"""Check guest race/state/clock results independently of renderer timing."""
from pathlib import Path
import argparse
import csv
import hashlib
import json
import struct

HERE = Path(__file__).resolve().parent
sha = lambda b: hashlib.sha256(b).hexdigest()


def verify(directory):
    directory = Path(directory)
    meta = json.loads((directory/'expected.json').read_text())
    r = json.loads((directory/'result.json').read_text())
    assert not (directory/'failure.txt').exists()
    frames = meta['frames']
    assert r['valid'] and r['race_view'] and not r['damage_enabled']
    assert r['frames'] == frames and r['physics_ticks'] == 4*frames
    assert r['warm_frames'] == 2 and r['request'] == frames+2
    assert r['generation'] == 5*frames+3
    assert all(r[k] for k in ('timer_restored', 'unloaded', 'post_swap_fenced', 'clean_text_exit'))
    reference = json.loads((HERE/f'EXPECTED-FINAL-{frames}.json').read_text())
    buffers = meta['state_buffers']
    expected = b''.join(bytes.fromhex(reference[str(b['id'])]) for b in buffers)
    state = (directory/'state.bin').read_bytes()
    assert state == expected, 'Final root/arrays differ from generated-C/independent model'
    root = bytes.fromhex(reference['1'])
    interface = meta['interface']
    def field(name):
        f = next(x for x in interface['globals'] if x['name'] == name)
        return int.from_bytes(root[f['offset']:f['offset']+f['bytes']], 'little', signed=f['type'].startswith('sint'))
    player = list(csv.DictReader((directory/'player.csv').read_text().splitlines()))
    assert len(player) == 1
    p = player[0]
    for key, value in dict(station=field('playerStation'), phase=field('renderPhase'), lateral=0, steering=0, rules_ticks=4*frames).items():
        assert int(p[key]) == value, (key, p[key], value)
    assert int(p['remaining']) > 0 and int(p['score']) > 0 and 1 <= int(p['rank']) <= 7
    assert r['footer_calls'] == frames and r['input_polls'] == frames
    assert r['hud_bytes'] > 0 and r['sky_repair_calls'] > 0
    if frames == 900:
        assert r['scroll_calls'] > 0 and r['repaint_calls'] > 0 and r['audio_changes'] > 0
        assert r['finish_frames'] > 0
    samples = []
    for name in ('ticks.bin', 'prt.bin'):
        data = (directory/name).read_bytes()
        assert len(data) == 4*(frames+1)
        samples.append(struct.unpack('<'+'I'*(frames+1), data))
    mos, prt = samples
    mt, pt = (mos[-1]-mos[0])&0xffffff, (prt[-1]-prt[0])&0xffffff
    assert mt == r['elapsed_mos_ticks'] and pt == r['prt_ticks'] and mt > 0 and pt > 0
    transcript = (directory/'replies.bin').read_bytes()
    assert len(transcript) == r['transcript_bytes'] == 10*r['retained_replies']
    coverage = meta.get('coverage', False)
    extra = 3 + 272*6 if coverage else 0
    assert r['retained_replies'] == 6*frames+224+extra and len(transcript) <= 100000
    if coverage:
        assert json.loads((directory/'coverage.json').read_text()) == meta['expected_coverage']
    replies = list(struct.iter_unpack('<4sBBHH', transcript))
    for token, (magic, version, kind, actual, value) in enumerate(replies, 1):
        assert (magic, version, actual) == (b'VDPL', 1, token)
        assert kind in (2, 3, 4)
        if kind == 3:
            assert value == 0
    assert replies[0][2] == 2 and replies[0][4] > 0
    for frame in range(1, frames+1):
        group = replies[18+(frame-1)*6:18+frame*6]
        wanted = [(3, 0), (4, 1), (4, frame+2), (4, 4*frame), (4, 5*frame+3), (4, 5*frame+3)]
        assert [(x[2], x[4]) for x in group] == wanted, ('frame replies', frame, group)
    result = dict(frames=frames, physics_ticks=4*frames, final_state_exact=True,
                  state_sha256=sha(state), nominal_mos_ticks=mt, nominal_mos_seconds=mt/120,
                  nominal_mos_fps=frames*120/mt, nominal_prt_ticks=pt,
                  nominal_prt_seconds=pt/1000, nominal_prt_fps=frames*1000/pt,
                  retained_replies=len(replies), every_frame_completion_and_post_swap_checked=True,
                  timer_restored=True, unloaded=True, race_view=True,
                  presentation_counters={k:r[k] for k in ('scroll_calls','repaint_calls','sky_repair_calls','hud_bytes','footer_calls','audio_changes','finish_frames','input_polls')},
                  player_race_state=p, timed_wire_bytes=r['timed_wire_bytes'],
                  zero_mos_intervals=[i for i in range(1,frames+1) if mos[i]==mos[i-1]],
                  stack_before=r['stack_before'], stack_after=r['stack_after'],
                  timing_excluded=bool(meta.get('timing_excluded', False)),
                  effect_coverage_verified=bool(coverage),
                  clock_limit='Nominal MOS120units/s and nominal PRT18.432MHz emulated instruction clock; no physical FPS/scanout claim',
                  raw_file_sha256={n:sha((directory/n).read_bytes()) for n in ('result.json','state.bin','player.csv','ticks.bin','prt.bin','replies.bin','stages.csv')})
    (directory/'verified.json').write_text(json.dumps(result, indent=2)+'\n')
    return result


if __name__ == '__main__':
    p=argparse.ArgumentParser();p.add_argument('directory');a=p.parse_args()
    print(json.dumps(verify(a.directory), indent=2))
