"""RALLY-24 ABI1 serializer and resident wrappers; no device/network access."""
import struct
ARGS,STATE,ASSETS,STATUS,ROAD,ACTORS,PLAYER,PREPARE = range(31001,31009)
DRAW=(31009,31010,31011)
def word(n): return struct.pack('<H',n)
def command(id,op): return b'\x17\0\xa0'+word(id)+bytes((op,))
def arguments(session,identity):
    if not 0<session<=0xffffffff:raise ValueError('nonzero u32 session required')
    return struct.pack('<4sHHI6HII',b'R24A',1,32,session,STATE,ASSETS,STATUS,ROAD,ACTORS,PLAYER,identity,0)
def frame(session,sequence,tick,station,phase,steering,lateral,flags=1,crash=0,invulnerable=0,cars=()):
    if not 0<session<=0xffffffff or not 0<sequence<=0xffffffff:raise ValueError('nonzero u32 session/sequence required')
    if not (0<=phase<8000 and -21<=steering<=21 and -38400<=lateral<=38400 and 0<=flags<8 and 0<=crash<=150 and 0<=invulnerable<=120):raise ValueError('state out of range')
    if len(cars)>6:raise ValueError('six stable car slots maximum')
    b=bytearray(struct.pack('<4sHHIIIiHhiHHHH',b'R24S',1,112,session,sequence,tick,station,phase,steering,lateral,flags,crash,invulnerable,0))
    for i in range(6):
        if i>=len(cars) or cars[i] is None:b+=bytes(12)
        else:
            position,offset,heading=cars[i]
            if not (-14260<=offset<=14260 and -1920<=heading<=1920):raise ValueError('car lateral out of range')
            b+=struct.pack('<iihBB',position,offset,heading,1,0)
    assert len(b)==112
    return bytes(b)
def run(handle,entry=1):
    if not 0<handle<65535:raise ValueError('live runtime handle required')
    payload=struct.pack('<BBHBBHHH',1,2,0,0,0,handle,entry,ARGS)
    return b'\x17\0\xd8'+word(len(payload))+payload
def wrappers(handle):
    # Clear readiness even if silent RUN fails before entering the native module.
    result={PREPARE:command(STATUS,5)+b'\x02'+word(0)+b'\0'+run(handle)}
    for wrapper,target in zip(DRAW,(ROAD,ACTORS,PLAYER)):
        result[wrapper]=command(target,6)+b'\x02'+word(STATUS)+word(0)+b'\x01'
    return result
def submit_parts(state):
    if len(state)!=112:raise ValueError('112-byte state required')
    # Caller inserts scenery/viewport/HUD around these ordered pieces.
    update=command(STATE,5)+b'\xc2'+word(0)+word(112)+state
    return (update+command(PREPARE,1),*(command(w,1) for w in DRAW))
