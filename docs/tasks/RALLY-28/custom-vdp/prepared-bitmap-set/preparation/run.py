"""Reproduce the host-only domain/image/error census in this private workspace."""
from pathlib import Path
import csv,hashlib,json,subprocess,sys,time
HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1]
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def run():
    started=time.monotonic();work=HERE/'.work';work.mkdir(exist_ok=True)
    source=CUSTOM/'incremental/round-trips/source';sdk=CUSTOM/'paced-road/control/sdk/include'
    base=HERE/'tracks'
    # Preserved copies of independently qualified original track exports.
    assert (base/'fuji.r24').exists() and (base/'oval.r24').exists()
    for mode,flags in [('ordinary',[]),('ubsan',['-fsanitize=undefined','-fno-omit-frame-pointer','-fno-sanitize-recover=all'])]:
        subprocess.run(['cc','-std=c11','-O2','-ffp-contract=off','-fno-builtin',*flags,
            '-I'+str(source),'-I'+str(sdk),str(HERE/'domain.c'),'-o',str(work/('domain-'+mode))],check=True)
        subprocess.run([str(work/('domain-'+mode)),str(base/'fuji.r24'),str(base/'oval.r24'),str(HERE/('DOMAIN-'+mode+'.csv'))],check=True)
    assert (HERE/'DOMAIN-ordinary.csv').read_bytes()==(HERE/'DOMAIN-ubsan.csv').read_bytes()
    (HERE/'DOMAIN-WITNESSES.csv').write_bytes((HERE/'DOMAIN-ordinary.csv').read_bytes())
    rows=list(csv.DictReader((HERE/'DOMAIN-WITNESSES.csv').open()))
    traffic=sorted({int(r['q']) for r in rows if r['track']=='fuji' and r['kind']=='traffic' and r['present']=='1'})
    assert len(traffic)==108 and all(r['present']=='1' for r in rows if r['track']=='fuji' and r['kind']=='traffic')
    signs={b:sorted({int(r['q']) for r in rows if r['kind']=='sign' and int(r['view'])==b}) for b in range(8)}
    aff=CUSTOM/'affine-offline';art=json.loads((aff/'WORKLOAD.json').read_text());assets={r['bitmap_id']:r for r in art['bitmaps']}
    lines=[]
    for b in [*range(5,35),*range(120,128)]:
        a=assets[b];path=aff/a['path'];assert sha(path)==a['sha256']
        for mirror in ((0,1) if b<120 else (0,)):
            family=2*((b-5)%5)+mirror if b<120 else 10+b-120
            qs=traffic if b<120 else signs[b-120]
            lines.append('\t'.join(map(str,(b,a['width'],a['height'],mirror,family,path,','.join(map(str,qs)))))+'\n')
    (HERE/'INPUT.tsv').write_text(''.join(lines))
    summary=dict(host_only=True,fuji_all_traffic_combinations_have_actual_visible_witnesses=True,
        traffic_q=traffic,sign_q_by_bitmap=signs,sign_total_combinations=sum(map(len,signs.values())),traffic_total_combinations=6480,
        both_camera_domains_fully_scanned_for_signs=True,fuji_camera_positions=3276800,oval_camera_positions=576000,
        ordinary_ubsan_exact_match=True,state_schema_ranges_and_actors_checked=True,
        domain_source_sha256=sha(HERE/'domain.c'),source_core_sha256=sha(source/'helper/render_core.inc'),
        assets={n:sha(base/(n+'.r24')) for n in ('fuji','oval')},source_artwork_sha256={str(b):a['sha256'] for b,a in assets.items()})
    (HERE/'DOMAIN.json').write_text(json.dumps(summary,indent=2)+'\n')
    manifest=json.loads((aff/'SOURCE-MANIFEST.json').read_text())
    for section in ('extracted','support'):
        for name,value in manifest[section].items():assert sha(aff/'stock'/name)==value['sha256']
    subprocess.run(['c++','-std=c++17','-O2','-ffp-contract=off','-I'+str(aff/'stock'),str(HERE/'images.cpp'),str(aff/'stock/stock.cpp'),'-o',str(work/'images')],check=True)
    subprocess.run([str(work/'images'),str(HERE)],check=True)
    for script in ('analyze.py','verify_analysis.py','resources.py','previews.py'):
        subprocess.run([sys.executable,str(HERE/script)],check=True)
    print('Host preparation finished in',round(time.monotonic()-started,2),'seconds; no emulator or target run.')

if __name__=='__main__':run()
