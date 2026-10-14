"""Immutable accepted primitive receipts and Rally-owned compiler staging."""
import hashlib,json,shutil,subprocess,time
from pathlib import Path
import sys
HERE=Path(__file__).resolve().parent;ROOT=HERE.parents[3];WORK=HERE.parent/'.work/route-kernels'
sys.path.insert(0,str(HERE.parent/'generated-state'))
from adapter import Interface
GOLEM=ROOT.parent/'golem';SDK=ROOT.parent/'agon-vdplet'
PINS=[('multiplication','964c43f564dfdca6','964c43f564dfdca6165702f3d40da4d6e581a7202c7ce4c084c60418ce3477fc','1ddfd64'),
      ('division','cd0e922475d08ad4','cd0e922475d08ad4848ec6c044f4c4851cf0148a7b209b8f5fd095f75ec8ed5e','df7a647'),
      ('right-shift','f78de85c7decc6a0','f78de85c7decc6a056d9450dd7ea2b3aca47733b9919c121bb0c47cfd720f600','b32c596')]
def sha(data):return hashlib.sha256(data).hexdigest()
def verify():
    started=time.monotonic();rows=[];tools={};latest=None
    for name,key,digest,commit in PINS:
        base=GOLEM/'docs/tasks/GOLEM-036'/name/'delivery'/key;raw=(base/'bundle.json').read_bytes();assert sha(raw)==digest
        m=json.loads(raw);sources=0
        for filename,meta in m['files'].items():
            p=(base/filename).resolve();assert p.is_relative_to(base.resolve());data=p.read_bytes()
            assert len(data)==meta['bytes'] and sha(data)==meta['sha256'],filename
            if filename.startswith('source/'):
                original=filename.removeprefix('source/')
                assert data==subprocess.check_output(['git','-C',str(GOLEM),'show',commit+':'+original]),filename;sources+=1
        for desc in m['packages'].values():
            raw=(base/desc['manifest']).read_bytes();assert sha(raw)==desc['sha256'];package=json.loads(raw)
            directory=base/Path(desc['manifest']).parent;spec=Interface(directory)
            assert spec.interface==package['interface'] and spec.root==package['root']
            assert all(package['backends'][k]==v for k,v in spec.backends.items() if k!='programs')
            for filename,meta in package['artifacts'].items():
                p=(directory/filename).resolve();assert p.is_relative_to(directory.resolve());data=p.read_bytes()
                assert len(data)==meta['bytes'] and sha(data)==meta['sha256']
            for filename,digest_ in package['inputs']['baseline']['sdk_files'].items():assert sha((SDK/filename).read_bytes())==digest_
            for tool,digest_ in package['inputs']['tool_executable_sha256'].items():
                p=shutil.which(tool) or Path.home()/'.platformio/packages/toolchain-xtensa-esp32/bin'/tool
                assert sha(Path(p).read_bytes())==digest_;tools[tool]=digest_
        rows.append(dict(feature=name,bundle_sha256=digest,published_commit=commit,bundle_files=len(m['files']),exported_sources_vs_commit=sources,packages=len(m['packages'])))
        latest=base
    closure=WORK/'compiler-source';closure.mkdir(parents=True,exist_ok=True)
    for p in (latest/'source').rglob('*'):
        if p.is_file():
            dest=closure/p.relative_to(latest/'source');dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(p.read_bytes())
    receipt=dict(scope='independent file/Git/metadata/installation/SDK/tool identity; owner target/human results not rerun',rows=rows,matched_tool_hashes=tools,host_seconds=round(time.monotonic()-started,3))
    (HERE/'DEPENDENCY-RECEIPT.json').write_text(json.dumps(receipt,indent=2)+'\n');return closure,receipt
