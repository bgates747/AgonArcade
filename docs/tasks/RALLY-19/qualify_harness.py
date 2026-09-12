"""Headless SDL capture hook smoke and fixture parser negative tests."""
from pathlib import Path
import os,subprocess,json,struct,hashlib
from PIL import Image
from capture import build_library
from fixtures import cases,encoded
TASK=Path(__file__).resolve().parent
def main():
    work=TASK/'.work/capture-smoke';work.mkdir(exist_ok=True)
    library,_=build_library(work);binary=work/'smoke';home=Path.home()
    subprocess.run(['clang','-std=c11','-Wall','-Wextra','-Werror',f'-I{home}/.local/include',f'-L{home}/.local/lib',f'-Wl,-rpath,{home}/.local/lib',str(TASK/'capture_smoke.c'),'-lSDL3','-o',str(binary)],check=True)
    schedule='capture 3\nkey 4 right down\nkey 6 right up\nquit 8\n'
    (work/'actions.txt').write_text(schedule)
    env={k:v for k,v in os.environ.items() if not k.startswith(('RALLY_','LD_PRELOAD','DYLD_'))}
    env.update(SDL_VIDEODRIVER='dummy',SDL_AUDIODRIVER='dummy',LD_PRELOAD=str(library),RALLY_VISUAL_DIR=str(work),RALLY_VISUAL_LOG=str(work/'events.txt'),RALLY_VISUAL_CONFIG=str(work/'actions.txt'))
    out=subprocess.check_output([str(binary)],env=env,timeout=10).decode()
    image=Image.open(work/'frame-000003.bmp').convert('RGB')
    assert image.size==(32,24) and set(image.get_flattened_data())=={(17,34,51)}
    result={'scope':__doc__,'stdout':out,'schedule':schedule,'events':(work/'events.txt').read_text(),'image_size':image.size,'uniform_rgb':[17,34,51],'capture_source_sha256':hashlib.sha256((TASK/'visual_capture_linux.c').read_bytes()).hexdigest(),'invalid_fixtures':[]}
    valid=encoded(cases()[0]);values=list(struct.unpack('<17i',valid))
    tests={'empty':b'','truncated':valid[:-1],'trailing':valid+b'\0'}
    for index,lo,hi in [(0,0,575999),(1,0,7999),(2,-38400,38400),(3,-21,21),(4,0,300)]+[(5+i*2,0,575999) for i in range(6)]+[(6+i*2,-90,90) for i in range(6)]:
        for name,value in [('under',lo-1),('over',hi+1)]:
            words=values.copy();words[index]=value;tests[f'word-{index}-{name}']=struct.pack('<17i',*words)
    pose=work/'pose.dat';host=TASK/'.work/host_fixture';road=TASK.parent/'RALLY-18/data/oval.road'
    for name,data in tests.items():
        pose.write_bytes(data)
        p=subprocess.run([str(host),'oval',str(road),str(pose)],capture_output=True)
        assert p.returncode==3 and not p.stderr,(name,p.returncode,p.stderr)
        result['invalid_fixtures'].append(name)
    pose.write_bytes(valid);subprocess.run([str(host),'oval',str(road),str(pose)],check=True,stdout=subprocess.DEVNULL)
    (TASK/'evidence/harness-qualification.json').write_text(json.dumps(result,indent=2)+'\n')
    print(out.strip(),'; rejected',len(tests),'malformed fixtures; valid fixture accepted')
if __name__=='__main__':main()
