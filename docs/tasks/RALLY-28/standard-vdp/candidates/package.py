"""Package exact portable inputs; never deploy to a card or launch hardware."""
from pathlib import Path
import hashlib,json,zipfile
HERE=Path(__file__).resolve().parent;OUT=HERE/'evidence'
if __name__=='__main__':
    build=json.loads((OUT/'BUILD-V5.json').read_text());files={};images={}
    for variant in ('dense','lookup','lookup-buffer','coarse','coarse-buffer'):
        binary=(OUT/'binaries-v5'/variant/'candidate.bin').read_bytes()
        assert hashlib.sha256(binary).hexdigest()==build['variants'][variant]['sha256']
        for mode in ((0,1,2) if variant=='lookup-buffer' else (0,1)):
            kind=('cpu','live','shadow')[mode];base=f'{variant}-{kind}/'
            images[base+'candidate.bin']=binary;images[base+'mode.txt']=(str(mode)+'\n').encode()
            if variant!='dense':images[base+'fuji.road']=(OUT/'data/fuji.road').read_bytes()
    for name,raw in images.items():files[name]={'sha256':hashlib.sha256(raw).hexdigest(),'bytes':len(raw)}
    manifest={'schema':1,'candidate':'v5','frames':900,'scripted_ticks':3600,'application_geometry_processor':'eZ80','stock_vdp_sha256':'b807beef35823b13a0a056f11b7464cd1b1c6356dce0e4098b78ebe059ded35f','mos_sha256':'d564243283972690933a4554296ad6202ca4ef54572279533a942960846bebae','files':files,'deployed_to_physical_media':False}
    archive=OUT/'PORTABLE-V5.zip'
    with zipfile.ZipFile(archive,'w',compression=zipfile.ZIP_DEFLATED,compresslevel=6) as z:
        for name,raw in sorted(images.items()):
            info=zipfile.ZipInfo(name,date_time=(2026,10,15,0,0,0));info.compress_type=zipfile.ZIP_DEFLATED;info.external_attr=0o100644<<16;z.writestr(info,raw)
    with zipfile.ZipFile(archive) as z:
        assert set(z.namelist())==set(files)
        for name,r in files.items():assert hashlib.sha256(z.read(name)).hexdigest()==r['sha256']
    manifest['archive']={'name':archive.name,'sha256':hashlib.sha256(archive.read_bytes()).hexdigest(),'bytes':archive.stat().st_size}
    (OUT/'PORTABLE-V5.json').write_text(json.dumps(manifest,indent=2)+'\n')
    print('Packaged eleven exact input sets, with no card write or hardware launch.')
