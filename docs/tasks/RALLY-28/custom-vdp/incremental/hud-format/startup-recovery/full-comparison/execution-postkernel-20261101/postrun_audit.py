from pathlib import Path
import json,hashlib,struct,importlib.util,collections,sys
root=Path('/Agon/mystuff/AgonArcade');f=root/'docs/tasks/RALLY-28/custom-vdp/incremental/hud-format/startup-recovery/full-comparison';d=f/'execution-postkernel-20261101';e=f/'evidence/hud900abba01';sha=lambda p:hashlib.sha256(p.read_bytes()).hexdigest()
def load(name,p):
 s=importlib.util.spec_from_file_location(name,p);m=importlib.util.module_from_spec(s);s.loader.exec_module(m);return m
raw=load('postkernel_raw',f.parents[1].parent/'round-trips/raw_audit.py')
reader=load('postkernel_reader',f.parent/'observer-integration/vendor/read_record.py')
control=e/'control1';failed=e/'cached1'
for n in ['full-audit.json','verified.json']:assert (control/n).read_bytes()==(root/'.work/hud900abba01-offline-recheck/control1'/n).read_bytes(),n
(d/'OFFLINE-RECHECK.json').write_text(json.dumps(dict(passed=True,control_audit_identical=True,control_verified_identical=True,release_before_offline_audit=True),indent=2)+'\n')
obs={case:reader.analyze((e/case/'sender-progress.jsonl').read_bytes()) for case in ['control1','cached1']}
assert obs['cached1']['window_complete'] and obs['cached1']['completed_sends_unchanged']
(d/'OBSERVER-ANALYSIS.json').write_text(json.dumps(obs,indent=2)+'\n')
tx,packets,generic=raw.backend(failed);assert len(tx)==241988 and len(packets)==1;assert struct.unpack('<4sBBHH',packets[0])==(b'VDPL',1,2,1,1)
r=json.loads((failed/'run.json').read_text());profiles=json.loads((f/'PROFILES.json').read_text());assert raw.identities(r['runtime_identities'])==profiles['cached1']['input_sha256'];assert r['process_exit']==0 and r['result'] is None
for n in ['result.json','state.bin','ticks.bin','prt.bin','failure.txt','replies.bin']:assert not (failed/n).exists(),n
assets=(f.parents[1]/'fixtures/cached/assets.vdu').read_bytes();art=(f.parents[1]/'fixtures/cached/artwork.vdu').read_bytes();asset_at=tx.index(assets);assert tx.count(assets)==1;art_at=asset_at+len(assets);part=tx[art_at:];assert art.startswith(part)
# Parse commands while skipping opaque declared payloads, never scan pixels for opcodes.
at=0;boundary=None
while at<len(art):
 start=at
 if art[at:at+3]==b'\x17\0\xa0':
  key,op=struct.unpack_from('<HB',art,at+3);at+=6;row=dict(buffer=key,opcode=op)
  if op==2:pass
  elif op==0:
   n=struct.unpack_from('<H',art,at)[0];at+=2;row.update(payload_bytes=n,payload_offset=at);at+=n
  elif op==72:
   opt=art[at];assert opt in (4,16);at+=3+(2 if opt==16 else 16)
  elif op==32:
   sub=art[at];assert sub in (0,11);at+=1+(13 if sub==11 else 0)
  else:raise AssertionError((key,op,start))
 elif art[at:at+3]==b'\x17\x1b\0':row=dict(bitmap_select=art[at+3]);at+=4
 elif art[at:at+3]==b'\x17\x1b\x21':row=dict(bitmap_create=list(struct.unpack_from('<HHB',art,at+3)));at+=8
 elif art[at:at+3]==b'\x17\0\xf8':assert art[at:at+7]==b'\x17\0\xf8\1\0\1\0';row=dict(affine_feature_enable=True);at+=7
 elif art[at]==17:row=dict(colour=art[at+1]);at+=2
 else:raise AssertionError((start,art[start:start+20].hex()))
 if start<=len(part)<at:
  boundary=dict(art_offset=start,absolute_uart_offset=art_at+start,command_bytes=at-start,captured_command_bytes=len(part)-start,remaining_command_bytes=at-len(part),**row)
assert at==len(art) and boundary
rows=json.loads((f/'EXPECTED-PROTOCOL.json').read_text())['requests']
for row in rows[1:]:assert raw.request(row['operation'],row['token'],bytes.fromhex(row['fields_hex'])) not in tx, row['token']
failed_result=dict(passed=True,qualification='Preserved failed startup only; no race FPS',outbound_bytes=len(tx),inbound_bytes=(failed/'vdp-to-mos.bin').stat().st_size,native_replies=1,native_load_handle=1,native_init_and_all_subsequent_requests_absent=True,asset_offset=asset_at,complete_asset_bytes=len(assets),art_offset=art_at,art_total_bytes=len(art),art_captured_bytes=len(part),art_missing_bytes=len(art)-len(part),boundary=boundary,host_process_seconds=r['host_seconds'],process_exit=r['process_exit'],guest_cleanup_verified=False,observer=obs['cached1'],enqueue_is_not_firmware_consumption=True,cause_unqualified=True)
(d/'FAILED-STARTUP-AUDIT.json').write_text(json.dumps(failed_result,indent=2)+'\n')
clocks={}
for n in ['ticks.bin','prt.bin']:
 data=(control/n).read_bytes();a=struct.unpack('<'+str(len(data)//4)+'I',data);delta=[(b-a)&0xffffffff for a,b in zip(a,a[1:])];clocks[n]=dict(samples=len(a),first=a[0],last=a[-1],elapsed=(a[-1]-a[0])&0xffffffff,per_frame_distribution=dict(collections.Counter(delta)))
clocks.update(nominal_MOS_to_PRT_fps_ratio=60/(900/25.647),calibrated_physical_FPS_claim=False,clock_discrepancy_cause='Unqualified; no change to frozen audit/report or target rerun')
(d/'CLOCK-OBSERVATIONS.json').write_text(json.dumps(clocks,indent=2)+'\n')
print(json.dumps(dict(failed=failed_result,clocks=clocks),indent=2))
