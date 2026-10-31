"""Additional setup, out-of-window counters and private-cleanup checks."""
from pathlib import Path
import csv
import json
import struct

HERE=Path(__file__).resolve().parent


def check(directory,result):
    directory=Path(directory)
    setup=json.loads((directory/'setup.json').read_text())
    final=json.loads((directory/'prepared.json').read_text())
    expected=json.loads((HERE/'HOST-FIXTURE.json').read_text())
    assert setup['complete'] and setup['images']==setup['registered']==901
    assert setup['pixel_checks']==963 and setup['drawing_page']==1
    assert setup['setup_prt_restored'] and result['timer_restored']
    assert setup['cold_mos_ticks']>=setup['install_mos_ticks']>=setup['verified_install_mos_ticks']>0
    assert setup['verified_install_prt_units']>0
    assert all(final[k] for k in ('complete','cleaned','counters_ok'))
    assert not final['generation_resynced_for_failure']
    assert final['cleanup_absent']==901 and final['baseline_buffers']==final['cleanup_buffers']
    assert final['setup_reply_end']==setup['install_reply_end']<final['timed_reply_begin']
    assert final['timed_reply_end']-final['timed_reply_begin']==2*result['frames']
    assert final['timed_token_begin']==final['timed_reply_begin'] and final['timed_token_end']==final['timed_reply_end']
    watermarks=[setup['loaded_stack'],setup['installed_stack'],result['stack_before'],result['stack_after'],final['cleanup_stack']]
    assert all(0<v<65536 for v in watermarks)
    assert all(a>=b for a,b in zip(watermarks,watermarks[1:])),watermarks
    assert result['unloaded'] and result['post_swap_fenced']
    assert (directory/'setup-state-before.bin').read_bytes()==(directory/'setup-state-after.bin').read_bytes()
    state=(directory/'setup-state-before.bin').read_bytes();assert len(state)==406
    assert struct.unpack_from('<I',state,20)[0]==0
    counters=(directory/'cache-counters.bin').read_bytes();assert len(counters)==32
    counters=struct.unpack('<8I',counters)
    assert list(counters)==expected['expected_counters']
    assert counters[3:]==(0,0,0,0,0)
    memory=list(csv.DictReader((directory/'setup-memory.csv').open()))
    stages=[r['stage'] for r in memory]
    for stage in ('baseline','index','small_probe','installed','race_ready','race_end','retained','cleanup'):assert stages.count(stage)==1,stage
    assert [int(r['id']) for r in memory if r['stage']=='image']==list(range(52000,52901))
    assert len(memory)==909
    by_stage={r['stage']:r for r in memory if r['stage']!='image'}
    assert int(by_stage['baseline']['free_psram'])==final['baseline_psram']==setup['baseline_psram']
    assert int(by_stage['cleanup']['free_psram'])==final['cleanup_psram']
    pixels=list(csv.DictReader((directory/'setup-pixels.csv').open()))
    assert len(pixels)==963 and all(r['expected']==r['actual'] for r in pixels)
    assert [int(r['id']) for r in pixels if r['kind']=='registration']==list(range(52000,52901))
    return dict(setup=setup,final=final,counters=list(counters),
        watermarks_bytes=watermarks,private_collection_cleanup_verified=True,
        psram_cleanup_residual=final['baseline_psram']-final['cleanup_psram'],
        internal_cleanup_residual=final['baseline_internal']-final['cleanup_internal'])
