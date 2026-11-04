"""Finite, read-only source/installation audit; never executes a VDU stream."""
from pathlib import Path
import hashlib
import json
import re
import struct

HERE = Path(__file__).resolve().parent
PROJECT = HERE.parents[4]
DIRECT = HERE.parent / 'direct-rows'
RUNTIME = Path('/Agon/mystuff/agon-vdplet/build/vdpl018-wolf-rows-r01/firmware-src/video')


def installation(path, bitmap_commands=False):
    """Decode only CLEAR/WRITE and known bitmap registration records, no CALLs."""
    data = path.read_bytes()
    at = 0
    images, registrations = {}, []
    while at < len(data):
        if data[at:at+3] == b'\x17\0\xa0':
            buffer, op = struct.unpack_from('<HB', data, at+3)
            at += 6
            if op == 2:
                images.pop(buffer, None)
            elif op == 0:
                n = struct.unpack_from('<H', data, at)[0]
                at += 2
                assert at+n <= len(data)
                images[buffer] = images.get(buffer, b'') + data[at:at+n]
                at += n
            else:
                raise ValueError(('unsupported buffered installation command', at, op))
        elif bitmap_commands and data[at:at+3] == bytes([23, 27, 32]):
            registrations.append({'at': at, 'select_bitmap': struct.unpack_from('<H', data, at+3)[0]})
            at += 5
        elif bitmap_commands and data[at:at+3] == bytes([23, 27, 33]):
            width, height, fmt = struct.unpack_from('<HHB', data, at+3)
            registrations.append({'at': at, 'from_buffer': [width, height, fmt]})
            at += 8
        else:
            raise ValueError(('unsupported installation prefix', at, data[at:at+12].hex()))
    return images, registrations


def main():
    source = DIRECT / 'source/rows'
    common, _ = installation(DIRECT / 'fixtures/rows900/common.vdu')
    native, registrations = installation(DIRECT / 'fixtures/rows900/native.vdu', True)
    text = (source / 'checked.c').read_text()
    prefix = text[text.index('int32_t vdplet_entry'):text.index('case 3:{')]
    tick = text[text.index('case 3:{'):text.index('case 13:{')]
    init = text[text.index('case 13:{'):text.index('case 15:{')]
    checks = [int(x) for x in re.search(r'offsets\[\].*?=\{([^}]+)', text)[1].split(',') if x]
    iface = json.loads((source / 'interface.json').read_text())
    wrappers = []
    for entry in range(17):
        buffer = 10+entry
        value = native[buffer]
        assert len(value) == 43
        assert value[:13] == bytes([23, 0, 160])+struct.pack('<H', 50304)+bytes([5, 194])+struct.pack('<HHH', 44, 2, 0)
        assert value[13:26] == bytes([23, 0, 160])+struct.pack('<H', 1)+bytes([5, 194])+struct.pack('<HHH', 28, 2, entry)
        assert value[26:37] == bytes([23, 0, 216, 12, 0, 1, 2, 0, 0, 0, 0])
        assert struct.unpack_from('<HHH', value, 37) == (0, entry, 9)
        wrappers.append({'buffer': buffer, 'entry': entry, 'bytes': len(value),
                         'behavior': ['SET16 completion.ready=0', 'SET16 root.requested_entry=entry',
                                      'native RUN flags=0 token=0 handle=patched entry=entry args=9']})
    summary = {
        'method': 'Static source and restricted installation decoding; no native/VDU execution or timing.',
        'prefix_acquire_sites': prefix.count('h->buffer_acquire('),
        'tick_acquire_sites': tick.count('h->buffer_acquire('),
        'init_acquire_sites': init.count('h->buffer_acquire('),
        'root_constant_byte_checks_per_run': len(checks),
        'root_bytes': len(common[1]),
        'mutable_array_bytes': sum(len(common[i]) for i in range(2, 7)),
        'immutable_route_sine_bytes': len(common[7])+len(common[8]),
        'native_wrappers': wrappers,
        'native_install_allocations': {str(i): len(data) for i, data in native.items()},
        'bitmap_registrations': registrations,
        'globals': iface['globals'],
        'arrays': iface['arrays'],
        'common_allocations': {str(i): {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}
                               for i, data in common.items()},
        'tick_path_formula': {
            'N': 'active opponents, 0..6', 'C': 'contact-true opponents, 0..N',
            'B': 'route record transition, 0 or 1', 'I': 'sine interpolation branch, 0 or 1',
            'acquire_release_pairs': '24 + 7*N + C + 2*B + I',
            'all_six_active_range': [66, 75]},
        'render_success_pairs_formula': '30 + 2*S, S=sampled actors, 0..8; row services excluded',
        'five_run_frame_pairs_range_all_active': [294, 346],
        'count_limit': 'Manual successful-path formulas, not dynamic trace or timing; acquire and release each count once per pair.',
        'native_state_raw_budget_example': {'current_data_rodata_bss': 1004,
                                           'add_complete_legacy_root_arrays_tables': 968,
                                           'raw_sum_before_new_alignment_or_metadata': 1972,
                                           'declared_limit': 4096},
    }
    (HERE / 'STATIC-INVENTORY.json').write_text(json.dumps(summary, indent=2)+'\n')
    paths = list((DIRECT / 'source/rows').rglob('*'))
    paths += list((DIRECT / 'guest').glob('include/*.hpp'))
    paths += [DIRECT / 'guest/src/main.cpp', DIRECT / 'guest/include/presentation-functions.inc',
              DIRECT / 'fixtures/rows900/common.vdu', DIRECT / 'fixtures/rows900/native.vdu',
              DIRECT / 'build-r02/rows/rally-render.json', DIRECT / 'SOURCE.json', DIRECT / 'REPORT.json',
              DIRECT / 'RESULTS.md', DIRECT / 'SHARED-COST-NOTES.md', DIRECT / 'SDK.json',
              DIRECT / 'coordination/VDPLET-GUIDANCE01.md',
              DIRECT / 'sdk/include/vdplet.h', DIRECT / 'sdk/include/vdplet_services.h',
              PROJECT / 'docs/tasks/RALLY-24/REVIEW.md', PROJECT / 'docs/tasks/RALLY-24/DESIGN.md',
              PROJECT / 'docs/tasks/RALLY-25/generated-state/README.md',
              PROJECT / 'docs/tasks/RALLY-25/generated-state/adapter.py',
              PROJECT / 'docs/tasks/RALLY-25/native-demo/demo.golem',
              PROJECT / 'docs/tasks/RALLY-25/native-demo/build.py',
              PROJECT / 'rally-production/include/section_protocol.hpp',
              Path('/Agon/mystuff/agon-vdplet/docs/API-reference.md'),
              Path('/Agon/mystuff/agon-vdplet/docs/tasks/VDPL-024/RALLY-WOLF.md')]
    paths += [RUNTIME / name for name in ['vdplet_runtime.h', 'vdplet_image.h', 'vdplet_color_rows.h',
                                          'vdu_buffered.h', 'vdu_sys.h', 'buffer_stream.h', 'types.h']]
    files = {}
    for p in sorted(set(paths)):
        if not p.is_file():
            continue
        data = p.read_bytes()
        files[str(p.resolve())] = {'bytes': len(data), 'sha256': hashlib.sha256(data).hexdigest()}
    (HERE / 'SOURCE-PINS.json').write_text(json.dumps({'schema': 1, 'checkpoint': 'a77a42b',
        'scope': 'Read-only NAT-001 audit, current rows source plus selected historical/runtime inputs',
        'files': files}, indent=2)+'\n')
    print(json.dumps({'files_pinned': len(files), 'prefix_sites': summary['prefix_acquire_sites'],
                      'tick_sites': summary['tick_acquire_sites'], 'init_sites': summary['init_acquire_sites'],
                      'constant_checks': len(checks), 'wrapper_count': len(wrappers),
                      'install_allocations': summary['native_install_allocations']}))


if __name__ == '__main__':
    main()
