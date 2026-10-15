#pragma once
#include <agon/mos.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "bindings.hpp"
extern "C" {
void fs_callback(),timing_irq(),timing_start(),timing_stop(),timing_release();
uint24_t timing_ticks(),timing_claim();
volatile uint8_t fs_reply[10]={0},fs_ready=0;
volatile uint24_t ticks=0,elapsed=0;
}
namespace fs {
uint16_t handle=0,token=0;
uint32_t generation=0,request=0,world=0,sendMs=0,waitMs=0,wireBytes=0,scrollCalls=0,repaintCalls=0;
uint8_t transcript[50000];unsigned transcriptBytes=0;
bool pending=false,installed=false,prt=false,healthy=true;
void (*previousTimer)()=nullptr;
const char *failure="none";
uint32_t now(){auto *v=(volatile SYSVAR *)mos_sysvars();uint32_t a,b;do{a=v->time;b=v->time;}while(a!=b);return a;}
uint32_t timer(){return prt?uint32_t(timing_ticks()):0;}
uint32_t difference(uint32_t a,uint32_t b){return (a-b)&0xffffff;}
void fail(const char *s){healthy=false;failure=s;}
void put16(uint8_t *p,uint16_t n){p[0]=uint8_t(n);p[1]=uint8_t(n>>8);}
void put32(uint8_t *p,uint32_t n){for(unsigned i=0;i<4;++i)p[i]=uint8_t(n>>(8*i));}
void send(const uint8_t *p,unsigned n){if(!n)return;uint32_t begin=timer();mos_puts((char*)p,n,0);sendMs+=difference(timer(),begin);wireBytes+=n;}
void command(uint16_t id,uint8_t op){uint8_t p[]={23,0,160,uint8_t(id),uint8_t(id>>8),op};send(p,sizeof p);}
void update(uint16_t id,uint16_t offset,const uint8_t *p,unsigned n){command(id,5);uint8_t head[]={0xc2,uint8_t(offset),uint8_t(offset>>8),uint8_t(n),uint8_t(n>>8)};send(head,sizeof head);send(p,n);}
void set16(uint16_t id,uint16_t offset,uint16_t n){uint8_t b[2];put16(b,n);update(id,offset,b,2);}
void set32(uint16_t id,uint16_t offset,uint32_t n){uint8_t b[4];put32(b,n);update(id,offset,b,4);}
uint16_t transaction(uint8_t op,const uint8_t *fields,unsigned count,uint8_t kind){
    uint8_t b[32]={23,0,216,0,0,1,op,0,0,1,0};put16(b+3,6+count);put16(b+7,++token);memcpy(b+11,fields,count);
    fs_ready=0;pending=true;send(b,11+count);uint32_t start=now(),begin=timer();
    while(!fs_ready){if(now()-start>=600){fail("VDPL callback timeout");return 0;}}
    waitMs+=difference(timer(),begin);pending=false;
    if(fs_reply[0]!='V'||fs_reply[1]!='D'||fs_reply[2]!='P'||fs_reply[3]!='L'||fs_reply[4]!=1||fs_reply[5]!=kind||uint16_t(fs_reply[6]|uint16_t(fs_reply[7])<<8)!=token){fail("VDPL reply identity");return 0;}
    if(transcriptBytes+10>sizeof transcript){fail("Transcript capacity");return 0;}
    for(unsigned i=0;i<10;++i)transcript[transcriptBytes++]=fs_reply[i];
    return uint16_t(fs_reply[8]|uint16_t(fs_reply[9])<<8);
}
uint16_t read16(uint16_t id,uint32_t offset){uint8_t p[6];put16(p,id);put32(p+2,offset);return transaction(5,p,sizeof p,4);}
void expect(uint16_t id,uint16_t offset,uint16_t n){if(read16(id,offset)!=n)fail("VDPL retained-state check");}
void invoke(uint16_t entry){set16(Root,28,entry);set16(Completion,44,0);uint8_t p[6];put16(p,handle);put16(p+2,entry);put16(p+4,Args);if(transaction(2,p,sizeof p,3))fail("VDPL RUN status");++generation;}
bool file(const char *name){FILE *f=fopen(name,"rb");if(!f){fail("Input file open");return false;}uint8_t b[1024];unsigned n;while((n=fread(b,1,sizeof b,f))!=0)send(b,n);bool ok=!ferror(f);fclose(f);if(!ok)fail("Input file read");return ok;}
void snapshot(uint32_t station,int32_t lateral,uint16_t phase,int16_t steering){set32(Root,PlayerStation,station);set32(Root,PlayerLateral,uint32_t(lateral));uint8_t p[4];put16(p,phase);put16(p+2,uint16_t(steering));update(Root,RenderPhase,p,4);}
void tick(){command(TickWrapper,1);++world;++generation;}
void render(){invoke(Render);++request;expect(Completion,44,1);expect(Completion,16,uint16_t(request));expect(Completion,20,uint16_t(world));expect(Root,20,uint16_t(generation));}
bool setup(){
    mos_setkbvector(fs_callback,0);installed=true;
    if(!file("assets.vdu")||!file("module.vdu"))return false;
    uint8_t p[8];put16(p,Staging);put32(p+2,ModuleBytes);put16(p+6,0);handle=transaction(1,p,sizeof p,2);if(!handle){fail("Native LOAD");return false;}
    if(!file("common.vdu")||!file("native.vdu"))return false;
    for(unsigned i=0;i<WrapperCount;++i)set16(Wrappers[i],HandleOffset,handle);
    uint8_t zeros[48]={0};command(Completion,2);command(Completion,0);uint8_t n[]={48,0};send(n,2);send(zeros,48);
    const uint16_t capacities[]={20480,2048,256};uint8_t clear[1024]={0};
    for(unsigned i=0;i<3;++i){command(Outputs[i],2);command(Outputs[i],0);uint8_t len[2];put16(len,capacities[i]);send(len,2);unsigned left=capacities[i];while(left){unsigned k=left>sizeof clear?sizeof clear:left;send(clear,k);left-=k;}}
    set32(Root,8,7);invoke(Init);return healthy;
}
void startTimer(){if(!timing_claim()){fail("PRT1 busy");return;}previousTimer=reinterpret_cast<void(*)()>(mos_setintvector(0x0c,timing_irq));prt=true;timing_start();}
void stopTimer(){if(prt){timing_stop();auto removed=mos_setintvector(0x0c,previousTimer);timing_release();prt=false;if(removed!=timing_irq)fail("PRT vector restoration mismatch");}}
void stop(){if(!pending&&handle){invoke(Stop);uint8_t p[2];put16(p,handle);if(transaction(3,p,2,3))fail("Native UNLOAD");handle=0;}if(installed&&!pending){mos_setkbvector(nullptr,0);installed=false;}stopTimer();}
bool save(const char *name,const void *p,unsigned n){FILE *f=fopen(name,"wb");if(!f)return false;bool ok=fwrite(p,1,n,f)==n;return fclose(f)==0&&ok;}
}
