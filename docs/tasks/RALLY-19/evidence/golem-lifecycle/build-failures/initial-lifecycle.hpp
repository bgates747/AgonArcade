// Full-scene transport/lifecycle diagnostic. Actual frontend uploads all art
// before this entry. Query readback is deliberately untimed and independent.
#include "render_readback.hpp"
bool lifecycleQueryInit(){
    const uint8_t reply[]={23,0,128,0};vdp_adv_clear_buffer(r19read::Query);
    vdp_adv_write_block_data(r19read::Query,4,(char*)reply);return waitForVDP();
}
bool lifecycleCollect(FILE*out,unsigned id,unsigned count,uint8_t*copy=nullptr){
    for(unsigned i=0;i<count;++i){uint8_t value;if(!r19read::query(id,i,value))return false;
        if(copy)copy[i]=value;if(out&&fwrite(&value,1,1,out)!=1)return false;}
    return true;
}
void lifecyclePhase(unsigned phase){
    char file[32];snprintf(file,sizeof(file),"phase-%u.snk",phase);marker(file);
    FILE*f=fopen("memory.phase","w");if(!f)exit(121);fprintf(f,"%u\n",phase);fclose(f);
    snprintf(file,sizeof(file),"ack-%u.snk",phase);awaitMarker(file);
}
int r19Lifecycle(){
    const bool fuji=motion.track==&rally::Fuji;
    const uint8_t canary[]={0x34,0x12};vdp_adv_write_block_data(55555,2,(char*)canary);
    vdp_swap();if(!lifecycleQueryInit())return 122;
    FILE*input=fopen("cases.dat","rb"),*output=fopen("lifecycle-events.dat","wb");if(!input||!output)return 123;
    uint8_t header[6];if(fread(header,1,6,input)!=6||memcmp(header,"G19A",4))return 124;
    unsigned cases=header[4]+256u*header[5];if(!cases||cases>512)return 125;
    uint16_t previousCount=0;unsigned accepted=0,reloads=0;
    for(unsigned index=0;index<cases;++index){
        uint8_t action[5],wire[97];if(fread(action,1,5,input)!=5)return 126;
        unsigned length=action[1]+256u*action[2],wait=action[3]+256u*action[4];
        if(length>97||wait>600||action[0]>1||fread(wire,1,length,input)!=length)return 127;
        if(action[0]){
            if(length||!golemRenderer.unload()||!waitForVDP())return 128;
            vdp_mode(0);vdp_mode(136);vdp_set_pixel_coordinates();vdp_cursor_enable(false);
            if(!golemRenderer.load(fuji)||!lifecycleQueryInit())return 129;
            previousCount=0;++reloads;
        }else if(length)r19read::send(wire,length);
        uint32_t begin=rawClock();while(rally::ticksSince(rawClock(),begin)<wait){}
        if(!waitForVDP())return 130;
        uint8_t status[10];
        if(!lifecycleCollect(output,1001,80)||!lifecycleCollect(output,1002,10,status)||
           !lifecycleCollect(output,1003,2)||!lifecycleCollect(output,1102,4)||
           !lifecycleCollect(output,1740,58)||!lifecycleCollect(output,1724,132)||
           !lifecycleCollect(output,1714,96)||!lifecycleCollect(output,1716,12))return 131;
        uint16_t count=status[4]+256u*status[5];
        if(count!=previousCount){vdp_swap();previousCount=count;++accepted;}
    }
    if(fgetc(input)!=EOF||ferror(input)||fclose(input)||fclose(output))return 132;
    if(!waitForVDP())return 133;lifecyclePhase(100);
    // Repeated mode changes, complete program teardown/reload and owned-ID
    // absence checks with a foreign canary. Artwork remains across these cycles.
    FILE*owned=fopen("owned.dat","rb"),*life=fopen("ownership.dat","wb");if(!owned||!life)return 134;
    uint16_t ids[1024];unsigned idCount=0;uint8_t pair[2];
    while(fread(pair,1,2,owned)==2){if(idCount==1024)return 135;ids[idCount++]=pair[0]+256u*pair[1];}
    if(ferror(owned)||fclose(owned)||idCount<800)return 136;
    for(unsigned cycle=0;cycle<3;++cycle){
        if(!golemRenderer.unload()||!waitForVDP())return 137;
        for(unsigned i=0;i<idCount;++i)if(!lifecycleCollect(life,ids[i],1))return 138;
        if(!lifecycleCollect(life,55555,2))return 139;
        lifecyclePhase(200+cycle);
        vdp_mode(0);vdp_mode(136);vdp_set_pixel_coordinates();vdp_cursor_enable(false);
        if(!golemRenderer.load(fuji)||!lifecycleQueryInit())return 140;
        rally::r18::pose(0,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        for(unsigned i=0;i<4;++i){if(!golemRenderer.prepare(motion,traffic,false,false))return 141;golemRenderer.submit();vdp_swap();}
        if(!waitForVDP())return 142;lifecyclePhase(300+cycle);
    }
    if(fclose(life))return 143;
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    if(!golemRenderer.unload())return 144;
    for(unsigned bitmap=0;bitmap<35;++bitmap)vdp_adv_clear_buffer(64000+bitmap);
    vdp_adv_clear_buffer(64100);vdp_adv_clear_buffer(63984);vdp_adv_clear_buffer(55555);vdp_adv_clear_buffer(r19read::Query);
    if(!waitForVDP())return 145;lifecyclePhase(400);
    FILE*f=fopen("lifecycle-summary.csv","w");if(!f)return 146;
    fprintf(f,"cases,accepted,reloads,cleanup_cycles,owned_ids\n%u,%u,%u,3,%u\n# complete\n",cases,accepted,reloads,idCount);
    if(fclose(f))return 147;marker("lifecycle-exit.snk");return 0;
}
