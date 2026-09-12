// Diagnostic entry: accepted input/physics under deterministic keys and clock.
// No sink, projected geometry, custom VDP commands or firmware modifications.
#include "render_readback.hpp"
#include "replay_step.hpp"
unsigned replayFrames=18064;
void replayMemory(unsigned phase){
    FILE*f=fopen("memory.phase","w");if(f){fprintf(f,"%u\n",phase);fclose(f);}
}
int r19Stability(){
    vdp_swap();if(!waitForVDP())return 101;
    marker("start.snk");awaitMarker("go.snk");
    uint32_t begin=rawClock(),next=begin;
    for(unsigned frame=0;frame<replayFrames;++frame){
        while(!rally::tickDue(rawClock(),next)){}
        next=rawClock()+4;
        if(!replayStep(frame))return 102;
        if(!golemRenderer.prepare(motion,traffic,demoMode,autosteer))return 103;
        golemRenderer.submit();
        if(demoMode)text(7,28,"PRESS ANY KEY TO RACE");
        else {char hud[41];
            snprintf(hud,sizeof(hud),"SPEED %03ld  UP/DN  -= GRIP  ESC QUIT",(long)motion.speed);text(1,28,hud);
            snprintf(hud,sizeof(hud),"%s L/R%+d GRIP%03d%% %s",motion.track==&rally::Fuji?"FUJI":"TRI-OVAL",motion.steering,motion.grip,motion.surfaceName());text(1,29,hud);}
        vdp_swap();
    }
    if(!waitForVDP())return 104;
    uint32_t ticks=rally::ticksSince(rawClock(),begin);
    // Independent guest UART/GP readback validates the external accessor ABI.
    uint8_t status[12]{},active[80]{};
    if(!r19read::admission(status))return 105;
    const uint8_t reply[]={23,0,128,0};vdp_adv_write_block_data(r19read::Query,4,(char*)reply);
    for(unsigned i=0;i<80;++i)if(!r19read::query(1001,i,active[i]))return 106;
    vdp_adv_clear_buffer(r19read::Query);if(!waitForVDP())return 107;
    FILE*f=fopen("replay-readback.dat","wb");if(!f)return 108;
    if(fwrite(status,1,12,f)!=12||fwrite(active,1,80,f)!=80){fclose(f);return 109;}if(fclose(f))return 110;
    replayMemory(100);marker("done.snk");awaitMarker("stop.snk");
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    if(!golemRenderer.unload())return 111;
    for(unsigned bitmap=0;bitmap<35;++bitmap)vdp_adv_clear_buffer(64000+bitmap);
    vdp_adv_clear_buffer(64100);vdp_adv_clear_buffer(63984);
    if(!waitForVDP())return 112;
    replayMemory(200);
    f=fopen("replay-summary.csv","w");if(!f)return 113;
    fprintf(f,"frames,ticks,scene_bytes,cleanup\n%u,%lu,%lu,1\n# complete\n",replayFrames,(unsigned long)ticks,(unsigned long)golemRenderer.sceneBytes);
    if(fclose(f))return 114;marker("replay-exit.snk");return 0;
}
