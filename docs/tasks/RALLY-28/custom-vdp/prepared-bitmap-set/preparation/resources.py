"""Source-level resource and ID inventory; no live capacity claim."""
from pathlib import Path
import collections,hashlib,importlib.util,inspect,json,struct
HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1]
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()

def main():
    source=Path('/Agon/mystuff/agon-vdplet/build/firmware/firmware-src/video')
    runtime=CUSTOM/'paced-road/control/sdk/src/vdplet_runtime.h'
    pinned=json.loads((CUSTOM/'paced-road/CONTROL.json').read_text())
    assert sha(runtime)==pinned['immutable_files']['control/sdk/src/vdplet_runtime.h']
    text=runtime.read_text();assert 'case 17:' in text and 'case 18:' not in text
    # Read-only stock capability check. Match the preserved firmware source
    # commit, rather than silently using newly added SDK fields.
    oldpinned='1056ee38ec1cc68ed327bd32ee47d04b1c30597c'
    import subprocess
    old=Path('/Agon/mystuff/agon-vdplet/build/firmware/upstream.git')
    proofs={}
    for name in ('agon.h','vdp_variables.h','vdu_buffered.h','buffers.h','sprites.h','vdu_sprites.h','buffer_stream.h','types.h'):
        committed=subprocess.check_output(['git','--git-dir',str(old),'show',oldpinned+':video/'+name])
        live=(source/name).read_bytes()
        if name=='vdu_buffered.h':
            # The frozen custom build inserts native dispatch elsewhere in
            # this header; check the stock functions we actually rely on.
            def function(text,signature):
                start=text.index(signature);at=text.index('{',start);level=1;end=at+1
                while level:
                    level+=(text[end]=='{')-(text[end]=='}');end+=1
                return text[start:end]
            names=('void VDUStreamProcessor::bufferReadVariable(', 'void VDUStreamProcessor::bufferTransformBitmap(')
            checked={}
            for signature in names:
                a=function(committed.decode(),signature);b=function(live.decode(),signature)
                if 'bufferReadVariable' in signature:assert a==b,signature
                checked[signature]=dict(committed_sha256=hashlib.sha256(a.encode()).hexdigest(),live_sha256=hashlib.sha256(b.encode()).hexdigest(),live_matches_committed=a==b)
            proofs[name]=dict(committed_sha256=hashlib.sha256(committed).hexdigest(),live_sha256=hashlib.sha256(live).hexdigest(),stock_functions_exact=checked)
        else:
            assert live==committed,name
            proofs[name]=hashlib.sha256(committed).hexdigest()
    assert 'heap_caps_get_free_size(MALLOC_CAP_SPIRAM)' in (source/'vdp_variables.h').read_text()
    fixture=CUSTOM/'incremental/round-trips/fixtures/compact'
    freeze=json.loads((HERE.parent/'FREEZE.json').read_text())
    assert all(sha(fixture/n)==h for n,h in freeze['baseline_compact_fixture']['files'].items())
    # Original artwork decoder also identifies buffers left live by remapping.
    f=CUSTOM/'affine-offline/workload.py'
    spec=importlib.util.spec_from_file_location('aff03_art_inventory',f);module=importlib.util.module_from_spec(spec);spec.loader.exec_module(module)
    definition=inspect.getsource(module.artwork).replace('return assets, matrices','return assets, matrices, buffers')
    scope=dict(module.__dict__);exec(compile(definition,str(f),'exec'),scope)
    assets,matrices,retained=scope['artwork']()
    assert sum(len(x[2]) for x in assets.values())==307658
    # All other retained application buffers are described by the frozen ABI
    # and exact upload files. Unknown allocator/controller internals are not
    # hidden inside an invented measured figure.
    ids={*range(1,27),*range(50300,50306),50700,*range(50710,50718),
         63800,63960,63930,63984,63940,63941,64100,*range(63970,63976),
         *range(64000,64035),*range(64120,64128),*range(35),100,*range(120,128)}
    reserved={51996,51997,51998,51999};planned=set(range(52000,52000+6927))
    assert not ids&(reserved|planned) and not reserved&planned
    components=dict(original_player_and_traffic_and_sign_pixels=307658,panorama_pixels=1024*104,
        original_fonts=2048+8192,renderer_tables_fuji=149518,road_pixels=38400,
        actor_scratch=6*7425+2*3844,output_commands_and_completion=20480+2048+256+48,
        module_upload_buffer=34836,native_executable_text=32264,native_data=1004,
        two_320_by_240_byte_framebuffers=2*320*240)
    # Shared arrays/root and wrapper lengths from the actual contiguous writes.
    def simple_upload(data):
        at=0;live=collections.defaultdict(int)
        while at<len(data):
            assert data[at:at+3]==b'\x17\0\xa0',(at,data[at:at+12].hex())
            key,op=struct.unpack_from('<HB',data,at+3);at+=6
            if op==2:live.pop(key,None)
            elif op==0:
                n=struct.unpack_from('<H',data,at)[0];at+=2;live[key]+=n;at+=n
            elif op==14:pass
            else:raise AssertionError((key,op,at))
        return dict(live)
    shared=simple_upload((fixture/'common.vdu').read_bytes())
    components['root_and_shared_arrays']=sum(shared.values())
    # Args9 plus17 resident wrappers43B, verified in their bootstrap writes.
    data=(fixture/'native.vdu').read_bytes();at=0;wrappers={}
    while data[at:at+3]==b'\x17\0\xa0':
        key,op=struct.unpack_from('<HB',data,at+3)
        if key>26:break
        at+=6
        if op==2:wrappers.pop(key,None)
        else:
            assert op==0;n=struct.unpack_from('<H',data,at)[0];at+=2
            wrappers[key]=n;at+=n
    assert len(wrappers)==18 and wrappers[9]==2 and set(wrappers.values())=={2,43}
    components['args_and_resident_wrappers']=sum(wrappers.values())
    result=dict(host_source_inventory_only=True,components=components,known_payload_total=sum(components.values()),
        not_a_measured_heap_partition_or_free_ram=True,
        omitted_runtime_overheads=['Controller/DMA/row pointers and allocator bookkeeping','Stock buffer/bitmap shared objects and map buckets','Context/font metadata and framework/audio/UART/kernel allocations','Native loader relocation/workspace and task stacks'],
        private_ids=dict(index=51999,generation_matrix=51998,telemetry=51997,setup_probe=51996,
            images_first=52000,exact_images_last=58926,maximum_private_images=8000),
        occupied_reference_ids=sorted(ids),no_private_id_collision=True,
        frozen_native_info=dict(source_sha256=sha(runtime),supports=list(range(18)),psram_fields_18_to_21=False,
            internal_free_fields=[13,14],internal_largest_fields=[15,16],field17='command task stack watermark'),
        stock_free_psram=dict(command=48,options=128,low_variable=528,high_variable=529,
            encoding='23,0,160,telemetry-id LE16,48,128,offset LE16,variable LE16; then ordinary native READ16',
            snapshot='Read high/low/high with consistency check, fixed preallocated telemetry buffer',
            largest_psram_block_exposed=False,target_runtime_query_qualified=False),
        frozen_stock_source_pin=oldpinned,frozen_stock_hashes=proofs,
        measured_live_memory=None,qualified_fit=False,current_compact_defaults_unchanged=True)
    (HERE/'RESOURCES.json').write_text(json.dumps(result,indent=2)+'\n')
    print(json.dumps({'known_payload_bytes':result['known_payload_total'],'no_private_id_collision':True,'native_psram_INFO_available':False,'stock_free_psram_source_available':True,'live_fit_qualified':False},indent=2))

if __name__=='__main__':main()
