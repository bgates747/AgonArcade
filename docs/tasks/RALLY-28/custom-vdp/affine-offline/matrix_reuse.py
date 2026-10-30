"""Count unchanged per-buffer affine matrices in the exact ordered baseline trace.

Analysis only: no renderer/source/fixture mutation or emulator execution.
"""
from pathlib import Path
import collections
import hashlib
import json
import subprocess

HERE=Path(__file__).resolve().parent
ROOT=HERE.parents[4]
RACE=HERE.parent/'full-race'
UPSTREAM=ROOT.parent/'agon-vdplet/build/firmware/upstream.git'
VDP_PIN='1056ee38ec1cc68ed327bd32ee47d04b1c30597c'


def digest(data):return hashlib.sha256(data).hexdigest()
def sha(path):return digest(Path(path).read_bytes())
def function(text,name):
    begin=text.index(name);opening=text.index('{',begin);depth=1;end=opening+1
    while depth:
        if text[end]=='{':depth+=1
        elif text[end]=='}':depth-=1
        end+=1
    return text[begin:end]


def main():
    workload=json.loads((HERE/'WORKLOAD.json').read_text())
    trace=HERE/workload['observed_draws']['path']
    assert sha(trace)==workload['observed_draws']['sha256']
    rows=[json.loads(line) for line in trace.read_text().splitlines()]
    resources=json.loads((RACE/'.work/packages/baseline/native-bindings.json').read_text())['bindings']['resources']
    traffic_ids=list(range(resources['traffic_matrix_base'],resources['traffic_matrix_base']+6))
    sign_id=resources['sign_matrix'];player_id=resources['player_mirror_matrix']
    assert traffic_ids==list(range(63970,63976)) and sign_id==63930 and player_id==63984
    last={};stats=collections.defaultdict(collections.Counter);examples=[];events=[]
    inverse_signatures=set();same_newbitmap=0;same_moved=0;same_aftergap=0
    for draw_index,row in enumerate(rows):
        if row['kind']=='player':
            assert row['matrix_id']==65535 and not row['affine_enabled']
            continue
        matrix_id=row['matrix_id'];matrix=tuple(row['matrix_q8'])
        assert matrix_id in (traffic_ids if row['kind']=='traffic' else [sign_id])
        assert row['affine_enabled'] and matrix[1]==matrix[3]==matrix[5]==0
        prior=last.get(matrix_id)
        identical=prior is not None and matrix==tuple(prior['matrix_q8'])
        for group in [('phase',row['phase']),('kind',row['kind']),('phase_kind',row['phase'],row['kind']),('matrix',matrix_id)]:
            stats[group]['writes']+=1
            stats[group]['identical' if identical else 'first_or_changed']+=1
        if row['phase']=='measured' and identical:
            same_newbitmap+=row['bitmap_id']!=prior['bitmap_id']
            same_moved+=(row['x'],row['y'])!=(prior['x'],prior['y'])
            same_aftergap+=row['frame']>prior['frame']+1 if prior['phase']=='measured' else False
        record=dict(trace_index=draw_index,phase=row['phase'],frame=row['frame'],warm_index=row['warm_index'],
            kind=row['kind'],matrix_id=matrix_id,matrix_q8=list(matrix),identical=identical,
            previous_frame=prior['frame'] if prior is not None else None,
            previous_phase=prior['phase'] if prior is not None else None)
        events.append(record)
        if identical and len(examples)<12:examples.append(record)
        last[matrix_id]=row
        inverse_signatures.add((matrix_id,matrix))
    def result(counter):
        return dict(counter,identical_percent=counter['identical']/counter['writes']*100,
            matrix_command_bytes=27*counter['writes'],potential_omitted_resident_bytes=27*counter['identical'])
    official={}
    functions={
        'video/buffers.h':('bool checkTransformBuffer(',),
        'video/context/graphics.h':('void Context::drawBitmap(', 'void Context::setAffineTransform('),
        'video/vdu_buffered.h':('void VDUStreamProcessor::bufferAffineTransform(', 'void VDUStreamProcessor::bufferClear('),
    }
    bodies={}
    for path,names in functions.items():
        data=subprocess.check_output(['git','--git-dir='+str(UPSTREAM),'show',VDP_PIN+':'+path])
        text=data.decode();parts={name:function(text,name) for name in names}
        bodies.update(parts)
        official[path]=dict(sha256=digest(data),functions={name:digest(part.encode()) for name,part in parts.items()})
    check=bodies['bool checkTransformBuffer(']
    assert 'transformBuffer.size() == 1' in check and '.inverse()' in check and 'transformBuffer.push_back(bufferStream)' in check
    rebuild=bodies['void VDUStreamProcessor::bufferAffineTransform(']
    assert 'bufferClear(bufferId);' in rebuild and 'buffers[bufferId].push_back' in rebuild
    clear=bodies['void VDUStreamProcessor::bufferClear(']
    assert 'buffers.erase(bufferIter)' in clear and 'matrixMetadata.erase(bufferId)' in clear
    selector=bodies['void Context::setAffineTransform(']
    assert 'bitmapTransform = bufferId' in selector and 'bufferClear' not in selector
    draw=bodies['void Context::drawBitmap(']
    assert 'checkTransformBuffer(transformBuffer)' in draw and 'transformBuffer[1]->getBuffer()' in draw
    core_path=RACE/'.work/packages/baseline/helper/render_core.inc'
    core=core_path.read_text();actors=function(core,'static unsigned actors(')
    assert actors.count('matrix(o, r->matrix, r->xx, r->scale, r->translation)')==1
    assert 'a->resources->traffic_matrix_base + i' in actors and 'a->resources->sign_matrix' in actors
    # Current accepted sampler still has historical static helper definitions;
    # inspect the actual actor function, not a whole-file keyword count.
    current_path=RACE/'.work/packages/additive/helper/render_core.inc'
    current=current_path.read_text();current_actors=function(current,'static unsigned actors(')
    assert 'matrix(o,' not in current_actors
    names=[Path(__file__),HERE/'WORKLOAD.json',trace,core_path,current_path,
        RACE/'.work/packages/baseline/native-bindings.json',RACE/'guest/main.cpp',RACE/'guest/native.hpp',
        ROOT/'rally-game/src/main.cpp',ROOT/'rally-game/include/signs.hpp',ROOT/'rally-production/include/traffic.hpp',
        RACE/'fixtures/baseline/artwork.vdu',RACE/'fixtures/baseline/presentation.vdu']
    pins={str(p.relative_to(ROOT)):sha(p) for p in names}
    phase={key:result(stats['phase',key]) for key in ('warm','measured')}
    kinds={kind:result(stats['phase_kind','measured',kind]) for kind in ('traffic','sign')}
    ids={str(key):result(stats['matrix',key]) for key in [*traffic_ids,sign_id]}
    total=collections.Counter()
    for key in ('warm','measured'):total.update(stats['phase',key])
    report=dict(schema=1,analysis_only=True,actual_implementation_changed=False,emulator_run=False,
        trace_source='Frozen full-race affine baseline; two warm renders then900measured renders in original command order',
        measured_frames=900,warm_renders=2,measured_actor_draws=4867,
        per_matrix_state='One persistent last-written six-coefficient Q8 tuple per matrix_id; unknown initially; retains entries across invisible frames',
        overall=result(total),phase=phase,measured_by_kind=kinds,by_matrix_id_including_warm=ids,
        measured_identical_with_changed_bitmap=same_newbitmap,measured_identical_with_changed_position=same_moved,
        measured_identical_after_invisible_frame_gap=same_aftergap,
        measured_potential_omitted_resident_bytes_per_frame=phase['measured']['potential_omitted_resident_bytes']/900,
        current_native_ez80_uart_savings_claim=0,current_accepted_additive_actor_matrix_rebuilds=0,
        ownership=dict(traffic_matrix_ids=traffic_ids,sign_matrix_id=sign_id,sign_matrix_shared=True,
            player_mirror_id=player_id,player_mirror_loaded_once=True,measured_player_uses_affine=False,
            panorama_hud_change_matrix_selector_only=True,scope='Pinned isolated baseline fixture only; not a general global-ID reservation proof'),
        invalidation_conditions=['Any identity/replacement/composition/write/clear of one of the seven matrix buffers outside the tracked emission path',
            'VDP reset/reflash/restart, clear-all-buffers, application/profile reload or uncertain delivery',
            'Resource rebinding or another consumer reusing an ID; explicitly invalidate before InitRace/recovery/re-admission until buffer state is known',
            'A read-only bitmap plot, clip/viewport/selector change, or bitmap view change does not by itself alter matrix buffer contents or its inverse block'],
        boundaries=['Every draw still needs bitmap selection, placement, clipping and rendering; identical matrices do not imply identical pixels or static actors',
            'The sign ID is shared: compare the last write to that ID across all signs, never only the previous state of each sign object',
            'Counts include equal-coefficient matrices only; no angle/depth approximation and no table of all possible precomputed matrices',
            'Omitted27-byte matrix emitters would shorten resident VDP command buffers in the custom native path, not the eZ80-to-VDP UART frame stream',
            'The accepted additive sampler already avoids traffic/sign stock affine calls; this baseline analysis does not establish another gain for that candidate',
            'No game patch, target rerun, timing extrapolation orFPS estimate is supplied'],
        official_vdp_commit=VDP_PIN,official_vdp_source=official,source_sha256=pins,
        example_identical_events=examples)
    output=HERE/'MATRIX-REUSE.json';data=(json.dumps(report,indent=2)+'\n').encode()
    if output.exists():assert output.read_bytes()==data,'Preserve existing analysis'
    else:output.write_bytes(data)
    print(json.dumps(dict(measured=phase['measured'],kinds=kinds,changed_bitmap=same_newbitmap,
        changed_position=same_moved,after_gap=same_aftergap),indent=2))

if __name__=='__main__':main()
