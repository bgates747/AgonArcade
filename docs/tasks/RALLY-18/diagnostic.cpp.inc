// RALLY-18 isolated diagnostics. No changes to accepted game sources.
void marker(const char *name){FILE*f=fopen(name,"w");if(!f)exit(20);fclose(f);}
void awaitMarker(const char *name){for(;;){FILE*f=fopen(name,"r");if(f){fclose(f);return;}}}
void prepareScene(){rally::r18::prepareScene(motion,traffic,road,sceneryHistory,scene,perspective);}
void drawPlayer(){
    vdp_select_bitmap(scene.playerBitmap);
    vdp_adv_use_affine_matrix(1,scene.playerMirror?63984:65535);
    vdp_draw_bitmap(scene.playerX,rally::r18::PlayerDrawY);
    vdp_adv_use_affine_matrix(1,65535);
}
void drawScene(){
    road.emit(stream,false);drawScenery();mos_puts((char*)stream.data,stream.size,0);
    drawTraffic();drawPlayer();text(9,28,"TIMING FIXTURE");vdp_swap();
}
void saveScene(){
    FILE*f=fopen("scene.csv","w");if(!f)exit(21);
    fprintf(f,"%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\n",(long)scene.skyOffset,(long)scene.skyDelta,(long)scene.skyLeft,(long)scene.skyRight,(long)scene.skyRepaint,(long)scene.playerBitmap,(long)scene.playerMirror,(long)scene.playerX,(long)scene.cars);
    for(unsigned i=0;i<road.boundaryCount;++i)fprintf(f,"R,%u,%ld,%u\n",unsigned(road.rows[i]),(long)road.centersQ8[i],unsigned(i<road.bands?road.materials[i]:0));
    for(unsigned i=0;i<scene.cars;++i){volatile const auto &c=scene.traffic[i];fprintf(f,"C,%d,%d,%d,%d,%d,%d\n",c.bitmap,c.scale,c.mirrored,c.x,c.y,c.translation);}
    fclose(f);
}
int taskDiagnostic(){
    vdp_swap();sceneryHistory.swapped();if(!waitForVDP())return 22;
    if(snapshot){
        rally::r18::pose(snapshotPose,motion,traffic);
        motion.lateral=snapshotLateral*256L;motion.steering=snapshotSteering;
        for(unsigned i=0;i<2;++i){prepareScene();drawScene();sceneryHistory.swapped();if(!waitForVDP())return 23;}
        saveScene();marker("ready.viz");
        for(;;){if(vdp_getKeyMap(14)&1)break;}
        vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);marker("exit.viz");return 0;
    }
    for(unsigned i=0;i<rally::WorkloadWarmup;++i){
        rally::r18::pose(0,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        prepareScene();drawScene();sceneryHistory.swapped();
    }
    if(!waitForVDP())return 24;
    uint32_t frames=0,cars=0,roadBytes=0,bands=0,hash=0;
    marker("start.snk");awaitMarker("go.snk");
    const uint32_t start=rawClock();r18Begin();
    for(unsigned pose=0;pose<rally::WorkloadFrames;++pose){
        rally::r18::pose(pose,motion,traffic);motion.tick(false,false);traffic.tick(motion.track->length*100);
        prepareScene();
        if(!computeOnly){drawScene();if(stream.overflow)return 25;roadBytes+=stream.size;}
        sceneryHistory.swapped();++frames;cars+=scene.cars;bands+=road.bands;
        hash=rally::workloadHash(hash,motion,traffic);
    }
    while(!(IO(UART0_LSR)&UART0_LSR_TEMT)){}
    r18End();const uint32_t submitted=rawClock();
    bool completed=true;uint32_t finished=submitted;
    if(displayTiming){completed=waitForVDP();finished=rawClock();}
    marker("done.snk");awaitMarker("stop.snk");
    if(!displayTiming)completed=waitForVDP();
    saveScene();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    FILE*f=fopen("measurement.csv","w");if(!f)return 26;
    fprintf(f,"frames,submit_ticks,complete_ticks,completed,road_bytes,cars,pose_hash,bands,load_ticks\n");
    fprintf(f,"%lu,%lu,%lu,%u,%lu,%lu,%lu,%lu,%lu\n",(unsigned long)frames,(unsigned long)rally::ticksSince(submitted,start),(unsigned long)rally::ticksSince(finished,start),unsigned(completed),(unsigned long)roadBytes,(unsigned long)cars,(unsigned long)hash,(unsigned long)bands,(unsigned long)roadLoadTicks);
    fprintf(f,"# complete\n");fclose(f);return completed?0:27;
}
