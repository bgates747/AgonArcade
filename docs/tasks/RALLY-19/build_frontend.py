"""Build isolated Golem-default frontend and both resident track bootstraps."""
import argparse,json,shutil,subprocess
from pathlib import Path
from profile import TASK
from native_run import GOLEM,sha
from build_scenery_draw import build

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');a=p.parse_args()
    work=TASK/'.work/frontend'/a.name;(work/'src').mkdir(parents=True,exist_ok=False)
    source_paths=[TASK/'frontend.cpp',TASK/'golem_renderer.hpp',TASK/'frontend_state.hpp',TASK/'scene_protocol.hpp',
                  Path(__file__),GOLEM/'src/golemc.cpp',GOLEM/'src/hosted.hpp']
    source_paths+=sorted(TASK.glob('build_*kernel.py'))
    source_paths += [TASK/n for n in ['build_scenery_draw.py','build_scenery_history.py','build_scenery_heading.py',
                    'build_vehicle_draw.py','build_vehicle_projection.py','build_vehicle_sort.py','build_admitted_road.py','build_packed_section.py']]
    source_paths+=sorted((TASK/'.work/oracle/include').glob('*.hpp'))
    before={str(p):sha(p) for p in source_paths}
    shutil.copytree(TASK/'.work/oracle/include',work/'include')
    shutil.copy2(TASK/'frontend.cpp',work/'src/main.cpp')
    for name in ['golem_renderer.hpp','frontend_state.hpp','scene_protocol.hpp']:shutil.copy2(TASK/name,work/'include'/name)
    (work/'Makefile').write_text('NAME=rally\n.DEFAULT_GOAL := all\nLDHAS_ARG_PROCESSING=0\nLDHAS_EXIT_HANDLER=0\n'
                               'include $(shell agondev-config --makefile)\nCXXFLAGS += -std=c++17 -Wall -Wextra -Werror -fno-exceptions -fno-rtti\n')
    with (work/'build.txt').open('w') as log:
        subprocess.run(['make','-C',str(GOLEM/'src')],check=True,stdout=log,stderr=subprocess.STDOUT)
        for track in ['oval','fuji']:
            source=build(track,work/'kernels'/track)
            output=work/(track+'.vdp')
            subprocess.run([str(GOLEM/'build/golemc'),'--hosted',str(source),str(output)],check=True,stdout=log,stderr=subprocess.STDOUT)
            shutil.copy2(output.with_name(output.name+'.clear'),work/(track+'.clr'))
            shutil.copy2(TASK.parent/'RALLY-18/data'/(track+'.road'),work/(track+'.road'))
        subprocess.run(['make','-C',str(work)],check=True,stdout=log,stderr=subprocess.STDOUT)
    assert before=={str(p):sha(p) for p in source_paths},'Source changed during build'
    output_paths=[work/'bin/rally.bin',*[work/(t+ext) for t in ['oval','fuji'] for ext in ['.vdp','.clr','.road']]]
    report={'scope':__doc__,'source_hashes':before,'outputs':{str(p):sha(p) for p in output_paths},
            'golem_compiler_sha256':sha(GOLEM/'build/golemc'),'work':str(work),
            'remaining':'Headless frontend/control validation and all frozen performance/stability tests.'}
    (work/'manifest.json').write_text(json.dumps(report,indent=2)+'\n');print(work,flush=True)

if __name__=='__main__':main()
