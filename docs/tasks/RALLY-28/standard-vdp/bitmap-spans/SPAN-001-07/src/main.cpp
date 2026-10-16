#include <initializer_list>
#ifndef POLYGON_SPARSE
#define POLYGON_SPARSE 0
#endif
#include <agon/mos.h>
#include <new>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include "projection.hpp"
#include "buffered.hpp"
#include "phase.hpp"
#include "generated.hpp"
#include "mode_lifecycle.hpp"
extern "C" {void timing_irq(),timing_start(),timing_stop(),timing_release();uint24_t timing_ticks(),timing_claim();volatile uint24_t ticks=0,elapsed=0;}
namespace {
constexpr unsigned Limit=1024,FrameBuffer=56004,Wrapper=56006;
alignas(rally::r28::SharedRoad) uint8_t storage[sizeof(rally::r28::SharedRoad)];
uint8_t command[12000],packet[16];unsigned used=0,variant=0,live=0,diagnostic=0,frames=1024,done=0;uint32_t bytes=0,calls=0;
volatile uint8_t *sv;const char *failure="none";bool timer=false;
struct Row{uint32_t geometry,packing,submission,wait,mos,bytes,vdpsubmit,vdpcomplete,vdpdrain;};Row rows[Limit];
void send(const uint8_t*p,unsigned n){bytes+=n;++calls;if(live)mos_puts(reinterpret_cast<const char*>(p),n,0);else {asm volatile(""::"r"(p),"r"(n):"memory");}}
void collect(const uint8_t*p,unsigned n){if(used+n>sizeof command){failure="command overflow";return;}memcpy(command+used,p,n);used+=n;}
uint32_t clock(){return getsysvar_time();}
bool gp(uint8_t token){const uint8_t b[]={23,0,128,token};sv[sysvar_gp]=255;send(b,sizeof b);uint32_t t=clock();unsigned budget=10000000;while(sv[sysvar_gp]!=token && uint32_t(clock()-t)<1200 && --budget){}return sv[sysvar_gp]==token;}
bool nibble(unsigned index,uint8_t &v){sv[sysvar_gp]=255;uint8_t b[]={23,0,235,uint8_t(index)};send(b,sizeof b);uint32_t t=clock();unsigned budget=10000000;while(sv[sysvar_gp]==255 && uint32_t(clock()-t)<1200&&--budget){}v=sv[sysvar_gp];return v<16;}
bool request(unsigned op,unsigned id,unsigned metric=0){uint8_t b[]={23,0,239,uint8_t(op),uint8_t(id),uint8_t(id>>8),uint8_t(metric)};send(b,sizeof b);
 for(unsigned i=0;i<16;++i){uint8_t lo,hi;if(!nibble(i*2,lo)||!nibble(i*2+1,hi))return false;packet[i]=lo|(hi<<4);}
 return !memcmp(packet,"QTG\xA1",4) && packet[4]==uint8_t(id) && packet[5]==uint8_t(id>>8) && packet[7]==0;
}
uint32_t value(){return uint32_t(packet[8])|(uint32_t(packet[9])<<8)|(uint32_t(packet[10])<<16)|(uint32_t(packet[11])<<24);}
uint32_t number(){return uint32_t(packet[12])|(uint32_t(packet[13])<<8)|(uint32_t(packet[14])<<16)|(uint32_t(packet[15])<<24);}
struct ModeIO {
 bool query(test_appliance::Mode &m){sv[sysvar_vdp_pflags]&=uint8_t(~vdp_pflag_mode);const uint8_t b[]={23,0,134};mos_puts((char*)b,sizeof b,0);uint32_t t=clock();unsigned budget=10000000;while(!(sv[sysvar_vdp_pflags]&vdp_pflag_mode)&&clock()-t<1200&&--budget){}if(!(sv[sysvar_vdp_pflags]&vdp_pflag_mode))return false;m={sv[sysvar_scrMode],uint16_t(getsysvar_scrwidth()),uint16_t(getsysvar_scrheight()),sv[sysvar_scrColours]};return m.width&&m.height;}
 bool cli_supported(const test_appliance::Mode&m){return m.number<128;}
 bool select(uint8_t mode){uint8_t b[]={22,mode};mos_puts((char*)b,sizeof b,0);return true;}
 bool settle(){uint32_t t=clock();unsigned budget=10000000;while(clock()-t<160&&--budget){}return budget!=0;}
 bool prepare_cli(){const uint8_t b[]={4,26,20,23,1,1,12};mos_puts((char*)b,sizeof b,0);return true;}
};
void prefix(uint8_t*p,unsigned id,unsigned op){p[0]=23;p[1]=0;p[2]=160;p[3]=id;p[4]=id>>8;p[5]=op;}
void word(uint8_t*p,unsigned n){p[0]=n;p[1]=n>>8;}
void patch(unsigned id,const uint8_t*p,unsigned n){uint8_t h[11];prefix(h,id,5);h[6]=194;word(h+7,0);word(h+9,n);send(h,sizeof h);send(p,n);}
void install(unsigned id,const uint8_t*p,unsigned n){uint8_t h[8];prefix(h,id,2);send(h,6);prefix(h,id,0);word(h+6,n);send(h,sizeof h);send(p,n);}
void wrapper(unsigned id){
 uint8_t w[60];unsigned n=0;
 auto add=[&](const uint8_t*p,unsigned size){memcpy(w+n,p,size);n+=size;};
 const uint8_t begin[]={23,0,239,6,uint8_t(id),uint8_t(id>>8),0};if(diagnostic)add(begin,sizeof begin);
 if(variant==1||variant==2){const uint8_t clear[]={18,0,2,25,4,0,0,104,0,25,101,63,1,223,0,18,0,0,25,4,0,0,224,0,25,101,63,1,239,0};add(clear,sizeof clear);}
 uint8_t call[6];prefix(call,((variant==1||variant==2)?55002:FrameBuffer),1);add(call,sizeof call);
 const uint8_t end[]={23,0,239,7,uint8_t(id),uint8_t(id>>8),0};if(diagnostic)add(end,sizeof end);
 if(!diagnostic && variant!=1 && variant!=2){const uint8_t flush[]={23,0,202};add(flush,sizeof flush);}
 const uint8_t fence[]={23,0,128,232};add(fence,sizeof fence);patch(Wrapper,w,n);
}
bool originalPaint(unsigned y,unsigned phase){return y>=116&&((800000L/(y-96)+phase)%8000)<4000;}
bool file(const char*name,const char*text){uint8_t f=mos_fopen(name,6);if(!f)return false;unsigned n=strlen(text);bool ok=mos_fwrite(f,const_cast<char*>(text),n)==n;mos_fclose(f);return ok;}
}
int main(){
 sv=mos_sysvars();char cfg[80]={};uint8_t f=mos_fopen("config.txt",1);if(!f)return 1;mos_fread(f,cfg,sizeof cfg-1);mos_fclose(f);if(sscanf(cfg,"%u %u %u %u",&variant,&live,&diagnostic,&frames)!=4 || variant>3||live>1||diagnostic>1||!frames||frames>Limit)return 2;
 for(const char*n:{"summary.txt","frames.csv","done.txt","started.txt","ended.txt"}){f=mos_fopen(n,1);if(f){mos_fclose(f);return 3;}}
 ModeIO io;test_appliance::ModeSession<ModeIO> mode(io);if(!mode.begin({8,320,240,64}))return 4;
 printf("Rally road benchmark / mainboard\r\nCandidate %u, CPU-only %u, diagnostic %u\r\n",variant,!live,diagnostic);
 auto&road=*new(storage)rally::r28::SharedRoad;road.track=&rally::Fuji;if(!road.load("fuji.road")){mode.restore();return 5;}
 const uint8_t init[]={23,0,192,0,23,1,0,23,0,248,1,0,1,0};mos_puts((char*)init,sizeof init,0);
 if(live){send(Setup,sizeof Setup);
 // Diagnostic frames use only the normal-worker fence, never sample's forced flush.
 if(diagnostic){uint8_t tail[18]={23,0,160,218,214,5,194,36,21,7,0,0,0,0,0,0,0,0};send(tail,sizeof tail);}
 rally::r28::templates(send);uint8_t zero[12000]={};install(FrameBuffer,zero,1);install(Wrapper,zero,60);if(!gp(234))failure="setup fence";}
 if(live&&diagnostic){uint8_t cap;if(!nibble(32,cap)||cap!=7)failure="VDP mailbox unsupported";}
 if(!timing_claim()){mode.restore();return 6;}auto old=reinterpret_cast<void(*)()>(mos_setintvector(12,timing_irq));timer=true;
 bytes=calls=0;uint32_t position=0,phase=0,mosStart=clock();rally::Stream stream;
 file("started.txt","start\n");timing_start();
 for(unsigned base=0;base<frames && !strcmp(failure,"none");base+=128){
  unsigned batch=frames-base<128?frames-base:128;
  if(live&&diagnostic && (!request(5,123)||value()!=0x475431||number()<batch)){failure="VDP reset/capacity";break;}
  for(unsigned i=0;i<batch;++i){
   if(sv[sysvar_keyascii]==27){failure="cancelled";break;}
   auto&r=rows[done];uint32_t b=bytes,t=timing_ticks(),m=clock();
   position=((done%128)*25600UL+1360)%(rally::Fuji.length*100);phase=(((done%128)+1)*1360UL)%8000;if(variant!=3)road.project(position,phase);
   int centre[120];int shift=(done%128<32?0:done%128<64?-100:done%128<96?100:0);
   if(!POLYGON_SPARSE || variant==1 || variant==2)for(unsigned k=0;k<120;++k)centre[k]=variant==3?160:road.centerAt(k+104)+shift;
   uint32_t a=timing_ticks();r.geometry=(a-t)&0xffffff;
   if(variant==1||variant==2){for(unsigned k=0;k<120;++k){uint8_t*p=RoadCommand+ParameterOffset+k*6;bool paint=variant==2?span_phase::painted(k+104,phase):originalPaint(k+104,phase);word(p,55100+paint);word(p+2,centre[k]);}prefix(RoadCommand+sizeof RoadCommand-6,Wrapper,1);}
   else if(variant==3){used=1;command[0]=0;}
   else{used=0; // Fine buffered polygon control, matching35pixel cross-section.
    // Offset the shared projection by the same constant without changing phase.
    stream.size=0;stream.rect(0,104,319,223,2);collect(stream.data,stream.size);
    const int edges[]={-35,35,-29,29,-27,-25,25,27,-1,1};
    for(unsigned band=0;band<road.bands;++band){
     unsigned layers=road.materials[band]?5:4;int y=road.rows[band],yy=road.rows[band+1],top=road.centerAt(y)+shift,bottom=road.centerAt(yy)+shift;
     int upper=(y-96)*106/50,lower=(yy-96)*106/50;stream.size=0;
     stream.byte(23);stream.byte(0);stream.byte(160);stream.word(rally::r28::Parameters);stream.byte(5);stream.byte(194);stream.word(0);stream.word(layers*8+4);
     for(unsigned layer=0;layer<layers;++layer){unsigned e=layer*2;stream.word(top+edges[e]*upper/32);stream.word(top+edges[e+1]*upper/32);stream.word(bottom+edges[e]*lower/32);stream.word(bottom+edges[e+1]*lower/32);}
     stream.word(y);stream.word(yy);stream.byte(23);stream.byte(0);stream.byte(160);stream.word(layers==5?rally::r28::Run5:rally::r28::Run4);stream.byte(1);collect(stream.data,stream.size);
    }
    stream.size=0;stream.rect(0,224,319,239,0);collect(stream.data,stream.size);
   }
   uint32_t c=timing_ticks();r.packing=(c-a)&0xffffff;
   wrapper(i);
   if(variant==1||variant==2){send(RoadCommand,sizeof RoadCommand);}
   else {install(FrameBuffer,command,used);uint8_t call[6];prefix(call,Wrapper,1);send(call,6);}
   uint32_t d=timing_ticks();r.submission=(d-c)&0xffffff;
   if(live){uint32_t start=clock();unsigned budget=10000000;while(sv[sysvar_gp]!=232&&clock()-start<1200&&--budget){}if(sv[sysvar_gp]!=232){failure="completion timeout";break;}sv[sysvar_gp]=255;}
   r.wait=(timing_ticks()-d)&0xffffff;r.mos=clock()-m;r.bytes=bytes-b;++done;
  }
  if(live&&diagnostic && !strcmp(failure,"none")){
   if(!request(9,123)||value()!=0||number()!=batch){failure="VDP stop/count";break;}
   for(unsigned i=0;i<batch;++i)for(unsigned metric=1;metric<=3;++metric){if(!request(8,i,metric)||packet[6]!=metric||number()!=batch){failure="VDP record mismatch";break;}auto&r=rows[base+i];if(metric==1)r.vdpsubmit=value();if(metric==2)r.vdpcomplete=value();if(metric==3)r.vdpdrain=value();}
  }
 }
 timing_stop();uint32_t total=elapsed,mosUnits=clock()-mosStart;mos_setintvector(12,old);timing_release();timer=false;file("ended.txt","end\n");road.~SharedRoad();bool restored=mode.restore();if(!restored)failure="mode/CLI restore";
 char text[600];snprintf(text,sizeof text,"variant=%u\r\nlive=%u\r\ndiagnostic=%u\r\nframes=%u\r\nplanned=%u\r\nprt_ticks=%lu\r\nmos_units=%lu\r\nexplicit_bytes=%lu\r\nexplicit_calls=%lu\r\nrestored=%u\r\nfailure=%s\r\n",variant,live,diagnostic,done,frames,(unsigned long)total,(unsigned long)mosUnits,(unsigned long)bytes,(unsigned long)calls,restored,failure);bool ok=file("summary.txt",text);
 f=mos_fopen("frames.csv",6);if(!f)return 7;const char*header="frame,geometry,packing,submission,wait,mos,bytes,vdp_submit_us,vdp_complete_us,vdp_drain_us\r\n";mos_fwrite(f,const_cast<char*>(header),strlen(header));
 for(unsigned i=0;i<done;++i){auto&r=rows[i];int n=snprintf(text,sizeof text,"%u,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu,%lu\r\n",i,(unsigned long)r.geometry,(unsigned long)r.packing,(unsigned long)r.submission,(unsigned long)r.wait,(unsigned long)r.mos,(unsigned long)r.bytes,(unsigned long)r.vdpsubmit,(unsigned long)r.vdpcomplete,(unsigned long)r.vdpdrain);ok=mos_fwrite(f,text,n)==unsigned(n)&&ok;}mos_fclose(f);
 printf("Rally benchmark %s; %u frames; saved summary/frames\r\n",failure,done);ok=file("done.txt","complete\n")&&ok;return ok&&done==frames&&!strcmp(failure,"none")?0:8;
}
