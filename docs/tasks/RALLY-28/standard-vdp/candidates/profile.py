"""Prepare a fresh stopped stock Flexe candidate; never launch a window/audio."""
from pathlib import Path
import argparse,hashlib,importlib.util,json,os,shutil
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4];PROBE=HERE.parent/'completion-probe'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()
def prepare(name,variant,mode,adapter="baseline",engine="jit"):
    assert engine in ("jit","interp")
    assert adapter in ("baseline","eof-fixed")
    assert name.startswith('rally28-') and Path(name).name==name and mode in (0,1,2)
    assert variant in ('dense','lookup','lookup-buffer','coarse','coarse-buffer')
    assert not (variant=='dense' and mode==2),'The diagnostic physics service is qualified only for the shared candidates'
    spec=importlib.util.spec_from_file_location('probe_profile',PROBE/'profile.py');module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    runtime=HERE/'.work/runtime';runtime.mkdir(parents=True,exist_ok=True);frozen=ROOT/'.emulator/rally28-completion-poll02'
    shutil.copyfile(frozen/'flexe-agon-emulator.bin',runtime/'flexe-agon-emulator')
    # Consume the already-copied immutable delivery, not a peer's live build.
    adapter_source=frozen/'flexe-vdp.so' if adapter=='baseline' else ROOT/'.emulator/rally28-lookup-buffer-cpu08/flexe-vdp.so'
    shutil.copyfile(adapter_source,runtime/'flexe-vdp.so')
    assert sha(runtime/'flexe-agon-emulator')=='7e78e991a32c7bc94e84d70e8ad1792e3b840c48adc2e3aae7f635a88f4878ad'
    expected_adapter='200f28cbe399b1fdc60cba1e5fed4c2bb86042b5e92f6e422539a5388c079a30' if adapter=='baseline' else '108ec5b02122381e6c3ae851508188ec0a96240ca5f74be804fd2201b141e6e9'
    assert sha(runtime/'flexe-vdp.so')==expected_adapter
    profile=module.prepare(name,'key',HERE/'.work'/variant/'bin/candidate.bin',PROBE/'.work/stock-v2.16.0.bin',runtime,ROOT.parent/'golem/.emulator/runtime/fab-1.2.5')
    old=profile/'sdcard/test/arcade/rally28/key';app=old.with_name('candidate');old.rename(app);(app/'probe.bin').rename(app/'candidate.bin')
    (app/'mode.txt').write_text(str(mode)+'\n')
    if variant!='dense':shutil.copyfile(HERE/'.work/data/fuji.road',app/'fuji.road')
    autoexec=profile/'sdcard/autoexec.txt';autoexec.write_bytes(b'SET KEYBOARD 1\r\nCD /test/arcade/rally28/candidate\r\nLOAD candidate.bin\r\nRUN .\r\n')
    identity=json.loads((profile/'identity.json').read_text());identity['kind']='candidate';identity['variant']=variant;identity['mode']=mode;identity['adapter_delivery']=adapter;identity['engine']=engine;identity['adapter_publication']='bbd0343' if adapter=='eof-fixed' else 'preserved-completion-profile'
    identity['files'].pop('sdcard/test/arcade/rally28/key/probe.bin')
    launcher=profile/'flexe-agon-emulator'
    guard='# Refuse reused fixtures before guest timer/callback installation.\napp_dir="$profile_dir/sdcard/test/arcade/rally28/candidate"\nfor output in started.txt ended.txt summary.txt frames.csv state.csv done.txt; do\n    if [ -e "$app_dir/$output" ]; then\n        printf \'%s\\n\' \'This fixture has been run; prepare a fresh profile.\' >&2\n        exit 2\n    fi\ndone\nif [ -s "$profile_dir/last-run/mos-to-vdp.bin" ]; then\n    printf \'%s\\n\' \'This profile contains an earlier run; prepare a fresh profile.\' >&2\n    exit 2\nfi\nif [ "$(cat /sys/devices/system/cpu/cpufreq/boost)" != 0 ]; then\n    printf \'%s\\n\' \'This Oryx fixture requires CPU boost disabled.\' >&2\n    exit 2\nfi\n'
    launch=launcher.read_text().replace('export AGON_FLEXE_ENGINE=jit','export AGON_FLEXE_ENGINE='+engine)
    launch=launch.replace('export SDL_AUDIODRIVER=dummy',guard+'export SDL_AUDIODRIVER=dummy',1)
    launcher.write_text(launch);identity['files']['flexe-agon-emulator']=sha(launcher)
    for p in [autoexec,*sorted(app.iterdir())]:identity['files'][str(p.relative_to(profile))]=sha(p)
    (profile/'identity.json').write_text(json.dumps(identity,indent=2)+'\n');(profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in identity['files'].items()))
    # Flush only this profile, outside all timed work.
    for path in [*(profile/n for n in identity['files']),profile/'identity.json',profile/'.runtime.sha256']:
        with path.open('rb') as f:os.fsync(f.fileno())
    for path in [profile,profile/'sdcard',profile/'sdcard/test',profile/'sdcard/test/arcade',profile/'sdcard/test/arcade/rally28',app]:
        fd=os.open(path,os.O_RDONLY|os.O_DIRECTORY)
        try:os.fsync(fd)
        finally:os.close(fd)
if __name__=='__main__':
    p=argparse.ArgumentParser();p.add_argument('name');p.add_argument('variant');p.add_argument('--mode',type=int,required=True);p.add_argument('--adapter',choices=['baseline','eof-fixed'],default='baseline');p.add_argument('--engine',choices=['jit','interp'],default='jit');a=p.parse_args();prepare(a.name,a.variant,a.mode,a.adapter,a.engine)
