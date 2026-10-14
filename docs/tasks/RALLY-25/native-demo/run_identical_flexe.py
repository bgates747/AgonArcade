"""Run returned Console8 fixture bytes unchanged in a separate Flexe profile."""
from pathlib import Path
import argparse
import hashlib
import json
import shutil

from profile import prepare
from run_headless import run

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def compare(card, name, timeout):
    card = Path(card).resolve()
    deployment = json.loads((HERE / 'HARDWARE-DEPLOYMENT.json').read_text())
    hardware = json.loads((HERE / 'HARDWARE-RESULTS.json').read_text())
    hashes = deployment['source_files']
    assert json.loads((card / 'deployment.json').read_text()) == deployment
    assert {n: sha(card / n) for n in hashes} == hashes, 'Card input identity changed'
    profile = ROOT / '.emulator' / name
    fixture = HERE / '.work' / name
    assert not profile.exists() and not fixture.exists(), 'Preserve existing run; choose a new name'
    fixture.mkdir(parents=True)
    for n in hashes:
        shutil.copyfile(card / n, fixture / n)
    runtime = ROOT.parent / 'golem/docs/tasks/GOLEM-037/binding/build/runtime'
    for filename, expected in {
        'flexe-agon-emulator': '28f50e87190f00de4039dc90c94432347f01c4771c4ea4a5dea8595d6cef7670',
        'flexe-vdp.so': '200f28cbe399b1fdc60cba1e5fed4c2bb86042b5e92f6e422539a5388c079a30',
    }.items():
        assert sha(runtime / filename) == expected, 'Accepted Flexe runtime identity changed'
    elf = ROOT / '.emulator/rally25-native-demo/esp32-firmware.elf'
    assert sha(elf) == 'b41e4cb37bd44633d14b2e6eea615cbbbdd29a1d4b49c3258b4f49f2e215e567'
    profile = prepare(fixture, fixture / 'vdp_rally.bin', elf, name, runtime)
    # Use the physical card's MOS working directory. The alias is host-tool
    # compatibility only; the guest uses /test/arcade/rally on both platforms.
    app = profile / 'sdcard/test/arcade/rally'
    app.parent.mkdir(parents=True)
    (profile / 'sdcard/rally25').rename(app)
    (profile / 'sdcard/rally25').symlink_to('test/arcade/rally', target_is_directory=True)
    (profile / 'sdcard/autoexec.txt').write_bytes(
        b'SET KEYBOARD 1\r\ncd /test/arcade/rally\r\nload probe.bin\r\nrun .\r\n')
    identities = profile / '.runtime.sha256'
    paths = [line.split('  ', 1)[1] for line in identities.read_text().splitlines()]
    paths = [p.replace('sdcard/rally25/', 'sdcard/test/arcade/rally/') for p in paths]
    identities.write_text(''.join(sha(profile / p) + '  ' + p + '\n' for p in paths))
    assert {n: sha(app / n) for n in hashes} == hashes
    assert sha(profile / 'esp32-firmware.bin') == deployment['firmware_sha256']
    receipt = run(profile, timeout)
    result = receipt['result']
    assert result['final_buffers'] == hardware['final_buffers'], 'Final state differs from physical run'
    assert result['reply_sha256'] == hardware['reply_sha256'], 'Reply transcript differs'
    assert {n: sha(app / n) for n in hashes} == hashes, 'Emulator input bytes changed'
    result['scope'] = 'Flexe emulator identical unpaced Console8 fixture; nominal120 MOS units/s; includes checks/drawing/swap submission'
    result['platform'] = 'Flexe emulator on Oryx'
    result['prt']['clock_limit'] = 'Emulator instruction-clock PRT IRQ ticks; not calibrated wall-clock timing'
    (app / 'verified.json').write_text(json.dumps(result, indent=2) + '\n')
    (profile / 'last-run/run.json').write_text(json.dumps(receipt, indent=2) + '\n')
    comparison = dict(schema=1, byte_identical_inputs=True, input_sha256=hashes,
                      firmware_sha256=sha(profile / 'esp32-firmware.bin'),
                      physical_card_directory=deployment['card_path'],
                      mos_directory_on_both_platforms='/test/arcade/rally',
                      fixture_metadata_unchanged=True,
                      host_platform_label_overrides_preserved_hardware_metadata=True,
                      final_state_and_reply_transcript_identical=True,
                      frames=result['frames'], physics_ticks=result['physics_ticks'],
                      hardware_fps=hardware['observed_fps'], flexe_fps=result['observed_fps'],
                      hardware_seconds=hardware['elapsed_seconds'], flexe_seconds=result['elapsed_seconds'],
                      emulator_host_seconds_including_startup=receipt['host_seconds'],
                      flexe_runtime_identities=receipt['runtime_identities'],
                      limitations=['Aggregate fixture timing, not isolated VDP rendering time',
                                   'Emulator versus physical nominal clocks; PRT interpretation differs',
                                   'No autonomous120/30Hz scheduler',
                                   'Flashed hardware firmware not read back; supplied firmware identity matched'])
    (profile / 'last-run/comparison.json').write_text(json.dumps(comparison, indent=2) + '\n')
    print(json.dumps({k: comparison[k] for k in ('byte_identical_inputs', 'final_state_and_reply_transcript_identical', 'hardware_fps', 'flexe_fps')}, indent=2))


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--card', required=True)
    parser.add_argument('--name', default='rally25-native-hardware-identical')
    parser.add_argument('--timeout', type=float, default=180)
    args = parser.parse_args()
    compare(args.card, args.name, args.timeout)
