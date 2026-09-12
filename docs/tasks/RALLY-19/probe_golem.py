"""Compile existing C++ Golem, execute its kernels headlessly on stock VDP.

GP echoes are used for diagnostic byte readback, never called frame completion.
No custom firmware, no unlimited CPU, and no mathematical answers from eZ80.
"""
from pathlib import Path
import argparse,hashlib,json,math,shutil,struct,subprocess
from profile import prepare,TASK
from capture import capture
from scene_masks import game_image
GOLEM=Path('/home/smith/Agon/mystuff/golem-rally19')
def sha(p):return hashlib.sha256(p.read_bytes()).hexdigest()
def f32(x):return struct.unpack('<f',struct.pack('<f',x))[0]
def main():
    parser=argparse.ArgumentParser(description=__doc__);parser.add_argument('name');args=parser.parse_args()
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
        values=[product,f32(product+a),reciprocal,f32(n*reciprocal),f32(10*math.cos(math.radians(angle))),f32(-10*math.sin(math.radians(angle))),math.floor(floor),int(product+40),y,6,12345]
        expected.append(values);cases+=struct.pack('<4ifhH',a,b,n,angle,floor,y,0)+struct.pack('<6f3hHh',*values)
    (root/'inputs.json').write_text(json.dumps({'inputs':poses,'expected':expected},indent=2)+'\n')
    profile=prepare(TASK/'.emulator'/('golem-'+args.name),build/'bin/probe.bin','')
    app=profile/'sdcard/rally';(app/'program.bin').symlink_to(build/'program.bin');(app/'cases.dat').write_bytes(cases)
    identity={'compiler':sha(GOLEM/'build/golemc'),'compiler_source':sha(GOLEM/'src/golemc.cpp'),'hosted_source':sha(GOLEM/'src/hosted.hpp'),'kernel':sha(GOLEM/'examples/native_arithmetic/kernel.golem'),'program':sha(build/'program.bin'),'loader':sha(build/'bin/probe.bin'),'case_bytes':hashlib.sha256(cases).hexdigest()}
    (root/'identity.json').write_text(json.dumps(identity,indent=2)+'\n')
    shutil.copy2(GOLEM/'examples/native_arithmetic/kernel.golem',root/'kernel.golem')
    shutil.copy2(GOLEM/'examples/native_arithmetic/main.cpp',root/'loader.cpp')
    shutil.copy2(build/'program.bin.map',root/'program.map')
    capture(argparse.Namespace(profile=profile,output=root/'capture',frames='10',keys='escape:20:26',quit_frame=50,timeout=60,ready_file=app/'ready.viz',expect_file=[app/'results.dat',app/'exit.viz']))
    raw=(root/'capture/guest-results.dat').read_bytes();assert len(raw)==len(poses)*34
    image=game_image(root/'capture/frame-000010.png');results=[]
    for i,want in enumerate(expected):
        actual=struct.unpack_from('<6f3hHh',raw,i*34);errors=[abs(x-y) for x,y in zip(actual[:6],want[:6])]
        correct=all(error<=max(5e-6,abs(w)*5e-6) for error,w in zip(errors,want[:6])) and list(actual[6:])==want[6:]
        x,y=want[7:9];pixel=image.getpixel((x,y));plot=pixel==(255,255,255)
        results.append({'case':i,'actual':actual,'expected':want,'float_absolute_errors':errors,'numeric_pass':correct,'plot_rgb':pixel,'plot_pass':plot})
    (root/'results.json').write_text(json.dumps({'scope':__doc__,'cases':results,'pass':all(r['numeric_pass'] and r['plot_pass'] for r in results)},indent=2)+'\n')
    assert all(r['numeric_pass'] and r['plot_pass'] for r in results),results
    print('Native Golem arithmetic and computed PLOT:',len(results),'varying-input cases pass')
if __name__=='__main__':main()
