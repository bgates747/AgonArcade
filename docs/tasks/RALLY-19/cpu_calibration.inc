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
