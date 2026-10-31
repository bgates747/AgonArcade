"""Audit the one stopped control; do not weaken the frozen full-success audit."""
from pathlib import Path
import hashlib,importlib.util,json,struct
HERE=Path(__file__).resolve().parent
spec=importlib.util.spec_from_file_location('hud_audit_helpers',HERE/'audit.py')
helpers=importlib.util.module_from_spec(spec);spec.loader.exec_module(helpers)
raw=helpers.raw

def command(key,op):return b'\x17\0\xa0'+struct.pack('<H',key)+bytes([op])

def audit():
    directory=HERE/'evidence/hudsmoke01/control'
    info=json.loads((HERE/'SMOKE-FIXTURES.json').read_text())['control']
    profile=json.loads((HERE/'PROFILES-hudsmoke01.json').read_text())['control']
    fixture,meta,runtime=helpers.fixture_inputs(info,profile)
    assert info['files']['probe.bin']=='685f4b4c6bd6959aac330a5c6c361b8e86b4967656bfb049df777b5a74ae3d1d'
    session=raw.session('hudsession01',require_complete=False)
    assert session['completed']==[]
    receipt=json.loads((directory/'run.json').read_text())
    assert receipt['result'] is None and receipt['process_exit']==0
    assert 'UART streams unchanged for60 host seconds' in receipt['error']
    assert raw.identities(receipt['runtime_identities'])==profile['input_sha256']
    assert not any((directory/n).exists() for n in ('result.json','failure.txt','state.bin','ticks.bin','prt.bin'))
    tx,packets,generic=raw.backend(directory)
    assert len(tx)==224661 and len(packets)==1
    assert struct.unpack('<4sBBHH',packets[0])==(b'VDPL',1,2,1,1)
    assert (directory/'vdp-to-mos.bin').read_bytes()==(directory/'vdp-to-mos-delivered.bin').read_bytes()
    reference=json.loads((HERE/'EXPECTED-FINAL-60.json').read_text())
    raw.COMPACT=True
    schedule=raw.specs(60,meta['module_bytes'],1,reference)
    raw.replies_match(packets,schedule[:1]);raw.raw_requests(tx,schedule[:1])
    assert all(tx.find(r['wire'])<0 for r in schedule[1:])
    assets=(fixture/'assets.vdu').read_bytes();art=(fixture/'artwork.vdu').read_bytes()
    asset_at=tx.index(assets);assert tx.count(assets)==1
    art_at=asset_at+len(assets);part=tx[art_at:];assert art.startswith(part)
    assert (asset_at,len(assets),art_at,len(part),len(art))==(35335,149554,184889,39772,58780)
    assert tx.count((fixture/'module.vdu').read_bytes())==1
    # Parse the known complete original-player uploads, then the first livery.
    # Skip each declared pixel payload, rather than scanning it for opcodes.
    at=0
    for i in range(5):
        assert art[at:at+6]==command(64000+i,2);at+=6
        assert art[at:at+8]==command(64000+i,0)+struct.pack('<H',102*77);at+=8+102*77
        assert art[at:at+4]==bytes([23,27,0,i]);at+=4
        assert art[at:at+8]==bytes([23,27,33])+struct.pack('<HHB',102,77,1);at+=8
    assert at==39400
    assert art[at:at+6]==command(63960,2);at+=6
    assert art[at:at+8]==command(63960,0)+struct.pack('<H',256);at+=8+256
    observed=None
    for i in range(5):
        assert art[at:at+6]==command(64005+i,2);at+=6
        packet=command(64005+i,72)+bytes([0x10])+struct.pack('<HH',64000+i,63960)
        assert art[at:at+len(packet)]==packet
        if at<len(part)<at+len(packet):
            observed=dict(art_offset=at,absolute_uart_offset=art_at+at,
                destination=64005+i,opcode=72,source=64000+i,map_buffer=63960,
                expected_bytes=len(packet),captured_bytes=len(part)-at,
                missing_suffix_hex=packet[len(part)-at:].hex());break
        at+=len(packet)
        assert art[at:at+4]==bytes([23,27,0,5+i]);at+=4
        assert art[at:at+8]==bytes([23,27,33])+struct.pack('<HHB',102,77,1);at+=8
    assert observed and observed['destination']==64008 and observed['captured_bytes']==9
    freeze=json.loads((HERE/'READINESS-FREEZE.json').read_text())
    for name,digest in freeze['files'].items():assert hashlib.sha256(Path(name).read_bytes()).hexdigest()==digest,name
    build=json.loads((HERE/'BUILD.json').read_text())
    for name,digest in build['preserved_control_inputs'].items():assert hashlib.sha256(Path(name).read_bytes()).hexdigest()==digest,name
    checkout=json.loads((HERE/'CHECKOUT.json').read_text());release=json.loads((HERE/'RELEASE.json').read_text())
    assert checkout['generation']==release['generation']==49
    assert checkout['lease']==release['lease'] and release['release_observation']['emulators']==[]
    return dict(passed=True,scope='One failed original-control startup; no timed race/FPS qualification',
        qualified_for_timing=False,new_game_fps=None,session=session,raw=raw.excluded_raw(directory),
        startup_original_control_exact=True,completed_native_load_reply=True,
        native_init_request_absent=True,warm_and_timed_requests_absent=True,
        original_assets=dict(offset=asset_at,complete_bytes=len(assets)),
        original_artwork=dict(offset=art_at,expected_bytes=len(art),captured_prefix_bytes=len(part),
                             missing_bytes=len(art)-len(part),last_partial_command=observed),
        delivery_limit='Outgoing trace and uart_rx account host-enqueued bytes; not firmware-consumption proof. Exact cause and expected quiet time unqualified.',
        failed_runs=['hudsmoke01/control'],
        unrun=['hudsmoke01/cached','hudab01/control','hudab01/cached','hudba01/cached','hudba01/control'],
        original_readiness_files_unchanged=len(freeze['files']),preserved_control_inputs=len(build['preserved_control_inputs']),
        host_cleanup_verified=True,guest_cleanup_verified=False,explicit_checkout_released=True,
        handoff=json.loads((HERE/'HANDOFF.json').read_text()))

if __name__=='__main__':
    result=audit()
    path=HERE/'FAILED-STARTUP-AUDIT.json';text=json.dumps(result,indent=2)+'\n'
    if path.exists():assert path.read_text()==text
    else:path.write_text(text)
    print('PASS: unchanged control stopped in original artwork command72 prefix; LOAD reply exact; candidate/five runs unrun; no FPS.')
