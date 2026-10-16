"""Compare captured live command payloads to host geometry + independent serializer."""
from pathlib import Path
import json,struct,hashlib,gzip
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[5];word=lambda v:struct.pack('<H',v&65535);prefix=lambda i,op:bytes([23,0,160])+word(i)+bytes([op]);poses=json.loads((HERE/'HOST-POSES.json').read_text())
def blocks(data,prefix,partial=False):
 out=[];start=0;tail=None
 while True:
  at=data.find(prefix,start)
  if at<0:break
  n=int.from_bytes(data[at+len(prefix):at+len(prefix)+2],'little');body=data[at+len(prefix)+2:at+len(prefix)+2+n]
  if len(body)!=n:
   assert partial
   tail={'offset':at,'advertised_bytes':n,'received_bytes':len(body)};break
  out.append(body);start=at+len(prefix)+2+n
 return out,tail

def polygon(p):
 out=bytes([18,0,2,25,4,0,0,104,0,25,101,63,1,223,0]);edges=[-35,35,-29,29,-27,-25,25,27,-1,1];trunc=lambda n:(1 if n>=0 else -1)*(abs(n)//32)
 for i,mat in enumerate(p['materials']):
  y,yy=p['rows'][i:i+2];layers=5 if mat else 4;upper=(y-96)*106//50;lower=(yy-96)*106//50;top=p['centres'][y-104];bottom=p['centres'][yy-104]
  payload=b''.join(word(x) for layer in range(layers) for x in (top+trunc(edges[layer*2]*upper),top+trunc(edges[layer*2+1]*upper),bottom+trunc(edges[layer*2]*lower),bottom+trunc(edges[layer*2+1]*lower)))+word(y)+word(yy)
  out+=prefix(54000,5)+bytes([194])+word(0)+word(len(payload))+payload+prefix(54004 if mat else 54003,1)
 return out+bytes([18,0,0,25,4,0,0,224,0,25,101,63,1,239,0])
def raw(path):
 return path.read_bytes() if path.exists() else gzip.decompress(path.with_suffix(path.suffix+'.gz').read_bytes())
def verify(name,evidence=False,partial=False):
 p=HERE/'evidence'/name if evidence else ROOT/'.emulator'/name
 runtime=HERE/'evidence/runtime'/name/'last-run' if evidence else p/'last-run'
 identity=json.loads((p/'identity.json').read_text());v=identity['variant'];nframes=identity['frames'];expected_poses=[poses[i%128] for i in range(nframes)];data=raw(runtime/'mos-to-vdp.bin')
 if v in (1,2):
  planes,tail=blocks(data,prefix(55000,5)+bytes([194])+word(0),partial);assert len(planes)<=nframes
  if not partial:assert len(planes)==nframes
  for pose,actual in zip(expected_poses,planes):
   expected=b''.join(word(55100+int(y>=116 and ((800000//(y-96)+pose['phase'])%8000)<4000))+word(pose['centres'][y-104])+word(55200+y-104) for y in range(104,224));assert actual==expected,(v,pose['frame'])
  result={'frames_uploaded_verified':len(planes),'parameter_bytes_verified':len(planes)*720,'stream_sha256':hashlib.sha256(b''.join(planes)).hexdigest()}
 if v==0:
  commands,tail=blocks(data,prefix(56004,0),partial);assert len(commands)<=nframes+1 and len(commands[0])==1
  if not partial:assert len(commands)==nframes+1
  for pose,actual in zip(expected_poses,commands[1:]):assert actual==polygon(pose),pose['frame']
  result={'frames_uploaded_verified':len(commands)-1,'command_bytes_verified':sum(map(len,commands[1:]))}
 if tail:
  pose=expected_poses[result['frames_uploaded_verified']]
  expected=(b''.join(word(55100+int(y>=116 and ((800000//(y-96)+pose['phase'])%8000)<4000))+word(pose['centres'][y-104])+word(55200+y-104) for y in range(104,224)) if v in (1,2) else polygon(pose))
  assert tail['advertised_bytes']==len(expected)
  at=tail['offset']+(11 if v in (1,2) else 8)
  assert data[at:at+tail['received_bytes']]==expected[:tail['received_bytes']]
 result.update(planned_frames=nframes,partial_upload=tail,complete_frame_replies=raw(runtime/'vdp-to-mos-delivered.bin').count(bytes([128,1,232])),capture_sha256=hashlib.sha256(data).hexdigest(),evidence_only=partial)
 if not partial:assert result['complete_frame_replies']==nframes
 return result
if __name__=='__main__':
 import argparse
 a=argparse.ArgumentParser();a.add_argument('name');a.add_argument('--evidence',action='store_true');a.add_argument('--partial',action='store_true');x=a.parse_args()
 print(json.dumps(verify(x.name,x.evidence,x.partial),indent=2))
