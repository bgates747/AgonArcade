"""Verify immutable peer inputs; copy exported compiler closure into Rally work."""
import hashlib,json,shutil,subprocess,time
from pathlib import Path
from adapter import Interface
HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[3]
WORK=HERE.parent/'.work/generated-state'
GOLEM=ROOT.parent/'golem';SDK=ROOT.parent/'agon-vdplet'
DELIVERIES=[('035','2156756263f8baff','2156756263f8baffa52e3c14a57e7838d90336bc9ee3d5bbde78566ed722ff8f','93bf1e452cc4c57b9aaf412ae016e318c7be6ceb'),
            ('036','94e72ff566490794','94e72ff56649079472a59b33ae9ba1514b49dcb5c8c919ace369de6e46fb2c6a','4a62c1d')]
def sha(data):return hashlib.sha256(data).hexdigest()
def git(commit,path):return subprocess.check_output(['git','-C',str(GOLEM),'show',commit+':'+path])
def verify():
    started=time.monotonic();rows=[];tools={};packages=0;foundation=None
    for task,key,digest,commit in DELIVERIES:
        base=GOLEM/f'docs/tasks/GOLEM-{task}/delivery'/key;raw=(base/'bundle.json').read_bytes();assert sha(raw)==digest
        bundle=json.loads(raw);sources=0
        for name,meta in bundle['files'].items():
            p=(base/name).resolve();assert p.is_relative_to(base.resolve());data=p.read_bytes()
            assert len(data)==meta['bytes'] and sha(data)==meta['sha256'],name
            if name.startswith('source/'):
                assert data==git(commit,name.removeprefix('source/')),name;sources+=1
        for name,desc in bundle['packages'].items():
            directory=base/Path(desc['manifest']).parent;raw=(base/desc['manifest']).read_bytes();assert sha(raw)==desc['sha256']
            manifest=json.loads(raw);interface=Interface(directory)
            assert manifest['interface']==interface.interface and manifest['root']==interface.root
            assert all(manifest['backends'][k]==v for k,v in interface.backends.items() if k!='programs')
            for filename,meta in manifest['artifacts'].items():
                p=(directory/filename).resolve();assert p.is_relative_to(directory.resolve());data=p.read_bytes()
                assert len(data)==meta['bytes'] and sha(data)==meta['sha256']
            baseline=manifest['inputs']['baseline']
            for path,digest_ in baseline['sdk_files'].items():assert sha((SDK/path).read_bytes())==digest_,path
            for f in baseline['files']:assert sha(git(baseline['compiler_commit'],f['path']))==f['sha256']
            for tool,digest_ in manifest['inputs']['tool_executable_sha256'].items():
                p=shutil.which(tool)
                if not p:p=Path.home()/'.platformio/packages/toolchain-xtensa-esp32/bin'/tool
                assert Path(p).is_file() and sha(Path(p).read_bytes())==digest_,tool;tools[tool]=digest_
            assert sha((SDK/'include/vdplet.h').read_bytes())==manifest['inputs']['abi_header_sha256']
            packages+=1
        rows.append(dict(task='GOLEM-'+task,bundle_sha256=digest,published_commit=commit,bundle_files=len(bundle['files']),exported_sources_matched_to_commit=sources,packages=len(bundle['packages'])))
        if task=='036':foundation=base
    receipt=dict(scope='independent hashes/Git/source/metadata/initialization/tool identity; owner human/target evidence not rerun',rows=rows,packages_verified=packages,
                 matched_tool_hashes=tools,duration_host_seconds=round(time.monotonic()-started,3))
    (HERE/'DEPENDENCY-RECEIPT.json').write_text(json.dumps(receipt,indent=2)+'\n')
    closure=WORK/'foundation-source';closure.mkdir(parents=True,exist_ok=True)
    for path in (foundation/'source').rglob('*'):
        if path.is_file():
            dest=closure/path.relative_to(foundation/'source');dest.parent.mkdir(parents=True,exist_ok=True);dest.write_bytes(path.read_bytes())
    return closure,receipt
