"""Frontend control capture with grip keys; isolated fork of the qualified headless harness, not for timing."""
from pathlib import Path
import argparse
import hashlib
import json
import os
import shlex
import signal
import subprocess
import time

TASK=Path(__file__).resolve().parent
REPO=TASK.parents[2]
SOURCE=TASK/'visual_capture_frontend.c'


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def runtime_identity(profile):
    launcher=profile/'fab-agon-emulator'
    if launcher.is_symlink() or not launcher.is_file():
        raise RuntimeError('Use a real canonical generated profile wrapper')
    if (profile/'.bespoke-vdp-profile').exists():
        raise RuntimeError('Visual captures require a stock-VDP profile')
    files=[launcher,profile/'fab-agon-emulator.bin',profile/'mos_platform.bin',
           profile/'mos_platform.map',profile/'firmware/vdp_platform.so',
           profile/'.mos-release',profile/'.mos-release.sha256',profile/'sdcard/autoexec.txt']
    files += sorted(p for p in (profile/'sdcard/rally').iterdir() if p.is_file())
    return {str(p):{'target':str(p.resolve()),'bytes':p.stat().st_size,'sha256':sha(p)} for p in files}


def build_library(output):
    library=output/'visual-capture.so'
    home=Path.home()
    command=['clang','-std=c11','-Wall','-Wextra','-Werror','-shared','-fPIC',
             f'-I{home}/.local/include',f'-L{home}/.local/lib',f'-Wl,-rpath,{home}/.local/lib','-lSDL3','-ldl',str(SOURCE),'-o',str(library)]
    subprocess.run(command,check=True)
    return library,command


def parse_actions(args):
    frames=[int(value) for value in args.frames.split(',')]
    if not frames or len(set(frames))!=len(frames) or min(frames)<1:
        raise ValueError('Capture frames must be distinct positive integers')
    events=[]
    for item in filter(None,args.keys.split(',')):
        name,start,end=item.split(':')
        start,end=int(start),int(end)
        if name not in ('left','right','up','down','space','escape','minus','equals') or not 0<start<end:
            raise ValueError('Keys use name:press_frame:release_frame')
        events += [(start,name,1),(end,name,0)]
    final=max(frames+[frame for frame,_,_ in events])
    if args.quit_frame<=final or len(frames)+len(events)+1>128:
        raise ValueError('Quit must follow all captures/keys; at most 128 actions')
    actions=[(n,f'capture {n}') for n in frames]
    actions += [(n,f'key {n} {name} '+('down' if down else 'up')) for n,name,down in events]
    actions += [(args.quit_frame,f'quit {args.quit_frame}')]
    return frames,events,'\n'.join(line for _,line in sorted(actions))+'\n'


def capture(args):
    from PIL import Image
    profile=args.profile.resolve()
    if not profile.is_relative_to(TASK/'.emulator'):
        raise RuntimeError('The input profile must be isolated under RALLY-19/.emulator')
    output=args.output.resolve()
    if not output.is_relative_to(TASK):
        raise RuntimeError('Keep visual output within the RALLY-19 task bucket')
    output.mkdir(parents=True,exist_ok=False)
    before=runtime_identity(profile)
    frames,events,configuration=parse_actions(args)
    for path in [args.ready_file,*args.expect_file]:
        if path and path.exists():
            raise RuntimeError(f'Stale guest signal/report; use a fresh profile: {path}')
    library,build_command=build_library(output)
    (output/'actions.txt').write_text(configuration)
    env=os.environ.copy()
    for key in list(env):
        if key.startswith(('RALLY_SINK_','RALLY_CAPTURE_','RALLY_VISUAL_')) or key in (
                'RALLY_STOCK_VDP','RALLY_TEST_KEYS','BASH_ENV','DYLD_INSERT_LIBRARIES','LD_PRELOAD'):
            env.pop(key,None)
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',LD_PRELOAD=str(library),
               RALLY_VISUAL_LIBRARY=str(library),RALLY_VISUAL_DIR=str(output),
               RALLY_VISUAL_LOG=str(output/'events.txt'),RALLY_VISUAL_CONFIG=str(output/'actions.txt'))
    if args.ready_file: env['RALLY_VISUAL_READY']=str(args.ready_file.resolve())
    manifest={'purpose':'native visual/input evidence; no performance measurements',
              'profile':str(profile),'runtime_before':before,'headless':True,
              'capture_source_sha256':sha(SOURCE),'capture_harness_sha256':sha(Path(__file__)),
              'interposer_sha256':sha(library),'build_command':build_command,
              'schedule':configuration,'ready_file':str(args.ready_file) if args.ready_file else None,
              'frame_definition':'host SDL presents, starting at ready-file detection or the first present',
              'command':['./fab-agon-emulator','--renderer','sw'],'actual_process_commands':[]}
    start=time.monotonic()
    with (output/'emulator.log').open('w') as log:
        process=subprocess.Popen(manifest['command'],cwd=profile,env=env,stdout=log,
                                 stderr=subprocess.STDOUT,start_new_session=True)
        manifest['pid']=process.pid
        try:
            while process.poll() is None and time.monotonic()-start<args.timeout:
                if not manifest['actual_process_commands']:
                    commands=subprocess.check_output(['ps','-axo','pgid=,command='],text=True)
                    actual=[line.strip() for line in commands.splitlines()
                            if line.strip().split(None,1)[0]==str(process.pid)]
                    if any('--sdcard' in line for line in actual):
                        manifest['actual_process_commands']=actual
                time.sleep(.1)
            manifest['timed_out']=process.poll() is None
        finally:
            if process.poll() is None:
                os.killpg(process.pid,signal.SIGTERM)
                try: process.wait(timeout=5)
                except subprocess.TimeoutExpired:
                    os.killpg(process.pid,signal.SIGKILL);process.wait()
            manifest['returncode']=process.returncode
            manifest['wall_seconds_with_startup']=time.monotonic()-start
            (output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    if manifest['timed_out']: raise RuntimeError(f'Capture timed out; artifacts retained: {output}')
    actual=manifest['actual_process_commands']
    if not actual or any(token in ('-u','--unlimited_cpu','--unlimited-cpu')
                         for line in actual for token in shlex.split(line)):
        raise RuntimeError('Missing runtime command identity or unexpected unlimited CPU')
    log=(output/'events.txt').read_text()
    expected=[f'capture frame={n} ' for n in frames]
    expected += [f'key frame={n} name={name} down={down} ' for n,name,down in events]
    expected += [f'quit frame={args.quit_frame} ']
    if 'error ' in log or any(log.count(line)!=1 for line in expected):
        raise RuntimeError(f'Missing/duplicate capture or input event; inspect {output}/events.txt')
    found=sorted(output.glob('frame-*.bmp'))
    if len(found)!=len(frames):raise RuntimeError('Unexpected capture count')
    manifest['captures']=[]
    for source in found:
        destination=source.with_suffix('.png')
        with Image.open(source) as image:
            image.convert('RGB').save(destination)
            size=image.size
        manifest['captures'].append({'file':destination.name,'sha256':sha(destination),'size':size})
        source.unlink()
    manifest['guest_reports']=[]
    for path in args.expect_file:
        if not path.is_file():raise RuntimeError(f'Guest did not produce expected report: {path}')
        destination=output/('guest-'+path.name)
        destination.write_bytes(path.read_bytes())
        manifest['guest_reports'].append({'source':str(path),'file':destination.name,'sha256':sha(path)})
    # Guest output is allowed, but every launch/runtime/data input must retain
    # exactly its initial identity. Newly created signal files are not inputs.
    after=runtime_identity(profile)
    if any(after.get(name)!=identity for name,identity in before.items()):
        raise RuntimeError('Profile input/runtime changed during visual capture')
    manifest['runtime_after']={name:after[name] for name in before}
    manifest['runtime_inputs_unchanged']=True
    manifest['status']='captures and scheduled event injection verified; inspect guest reports/images for behavior'
    (output/'manifest.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print(f'Captured {len(frames)} native frames: {output}',flush=True)


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--profile',type=Path,required=True)
    parser.add_argument('--output',type=Path,required=True,help='New task-local results directory')
    parser.add_argument('--ready-file',type=Path,help='Start schedule only when guest creates this file')
    parser.add_argument('--expect-file',type=Path,action='append',default=[],help='Require and retain a fresh guest report')
    parser.add_argument('--frames',default='600',help='Comma-separated host-present capture numbers')
    parser.add_argument('--keys',default='',help='Comma-separated name:press:release (host presents)')
    parser.add_argument('--quit-frame',type=int,default=640)
    parser.add_argument('--timeout',type=float,default=90)
    capture(parser.parse_args())


if __name__=='__main__': main()
