"""Measure one completed 360-degree turn using host-stamped UART events."""
from collections import deque
from pathlib import Path
import argparse
import hashlib
import json
import os
import signal
import socket
import subprocess
import time
from run import boost, temperatures

HERE = Path(__file__).resolve().parent
BOOST = Path('/sys/devices/system/cpu/cpufreq/boost')


def run(name):
    assert socket.gethostname() == 'oryx-linuxlite'
    case = HERE / 'positions'
    config = json.loads((case / ('PROFILE-'+name+'.json')).read_text())
    profile = Path(config['profile'])
    target = case / ('RUN-'+name+'.json')
    assert not target.exists() and not (profile/'last-run').exists()
    verify = lambda: all(hashlib.sha256((profile/n).read_bytes()).hexdigest()==h
        for n,h in config['inputs_sha256'].items())
    assert verify()
    state = dict(case=name,tile=config['tile'],position=config['position'],
        original_boost=BOOST.read_text().strip(),video_driver='dummy',audio_driver='dummy',
        host_boot_id=Path('/proc/sys/kernel/random/boot_id').read_text().strip(),
        samples=[],keys=[],completed_frames=[],error=None,turn=None,
        timing='CLOCK_MONOTONIC timestamps at existing UART fputc trace points; no game or wire changes')
    target.write_text(json.dumps(state,indent=2)+'\n')
    proc = None
    changed = False
    started = time.monotonic()
    right = False
    release_enter = None
    last_enter = -10
    heartbeat = 0
    pending = deque()
    request_count = 0
    completed_count = 0
    turn_start = None
    previous_angle = None
    degrees = 0
    stream = None
    tail = b''
    artifact = profile/'last-run'

    def key(code,down):
        with (profile/'key-events.txt').open('a') as f:f.write(f'{code} {int(down)}\n')
        state['keys'].append(dict(host_seconds=time.monotonic()-started,scancode=code,down=down))

    def interrupted(sig,frame):raise RuntimeError('Interrupted '+str(sig))
    handlers={s:signal.signal(s,interrupted) for s in (signal.SIGINT,signal.SIGTERM,signal.SIGHUP)}
    try:
        changed=True
        boost('0')
        artifact.mkdir()
        env=os.environ.copy()
        env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',
            LD_PRELOAD=str(profile/'input.so'),WOLF_KEY_EVENTS=str(profile/'key-events.txt'),
            WOLF_TIMED_TRACE=str(artifact/'timed.csv'))
        with (artifact/'frontend.txt').open('w') as log:
            proc=subprocess.Popen(['./flexe-agon-emulator','--renderer','sw'],cwd=profile,env=env,
                stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            while state['turn'] is None:
                now=time.monotonic();elapsed=now-started
                if proc.poll() is not None:raise RuntimeError('Frontend exit '+str(proc.returncode))
                if elapsed>120:raise TimeoutError('No complete 360-degree turn within120seconds')
                if BOOST.read_text().strip()!='0':raise RuntimeError('CPU boost changed')
                path=artifact/'timed.csv'
                if stream is None and path.exists():stream=path.open('rb')
                if stream:
                    tail+=stream.read()
                    lines=tail.split(b'\n');tail=lines.pop()
                    for line in lines:
                        ns,kind,seq,x,y,angle=line.decode().split(',')
                        ns=int(ns);seq=int(seq);x=int(x);y=int(y);angle=int(angle)
                        if kind=='R':
                            request_count+=1
                            assert (x,y)==tuple(int(v*65536) for v in config['position'])
                            pending.append(dict(request_number=request_count,request_ns=ns,x=x,y=y,angle=angle))
                        elif kind=='F':raise RuntimeError('Fizzle before completed turn')
                        elif kind=='D':
                            assert pending,'Completion without request'
                            frame=pending.popleft()
                            completed_count+=1
                            assert seq==completed_count%65536==frame['request_number']%65536
                            assert ns>frame['request_ns']
                            frame.update(sequence=seq,completed_ns=ns)
                            state['completed_frames'].append(frame)
                            if right and turn_start is None and frame['angle']!=0:
                                turn_start=dict(frame)
                                turn_start['completed_count']=completed_count
                                previous_angle=frame['angle']
                            elif turn_start is not None:
                                delta=(previous_angle-frame['angle'])%360
                                assert delta<=12,('Unexpected camera jump',previous_angle,frame['angle'])
                                degrees+=delta;previous_angle=frame['angle']
                                if degrees>=360 and state['turn'] is None:
                                    seconds=(ns-turn_start['completed_ns'])/1e9
                                    count=completed_count-turn_start['completed_count']
                                    state['turn']=dict(start=turn_start,end=dict(frame),
                                        degrees=degrees,completed_frame_intervals=count,host_seconds=seconds,
                                        completed_fps=count/seconds,returns_to_start_heading=frame['angle']==turn_start['angle'])
                                    print(name,'full turn:',degrees,'degrees,',count,'frame intervals,',
                                        round(seconds,6),'seconds,',round(count/seconds,3),'FPS',flush=True)
                if release_enter is not None and now>=release_enter:
                    key(40,False);release_enter=None
                if not completed_count:
                    if elapsed>=6 and elapsed-last_enter>=2 and release_enter is None:
                        key(40,True);release_enter=now+.12;last_enter=elapsed
                elif not right and release_enter is None:
                    key(79,True);right=True
                    print(name,'gameplay ready; turning clockwise',flush=True)
                if elapsed-heartbeat>=15:
                    sample=dict(host_seconds=elapsed,temperatures_celsius=temperatures(),
                        completions=completed_count,degrees=degrees,boost=BOOST.read_text().strip())
                    state['samples'].append(sample)
                    print(name,'elapsed',round(elapsed),'seconds;',sample,flush=True)
                    target.write_text(json.dumps(state,indent=2)+'\n');heartbeat=elapsed
                if max(temperatures().values(),default=0)>=95:raise RuntimeError('Temperature stop')
                time.sleep(.025)
            key(79,False)
            time.sleep(.15)
    except BaseException as exc:
        state['error']=repr(exc)
        raise
    finally:
        if stream:stream.close()
        if proc and proc.poll() is None:
            for p in Path('/proc').glob('[0-9]*'):
                try:
                    if os.getpgid(int(p.name))==proc.pid and (p/'exe').resolve()==(profile/'flexe-agon-emulator.bin').resolve():
                        os.kill(int(p.name),signal.SIGTERM)
                except (OSError,RuntimeError):pass
            try:proc.wait(timeout=10)
            except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
        state['process_exit']=proc.returncode if proc else None
        if proc:assert proc.poll() is not None
        if changed:boost(state['original_boost'])
        state['final_boost']=BOOST.read_text().strip()
        state['boost_restored']=state['final_boost']==state['original_boost']
        state['inputs_preserved']=verify()
        state['elapsed_host_seconds']=time.monotonic()-started
        stats=artifact/'stats.json'
        if stats.exists():state['backend_stats']=json.loads(stats.read_text())
        target.write_text(json.dumps(state,indent=2)+'\n')
        for s,h in handlers.items():signal.signal(s,h)
        print(name,'stopped; boost restored',state['boost_restored'],flush=True)
    assert state['error'] is None and state['process_exit']==0
    assert state['inputs_preserved'] and state['boost_restored']
    assert state['turn']['degrees']==360 and state['turn']['returns_to_start_heading']
    assert not any(state['backend_stats'][k] for k in ('failed','unhandled','unregistered','unmapped'))


if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('case',choices=['center','south'])
    run(parser.parse_args().case)
