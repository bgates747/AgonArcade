"""Select the preserved forward run and resumed reverse tail without copying runs.

Run only after all five finish-case receipts have returned. This helper creates
metadata; the independent raw audit qualifies the selected original evidence.
"""
from pathlib import Path
import argparse
import hashlib
import json

HERE = Path(__file__).resolve().parent


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def load(name):
    assert Path(name).name == name and not (HERE / name).is_symlink()
    return json.loads((HERE / name).read_text())


def create(output='COMPARISON-SELECTION.json'):
    assert Path(output).name == output and output.endswith('.json')
    destination = HERE / output
    assert not destination.exists(), 'Preserve the existing comparison selection'
    order = load('VARIANTS.json')['order']
    assert len(order) == len(set(order)) == 17
    reverse = list(reversed(order))
    forward = [dict(campaign='raceab03', case=case) for case in order]
    backward = [dict(campaign='raceba03' if index < 12 else 'racefinish01', case=case)
                for index, case in enumerate(reverse)]
    groups = {'raceab03': order, 'raceba03': reverse[:12], 'racefinish01': reverse[12:]}
    sessions = {'raceab03': 'racefullsession02', 'raceba03': 'racefullsession02',
                'racefinish01': 'racefinishsession01'}
    names = {'VARIANTS.json', 'FIXTURES.json', 'GUEST-BUILD.json'}
    for campaign, cases in groups.items():
        campaign_name, profiles_name, attempts_name = (
            prefix + campaign + '.json' for prefix in ('CAMPAIGN-', 'PROFILES-', 'ATTEMPTS-'))
        receipt, profiles, attempts = load(campaign_name), load(profiles_name), load(attempts_name)
        assert list(receipt) == cases and set(cases) <= set(profiles)
        assert all(receipt[case]['passed'] and receipt[case]['input_hashes_preserved']
                   and receipt[case]['boost_after'] == '0' for case in cases)
        assert list(attempts['selected']) == cases
        names.update((campaign_name, profiles_name, attempts_name, attempts['initial_profiles_receipt']))
        names.update(entry['profiles_receipt'] for rows in attempts['attempts'].values() for entry in rows)
    for session in dict.fromkeys(sessions.values()):
        names.update(('SESSION-' + session + '.json', 'RETRY-SESSION-' + session + '.json'))
    pins = {}
    for name in sorted(names):
        load(name)
        pins[name] = sha(HERE / name)
    selection = dict(schema=1, forward=forward, reverse=backward,
        source_sessions=sessions, source_receipts=pins,
        original_campaigns_and_raw_evidence_unmodified=True,
        reason='Preserve seventeen forward and twelve completed reverse cases before the external boost-change abort; finish only the five untouched reverse cases in a fresh guarded session.',
        interrupted_attempt_excluded=dict(campaign='raceba03', case=reverse[12],
                                         reason='Session guard abort after external boost change; no complete result'),
        builder=dict(source='selection.py', sha256=sha(Path(__file__))))
    destination.write_text(json.dumps(selection, indent=2) + '\n')
    print(json.dumps(dict(path=output, sha256=sha(destination), selected_runs=34,
                         pinned_original_receipts=len(pins)), indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', default='COMPARISON-SELECTION.json')
    create(parser.parse_args().output)
