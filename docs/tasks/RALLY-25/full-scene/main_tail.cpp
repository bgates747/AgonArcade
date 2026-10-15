}
int main() {
    const char *oldOutputs[]={"result.json","failure.txt","state.bin","player.csv","ticks.bin","prt.bin","replies.bin","stages.csv"};
    for(const char *name:oldOutputs)mos_del(name);
    selected=&rally::Fuji;rules.policy=Policy::Circuit;
    motion.track=selected;motion.grip=200;motion.position=selected->length*100-6800;
    motion.lateral=motion.lateralVelocity=motion.steering=0;motion.phase=0;motion.cornerAssist=false;
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_reset_sprites();vdp_cursor_enable(false);
    loadCars();loadFont();loadSigns();
    if(!fs::setup())goto failed;
    engine.start(send);
    {
        uint32_t times[fs::FrameCount+1],prts[fs::FrameCount+1];
        uint32_t cpu=0,scenery=0,hudMs=0,frames=0,audioChanges=0;
        full_scene::Player player;
        auto paint=[&](unsigned interval){
            uint32_t begin=fs::timer();
            int32_t p=motion.position/100*256+(motion.position%100)*256/100;
            auto heading=rally::trackSample(p,*motion.track);
            const int offset=rally::sceneryHeading(heading.tx,heading.ty);
            auto u=sceneryHistory.prepare(offset);scene.skyOffset=offset;scene.skyDelta=u.delta;
            scene.skyLeft=u.left;scene.skyRight=u.right;scene.skyRepaint=u.repaint;
            scenery+=fs::difference(fs::timer(),begin);
            drawScenery();
            fs::render();if(!fs::healthy)return;
            for(auto id:fs::Outputs)fs::command(id,1);
            viewport(stream,0,0,319,239);flush();
            begin=fs::timer();uint32_t sending=fs::sendMs;
            drawPanel();drawHud(interval);bottom();
            uint32_t cost=fs::difference(fs::timer(),begin),io=fs::sendMs-sending;
            if(cost>=io)hudMs+=cost-io;
            vdp_swap();sceneryHistory.swapped();
        };
        // Warm both retained pages at tick0, outside measured work.
        paint(0);paint(0);if(!fs::healthy)goto failed;
        fs::startTimer();if(!fs::healthy)goto failed;
        uint16_t stackBefore=0;{uint8_t p[2]={17,0};stackBefore=fs::transaction(4,p,2,4);}
        fs::sendMs=fs::waitMs=0;fs::wireBytes=0;scenery=hudMs=0;
        times[0]=fs::now();prts[0]=fs::timer();
        for(unsigned frame=0;frame<fs::FrameCount&&fs::healthy;++frame){
            for(unsigned i=0;i<16;++i)heldKeys[i]=vdp_getKeyMap(i);
            for(unsigned step=0;step<4&&fs::healthy;++step){
                uint32_t begin=fs::timer();
                player.tick(motion,rules);
                cpu+=fs::difference(fs::timer(),begin);
                fs::snapshot(motion.position,motion.lateral,uint16_t(motion.phase),int16_t(motion.steering));fs::tick();
            }
            unsigned pitch=engine.frequency;engine.update(motion.speed,send);if(engine.frequency!=pitch)++audioChanges;paint(4);if(!fs::healthy)break;
            ++frames;times[frames]=fs::now();prts[frames]=fs::timer();
        }
        if(!fs::healthy)goto failed;
        const uint32_t window=times[frames]-times[0],prtWindow=fs::difference(prts[frames],prts[0]);
        const uint32_t submission=fs::sendMs,waits=fs::waitMs,bytes=fs::wireBytes;
        uint16_t stackAfter=0;{uint8_t p[2]={17,0};stackAfter=fs::transaction(4,p,2,4);}
        uint8_t state[fs::StateBytes];unsigned at=0;
        for(const auto &b:fs::Buffers)for(unsigned offset=0;offset<b.bytes;offset+=2){
            fs::put16(state+at,fs::read16(b.id,b.offset+offset));at+=2;
        }
        if(!fs::healthy)goto failed;
        fs::stop();engine.stop(send);if(!fs::healthy)goto failed;
        bool saved=fs::save("state.bin",state,at)&&fs::save("ticks.bin",times,(frames+1)*sizeof(uint32_t))
            &&fs::save("prt.bin",prts,(frames+1)*sizeof(uint32_t))&&fs::save("replies.bin",fs::transcript,fs::transcriptBytes);
        FILE *f=fopen("stages.csv","wb");if(f){
            fprintf(f,"player_rules_prt_ms,scenery_math_prt_ms,hud_cpu_estimate_prt_ms,submission_prt_ms,reply_wait_prt_ms,loop_prt_ms,wire_bytes\r\n%lu,%lu,%lu,%lu,%lu,%lu,%lu\r\n",
                (unsigned long)cpu,(unsigned long)scenery,(unsigned long)hudMs,(unsigned long)submission,(unsigned long)waits,(unsigned long)prtWindow,(unsigned long)bytes);saved=fclose(f)==0&&saved;
        }else saved=false;
        f=fopen("player.csv","wb");if(f){fprintf(f,"station,phase,speed,lateral,steering,rules_ticks\r\n%ld,%ld,%ld,%ld,%d,%lu\r\n",
            (long)motion.position,(long)motion.phase,(long)motion.speed,(long)motion.lateral,motion.steering,(unsigned long)rules.phaseTicks);saved=fclose(f)==0&&saved;}else saved=false;
        if(!saved){fs::fail("Result file write");goto failed;}
        f=fopen("result.json","wb");if(!f){fs::fail("Result file open");goto failed;}
        fprintf(f,"{\"schema\":1,\"valid\":true,\"frames\":%lu,\"physics_ticks\":%lu,\"mos_tick_hz\":120,\"elapsed_mos_ticks\":%lu,\"prt_ticks\":%lu,\"stack_before\":%u,\"stack_after\":%u,\"scroll_calls\":%lu,\"repaint_calls\":%lu,\"audio_changes\":%lu,\"request\":%lu,\"generation\":%lu,\"timer_restored\":true,\"unloaded\":true}\n",
            (unsigned long)frames,(unsigned long)fs::world,(unsigned long)window,(unsigned long)prtWindow,unsigned(stackBefore),unsigned(stackAfter),(unsigned long)fs::scrollCalls,(unsigned long)fs::repaintCalls,(unsigned long)audioChanges,(unsigned long)fs::request,(unsigned long)fs::generation);
        if(fclose(f)){fs::fail("Result file close");goto failed;}
        printf("RALLY-25 FULL SCENE DONE: logs saved.\n");return 0;
    }
failed:
    fs::stop();engine.stop(send);
    {FILE *f=fopen("failure.txt","wb");if(f){fprintf(f,"%s\n",fs::failure);fclose(f);}}
    printf("RALLY-25 FULL SCENE FAILED: %s\n",fs::failure);
    if(fs::pending)for(;;){} // Keep callback storage resident after a timed-out request.
    return 1;
}
