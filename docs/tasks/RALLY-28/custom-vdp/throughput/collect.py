"""Collect stopped-profile evidence without modifying fixture inputs or old runs."""
import argparse
import json
from pathlib import Path
import shutil
from fixtures import HERE, sha
from oryx_session import owned_processes


def collect(campaigns):
    selected = {}
    for campaign in campaigns:
        assert campaign.isalnum()
        selected[campaign] = json.loads((HERE / ('PROFILES-' + campaign + '.json')).read_text())
    paths = {Path(item['profile']).resolve() for entries in selected.values() for item in entries.values()}
    assert not owned_processes(paths), 'Collect after all selected emulators stop'
    report = {}
    for campaign, entries in selected.items():
        for name, item in entries.items():
            profile = Path(item['profile'])
            assert all(sha(profile / n) == h for n, h in item['input_sha256'].items()), name
            if not (profile / 'last-run').exists():
                report[campaign + '/' + name] = dict(started=False, input_hashes_preserved=True)
                continue
            target = HERE / 'evidence' / campaign / name
            target.mkdir(parents=True, exist_ok=True)
            files = {}
            for stem in ('replies', 'ticks', 'prt', 'clock', 'failure'):
                source = profile / 'sdcard/rally25' / (stem + '.log')
                if source.exists():
                    files[stem + '.bin'] = source
            for source in (profile / 'last-run').iterdir():
                if source.is_file():
                    key = source.with_suffix('.txt').name if source.suffix == '.log' else source.name
                    files[key] = source
            for source_name in ('verified.json', 'phase-verified.json'):
                source = profile / 'sdcard/rally25' / source_name
                if source.exists():
                    key = 'guest-' + source_name if source_name in files else source_name
                    files[key] = source
            hashes = {}
            for filename, source in files.items():
                destination = target / filename
                digest = sha(source)
                if destination.exists():
                    assert sha(destination) == digest, 'Preserve existing differing evidence: ' + str(destination)
                else:
                    shutil.copyfile(source, destination)
                assert sha(destination) == digest
                hashes[filename] = digest
            report[campaign + '/' + name] = dict(started=True, input_hashes_preserved=True,
                files=hashes, profile=str(profile), evidence=str(target.relative_to(HERE)))
    (HERE / 'COLLECTED.json').write_text(json.dumps(report, indent=2) + '\n')
    print('Collected', sum(v['started'] for v in report.values()), 'stopped runs;',
          sum(not v['started'] for v in report.values()), 'not started; all input hashes preserved')


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('campaigns', nargs='+')
    collect(parser.parse_args().campaigns)
