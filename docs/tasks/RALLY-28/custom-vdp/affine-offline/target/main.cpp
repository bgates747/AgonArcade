#include <agon/mos.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "cases.hpp"

extern "C" {
void affine_callback(), timing_irq(), timing_start(), timing_stop(), timing_release();
uint24_t timing_ticks(), timing_claim();
volatile uint8_t affine_hits=0;
volatile uint24_t affine_packets=0, ticks=0, elapsed=0;
}
namespace {
constexpr unsigned CallbackOffset=0x6c; // Pinned official MOS3.0.2 only.
constexpr unsigned MaxRows=256, BlockBytes=32768;
constexpr uint16_t OperationBase=53000, BatchBase=54000, MatrixBase=55000;
constexpr uint16_t TransformBase=56000, SizedBase=56100, EmptyOperation=53099, EmptyBatch=54099;
constexpr uint8_t PollMarker=0xd1, PixelMarker=12;
const char *Methods[]={"ordinary-sized","cached-affine","rebuilt-affine","transform40-plot","matrix-only","empty"};
struct Row {uint32_t mos,prt,send,wait;uint16_t caseIndex,method,sample,repeats;uint8_t hits,poll,pixel,valid;};
Row rows[MaxRows];
uint8_t block[BlockBytes];unsigned used=0,completed=0,planned=0;
uint16_t repeats=128,samples=4,setupRepeats=1024,caseMask=63;
uint8_t primaryPoll=0,verifyToken=1;
volatile uint8_t *sysvars=nullptr;
void (*previousCallback)()=nullptr,*previousTimerRaw=nullptr;
bool callbackInstalled=false,timerInstalled=false,callbackRestored=false,timerRestored=false;
bool fallbackUsed=false;
const char *failure=nullptr;
uint32_t setupStart=0,setupEnd=0;

void fail(const char *s){if(!failure)failure=s;}
uint32_t now(){return getsysvar_time();}
uint32_t timer(){return timerInstalled?uint32_t(timing_ticks()):0;}
uint32_t difference(uint32_t end,uint32_t start){return(end-start)&0xffffff;}
void send(const uint8_t *p,unsigned n){if(n)mos_puts(reinterpret_cast<const char*>(p),n,0);}
void byte(uint8_t v){if(used<sizeof block)block[used++]=v;else fail("Command buffer capacity");}
void word(int v){byte(uint8_t(v));byte(uint8_t(unsigned(v)>>8));}
void buffered(uint16_t id,uint8_t op){const uint8_t p[]={23,0,160,uint8_t(id),uint8_t(id>>8),op};send(p,sizeof p);}
void command(uint16_t id,uint8_t op){byte(23);byte(0);byte(160);word(id);byte(op);}
void affine(uint16_t id){byte(23);byte(0);byte(150);byte(1);word(id);}
void select(uint16_t id){byte(23);byte(27);byte(32);word(id);}
void plot(int x,int y){byte(23);byte(27);byte(3);word(x);word(y);}
void viewport(int left,int top,int right,int bottom){byte(24);word(left);word(bottom);word(right);word(top);byte(25);byte(4);word(left);word(top);}
void rect(int left,int top,int right,int bottom,uint8_t colour){byte(18);byte(0);byte(colour);byte(25);byte(4);word(left);word(top);byte(25);byte(101);word(right);word(bottom);}
void output(){send(block,used);used=0;}
void store(uint16_t id){if(failure)return;buffered(id,2);const uint8_t p[]={23,0,160,uint8_t(id),uint8_t(id>>8),0,uint8_t(used),uint8_t(used>>8)};send(p,sizeof p);output();}
void matrix(unsigned index){const auto &c=Cases[index];uint16_t id=MatrixBase+index;command(id,32);byte(0);command(id,32);byte(11);byte(200);for(int value:c.matrix)word(value);}
void transform(unsigned index,uint16_t destination){command(destination,40);byte(5);word(MatrixBase+index);word(Cases[index].source);}
void makeOperation(unsigned index,unsigned method){
    const auto &c=Cases[index];used=0;
    if(method==0){affine(65535);select(SizedBase+index);plot(c.x+c.minX,c.y+c.minY);}
    else if(method==1){affine(MatrixBase+index);select(c.source);plot(c.x,c.y);}
    else if(method==2){matrix(index);affine(MatrixBase+index);select(c.source);plot(c.x,c.y);}
    else if(method==3){transform(index,TransformBase+index);affine(65535);select(TransformBase+index);plot(c.x+c.minX,c.y+c.minY);}
    else if(method==4)matrix(index);
    else byte(0);
    store(OperationBase+index*5+method);
}
void tail(){viewport(0,0,319,239);rect(319,239,319,239,PixelMarker);byte(23);byte(0);byte(0xca);byte(23);byte(0);byte(primaryPoll?0x80:0x99);byte(primaryPoll?PollMarker:0);}
void makeBatch(unsigned index,unsigned method){
    used=0;const auto &c=Cases[index];viewport(c.clip[0],c.clip[1],c.clip[2],c.clip[3]);
    unsigned count=method==4?setupRepeats:repeats;
    for(unsigned i=0;i<count;++i)command(OperationBase+index*5+method,1);
    tail();store(BatchBase+index*5+method);
}
bool pollFence(){
    if(++verifyToken>=128)verifyToken=1;
    const uint8_t p[]={23,0,0xca,23,0,0x80,verifyToken};send(p,sizeof p);
    uint32_t begin=now();while(sysvars[sysvar_gp]!=verifyToken&&now()-begin<7200){}
    return sysvars[sysvar_gp]==verifyToken;
}
bool file(const char *name){FILE *f=fopen(name,"rb");if(!f){fail("Input file open");return false;}uint8_t p[1024];unsigned n;while((n=fread(p,1,sizeof p,f))!=0)send(p,n);bool ok=!ferror(f);fclose(f);if(!ok)fail("Input file read");return ok;}
bool configuration(){
    FILE *f=fopen("config.bin","rb");uint8_t p[16];if(!f){fail("Configuration open");return false;}
    bool ok=fread(p,1,sizeof p,f)==sizeof p&&fgetc(f)==EOF;fclose(f);
    auto get=[&](unsigned i){return uint16_t(p[i])|uint16_t(p[i+1])<<8;};
    if(!ok||memcmp(p,"R28A",4)||get(4)!=1||!get(6)||get(6)>256||!get(8)||get(8)>8||!get(10)||get(10)>4096||!get(12)||get(12)>=64||p[14]>1||p[15]){fail("Configuration bounds");return false;}
    repeats=get(6);samples=get(8);setupRepeats=get(10);caseMask=get(12);primaryPoll=p[14];return true;
}
bool outputsAbsent(){const char *names[]={"summary.json","timings.csv","done.txt","failure.txt"};for(const char *name:names){FILE *f=fopen(name,"rb");if(f){fclose(f);fail("Results already exist; use a fresh profile");return false;}}return true;}
bool setup(){
    setupStart=now();if(!configuration())return false;
    // Stock affine/matrix dispatch is gated by TESTFLAG_AFFINE_TRANSFORM.
    // This is the same explicit feature-enable sequence used by loadCars().
    const uint8_t init[]={22,136,23,0,192,0,23,1,0,26,12,23,0,0xf8,1,0,1,0};send(init,sizeof init);
    if(!file("artwork.vdu"))return false;
    for(unsigned index=0;index<CaseCount;++index){
        used=0;matrix(index);transform(index,SizedBase+index);output();
        for(unsigned method=0;method<5;++method){makeOperation(index,method);makeBatch(index,method);}
        if(caseMask&(1u<<index))planned+=5*samples;
    }
    used=0;byte(0);store(EmptyOperation);used=0;
    for(unsigned i=0;i<repeats;++i)command(EmptyOperation,1);
    tail();store(EmptyBatch);planned+=samples;
    if(failure)return false;
    if(!pollFence()){fail("Setup rendering fence timeout");return false;}
    auto slot=reinterpret_cast<void(**)()>(const_cast<uint8_t*>(sysvars)+CallbackOffset);
    previousCallback=*slot;mos_setkbvector(affine_callback,0);callbackInstalled=true;
    if(!timing_claim()){fail("PRT1 already owned");return false;}
    previousTimerRaw=reinterpret_cast<void*>(mos_setintvector(0x0c,timing_irq));timerInstalled=true;timing_start();setupEnd=now();
    return true;
}
bool measure(unsigned index,unsigned method,unsigned sample){
    if(completed>=MaxRows){fail("Row capacity");return false;}
    Row &r=rows[completed];r.caseIndex=index;r.method=method;r.sample=sample;r.repeats=method==4?setupRepeats:repeats;
    used=0;affine(65535);viewport(0,0,319,239);rect(0,0,319,239,16);
    if(index<CaseCount){const auto &c=Cases[index];viewport(c.clip[0],c.clip[1],c.clip[2],c.clip[3]);command(OperationBase+index*5+method,1);}
    output();if(!pollFence()){fail("Untimed warm fence timeout");return false;}
    uint8_t hits=affine_hits;uint32_t mosBegin=now(),prtBegin=timer();
    buffered(index<CaseCount?BatchBase+index*5+method:EmptyBatch,1);uint32_t sent=timer();
    while((primaryPoll?sysvars[sysvar_gp]!=PollMarker:affine_hits==hits)&&now()-mosBegin<7200){}
    uint32_t end=timer();r.mos=now()-mosBegin;r.prt=difference(end,prtBegin);r.send=difference(sent,prtBegin);r.wait=difference(end,sent);r.hits=uint8_t(affine_hits-hits);r.poll=sysvars[sysvar_gp];
    bool completedPrimary=primaryPoll?r.poll==PollMarker:r.hits==1;
    if(!completedPrimary){fallbackUsed=pollFence();fail("Primary completion timeout/ambiguity; fallback excluded from timing");++completed;return false;}
    // Only after the primary completion, verify the batch's last visible write.
    sysvars[sysvar_vdp_pflags]&=uint8_t(~vdp_pflag_point);
    const uint8_t point[]={23,0,0x84,63,1,239,0};send(point,sizeof point);
    if(!pollFence()||!(sysvars[sysvar_vdp_pflags]&vdp_pflag_point)){fail("Marker readback timeout");++completed;return false;}
    r.pixel=sysvars[sysvar_scrpixelIndex];r.valid=r.pixel==PixelMarker;
    ++completed;if(!r.valid)fail("Final marker pixel mismatch");return r.valid;
}
void cleanup(){
    if(callbackInstalled){mos_setkbvector(previousCallback,0);auto slot=reinterpret_cast<void(**)()>(const_cast<uint8_t*>(sysvars)+CallbackOffset);callbackRestored=*slot==previousCallback;callbackInstalled=false;}
    if(timerInstalled){timing_stop();auto removed=mos_setintvector(0x0c,reinterpret_cast<void(*)()>(previousTimerRaw));timing_release();timerRestored=removed==timing_irq;timerInstalled=false;}
    used=0;affine(65535);output();
    for(unsigned index=0;index<CaseCount;++index){for(unsigned method=0;method<5;++method){buffered(OperationBase+index*5+method,2);buffered(BatchBase+index*5+method,2);}buffered(MatrixBase+index,2);buffered(TransformBase+index,2);buffered(SizedBase+index,2);buffered(Cases[index].source,2);}
    buffered(EmptyOperation,2);buffered(EmptyBatch,2);
    const uint8_t restore[]={22,8,23,0,192,0,23,1,1,26,12};send(restore,sizeof restore);
    if(!callbackRestored||!timerRestored)fail("Callback/PRT ownership restoration");
}
bool save(){
    FILE *f=fopen("timings.csv","wb");if(!f)return false;
    fprintf(f,"case_index,case,method,sample,operations,mos_ticks,prt_ticks,submit_prt_ticks,wait_prt_ticks,callback_hits,gp,marker_pixel,valid\r\n");
    for(unsigned i=0;i<completed;++i){const auto &r=rows[i];fprintf(f,"%u,%s,%s,%u,%u,%lu,%lu,%lu,%lu,%u,%u,%u,%u\r\n",unsigned(r.caseIndex),r.caseIndex<CaseCount?Cases[r.caseIndex].name:"empty",Methods[r.method],unsigned(r.sample),unsigned(r.repeats),(unsigned long)r.mos,(unsigned long)r.prt,(unsigned long)r.send,(unsigned long)r.wait,unsigned(r.hits),unsigned(r.poll),unsigned(r.pixel),unsigned(r.valid));}if(fclose(f))return false;
    f=fopen("summary.json","wb");if(!f)return false;
    fprintf(f,"{\"schema\":1,\"valid\":%s,\"completed_batches\":%u,\"planned_batches\":%u,\"mode\":136,\"timed_swaps\":0,\"draw_repeats\":%u,\"setup_repeats\":%u,\"samples\":%u,\"case_mask\":%u,\"primary_completion\":\"%s\",\"fallback_used\":%s,\"callback_restored\":%s,\"prt_restored\":%s,\"setup_mos_ticks\":%lu,\"keyboard_packets\":%lu,\"mos_hz_nominal\":120,\"prt_hz_nominal\":1000,\"failure\":\"%s\"}\n",failure?"false":"true",completed,planned,unsigned(repeats),unsigned(setupRepeats),unsigned(samples),unsigned(caseMask),primaryPoll?"poll":"key-zero",fallbackUsed?"true":"false",callbackRestored?"true":"false",timerRestored?"true":"false",(unsigned long)(setupEnd-setupStart),(unsigned long)affine_packets,failure?failure:"none");if(fclose(f))return false;
    if(failure){f=fopen("failure.txt","wb");if(f){fprintf(f,"%s\n",failure);fclose(f);}}
    f=fopen("done.txt","wb");if(!f)return false;fprintf(f,"%s\n",failure?"FAIL":"PASS");return fclose(f)==0;
}
}
int main(){
    sysvars=mos_sysvars();if(!outputsAbsent()){printf("AFFINE PROBE REFUSED: existing outputs\n");return 1;}
    if(setup())for(unsigned sample=0;sample<samples&&!failure;++sample){
        measure(CaseCount,5,sample);
        for(unsigned index=0;index<CaseCount&&!failure;++index)if(caseMask&(1u<<index))for(unsigned method=0;method<5&&!failure;++method)measure(index,method,sample);
    }
    cleanup();bool saved=save();printf("RALLY AFFINE %s: %u/%u batches; logs saved.\n",failure||!saved?"FAIL":"PASS",completed,planned);return failure||!saved?1:0;
}
