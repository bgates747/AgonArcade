// RALLY-17: batch measurements only; renderPose has no clock or pacing calls.
namespace {
uint32_t frames=0,roadBytes=0,poseHash=0,carCount=0;
rally::PollFence batchFence;
uint32_t rawClock() {
    uint32_t a,b;do {a=sys_vars->time;b=sys_vars->time;}while(a!=b);return b;
}
struct Backend {
    uint32_t ticks() {return rawClock();}
    uint8_t poll() {return reinterpret_cast<volatile uint8_t *>(sys_vars)[0x37];}
    void send(uint8_t token) {uint8_t v[]={23,0,128,token};mos_puts((char *)v,sizeof(v),0);}
} backend;
void marker(const char *name){FILE*f=fopen(name,"w");if(!f)exit(20);fclose(f);}
void awaitMarker(const char *name){for(;;){FILE*f=fopen(name,"r");if(f){fclose(f);return;}}}
bool completeBatch() {return batchFence.wait(backend,rally::FenceTimeout);}
bool renderPose(unsigned pose) {
    rally::workloadPose(pose,motion,traffic,false);
    motion.tick(false,false);traffic.tick(motion.track->length*100);
    road.render(stream,motion.phase,motion.position,motion.cameraOffset(),false);
    if(stream.overflow)return false;
    drawScenery();
    mos_puts((char *)stream.data,stream.size,0);
    carCount+=drawTraffic();
    vdp_select_bitmap(motion.view());
    vdp_adv_use_affine_matrix(1,motion.mirrored()?63984:65535);
    vdp_draw_bitmap(motion.carX()-19,149);
    vdp_adv_use_affine_matrix(1,65535);
    text(9,28,"TIMING FIXTURE");
    vdp_swap();sceneryHistory.swapped();
    ++frames;roadBytes+=stream.size;
    poseHash=rally::workloadHash(poseHash,motion,traffic);
    return true;
}
}
int main(int argc,char **argv) {
    const rally::TrackDef *track=&rally::TriOval;
    for(int i=1;i<argc;++i) if(strcmp(argv[i],"fuji")==0) track=&rally::Fuji;
    motion.track=road.track=track;road.fixedBands=true;road.init();
    // STARTUP is injected verbatim from the frozen game, plus section upload.
    /* STARTUP */
    vdp_swap();sceneryHistory.swapped();
    if(!completeBatch())return 2;
    for(unsigned i=0;i<rally::WorkloadWarmup;++i)if(!renderPose(0))return 3;
    if(!completeBatch())return 4;
    frames=roadBytes=poseHash=carCount=0;
    marker("start.snk");awaitMarker("go.snk");
    const uint32_t start=rawClock();
    for(unsigned pose=0;pose<rally::WorkloadFrames;++pose)if(!renderPose(pose))return 5;
    while(!(IO(UART0_LSR)&UART0_LSR_TEMT)){}
    const uint32_t submitted=rawClock();
    marker("done.snk");awaitMarker("stop.snk");
    const bool completed=completeBatch();
    const uint32_t end=rawClock();
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    FILE *file=fopen("unpaced.csv","w");
    if(!file)return 6;
    fprintf(file,"frames,submit_ticks,drain_ticks,total_ticks,completed,road_bytes,cars,pose_hash\n");
    fprintf(file,"%lu,%lu,%lu,%lu,%u,%lu,%lu,%lu\n",(unsigned long)frames,
      (unsigned long)rally::ticksSince(submitted,start),(unsigned long)rally::ticksSince(end,submitted),
      (unsigned long)rally::ticksSince(submitted,start),unsigned(completed),(unsigned long)roadBytes,
      (unsigned long)carCount,(unsigned long)poseHash);
    fprintf(file,"# complete\n");fclose(file);
    printf("Unpaced batch complete: %lu frames; VDP completion %u.\n",(unsigned long)frames,unsigned(completed));
    return completed?0:7;
}
