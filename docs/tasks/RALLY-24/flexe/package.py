"""Package hardware fixtures and their exact tested firmware; does not deploy."""
from pathlib import Path
import hashlib,json,zipfile
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3];WORK=HERE/'.work'
def package():
    files={}
    cases=('oval-replay','oval-a','oval-b','fuji-replay','fuji-a','fuji-b','matrix')
    for case in cases:
        for p in (WORK/'fixtures'/case).iterdir():
            if p.is_file() and p.suffix!='.log':files['r24/'+case+'/'+p.name]=p.read_bytes()
    files['r24/README.txt']=('Copy r24 to the Agon SD root. With the matching VDPlet-enabled mainboard VDP,\n'
       'run each case from its directory: cd /r24/oval-b then exec run.txt\nEach fixture saves replies.log and ticks.log in its own directory.\n'
       'A failure saves failure.log. Logs are replaced on each invocation; archive prior runs.\n'
       'Type mode 0 after an individual run to restore the MOS console.\nStock VDP/EDP are not the target of this fixture.\n'
       'No firmware flash or autoexec change is performed by these scripts.\n'
       'Return each fixture directory with its logs and expected.json for decoding.\n'
       'See README.md for limits: replay omits eZ80 calculation, and native B pixel parity\n'
       'remains unresolved. Firmware image is provided for a separately controlled installation.\n').encode()
    for name in ('README.md','RESULTS.md','RESULTS.json','MATRIX.json','PROVENANCE.json'):
        files[name]=(HERE/name).read_bytes()
    files['decode.py']=(HERE/'decode.py').read_bytes()
    files['firmware/firmware.bin']=(ROOT.parent/'agon-vdplet/build/firmware/firmware-src/.pio/build/esp32dev/firmware.bin').read_bytes()
    manifest={n:dict(bytes=len(b),sha256=hashlib.sha256(b).hexdigest()) for n,b in files.items()}
    files['MANIFEST.json']=(json.dumps(manifest,indent=2)+'\n').encode()
    path=WORK/'rally24-hardware.zip'
    with zipfile.ZipFile(path,'w',zipfile.ZIP_DEFLATED) as z:
        for n,b in files.items():z.writestr(n,b)
    print(path)
    (WORK/'hardware-manifest.json').write_text(json.dumps(dict(archive_sha256=hashlib.sha256(path.read_bytes()).hexdigest(),files=manifest),indent=2)+'\n')
if __name__=='__main__':package()
