void drawScenery() {
    const int top=panelVisible()?88:HudHeight,offset=scene.skyOffset;
    vdp_adv_use_affine_matrix(1,65535);
    if(scene.skyDelta) {++fs::scrollCalls;
        skyViewport(stream,0,top,319,rally::RoadTop-1);flush();
        vdp_scroll_screen_extent(2,scene.skyDelta>0?1:0,scene.skyDelta>0?scene.skyDelta:-scene.skyDelta);
    }
    vdp_select_bitmap(100);
    if(scene.skyRepaint) {++fs::repaintCalls;
        skyViewport(stream,scene.skyLeft,top,scene.skyRight,rally::RoadTop-1);flush();
        if(1024-offset>scene.skyLeft)vdp_draw_bitmap(-offset,0);
        if(1024-offset<=scene.skyRight)vdp_draw_bitmap(1024-offset,0);
    }
    if(!scene.skyRepaint || scene.skyDelta) {++fs::skyRepairCalls;
        skyViewport(stream,0,rally::RoadTop-16,319,rally::RoadTop-1);flush();
        vdp_draw_bitmap(-offset,0);if(offset>704)vdp_draw_bitmap(1024-offset,0);
    }
    viewport(stream,0,rally::RoadTop,319,239);flush();
}
void clockText(char *out,unsigned size,uint32_t ticks) {
    const uint32_t hundredths=ticks*100/Hz;
    snprintf(out,size,"%01lu'%02lu\"%02lu",(unsigned long)(hundredths/6000),
             (unsigned long)(hundredths/100%60),(unsigned long)(hundredths%100));
}
void drawHud(uint32_t interval) {
    HudImage image;char value[48],time[20];
    const bool active=driving(rules.phase) || result(rules.phase) || rules.phase==Phase::Qualified;
    const auto &record=records.entries[Records::key(selected==&rally::Fuji,rules.policy==Policy::Arcade,
        steeringStep,active?rules.maxGrip:motion.grip)];
    topScore=record.score;
    snprintf(value,sizeof(value),"TOP %07lu",(unsigned long)topScore);image.put(0,0,value,11);
    snprintf(value,sizeof(value),"TIME %03lu",(unsigned long)((rules.remaining+Hz-1)/Hz));image.put(14,0,value,11);
    clockText(time,sizeof(time),driving(rules.phase)?rules.elapsed-rules.lapBegin:rules.lapTime);
    snprintf(value,sizeof(value),"LAP %s",time);image.put(25,0,value,15);
    snprintf(value,sizeof(value),"SCORE %07lu",(unsigned long)rules.score);image.put(0,1,value);
    snprintf(value,sizeof(value),"SPEED %03ld",(long)motion.speed);image.put(16,1,value);
    if(rules.policy==Policy::Circuit && (rules.phase==Phase::Race || rules.phase==Phase::Finished || rules.phase==Phase::TimeUp)) {
        snprintf(value,sizeof(value),"POS %d/7",rules.rank);image.put(30,1,value,11);
    }
#ifdef RALLY_DEVELOPMENT
    snprintf(value,sizeof(value),"W%+03d G%03d%% %s DT%02lu B%02u C%u S%u",motion.steering,
             motion.grip,motion.surfaceName(),(unsigned long)interval,road.bands,scene.cars,steeringStep);
    image.put(0,2,value,14);
#else
    (void)interval;
#endif
    hud.emit(stream,sceneryHistory.slot,image);flush();
}
void bottom() {
    if(rules.phase==Phase::Attract)text(2,28,"ARROWS DRIVE   -= GRIP   M MUTE",15,0);
    else if(rules.phase==Phase::Qualify)text(1,28,"QUALIFYING LAP",11,0);
    else if(rules.phase==Phase::Race) {
        char s[40];snprintf(s,sizeof(s),"%s  LAP %u/%u",rules.policy==Policy::Circuit?"RACE":"ARCADE",
            unsigned(rules.laps+1),unsigned(rules.settings.laps));text(1,28,s,15,0);
        if(rules.extensionNotice)text(23,28,"TIME EXTENDED!",11,0);
    }
}
void drawPlayer() {
    if(crash.remaining) {
        const int age=150-crash.remaining,centre=scene.playerCentre,y=193;
        // Original integer radial bursts, refreshed by road spans every frame.
        const int dx[]={0,7,10,7,0,-7,-10,-7},dy[]={-10,-7,0,7,10,7,0,-7};
        int radius=8+(age<60?age/3:20-(age-60)/5);if(radius<4)radius=4;
        for(unsigned i=0;i<8;++i) {
            int x=centre+dx[i]*radius/10,yy=y+dy[i]*radius/10;
            int size=3+(int(i)+age/8)%6;
            stream.rect(x-size,yy-size,x+size,yy+size,(i+unsigned(age/6))%3==0?15:((i&1)?11:9));
        }
        stream.rect(centre-6,y-6,centre+6,y+6,15);flush();return;
    }
    if(crash.invulnerable && ((crash.invulnerable/10)&1))return;
    vdp_select_bitmap(scene.playerBitmap);vdp_adv_use_affine_matrix(1,scene.playerMirror?63984:65535);
    vdp_draw_bitmap(scene.playerX,rally::r18::PlayerDrawY);vdp_adv_use_affine_matrix(1,65535);
}
