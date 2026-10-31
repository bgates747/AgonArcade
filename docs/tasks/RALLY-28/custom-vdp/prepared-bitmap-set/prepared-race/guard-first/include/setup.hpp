#pragma once
// Included after unchanged presentation helpers and the qualified capacity.hpp.
namespace prepared_setup {
uint32_t coldBegin=0,coldEnd=0,installBegin=0,installEnd=0;
uint32_t loadedInternal=0,loadedLargest=0;
uint16_t loadedStack=0,installedStack=0,cleanupStack=0;
unsigned setupReplyEnd=0,timedReplyBegin=0,timedReplyEnd=0;
unsigned timedTokenBegin=0,timedTokenEnd=0;
uint32_t counters[8]={0};
capacity::Memory installedMemory{},raceReadyMemory{},raceEndMemory{};
bool started=false,attempted=false,complete=false,finished=false,cleanupOK=false,countersOK=false,generationResynced=false;

unsigned stack(){uint8_t q[2]={17,0};return fs::transaction(4,q,2,4);}
void begin(){
    const char *names[]={"setup.json","prepared.json","setup-memory.csv","setup-pixels.csv",
        "setup-state-before.bin","setup-state-after.bin","cache-counters.bin"};
    for(auto n:names)mos_del(n);coldBegin=fs::now();started=true;
}
void loaded(){
    loadedStack=stack();uint8_t q[2];fs::put16(q,13);loadedInternal=fs::transaction(4,q,2,4);
    fs::put16(q,14);loadedInternal|=uint32_t(fs::transaction(4,q,2,4))<<16;
    fs::put16(q,15);loadedLargest=fs::transaction(4,q,2,4);
    fs::put16(q,16);loadedLargest|=uint32_t(fs::transaction(4,q,2,4))<<16;
}
bool memoryFile(const char *mode){
    capacity::memoryLog=fopen("setup-memory.csv",mode);
    if(!capacity::memoryLog){fs::fail("Prepared memory output open");return false;}return true;
}
void closeMemory(){if(capacity::memoryLog){if(fclose(capacity::memoryLog))fs::fail("Prepared memory output close");capacity::memoryLog=nullptr;}}
bool install(){
    attempted=true;installBegin=fs::now();
    // Root/arrays/output resources exist, but native Init/bind has not run.
    // The frozen initial Root generation is0, matching fs::generation here.
    fs::command(51996,2);fs::command(51996,0);uint8_t n[]={32,0},zero[32]={0};fs::send(n,2);fs::send(zero,32);
    if(!memoryFile("wb"))return false;
    capacity::pixelLog=fopen("setup-pixels.csv","wb");
    if(!capacity::pixelLog){fs::fail("Prepared pixel output open");closeMemory();return false;}
    fprintf(capacity::memoryLog,"stage,id,internal,largest_internal,free_psram,buffers,mos_ticks,phase_prt_units\r\n");
    fprintf(capacity::pixelLog,"id,x,y,expected,actual,kind\r\n");
    bool ok=capacity::execute();
    if(fs::healthy)installedMemory=capacity::memory("installed",0);
    if(fs::healthy)installedStack=stack();
    installEnd=fs::now();fs::stopTimer();
    if(fclose(capacity::pixelLog))fs::fail("Prepared pixel output close");capacity::pixelLog=nullptr;closeMemory();
    if(!fs::save("setup-state-before.bin",capacity::beforeState,sizeof capacity::beforeState)||
       !fs::save("setup-state-after.bin",capacity::afterState,sizeof capacity::afterState))fs::fail("Prepared setup state output");
    complete=ok&&fs::healthy&&capacity::registered==901;
    setupReplyEnd=fs::transcriptBytes/10;
    return complete;
}
bool ready(){
    if(!complete){fs::fail("Prepared set incomplete");return false;}
    if(!memoryFile("ab"))return false;
    raceReadyMemory=capacity::memory("race_ready",0);closeMemory();coldEnd=fs::now();
    FILE *f=fopen("setup.json","wb");if(!f){fs::fail("Prepared setup summary open");return false;}
    fprintf(f,"{\"schema\":1,\"complete\":true,\"images\":%u,\"registered\":%u,\"pixel_checks\":%u,\"drawing_page\":%u,\"cold_mos_ticks\":%lu,\"install_mos_ticks\":%lu,\"verified_install_mos_ticks\":%lu,\"verified_install_prt_units\":%lu,\"loaded_internal\":%lu,\"loaded_largest_internal\":%lu,\"loaded_stack\":%u,\"installed_stack\":%u,\"loaded_reply_end\":%u,\"baseline_psram\":%lu,\"installed_psram\":%lu,\"race_ready_psram\":%lu,\"installed_internal\":%lu,\"race_ready_internal\":%lu,\"installed_largest_internal\":%lu,\"setup_prt_restored\":%s}\n",
        capacity::generated,capacity::registered,capacity::pixelChecks,capacity::pageMode,
        (unsigned long)(coldEnd-coldBegin),(unsigned long)(installEnd-installBegin),
        (unsigned long)(capacity::endMos-capacity::startMos),(unsigned long)fs::difference(capacity::endPrt,capacity::startPrt),
        (unsigned long)loadedInternal,(unsigned long)loadedLargest,unsigned(loadedStack),unsigned(installedStack),setupReplyEnd,
        (unsigned long)capacity::baseline.psram,(unsigned long)installedMemory.psram,(unsigned long)raceReadyMemory.psram,
        (unsigned long)installedMemory.internal,(unsigned long)raceReadyMemory.internal,(unsigned long)installedMemory.largest,fs::timerRestored?"true":"false");
    if(fclose(f))fs::fail("Prepared setup summary close");return fs::healthy;
}
void steadyBegin(){timedReplyBegin=fs::transcriptBytes/10;timedTokenBegin=fs::token;}
void steadyEnd(){timedReplyEnd=fs::transcriptBytes/10;timedTokenEnd=fs::token;}
void raceEnd(){if(memoryFile("ab")){raceEndMemory=capacity::memory("race_end",0);closeMemory();}}
void finish(){
    if(finished||!attempted||fs::pending)return;finished=true;
    bool prior=fs::healthy;const char *priorFailure=fs::failure;fs::healthy=true;
    // Failure paths may have issued a rejected RUN. Only after the steady-state
    // window, recover the actual retained generation for cleanup fences.
    if(!prior){uint32_t actual=fs::read32(fs::Root,20);if(fs::healthy){fs::generation=actual;generationResynced=true;}}
    if(fs::unloaded&&fs::healthy){
        for(unsigned i=0;i<8;++i)counters[i]=fs::read32(51996,i*4);
        countersOK=fs::healthy&&counters[3]==0&&counters[4]==0&&counters[5]==0&&counters[6]==0&&counters[7]==0;
        if(!countersOK)fs::fail("Prepared cache operation counters");
    }
    if(memoryFile("ab")){capacity::cleanup();closeMemory();}
    if(!fs::pending){
        bool cleanupPrior=fs::healthy;fs::healthy=true;
        fs::command(51996,2);fs::fence();capacity::errorRead(51996,0,VDPL_E_BUFFER);
        if(fs::healthy)cleanupStack=stack();cleanupOK=capacity::cleaned&&fs::healthy;
        fs::healthy=cleanupPrior&&fs::healthy;
    }
    if(!fs::save("cache-counters.bin",counters,sizeof counters))fs::fail("Prepared counter output");
    FILE *f=fopen("prepared.json","wb");if(!f)fs::fail("Prepared final summary open");else {
        fprintf(f,"{\"schema\":1,\"complete\":%s,\"cleaned\":%s,\"counters_ok\":%s,\"setup_reply_end\":%u,\"timed_reply_begin\":%u,\"timed_reply_end\":%u,\"timed_token_begin\":%u,\"timed_token_end\":%u,\"cleanup_absent\":%u,\"cleanup_stack\":%u,\"baseline_buffers\":%u,\"cleanup_buffers\":%u,\"baseline_internal\":%lu,\"minimum_internal\":%lu,\"minimum_largest_internal\":%lu,\"minimum_psram\":%lu,\"cleanup_internal\":%lu,\"baseline_psram\":%lu,\"cleanup_psram\":%lu,\"race_end_internal\":%lu,\"race_end_psram\":%lu,\"generation_resynced_for_failure\":%s}\n",
            complete?"true":"false",cleanupOK?"true":"false",countersOK?"true":"false",setupReplyEnd,timedReplyBegin,timedReplyEnd,timedTokenBegin,timedTokenEnd,
            capacity::cleanupAbsent,unsigned(cleanupStack),unsigned(capacity::baseline.buffers),unsigned(capacity::afterCleanup.buffers),
            (unsigned long)capacity::baseline.internal,(unsigned long)capacity::minimum.internal,(unsigned long)capacity::minimum.largest,(unsigned long)capacity::minimum.psram,
            (unsigned long)capacity::afterCleanup.internal,(unsigned long)capacity::baseline.psram,(unsigned long)capacity::afterCleanup.psram,
            (unsigned long)raceEndMemory.internal,(unsigned long)raceEndMemory.psram,generationResynced?"true":"false");
        if(fclose(f))fs::fail("Prepared final summary close");
    }
    if(!prior){fs::healthy=false;fs::failure=priorFailure;}
}
}
