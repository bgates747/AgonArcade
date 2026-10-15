"""Independently check guest records against the captured VDP protocol stream."""
from pathlib import Path
import argparse,csv,json
def packets(data):
    out=[];at=0
    while at<len(data):
        assert at+2<=len(data) and data[at]&128,('packet framing',at,data[at:at+10].hex())
        n=data[at+1];assert at+2+n<=len(data),('truncated packet',at,n)
        out.append((data[at]&127,data[at+2:at+2+n]));at+=2+n
    return out
def verify(profile,expect_input=False):
    result=json.loads((profile/'last-run/result.json').read_text());kind=result['kind']
    app=profile/'sdcard/test/arcade/rally28'/kind;s=result['summary']
    assert result['reason']=='guest-files' and result['exit']==0 and result['identities_unchanged']
    assert result['forced_sdl']=={'video':'dummy','audio':'dummy'}
    assert s['failure']=='none' and s['callback_restored']=='1' and s['overflow']=='0'
    assert s['completed']==s['planned']=='52' and s['idle_marker_hits']=='0'
    assert 0<=int(s['counter_ticks'])-int(s['elapsed_ticks'])<=2,'Counter included time outside its measurement window'
    assert (app/'done.txt').read_text().strip()=='PASS'
    frame_header=None;key_header=None;frames=[];keys=[]
    for row in csv.reader((app/'events.csv').read_text().splitlines()):
        if row[0]=='kind':
            if row[2]=='heavy':frame_header=row
            else:key_header=row
        elif row[0]=='frame':frames.append(dict(zip(frame_header,[row[0],*map(int,row[1:])],strict=True)))
        elif row[0]=='key':keys.append(dict(zip(key_header,[row[0],*map(int,row[1:])],strict=True)))
        else:raise AssertionError(row)
    assert len(frames)==52 and len(keys)==int(s['keyboard_packets'])
    for i,f in enumerate(frames):
        assert f['index']==i and f['heavy']==int(24<=i<48) and f['marker']==(0 if i<48 else 170)
        assert f['pixel']==(4 if i&1 else 2) and f['token']==40+i
        assert f['submit']<=f['returned']<=f['observed'] and f['submit']<=f['completion']<=f['observed']
        if kind=='key':assert f['hits']==1,(i,f)
        else:assert f['hits']==0,(i,f)
    raw=(profile/'last-run/vdp-to-mos.bin').read_bytes()
    delivered=(profile/'last-run/vdp-to-mos-delivered.bin').read_bytes();assert raw==delivered,'VDP packet loss/difference'
    wire=packets(raw);wire_keys=[p for op,p in wire if op==1]
    captured=[bytes(k[n] for n in ('ascii','modifiers','vkey','down')) for k in keys]
    # Startup may request Shift before our callback is installed. Match the full capture as a suffix.
    assert wire_keys[-len(captured):]==captured if captured else True
    # MOS boot performs its own pixel query; the application's readbacks are last.
    pixels=[p for op,p in wire if op==4][-52:];assert len(pixels)==52
    for f,p in zip(frames,pixels,strict=True):assert p==bytes(f[n] for n in ('r','g','b','pixel'))
    polls=[p[0] for op,p in wire if op==0 and len(p)==1]
    expected_polls=[225,*range(40,92),226] if kind=='key' else [225,*[n for i in range(52) for n in (40+i,100+i)],226]
    assert polls[-len(expected_polls):]==expected_polls,polls
    # Each independent pixel-read response comes after that frame's primary
    # completion. A callback therefore cannot depend on the later verification.
    start=next(i for i,(op,p) in enumerate(wire) if op==0 and p==bytes([225]))+1
    at=start
    for i,f in enumerate(frames):
        if kind=='key':
            while at<len(wire) and not (wire[at][0]==1 and len(wire[at][1])==4 and wire[at][1][2]==f['marker']):at+=1
        else:
            while at<len(wire) and wire[at]!=(0,bytes([f['token']])):at+=1
        assert at<len(wire),('missing primary',i)
        at+=1
        while at<len(wire) and wire[at][0]!=4:at+=1
        assert at<len(wire) and wire[at][1][3]==f['pixel'],('readback order',i)
        at+=1
        expected=f['token'] if kind=='key' else 100+i
        while at<len(wire) and wire[at]!=(0,bytes([expected])):at+=1
        assert at<len(wire),('missing validation fence',i)
        at+=1
    marker=[k for k in keys if k['vkey']==0];assert len(marker)==(48 if kind=='key' else 0)
    assert all(k['down']==0 for k in marker),'VK_NONE changed to held'
    other=[k for k in keys if k['vkey'] not in (0,170)]
    if expect_input:
        for vk in (150,154,22): # FabGL Up, Left, lowercase a
            assert any(k['vkey']==vk and k['down']==1 for k in other),(vk,other)
            assert any(k['vkey']==vk and k['down']==0 for k in other),(vk,other)
        f12=[k for k in keys if k['vkey']==170];assert any(k['down']==1 for k in f12) and len(f12)>=6
    else:assert not other,other
    assert s['keymap_before']==s['keymap_after']=='0'*32
    stats=result['backend_stats'];assert not any(stats[n] for n in ('failed','unhandled','unregistered','unmapped'))
    report={'verified':True,'kind':kind,'frames':len(frames),'zero_key_callbacks':len(marker),'keyboard_packets':len(keys),'input_checked':expect_input,
        'pending_counter_ticks':sum(f['pending_counter'] for f in frames),'heavy_pending_counter_ticks':sum(f['pending_counter'] for f in frames if f['heavy']),
        'completion_ticks':{'light':[f['completion']-f['submit'] for f in frames if not f['heavy']], 'heavy':[f['completion']-f['submit'] for f in frames if f['heavy']]},
        'summary':s,'runtime':result['identity'],'outputs':result['outputs']}
    (profile/'last-run/verified.json').write_text(json.dumps(report,indent=2)+'\n');print(json.dumps(report,indent=2))
    return report
if __name__=='__main__':
    p=argparse.ArgumentParser(description=__doc__);p.add_argument('profile',type=Path);p.add_argument('--expect-input',action='store_true');a=p.parse_args();verify(a.profile.resolve(),a.expect_input)
