"""Prepare/build one common synchronous guest with explicit startup admission."""
from pathlib import Path
import hashlib
import json
import os
import shutil
import struct
import subprocess

HERE = Path(__file__).resolve().parent
HUD = HERE.parent / 'incremental/hud-format'
ROOT = HERE.parents[4]


def main():
    guest = HERE / 'guest'
    shutil.copytree(HUD / 'guest', guest, dirs_exist_ok=True)
    # Remove inherited binary products: this source has its own new identity.
    for name in ('probe.bin', 'probe.map', 'probe.s'):
        (guest / name).unlink(missing_ok=True)
    header = guest / 'include/native.hpp'
    text = header.read_text()
    old = '''    mos_setkbvector(fs_callback,0);installed=true;
    if(!config()||!file("module.vdu"))return false;'''
    new = '''    if(!config())return false;
    // Receive the original mode reply before taking private callback ownership.
    mos_clearvdpflags(vdp_pflag_mode);
    const uint8_t mode[]={22,136};send(mode,sizeof mode);
    uint8_t mode_status=15;
    for(unsigned attempt=0;attempt<3 && mode_status==15;++attempt)
        mode_status=mos_waitforvdpflags(vdp_pflag_mode);
    auto *screen=(volatile SYSVAR *)mos_sysvars();
    if(mode_status || screen->scrMode!=136 || screen->scrWidth!=320 || screen->scrHeight!=240){fail("Mode reply/admission");return false;}
    mos_setkbvector(fs_callback,0);installed=true;
    uint8_t caps[2]={1,0};
    if((transaction(4,caps,2,4)&273)!=273){fail("Rows capability admission");return false;}
    if(!file("module.vdu"))return false;'''
    assert text.count(old) == 1
    text = text.replace(old, new)
    old = '''    // Admit executable memory before mode136 fragments internal RAM, matching
    // the qualified early-LOAD startup used by both historical sampler cases.
    if(vdp_mode(136)<0){fail("Video mode");return false;}'''
    assert text.count(old) == 1
    text = text.replace(old, '    // Both new arms use the admitted display and same reduced-size module policy.')
    header.write_text(text)
    make = '''NAME=probe
LDHAS_ARG_PROCESSING=0
LDHAS_EXIT_HANDLER=0
include /Agon/agondev/release/config/makefile.inc
CFLAGS += -I{game} -I{production}
CXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -Wno-unused-function -Wno-unused-variable -Wno-misleading-indentation
'''.format(game=ROOT/'rally-game/include', production=ROOT/'rally-production/include')
    (guest / 'Makefile').write_text(make)
    env = dict(os.environ, PATH='/Agon/agondev/release/bin:' + os.environ['PATH'])
    run = subprocess.run(['make', '-C', str(guest), '-j1'], env=env,
                         text=True, capture_output=True, timeout=180)
    (HERE / 'GUEST-BUILD.txt').write_text(run.stdout + run.stderr)
    if run.returncode:
        raise SystemExit(run.returncode)
    binary = (guest / 'bin/probe.bin').read_bytes()
    fixture_pins = {}
    for frames in (60, 900):
        for name in ('bitmap', 'rows'):
            directory = HERE / 'fixtures' / (name + str(frames))
            source = HUD / ('fixtures-smoke60' if frames == 60 else 'fixtures') / 'cached'
            shutil.copytree(source, directory, dirs_exist_ok=True)
            module = (HERE / 'build-r02' / name / 'rally-render.vdpl').read_bytes()
            prefix = b'\x17\0\xa0' + struct.pack('<H', 50305)
            (directory / 'module.vdu').write_bytes(prefix+b'\2'+prefix+b'\0'+struct.pack('<H', len(module))+module)
            (directory / 'config.bin').write_bytes(b'R28F'+struct.pack('<HHIHH', 1, frames, len(module), 1, 0))
            (directory / 'probe.bin').write_bytes(binary)
            meta = json.loads((source / 'expected.json').read_text())
            meta.update(renderer=name, module_sha256=hashlib.sha256(module).hexdigest(),
                        module_bytes=len(module), startup_capability_query=True,
                        mode_receive_fenced=True, synchronous_uart=True)
            meta['files'] = {p.name:hashlib.sha256(p.read_bytes()).hexdigest()
                             for p in directory.iterdir() if p.name != 'expected.json'}
            (directory / 'expected.json').write_text(json.dumps(meta, indent=2)+'\n')
            fixture_pins[name+str(frames)] = {p.name:hashlib.sha256(p.read_bytes()).hexdigest()
                                            for p in directory.iterdir()}
    (HERE / 'FIXTURES.json').write_text(json.dumps(fixture_pins, indent=2)+'\n')
    print('Common guest', hashlib.sha256(binary).hexdigest(), 'bytes', len(binary))


if __name__ == '__main__':
    main()
