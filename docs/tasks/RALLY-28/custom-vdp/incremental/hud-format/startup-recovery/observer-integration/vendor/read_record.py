#!/usr/bin/env python3
"""Bounded, device-free FX-114 r02 JSONL reader. No runtime imports or control. MIT."""
import argparse
import json
from pathlib import Path

LIMIT = 65536
SCHEMA = 'fx114-sender-v1'
META = dict(schema=SCHEMA, event='metadata', stall_ms=50000, poll_ms=100,
            sample_offsets_ms=[0, 250, 500], max_lifetime_ms=630000, reader_attempts=4)
FIELDS = {'schema', 'event', 'reason', 'elapsed_ns', 'samples', 'sender',
          'vdp_cycles', 'vdp_frames', 'vdp_failed'}
SENDER = {'publication', 'phase', 'cts_result', 'completed_sends', 'batches', 'ez80_cycles', 'paused'}
PHASES = {'idle', 'entered_cts', 'returned_cts', 'entered_send', 'returned_send'}
REASONS = {'stasis_window_observed', 'interrupted_window', 'shutdown', 'reader_lifetime_limit'}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def uint(value):
    return type(value) is int and 0 <= value < 2**64


def unique(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, 'duplicate JSON key')
        result[key] = value
    return result


def analyze(raw):
    require(len(raw) <= LIMIT, 'record exceeds 64 KiB')
    lines = raw.decode('utf-8').splitlines()
    require(1 <= len(lines) <= 5, 'expected 1..5 nonempty JSONL records')
    rows = [json.loads(line, object_pairs_hook=unique) for line in lines]
    require(rows[0] == META and all(type(rows[0][k]) is type(v) for k, v in META.items()), 'r02 metadata mismatch')
    samples = []
    final = None
    elapsed = 0
    for row in rows[1:]:
        require(type(row) is dict and set(row) == FIELDS, 'record fields mismatch')
        require(row['schema'] == SCHEMA, 'schema mismatch')
        require(final is None, 'record after final')
        require(uint(row['elapsed_ns']) and row['elapsed_ns'] >= elapsed, 'invalid elapsed time')
        elapsed = row['elapsed_ns']
        require(uint(row['vdp_cycles']) and uint(row['vdp_frames']) and type(row['vdp_failed']) is bool, 'invalid VDP atomics')
        s = row['sender']
        if s is not None:
            require(type(s) is dict and set(s) == SENDER, 'sender fields mismatch')
            require(all(uint(s[k]) for k in ('publication', 'completed_sends', 'batches', 'ez80_cycles')), 'invalid sender counters')
            require(s['publication'] % 2 == 0 and s['phase'] in PHASES and type(s['paused']) is bool, 'invalid publication/phase/paused')
            require(s['cts_result'] is None or type(s['cts_result']) is bool, 'invalid CTS result')
            require((type(s['cts_result']) is bool) == (s['phase'] == 'returned_cts'), 'CTS result/phase mismatch')
        require(uint(row['samples']), 'invalid sample count')
        if row['event'] == 'sample':
            require(row['reason'] == 'no_completed_send_progress' and row['samples'] == len(samples)+1 and len(samples) < 3, 'invalid sample ordering')
            require(elapsed >= 50000 * 1000000, 'sample before stasis trigger')
            samples.append(row)
        else:
            require(row['event'] == 'final' and row['reason'] in REASONS and row['samples'] == len(samples), 'invalid final record')
            require((row['reason'] == 'stasis_window_observed') == (len(samples) == 3), 'final/sample completeness mismatch')
            require(row['reason'] != 'interrupted_window' or len(samples) < 3, 'invalid interruption')
            require(row['reason'] not in {'shutdown', 'reader_lifetime_limit'} or not samples, 'unexpected samples before shutdown/lifetime final')
            final = row
    # 100ms scheduling slack is an OFFLINE admission policy, never a target timeout.
    timely = len(samples) == 3 and all(
        offset*1000000 <= row['elapsed_ns']-samples[0]['elapsed_ns'] <= (offset+100)*1000000
        for row, offset in zip(samples, (0, 250, 500))) and all(row['elapsed_ns'] < 630000*1000000 for row in samples)
    available = len(samples) == 3 and all(row['sender'] is not None for row in samples)
    complete = bool(final and final['reason'] == 'stasis_window_observed' and timely)
    unchanged = (len({row['sender']['completed_sends'] for row in samples}) == 1) if available else None
    return dict(schema_valid=True, finalized=final is not None, sample_count=len(samples),
                final_reason=final['reason'] if final else None, window_complete=complete,
                sample_timing_within_100ms=bool(timely), all_sample_senders_available=available,
                completed_sends_unchanged=unchanged,
                diagnosis='none: no CTS/FIFO/IRQ/PC or causal inference')


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('record', type=Path)
    args = parser.parse_args()
    try:
        with args.record.open('rb') as stream:
            result = analyze(stream.read(LIMIT+1))
    except (ValueError, UnicodeError, OSError, TypeError, KeyError) as error:
        print(json.dumps(dict(schema_valid=False, error=str(error))))
        return 2
    print(json.dumps(result, indent=2))
    return 0 if result['finalized'] else 1


if __name__ == '__main__':
    raise SystemExit(main())
