"""Compile game packets through the actual P4 receiver and host decoder."""
import argparse,json,struct,subprocess,sys,tempfile,zlib
from pathlib import Path
p=argparse.ArgumentParser();p.add_argument('--extender',type=Path,required=True);a=p.parse_args()
root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(a.extender/'scripts'))
from rally_race import decode
with tempfile.TemporaryDirectory(prefix='rally-packet-') as tmp:
    exe=Path(tmp)/'packet-test'
    subprocess.run(['c++','-std=c++17','-Wall','-Wextra','-Werror','-fsanitize=address,undefined',
        '-I'+str(root/'include'),'-I'+str(root.parent/'rally-production/include'),
        '-I'+str(a.extender/'vdp/video/extender/telemetry'),
        str(root/'tests/host_telemetry_test.cpp'),'-o',str(exe)],check=True)
    packets=subprocess.check_output([str(exe)])
def reply(b,age=0):return {'online':True,'age_ms':age,'payload':b.hex()}
for i in range(11):
    b=packets[i*140:(i+1)*140];s,phase=decode(reply(b))
    assert phase==(i if i<10 else 6)
    assert len(s.traffic)==(1 if phase==6 else 0)
    assert bool(s.flags&1)==(i in (3,6))
def reject(b,age=0):
    try:decode(reply(b,age))
    except (RuntimeError,ValueError):return
    raise AssertionError('Invalid telemetry accepted')
for age in (300,9999):reject(packets[:140],age)
for offset,value in ((3,0x6d),(3,0xa1),(51,1),(79,1),(80,7),(96,1)):
    b=bytearray(packets[6*140:7*140]);b[offset]=value
    struct.pack_into('<I',b,136,zlib.crc32(b[:136]));reject(b)
b=bytearray(packets[:140]);b[10]^=1;reject(b)
print('Actual P4 receiver + all game phases + host bounds/assistance/expiry/CRC checks passed')
