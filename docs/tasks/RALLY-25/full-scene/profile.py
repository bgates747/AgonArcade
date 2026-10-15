"""Stage a stopped full-scene profile with the same MOS path used on hardware."""
from pathlib import Path
import argparse,hashlib,importlib.util
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3]
def prepare(fixture,name):
    spec=importlib.util.spec_from_file_location('native_profile',HERE.parent/'native-demo/profile.py');m=importlib.util.module_from_spec(spec);spec.loader.exec_module(m)
    old=ROOT/'.emulator/rally25-native-demo'
    profile=ROOT/'.emulator'/name;assert not profile.exists(),'Preserve existing profile'
    p=m.prepare(fixture,Path(fixture)/'vdp_rally.bin',old/'esp32-firmware.elf',name,ROOT.parent/'golem/docs/tasks/GOLEM-037/binding/build/runtime')
    app=p/'sdcard/test/arcade/rally';app.parent.mkdir(parents=True)
    (p/'sdcard/rally25').rename(app);(p/'sdcard/rally25').symlink_to('test/arcade/rally',target_is_directory=True)
    (p/'sdcard/autoexec.txt').write_bytes(b'SET KEYBOARD 1\r\ncd /test/arcade/rally\r\nload probe.bin\r\nrun .\r\n')
    hashes=p/'.runtime.sha256';paths=[line.split('  ',1)[1].replace('sdcard/rally25/','sdcard/test/arcade/rally/') for line in hashes.read_text().splitlines()]
    hashes.write_text(''.join(hashlib.sha256((p/n).read_bytes()).hexdigest()+'  '+n+'\n' for n in paths))
    print('Full-scene profile ready, stopped:',p)
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('--fixture',required=True);p.add_argument('--name',required=True);a=p.parse_args();prepare(a.fixture,a.name)
