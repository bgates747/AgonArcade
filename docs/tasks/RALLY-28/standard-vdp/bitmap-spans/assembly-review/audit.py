"""Emit same-flags assembly for sample and unchanged game; no game linking/run."""
from pathlib import Path
import os,subprocess,shlex,hashlib,json,re,importlib.util,shutil
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5];SAMPLE=HERE.parent/'SPAN-001-03';WORK=HERE/'.work';E=HERE/'evidence'
SDK=Path('/Agon/agondev/release');CC=SDK/'bin/ez80-none-elf-clang';COPY=SDK/'bin/ez80-none-elf-objcopy'
sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
commands=[]
def run(args,cwd=ROOT):
 args=list(map(str,args));r=subprocess.run(args,cwd=cwd,env=dict(os.environ,PATH=str(SDK/'bin')+':'+os.environ['PATH']),capture_output=True,text=True)
 commands.append({'argv':args,'cwd':str(cwd),'returncode':r.returncode,'stderr':r.stderr})
 if r.returncode:raise RuntimeError(r.stderr)
 return r.stdout
WORK.mkdir(exist_ok=True);E.mkdir(exist_ok=True)
protected=[p for base in ('rally-game','rally-production') for p in (ROOT/base).rglob('*') if p.is_file() and '.work' not in p.parts]
before={str(p.relative_to(ROOT)):sha(p) for p in protected}
old=WORK/'baseline/src';old.mkdir(parents=True,exist_ok=True)
for name in ('main.cpp','generated.hpp'):
 (old/name).write_text(run(['git','show','50acc3c:docs/tasks/RALLY-28/standard-vdp/bitmap-spans/SPAN-001-03/src/'+name]))
module_path=ROOT/'docs/tasks/RALLY-28/research/audit_hot_loop.py';spec=importlib.util.spec_from_file_location('old_audit',module_path);audit=importlib.util.module_from_spec(spec);spec.loader.exec_module(audit)
reports={}
for label,cwd,source,existing in [('sample',SAMPLE/'.work','src/main.cpp',SAMPLE/'.work/obj/main.o'),('sample-before',SAMPLE/'.work',str(old/'main.cpp'),None),('game',ROOT/'rally-game','src/main.cpp',ROOT/'rally-game/obj/main.o')]:
 dry=run(['make','-n','-B','obj/main.o','V='],cwd)
 command=next(shlex.split(l) for l in dry.splitlines() if l.startswith(str(CC)+' '))
 command=command[:command.index('src/main.cpp')]+[source]
 out=E/(label+'.s');annotated=E/(label+'-lines.s')
 run([*command,'-S','-fverbose-asm','-o',out],cwd)
 run([*command,'-S','-fverbose-asm','-gline-tables-only','-o',annotated],cwd)
 run([*command,'-S','-emit-llvm','-o',E/(label+'.ll')],cwd)
 run([*command,'-c','-o',WORK/(label+'.o')],cwd)
 run([*command,'-gline-tables-only','-c','-o',WORK/(label+'-debug.o')],cwd)
 for tag,obj in [('ordinary',WORK/(label+'.o')),('debug',WORK/(label+'-debug.o')),*([('existing',existing)] if existing else [])]:
  run([COPY,'-O','binary','--only-section=.text',obj,WORK/(label+'-'+tag+'.text')])
 text=(WORK/(label+'-ordinary.text')).read_bytes()
 same_debug=text==(WORK/(label+'-debug.text')).read_bytes()
 same_existing=text==(WORK/(label+'-existing.text')).read_bytes() if existing else None
 assert same_existing is not False,(label,'existing object text differs')
 functions=audit.assembly_inventory(out)
 debug_sections=run([SDK/'bin/ez80-none-elf-readelf','-S',WORK/(label+'-debug.o')])
 reports[label]={'ir_sha256':sha(E/(label+'.ll')),'debug_sections_present':'.debug_' in debug_sections,'debug_text_bytes':(WORK/(label+'-debug.text')).stat().st_size,'compile_argv':command,'assembly_sha256':sha(out),'line_assembly_sha256':sha(annotated),'debug_text_matches_ordinary':same_debug,'text_matches_existing':same_existing,'text_bytes':len(text),'object_sha256':sha(WORK/(label+'.o')),'functions':functions,'line_directives':annotated.read_text().count('\t.loc\t'),'verbose_comments':out.read_text().count(';')}
 # Retain raw output; do not invent missing source-line annotations.
for p in protected:assert sha(p)==before[str(p.relative_to(ROOT))],p
# Array's object .data offset and final binary contents prove static writable initialization.
nm=run([SDK/'bin/ez80-none-elf-nm','-S',SAMPLE/'.work/obj/main.o'])
m=re.search(r'^([0-9a-f]+) d __ZL11RoadCommand$',nm,re.M);assert m;offset=int(m[1],16)
run([COPY,'-O','binary','--only-section=.data',SAMPLE/'.work/obj/main.o',WORK/'sample.data'])
initial=(SAMPLE/'INITIAL-COMMAND.bin').read_bytes();assert (WORK/'sample.data').read_bytes()[offset:offset+737]==initial
mapping=(SAMPLE/'.work/bin/spans.map').read_text();m=re.search(r' \.data\s+(0x[0-9a-f]+)\s+0x[0-9a-f]+ obj/main.o',mapping);assert m
address=int(m[1],16)+offset;binary=(SAMPLE/'.work/bin/spans.bin').read_bytes();assert binary[address-0x40000:address-0x40000+737]==initial
for section in ('init_array','ctors','dtors','fini_array'):
 m=re.search(r'^\.'+section+r'\s+0x[0-9a-f]+\s+(0x[0-9a-f]+)',mapping,re.M);assert m and int(m[1],16)==0
shutil.copyfile(SAMPLE/'.work/bin/spans.map',E/'sample.map')
result={'compiler_version':run([CC,'--version']),'compiler_sha256':sha(CC),'library_sha256':sha(SDK/'lib/libagon.a'),'makefile_sha256':sha(SDK/'config/makefile.inc'),'base_commit':run(['git','rev-parse','HEAD']).strip(),'protected_files':len(before),'protected_unchanged':True,'protected_sha256':before,'array':{'section':'.data','bytes':737,'address':hex(address),'initial_bytes_match_binary':True,'empty_ctor_tables':True},'reports':reports,'commands':commands,'source_sha256':{str(p.relative_to(ROOT)):sha(p) for p in [SAMPLE/'src/main.cpp',SAMPLE/'src/generated.hpp',SAMPLE/'generate.py',ROOT/'rally-game/src/main.cpp']}}
(E/'AUDIT.json').write_text(json.dumps(result,indent=2)+'\n');print(json.dumps({'array':result['array'],'protected_files':len(before),'reports':{k:{n:v[n] for n in ('debug_text_matches_ordinary','text_matches_existing','text_bytes','line_directives','verbose_comments')} for k,v in reports.items()}},indent=2))
