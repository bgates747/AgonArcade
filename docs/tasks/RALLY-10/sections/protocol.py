"""Draft stock-VDP section program. Generates raw VDU streams; not yet VDP-qualified.

Run with the repository .venv/bin/python. No mainline source or emulator changes.
"""
from pathlib import Path
import struct

PARAM,VECTOR,COEFFICIENTS,PRODUCT,TRANSFORM,RED,WHITE,OUTPUT,DRAW_RED,DRAW_WHITE=range(30000,30010)

def word(value):
    return struct.pack('<H',value & 0xffff)

def command(buffer,operation):
    return bytes((23,0,0xa0))+word(buffer)+bytes((operation,))

def block(buffer,data):
    return command(buffer,0)+word(len(data))+data

def matrix(buffer,rows,columns,values):
    assert len(values)==rows*columns
    return command(buffer,34)+bytes((0,rows,columns,0))+struct.pack('<'+'f'*len(values),*values)

def strip(left,right,colour):
    data=bytes((18,0,colour))
    for operation,u,v in ((4,left,0),(4,right,0),(0x55,left,1),(0x55,right,1)):
        # Command 41 turns this into PLOT x;y; followed by two VDU 0 bytes.
        data+=bytes((25,operation))+word(u)+word(v)+word(u*v)
    assert len(data)==35
    return data

def section_program(template):
    data=command(VECTOR,34)+bytes((0x20,5,1,0xc0))+word(PARAM)+word(0)
    data+=command(PRODUCT,34)+bytes((6,8,1))+word(COEFFICIENTS)+word(VECTOR)
    data+=command(TRANSFORM,5)+bytes((0xe2,))+word(0)+word(32)+word(PRODUCT)+word(0)
    data+=command(OUTPUT,41)+bytes((0x4e,0xc0))+word(TRANSFORM)+word(template)+word(5)+word(8)+word(4)
    data+=command(OUTPUT,1)
    return data

def startup():
    # P = [centreTop, centreBottom, yTop, yBottom, 1].
    # Multiplication yields the first two rows of the section transform.
    coefficients=[
        0,0,1/50,0,-96/50,
        -1,1,0,0,0,
        0,0,-1/50,1/50,0,
        1,0,0,0,0,
        0,0,0,0,0,
        0,0,-1,1,0,
        0,0,0,0,0,
        0,0,1,0,0,
    ]
    data=bytes((23,0,0xf8))+word(1)+word(1)
    for buffer in range(PARAM,DRAW_WHITE+1): data+=command(buffer,2)
    data+=block(PARAM,bytes(8)+word(1))
    data+=matrix(COEFFICIENTS,8,5,coefficients)
    # Third output coordinate must stay zero; fourth homogeneous value is one.
    data+=matrix(TRANSFORM,4,4,[0]*15+[1])
    for template,painted in ((RED,True),(WHITE,False)):
        strips=[(-106,106,9 if painted else 15),(-90,90,8),
                (-86,-84,11 if painted else 15),(84,86,11 if painted else 15)]
        if painted: strips.append((-2,2,11))
        for left,right,colour in strips: data+=block(template,strip(left,right,colour))
    data+=block(DRAW_RED,section_program(RED))
    data+=block(DRAW_WHITE,section_program(WHITE))
    return data

def draw_section(centre_top,centre_bottom,y_top,y_bottom,painted):
    assert 104<=y_top<y_bottom<=224
    values=(centre_top,centre_bottom,y_top,y_bottom)
    assert all(-32768<=value<=32767 for value in values)
    # Eight data bytes; 11 bytes of buffer-adjust framing, then a 6-byte call.
    return (command(PARAM,5)+bytes((0xc2,))+word(0)+word(8)
            +b''.join(word(value) for value in values)
            +command(DRAW_RED if painted else DRAW_WHITE,1))

if __name__=='__main__':
    output=Path(__file__).resolve().parent/'.work';output.mkdir(exist_ok=True)
    initial=startup();sample=draw_section(140,180,116,160,True)
    (output/'startup.vdu').write_bytes(initial)
    (output/'sample-section.vdu').write_bytes(sample)
    print(f'Draft generated: startup {len(initial)} bytes; one section {len(sample)} UART bytes.')
    print('Source/API checked only; no emulator or hardware qualification yet.')
