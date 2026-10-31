#pragma once
#include "recipe-pins.hpp"
#include "capacity-details.hpp"
#include "protocol.hpp"

// Setup-only application experiment. Existing runtime, allocator, bitmap and
// counter APIs are used without extending their contracts.
namespace capacity {
constexpr unsigned Index=51999,Matrix=51998,Telemetry=51997,First=52000,Count=901;
uint8_t plan[16*Count],generators[48*Count],table[10628];
uint8_t beforeState[fs::StateBytes],afterState[fs::StateBytes];
unsigned requested=0,attempted=0,generated=0,registered=0,pixelChecks=0;
unsigned memoryRows=0,pageMode=0,cleanupAbsent=0;
unsigned activeId=0,failureKind=0,failureCode=0;
uint32_t startMos=0,startPrt=0,endMos=0,endPrt=0;
uint32_t genPrt=0,verifyPrt=0,measurePrt=0;
bool indexInstalled=false,matrixInstalled=false,telemetryInstalled=false,cleaned=false;
FILE *memoryLog=nullptr,*pixelLog=nullptr;
struct Memory {uint32_t internal,largest,psram;uint16_t buffers;};
Memory baseline{},retained{},minimum{},afterCleanup{};

uint32_t fnv(const uint8_t *p,unsigned n){uint32_t h=2166136261u;for(unsigned i=0;i<n;++i)h=(h^p[i])*16777619u;return h;}
bool input(const char *name,uint8_t *p,unsigned n,uint32_t expected){
    FILE *f=fopen(name,"rb");if(!f){fs::fail("Capacity input open");return false;}
    bool ok=fread(p,1,n,f)==n&&fgetc(f)==EOF;fclose(f);
    if(!ok||fnv(p,n)!=expected){fs::fail("Capacity input identity");return false;}return true;
}
void variable(unsigned var,unsigned offset){fs::command(Telemetry,48);uint8_t p[5]={128,0,0,0,0};fs::put16(p+1,offset);fs::put16(p+3,var);fs::send(p,sizeof p);}
uint16_t errorRead(unsigned id,unsigned offset,unsigned expected){
    uint8_t p[6];fs::put16(p,id);fs::put32(p+2,offset);unsigned status=fs::transaction(VDPL_READ16,p,6,VDPL_REPLY_ERROR);
    if(status!=expected)fs::fail("Capacity expected READ16 status");return status;
}
bool length(unsigned id,unsigned bytes){
    (void)fs::read16(id,bytes-2);if(!fs::healthy)return false;
    errorRead(id,bytes-1,3);return fs::healthy;
}
Memory memory(const char *stage,unsigned id){
    uint32_t begin=fs::timer();Memory m{};uint8_t q[2];
    fs::put16(q,13);m.internal=fs::transaction(4,q,2,4);fs::put16(q,14);m.internal|=uint32_t(fs::transaction(4,q,2,4))<<16;
    fs::put16(q,15);m.largest=fs::transaction(4,q,2,4);fs::put16(q,16);m.largest|=uint32_t(fs::transaction(4,q,2,4))<<16;
    bool consistent=false;
    for(unsigned retry=0;retry<4&&fs::healthy;++retry){
        variable(0x211,0);variable(0x210,2);variable(0x211,4);variable(0x212,6);
        unsigned hi=fs::read16(Telemetry,0),lo=fs::read16(Telemetry,2),hi2=fs::read16(Telemetry,4);
        m.buffers=fs::read16(Telemetry,6);
        if(hi==hi2){m.psram=uint32_t(lo)|(uint32_t(hi)<<16);consistent=true;break;}
    }
    if(!consistent)fs::fail("Capacity PSRAM sample unstable");
    if(!memoryRows)minimum=m;
    else {if(m.internal<minimum.internal)minimum.internal=m.internal;if(m.largest<minimum.largest)minimum.largest=m.largest;if(m.psram<minimum.psram)minimum.psram=m.psram;}
    ++memoryRows;
    if(memoryLog&&fprintf(memoryLog,"%s,%u,%lu,%lu,%lu,%u,%lu,%lu\r\n",stage,id,
        (unsigned long)m.internal,(unsigned long)m.largest,(unsigned long)m.psram,unsigned(m.buffers),
        (unsigned long)(fs::now()-startMos),(unsigned long)fs::difference(fs::timer(),startPrt))<0)fs::fail("Capacity memory log write");
    measurePrt+=fs::difference(fs::timer(),begin);return m;
}
void state(uint8_t *out){unsigned at=0;for(const auto &b:fs::Buffers)for(unsigned off=0;off<b.bytes;off+=2){fs::put16(out+at,fs::read16(b.id,b.offset+off));at+=2;}}
void clear(unsigned colour){
    viewport(stream,0,0,319,239);flush();vdp_adv_use_affine_matrix(0,65535);
    stream.rect(0,0,319,239,colour);flush();
}
void swap(){vdp_swap();fs::fence();}
unsigned pixel(unsigned x,unsigned y){
    uint8_t b[]={23,0,0x84,0,0,0,0};fs::put16(b+3,x);fs::put16(b+5,y);fs::send(b,sizeof b);
    variable(0x514,8);return fs::read16(Telemetry,8);
}
void plot(unsigned id){
    vdp_adv_use_affine_matrix(0,65535);uint8_t b[]={23,27,0x20,0,0,23,27,3,10,0,10,0};
    fs::put16(b+3,id);fs::send(b,sizeof b);
}
bool probe(unsigned row,bool detail=false){
    const uint8_t *p=plan+16*row;unsigned id=fs::get16(p),x=p[9],y=p[10],expected=p[11];
    // Plot against a definitely different background. Clearing removes the old
    // image even when adjacent records have identical colours/geometry.
    unsigned bg=expected==0?15:0;clear(bg);plot(id);if(pageMode==2)swap();
    unsigned actual=pixel(10+x,10+y);++pixelChecks;
    if(pixelLog&&fprintf(pixelLog,"%u,%u,%u,%u,%u,%s\r\n",id,x,y,expected,actual,detail?"detail":"registration")<0)fs::fail("Capacity pixel log write");
    if(actual!=expected){fs::fail("Capacity Bitmap registration pixel");return false;}
    if(fs::get16(p+14)&2)for(const auto &point:capacity_details::Points)if(point.id==id){
        clear(point.colour==0?15:0);plot(id);if(pageMode==2)swap();
        actual=pixel(10+point.x,10+point.y);++pixelChecks;
        if(pixelLog&&fprintf(pixelLog,"%u,%u,%u,%u,%u,detail\r\n",id,unsigned(point.x),unsigned(point.y),unsigned(point.colour),actual)<0)fs::fail("Capacity detail log write");
        if(actual!=point.colour){fs::fail("Capacity representative image pixel");return false;}
    }
    return fs::healthy;
}
void generate(unsigned row){
    activeId=fs::get16(plan+16*row);matrixInstalled=true;fs::send(generators+48*row,48);
}
bool pageProbe(unsigned row){
    const uint8_t *p=plan+16*row;generate(row);
    if(!length(fs::get16(p),fs::get16(p+12)))return false;
    // Visible page black; hidden drawing page white. Observe the actual stock
    // pixel API rather than assuming which double-buffer page it inspects.
    clear(0);swap();clear(15);
    unsigned observed=pixel(1,1);
    if(observed==63)pageMode=1;else if(observed==0)pageMode=2;else {fs::fail("Capacity pixel page semantics");return false;}
    if(!probe(row,true))return false;
    // Recheck after a swap with the opposite background to prove both pages.
    swap();if(!probe(row,true))return false;
    fs::fence();fs::command(fs::get16(p),2);fs::fence();errorRead(fs::get16(p),0,2);
    return fs::healthy;
}
bool configure(){
    uint8_t cfg[8];FILE *f=fopen("capacity.cfg","rb");if(!f){fs::fail("Capacity config open");return false;}
    bool ok=fread(cfg,1,8,f)==8&&fgetc(f)==EOF;fclose(f);requested=fs::get16(cfg+4);
    if(!ok||memcmp(cfg,"R3CP",4)||(requested!=1&&requested!=Count)||fs::get16(cfg+6)!=1){fs::fail("Capacity config identity");return false;}
    if(!input("index.bin",table,sizeof table,capacity_pins::TableFNV)||
       !input("plan.bin",plan,sizeof plan,capacity_pins::PlanFNV)||
       !input("generation.vdu",generators,sizeof generators,capacity_pins::WireFNV))return false;
    if(memcmp(table,"R3PI",4)||fs::get16(table+4)!=1||fs::get16(table+6)!=64||fs::get32(table+8)!=sizeof table||fs::get16(table+20)!=Count||fs::get16(table+22)!=1||fs::get16(table+46)!=First||fs::get16(table+48)!=Count){fs::fail("Capacity index header");return false;}
    for(unsigned i=0;i<Count;++i){const uint8_t *p=plan+16*i,*r=table+3420+8*i;
        unsigned s=fs::get16(p+4),id=fs::get16(p),source=fs::get16(p+2);
        if(id!=First+i||fs::get16(r)!=id||p[6]!=r[2]||p[7]!=r[3]||p[8]>1||
           s<14||s>250||s%2||!p[6]||!p[7]||p[9]>=p[6]||p[10]>=p[7]||
           p[11]>63||fs::get16(p+12)!=unsigned(p[6])*p[7]||
           !((source>=5&&source<35)||(source>=120&&source<128))){fs::fail("Capacity recipe bounds");return false;}
    }return true;
}
void cleanup(){
    if(fs::pending)return;
    bool prior=fs::healthy;const char *priorFailure=fs::failure;fs::healthy=true;
    if(!prior){failureKind=fs_reply[5];failureCode=unsigned(fs_reply[8])|(unsigned(fs_reply[9])<<8);}
    if(!endMos){endMos=fs::now();endPrt=fs::timer();}
    fs::fence();
    if(telemetryInstalled)retained=memory(prior?"retained":"failure_before_cleanup",attempted);
    // Full range is ours, including a partially admitted final image. Never
    // delete a baseline or peer resource when generation fails.
    for(unsigned id=First;id<First+Count;++id)fs::command(id,2);
    if(indexInstalled)fs::command(Index,2);if(matrixInstalled)fs::command(Matrix,2);
    fs::fence();
    for(unsigned id=First;id<First+Count&&fs::healthy;++id){errorRead(id,0,2);if(fs::healthy)++cleanupAbsent;}
    if(indexInstalled)errorRead(Index,0,2);if(matrixInstalled)errorRead(Matrix,0,2);
    if(telemetryInstalled)afterCleanup=memory("cleanup",0);
    cleaned=fs::healthy&&cleanupAbsent==Count;
    if(telemetryInstalled){fs::command(Telemetry,2);fs::fence();}
    if(!prior){fs::healthy=false;fs::failure=priorFailure;}
}
bool execute(){
    if(!configure())return false;
    fs::command(Telemetry,2);fs::command(Telemetry,0);uint8_t n[]={12,0},zero[12]={0};fs::send(n,2);fs::send(zero,12);telemetryInstalled=true;
    fs::startTimer();if(!fs::healthy)return false;startMos=fs::now();startPrt=fs::timer();
    state(beforeState);if(!fs::healthy)return false;baseline=memory("baseline",0);
    indexInstalled=true;if(!fs::file("index.vdu")||!length(Index,sizeof table))return false;
    // One-time actual table admission; pixels are NOT read back or checksummed.
    for(unsigned off=0;off<sizeof table&&fs::healthy;off+=2)if(fs::read16(Index,off)!=fs::get16(table+off))fs::fail("Capacity installed table mismatch");
    if(!fs::healthy)return false;memory("index",0);
    unsigned small=capacity_pins::SmallId-First;
    if(!pageProbe(small))return false;memory("small_probe",capacity_pins::SmallId);
    for(unsigned i=0;i<requested&&fs::healthy;++i){
        unsigned row=requested==1?small:i;attempted=i+1;const uint8_t *p=plan+16*row;
        uint32_t begin=fs::timer();generate(row);(void)fs::read16(fs::Root,20);genPrt+=fs::difference(fs::timer(),begin);
        begin=fs::timer();if(!length(fs::get16(p),fs::get16(p+12)))break;++generated;
        if(!probe(row))break;++registered;verifyPrt+=fs::difference(fs::timer(),begin);
        retained=memory("image",fs::get16(p));
    }
    endMos=fs::now();endPrt=fs::timer();
    if(!fs::healthy)return false;state(afterState);
    if(memcmp(beforeState,afterState,sizeof beforeState))fs::fail("Capacity native state changed");
    return fs::healthy&&registered==requested;
}
bool save(){
    if(memoryLog){if(fclose(memoryLog))fs::fail("Capacity memory close");memoryLog=nullptr;}
    if(pixelLog){if(fclose(pixelLog))fs::fail("Capacity pixel close");pixelLog=nullptr;}
    if(!fs::save("state-before.bin",beforeState,sizeof beforeState)||!fs::save("state-after.bin",afterState,sizeof afterState)||!fs::save("replies.bin",fs::transcript,fs::transcriptBytes))return false;
    FILE *failureLog=fopen("failure-detail.csv","wb");if(!failureLog)return false;
    fprintf(failureLog,"active_id,last_reply_kind,last_reply_code\r\n%u,%u,%u\r\n",activeId,failureKind,failureCode);
    if(fclose(failureLog))return false;
    FILE *f=fopen("result.json","wb");if(!f)return false;
    fprintf(f,"{\"schema\":1,\"kind\":\"prepared_capacity\",\"valid\":%s,\"full_set_fits\":%s,\"requested\":%u,\"attempted\":%u,\"generated\":%u,\"registered\":%u,\"pixel_checks\":%u,\"pixel_page\":%u,\"elapsed_mos_ticks\":%lu,\"elapsed_prt\":%lu,\"generation_prt\":%lu,\"verification_prt\":%lu,\"memory_measurement_prt\":%lu,\"baseline_internal\":%lu,\"baseline_largest_internal\":%lu,\"baseline_psram\":%lu,\"baseline_buffers\":%u,\"retained_internal\":%lu,\"retained_largest_internal\":%lu,\"retained_psram\":%lu,\"retained_buffers\":%u,\"minimum_internal\":%lu,\"minimum_largest_internal\":%lu,\"minimum_psram\":%lu,\"cleanup_internal\":%lu,\"cleanup_largest_internal\":%lu,\"cleanup_psram\":%lu,\"cleanup_buffers\":%u,\"cleanup_absent\":%u,\"cleaned\":%s,\"timer_restored\":%s,\"unloaded\":%s,\"failure\":\"%s\"}\n",
        fs::healthy&&cleaned?"true":"false",fs::healthy&&cleaned&&requested==Count&&registered==Count?"true":"false",
        requested,attempted,generated,registered,pixelChecks,pageMode,(unsigned long)(endMos-startMos),(unsigned long)fs::difference(endPrt,startPrt),
        (unsigned long)genPrt,(unsigned long)verifyPrt,(unsigned long)measurePrt,
        (unsigned long)baseline.internal,(unsigned long)baseline.largest,(unsigned long)baseline.psram,unsigned(baseline.buffers),
        (unsigned long)retained.internal,(unsigned long)retained.largest,(unsigned long)retained.psram,unsigned(retained.buffers),
        (unsigned long)minimum.internal,(unsigned long)minimum.largest,(unsigned long)minimum.psram,
        (unsigned long)afterCleanup.internal,(unsigned long)afterCleanup.largest,(unsigned long)afterCleanup.psram,unsigned(afterCleanup.buffers),
        cleanupAbsent,cleaned?"true":"false",fs::timerRestored?"true":"false",fs::unloaded?"true":"false",fs::failure);
    return fclose(f)==0;
}
}
