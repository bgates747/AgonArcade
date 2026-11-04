#define R28_DIRECT_ROWS 1
/* Generated from the shared Golem model; module state stays in VDP buffers. */
#include "vdplet.h"
static volatile uint32_t identity=0x474c3332u;
static uint16_t get(const uint8_t*p){return (uint16_t)p[0]|(uint16_t)p[1]<<8;}
static void put(uint8_t*p,uint16_t v){p[0]=(uint8_t)v;p[1]=(uint8_t)(v>>8);}
static inline int32_t signed16(uint32_t v){return (int32_t)v-((v&32768u)?65536:0); }
static inline int32_t signed32(uint32_t v){return v>2147483647u?-1-(int32_t)(4294967295u-v):(int32_t)v;}
#define FAIL(n) do {put(state+14,n);h->buffer_release(h->context,view.lease);return VDPL_E_ARGUMENT;}while(0)
#define ROOT_FAIL(n,rc) do{put(state+12,n);h->buffer_release(h->context,view.lease);return (rc);}while(0)
static inline uint32_t get32(const uint8_t*p){return (uint32_t)get(p)|(uint32_t)get(p+2)<<16;}
static inline void put32(uint8_t*p,uint32_t v){put(p,(uint16_t)v);put(p+2,(uint16_t)(v>>16));}
static inline float fvalue(uint32_t u){union{uint32_t u;float f;}v={.u=u};return v.f;}
static inline uint32_t fbits(float f){union{uint32_t u;float f;}v={.f=f};return v.u;}
static inline uint32_t ordered(uint32_t v){return (v&0x80000000u)?~v:(v^0x80000000u);}
#define FP_RESULT(v) do{if(((v)&0x7f800000u)==0x7f800000u)FAIL(33);if(!((v)&0x7f800000u))(v)=0;}while(0)
#define FP_INPUT(v) do{if(!((v)&0x7f800000u)&&((v)&0x007fffffu))FAIL(33);FP_RESULT(v);}while(0)

#include "helper/rally_render.c"
void*memcpy(void*d,const void*s,size_t n){uint8_t*a=d;const uint8_t*b=s;for(size_t i=0;i<n;++i)a[i]=b[i];return d;}
void*memset(void*d,int v,size_t n){uint8_t*a=d;for(size_t i=0;i<n;++i)a[i]=(uint8_t)v;return d;}
static RallyRenderContextV1 renderer={.struct_bytes=sizeof(renderer)};
static RallyRenderBindingsV1 render_binding={76,1,0,{50300,1,0u,149518u},{{50301,2,0u,20480u},{50302,2,0u,2048u},{50303,2,0u,256u}},2101713653u,3635234752u,{0,5,120,63970,63984,63930}};
static int32_t renderer_hook(const vdplet_host_v1*h,unsigned entry,uint8_t*state){
unsigned op=0;switch(entry){
case 13:op=1;break;
case 15:op=2;break;
case 14:op=1;break;
case 16:op=3;break;
default:return 0;}
RallyRenderCompletionV1 done={.struct_bytes=48,.schema=1};
RallyRenderStateV1 s={.struct_bytes=108,.schema=1};
s.session=get32(state+292);
s.request_generation=get32(state+296);
s.simulation_tick=get32(state+136);
s.player_station=get32(state+198);
s.player_lateral_q8=signed32(get32(state+202));
s.phase=get(state+304);
s.steering=signed16(get(state+306));
s.flags=get(state+308);
if(!s.session||s.session!=get32(state+8)||get32(state+198)>2147483647u)return VDPL_E_ARGUMENT;
int32_t rc=0;
if(op==1){render_binding.session=s.session;rc=rally_render_bind_v1(h,&renderer,&render_binding,&done);}
else if(op==3)rc=rally_render_stop_v1(&renderer,&done);
else {int32_t heading=signed32(get32(state+120));if(heading< -1920||heading>1920)return VDPL_E_ARGUMENT;
{vdplet_view_v1 v={sizeof(v),0,0,0,0};rc=h->buffer_acquire(h->context,4,VDPL_READ,0,24,&v);if(rc)return rc;for(unsigned i=0;i<6;++i)s.opponents[i].station=get32(v.data+i*4);rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
{vdplet_view_v1 v={sizeof(v),0,0,0,0};rc=h->buffer_acquire(h->context,5,VDPL_READ,0,24,&v);if(rc)return rc;for(unsigned i=0;i<6;++i)s.opponents[i].lateral_q8=get32(v.data+i*4);rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
{vdplet_view_v1 v={sizeof(v),0,0,0,0};rc=h->buffer_acquire(h->context,2,VDPL_READ,0,12,&v);if(rc)return rc;for(unsigned i=0;i<6;++i)s.opponents[i].active=get(v.data+i*2);rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
for(unsigned i=0;i<6;++i){if(s.opponents[i].active)s.opponents[i].heading_turn16=(int16_t)heading;else s.opponents[i]=(RallyRenderOpponentV1){0,0,0,0};}rc=rally_render_prepare_v1(h,&renderer,&s,&done);}
if(done.reason==RALLY_RENDER_REASON_RELEASE)return rc;
vdplet_view_v1 out={sizeof(out),0,0,0,0};int32_t pr=h->buffer_acquire(h->context,50304,VDPL_WRITE,0,48,&out);if(pr)return pr;memcpy(out.data,&done,48);pr=h->buffer_release(h->context,out.lease);return pr?pr:rc;}
#include "publication.inc"
__attribute__((visibility("default")))
int32_t vdplet_entry(const vdplet_host_v1*h,const vdplet_request_v1*r){
if(!h||!r||h->struct_bytes<sizeof(*h)||r->struct_bytes<sizeof(*r)||h->abi_major!=1||!(h->capabilities&VDPL_CAP_BUFFERS)||!h->buffer_acquire||!h->buffer_release)return VDPL_E_ABI;
if(r->operation==VDPL_INIT)return identity==0x474c3332u?0:VDPL_E_INIT;
if(r->operation==VDPL_FINI)return 0;
if(r->operation!=VDPL_RUN || (r->entry_id!=3 && r->entry_id!=13 && r->entry_id!=15 && r->entry_id!=16))return VDPL_E_UNSUPPORTED;
if(r->argument_bytes!=2)return VDPL_E_ARGUMENT;
vdplet_view_v1 args={sizeof(args),0,0,0,0},view={sizeof(view),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,r->argument_buffer,VDPL_READ,0,2,&args);if(rc)return rc;
uint16_t id=get(args.data);rc=h->buffer_release(h->context,args.lease);if(rc)return rc;args.lease=0;rc=h->buffer_acquire(h->context,id,VDPL_WRITE,0,VDPL_WHOLE_BUFFER,&view);if(rc){return rc;}
if(view.bytes!=310){h->buffer_release(h->context,view.lease);return VDPL_E_BOUNDS;}
uint8_t*state=view.data;put(state+12,0);
uint32_t r28_next_generation=get32(state+20)+1u,r28_next_request=get32(state+296)+1u;
static const uint8_t offsets[] __attribute__((aligned(4)))={0,1,2,3,4,5,6,7,26,27,30,31,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,};
static const uint8_t values[] __attribute__((aligned(4)))={82,71,1,0,112,0,54,1,4,0,0,0,17,0,198,0,0,0,0,0,48,53,50,82,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
static const uint8_t errors[] __attribute__((aligned(4)))={1,1,2,2,3,3,3,3,3,3,6,6,3,3,3,3,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,};
for(unsigned i=0;i<sizeof(offsets);++i)if(state[offsets[i]]!=values[i])ROOT_FAIL(errors[i],VDPL_E_ARGUMENT);
if(!get32(state+8))ROOT_FAIL(4,VDPL_E_ARGUMENT);
if(get(state+28)>=17u||get(state+28)!=r->entry_id)ROOT_FAIL(7,VDPL_E_ARGUMENT);
{vdplet_view_v1 bound={sizeof(bound),0,0,0,0};rc=h->buffer_acquire(h->context,2,2,0,VDPL_WHOLE_BUFFER,&bound);
if(rc){ROOT_FAIL(8,rc);}
uint32_t shape=bound.bytes;rc=h->buffer_release(h->context,bound.lease);
if(rc){ROOT_FAIL(8,rc);}
if(shape!=12u){ROOT_FAIL(8,VDPL_E_BOUNDS);}}
{vdplet_view_v1 bound={sizeof(bound),0,0,0,0};rc=h->buffer_acquire(h->context,3,2,0,VDPL_WHOLE_BUFFER,&bound);
if(rc){ROOT_FAIL(8,rc);}
uint32_t shape=bound.bytes;rc=h->buffer_release(h->context,bound.lease);
if(rc){ROOT_FAIL(8,rc);}
if(shape!=24u){ROOT_FAIL(8,VDPL_E_BOUNDS);}}
{vdplet_view_v1 bound={sizeof(bound),0,0,0,0};rc=h->buffer_acquire(h->context,4,2,0,VDPL_WHOLE_BUFFER,&bound);
if(rc){ROOT_FAIL(8,rc);}
uint32_t shape=bound.bytes;rc=h->buffer_release(h->context,bound.lease);
if(rc){ROOT_FAIL(8,rc);}
if(shape!=24u){ROOT_FAIL(8,VDPL_E_BOUNDS);}}
{vdplet_view_v1 bound={sizeof(bound),0,0,0,0};rc=h->buffer_acquire(h->context,5,2,0,VDPL_WHOLE_BUFFER,&bound);
if(rc){ROOT_FAIL(8,rc);}
uint32_t shape=bound.bytes;rc=h->buffer_release(h->context,bound.lease);
if(rc){ROOT_FAIL(8,rc);}
if(shape!=24u){ROOT_FAIL(8,VDPL_E_BOUNDS);}}
{vdplet_view_v1 bound={sizeof(bound),0,0,0,0};rc=h->buffer_acquire(h->context,6,2,0,VDPL_WHOLE_BUFFER,&bound);
if(rc){ROOT_FAIL(8,rc);}
uint32_t shape=bound.bytes;rc=h->buffer_release(h->context,bound.lease);
if(rc){ROOT_FAIL(8,rc);}
if(shape!=12u){ROOT_FAIL(8,VDPL_E_BOUNDS);}}
{vdplet_view_v1 bound={sizeof(bound),0,0,0,0};rc=h->buffer_acquire(h->context,7,1,0,VDPL_WHOLE_BUFFER,&bound);
if(rc){ROOT_FAIL(8,rc);}
uint32_t shape=bound.bytes;rc=h->buffer_release(h->context,bound.lease);
if(rc){ROOT_FAIL(8,rc);}
if(shape!=48u){ROOT_FAIL(8,VDPL_E_BOUNDS);}}
{vdplet_view_v1 bound={sizeof(bound),0,0,0,0};rc=h->buffer_acquire(h->context,8,1,0,VDPL_WHOLE_BUFFER,&bound);
if(rc){ROOT_FAIL(8,rc);}
uint32_t shape=bound.bytes;rc=h->buffer_release(h->context,bound.lease);
if(rc){ROOT_FAIL(8,rc);}
if(shape!=514u){ROOT_FAIL(8,VDPL_E_BOUNDS);}}
put(state+14,0);
if((int64_t)(signed32(get32(state+144)))<-32768ll)FAIL(32);
if((int64_t)(signed32(get32(state+144)))>32767ll)FAIL(32);
if((int64_t)(signed32(get32(state+186)))<1ll)FAIL(32);
if((int64_t)(signed32(get32(state+186)))>3276800ll)FAIL(32);
if((int64_t)(signed32(get32(state+202)))<-38400ll)FAIL(32);
if((int64_t)(signed32(get32(state+202)))>38400ll)FAIL(32);
if((int64_t)(signed32(get32(state+210)))<-14260ll)FAIL(32);
if((int64_t)(signed32(get32(state+210)))>14260ll)FAIL(32);
if(get(state+226)>1u)FAIL(32);
if(get(state+228)>1u)FAIL(32);
if((int64_t)(signed32(get32(state+234)))<-14260ll)FAIL(32);
if((int64_t)(signed32(get32(state+234)))>14260ll)FAIL(32);
if(get(state+238)>1u)FAIL(32);
if((int64_t)(signed32(get32(state+272)))<-10ll)FAIL(32);
if((int64_t)(signed32(get32(state+272)))>10ll)FAIL(32);
if((int64_t)(signed32(get32(state+276)))<-3ll)FAIL(32);
if((int64_t)(signed32(get32(state+276)))>3ll)FAIL(32);
if(get(state+304)>7999u)FAIL(32);
if(signed16(get(state+306))<-21)FAIL(32);
if(signed16(get(state+306))>21)FAIL(32);
if(get(state+308)>7u)FAIL(32);
switch(r->entry_id){
case 3:{
uint32_t v178=get(state+116);
uint32_t v179=(v178==0u)?1u:0u;
if(v179){
uint32_t v180=get(state+114);
uint32_t v181=(uint32_t)(v180)+(uint32_t)(1u);
if(v181>65535u)FAIL(1);
put(state+114,v181);
uint32_t v182=get(state+114);
uint32_t v183=(v182>=6u)?1u:0u;
if(v183){
put(state+114,0u);
}else{
}
uint32_t v184=get(state+114);
uint32_t v185=(uint32_t)(v184)*(uint32_t)(4u);
if(v185>65535u)FAIL(3);
put(state+118,v185);
uint32_t v186=get(state+118);
int32_t index187=(int32_t)(v186);
if(index187<0||index187>23)FAIL(5);
uint32_t v188;{vdplet_view_v1 av188={sizeof(av188),0,0,0,0};
rc=h->buffer_acquire(h->context,7,VDPL_READ,(uint32_t)(index187-(0))*2u,2,&av188);
if(rc){ROOT_FAIL(8,rc);}
v188=get(av188.data);
rc=h->buffer_release(h->context,av188.lease);if(rc){ROOT_FAIL(8,rc);}}
if(v188>32767u)FAIL(32);
put(state+116,v188);
uint32_t v189=get(state+118);
uint32_t v190=(uint32_t)(v189)+(uint32_t)(2u);
if(v190>65535u)FAIL(1);
int32_t index191=(int32_t)(v190);
if(index191<0||index191>23)FAIL(5);
uint32_t v192;{vdplet_view_v1 av192={sizeof(av192),0,0,0,0};
rc=h->buffer_acquire(h->context,7,VDPL_READ,(uint32_t)(index191-(0))*2u,2,&av192);
if(rc){ROOT_FAIL(8,rc);}
v192=get(av192.data);
rc=h->buffer_release(h->context,av192.lease);if(rc){ROOT_FAIL(8,rc);}}
int64_t nv193=(int64_t)(signed16(v192));
if(nv193<-2147483648ll||nv193>2147483647ll)FAIL(32);
uint32_t v193=(uint32_t)nv193;
put32(state+120,v193);
}else{
}
uint32_t v194=get(state+114);
uint32_t v195=(uint32_t)(v194)*(uint32_t)(4u);
if(v195>65535u)FAIL(3);
put(state+118,v195);
uint32_t v196=get32(state+120);
uint32_t v197=get(state+118);
uint32_t v198=(uint32_t)(v197)+(uint32_t)(3u);
if(v198>65535u)FAIL(1);
int32_t index199=(int32_t)(v198);
if(index199<0||index199>23)FAIL(5);
uint32_t v200;{vdplet_view_v1 av200={sizeof(av200),0,0,0,0};
rc=h->buffer_acquire(h->context,7,VDPL_READ,(uint32_t)(index199-(0))*2u,2,&av200);
if(rc){ROOT_FAIL(8,rc);}
v200=get(av200.data);
rc=h->buffer_release(h->context,av200.lease);if(rc){ROOT_FAIL(8,rc);}}
int64_t nv201=(int64_t)(signed16(v200));
if(nv201<-2147483648ll||nv201>2147483647ll)FAIL(32);
uint32_t v201=(uint32_t)nv201;
int64_t nv202=(int64_t)signed32(v196)+(int64_t)signed32(v201);
if(nv202 < -2147483648ll || nv202 >2147483647ll)FAIL(1);
uint32_t v202=(uint32_t)nv202;
put32(state+120,v202);
uint32_t v203=get32(state+120);
put32(state+140,v203);
uint32_t v204=get32(state+140);
if((int64_t)(signed32(v204))<-32768ll)FAIL(32);
if((int64_t)(signed32(v204))>32767ll)FAIL(32);
put32(state+144,v204);
uint32_t v205=get32(state+144);
put32(state+148,v205);
uint32_t v206=get32(state+148);
uint32_t v207=(signed32(v206)<signed32(0u))?1u:0u;
if(v207){
uint32_t v208=get32(state+148);
int64_t nv209=(int64_t)signed32(0u)-(int64_t)signed32(v208);
if(nv209 < -2147483648ll || nv209 >2147483647ll)FAIL(2);
uint32_t v209=(uint32_t)nv209;
put32(state+148,v209);
}else{
}
uint32_t v210=get32(state+148);
uint32_t v211=(signed32(v210)>signed32(16384u))?1u:0u;
if(v211){
uint32_t v212=get32(state+148);
int64_t nv213=(int64_t)signed32(32768u)-(int64_t)signed32(v212);
if(nv213 < -2147483648ll || nv213 >2147483647ll)FAIL(2);
uint32_t v213=(uint32_t)nv213;
put32(state+148,v213);
}else{
}
uint32_t v214=get32(state+148);
uint32_t v215=64u;
if(!v215)FAIL(4);
if(v214==2147483648u && v215==4294967295u)FAIL(6);
uint32_t v216=(uint32_t)(signed32(v214)/signed32(v215)),v217=(uint32_t)(signed32(v214)%signed32(v215));
put32(state+152,v216);
put32(state+156,v217);
uint32_t v218=get32(state+152);
int64_t nv219=(int64_t)(signed32(v218));
if(nv219<0ll||nv219>65535ll)FAIL(32);
uint32_t v219=(uint32_t)nv219&65535u;
put(state+160,v219);
uint32_t v220=get(state+160);
int32_t index221=(int32_t)(v220);
if(index221<0||index221>256)FAIL(5);
uint32_t v222;{vdplet_view_v1 av222={sizeof(av222),0,0,0,0};
rc=h->buffer_acquire(h->context,8,VDPL_READ,(uint32_t)(index221-(0))*2u,2,&av222);
if(rc){ROOT_FAIL(8,rc);}
v222=get(av222.data);
rc=h->buffer_release(h->context,av222.lease);if(rc){ROOT_FAIL(8,rc);}}
int64_t nv223=(int64_t)(signed16(v222));
if(nv223<-2147483648ll||nv223>2147483647ll)FAIL(32);
uint32_t v223=(uint32_t)nv223;
put32(state+162,v223);
uint32_t v224=get(state+160);
uint32_t v225=(v224<256u)?1u:0u;
if(v225){
uint32_t v226=get(state+160);
uint32_t v227=(uint32_t)(v226)+(uint32_t)(1u);
if(v227>65535u)FAIL(1);
int32_t index228=(int32_t)(v227);
if(index228<0||index228>256)FAIL(5);
uint32_t v229;{vdplet_view_v1 av229={sizeof(av229),0,0,0,0};
rc=h->buffer_acquire(h->context,8,VDPL_READ,(uint32_t)(index228-(0))*2u,2,&av229);
if(rc){ROOT_FAIL(8,rc);}
v229=get(av229.data);
rc=h->buffer_release(h->context,av229.lease);if(rc){ROOT_FAIL(8,rc);}}
int64_t nv230=(int64_t)(signed16(v229));
if(nv230<-2147483648ll||nv230>2147483647ll)FAIL(32);
uint32_t v230=(uint32_t)nv230;
uint32_t v231=get32(state+162);
int64_t nv232=(int64_t)signed32(v230)-(int64_t)signed32(v231);
if(nv232 < -2147483648ll || nv232 >2147483647ll)FAIL(2);
uint32_t v232=(uint32_t)nv232;
uint32_t v233=get32(state+156);
int64_t nv234=(int64_t)signed32(v232)*(int64_t)signed32(v233);
if(nv234 < -2147483648ll || nv234 >2147483647ll)FAIL(3);
uint32_t v234=(uint32_t)nv234;
put32(state+166,v234);
uint32_t v235=get32(state+166);
uint32_t v236=64u;
if(!v236)FAIL(4);
if(v235==2147483648u && v236==4294967295u)FAIL(6);
uint32_t v237=(uint32_t)(signed32(v235)/signed32(v236)),v238=(uint32_t)(signed32(v235)%signed32(v236));
put32(state+170,v237);
put32(state+174,v238);
uint32_t v239=get32(state+162);
uint32_t v240=get32(state+170);
int64_t nv241=(int64_t)signed32(v239)+(int64_t)signed32(v240);
if(nv241 < -2147483648ll || nv241 >2147483647ll)FAIL(1);
uint32_t v241=(uint32_t)nv241;
put32(state+162,v241);
}else{
}
uint32_t v242=get32(state+144);
uint32_t v243=(signed32(v242)<signed32(0u))?1u:0u;
if(v243){
uint32_t v244=get32(state+162);
int64_t nv245=(int64_t)signed32(0u)-(int64_t)signed32(v244);
if(nv245 < -2147483648ll || nv245 >2147483647ll)FAIL(2);
uint32_t v245=(uint32_t)nv245;
put32(state+162,v245);
}else{
}
uint32_t v246=get(state+118);
uint32_t v247=(uint32_t)(v246)+(uint32_t)(1u);
if(v247>65535u)FAIL(1);
int32_t index248=(int32_t)(v247);
if(index248<0||index248>23)FAIL(5);
uint32_t v249;{vdplet_view_v1 av249={sizeof(av249),0,0,0,0};
rc=h->buffer_acquire(h->context,7,VDPL_READ,(uint32_t)(index248-(0))*2u,2,&av249);
if(rc){ROOT_FAIL(8,rc);}
v249=get(av249.data);
rc=h->buffer_release(h->context,av249.lease);if(rc){ROOT_FAIL(8,rc);}}
int64_t nv250=(int64_t)(signed16(v249));
if(nv250<-2147483648ll||nv250>2147483647ll)FAIL(32);
uint32_t v250=(uint32_t)nv250;
put32(state+178,v250);
uint32_t v251=get32(state+178);
int64_t nv252=(int64_t)signed32(v251)*(int64_t)signed32(2u);
if(nv252 < -2147483648ll || nv252 >2147483647ll)FAIL(3);
uint32_t v252=(uint32_t)nv252;
uint32_t v253=get32(state+162);
int64_t nv254=(int64_t)signed32(v252)*(int64_t)signed32(v253);
if(nv254 < -2147483648ll || nv254 >2147483647ll)FAIL(3);
uint32_t v254=(uint32_t)nv254;
put32(state+166,v254);
uint32_t v255=get32(state+166);
uint32_t v256=12800u;
if(!v256)FAIL(4);
if(v255==2147483648u && v256==4294967295u)FAIL(6);
uint32_t v257=(uint32_t)(signed32(v255)/signed32(v256)),v258=(uint32_t)(signed32(v255)%signed32(v256));
put32(state+170,v257);
put32(state+174,v258);
uint32_t v259=get32(state+124);
uint32_t v260=get32(state+170);
int64_t nv261=(int64_t)signed32(v259)+(int64_t)signed32(v260);
if(nv261 < -2147483648ll || nv261 >2147483647ll)FAIL(1);
uint32_t v261=(uint32_t)nv261;
put32(state+124,v261);
uint32_t v262=get32(state+178);
int64_t nv263=(int64_t)signed32(v262)*(int64_t)signed32(2u);
if(nv263 < -2147483648ll || nv263 >2147483647ll)FAIL(3);
uint32_t v263=(uint32_t)nv263;
int64_t nv264=(int64_t)(signed32(v263));
if(nv264<0ll||nv264>4294967295ll)FAIL(32);
uint32_t v264=(uint32_t)nv264;
put32(state+132,v264);
uint32_t v265=get32(state+128);
uint32_t v266=get32(state+132);
uint64_t nv267=(uint64_t)(v265)+(uint64_t)(v266);
if(nv267>4294967295ull)FAIL(1);
uint32_t v267=(uint32_t)nv267;
put32(state+128,v267);
uint32_t v268=get(state+116);
if((uint32_t)(v268)<(uint32_t)(1u))FAIL(2);
uint32_t v269=(uint32_t)(v268)-(uint32_t)(1u);
put(state+116,v269);
uint32_t v270=get32(state+198);
uint32_t v271=get32(state+132);
uint64_t nv272=(uint64_t)(v270)+(uint64_t)(v271);
if(nv272>4294967295ull)FAIL(1);
uint32_t v272=(uint32_t)nv272;
put32(state+198,v272);
uint32_t v273=get32(state+198);
uint32_t v274=get32(state+186);
int64_t nv275=(int64_t)(signed32(v274));
if(nv275<0ll||nv275>4294967295ll)FAIL(32);
uint32_t v275=(uint32_t)nv275;
uint32_t v276=(v273>=v275)?1u:0u;
if(v276){
uint32_t v277=get32(state+198);
uint32_t v278=get32(state+186);
int64_t nv279=(int64_t)(signed32(v278));
if(nv279<0ll||nv279>4294967295ll)FAIL(32);
uint32_t v279=(uint32_t)nv279;
if(v277<v279)FAIL(2);
uint32_t v280=v277-v279;
put32(state+198,v280);
}else{
}
uint32_t v281=get32(state+300);
uint32_t v282=get32(state+132);
uint64_t nv283=(uint64_t)(v281)+(uint64_t)(v282);
if(nv283>4294967295ull)FAIL(1);
uint32_t v283=(uint32_t)nv283;
put32(state+300,v283);
uint32_t v284=get32(state+300);
uint32_t v285=8000u;
if(!v285)FAIL(4);
uint32_t v286=v284/v285,v287=v284%v285;
put32(state+264,v286);
put32(state+268,v287);
uint32_t v288=get32(state+268);
int64_t nv289=(int64_t)(v288);
if(nv289<0ll||nv289>65535ll)FAIL(32);
uint32_t v289=(uint32_t)nv289&65535u;
if(v289>7999u)FAIL(32);
put(state+304,v289);
uint32_t v290=get32(state+182);
if((int64_t)(signed32(v290))<1ll)FAIL(32);
if((int64_t)(signed32(v290))>3276800ll)FAIL(32);
put32(state+186,v290);
if(0u>1u)FAIL(32);
put(state+228,0u);
for(uint32_t loop291=0;loop291<6u;++loop291){
put(state+112,(uint16_t)(0+(int32_t)loop291*(1)));
uint32_t v292=get(state+112);
int32_t index293=(int32_t)(v292);
if(index293<0||index293>5)FAIL(5);
uint32_t v294;{vdplet_view_v1 av294={sizeof(av294),0,0,0,0};
rc=h->buffer_acquire(h->context,2,VDPL_READ,(uint32_t)(index293-(0))*2u,2,&av294);
if(rc){ROOT_FAIL(8,rc);}
v294=get(av294.data);
rc=h->buffer_release(h->context,av294.lease);if(rc){ROOT_FAIL(8,rc);}}
if(v294>1u)FAIL(32);
put(state+238,v294);
uint32_t v295=get(state+112);
int32_t index296=(int32_t)(v295);
if(index296<0||index296>5)FAIL(5);
{vdplet_view_v1 store297={sizeof(store297),0,0,0,0};
rc=h->buffer_acquire(h->context,6,VDPL_WRITE,(uint32_t)(index296-(0))*2u,2,&store297);
if(rc){ROOT_FAIL(8,rc);}
put(store297.data,0u);
rc=h->buffer_release(h->context,store297.lease);if(rc){ROOT_FAIL(8,rc);}}
uint32_t v298=get(state+238);
uint32_t v299=(v298==1u)?1u:0u;
if(v299){
uint32_t v300=get(state+112);
int32_t index301=(int32_t)(v300);
if(index301<0||index301>5)FAIL(5);
uint32_t v303=get(state+112);
int32_t index304=(int32_t)(v303);
if(index304<0||index304>5)FAIL(5);
uint32_t v305;{vdplet_view_v1 av305={sizeof(av305),0,0,0,0};
rc=h->buffer_acquire(h->context,3,VDPL_READ,(uint32_t)(index304-(0))*4u,4,&av305);
if(rc){ROOT_FAIL(8,rc);}
v305=get32(av305.data);
rc=h->buffer_release(h->context,av305.lease);if(rc){ROOT_FAIL(8,rc);}}
uint32_t v306=get32(state+132);
int64_t nv307=(int64_t)(v306);
if(nv307<-2147483648ll||nv307>2147483647ll)FAIL(32);
uint32_t v307=(uint32_t)nv307;
int64_t nv308=(int64_t)signed32(v305)+(int64_t)signed32(v307);
if(nv308 < -2147483648ll || nv308 >2147483647ll)FAIL(1);
uint32_t v308=(uint32_t)nv308;
{vdplet_view_v1 store302={sizeof(store302),0,0,0,0};
rc=h->buffer_acquire(h->context,3,VDPL_WRITE,(uint32_t)(index301-(0))*4u,4,&store302);
if(rc){ROOT_FAIL(8,rc);}
put32(store302.data,v308);
rc=h->buffer_release(h->context,store302.lease);if(rc){ROOT_FAIL(8,rc);}}
uint32_t v309=get(state+112);
int32_t index310=(int32_t)(v309);
if(index310<0||index310>5)FAIL(5);
uint32_t v311;{vdplet_view_v1 av311={sizeof(av311),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_READ,(uint32_t)(index310-(0))*4u,4,&av311);
if(rc){ROOT_FAIL(8,rc);}
v311=get32(av311.data);
rc=h->buffer_release(h->context,av311.lease);if(rc){ROOT_FAIL(8,rc);}}
int64_t nv312=(int64_t)(v311);
if(nv312<-2147483648ll||nv312>2147483647ll)FAIL(32);
uint32_t v312=(uint32_t)nv312;
uint32_t v313=get32(state+132);
int64_t nv314=(int64_t)(v313);
if(nv314<-2147483648ll||nv314>2147483647ll)FAIL(32);
uint32_t v314=(uint32_t)nv314;
int64_t nv315=(int64_t)signed32(v312)+(int64_t)signed32(v314);
if(nv315 < -2147483648ll || nv315 >2147483647ll)FAIL(1);
uint32_t v315=(uint32_t)nv315;
put32(state+166,v315);
uint32_t v316=get32(state+166);
uint32_t v317=get32(state+186);
uint32_t v318=v317;
if(!v318)FAIL(4);
if(v316==2147483648u && v318==4294967295u)FAIL(6);
uint32_t v319=(uint32_t)(signed32(v316)/signed32(v318)),v320=(uint32_t)(signed32(v316)%signed32(v318));
put32(state+170,v319);
put32(state+174,v320);
uint32_t v321=get32(state+174);
uint32_t v322=(signed32(v321)<signed32(0u))?1u:0u;
if(v322){
uint32_t v323=get32(state+174);
uint32_t v324=get32(state+186);
int64_t nv325=(int64_t)signed32(v323)+(int64_t)signed32(v324);
if(nv325 < -2147483648ll || nv325 >2147483647ll)FAIL(1);
uint32_t v325=(uint32_t)nv325;
put32(state+174,v325);
}else{
}
uint32_t v326=get(state+112);
int32_t index327=(int32_t)(v326);
if(index327<0||index327>5)FAIL(5);
uint32_t v329=get32(state+174);
int64_t nv330=(int64_t)(signed32(v329));
if(nv330<0ll||nv330>4294967295ll)FAIL(32);
uint32_t v330=(uint32_t)nv330;
{vdplet_view_v1 store328={sizeof(store328),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_WRITE,(uint32_t)(index327-(0))*4u,4,&store328);
if(rc){ROOT_FAIL(8,rc);}
put32(store328.data,v330);
rc=h->buffer_release(h->context,store328.lease);if(rc){ROOT_FAIL(8,rc);}}
uint32_t v331=get(state+112);
uint32_t v332=3u;
if(!v332)FAIL(4);
uint32_t v333=v331/v332,v334=v331%v332;
put(state+230,v333);
put(state+232,v334);
uint32_t v335=get(state+232);
int64_t nv336=(int64_t)(v335);
if(nv336<-2147483648ll||nv336>2147483647ll)FAIL(32);
uint32_t v336=(uint32_t)nv336;
int64_t nv337=(int64_t)signed32(v336)-(int64_t)signed32(1u);
if(nv337 < -2147483648ll || nv337 >2147483647ll)FAIL(2);
uint32_t v337=(uint32_t)nv337;
int64_t nv338=(int64_t)signed32(v337)*(int64_t)signed32(9216u);
if(nv338 < -2147483648ll || nv338 >2147483647ll)FAIL(3);
uint32_t v338=(uint32_t)nv338;
if((int64_t)(signed32(v338))<-14260ll)FAIL(32);
if((int64_t)(signed32(v338))>14260ll)FAIL(32);
put32(state+234,v338);
uint32_t v339=get(state+112);
uint32_t v340=2u;
if(!v340)FAIL(4);
uint32_t v341=v339/v340,v342=v339%v340;
put(state+230,v341);
put(state+232,v342);
uint32_t v343=get(state+232);
uint32_t v344=(v343==0u)?1u:0u;
if(v344){
uint32_t v345=get32(state+234);
uint32_t v346=get32(state+124);
int64_t nv347=(int64_t)signed32(v345)+(int64_t)signed32(v346);
if(nv347 < -2147483648ll || nv347 >2147483647ll)FAIL(1);
uint32_t v347=(uint32_t)nv347;
int64_t nv348=(int64_t)signed32(v347)-(int64_t)signed32(5044u);
if(nv348 < -2147483648ll || nv348 >2147483647ll)FAIL(2);
uint32_t v348=(uint32_t)nv348;
if((int64_t)(signed32(v348))<-14260ll)FAIL(32);
if((int64_t)(signed32(v348))>14260ll)FAIL(32);
put32(state+234,v348);
}else{
uint32_t v349=get32(state+234);
uint32_t v350=get32(state+124);
int64_t nv351=(int64_t)signed32(v349)-(int64_t)signed32(v350);
if(nv351 < -2147483648ll || nv351 >2147483647ll)FAIL(2);
uint32_t v351=(uint32_t)nv351;
int64_t nv352=(int64_t)signed32(v351)+(int64_t)signed32(5044u);
if(nv352 < -2147483648ll || nv352 >2147483647ll)FAIL(1);
uint32_t v352=(uint32_t)nv352;
if((int64_t)(signed32(v352))<-14260ll)FAIL(32);
if((int64_t)(signed32(v352))>14260ll)FAIL(32);
put32(state+234,v352);
}
uint32_t v353=get(state+112);
int32_t index354=(int32_t)(v353);
if(index354<0||index354>5)FAIL(5);
uint32_t v356=get32(state+234);
{vdplet_view_v1 store355={sizeof(store355),0,0,0,0};
rc=h->buffer_acquire(h->context,5,VDPL_WRITE,(uint32_t)(index354-(0))*4u,4,&store355);
if(rc){ROOT_FAIL(8,rc);}
put32(store355.data,v356);
rc=h->buffer_release(h->context,store355.lease);if(rc){ROOT_FAIL(8,rc);}}
uint32_t v357=get(state+112);
int32_t index358=(int32_t)(v357);
if(index358<0||index358>5)FAIL(5);
uint32_t v359;{vdplet_view_v1 av359={sizeof(av359),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_READ,(uint32_t)(index358-(0))*4u,4,&av359);
if(rc){ROOT_FAIL(8,rc);}
v359=get32(av359.data);
rc=h->buffer_release(h->context,av359.lease);if(rc){ROOT_FAIL(8,rc);}}
put32(state+206,v359);
uint32_t v360=get(state+112);
int32_t index361=(int32_t)(v360);
if(index361<0||index361>5)FAIL(5);
uint32_t v362;{vdplet_view_v1 av362={sizeof(av362),0,0,0,0};
rc=h->buffer_acquire(h->context,5,VDPL_READ,(uint32_t)(index361-(0))*4u,4,&av362);
if(rc){ROOT_FAIL(8,rc);}
v362=get32(av362.data);
rc=h->buffer_release(h->context,av362.lease);if(rc){ROOT_FAIL(8,rc);}}
if((int64_t)(signed32(v362))<-14260ll)FAIL(32);
if((int64_t)(signed32(v362))>14260ll)FAIL(32);
put32(state+210,v362);
uint32_t v363=get32(state+182);
if((int64_t)(signed32(v363))<1ll)FAIL(32);
if((int64_t)(signed32(v363))>3276800ll)FAIL(32);
put32(state+186,v363);
uint32_t v364=get32(state+206);
int64_t nv365=(int64_t)(v364);
if(nv365<-2147483648ll||nv365>2147483647ll)FAIL(32);
uint32_t v365=(uint32_t)nv365;
uint32_t v366=get32(state+198);
int64_t nv367=(int64_t)(v366);
if(nv367<-2147483648ll||nv367>2147483647ll)FAIL(32);
uint32_t v367=(uint32_t)nv367;
int64_t nv368=(int64_t)signed32(v365)-(int64_t)signed32(v367);
if(nv368 < -2147483648ll || nv368 >2147483647ll)FAIL(2);
uint32_t v368=(uint32_t)nv368;
put32(state+166,v368);
uint32_t v369=get32(state+166);
uint32_t v370=get32(state+186);
uint32_t v371=v370;
if(!v371)FAIL(4);
if(v369==2147483648u && v371==4294967295u)FAIL(6);
uint32_t v372=(uint32_t)(signed32(v369)/signed32(v371)),v373=(uint32_t)(signed32(v369)%signed32(v371));
put32(state+170,v372);
put32(state+174,v373);
uint32_t v374=get32(state+174);
put32(state+214,v374);
uint32_t v375=get32(state+214);
uint32_t v376=(signed32(v375)<signed32(0u))?1u:0u;
if(v376){
uint32_t v377=get32(state+214);
uint32_t v378=get32(state+186);
int64_t nv379=(int64_t)signed32(v377)+(int64_t)signed32(v378);
if(nv379 < -2147483648ll || nv379 >2147483647ll)FAIL(1);
uint32_t v379=(uint32_t)nv379;
put32(state+214,v379);
}else{
}
uint32_t v380=get32(state+186);
uint32_t v381=2u;
if(!v381)FAIL(4);
if(v380==2147483648u && v381==4294967295u)FAIL(6);
uint32_t v382=(uint32_t)(signed32(v380)/signed32(v381)),v383=(uint32_t)(signed32(v380)%signed32(v381));
put32(state+222,v382);
put32(state+174,v383);
uint32_t v384=get32(state+214);
uint32_t v385=get32(state+222);
uint32_t v386=(signed32(v384)>signed32(v385))?1u:0u;
if(v386){
uint32_t v387=get32(state+214);
uint32_t v388=get32(state+186);
int64_t nv389=(int64_t)signed32(v387)-(int64_t)signed32(v388);
if(nv389 < -2147483648ll || nv389 >2147483647ll)FAIL(2);
uint32_t v389=(uint32_t)nv389;
put32(state+214,v389);
}else{
}
uint32_t v390=get32(state+214);
put32(state+166,v390);
uint32_t v391=get32(state+166);
uint32_t v392=(signed32(v391)<signed32(0u))?1u:0u;
if(v392){
uint32_t v393=get32(state+166);
int64_t nv394=(int64_t)signed32(0u)-(int64_t)signed32(v393);
if(nv394 < -2147483648ll || nv394 >2147483647ll)FAIL(2);
uint32_t v394=(uint32_t)nv394;
put32(state+166,v394);
}else{
}
uint32_t v395=get32(state+210);
uint32_t v396=get32(state+202);
int64_t nv397=(int64_t)signed32(v395)-(int64_t)signed32(v396);
if(nv397 < -2147483648ll || nv397 >2147483647ll)FAIL(2);
uint32_t v397=(uint32_t)nv397;
put32(state+218,v397);
uint32_t v398=get32(state+218);
uint32_t v399=(signed32(v398)<signed32(0u))?1u:0u;
if(v399){
uint32_t v400=get32(state+218);
int64_t nv401=(int64_t)signed32(0u)-(int64_t)signed32(v400);
if(nv401 < -2147483648ll || nv401 >2147483647ll)FAIL(2);
uint32_t v401=(uint32_t)nv401;
put32(state+218,v401);
}else{
}
uint32_t v402=get32(state+166);
uint32_t v403=(signed32(v402)<signed32(3200u))?1u:0u;
uint32_t v404=v403;
if(v404){
uint32_t v405=get32(state+218);
uint32_t v406=(signed32(v405)<signed32(6144u))?1u:0u;
v404=v406;
}
if(v404>1u)FAIL(32);
put(state+226,v404);
uint32_t v407=get(state+226);
if(v407){
uint32_t v408=get(state+112);
int32_t index409=(int32_t)(v408);
if(index409<0||index409>5)FAIL(5);
{vdplet_view_v1 store410={sizeof(store410),0,0,0,0};
rc=h->buffer_acquire(h->context,6,VDPL_WRITE,(uint32_t)(index409-(0))*2u,2,&store410);
if(rc){ROOT_FAIL(8,rc);}
put(store410.data,1u);
rc=h->buffer_release(h->context,store410.lease);if(rc){ROOT_FAIL(8,rc);}}
if(1u>1u)FAIL(32);
put(state+228,1u);
}else{
}
}else{
}
}
uint32_t v411=get32(state+136);
uint64_t nv412=(uint64_t)(v411)+(uint64_t)(1u);
if(nv412>4294967295ull)FAIL(1);
uint32_t v412=(uint32_t)nv412;
put32(state+136,v412);
break;}
case 13:{
put(state+114,0u);
put(state+116,60u);
put(state+118,0u);
put32(state+120,0u);
put32(state+124,0u);
put32(state+128,0u);
put32(state+132,0u);
put32(state+136,0u);
put32(state+198,3246800u);
put32(state+300,3246800u);
if((int64_t)(signed32(0u))<-38400ll)FAIL(32);
if((int64_t)(signed32(0u))>38400ll)FAIL(32);
put32(state+202,0u);
put32(state+292,7u);
put32(state+296,0u);
if(6800u>7999u)FAIL(32);
put(state+304,6800u);
if(signed16(0u)<-21)FAIL(32);
if(signed16(0u)>21)FAIL(32);
put(state+306,0u);
if(3u>7u)FAIL(32);
put(state+308,3u);
if(0u>1u)FAIL(32);
put(state+228,0u);
int32_t index464=(int32_t)(0u);
if(index464<0||index464>5)FAIL(5);
{vdplet_view_v1 store465={sizeof(store465),0,0,0,0};
rc=h->buffer_acquire(h->context,2,VDPL_WRITE,(uint32_t)(index464-(0))*2u,2,&store465);
if(rc){ROOT_FAIL(8,rc);}
put(store465.data,1u);
rc=h->buffer_release(h->context,store465.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index466=(int32_t)(0u);
if(index466<0||index466>5)FAIL(5);
{vdplet_view_v1 store467={sizeof(store467),0,0,0,0};
rc=h->buffer_acquire(h->context,3,VDPL_WRITE,(uint32_t)(index466-(0))*4u,4,&store467);
if(rc){ROOT_FAIL(8,rc);}
put32(store467.data,3246800u);
rc=h->buffer_release(h->context,store467.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index468=(int32_t)(0u);
if(index468<0||index468>5)FAIL(5);
{vdplet_view_v1 store469={sizeof(store469),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_WRITE,(uint32_t)(index468-(0))*4u,4,&store469);
if(rc){ROOT_FAIL(8,rc);}
put32(store469.data,3246800u);
rc=h->buffer_release(h->context,store469.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index470=(int32_t)(0u);
if(index470<0||index470>5)FAIL(5);
{vdplet_view_v1 store471={sizeof(store471),0,0,0,0};
rc=h->buffer_acquire(h->context,5,VDPL_WRITE,(uint32_t)(index470-(0))*4u,4,&store471);
if(rc){ROOT_FAIL(8,rc);}
put32(store471.data,0u);
rc=h->buffer_release(h->context,store471.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index472=(int32_t)(0u);
if(index472<0||index472>5)FAIL(5);
{vdplet_view_v1 store473={sizeof(store473),0,0,0,0};
rc=h->buffer_acquire(h->context,6,VDPL_WRITE,(uint32_t)(index472-(0))*2u,2,&store473);
if(rc){ROOT_FAIL(8,rc);}
put(store473.data,0u);
rc=h->buffer_release(h->context,store473.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index474=(int32_t)(1u);
if(index474<0||index474>5)FAIL(5);
{vdplet_view_v1 store475={sizeof(store475),0,0,0,0};
rc=h->buffer_acquire(h->context,2,VDPL_WRITE,(uint32_t)(index474-(0))*2u,2,&store475);
if(rc){ROOT_FAIL(8,rc);}
put(store475.data,1u);
rc=h->buffer_release(h->context,store475.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index476=(int32_t)(1u);
if(index476<0||index476>5)FAIL(5);
{vdplet_view_v1 store477={sizeof(store477),0,0,0,0};
rc=h->buffer_acquire(h->context,3,VDPL_WRITE,(uint32_t)(index476-(0))*4u,4,&store477);
if(rc){ROOT_FAIL(8,rc);}
put32(store477.data,3249999u);
rc=h->buffer_release(h->context,store477.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index478=(int32_t)(1u);
if(index478<0||index478>5)FAIL(5);
{vdplet_view_v1 store479={sizeof(store479),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_WRITE,(uint32_t)(index478-(0))*4u,4,&store479);
if(rc){ROOT_FAIL(8,rc);}
put32(store479.data,3249999u);
rc=h->buffer_release(h->context,store479.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index480=(int32_t)(1u);
if(index480<0||index480>5)FAIL(5);
{vdplet_view_v1 store481={sizeof(store481),0,0,0,0};
rc=h->buffer_acquire(h->context,5,VDPL_WRITE,(uint32_t)(index480-(0))*4u,4,&store481);
if(rc){ROOT_FAIL(8,rc);}
put32(store481.data,0u);
rc=h->buffer_release(h->context,store481.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index482=(int32_t)(1u);
if(index482<0||index482>5)FAIL(5);
{vdplet_view_v1 store483={sizeof(store483),0,0,0,0};
rc=h->buffer_acquire(h->context,6,VDPL_WRITE,(uint32_t)(index482-(0))*2u,2,&store483);
if(rc){ROOT_FAIL(8,rc);}
put(store483.data,0u);
rc=h->buffer_release(h->context,store483.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index484=(int32_t)(2u);
if(index484<0||index484>5)FAIL(5);
{vdplet_view_v1 store485={sizeof(store485),0,0,0,0};
rc=h->buffer_acquire(h->context,2,VDPL_WRITE,(uint32_t)(index484-(0))*2u,2,&store485);
if(rc){ROOT_FAIL(8,rc);}
put(store485.data,1u);
rc=h->buffer_release(h->context,store485.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index486=(int32_t)(2u);
if(index486<0||index486>5)FAIL(5);
{vdplet_view_v1 store487={sizeof(store487),0,0,0,0};
rc=h->buffer_acquire(h->context,3,VDPL_WRITE,(uint32_t)(index486-(0))*4u,4,&store487);
if(rc){ROOT_FAIL(8,rc);}
put32(store487.data,3250000u);
rc=h->buffer_release(h->context,store487.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index488=(int32_t)(2u);
if(index488<0||index488>5)FAIL(5);
{vdplet_view_v1 store489={sizeof(store489),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_WRITE,(uint32_t)(index488-(0))*4u,4,&store489);
if(rc){ROOT_FAIL(8,rc);}
put32(store489.data,3250000u);
rc=h->buffer_release(h->context,store489.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index490=(int32_t)(2u);
if(index490<0||index490>5)FAIL(5);
{vdplet_view_v1 store491={sizeof(store491),0,0,0,0};
rc=h->buffer_acquire(h->context,5,VDPL_WRITE,(uint32_t)(index490-(0))*4u,4,&store491);
if(rc){ROOT_FAIL(8,rc);}
put32(store491.data,0u);
rc=h->buffer_release(h->context,store491.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index492=(int32_t)(2u);
if(index492<0||index492>5)FAIL(5);
{vdplet_view_v1 store493={sizeof(store493),0,0,0,0};
rc=h->buffer_acquire(h->context,6,VDPL_WRITE,(uint32_t)(index492-(0))*2u,2,&store493);
if(rc){ROOT_FAIL(8,rc);}
put(store493.data,0u);
rc=h->buffer_release(h->context,store493.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index494=(int32_t)(3u);
if(index494<0||index494>5)FAIL(5);
{vdplet_view_v1 store495={sizeof(store495),0,0,0,0};
rc=h->buffer_acquire(h->context,2,VDPL_WRITE,(uint32_t)(index494-(0))*2u,2,&store495);
if(rc){ROOT_FAIL(8,rc);}
put(store495.data,1u);
rc=h->buffer_release(h->context,store495.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index496=(int32_t)(3u);
if(index496<0||index496>5)FAIL(5);
{vdplet_view_v1 store497={sizeof(store497),0,0,0,0};
rc=h->buffer_acquire(h->context,3,VDPL_WRITE,(uint32_t)(index496-(0))*4u,4,&store497);
if(rc){ROOT_FAIL(8,rc);}
put32(store497.data,3253200u);
rc=h->buffer_release(h->context,store497.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index498=(int32_t)(3u);
if(index498<0||index498>5)FAIL(5);
{vdplet_view_v1 store499={sizeof(store499),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_WRITE,(uint32_t)(index498-(0))*4u,4,&store499);
if(rc){ROOT_FAIL(8,rc);}
put32(store499.data,3253200u);
rc=h->buffer_release(h->context,store499.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index500=(int32_t)(3u);
if(index500<0||index500>5)FAIL(5);
{vdplet_view_v1 store501={sizeof(store501),0,0,0,0};
rc=h->buffer_acquire(h->context,5,VDPL_WRITE,(uint32_t)(index500-(0))*4u,4,&store501);
if(rc){ROOT_FAIL(8,rc);}
put32(store501.data,0u);
rc=h->buffer_release(h->context,store501.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index502=(int32_t)(3u);
if(index502<0||index502>5)FAIL(5);
{vdplet_view_v1 store503={sizeof(store503),0,0,0,0};
rc=h->buffer_acquire(h->context,6,VDPL_WRITE,(uint32_t)(index502-(0))*2u,2,&store503);
if(rc){ROOT_FAIL(8,rc);}
put(store503.data,0u);
rc=h->buffer_release(h->context,store503.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index504=(int32_t)(4u);
if(index504<0||index504>5)FAIL(5);
{vdplet_view_v1 store505={sizeof(store505),0,0,0,0};
rc=h->buffer_acquire(h->context,2,VDPL_WRITE,(uint32_t)(index504-(0))*2u,2,&store505);
if(rc){ROOT_FAIL(8,rc);}
put(store505.data,1u);
rc=h->buffer_release(h->context,store505.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index506=(int32_t)(4u);
if(index506<0||index506>5)FAIL(5);
{vdplet_view_v1 store507={sizeof(store507),0,0,0,0};
rc=h->buffer_acquire(h->context,3,VDPL_WRITE,(uint32_t)(index506-(0))*4u,4,&store507);
if(rc){ROOT_FAIL(8,rc);}
put32(store507.data,3264800u);
rc=h->buffer_release(h->context,store507.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index508=(int32_t)(4u);
if(index508<0||index508>5)FAIL(5);
{vdplet_view_v1 store509={sizeof(store509),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_WRITE,(uint32_t)(index508-(0))*4u,4,&store509);
if(rc){ROOT_FAIL(8,rc);}
put32(store509.data,3264800u);
rc=h->buffer_release(h->context,store509.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index510=(int32_t)(4u);
if(index510<0||index510>5)FAIL(5);
{vdplet_view_v1 store511={sizeof(store511),0,0,0,0};
rc=h->buffer_acquire(h->context,5,VDPL_WRITE,(uint32_t)(index510-(0))*4u,4,&store511);
if(rc){ROOT_FAIL(8,rc);}
put32(store511.data,0u);
rc=h->buffer_release(h->context,store511.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index512=(int32_t)(4u);
if(index512<0||index512>5)FAIL(5);
{vdplet_view_v1 store513={sizeof(store513),0,0,0,0};
rc=h->buffer_acquire(h->context,6,VDPL_WRITE,(uint32_t)(index512-(0))*2u,2,&store513);
if(rc){ROOT_FAIL(8,rc);}
put(store513.data,0u);
rc=h->buffer_release(h->context,store513.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index514=(int32_t)(5u);
if(index514<0||index514>5)FAIL(5);
{vdplet_view_v1 store515={sizeof(store515),0,0,0,0};
rc=h->buffer_acquire(h->context,2,VDPL_WRITE,(uint32_t)(index514-(0))*2u,2,&store515);
if(rc){ROOT_FAIL(8,rc);}
put(store515.data,1u);
rc=h->buffer_release(h->context,store515.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index516=(int32_t)(5u);
if(index516<0||index516>5)FAIL(5);
{vdplet_view_v1 store517={sizeof(store517),0,0,0,0};
rc=h->buffer_acquire(h->context,3,VDPL_WRITE,(uint32_t)(index516-(0))*4u,4,&store517);
if(rc){ROOT_FAIL(8,rc);}
put32(store517.data,3326800u);
rc=h->buffer_release(h->context,store517.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index518=(int32_t)(5u);
if(index518<0||index518>5)FAIL(5);
{vdplet_view_v1 store519={sizeof(store519),0,0,0,0};
rc=h->buffer_acquire(h->context,4,VDPL_WRITE,(uint32_t)(index518-(0))*4u,4,&store519);
if(rc){ROOT_FAIL(8,rc);}
put32(store519.data,50000u);
rc=h->buffer_release(h->context,store519.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index520=(int32_t)(5u);
if(index520<0||index520>5)FAIL(5);
{vdplet_view_v1 store521={sizeof(store521),0,0,0,0};
rc=h->buffer_acquire(h->context,5,VDPL_WRITE,(uint32_t)(index520-(0))*4u,4,&store521);
if(rc){ROOT_FAIL(8,rc);}
put32(store521.data,0u);
rc=h->buffer_release(h->context,store521.lease);if(rc){ROOT_FAIL(8,rc);}}
int32_t index522=(int32_t)(5u);
if(index522<0||index522>5)FAIL(5);
{vdplet_view_v1 store523={sizeof(store523),0,0,0,0};
rc=h->buffer_acquire(h->context,6,VDPL_WRITE,(uint32_t)(index522-(0))*2u,2,&store523);
if(rc){ROOT_FAIL(8,rc);}
put(store523.data,0u);
rc=h->buffer_release(h->context,store523.lease);if(rc){ROOT_FAIL(8,rc);}}
break;}
case 15:{
uint32_t v584=get32(state+296);
uint64_t nv585=(uint64_t)(v584)+(uint64_t)(1u);
if(nv585>4294967295ull)FAIL(1);
uint32_t v585=(uint32_t)nv585;
put32(state+296,v585);
break;}
case 16:{
if(0u>7u)FAIL(32);
put(state+308,0u);
break;}
}
rc=renderer_hook(h,r->entry_id,state);if(rc){int32_t rr=h->buffer_release(h->context,view.lease);return rr?rr:rc;}put32(state+20,get32(state+20)+1u);put(state+24,r->entry_id);put32(state+32,get32(state+8));
if(r->entry_id==15){rc=r28_check_publication(h,state,r28_next_generation,r28_next_request);if(rc){int32_t rr=h->buffer_release(h->context,view.lease);return rr?rr:rc;}}
return h->buffer_release(h->context,view.lease);
}
