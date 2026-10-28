"""Synthetic decoder rejection and wrap tests, not target timing measurements."""
import json
import struct
from phase_shared import HERE,HEADER,ROW
from phase_verify import decode


def checks():
    source=HERE/'.work/phase-host-control-ordinary.bin'
    data=source.read_bytes();frames=(len(data)-HEADER)//ROW
    assert decode(data,frames)['frames']==frames
    passed=['valid_host_stub_records']
    def rejected(name,change):
        altered=bytearray(data);change(altered)
        try:decode(altered,frames)
        except (AssertionError,struct.error):passed.append(name)
        else:raise AssertionError('Accepted corrupt diagnostic: '+name)
    rejected('incomplete_count',lambda b:struct.pack_into('<H',b,10,frames-1))
    rejected('bad_row_bytes',lambda b:struct.pack_into('<H',b,6,ROW-4))
    rejected('zero_counter_progress',lambda b:struct.pack_into('<I',b,16,0))
    rejected('stale_frame',lambda b:struct.pack_into('<I',b,HEADER,2))
    rejected('nested_time_exceeds_parent',lambda b:struct.pack_into('<I',b,HEADER+2*4,1))
    rejected('zero_stage_interval',lambda b:struct.pack_into('<I',b,HEADER+7*4,struct.unpack_from('<I',b,HEADER+6*4)[0]))
    rejected('ambiguous_stage_interval',lambda b:struct.pack_into('<I',b,HEADER+7*4,(struct.unpack_from('<I',b,HEADER+6*4)[0]+0x80000000)&0xffffffff))
    wrap=bytearray(data)
    for i in range(7):struct.pack_into('<I',wrap,HEADER+(6+i)*4,(0xffffffe0+i*17)&0xffffffff)
    assert decode(wrap,frames)['rows'][0]['road_dispatch_draw_and_flush']==17
    passed.append('single_wrap_delta')
    result=dict(cases=len(passed),passed=passed,synthetic_only=True,emulator_run=False)
    (HERE/'phase_VERIFY-tests.json').write_text(json.dumps(result,indent=2)+'\n')
    print('PASS',len(passed),'synthetic decoder cases; no timing claim')


if __name__=='__main__':checks()
