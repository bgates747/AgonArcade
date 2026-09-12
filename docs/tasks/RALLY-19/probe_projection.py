"""Compare VDP evaluation of real compact track records to accepted C++ oracle.

The candidate retains fractionQ14/fractionQ12/squareQ12, but defers b/d/e and
final Q8 truncations. Those four errors total <(2+q/8)/256 <=0.0703125 pixel;
allow 0.075 pixel including bounded float32 roundoff. Rounded endpoints must
still differ by <=1 pixel. This is a numeric construction test, not road pixels.
"""
import argparse,json,struct,subprocess,hashlib
from native_run import execute,GOLEM
from profile import TASK
from build_projection_kernel import build
from probe_admission import update,CALL

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');a=p.parse_args()
    source=build(a.track,TASK/'.work/projection-source')
    count=90 if a.track=='oval' else 512;lap=count*6400
    fixed=json.loads((TASK/'fixtures.json').read_text())['cases']+json.loads((TASK/'fixtures-bends.json').read_text())['cases']
    positions=sorted({p['player']['position'] for p in fixed if p['track']==a.track}|{0,1,24,25,99,100,6399,6400,6401,65535,131071,lap-6401,lap-6400,lap-1})
    queries=[(pos,row) for pos in positions for row in [103,104,116,160,200,224]]
    assert len(queries)<=512
    reference=TASK/'.work/projection_reference'
    command=['g++','-std=c++17','-O2','-Wall','-Wextra','-Werror','-I',str(TASK/'.work/oracle/include'),str(TASK/'projection_reference.cpp'),'-o',str(reference)]
    subprocess.run(command,check=True)
    ref=subprocess.check_output([str(reference),a.track,str(TASK.parent/'RALLY-18/data'/(a.track+'.road'))],input=''.join(f'{pos} {row}\n' for pos,row in queries).encode()).decode().splitlines()
    wanted=[tuple(map(int,line.split())) for line in ref];assert len(wanted)==len(queries)
    data=bytearray(b'G19A'+struct.pack('<H',len(queries)))
    for pos,row in queries:
        wire=update(struct.pack('<ih',pos,row))+CALL;data+=struct.pack('<BHH',0,len(wire),0)+wire
    root,raw=execute('golem-projection',a.name,source,data)
    (root/'reference-build.json').write_text(json.dumps({'command':command,'source_sha256':hashlib.sha256((TASK/'projection_reference.cpp').read_bytes()).hexdigest(),'executable_sha256':hashlib.sha256(reference.read_bytes()).hexdigest()},indent=2)+'\n')
    assert len(raw)==96*len(queries)
    coefficients=list(struct.iter_unpack('<hhihh',(TASK.parent/'RALLY-18/data'/(a.track+'.road')).read_bytes()[64:]))
    results=[]
    for i,((pos,row),(q8,pixel)) in enumerate(zip(queries,wanted)):
        values=struct.unpack_from('<6HhHhhihh',raw,i*96)
        interval,local,f14,f12,square,k,actualPixel,rowIndex,*record=values
        flags=struct.unpack_from('<3H',raw,i*96+80);centre=struct.unpack_from('<f',raw,i*96+92)[0]
        wantLocal=pos%6400;want14=(wantLocal//100)*256+(wantLocal%100)*256//100;want12=want14//4;wantSquare=want12*want12//4096;wantK=(want14+2048000//(row-96))//16384
        integers=(interval,local,f14,f12,square,k,rowIndex)==(pos//6400,wantLocal,want14,want12,wantSquare,wantK,row-103)
        selected=tuple(record)==coefficients[(pos//6400)*19+wantK]
        error=abs(centre-q8/256);pixelError=abs(actualPixel-pixel)
        results.append({'position':pos,'row':row,'integer_stages':values[:6],'integer_stages_pass':integers,'selected_record':record,'selected_record_pass':selected,'flags':flags,'native_centre':centre,'oracle_q8':q8,'oracle_pixel':pixel,'native_pixel':actualPixel,'float_pixel_error':error,'endpoint_pixel_error':pixelError,'pass':integers and selected and flags==(1,1,1) and error<=.075 and pixelError<=1})
    passed=all(r['pass'] for r in results)
    (root/'results.json').write_text(json.dumps({'pass':passed,'scope':__doc__,'track':a.track,'cases':len(results),'maximum_float_pixel_error':max(r['float_pixel_error'] for r in results),'maximum_endpoint_pixel_error':max(r['endpoint_pixel_error'] for r in results),'results':results},indent=2)+'\n')
    assert passed,[r for r in results if not r['pass']][:8]
    print('Real coefficient VDP projection:',a.track,len(results),'cases pass; max error',max(r['float_pixel_error'] for r in results),'pixel')
if __name__=='__main__':main()
