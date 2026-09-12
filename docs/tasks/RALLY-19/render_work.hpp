// Real normal-UART rendering diagnostic. No linker output sink or substitutions.
#include "render_readback.hpp"
uint32_t r19ApplicationStart=0;
extern "C" __attribute__((noinline)) void r19BatchBegin(){asm volatile("nop":::"memory");}
extern "C" __attribute__((noinline)) void r19BatchEnd(){asm volatile("nop\nnop":::"memory");}
struct R19RenderRow {uint32_t start,physics,prepare,submit,hash,roadBytes;};
int r19RenderBenchmark(){
    R19RenderRow rows[rally::WorkloadFrames]{};uint32_t hash=0;
    vdp_swap();if(oracleRenderer)sceneryHistory.swapped();if(!waitForVDP())return 71;
    for(unsigned i=0;i<rally::WorkloadWarmup;++i){
        rally::r18::pose(0,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        if(oracleRenderer){prepareScene();drawScene();sceneryHistory.swapped();}
        else{
            if(!golemRenderer.prepare(motion,traffic,false,false))return 72;
            golemRenderer.submit();text(9,28,"TIMING FIXTURE");vdp_swap();
        }
    }
    if(!waitForVDP())return 73;
    const uint32_t readyTicks=rally::ticksSince(rawClock(),r19ApplicationStart);
    marker("start.snk");awaitMarker("go.snk");
    uint32_t begin=rawClock();r19BatchBegin();
    for(unsigned pose=0;pose<rally::WorkloadFrames;++pose){
        uint32_t start=rawClock();
        rally::r18::pose(pose,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        uint32_t physicsEnd=rawClock();
        if(oracleRenderer)prepareScene();
        else if(!golemRenderer.prepare(motion,traffic,false,false))return 74;
        uint32_t prepared=rawClock();
        if(oracleRenderer){drawScene();if(stream.overflow)return 75;sceneryHistory.swapped();}
        else {golemRenderer.submit();text(9,28,"TIMING FIXTURE");vdp_swap();}
        uint32_t submitted=rawClock();
        hash=rally::workloadHash(hash,motion,traffic);
        rows[pose]={rally::ticksSince(start,begin),rally::ticksSince(physicsEnd,start),
                    rally::ticksSince(prepared,physicsEnd),rally::ticksSince(submitted,prepared),hash,
                    oracleRenderer?uint32_t(stream.size):0};
    }
    while(!(IO(UART0_LSR)&UART0_LSR_TEMT)){}
    r19BatchEnd();const uint32_t batchTicks=rally::ticksSince(rawClock(),begin);
    marker("done.snk");awaitMarker("stop.snk");
    uint32_t drainBegin=rawClock();if(!waitForVDP())return 76;
    const uint32_t parserDrainTicks=rally::ticksSince(rawClock(),drainBegin);
    uint8_t status[12]{};
    if(!oracleRenderer && !r19read::admission(status))return 77;
    if(oracleRenderer)saveScene();
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    if(!oracleRenderer && !golemRenderer.unload())return 78;
    for(unsigned bitmap=0;bitmap<35;++bitmap)vdp_adv_clear_buffer(64000+bitmap);
    vdp_adv_clear_buffer(64100);vdp_adv_clear_buffer(63984);
    if(!waitForVDP())return 79;
    FILE*f=fopen("render-rows.csv","w");if(!f)return 80;
    fprintf(f,"pose,start_ticks,physics_ticks,prepare_ticks,submit_ticks,hash,road_bytes\n");
    for(unsigned i=0;i<rally::WorkloadFrames;++i){const auto&r=rows[i];
        fprintf(f,"%u,%lu,%lu,%lu,%lu,%lu,%lu\n",i,(unsigned long)r.start,(unsigned long)r.physics,
                (unsigned long)r.prepare,(unsigned long)r.submit,(unsigned long)r.hash,(unsigned long)r.roadBytes);}
    fprintf(f,"# complete\n");if(fclose(f))return 81;
    f=fopen("render-summary.csv","w");if(!f)return 82;
    fprintf(f,"oracle,frames,batch_ticks,ready_ticks,data_load_ticks,parser_drain_ticks,hash,host_scene_bytes,valid,wrap,count,last,error,expected\n");
    fprintf(f,"%u,64,%lu,%lu,%lu,%lu,%lu,%lu",unsigned(oracleRenderer),(unsigned long)batchTicks,
            (unsigned long)readyTicks,(unsigned long)(oracleRenderer?roadLoadTicks:startupTicks),
            (unsigned long)parserDrainTicks,(unsigned long)hash,(unsigned long)(oracleRenderer?0:64UL*97));
    for(unsigned i=0;i<6;++i)fprintf(f,",%u",unsigned(status[i*2])+256u*status[i*2+1]);
    fprintf(f,"\n# complete\n");if(fclose(f))return 83;
    marker("render-exit.snk");return 0;
}
