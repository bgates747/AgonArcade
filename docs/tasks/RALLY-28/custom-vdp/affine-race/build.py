"""Actor-only full-race cache candidates; preserve every historical input."""
from pathlib import Path
import hashlib,json,shutil,struct,subprocess,sys

HERE=Path(__file__).resolve().parent
RACE=HERE.parent/'full-race'
PACED=HERE.parent/'paced-road'
WORK=HERE/'.work'
ORDER=('rebuild','cached-affine','prepared-bitmap','additive')
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def save(path,value):
    path.parent.mkdir(parents=True,exist_ok=True)
    data=(json.dumps(value,indent=2)+'\n').encode()
    if path.exists():assert path.read_bytes()==data,('Preserve existing output',path)
    else:path.write_bytes(data)

def build():
    source=RACE/'.work/packages/span-native'
    old=json.loads((RACE/'VARIANTS.json').read_text())['variants']
    result={}
    for name in ORDER:
        package=WORK/'packages'/name
        if name in ('rebuild','additive'):
            tag='span-native' if name=='rebuild' else 'additive'
            original=RACE/old[tag]['package']
            shutil.copytree(original,package)
            image=(RACE/old[tag]['target']).read_bytes()
            assert hashlib.sha256(image).hexdigest()==old[tag]['module_sha256']
            target=WORK/'targets'/name;target.mkdir(parents=True)
            (target/'rally-render.vdpl').write_bytes(image)
            meta=dict(module_sha256=old[tag]['module_sha256'],module_bytes=len(image),
                      preserved=True,original=tag)
        else:
            shutil.copytree(source,package)
            core=(package/'helper/render_core.inc').read_text()
            needle='typedef RallyRenderActorScratchV1 Car;'
            assert core.count(needle)==1
            core=core.replace(needle,needle+'\n#define R28_PREPARED '+str(int(name=='prepared-bitmap'))+'\n#include "cache.inc"')
            old_draw='''        matrix(o, r->matrix, r->xx, r->scale, r->translation);
        bitmap(o, r->bitmap, r->matrix, r->x, r->y);'''
            assert core.count(old_draw)==1
            core=core.replace(old_draw,'        r28_actor(o,a,r,sign,sign?(unsigned)(r-signs):0);')
            (package/'helper/render_core.inc').write_text(core)
            shutil.copyfile(HERE/'cache.inc',package/'helper/cache.inc')
            helper=(package/'helper/rally_render.c').read_text()
            helper=helper.replace('clear_completion(c);ctx->bound=0;',
                'clear_completion(c);ctx->bound=0;r28_cache_reset();',1)
            before='    if(!state_ok(state,lap,b->session))'
            assert helper.count(before)==1
            helper=helper.replace(before,'    if(state->request_generation==3)r28_cache_reset(); /* cold first timed frame */\n'+before)
            (package/'helper/rally_render.c').write_text(helper)
            target=WORK/'targets'/name
            command=[sys.executable,str(PACED/'control/sdk/tools/build_module.py'),str(package/'native.c'),
                '--name','rally-render','--build-id',hex(0x52384130+ORDER.index(name)),
                '--output',str(target),'--text-limit','32768','--data-limit','4096',
                '--stack-limit','2048','--image-limit','65536']
            run=subprocess.run(command,text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
            (HERE/('BUILD-'+name+'.txt')).write_text(run.stdout)
            assert run.returncode==0,run.stdout
            module=json.loads(run.stdout)['module'];image=(target/'rally-render.vdpl').read_bytes()
            meta=dict(module_sha256=sha(target/'rally-render.vdpl'),module_bytes=len(image),module=module,
                      preserved=False,cold_first_timed_frame=True)
        assert sha(package/'native.c')=='94d92d109f9b3b93e8ddfea1427edcdeb9059a87636a6bacfd93d3c3894a1992'
        out=HERE/'targets'/name;out.mkdir(parents=True)
        shutil.copyfile(target/'rally-render.vdpl',out/'rally-render.vdpl')
        meta.update(package=str(package.relative_to(HERE)),target=str((out/'rally-render.vdpl').relative_to(HERE)),
            source_files={str(p.relative_to(package)):sha(p) for p in package.rglob('*') if p.is_file()})
        result[name]=meta
    save(HERE/'BUILD.json',result)
    for frames in (60,900):
        registry={}
        for name in ORDER:
            base='additive' if name=='additive' else 'span-native'
            directory=RACE/('fixtures' if frames==900 else 'fixtures-smoke60')/base
            # Short fixtures may exist only for baseline/additive; use full
            # files and change only the already specified frame count/config.
            if not directory.exists():directory=RACE/'fixtures'/base
            fixture=HERE/('fixtures' if frames==900 else 'fixtures-smoke60')/name
            shutil.copytree(directory,fixture)
            module=(HERE/result[name]['target']).read_bytes()
            wire=b'\x17\0\xa0'+struct.pack('<H',50305)
            (fixture/'module.vdu').write_bytes(wire+b'\2'+wire+b'\0'+struct.pack('<H',len(module))+module)
            config=b'R28F'+struct.pack('<HHIHH',1,frames,len(module),0,0)
            (fixture/'config.bin').write_bytes(config)
            meta=json.loads((fixture/'expected.json').read_text())
            meta.update(frames=frames,physics_ticks=frames*4,candidate=name,module_sha256=result[name]['module_sha256'],
                module_bytes=len(module),expected_render_requests=frames+2,expected_native_generation=frames*5+3,
                expected_native_world_ticks=frames*4,alias_of=None,alias_reason=None)
            meta['files']={p.name:sha(p) for p in fixture.iterdir() if p.name!='expected.json'}
            (fixture/'expected.json').write_text(json.dumps(meta,indent=2)+'\n')
            registry[name]=dict(directory=str(fixture.relative_to(HERE)),files={p.name:sha(p) for p in fixture.iterdir()},
                module_sha256=result[name]['module_sha256'],diagnostic=False,foreground_paced=False)
        for n in ('probe.bin','motion.bin','artwork.vdu','presentation.vdu','common.vdu','assets.vdu'):
            assert len({r['files'][n] for r in registry.values()})==1,n
        save(HERE/('FIXTURES.json' if frames==900 else 'SMOKE-FIXTURES.json'),registry)
    print('Built four actor variants with one unchanged full-race guest.')

if __name__=='__main__':build()
