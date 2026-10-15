"""Exact v5 guest fixtures on stock Fab; always silent/headless, fresh profiles."""
from pathlib import Path
import csv,hashlib,importlib.util,json,os,shutil,signal,subprocess,time
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[4]
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def main():
    runtime=ROOT.parent/'golem/.emulator/runtime/fab-1.2.5'
    helper=HERE.parent/'completion-probe/.work/setup_emulator.py'
    spec=importlib.util.spec_from_file_location('setup',helper);setup=importlib.util.module_from_spec(spec);spec.loader.exec_module(setup)
    results=[]
    for variant,mode in [('dense',1),('lookup',1),('lookup-buffer',1),('coarse',1),('coarse-buffer',1),('lookup-buffer',2)]:
        label=variant+('-physics' if mode==2 else '')
        profile=ROOT/'.emulator'/('rally28-fab-v5-'+label+'-01')
        assert not profile.exists(),profile
        inputs=HERE/'.work'/variant/'bin/candidate.bin'
        profile.mkdir(parents=True);app=profile/'sdcard/test/arcade/rally28/candidate';app.mkdir(parents=True)
        shutil.copyfile(inputs,app/'candidate.bin');(app/'mode.txt').write_text(str(mode)+'\n')
        if variant!='dense':shutil.copyfile(HERE/'.work/data/fuji.road',app/'fuji.road')
        receipt=json.loads((HERE/'evidence/PORTABLE-V5.json').read_text())
        portable_key=variant+('-shadow' if mode==2 else '-live')
        for p in app.iterdir():
            assert sha(p)==receipt['files'][portable_key+'/'+p.name]['sha256'],p
        for n in ('mos_platform.bin','mos_platform.map'):shutil.copyfile(runtime/'firmware'/n,profile/n)
        setup.verify_latest_mos(profile/'mos_platform.bin',profile/'mos_platform.map');setup.write_mos_identity(profile)
        (profile/'fab-agon-emulator.bin').symlink_to(runtime/'fab-agon-emulator')
        shutil.copyfile(runtime/'firmware/vdp_platform.so',profile/'vdp_platform.so')
        (profile/'.bespoke-vdp-profile').write_text('vdp_platform.so\n')
        setup.sync_shared_bin(runtime/'sdcard/bin',profile/'sdcard/bin')
        (profile/'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\nCD /test/arcade/rally28/candidate\r\nLOAD candidate.bin\r\nRUN .\r\n')
        setup.write_profile_launcher(profile,strict_bespoke=True)
        launch=profile/'fab-agon-emulator';launch.write_text(launch.read_text().replace('set -euo pipefail','set -euo pipefail\nexport SDL_VIDEODRIVER=dummy\nexport SDL_AUDIODRIVER=dummy',1))
        files=[launch,profile/'fab-agon-emulator.bin',profile/'vdp_platform.so',profile/'mos_platform.bin',profile/'mos_platform.map',profile/'sdcard/autoexec.txt',*app.iterdir()]
        hashes={str(p.relative_to(profile)):sha(p) for p in files}
        (profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in hashes.items()))
        identity={'variant':variant,'mode':mode,'runtime':'Fab 1.2.5 stock platform host module','files':hashes,'setup_helper_sha256':sha(helper)}
        (profile/'identity.json').write_text(json.dumps(identity,indent=2)+'\n')
        boost=Path('/sys/devices/system/cpu/cpufreq/boost');assert boost.read_text().strip()=='0'
        start=time.monotonic();boot=time.clock_gettime(time.CLOCK_BOOTTIME);begin=end=None;reason='timeout'
        with (profile/'frontend.log').open('w') as log:
            proc=subprocess.Popen(['./fab-agon-emulator'],cwd=profile,env=dict(os.environ,SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy'),stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            try:
                while time.monotonic()-start<300:
                    now=time.monotonic()
                    if boost.read_text().strip()!='0':reason='boost-enabled';break
                    if begin is None and (app/'started.txt').exists() and (app/'started.txt').stat().st_size:begin=now
                    if end is None and (app/'ended.txt').exists() and (app/'ended.txt').stat().st_size:end=now
                    if (app/'done.txt').exists() and (app/'done.txt').read_bytes().endswith(b'\n'):reason='guest-files';break
                    if proc.poll() is not None:reason='frontend-exit';break
                    time.sleep(.05)
            finally:
                if proc.poll() is None:
                    os.killpg(proc.pid,signal.SIGTERM)
                    try:proc.wait(timeout=5)
                    except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
        summary=dict(line.split('=',1) for line in (app/'summary.txt').read_text().splitlines() if '=' in line) if (app/'summary.txt').exists() else {}
        result={'variant':variant,'mode':mode,'reason':reason,'summary':summary,'host_seconds':time.monotonic()-start,'host_window_seconds':end-begin if begin is not None and end is not None else None,'host_suspend_seconds':(time.clock_gettime(time.CLOCK_BOOTTIME)-boot)-(time.monotonic()-start),'forced_sdl':{'video':'dummy','audio':'dummy'},'identities_unchanged':all(sha(profile/n)==h for n,h in hashes.items()),'identity':identity}
        result['outputs']={p.name:sha(p) for p in app.iterdir() if p.name not in ('candidate.bin','mode.txt','fuji.road')}
        # Persist the completed host window before optional reference checks.
        (profile/'result.json').write_text(json.dumps(result,indent=2)+'\n')
        if reason=='guest-files':
            assert summary['frames']=='900' and summary['failure']=='none' and summary['vector_restored']=='1' and summary['callback_restored']=='1'
            assert summary['position']=='1202800' and summary['phase']=='1600'
            assert len(list(csv.DictReader((app/'frames.csv').open())))==900
            if mode==2:
                import verify
                result['physics_reference']=verify.shadow(summary,app)
        dest=HERE/'evidence/fab-v5'/label;dest.mkdir(parents=True)
        for p in app.iterdir():shutil.copyfile(p,dest/p.name)
        shutil.copyfile(profile/'frontend.log',dest/'frontend.log')
        (dest/'result.json').write_text(json.dumps(result,indent=2)+'\n');results.append(result)
        print(json.dumps({k:result[k] for k in ('variant','mode','reason','host_window_seconds','summary')}),flush=True)
    (HERE/'evidence/fab-v5/COMPARISON.json').write_text(json.dumps(results,indent=2)+'\n')
if __name__=='__main__':main()
