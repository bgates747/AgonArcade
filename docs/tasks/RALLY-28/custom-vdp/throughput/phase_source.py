"""Read-only pinned implementation audit supporting raw-cycle diagnostic scopes."""
from pathlib import Path
import hashlib
import json
import subprocess
from phase_shared import HERE,PACED,ROOT,WORK

sha=lambda data:hashlib.sha256(data).hexdigest()


def source_audit():
    repository=ROOT.parent/'flexe-agon-emulator'
    frontend='1f7ea21d41a7e1f11fe89848a559e27ce7828423'
    tree=subprocess.check_output(['git','-C',str(repository),'ls-tree',frontend,'vendor/flexe'],text=True)
    vendor=tree.split()[2]
    assert vendor=='fbda8e905ccff36a090e4e33b0ffc2337dd79c52'
    output={}
    for relative in ('src/xtensa.c','src/jit.c'):
        data=subprocess.check_output(['git','-C',str(repository/'vendor/flexe'),'show',vendor+':'+relative])
        text=data.decode();needles=(['case XT_SR_CCOUNT:      return cpu->ccount;'] if relative.endswith('xtensa.c') else
            ['case XT_SR_CCOUNT:   off = CPU_OFF_CCOUNT;',
             'emit_add_reg32_imm32(e, RAX, insn_idx);',
             'CPU_OFF_JIT_TIME_ACCOUNTED'])
        assert all(n in text for n in needles),(relative,'Changed CCOUNT accounting')
        output[relative]=dict(sha256=sha(data),checks=needles)
    original=json.loads((PACED/'STOCK-PATH.json').read_text())
    for filename,digest in original['files'].items():
        assert sha(Path(filename).read_bytes())==digest,filename
    firmware=ROOT.parent/'agon-vdplet/build/firmware/firmware-src'
    gl=firmware/'.pio/libdeps/esp32dev/vdp-gl/src'
    checks={firmware/'video/agon_screen.h':['inline void waitPlotCompletion(bool waitForVSync = false)',
        'canvas->waitCompletion(waitForVSync);','canvas->swapBuffers();'],
        gl/'canvas.cpp':['void Canvas::swapBuffers()','p.notifyTask = xTaskGetCurrentTaskHandle();',
            'm_displayController->primitivesExecutionWait();','m_displayController->processPrimitives();'],
        gl/'displaycontroller.cpp':['primitive.cmd == PrimitiveCmd::SwapBuffers',
            'ulTaskNotifyTake(true, portMAX_DELAY);','case PrimitiveCmd::SwapBuffers:',
            'xTaskNotifyGive(prim.notifyTask);']}
    for path,needles in checks.items():
        assert all(n in path.read_text() for n in needles),str(path)
    system=firmware/'video/vdu_sys.h'
    data=system.read_bytes();assert b'VDP_FLUSH_DRAWING_QUEUE' in data and b'// VDU 23, 0, &CA' in data
    compiled={}
    for name in ('control','float-quad-layered'):
        file=WORK/name/'target/phase-render.disassembly.txt'
        assembly=file.read_text();assert 'rsr.ccount' in assembly and 'rsr.prid' in assembly
        compiled[name]=dict(disassembly_sha256=sha(file.read_bytes()),
            ccount_instruction_sites=assembly.count('rsr.ccount'),
            prid_instruction_sites=assembly.count('rsr.prid'))
    result=dict(frontend_base_commit=frontend,pinned_flexe_vendor=vendor,source_files=output,
        pinned_graphics_files_unchanged=original['files'],flush_selector=202,
        vdu_sys_sha256=sha(data),target_counter_instructions=compiled,
        ccount_semantics='Raw per-core counter. Pinned interpreter exposesCCOUNT; JIT adds chained-block/instruction prefix and subtracts time already charged. Abstract guest instruction accounting is not calibrated ESP32 cycles.',
        swap_boundary='In double buffering, stock swap queues its controller primitive and waits for the executing task notification; worker notifies after swapBuffers. Resident final marker follows swap then stockCA drain. This is controller swap completion, not full monitor scanout.',
        emulator_run=False,ccount_runtime_progress_qualified=False,firmware_changed=False)
    (HERE/'phase_SOURCE.json').write_text(json.dumps(result,indent=2)+'\n')
    print('Pinned CCOUNT / stock swap-and-drain source audit PASS; no emulator launch')


if __name__=='__main__':source_audit()
