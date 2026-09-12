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
// Replaces only r19CpuBenchmark in a separate calibration binary.
int r19CpuBenchmark(){
    constexpr unsigned Cases=32,Repeats=64;
    const uint32_t seeds[]={0,250,65530,0xfffffff0UL};
    const uint24_t sizes[]={0,1,1,3,9,14,97,2048};
    struct Row {unsigned kind;uint32_t seed,bytes,calls;};
    Row rows[Cases]{};char data[2048]{};
    for(unsigned index=0;index<Cases;++index){
        unsigned kind=index/4;uint32_t seed=seeds[index%4];uint24_t size=sizes[kind];
        r19SinkBytes=r19SinkCalls=seed;r19ZeroLength=false;r19Sink=true;
        r19WorkBegin();
        if(kind)for(unsigned i=0;i<Repeats;++i){
            if(kind==1)putch(0x55);else mos_puts(data,size,0);
        }
        r19WorkEnd();
        r19Sink=false;if(r19ZeroLength)return 61;
        rows[index]={kind,seed,r19SinkBytes,r19SinkCalls};
    }
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    if(!waitForVDP())return 62;
    FILE*f=fopen("cpu-calibration.csv","w");if(!f)return 63;
    fprintf(f,"kind,seed,bytes,calls\n");
    for(const auto&r:rows)fprintf(f,"%u,%lu,%lu,%lu\n",r.kind,(unsigned long)r.seed,(unsigned long)r.bytes,(unsigned long)r.calls);
    fprintf(f,"# complete\n");if(fclose(f))return 64;
    marker("cpu-calibration.snk");return 0;
}
