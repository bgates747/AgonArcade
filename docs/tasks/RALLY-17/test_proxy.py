"""Check sink boundary with a fake VDP, including exact bytes and CTS."""
import ctypes,json,os,subprocess,tempfile,time
from pathlib import Path
TASK=Path(__file__).resolve().parent
if os.environ.get('RALLY_PROXY_CHILD'):
    lib=ctypes.CDLL(str(TASK/'.work/vdp_rally_sink.so'))
    fake=ctypes.CDLL(os.environ['RALLY_STOCK_VDP'])
    lib.z80_uart0_is_cts.restype=ctypes.c_bool
    lib.vdp_setup()
    lib.z80_send_to_vdp(7)
    assert fake.sent()==1 and not lib.z80_uart0_is_cts()
    d=Path(os.environ['RALLY_SINK_DIR']);(d/'start.snk').touch()
    def wait(name):
        end=time.monotonic()+5
        while not (d/name).exists():
            assert time.monotonic()<end
            time.sleep(.002)
    wait('go.snk');sink=os.environ['RALLY_SINK_MODE']=='sink'
    assert lib.z80_uart0_is_cts()==sink
    data=bytes(range(256))*4
    for b in data:lib.z80_send_to_vdp(b)
    (d/'done.snk').touch();wait('stop.snk')
    h=14695981039346656037
    for b in data:h=((h^b)*1099511628211)&((1<<64)-1)
    assert json.loads((d/'sink.json').read_text())==dict(bytes=len(data),fnv1a64=f'{h:016x}',discard=sink)
    assert fake.sent()==(1 if sink else 1025)
    assert not lib.z80_uart0_is_cts()
    lib.z80_send_to_vdp(9);assert fake.sent()==(2 if sink else 1026)
else:
    import sys
    with tempfile.TemporaryDirectory(dir=TASK/'.work') as temp:
        d=Path(temp);src=d/'fake.cpp';so=d/'fake.so'
        src.write_text('extern "C" { static int n; void vdp_setup(){} void z80_send_to_vdp(unsigned char){++n;} bool z80_uart0_is_cts(){return false;} int sent(){return n;} }')
        subprocess.run(['clang++','-dynamiclib',str(src),'-o',str(so)],check=True)
        for mode in ('sink','count'):
            case=d/mode;case.mkdir()
            subprocess.run([sys.executable,__file__],env=os.environ|dict(RALLY_PROXY_CHILD='1',RALLY_STOCK_VDP=str(so),RALLY_SINK_DIR=str(case),RALLY_SINK_MODE=mode),check=True)
    print('Proxy sink and passthrough tests passed')
