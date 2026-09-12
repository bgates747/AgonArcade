// R19-10 diagnostic-only CPU/command-construction probe. Never a game renderer.
// Included after the unchanged frontend's scene helpers, inside its namespace.
volatile bool r19Sink=false,r19ZeroLength=false;
volatile uint32_t r19SinkBytes=0,r19SinkCalls=0;
extern "C" void r19RealPuts(const char*,uint24_t,char) asm("__real__mos_puts");
extern "C" void r19WrappedPuts(const char*,uint24_t,char) asm("__wrap__mos_puts");
extern "C" int r19RealPutch(int) asm("__real__putch");
extern "C" int r19WrappedPutch(int) asm("__wrap__putch");
extern "C" void r19WrappedPuts(const char *data,uint24_t size,char delimiter){
    if(r19Sink){
        ++r19SinkCalls;r19SinkBytes+=size;if(!size)r19ZeroLength=true;
    }else r19RealPuts(data,size,delimiter);
}
extern "C" int r19WrappedPutch(int value){
    if(r19Sink){++r19SinkCalls;++r19SinkBytes;return value;}
    return r19RealPutch(value);
}
extern "C" __attribute__((noinline)) void r19WorkBegin(){asm volatile("nop":::"memory");}
extern "C" __attribute__((noinline)) void r19WorkEnd(){asm volatile("nop\nnop":::"memory");}
struct R19CpuRow {uint32_t bytes,calls,hash;};
int r19CpuBenchmark(){
    R19CpuRow rows[rally::WorkloadFrames]{};uint32_t hash=0;
    vdp_swap();if(oracleRenderer)sceneryHistory.swapped();if(!waitForVDP())return 51;
    for(unsigned i=0;i<rally::WorkloadWarmup;++i){
        rally::r18::pose(0,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        if(oracleRenderer){prepareScene();drawScene();sceneryHistory.swapped();}
        else{
            if(!golemRenderer.prepare(motion,traffic,false,false))return 52;
            golemRenderer.submit();text(9,28,"TIMING FIXTURE");vdp_swap();
        }
    }
    if(!waitForVDP())return 53;
    for(unsigned pose=0;pose<rally::WorkloadFrames;++pose){
        // Raw fixture setup and the original physics tick are outside the span.
        rally::r18::pose(pose,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        r19SinkBytes=r19SinkCalls=0;r19ZeroLength=false;r19Sink=true;
        bool valid=true;
        r19WorkBegin();
        if(oracleRenderer){prepareScene();drawScene();sceneryHistory.swapped();}
        else{
            valid=golemRenderer.prepare(motion,traffic,false,false);
            if(valid){golemRenderer.submit();text(9,28,"TIMING FIXTURE");vdp_swap();}
        }
        r19WorkEnd();
        r19Sink=false;
        if(!valid || r19ZeroLength || (oracleRenderer && stream.overflow))return 54;
        hash=rally::workloadHash(hash,motion,traffic);
        rows[pose]={r19SinkBytes,r19SinkCalls,hash};
    }
    // No swallowed frame is counted as a VDP-rendered frame. Only the two
    // warmups reached the VDP; the CPU-only sequence ends before any more draws.
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    if(!oracleRenderer && !golemRenderer.unload())return 55;
    for(unsigned bitmap=0;bitmap<35;++bitmap)vdp_adv_clear_buffer(64000+bitmap);
    vdp_adv_clear_buffer(64100);vdp_adv_clear_buffer(63984);
    if(!waitForVDP())return 56;
    FILE*f=fopen("cpu-work.csv","w");if(!f)return 57;
    fprintf(f,"pose,bytes,calls,hash\n");
    for(unsigned i=0;i<rally::WorkloadFrames;++i)
        fprintf(f,"%u,%lu,%lu,%lu\n",i,(unsigned long)rows[i].bytes,(unsigned long)rows[i].calls,(unsigned long)rows[i].hash);
    fprintf(f,"# complete\n");if(fclose(f))return 58;
    marker("cpu-exit.snk");return 0;
}
