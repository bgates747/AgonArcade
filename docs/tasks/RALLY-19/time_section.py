"""Serial ABBA comparison of one-band VDP construction choices.

Normal guest clock/UART; no observer interposer. One group is 16 finite resident
calls, observed by stock GP parser echo with 120Hz guest ticks. First 64 groups
warm resident data; then two identical 64-pose passes. This is construction cost,
not complete scene CPU work, frame rate, raster completion or R19-10 acceptance.
"""
import argparse,json,struct,statistics
from native_run import execute,GOLEM,sha
from profile import TASK
from build_section_kernel import build
from probe_section import queries

def main():
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('name');p.add_argument('--track',choices=['oval','fuji'],default='oval');a=p.parse_args()
    root=TASK/'evidence/golem-section-timing'/a.name;root.mkdir(parents=True,exist_ok=False)
    cases=queries(a.track);cases=[cases[i%len(cases)] for i in range(64)]
    data=b'G19T'+struct.pack('<H',64)+b''.join(struct.pack('<iH',*case) for case in cases)
    loader=TASK/'.work/section-timing-loader'/a.name;loader.mkdir(parents=True,exist_ok=False)
    (loader/'Makefile').write_text((GOLEM/'examples/native_admission/Makefile').read_text())
    (loader/'main.cpp').write_text((GOLEM/'examples/native_admission/main.cpp').read_text().replace('int main() {','int admission_main() {')+'\n'+(TASK/'section_timing.cpp').read_text())
    results=[]
    for order,variant in enumerate(['shared','repeated','repeated','shared']):
        source=build(a.track,TASK/'.work/section-timing-source'/a.name/str(order));s=source.read_text()
        if variant=='repeated':s=s.replace('WidenUnsigned(row,bottomRow); Call(projectRow);','Call(prepareProjection); WidenUnsigned(row,bottomRow); Call(projectRow);')
        source.write_text(s+'\nProgram benchmark(2100) { Repeat(16) { Call(section); }; };\n')
        run,raw=execute('golem-section-timing',a.name+f'-{order}-{variant}',source,data,loader=loader,timeout=300)
        ticks=[v[0] for v in struct.iter_unpack('<I',raw)];assert len(ticks)==128 and all(ticks)
        perCall=[v*1000/120/16 for v in ticks]
        results.append({'variant':variant,'order':order,'evidence':str(run.relative_to(TASK)),'group_ticks':ticks,'median_ms_per_call':statistics.median(perCall),'mean_ms_per_call':statistics.mean(perCall),'min_ms_per_call':min(perCall),'max_ms_per_call':max(perCall)})
        (root/'progress.json').write_text(json.dumps(results,indent=2)+'\n')
    report={'scope':__doc__,'track':a.track,'poses':cases,'source_hashes':{str(path):sha(path) for path in [TASK/'section_timing.cpp',TASK/'build_section_kernel.py',TASK/'build_projection_kernel.py',GOLEM/'src/hosted.hpp']},'runs':results}
    (root/'results.json').write_text(json.dumps(report,indent=2)+'\n')
    print([(r['variant'],r['median_ms_per_call'],r['mean_ms_per_call']) for r in results])
if __name__=='__main__':main()
