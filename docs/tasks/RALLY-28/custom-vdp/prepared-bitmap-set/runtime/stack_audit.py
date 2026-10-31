"""Conservative compiled-module stack path; external SDK frames stay separate."""
from pathlib import Path
import hashlib
import json
import re
import subprocess

HERE=Path(__file__).resolve().parent
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def audit():
    work=HERE/'.work/stack';work.mkdir(parents=True,exist_ok=True)
    cc=Path.home()/'.platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc'
    command=[str(cc),'-I',str(HERE.parents[1]/'paced-road/control/sdk/include'),'-Os',
        '-fPIC','-mlongcalls','-mtext-section-literals','-fvisibility=hidden',
        '-ffunction-sections','-fdata-sections','-fno-builtin','-ffp-contract=off',
        '-fstack-usage','-fno-common','-DVDPL_VARIANT=1','-fdump-tree-optimized',
        '-c',str(HERE/'source/checked.c'),'-o',str(work/'stack.o')]
    subprocess.run(command,check=True)
    assert (work/'stack.o').read_bytes()==(HERE/'target/rally-prepared.o').read_bytes()
    dump=next(work.glob('*optimized'));text=dump.read_text()
    su=HERE/'target/rally-prepared.su'
    frames={}
    for line in su.read_text().splitlines():
        label,n,kind=line.split('\t');assert kind=='static'
        frames[label.rsplit(':',1)[-1].replace('$','.')]=int(n)
    chunks=re.split(r'^;; Function (\S+).*\n',text,flags=re.M);graph={};indirect={}
    for name,body in zip(chunks[1::2],chunks[2::2]):
        body=body[body.find('{')+1:]
        calls={c.replace('$','.') for c in re.findall(r'(?<![\w$])([A-Za-z_][\w.$]*) \(',body)}
        name=name.replace('$','.');graph[name]=sorted(calls&frames.keys())
        indirect[name]=sorted(c for c in calls if c.startswith('_'))
    assert set(graph)==set(frames)
    active=set();paths={}
    def depth(name):
        assert name not in active,'Recursive path is not covered'
        if name in paths:return paths[name]
        active.add(name)
        n,path=max((depth(v) for v in graph[name]),key=lambda x:x[0],default=(0,[]))
        active.remove(name);paths[name]=(frames[name]+n,[name]+path);return paths[name]
    n,path=depth('vdplet_entry')
    assert n==1280 and n<2048
    old=(HERE.parents[1]/'incremental/round-trips/target/rally-render.su').read_text()
    oldentry=next(int(line.split('\t')[1]) for line in old.splitlines() if ':vdplet_entry\t' in line)
    (HERE/'STACK-OPTIMIZED.txt').write_text(text)
    result=dict(schema='rally.aff03.compiled-module-stack.v1',passed=True,
        object_matches_actual_target=True,object_sha256=sha(work/'stack.o'),
        all_compiler_frames_static=True,no_recursion=True,frames=frames,call_graph=graph,
        conservative_module_path_bytes=n,maximum_path=path,declared_module_stack=2048,
        prepared_entry_frame=frames['vdplet_entry'],control_entry_frame=oldentry,
        entry_frame_delta=frames['vdplet_entry']-oldentry,
        sdk_indirect_call_sites=indirect,external_sdk_interrupt_and_caller_frames_excluded=True,
        target_loader_and_new_stack_watermark_not_yet_observed=True,
        optimized_dump_sha256=sha(dump),stack_usage_sha256=sha(su),compile_command=command)
    (HERE/'STACK-AUDIT.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({k:result[k] for k in ('passed','object_matches_actual_target','conservative_module_path_bytes','maximum_path','entry_frame_delta','external_sdk_interrupt_and_caller_frames_excluded')},indent=2))


if __name__=='__main__':audit()
