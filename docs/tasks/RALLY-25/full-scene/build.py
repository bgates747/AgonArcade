"""Build a separate native full-scene derivative without changing R27 sources."""
from pathlib import Path
import argparse,hashlib,json,os,re,shutil,struct,subprocess,sys
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]
def sha(p):return hashlib.sha256(Path(p).read_bytes()).hexdigest()
def function(text,name):
    begin=text.index('void '+name+'(');at=text.index('{',begin);level=1;end=at+1
    while level:
        if text[end]=='{':level+=1
        elif text[end]=='}':level-=1
        end+=1
    return text[begin:end]+'\n'
def build(package,frames):
    package=Path(package).resolve();out=HERE/'.work'/('fixture-'+str(frames));work=HERE/'.work/build';(work/'src').mkdir(parents=True,exist_ok=True);(work/'include').mkdir(exist_ok=True);out.mkdir(parents=True,exist_ok=True)
    delivery=json.loads((package/'delivery-manifest.json').read_text())
    assert delivery['source_sha256']==sha(HERE/'full-scene.golem'),'Package does not match full-scene source'
    iface=json.loads((package/'interface.json').read_text());backend=json.loads((package/'backends.json').read_text())
    fields={g['name']:g for g in iface['globals']};entries={e['name']:e['logical_id'] for e in iface['entries']}
    constants=dict(Root=iface['state_buffer'],Args=backend['native_arguments'],Staging=50305,Completion=50304,
        Init=entries['InitRace'],Tick=entries['Tick120'],Render=entries['Render30'],Stop=entries['StopRace'],
        TickWrapper=backend['native_wrappers'][entries['Tick120']],HandleOffset=backend['native_handle_offset'],
        PlayerStation=fields['playerStation']['offset'],PlayerLateral=fields['playerLateral']['offset'],RenderPhase=fields['renderPhase']['offset'],
        ModuleBytes=(package/'rally-render.vdpl').stat().st_size,FrameCount=frames,WrapperCount=len(backend['native_wrappers']))
    buffers=[dict(id=iface['state_buffer'],offset=0,bytes=iface['state_bytes'])]+[dict(id=a['buffer'],offset=a['offset'],bytes=a['bytes']) for a in iface['arrays'] if a['access']==3]
    constants['StateBytes']=sum(b['bytes'] for b in buffers)
    header='#pragma once\n#include <stdint.h>\nnamespace fs {\n'+''.join(f'constexpr uint32_t {n}={v};\n' for n,v in constants.items())
    header+='constexpr uint16_t Wrappers[]={'+','.join(map(str,backend['native_wrappers']))+'};\nconstexpr uint16_t Outputs[]={50301,50302,50303};\nstruct Buffer {uint16_t id,offset,bytes;};\nconstexpr Buffer Buffers[]={'+','.join('{'+','.join(str(b[n]) for n in ('id','offset','bytes'))+'}' for b in buffers)+'};\n}\n'
    (work/'include/bindings.hpp').write_text(header);shutil.copyfile(HERE/'native.hpp',work/'include/native.hpp')
    source=(ROOT/'rally-game/src/main.cpp').read_text();prefix=source[:source.index('void trafficMatrix(')]
    prefix=prefix.replace('namespace {','#include "native.hpp"\n#include "player.hpp"\nnamespace {',1)
    for line in ('rally::DirectRoad road;','rally::Traffic traffic;','[[maybe_unused]] rally::DemoDriver demoDriver;','RaceTraffic raceTraffic;','Crash crash;','Billboards billboards;'):
        prefix=prefix.replace(line,'')
    prefix=prefix.replace('if(n)mos_puts((char*)p,n,0);','fs::send(p,n);')
    functions=''.join(function(source,n) for n in ('loadScenery','loadSigns','drawScenery','clockText','drawHud','drawPanel','bottom','loadCars'))
    functions=functions.replace('if(scene.skyDelta) {','if(scene.skyDelta) {++fs::scrollCalls;').replace('if(scene.skyRepaint) {','if(scene.skyRepaint) {++fs::repaintCalls;')
    (work/'src/main.cpp').write_text(prefix+functions+(HERE/'main_tail.cpp').read_text())
    shutil.copyfile(HERE/'player.hpp',work/'include/player.hpp');
    shutil.copyfile(HERE/'callback.asm',work/'src/callback.asm');shutil.copyfile(ROOT/'rally-game/src/timing_prt.asm',work/'src/timing_prt.asm')
    make='NAME=probe\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\ninclude /Agon/agondev/release/config/makefile.inc\nCFLAGS += -I'+str(ROOT/'rally-game/include')+' -I'+str(ROOT/'rally-production/include')+'\nCXXFLAGS += -std=c++17 -fno-exceptions -fno-rtti -Wall -Wextra -Werror -Wno-unused-function -Wno-unused-variable\n'
    (work/'Makefile').write_text(make);env=dict(os.environ,PATH='/Agon/agondev/release/bin:'+os.environ['PATH'])
    subprocess.run(['make','-C',str(work)],env=env,check=True)
    mapping=(work/'bin/probe.map').read_text()
    for name in ('init_array','ctors','dtors','fini_array'):
        match=re.search(r'^\.'+name+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M);assert match and int(match[1],16)==0,name
    # Import by explicit file identity; this script also has the name build.py.
    import importlib.util
    spec=importlib.util.spec_from_file_location('native_wire',HERE.parent/'native-demo/build.py');wire=importlib.util.module_from_spec(spec);spec.loader.exec_module(wire)
    asset=ROOT/'docs/tasks/RALLY-25/.work/renderer-helper/fuji.r24';assert asset.exists()
    for dest,data in [('assets.vdu',wire.write(50300,asset.read_bytes())),('module.vdu',wire.write(50305,(package/'rally-render.vdpl').read_bytes())),('common.vdu',(package/'common-install.bin').read_bytes()),('native.vdu',(package/'native-install.bin').read_bytes())]:
        (out/dest).write_bytes(data)
    shutil.copyfile(work/'bin/probe.bin',out/'probe.bin');shutil.copyfile(work/'bin/probe.map',out/'probe.map')
    meta=dict(schema=1,frames=frames,physics_ticks=frames*4,warm_frames=2,paced=False,mos_tick_hz=120,buffers=buffers,interface=iface,
        source_sha256=sha(HERE/'full-scene.golem'),module_sha256=sha(package/'rally-render.vdpl'),package=str(package),
        ownership=dict(ez80='centerline player/input/rules/scenery/HUD/audio/control',vdp='opponent simulation/contact/native geometry and drawing'),
        reference_sources={str(p.relative_to(ROOT)):sha(p) for p in [ROOT/'rally-game/src/main.cpp',ROOT/'rally-game/include/timing_fixture.hpp',ROOT/'rally-game/src/timing_prt.asm',*sorted((ROOT/'rally-game/include').glob('*.hpp')),*sorted((ROOT/'rally-production/include').glob('*.hpp'))]},
        files={p.name:sha(p) for p in out.iterdir() if p.is_file() and p.name not in ('expected.json',)})
    (out/'expected.json').write_text(json.dumps(meta,indent=2)+'\n');print(out)
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--package',required=True);p.add_argument('--frames',type=int,default=900);a=p.parse_args();assert 1<=a.frames<=900;build(a.package,a.frames)
