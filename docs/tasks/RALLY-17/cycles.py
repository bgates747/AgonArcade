"""Read stock debugger cycle deltas at existing batch boundaries; no guest edits."""
import experiment as e
import re,subprocess,json
s=json.loads(e.STATE.read_text())
for variant,info in s['variants'].items():
    remote=re.search(r'Build directory: (.+)',info['build_evidence'])[1]
    mapping=subprocess.check_output(['ssh','agon-linux','cat '+remote+'/bin/rally.map'],text=True)
    dis=subprocess.check_output(['ssh','agon-linux','/home/smith/Agon/agondev/release/bin/ez80-none-elf-objdump -dr '+remote+'/obj/main.o'],text=True)
    (e.WORK/(variant+'.map')).write_text(mapping)
    (e.WORK/(variant+'-disasm.txt')).write_text(dis)
    base=int(re.search(r'(0x[0-9a-f]+)\s+_main\s*$',mapping,re.M)[1],16)
    main=dis[dis.index('<_main>:'):dis.index('\n0000',dis.index('<_main>:'))]
    temt=main.index('in0 a,(0xc5)')
    before=main[:temt];after=main[temt:]
    # The last call before the TEMT loop is renderPose; rawClock is the last
    # call before the measured loop setup, identified by its symbol's offset.
    clock=int(re.search(r'([0-9a-f]+) <__ZN12_GLOBAL__N_18rawClockEv>',dis)[1],16)
    calls=list(re.finditer(r'^\s*([0-9a-f]+):.*\bcall 0x0*'+f'{clock:x}'+r'\s*$',main,re.M))
    start=[m for m in calls if m.start()<temt][-1]
    end=[m for m in calls if m.start()>temt][0]
    info['breakpoints']=[base+int(m[1],16) for m in (start,end)]
    binary=(e.Path(info['root'])/'bin/rally.bin').read_bytes()
    for addr in info['breakpoints']:
        assert binary[addr-0x40000]==0xcd,(variant,hex(addr))
    print(variant,[hex(x) for x in info['breakpoints']],flush=True)
e.CYCLE_MODE=True
(e.TASK/'cycle-results').mkdir(exist_ok=True)
for variant in s['variants']:
    for suffix in ('.map','-disasm.txt'):
        e.shutil.copy2(e.WORK/(variant+suffix),e.TASK/'cycle-results'/(variant+suffix))
e.bench(s)
