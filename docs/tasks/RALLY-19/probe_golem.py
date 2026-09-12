"""Compile existing C++ Golem, execute its kernels headlessly on stock VDP.

GP echoes are used for diagnostic byte readback, never called frame completion.
No custom firmware, no unlimited CPU, and no mathematical answers from eZ80.
"""
from pathlib import Path
import argparse,hashlib,json,math,shutil,struct,subprocess,csv,os,signal,time
from profile import prepare,TASK
from capture import capture,runtime_identity
from scene_masks import game_image
GOLEM=Path('/home/smith/Agon/mystuff/golem-rally19')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('name');parser.add_argument('--cost-only',action='store_true');args=parser.parse_args()
    root=TASK/'evidence/golem-arithmetic'/args.name;root.mkdir(parents=True,exist_ok=False)
    build=GOLEM/'build/native-arithmetic'/args.name;(build/'src').mkdir(parents=True,exist_ok=False)
    for src,dest in [('Makefile','Makefile'),('main.cpp','src/main.cpp')]:shutil.copy2(GOLEM/'examples/native_arithmetic'/src,build/dest)
    with (root/'build.txt').open('w') as log:
        subprocess.run(['make','-B','-C',str(GOLEM/'src')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(GOLEM/'examples/native_arithmetic/kernel.golem'),str(build/'program.bin')],check=True,stdout=log,stderr=subprocess.STDOUT)
        subprocess.run(['make','-B','-C',str(build)],check=True,stdout=log,stderr=subprocess.STDOUT)
    poses=[(7,9,84,0,-3.75,30),(3,11,81,45,127.75,60),(-4,6,42,90,-32768,90),(7,7,84,-90,32767,120),(1,3,42,45,.5,150)]
    cases=bytearray(b'G19P'+struct.pack('<H',len(poses)));expected=[]
    for a,b,n,angle,floor,y in poses:
        product=f32(a*b);reciprocal=f32(1/b)
        # Stock affine rotation is anticlockwise in downward-positive screen Y:
        # [cos sin; -sin cos], as pinned vdu_buffered.h specifies.
        values=[product,f32(product+a),reciprocal,f32(n*reciprocal),f32(10*math.cos(math.radians(angle))),f32(-10*math.sin(math.radians(angle))),math.floor(floor),int(product+40),y,6,12345,float(a),product,float(a)]
        expected.append(values);cases+=struct.pack('<4ifhH',a,b,n,angle,floor,y,0)+struct.pack('<6f3hHh3f',*values)
    (root/'inputs.json').write_text(json.dumps({'inputs':poses,'expected':expected},indent=2)+'\n')
    profile=prepare(TASK/'.emulator'/('golem-'+args.name),build/'bin/probe.bin','')
    app=profile/'sdcard/rally';(app/'program.bin').symlink_to(build/'program.bin');(app/'cases.dat').write_bytes(cases)
    identity={'compiler':sha(GOLEM/'build/golemc'),'compiler_source':sha(GOLEM/'src/golemc.cpp'),'hosted_source':sha(GOLEM/'src/hosted.hpp'),'kernel':sha(GOLEM/'examples/native_arithmetic/kernel.golem'),'program':sha(build/'program.bin'),'loader':sha(build/'bin/probe.bin'),'case_bytes':hashlib.sha256(cases).hexdigest()}
    (root/'identity.json').write_text(json.dumps(identity,indent=2)+'\n')
    shutil.copy2(GOLEM/'examples/native_arithmetic/kernel.golem',root/'kernel.golem')
    shutil.copy2(GOLEM/'examples/native_arithmetic/main.cpp',root/'loader.cpp')
    shutil.copy2(build/'program.bin.map',root/'program.map')
    if args.cost_only:
        (app/'cost.only').touch();out=root/'capture';out.mkdir()
        before=runtime_identity(profile)
        env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','DYLD_')) and k not in ('LD_PRELOAD','BASH_ENV')}
        env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy')
        command=['./fab-agon-emulator','--renderer','sw'];started=time.monotonic()
        with (out/'emulator.log').open('w') as log:
            proc=subprocess.Popen(command,cwd=profile,env=env,stdout=log,stderr=subprocess.STDOUT,start_new_session=True)
            try:
                while not (app/'exit.viz').exists():
                    if proc.poll() is not None:raise RuntimeError('emulator exited before guest completion')
                    if time.monotonic()-started>120:raise TimeoutError('native cost run')
                    time.sleep(.02)
            finally:
                if proc.poll() is None:
                    os.killpg(proc.pid,signal.SIGTERM)
                    try:proc.wait(timeout=5)
                    except subprocess.TimeoutExpired:os.killpg(proc.pid,signal.SIGKILL);proc.wait()
        for name in ['results.dat','extra.dat','cost.csv','final.dat','exit.viz']:shutil.copy2(app/name,out/('guest-'+name))
        after=runtime_identity(profile);assert all(after[p]==v for p,v in before.items())
        (out/'manifest.json').write_text(json.dumps({'command':command,'runtime_before':before,'runtime_after':after,'scope':'Normal CPU, stock VDP, dummy SDL, no interposer. Guest exit marker precedes host process termination.','host_seconds':time.monotonic()-started},indent=2)+'\n')
    else:
        capture(argparse.Namespace(profile=profile,output=root/'capture',frames='10',keys='escape:20:26',quit_frame=50,timeout=90,ready_file=app/'ready.viz',expect_file=[app/'results.dat',app/'extra.dat',app/'cost.csv',app/'final.dat',app/'exit.viz']))
    raw=(root/'capture/guest-results.dat').read_bytes();assert len(raw)==len(poses)*46
    image=None if args.cost_only else game_image(root/'capture/frame-000010.png');results=[]
    for i,want in enumerate(expected):
        actual=struct.unpack_from('<6f3hHh3f',raw,i*46);errors=[abs(x-y) for x,y in zip(actual[:6],want[:6])]
        correct=all(error<=max(5e-6,abs(w)*5e-6) for error,w in zip(errors,want[:6])) and list(actual[6:])==want[6:]
        x,y=want[7:9];pixel=image.getpixel((x,y)) if image else None;plot=pixel==(255,255,255) if image else None
        results.append({'case':i,'actual':actual,'expected':want,'float_absolute_errors':errors,'numeric_pass':correct,'plot_rgb':pixel,'plot_pass':plot})
    extra=(root/'capture/guest-extra.dat').read_bytes();assert len(extra)==52
    loops=[struct.unpack_from('<HH',extra,i*4) for i in range(4)]
    guards=[struct.unpack_from('<Hf',extra,16+i*6) for i in range(6)]
    assert loops==[(65534,12345),(65535,12345),(6,12345),(118,12345)],loops
    assert guards==[(0,3.0)]*5+[(1,7.0)],guards
    if image:
        white={(x,y) for y in range(240) for x in range(320) if image.getpixel((x,y))==(255,255,255)}
        assert white=={(103,30),(73,60),(16,90),(89,120),(43,150),(47,150)},white
    final=struct.unpack('<6f3hHh3f',(root/'capture/guest-final.dat').read_bytes())
    final_want=[7,8,f32(1/7),f32(42*f32(1/7)),f32(10/math.sqrt(2)),f32(-10/math.sqrt(2)),0,47,150,6,12345,1,7,1]
    assert all(abs(a-b)<=max(5e-6,abs(b)*5e-6) for a,b in zip(final[:6],final_want[:6])) and list(final[6:])==final_want[6:],final
    costs=list(csv.DictReader((root/'capture/guest-cost.csv').read_text().splitlines()))
    assert len(costs)==11
    for row in costs:
        row['mean_ms_per_call']=int(row['ticks'])/120*1000/int(row['calls'])
    passed=all(r['numeric_pass'] and (args.cost_only or r['plot_pass']) for r in results)
    (root/'results.json').write_text(json.dumps({'scope':__doc__,'cases':results,'loops':loops,'guards':guards,'final_after_repeated_calls':final,'costs':costs,'timing_scope':'Guest raw-clock batch including command transmission and final GP parser milestone; not raster completion. '+('No visual hook.' if args.cost_only else 'Visual hook active; preliminary only.'),'pass':passed},indent=2)+'\n')
    assert passed,results
    print('Native Golem arithmetic and computed PLOT:',len(results),'varying-input cases pass')
if __name__=='__main__':main()
