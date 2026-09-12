"""Passive ESP32 UART0 capture; no serial commands or intentional reset pulses."""
import argparse,json,time
from pathlib import Path
import serial
from profile import TASK

def main():
 p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--seconds',type=float,default=600);a=p.parse_args()
 root=TASK/'evidence/hardware-production'/a.name;root.mkdir(parents=True,exist_ok=True)
 raw=root/'serial.bin';assert not raw.exists(), 'Preserve prior captures'
 stop=TASK/'.work'/('serial-stop-'+a.name);assert not stop.exists()
 device=Path('/dev/serial/by-id/usb-1a86_USB_Serial-if00-port0');assert device.exists()
 s=serial.Serial(port=None,baudrate=115200,timeout=.2);s.dtr=False;s.rts=False;s.port=str(device);s.open()
 start=time.monotonic()
 (root/'capture.json').write_text(json.dumps({'device':str(device),'resolved':str(device.resolve()),'baud':115200,'dtr':False,'rts':False,'intent':'passive UART0 logging; opening a serial driver can still affect hardware control lines','started_utc':time.strftime('%Y-%m-%dT%H:%M:%SZ',time.gmtime()),'stop_file':str(stop)},indent=2)+'\n')
 print('ESP32 serial capture armed:',a.name,flush=True)
 try:
  with raw.open('wb') as f,(root/'serial-chunks.jsonl').open('w') as timing:
   while time.monotonic()-start<a.seconds and not stop.exists():
    b=s.read(8192)
    if b:
     offset=f.tell();f.write(b);f.flush();timing.write(json.dumps({'seconds':time.monotonic()-start,'offset':offset,'bytes':len(b)})+'\n');timing.flush()
     print(b.decode('utf8','backslashreplace'),end='',flush=True)
 finally:s.close()
 print('\nCapture closed.',flush=True)
if __name__=='__main__':main()
