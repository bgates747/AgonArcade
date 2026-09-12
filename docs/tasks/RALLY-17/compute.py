"""Computation/state-only section renderer experiment; no command construction."""
import experiment as e
import re,json,subprocess,argparse
BASE_SOURCE=e.source
e.STATE=e.WORK/'compute-active.json';e.VARIANTS=('sections',)
def source(variant):
    s=BASE_SOURCE(variant)
    s=s.replace('#include <ez80f92.h>','#include <ez80f92.h>\n#include "computation.hpp"')
    a=s.index('bool renderPose(');b=s.index('\n}\n}',a)+2
    original=s[a:b].replace('renderPose(','renderWarmup(',1)
    hot='''volatile computation::Scene computedScene{};
bool renderPose(unsigned pose){
    rally::workloadPose(pose,motion,traffic,false);
    computation::calculate(motion,traffic,road,sceneryHistory,computedScene);
    ++frames;carCount+=computedScene.carCount;
    poseHash=rally::workloadHash(poseHash,motion,traffic);
    return true;
}'''
    s=s[:a]+original+'\n'+hot+s[b:]
    s=s.replace('if(!renderPose(0))','if(!renderWarmup(0))')
    s=s.replace('    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);','''    FILE *scene=fopen("computed.csv","w");if(!scene)return 21;
    fprintf(scene,"%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\\n",
      (long)computedScene.skyOffset,(long)computedScene.skyDelta,(long)computedScene.skyLeft,
      (long)computedScene.skyRight,(long)computedScene.skyRepaint,(long)computedScene.playerView,
      (long)computedScene.playerMirror,(long)computedScene.playerX,(long)computedScene.sectionCount,(long)computedScene.carCount);
    for(unsigned i=0;i<road.boundaryCount;++i)fprintf(scene,"%ld,%u,%ld\\n",(long)computedScene.sectionX[i],unsigned(road.rows[i]),(long)road.centersQ8[i]);
    for(int i=0;i<computedScene.carCount;++i){const volatile auto &c=computedScene.cars[i];fprintf(scene,"%ld,%ld,%ld,%ld,%ld,%ld\\n",(long)c.bitmap,(long)c.scale,(long)c.mirror,(long)c.x,(long)c.y,(long)c.translation);}
    fclose(scene);
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);''')
    return s
e.source=source

def bench():
    s=json.loads(e.STATE.read_text());e.check(s);e.CYCLE_MODE=True
    info=s['variants']['sections'];remote=re.search(r'Build directory: (.+)',info['build_evidence'])[1]
    mapping=subprocess.check_output(['ssh','agon-linux','cat '+remote+'/bin/rally.map'],text=True)
    dis=subprocess.check_output(['ssh','agon-linux','/home/smith/Agon/agondev/release/bin/ez80-none-elf-objdump -dr '+remote+'/obj/main.o'],text=True)
    base=int(re.search(r'(0x[0-9a-f]+)\s+_main\s*$',mapping,re.M)[1],16)
    main=dis[dis.index('<_main>:'):dis.index('\n0000',dis.index('<_main>:'))]
    temt=main.index('in0 a,(0xc5)');clock=int(re.search(r'([0-9a-f]+) <__ZN12_GLOBAL__N_18rawClockEv>',dis)[1],16)
    calls=list(re.finditer(r'^\s*([0-9a-f]+):.*\bcall 0x0*'+f'{clock:x}'+r'\s*$',main,re.M))
    boundaries=([m for m in calls if m.start()<temt][-1],[m for m in calls if m.start()>temt][0])
    info['breakpoints']=[base+int(m[1],16) for m in boundaries]
    binary=(e.Path(info['root'])/'bin/rally.bin').read_bytes()
    for address in info['breakpoints']:assert binary[address-0x40000]==0xcd
    output=e.Path(e.tempfile.mkdtemp(prefix='compute-',dir=e.TASK/'.emulator'))
    (output/'sections.map').write_text(mapping);(output/'sections-disasm.txt').write_text(dis)
    prior=json.loads((e.TASK/'cycle-results/manifest.json').read_text())
    m={'variants':s['variants'],'mainline':s['mainline'],'runtime':prior['runtime'],'headless':True,'runs':[]}
    for track in ('oval','fuji'):
        expected=next(r for r in prior['runs'] if r['track']==track and r['variant']=='sections' and r['mode']=='sink')
        for number in (1,2):
            r=e.run_case(s,output,track,'sections',number,'sink')
            assert r['sink']['bytes']==0 and r['data']['road_bytes']==0,r
            for key in ('pose_hash','cars','frames'):assert r['data'][key]==expected['data'][key],key
            scene=output/r['case']/'sdcard/rally/computed.csv'
            host=subprocess.check_output([str(e.WORK/'compute-reference'),track],text=True)
            assert scene.read_text()==host,(scene,host)
            e.shutil.copy2(scene,output/(r['case']+'-computed.csv'))
            m['runs'].append(r);(output/'manifest.json').write_text(json.dumps(m,indent=2)+'\n')
    e.check(s)
    for name,h in m['runtime'].items():assert e.sha(e.Path(name))==h,name
    results=e.TASK/'compute-results';results.mkdir(exist_ok=True)
    for p in output.iterdir():
        if p.is_file():e.shutil.copy2(p,results/p.name)
    e.shutil.copy2(info['build_log'],results/'sections-build.txt')
    print('Results:',results,flush=True)

if __name__=='__main__':
    parser=argparse.ArgumentParser();parser.add_argument('action',choices=('build','bench'));args=parser.parse_args()
    if args.action=='build':e.build()
    else:bench()
