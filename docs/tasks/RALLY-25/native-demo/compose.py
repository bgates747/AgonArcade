"""Derive a finite centerline demo from pinned Rally kernels; no peer edits."""
from pathlib import Path
import re
HERE=Path(__file__).resolve().parent
KERNELS=HERE.parent/'route-kernels'
LAP=3276800
START=LAP-30000
GAPS=[0,3199,3200,6400,18000,80000]

def source():
    text=(KERNELS/'kernels.golem').read_text()
    text=re.sub(r'Sub (ResetRace|StopRace)\n.*?EndSub\n', '', text, flags=re.S)
    text=text.replace('uint32 playerStation = 0',f'uint32 playerStation = {START}',1)
    text=text.replace('Array sint32 progress(0:5) = Fill(0)',
                      'Array sint32 progress(0:5) = Values('+','.join(str(START+gap) for gap in GAPS)+')',1)
    text=text.replace('Array uint32 position(0:5) = Values(0,65535,65536,3200000,3276798,3276799)',
                      'Array uint32 position(0:5) = Values('+','.join(str((START+gap)%LAP) for gap in GAPS)+')',1)
    declarations=f'''// Supplied deterministic fixture presentation; not production telemetry policy.
uint32 renderSession = 7
uint32 renderRequest = 0
uint32 playerUnwrapped = {START}
uint16 renderPhase Bounds(0,7999) = {START%8000}
sint16 renderSteering Bounds(-21,21) = 0
uint16 renderFlags Bounds(0,7) = 3
'''
    text=text.replace('Sub Sine\n',declarations+'Sub Sine\n',1)
    begin=text.index('Sub Tick120\n');end=text.index('EndSub',begin)
    advance='''    // Deterministic fixture player follows the shared traffic pace on centerline.
    playerStation = playerStation + forwardAdvance
    If playerStation >= uint32(lap) Then
        playerStation = playerStation - uint32(lap)
    EndIf
    playerUnwrapped = playerUnwrapped + forwardAdvance
    (uq,ur) = divmod(playerUnwrapped,8000)
    renderPhase = uint16(ur)
'''
    motion_start=text.index('    lap = lapInput\n', begin, end)
    text=text[:motion_start]+advance+text[motion_start:]
    # Reset restores only the bounded fixture. It does not define crash recovery.
    reset='''    routeRecord = 0
    routeRemaining = 60
    routeIndex = 0
    routeHeading = 0
    routeLateral = 0
    routeForward = 0
    forwardAdvance = 0
    worldTick = 0
    playerStation = '''+str(START)+'''
    playerUnwrapped = '''+str(START)+'''
    playerLateral = 0
    renderSession = 7
    renderRequest = 0
    renderPhase = '''+str(START%8000)+'''
    renderSteering = 0
    renderFlags = 3
    contactAny = false
'''
    for slot,gap in enumerate(GAPS):
        reset+=f'    active({slot}) = 1\n    progress({slot}) = {START+gap}\n    position({slot}) = {(START+gap)%LAP}\n    lateral({slot}) = 0\n    contacts({slot}) = 0\n'
    for name,body in [('InitRace',reset),('ResetRace',reset),('Render30','    renderRequest = renderRequest + 1\n'),('StopRace','    renderFlags = 0\n')]:
        text+='Sub '+name+'\n'+body+'EndSub\n'
    return '// Demo derivative: actual Golem physics, finite entries, supplied centerline player.\n'+text

if __name__=='__main__':
    (HERE/'demo.golem').write_text(source())
