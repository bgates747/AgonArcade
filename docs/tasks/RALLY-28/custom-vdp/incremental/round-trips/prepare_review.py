from pathlib import Path
import hashlib,json,subprocess
base=Path('/home/smith/Agon/mystuff/AgonArcade')
here=base/'docs/tasks/RALLY-28/custom-vdp/incremental/round-trips'
profile=base/'.emulator/rally28-hz60-rlyrtreview01-compact'
source=base/'.emulator/rally28-hz60-affreview01-cached-affine/flexe-agon-emulator'
text=source.read_text()
needle='cd "${profile_dir}"'
assert text.count(needle)==1
check=r'''# Human review also requires the central Author slot; never inherit a peer lease.
lease="${RALLY_ORYX_LEASE:-}"
if [[ ! "$lease" =~ ^[0-9a-f]{32}$ ]]; then
    echo 'Rally review requires a central Author Oryx lease; arrange it with Golem before launch.' >&2
    exit 1
fi
ssh -o BatchMode=yes raspberrypi \
    "/Agon/mystuff/AgonArcade/.venv/bin/python /Agon/mystuff/agon-dev-env/cross-agent/vdplet-rollout/oryx_lease.py assert-owner --owner author --lease $lease" >/dev/null || {
    echo 'Rally review launch rejected: current central lease does not belong to author.' >&2
    exit 1
}
'''
text=text.replace(needle,check+'\n'+needle)
(profile/'flexe-agon-emulator').write_text(text)
(profile/'flexe-agon-emulator').chmod(0o755)
subprocess.run(['bash','-n',str(profile/'flexe-agon-emulator')],check=True)
receipt=json.loads((here/'PROFILES-rlyrtreview01.json').read_text())
info=receipt['compact']
info['input_sha256']['flexe-agon-emulator']=hashlib.sha256((profile/'flexe-agon-emulator').read_bytes()).hexdigest()
info.update(human_review=True,central_owner_required='author',launch_not_performed=True)
(profile/'.runtime.sha256').write_text(''.join(h+'  '+n+'\n' for n,h in info['input_sha256'].items()))
assert all(hashlib.sha256((profile/n).read_bytes()).hexdigest()==h for n,h in info['input_sha256'].items())
(here/'PROFILES-rlyrtreview01.json').write_text(json.dumps(receipt,indent=2)+'\n')
print(json.dumps({'profile':str(profile),'stopped':True,'central_lease_required':True,'audio':'dummy'}))
