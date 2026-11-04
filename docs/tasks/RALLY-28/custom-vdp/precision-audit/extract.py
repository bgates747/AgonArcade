from pathlib import Path
import json,hashlib,re,struct,collections
root=Path('/Agon/mystuff/AgonArcade');p=root/'docs/tasks/RALLY-28/custom-vdp/precision-audit';n=p.parent/'native-state';d=p.parent/'direct-rows'
files=[n/'source/checked.c',n/'source/helper/render_core.inc',n/'source/helper/sprite.inc',n/'source/helper/rally_render.c',n/'source/helper/rally_render.h',n/'source/helper/road_rows.inc',d/'source/rows/checked.c',n/'build/rally-state.elf',n/'build/rally-state.map',n/'build/rally-state.json',n/'build/rally-state.disassembly.txt',d/'build-r02/rows/rally-render.elf',d/'build-r02/rows/rally-render.map',d/'build-r02/rows/rally-render.json',d/'build-r02/rows/rally-render.disassembly.txt',n/'guest-coarse/bin/probe.map',n/'guest-coarse/bin/probe.bin',d/'guest/bin/probe.map',d/'guest/bin/probe.bin',d/'sdk/tools/build_module.py',n/'guest-coarse/src/main.cpp',n/'guest-coarse/include/native.hpp',n/'guest-coarse/include/presentation-functions.inc',root/'rally-production/include/road.hpp',root/'rally-production/include/lookup_road.hpp',root/'rally-production/include/lookup_format.hpp',root/'rally-production/include/vehicle.hpp',root/'rally-production/include/scenery.hpp',root/'rally-game/include/rules.hpp',root/'rally-game/include/engine.hpp',n/'olimex01/REPORT.json',n/'REPORT.json']
files += [n/'hardware-kit/baseline/assets.vdu',root/'rally-game/include/race_traffic.hpp',root/'rally-game/include/routes_data.hpp',n/'guest-coarse/Makefile',n/'GUEST-BUILD.txt']
evidence={'files':{str(f.relative_to(root)):{'bytes':f.stat().st_size,'sha256':hashlib.sha256(f.read_bytes()).hexdigest()} for f in files}}
ops={}
for arm,file in [('baseline',d/'build-r02/rows/rally-render.disassembly.txt'),('native_state_and_coarse',n/'build/rally-state.disassembly.txt')]:
 counts=collections.Counter();by=collections.defaultdict(collections.Counter);sym='?'
 for line in file.read_text().splitlines():
  h=re.match(r'^([0-9a-f]+) <([^>]+)>:',line)
  if h:sym=h[2]
  m=re.match(r'^\s*[0-9a-f]+:\s+[0-9a-f]+\s+([a-z][a-z0-9.]*)\s',line)
  if m:counts[m[1]]+=1;by[sym][m[1]]+=1
 selected=('mull','mulsh','muluh','quos','quou','rems','remu','float.s','ufloat.s','trunc.s','utrunc.s','add.s','sub.s','mul.s','madd.s','msub.s')
 ops[arm]={'static_instruction_sites':{op:counts[op]for op in selected},'selected_sites_by_symbol':{s:{op:c[op]for op in selected if c[op]}for s,c in by.items()if any(c[op]for op in selected)},'external_arithmetic_symbols':sorted(set(re.findall(r'<(__[^>]+)>',file.read_text()))),'meaning':'Static opcode sites, not dynamic execution/time. Inline body sites attributed to surviving containing symbol.'}
evidence['retained_opcodes']=ops
b=(n/'hardware-kit/baseline/assets.vdu').read_bytes();at=0;blocks=[]
while at<len(b):
 assert b[at:at+3]==bytes([23,0,160])and int.from_bytes(b[at+3:at+5],'little')==50300
 op=b[at+5]
 if op==0:
  size=int.from_bytes(b[at+6:at+8],'little');blocks.append(b[at+8:at+8+size]);at+=8+size
 else:assert op in(2,14);at+=6
assert at==len(b)
a=b''.join(blocks);off=14;assert len(a)==149518 and a[:4]==b'R24T'

records=[]
for i in range(10):
 id,w,count,start,size=struct.unpack_from('<HHIII',a,32+i*16);records.append(dict(id=id,width=w,count=count,offset=start,bytes=size))
z=records[0];co=list(struct.iter_unpack('<hhihh',a[z['offset']:z['offset']+z['bytes']]))
mins=[min(row[i]for row in co)for i in range(5)];maxs=[max(row[i]for row in co)for i in range(5)]
t=records[1];track=list(struct.iter_unpack('<hhhh',a[t['offset']:t['offset']+t['bytes']]))
# Independent interval bound, no candidate evaluation and no exhaustive pose run.
f=4095;ff=4094;q=128
boundA=max(abs(row[0])*4+abs(row[1])*f//4096+1 for row in co)
boundB=max(abs(row[2])+abs(row[3])*f//4096+abs(row[4])*ff//4096+2 for row in co)
evidence['literal_asset_ranges']=dict(asset_offset_in_first_vdu_block=off,vdu_block_lengths=list(map(len,blocks)),asset_bytes=len(a),tables=records,coefficients=dict(count=len(co),minimum=mins,maximum=maxs),track_component_minimum=[min(row[i]for row in track)for i in range(4)],track_component_maximum=[max(row[i]for row in track)for i in range(4)],conservative_center_bounds=dict(abs_A=boundA,abs_B=boundB,abs_B_times_q=boundB*q,abs_centerQ8=boundA+boundB*q//16+1),derivation='Static table extrema/interval arithmetic; no application, simulator, compiler, test or renderer executed.')
evidence['steering_sign_extension_witness']=dict(source='native-state/source/checked.c signed16 helper + native_validate renderSteering',stored_signed16=-21,cast_uint32=4294967275,cast_int32=-21,helper_subtract=65536,helper_result=-65557,valid_zero_extended_input=65515,correct_result=-21,kind='Static C value-flow calculation, not a new runtime test',fixture_steering=0)
(p/'EVIDENCE.json').write_text(json.dumps(evidence,indent=2)+'\n')
print(json.dumps({'opcodes':{k:v['static_instruction_sites'] for k,v in ops.items()},'asset_ranges':evidence['literal_asset_ranges']},indent=2))
