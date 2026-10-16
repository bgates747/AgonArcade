"""Author-authorized exact mainboard diagnostic installation; no test/startup/P4 writes.

Uses the bench's existing esptool CLI. Back up app0 and all boot metadata,
validate the actual OTA selector, change only app0, independently read back,
then perform the normal common mainboard hard reset.
"""
from pathlib import Path
import argparse
import datetime
import fcntl
import hashlib
import json
import struct
import subprocess
import zlib

HERE = Path(__file__).resolve().parent
IMAGE = HERE.parent / 'SPAN-001-08/firmware.bin'
EXPECTED = '36edc736c992502367489c8ccea677d7aebb11d20371cd58cb0b91ef61df9f99'
PORT = '/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0'
MAC = '10:06:1c:0b:46:e0'
TOOL = Path('/Agon/mystuff/agon-extender/.venv/bin/esptool')


def sha(data):
    return hashlib.sha256(data).hexdigest()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('--execute', action='store_true', required=True)
    parser.parse_args()
    image = IMAGE.read_bytes()
    assert sha(image) == EXPECTED and len(image) == 1085168
    assert Path(PORT).resolve(strict=True).name == 'ttyUSB0'
    stamp = datetime.datetime.now(datetime.timezone.utc).strftime('%Y%m%dT%H%M%SZ')
    work = HERE / '.work' / ('mainboard-flash-' + stamp)
    work.mkdir(parents=True, exist_ok=False)
    base = [str(TOOL), '--chip', 'esp32', '--port', PORT, '--baud', '460800']
    def run(name, args, device=True):
        print(name + ' ...', flush=True)
        with (work / (name + '.log')).open('x') as log:
            subprocess.run((base if device else [str(TOOL)]) + args,
                           stdout=log, stderr=subprocess.STDOUT, check=True, timeout=180)
        if device:
            assert MAC in (work / (name + '.log')).read_text(), 'Unexpected mainboard MAC'
        print(name + ' PASS', flush=True)
    with (HERE / '.work/mainboard-flash.lock').open('a') as lock:
        fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
        run('image-info', ['--chip', 'esp32', 'image-info', str(IMAGE)], False)
        before = work / 'before-prefix.bin'
        run('backup', ['--before', 'default-reset', '--after', 'no-reset',
                       'read-flash', '0', '0x150000', str(before)])
        data = before.read_bytes()
        assert len(data) == 0x150000
        parts = []
        for offset in range(0x8000, 0x9000, 32):
            magic, typ, subtype, start, size, label, flags = struct.unpack_from('<HBBII16sI', data, offset)
            if magic != 0x50aa:
                break
            parts.append(dict(type=typ, subtype=subtype, offset=start, bytes=size,
                              label=label.split(b'\0')[0].decode()))
        ota = next(p for p in parts if p['type'] == 1 and p['subtype'] == 0)
        entries = []
        for offset in (ota['offset'], ota['offset'] + 0x1000):
            seq = struct.unpack_from('<I', data, offset)[0]
            state, crc = struct.unpack_from('<II', data, offset + 24)
            valid = seq != 0xffffffff and state not in (3, 4) and crc == zlib.crc32(data[offset:offset+4], 0xffffffff)
            entries.append(dict(seq=seq, state=state, crc=crc, valid=valid))
        valid = [e for e in entries if e['valid']]
        assert valid, 'Unknown OTA selector; no write performed'
        selected = max(valid, key=lambda e: e['seq'])
        apps = sorted((p for p in parts if p['type'] == 0), key=lambda p: p['subtype'])
        app = apps[(selected['seq'] - 1) % len(apps)]
        assert app['offset'] == 0x10000 and app['label'] == 'app0' and app['bytes'] == 0x140000
        assert len(image) <= app['bytes']
        inspection = dict(partitions=parts, ota_entries=entries, selected_app=app,
                          backup_sha256=sha(data), incoming_app_prefix_sha256=sha(data[0x10000:0x10000+len(image)]))
        (work / 'inspection.json').write_text(json.dumps(inspection, indent=2) + '\n')
        run('write', ['--before', 'no-reset', '--after', 'no-reset', 'write-flash',
                      '--flash-mode', 'keep', '--flash-freq', 'keep', '--flash-size', 'keep',
                      '0x10000', str(IMAGE)])
        run('verify', ['--before', 'no-reset', '--after', 'no-reset', 'verify-flash', '0x10000', str(IMAGE)])
        after = work / 'after-prefix.bin'
        run('readback', ['--before', 'no-reset', '--after', 'no-reset', 'read-flash', '0', '0x150000', str(after)])
        observed = after.read_bytes()
        assert observed[:0x10000] == data[:0x10000], 'Bootloader/partitions/NVS/OTA changed'
        assert observed[0x10000:0x10000+len(image)] == image, 'Application readback mismatch'
        erase_end = (0x10000 + len(image) + 4095) & ~4095
        assert observed[erase_end:] == data[erase_end:], 'Unwritten application tail changed'
        run('normal-boot-reset', ['--before', 'no-reset', '--after', 'hard-reset', 'chip-id'])
        receipt = dict(status='flashed-independently-readback-verified-and-reset', utc=stamp,
                       mainboard_mac=MAC, port=PORT, tool=str(TOOL), tool_version='5.1.0',
                       image=str(IMAGE), image_sha256=EXPECTED, image_bytes=len(image),
                       offset='0x10000', selected_app=app, ota_entries=entries,
                       bootloader_partition_nvs_ota_unchanged=True, unwritten_tail_unchanged=True,
                       backup=str(before), backup_sha256=sha(data), readback_sha256=sha(observed),
                       normal_common_reset=True, p4_flashed=False, emos_changed=False,
                       startup_written=False, tests_invoked=False, cli_execution_verified=False,
                       evidence=str(work))
        (HERE / 'MAINBOARD-FLASH.json').write_text(json.dumps(receipt, indent=2) + '\n')
        print(json.dumps(receipt, indent=2), flush=True)


if __name__ == '__main__':
    main()
