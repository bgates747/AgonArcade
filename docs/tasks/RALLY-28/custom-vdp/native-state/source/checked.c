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
/* Native-owned state. No pointer here refers to a borrowed VDP buffer. */
typedef struct { int32_t progress; uint32_t position; int32_t lateral;
                 uint16_t active,contacts; } NativeOpponent;
_Static_assert(sizeof(NativeOpponent)==16,"native opponent layout");
typedef struct {
    uint16_t slot;
    uint16_t routeRecord;
    uint16_t routeRemaining;
    uint16_t routeIndex;
    int32_t routeHeading;
    int32_t routeLateral;
    uint32_t routeForward;
    uint32_t forwardAdvance;
    uint32_t worldTick;
    int32_t headingInput;
    int32_t headingChecked;
    int32_t magnitude;
    int32_t sineQuotient;
    int32_t sineFraction;
    uint16_t sineIndex;
    int32_t sineValue;
    int32_t work;
    int32_t quotient;
    int32_t remainder;
    int32_t speed;
    int32_t lapInput;
    int32_t lap;
    int32_t normalizeInput;
    uint32_t normalPosition;
    uint32_t playerStation;
    int32_t playerLateral;
    uint32_t opponentStation;
    int32_t opponentLateral;
    int32_t separation;
    int32_t lateralSeparation;
    int32_t halfLap;
    uint16_t contactResult;
    uint16_t contactAny;
    uint16_t laneQuotient;
    uint16_t laneRemainder;
    int32_t placedLateral;
    uint16_t activeChecked;
    int32_t sa;
    int32_t sb;
    int32_t sq;
    int32_t sr;
    uint32_t ua;
    uint32_t ub;
    uint32_t uq;
    uint32_t ur;
    int32_t boundedQ;
    int32_t boundedR;
    uint16_t effect;
    uint16_t shiftCount;
    int32_t signedShift;
    uint32_t unsignedShift;
    uint32_t renderSession;
    uint32_t renderRequest;
    uint32_t playerUnwrapped;
    uint16_t renderPhase;
    int16_t renderSteering;
    uint16_t renderFlags;
    NativeOpponent opponents[6];
    uint16_t failure;
} NativeWorld;
static NativeWorld world;
static uint32_t owner_session;
static uint16_t initialized,poisoned;
static const int16_t native_routes[24]={60,180,0,32,60,180,1920,-32,180,170,0,0,60,180,0,-32,60,180,-1920,32,180,150,0,0};
static const int16_t native_sine[257]={0,201,402,603,804,1005,1206,1407,1608,1809,2009,2210,2410,2611,2811,3012,3212,3412,3612,3811,4011,4210,4410,4609,4808,5007,5205,5404,5602,5800,5998,6195,6393,6590,6786,6983,7179,7375,7571,7767,7962,8157,8351,8545,8739,8933,9126,9319,9512,9704,9896,10087,10278,10469,10659,10849,11039,11228,11417,11605,11793,11980,12167,12353,12539,12725,12910,13094,13279,13462,13645,13828,14010,14191,14372,14553,14732,14912,15090,15269,15446,15623,15800,15976,16151,16325,16499,16673,16846,17018,17189,17360,17530,17700,17869,18037,18204,18371,18537,18703,18868,19032,19195,19357,19519,19680,19841,20000,20159,20317,20475,20631,20787,20942,21096,21250,21403,21554,21705,21856,22005,22154,22301,22448,22594,22739,22884,23027,23170,23311,23452,23592,23731,23870,24007,24143,24279,24413,24547,24680,24811,24942,25072,25201,25329,25456,25582,25708,25832,25955,26077,26198,26319,26438,26556,26674,26790,26905,27019,27133,27245,27356,27466,27575,27683,27790,27896,28001,28105,28208,28310,28411,28510,28609,28706,28803,28898,28992,29085,29177,29268,29358,29447,29534,29621,29706,29791,29874,29956,30037,30117,30195,30273,30349,30424,30498,30571,30643,30714,30783,30852,30919,30985,31050,31113,31176,31237,31297,31356,31414,31470,31526,31580,31633,31685,31736,31785,31833,31880,31926,31971,32014,32057,32098,32137,32176,32213,32250,32285,32318,32351,32382,32412,32441,32469,32495,32521,32545,32567,32589,32609,32628,32646,32663,32678,32692,32705,32717,32728,32737,32745,32752,32757,32761,32765,32766,32767};
static void import_globals(NativeWorld*w,const uint8_t*p){
w->slot=(uint16_t)get(p+112);
w->routeRecord=(uint16_t)get(p+114);
w->routeRemaining=(uint16_t)get(p+116);
w->routeIndex=(uint16_t)get(p+118);
w->routeHeading=(int32_t)get32(p+120);
w->routeLateral=(int32_t)get32(p+124);
w->routeForward=(uint32_t)get32(p+128);
w->forwardAdvance=(uint32_t)get32(p+132);
w->worldTick=(uint32_t)get32(p+136);
w->headingInput=(int32_t)get32(p+140);
w->headingChecked=(int32_t)get32(p+144);
w->magnitude=(int32_t)get32(p+148);
w->sineQuotient=(int32_t)get32(p+152);
w->sineFraction=(int32_t)get32(p+156);
w->sineIndex=(uint16_t)get(p+160);
w->sineValue=(int32_t)get32(p+162);
w->work=(int32_t)get32(p+166);
w->quotient=(int32_t)get32(p+170);
w->remainder=(int32_t)get32(p+174);
w->speed=(int32_t)get32(p+178);
w->lapInput=(int32_t)get32(p+182);
w->lap=(int32_t)get32(p+186);
w->normalizeInput=(int32_t)get32(p+190);
w->normalPosition=(uint32_t)get32(p+194);
w->playerStation=(uint32_t)get32(p+198);
w->playerLateral=(int32_t)get32(p+202);
w->opponentStation=(uint32_t)get32(p+206);
w->opponentLateral=(int32_t)get32(p+210);
w->separation=(int32_t)get32(p+214);
w->lateralSeparation=(int32_t)get32(p+218);
w->halfLap=(int32_t)get32(p+222);
w->contactResult=(uint16_t)get(p+226);
w->contactAny=(uint16_t)get(p+228);
w->laneQuotient=(uint16_t)get(p+230);
w->laneRemainder=(uint16_t)get(p+232);
w->placedLateral=(int32_t)get32(p+234);
w->activeChecked=(uint16_t)get(p+238);
w->sa=(int32_t)get32(p+240);
w->sb=(int32_t)get32(p+244);
w->sq=(int32_t)get32(p+248);
w->sr=(int32_t)get32(p+252);
w->ua=(uint32_t)get32(p+256);
w->ub=(uint32_t)get32(p+260);
w->uq=(uint32_t)get32(p+264);
w->ur=(uint32_t)get32(p+268);
w->boundedQ=(int32_t)get32(p+272);
w->boundedR=(int32_t)get32(p+276);
w->effect=(uint16_t)get(p+280);
w->shiftCount=(uint16_t)get(p+282);
w->signedShift=(int32_t)get32(p+284);
w->unsignedShift=(uint32_t)get32(p+288);
w->renderSession=(uint32_t)get32(p+292);
w->renderRequest=(uint32_t)get32(p+296);
w->playerUnwrapped=(uint32_t)get32(p+300);
w->renderPhase=(uint16_t)get(p+304);
w->renderSteering=(int16_t)get(p+306);
w->renderFlags=(uint16_t)get(p+308);
}
static void export_globals(uint8_t*p,const NativeWorld*w){
put(p+112,(uint32_t)w->slot);
put(p+114,(uint32_t)w->routeRecord);
put(p+116,(uint32_t)w->routeRemaining);
put(p+118,(uint32_t)w->routeIndex);
put32(p+120,(uint32_t)w->routeHeading);
put32(p+124,(uint32_t)w->routeLateral);
put32(p+128,(uint32_t)w->routeForward);
put32(p+132,(uint32_t)w->forwardAdvance);
put32(p+136,(uint32_t)w->worldTick);
put32(p+140,(uint32_t)w->headingInput);
put32(p+144,(uint32_t)w->headingChecked);
put32(p+148,(uint32_t)w->magnitude);
put32(p+152,(uint32_t)w->sineQuotient);
put32(p+156,(uint32_t)w->sineFraction);
put(p+160,(uint32_t)w->sineIndex);
put32(p+162,(uint32_t)w->sineValue);
put32(p+166,(uint32_t)w->work);
put32(p+170,(uint32_t)w->quotient);
put32(p+174,(uint32_t)w->remainder);
put32(p+178,(uint32_t)w->speed);
put32(p+182,(uint32_t)w->lapInput);
put32(p+186,(uint32_t)w->lap);
put32(p+190,(uint32_t)w->normalizeInput);
put32(p+194,(uint32_t)w->normalPosition);
put32(p+198,(uint32_t)w->playerStation);
put32(p+202,(uint32_t)w->playerLateral);
put32(p+206,(uint32_t)w->opponentStation);
put32(p+210,(uint32_t)w->opponentLateral);
put32(p+214,(uint32_t)w->separation);
put32(p+218,(uint32_t)w->lateralSeparation);
put32(p+222,(uint32_t)w->halfLap);
put(p+226,(uint32_t)w->contactResult);
put(p+228,(uint32_t)w->contactAny);
put(p+230,(uint32_t)w->laneQuotient);
put(p+232,(uint32_t)w->laneRemainder);
put32(p+234,(uint32_t)w->placedLateral);
put(p+238,(uint32_t)w->activeChecked);
put32(p+240,(uint32_t)w->sa);
put32(p+244,(uint32_t)w->sb);
put32(p+248,(uint32_t)w->sq);
put32(p+252,(uint32_t)w->sr);
put32(p+256,(uint32_t)w->ua);
put32(p+260,(uint32_t)w->ub);
put32(p+264,(uint32_t)w->uq);
put32(p+268,(uint32_t)w->ur);
put32(p+272,(uint32_t)w->boundedQ);
put32(p+276,(uint32_t)w->boundedR);
put(p+280,(uint32_t)w->effect);
put(p+282,(uint32_t)w->shiftCount);
put32(p+284,(uint32_t)w->signedShift);
put32(p+288,(uint32_t)w->unsignedShift);
put32(p+292,(uint32_t)w->renderSession);
put32(p+296,(uint32_t)w->renderRequest);
put32(p+300,(uint32_t)w->playerUnwrapped);
put(p+304,(uint32_t)w->renderPhase);
put(p+306,(uint32_t)w->renderSteering);
put(p+308,(uint32_t)w->renderFlags);
}
#undef FAIL
#define FAIL(n) do {w->failure=(n);return VDPL_E_ARGUMENT;}while(0)
static int32_t native_validate(NativeWorld*w){
if((int64_t)(signed32((uint32_t)w->headingChecked))<-32768ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->headingChecked))>32767ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->lap))<1ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->lap))>3276800ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->playerLateral))<-38400ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->playerLateral))>38400ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->opponentLateral))<-14260ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->opponentLateral))>14260ll)FAIL(32);
if((uint32_t)w->contactResult>1u)FAIL(32);
if((uint32_t)w->contactAny>1u)FAIL(32);
if((int64_t)(signed32((uint32_t)w->placedLateral))<-14260ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->placedLateral))>14260ll)FAIL(32);
if((uint32_t)w->activeChecked>1u)FAIL(32);
if((int64_t)(signed32((uint32_t)w->boundedQ))<-10ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->boundedQ))>10ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->boundedR))<-3ll)FAIL(32);
if((int64_t)(signed32((uint32_t)w->boundedR))>3ll)FAIL(32);
if((uint32_t)w->renderPhase>7999u)FAIL(32);
if(signed16((uint32_t)w->renderSteering)<-21)FAIL(32);
if(signed16((uint32_t)w->renderSteering)>21)FAIL(32);
if((uint32_t)w->renderFlags>7u)FAIL(32);
return 0;
}
static int32_t native_3(NativeWorld*w){
uint32_t v178=(uint32_t)w->routeRemaining;
uint32_t v179=(v178==0u)?1u:0u;
if(v179){
uint32_t v180=(uint32_t)w->routeRecord;
uint32_t v181=(uint32_t)(v180)+(uint32_t)(1u);
if(v181>65535u)FAIL(1);
w->routeRecord=(uint16_t)(v181);
uint32_t v182=(uint32_t)w->routeRecord;
uint32_t v183=(v182>=6u)?1u:0u;
if(v183){
w->routeRecord=(uint16_t)(0u);
}else{
}
uint32_t v184=(uint32_t)w->routeRecord;
uint32_t v185=(uint32_t)(v184)*(uint32_t)(4u);
if(v185>65535u)FAIL(3);
w->routeIndex=(uint16_t)(v185);
uint32_t v186=(uint32_t)w->routeIndex;
int32_t index187=(int32_t)(v186);
if(index187<0||index187>23)FAIL(5);
uint32_t v188;v188=(uint16_t)(native_routes[index187]);
if(v188>32767u)FAIL(32);
w->routeRemaining=(uint16_t)(v188);
uint32_t v189=(uint32_t)w->routeIndex;
uint32_t v190=(uint32_t)(v189)+(uint32_t)(2u);
if(v190>65535u)FAIL(1);
int32_t index191=(int32_t)(v190);
if(index191<0||index191>23)FAIL(5);
uint32_t v192;v192=(uint16_t)(native_routes[index191]);
int64_t nv193=(int64_t)(signed16(v192));
if(nv193<-2147483648ll||nv193>2147483647ll)FAIL(32);
uint32_t v193=(uint32_t)nv193;
w->routeHeading=(int32_t)(v193);
}else{
}
uint32_t v194=(uint32_t)w->routeRecord;
uint32_t v195=(uint32_t)(v194)*(uint32_t)(4u);
if(v195>65535u)FAIL(3);
w->routeIndex=(uint16_t)(v195);
uint32_t v196=(uint32_t)w->routeHeading;
uint32_t v197=(uint32_t)w->routeIndex;
uint32_t v198=(uint32_t)(v197)+(uint32_t)(3u);
if(v198>65535u)FAIL(1);
int32_t index199=(int32_t)(v198);
if(index199<0||index199>23)FAIL(5);
uint32_t v200;v200=(uint16_t)(native_routes[index199]);
int64_t nv201=(int64_t)(signed16(v200));
if(nv201<-2147483648ll||nv201>2147483647ll)FAIL(32);
uint32_t v201=(uint32_t)nv201;
int64_t nv202=(int64_t)signed32(v196)+(int64_t)signed32(v201);
if(nv202 < -2147483648ll || nv202 >2147483647ll)FAIL(1);
uint32_t v202=(uint32_t)nv202;
w->routeHeading=(int32_t)(v202);
uint32_t v203=(uint32_t)w->routeHeading;
w->headingInput=(int32_t)(v203);
uint32_t v204=(uint32_t)w->headingInput;
if((int64_t)(signed32(v204))<-32768ll)FAIL(32);
if((int64_t)(signed32(v204))>32767ll)FAIL(32);
w->headingChecked=(int32_t)(v204);
uint32_t v205=(uint32_t)w->headingChecked;
w->magnitude=(int32_t)(v205);
uint32_t v206=(uint32_t)w->magnitude;
uint32_t v207=(signed32(v206)<signed32(0u))?1u:0u;
if(v207){
uint32_t v208=(uint32_t)w->magnitude;
int64_t nv209=(int64_t)signed32(0u)-(int64_t)signed32(v208);
if(nv209 < -2147483648ll || nv209 >2147483647ll)FAIL(2);
uint32_t v209=(uint32_t)nv209;
w->magnitude=(int32_t)(v209);
}else{
}
uint32_t v210=(uint32_t)w->magnitude;
uint32_t v211=(signed32(v210)>signed32(16384u))?1u:0u;
if(v211){
uint32_t v212=(uint32_t)w->magnitude;
int64_t nv213=(int64_t)signed32(32768u)-(int64_t)signed32(v212);
if(nv213 < -2147483648ll || nv213 >2147483647ll)FAIL(2);
uint32_t v213=(uint32_t)nv213;
w->magnitude=(int32_t)(v213);
}else{
}
uint32_t v214=(uint32_t)w->magnitude;
uint32_t v215=64u;
if(!v215)FAIL(4);
if(v214==2147483648u && v215==4294967295u)FAIL(6);
uint32_t v216=(uint32_t)(signed32(v214)/signed32(v215)),v217=(uint32_t)(signed32(v214)%signed32(v215));
w->sineQuotient=(int32_t)(v216);
w->sineFraction=(int32_t)(v217);
uint32_t v218=(uint32_t)w->sineQuotient;
int64_t nv219=(int64_t)(signed32(v218));
if(nv219<0ll||nv219>65535ll)FAIL(32);
uint32_t v219=(uint32_t)nv219&65535u;
w->sineIndex=(uint16_t)(v219);
uint32_t v220=(uint32_t)w->sineIndex;
int32_t index221=(int32_t)(v220);
if(index221<0||index221>256)FAIL(5);
uint32_t v222;v222=(uint16_t)(native_sine[index221]);
int64_t nv223=(int64_t)(signed16(v222));
if(nv223<-2147483648ll||nv223>2147483647ll)FAIL(32);
uint32_t v223=(uint32_t)nv223;
w->sineValue=(int32_t)(v223);
uint32_t v224=(uint32_t)w->sineIndex;
uint32_t v225=(v224<256u)?1u:0u;
if(v225){
uint32_t v226=(uint32_t)w->sineIndex;
uint32_t v227=(uint32_t)(v226)+(uint32_t)(1u);
if(v227>65535u)FAIL(1);
int32_t index228=(int32_t)(v227);
if(index228<0||index228>256)FAIL(5);
uint32_t v229;v229=(uint16_t)(native_sine[index228]);
int64_t nv230=(int64_t)(signed16(v229));
if(nv230<-2147483648ll||nv230>2147483647ll)FAIL(32);
uint32_t v230=(uint32_t)nv230;
uint32_t v231=(uint32_t)w->sineValue;
int64_t nv232=(int64_t)signed32(v230)-(int64_t)signed32(v231);
if(nv232 < -2147483648ll || nv232 >2147483647ll)FAIL(2);
uint32_t v232=(uint32_t)nv232;
uint32_t v233=(uint32_t)w->sineFraction;
int64_t nv234=(int64_t)signed32(v232)*(int64_t)signed32(v233);
if(nv234 < -2147483648ll || nv234 >2147483647ll)FAIL(3);
uint32_t v234=(uint32_t)nv234;
w->work=(int32_t)(v234);
uint32_t v235=(uint32_t)w->work;
uint32_t v236=64u;
if(!v236)FAIL(4);
if(v235==2147483648u && v236==4294967295u)FAIL(6);
uint32_t v237=(uint32_t)(signed32(v235)/signed32(v236)),v238=(uint32_t)(signed32(v235)%signed32(v236));
w->quotient=(int32_t)(v237);
w->remainder=(int32_t)(v238);
uint32_t v239=(uint32_t)w->sineValue;
uint32_t v240=(uint32_t)w->quotient;
int64_t nv241=(int64_t)signed32(v239)+(int64_t)signed32(v240);
if(nv241 < -2147483648ll || nv241 >2147483647ll)FAIL(1);
uint32_t v241=(uint32_t)nv241;
w->sineValue=(int32_t)(v241);
}else{
}
uint32_t v242=(uint32_t)w->headingChecked;
uint32_t v243=(signed32(v242)<signed32(0u))?1u:0u;
if(v243){
uint32_t v244=(uint32_t)w->sineValue;
int64_t nv245=(int64_t)signed32(0u)-(int64_t)signed32(v244);
if(nv245 < -2147483648ll || nv245 >2147483647ll)FAIL(2);
uint32_t v245=(uint32_t)nv245;
w->sineValue=(int32_t)(v245);
}else{
}
uint32_t v246=(uint32_t)w->routeIndex;
uint32_t v247=(uint32_t)(v246)+(uint32_t)(1u);
if(v247>65535u)FAIL(1);
int32_t index248=(int32_t)(v247);
if(index248<0||index248>23)FAIL(5);
uint32_t v249;v249=(uint16_t)(native_routes[index248]);
int64_t nv250=(int64_t)(signed16(v249));
if(nv250<-2147483648ll||nv250>2147483647ll)FAIL(32);
uint32_t v250=(uint32_t)nv250;
w->speed=(int32_t)(v250);
uint32_t v251=(uint32_t)w->speed;
int64_t nv252=(int64_t)signed32(v251)*(int64_t)signed32(2u);
if(nv252 < -2147483648ll || nv252 >2147483647ll)FAIL(3);
uint32_t v252=(uint32_t)nv252;
uint32_t v253=(uint32_t)w->sineValue;
int64_t nv254=(int64_t)signed32(v252)*(int64_t)signed32(v253);
if(nv254 < -2147483648ll || nv254 >2147483647ll)FAIL(3);
uint32_t v254=(uint32_t)nv254;
w->work=(int32_t)(v254);
uint32_t v255=(uint32_t)w->work;
uint32_t v256=12800u;
if(!v256)FAIL(4);
if(v255==2147483648u && v256==4294967295u)FAIL(6);
uint32_t v257=(uint32_t)(signed32(v255)/signed32(v256)),v258=(uint32_t)(signed32(v255)%signed32(v256));
w->quotient=(int32_t)(v257);
w->remainder=(int32_t)(v258);
uint32_t v259=(uint32_t)w->routeLateral;
uint32_t v260=(uint32_t)w->quotient;
int64_t nv261=(int64_t)signed32(v259)+(int64_t)signed32(v260);
if(nv261 < -2147483648ll || nv261 >2147483647ll)FAIL(1);
uint32_t v261=(uint32_t)nv261;
w->routeLateral=(int32_t)(v261);
uint32_t v262=(uint32_t)w->speed;
int64_t nv263=(int64_t)signed32(v262)*(int64_t)signed32(2u);
if(nv263 < -2147483648ll || nv263 >2147483647ll)FAIL(3);
uint32_t v263=(uint32_t)nv263;
int64_t nv264=(int64_t)(signed32(v263));
if(nv264<0ll||nv264>4294967295ll)FAIL(32);
uint32_t v264=(uint32_t)nv264;
w->forwardAdvance=(uint32_t)(v264);
uint32_t v265=(uint32_t)w->routeForward;
uint32_t v266=(uint32_t)w->forwardAdvance;
uint64_t nv267=(uint64_t)(v265)+(uint64_t)(v266);
if(nv267>4294967295ull)FAIL(1);
uint32_t v267=(uint32_t)nv267;
w->routeForward=(uint32_t)(v267);
uint32_t v268=(uint32_t)w->routeRemaining;
if((uint32_t)(v268)<(uint32_t)(1u))FAIL(2);
uint32_t v269=(uint32_t)(v268)-(uint32_t)(1u);
w->routeRemaining=(uint16_t)(v269);
uint32_t v270=(uint32_t)w->playerStation;
uint32_t v271=(uint32_t)w->forwardAdvance;
uint64_t nv272=(uint64_t)(v270)+(uint64_t)(v271);
if(nv272>4294967295ull)FAIL(1);
uint32_t v272=(uint32_t)nv272;
w->playerStation=(uint32_t)(v272);
uint32_t v273=(uint32_t)w->playerStation;
uint32_t v274=(uint32_t)w->lap;
int64_t nv275=(int64_t)(signed32(v274));
if(nv275<0ll||nv275>4294967295ll)FAIL(32);
uint32_t v275=(uint32_t)nv275;
uint32_t v276=(v273>=v275)?1u:0u;
if(v276){
uint32_t v277=(uint32_t)w->playerStation;
uint32_t v278=(uint32_t)w->lap;
int64_t nv279=(int64_t)(signed32(v278));
if(nv279<0ll||nv279>4294967295ll)FAIL(32);
uint32_t v279=(uint32_t)nv279;
if(v277<v279)FAIL(2);
uint32_t v280=v277-v279;
w->playerStation=(uint32_t)(v280);
}else{
}
uint32_t v281=(uint32_t)w->playerUnwrapped;
uint32_t v282=(uint32_t)w->forwardAdvance;
uint64_t nv283=(uint64_t)(v281)+(uint64_t)(v282);
if(nv283>4294967295ull)FAIL(1);
uint32_t v283=(uint32_t)nv283;
w->playerUnwrapped=(uint32_t)(v283);
uint32_t v284=(uint32_t)w->playerUnwrapped;
uint32_t v285=8000u;
if(!v285)FAIL(4);
uint32_t v286=v284/v285,v287=v284%v285;
w->uq=(uint32_t)(v286);
w->ur=(uint32_t)(v287);
uint32_t v288=(uint32_t)w->ur;
int64_t nv289=(int64_t)(v288);
if(nv289<0ll||nv289>65535ll)FAIL(32);
uint32_t v289=(uint32_t)nv289&65535u;
if(v289>7999u)FAIL(32);
w->renderPhase=(uint16_t)(v289);
uint32_t v290=(uint32_t)w->lapInput;
if((int64_t)(signed32(v290))<1ll)FAIL(32);
if((int64_t)(signed32(v290))>3276800ll)FAIL(32);
w->lap=(int32_t)(v290);
if(0u>1u)FAIL(32);
w->contactAny=(uint16_t)(0u);
for(uint32_t loop291=0;loop291<6u;++loop291){
w->slot=(uint16_t)((uint16_t)(0+(int32_t)loop291*(1)));
uint32_t v292=(uint32_t)w->slot;
int32_t index293=(int32_t)(v292);
if(index293<0||index293>5)FAIL(5);
uint32_t v294;v294=(uint16_t)(w->opponents[index293].active);
if(v294>1u)FAIL(32);
w->activeChecked=(uint16_t)(v294);
uint32_t v295=(uint32_t)w->slot;
int32_t index296=(int32_t)(v295);
if(index296<0||index296>5)FAIL(5);
w->opponents[index296].contacts=(uint16_t)(0u);
uint32_t v298=(uint32_t)w->activeChecked;
uint32_t v299=(v298==1u)?1u:0u;
if(v299){
uint32_t v300=(uint32_t)w->slot;
int32_t index301=(int32_t)(v300);
if(index301<0||index301>5)FAIL(5);
uint32_t v303=(uint32_t)w->slot;
int32_t index304=(int32_t)(v303);
if(index304<0||index304>5)FAIL(5);
uint32_t v305;v305=(uint32_t)(w->opponents[index304].progress);
uint32_t v306=(uint32_t)w->forwardAdvance;
int64_t nv307=(int64_t)(v306);
if(nv307<-2147483648ll||nv307>2147483647ll)FAIL(32);
uint32_t v307=(uint32_t)nv307;
int64_t nv308=(int64_t)signed32(v305)+(int64_t)signed32(v307);
if(nv308 < -2147483648ll || nv308 >2147483647ll)FAIL(1);
uint32_t v308=(uint32_t)nv308;
w->opponents[index301].progress=(int32_t)(v308);
uint32_t v309=(uint32_t)w->slot;
int32_t index310=(int32_t)(v309);
if(index310<0||index310>5)FAIL(5);
uint32_t v311;v311=(uint32_t)(w->opponents[index310].position);
int64_t nv312=(int64_t)(v311);
if(nv312<-2147483648ll||nv312>2147483647ll)FAIL(32);
uint32_t v312=(uint32_t)nv312;
uint32_t v313=(uint32_t)w->forwardAdvance;
int64_t nv314=(int64_t)(v313);
if(nv314<-2147483648ll||nv314>2147483647ll)FAIL(32);
uint32_t v314=(uint32_t)nv314;
int64_t nv315=(int64_t)signed32(v312)+(int64_t)signed32(v314);
if(nv315 < -2147483648ll || nv315 >2147483647ll)FAIL(1);
uint32_t v315=(uint32_t)nv315;
w->work=(int32_t)(v315);
uint32_t v316=(uint32_t)w->work;
uint32_t v317=(uint32_t)w->lap;
uint32_t v318=v317;
if(!v318)FAIL(4);
if(v316==2147483648u && v318==4294967295u)FAIL(6);
uint32_t v319=(uint32_t)(signed32(v316)/signed32(v318)),v320=(uint32_t)(signed32(v316)%signed32(v318));
w->quotient=(int32_t)(v319);
w->remainder=(int32_t)(v320);
uint32_t v321=(uint32_t)w->remainder;
uint32_t v322=(signed32(v321)<signed32(0u))?1u:0u;
if(v322){
uint32_t v323=(uint32_t)w->remainder;
uint32_t v324=(uint32_t)w->lap;
int64_t nv325=(int64_t)signed32(v323)+(int64_t)signed32(v324);
if(nv325 < -2147483648ll || nv325 >2147483647ll)FAIL(1);
uint32_t v325=(uint32_t)nv325;
w->remainder=(int32_t)(v325);
}else{
}
uint32_t v326=(uint32_t)w->slot;
int32_t index327=(int32_t)(v326);
if(index327<0||index327>5)FAIL(5);
uint32_t v329=(uint32_t)w->remainder;
int64_t nv330=(int64_t)(signed32(v329));
if(nv330<0ll||nv330>4294967295ll)FAIL(32);
uint32_t v330=(uint32_t)nv330;
w->opponents[index327].position=(uint32_t)(v330);
uint32_t v331=(uint32_t)w->slot;
uint32_t v332=3u;
if(!v332)FAIL(4);
uint32_t v333=v331/v332,v334=v331%v332;
w->laneQuotient=(uint16_t)(v333);
w->laneRemainder=(uint16_t)(v334);
uint32_t v335=(uint32_t)w->laneRemainder;
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
w->placedLateral=(int32_t)(v338);
uint32_t v339=(uint32_t)w->slot;
uint32_t v340=2u;
if(!v340)FAIL(4);
uint32_t v341=v339/v340,v342=v339%v340;
w->laneQuotient=(uint16_t)(v341);
w->laneRemainder=(uint16_t)(v342);
uint32_t v343=(uint32_t)w->laneRemainder;
uint32_t v344=(v343==0u)?1u:0u;
if(v344){
uint32_t v345=(uint32_t)w->placedLateral;
uint32_t v346=(uint32_t)w->routeLateral;
int64_t nv347=(int64_t)signed32(v345)+(int64_t)signed32(v346);
if(nv347 < -2147483648ll || nv347 >2147483647ll)FAIL(1);
uint32_t v347=(uint32_t)nv347;
int64_t nv348=(int64_t)signed32(v347)-(int64_t)signed32(5044u);
if(nv348 < -2147483648ll || nv348 >2147483647ll)FAIL(2);
uint32_t v348=(uint32_t)nv348;
if((int64_t)(signed32(v348))<-14260ll)FAIL(32);
if((int64_t)(signed32(v348))>14260ll)FAIL(32);
w->placedLateral=(int32_t)(v348);
}else{
uint32_t v349=(uint32_t)w->placedLateral;
uint32_t v350=(uint32_t)w->routeLateral;
int64_t nv351=(int64_t)signed32(v349)-(int64_t)signed32(v350);
if(nv351 < -2147483648ll || nv351 >2147483647ll)FAIL(2);
uint32_t v351=(uint32_t)nv351;
int64_t nv352=(int64_t)signed32(v351)+(int64_t)signed32(5044u);
if(nv352 < -2147483648ll || nv352 >2147483647ll)FAIL(1);
uint32_t v352=(uint32_t)nv352;
if((int64_t)(signed32(v352))<-14260ll)FAIL(32);
if((int64_t)(signed32(v352))>14260ll)FAIL(32);
w->placedLateral=(int32_t)(v352);
}
uint32_t v353=(uint32_t)w->slot;
int32_t index354=(int32_t)(v353);
if(index354<0||index354>5)FAIL(5);
uint32_t v356=(uint32_t)w->placedLateral;
w->opponents[index354].lateral=(int32_t)(v356);
uint32_t v357=(uint32_t)w->slot;
int32_t index358=(int32_t)(v357);
if(index358<0||index358>5)FAIL(5);
uint32_t v359;v359=(uint32_t)(w->opponents[index358].position);
w->opponentStation=(uint32_t)(v359);
uint32_t v360=(uint32_t)w->slot;
int32_t index361=(int32_t)(v360);
if(index361<0||index361>5)FAIL(5);
uint32_t v362;v362=(uint32_t)(w->opponents[index361].lateral);
if((int64_t)(signed32(v362))<-14260ll)FAIL(32);
if((int64_t)(signed32(v362))>14260ll)FAIL(32);
w->opponentLateral=(int32_t)(v362);
uint32_t v363=(uint32_t)w->lapInput;
if((int64_t)(signed32(v363))<1ll)FAIL(32);
if((int64_t)(signed32(v363))>3276800ll)FAIL(32);
w->lap=(int32_t)(v363);
uint32_t v364=(uint32_t)w->opponentStation;
int64_t nv365=(int64_t)(v364);
if(nv365<-2147483648ll||nv365>2147483647ll)FAIL(32);
uint32_t v365=(uint32_t)nv365;
uint32_t v366=(uint32_t)w->playerStation;
int64_t nv367=(int64_t)(v366);
if(nv367<-2147483648ll||nv367>2147483647ll)FAIL(32);
uint32_t v367=(uint32_t)nv367;
int64_t nv368=(int64_t)signed32(v365)-(int64_t)signed32(v367);
if(nv368 < -2147483648ll || nv368 >2147483647ll)FAIL(2);
uint32_t v368=(uint32_t)nv368;
w->work=(int32_t)(v368);
uint32_t v369=(uint32_t)w->work;
uint32_t v370=(uint32_t)w->lap;
uint32_t v371=v370;
if(!v371)FAIL(4);
if(v369==2147483648u && v371==4294967295u)FAIL(6);
uint32_t v372=(uint32_t)(signed32(v369)/signed32(v371)),v373=(uint32_t)(signed32(v369)%signed32(v371));
w->quotient=(int32_t)(v372);
w->remainder=(int32_t)(v373);
uint32_t v374=(uint32_t)w->remainder;
w->separation=(int32_t)(v374);
uint32_t v375=(uint32_t)w->separation;
uint32_t v376=(signed32(v375)<signed32(0u))?1u:0u;
if(v376){
uint32_t v377=(uint32_t)w->separation;
uint32_t v378=(uint32_t)w->lap;
int64_t nv379=(int64_t)signed32(v377)+(int64_t)signed32(v378);
if(nv379 < -2147483648ll || nv379 >2147483647ll)FAIL(1);
uint32_t v379=(uint32_t)nv379;
w->separation=(int32_t)(v379);
}else{
}
uint32_t v380=(uint32_t)w->lap;
uint32_t v381=2u;
if(!v381)FAIL(4);
if(v380==2147483648u && v381==4294967295u)FAIL(6);
uint32_t v382=(uint32_t)(signed32(v380)/signed32(v381)),v383=(uint32_t)(signed32(v380)%signed32(v381));
w->halfLap=(int32_t)(v382);
w->remainder=(int32_t)(v383);
uint32_t v384=(uint32_t)w->separation;
uint32_t v385=(uint32_t)w->halfLap;
uint32_t v386=(signed32(v384)>signed32(v385))?1u:0u;
if(v386){
uint32_t v387=(uint32_t)w->separation;
uint32_t v388=(uint32_t)w->lap;
int64_t nv389=(int64_t)signed32(v387)-(int64_t)signed32(v388);
if(nv389 < -2147483648ll || nv389 >2147483647ll)FAIL(2);
uint32_t v389=(uint32_t)nv389;
w->separation=(int32_t)(v389);
}else{
}
uint32_t v390=(uint32_t)w->separation;
w->work=(int32_t)(v390);
uint32_t v391=(uint32_t)w->work;
uint32_t v392=(signed32(v391)<signed32(0u))?1u:0u;
if(v392){
uint32_t v393=(uint32_t)w->work;
int64_t nv394=(int64_t)signed32(0u)-(int64_t)signed32(v393);
if(nv394 < -2147483648ll || nv394 >2147483647ll)FAIL(2);
uint32_t v394=(uint32_t)nv394;
w->work=(int32_t)(v394);
}else{
}
uint32_t v395=(uint32_t)w->opponentLateral;
uint32_t v396=(uint32_t)w->playerLateral;
int64_t nv397=(int64_t)signed32(v395)-(int64_t)signed32(v396);
if(nv397 < -2147483648ll || nv397 >2147483647ll)FAIL(2);
uint32_t v397=(uint32_t)nv397;
w->lateralSeparation=(int32_t)(v397);
uint32_t v398=(uint32_t)w->lateralSeparation;
uint32_t v399=(signed32(v398)<signed32(0u))?1u:0u;
if(v399){
uint32_t v400=(uint32_t)w->lateralSeparation;
int64_t nv401=(int64_t)signed32(0u)-(int64_t)signed32(v400);
if(nv401 < -2147483648ll || nv401 >2147483647ll)FAIL(2);
uint32_t v401=(uint32_t)nv401;
w->lateralSeparation=(int32_t)(v401);
}else{
}
uint32_t v402=(uint32_t)w->work;
uint32_t v403=(signed32(v402)<signed32(3200u))?1u:0u;
uint32_t v404=v403;
if(v404){
uint32_t v405=(uint32_t)w->lateralSeparation;
uint32_t v406=(signed32(v405)<signed32(6144u))?1u:0u;
v404=v406;
}
if(v404>1u)FAIL(32);
w->contactResult=(uint16_t)(v404);
uint32_t v407=(uint32_t)w->contactResult;
if(v407){
uint32_t v408=(uint32_t)w->slot;
int32_t index409=(int32_t)(v408);
if(index409<0||index409>5)FAIL(5);
w->opponents[index409].contacts=(uint16_t)(1u);
if(1u>1u)FAIL(32);
w->contactAny=(uint16_t)(1u);
}else{
}
}else{
}
}
uint32_t v411=(uint32_t)w->worldTick;
uint64_t nv412=(uint64_t)(v411)+(uint64_t)(1u);
if(nv412>4294967295ull)FAIL(1);
uint32_t v412=(uint32_t)nv412;
w->worldTick=(uint32_t)(v412);
return 0;
}

static int32_t native_13(NativeWorld*w){
w->routeRecord=(uint16_t)(0u);
w->routeRemaining=(uint16_t)(60u);
w->routeIndex=(uint16_t)(0u);
w->routeHeading=(int32_t)(0u);
w->routeLateral=(int32_t)(0u);
w->routeForward=(uint32_t)(0u);
w->forwardAdvance=(uint32_t)(0u);
w->worldTick=(uint32_t)(0u);
w->playerStation=(uint32_t)(3246800u);
w->playerUnwrapped=(uint32_t)(3246800u);
if((int64_t)(signed32(0u))<-38400ll)FAIL(32);
if((int64_t)(signed32(0u))>38400ll)FAIL(32);
w->playerLateral=(int32_t)(0u);
w->renderSession=(uint32_t)(7u);
w->renderRequest=(uint32_t)(0u);
if(6800u>7999u)FAIL(32);
w->renderPhase=(uint16_t)(6800u);
if(signed16(0u)<-21)FAIL(32);
if(signed16(0u)>21)FAIL(32);
w->renderSteering=(int16_t)(0u);
if(3u>7u)FAIL(32);
w->renderFlags=(uint16_t)(3u);
if(0u>1u)FAIL(32);
w->contactAny=(uint16_t)(0u);
int32_t index464=(int32_t)(0u);
if(index464<0||index464>5)FAIL(5);
w->opponents[index464].active=(uint16_t)(1u);
int32_t index466=(int32_t)(0u);
if(index466<0||index466>5)FAIL(5);
w->opponents[index466].progress=(int32_t)(3246800u);
int32_t index468=(int32_t)(0u);
if(index468<0||index468>5)FAIL(5);
w->opponents[index468].position=(uint32_t)(3246800u);
int32_t index470=(int32_t)(0u);
if(index470<0||index470>5)FAIL(5);
w->opponents[index470].lateral=(int32_t)(0u);
int32_t index472=(int32_t)(0u);
if(index472<0||index472>5)FAIL(5);
w->opponents[index472].contacts=(uint16_t)(0u);
int32_t index474=(int32_t)(1u);
if(index474<0||index474>5)FAIL(5);
w->opponents[index474].active=(uint16_t)(1u);
int32_t index476=(int32_t)(1u);
if(index476<0||index476>5)FAIL(5);
w->opponents[index476].progress=(int32_t)(3249999u);
int32_t index478=(int32_t)(1u);
if(index478<0||index478>5)FAIL(5);
w->opponents[index478].position=(uint32_t)(3249999u);
int32_t index480=(int32_t)(1u);
if(index480<0||index480>5)FAIL(5);
w->opponents[index480].lateral=(int32_t)(0u);
int32_t index482=(int32_t)(1u);
if(index482<0||index482>5)FAIL(5);
w->opponents[index482].contacts=(uint16_t)(0u);
int32_t index484=(int32_t)(2u);
if(index484<0||index484>5)FAIL(5);
w->opponents[index484].active=(uint16_t)(1u);
int32_t index486=(int32_t)(2u);
if(index486<0||index486>5)FAIL(5);
w->opponents[index486].progress=(int32_t)(3250000u);
int32_t index488=(int32_t)(2u);
if(index488<0||index488>5)FAIL(5);
w->opponents[index488].position=(uint32_t)(3250000u);
int32_t index490=(int32_t)(2u);
if(index490<0||index490>5)FAIL(5);
w->opponents[index490].lateral=(int32_t)(0u);
int32_t index492=(int32_t)(2u);
if(index492<0||index492>5)FAIL(5);
w->opponents[index492].contacts=(uint16_t)(0u);
int32_t index494=(int32_t)(3u);
if(index494<0||index494>5)FAIL(5);
w->opponents[index494].active=(uint16_t)(1u);
int32_t index496=(int32_t)(3u);
if(index496<0||index496>5)FAIL(5);
w->opponents[index496].progress=(int32_t)(3253200u);
int32_t index498=(int32_t)(3u);
if(index498<0||index498>5)FAIL(5);
w->opponents[index498].position=(uint32_t)(3253200u);
int32_t index500=(int32_t)(3u);
if(index500<0||index500>5)FAIL(5);
w->opponents[index500].lateral=(int32_t)(0u);
int32_t index502=(int32_t)(3u);
if(index502<0||index502>5)FAIL(5);
w->opponents[index502].contacts=(uint16_t)(0u);
int32_t index504=(int32_t)(4u);
if(index504<0||index504>5)FAIL(5);
w->opponents[index504].active=(uint16_t)(1u);
int32_t index506=(int32_t)(4u);
if(index506<0||index506>5)FAIL(5);
w->opponents[index506].progress=(int32_t)(3264800u);
int32_t index508=(int32_t)(4u);
if(index508<0||index508>5)FAIL(5);
w->opponents[index508].position=(uint32_t)(3264800u);
int32_t index510=(int32_t)(4u);
if(index510<0||index510>5)FAIL(5);
w->opponents[index510].lateral=(int32_t)(0u);
int32_t index512=(int32_t)(4u);
if(index512<0||index512>5)FAIL(5);
w->opponents[index512].contacts=(uint16_t)(0u);
int32_t index514=(int32_t)(5u);
if(index514<0||index514>5)FAIL(5);
w->opponents[index514].active=(uint16_t)(1u);
int32_t index516=(int32_t)(5u);
if(index516<0||index516>5)FAIL(5);
w->opponents[index516].progress=(int32_t)(3326800u);
int32_t index518=(int32_t)(5u);
if(index518<0||index518>5)FAIL(5);
w->opponents[index518].position=(uint32_t)(50000u);
int32_t index520=(int32_t)(5u);
if(index520<0||index520>5)FAIL(5);
w->opponents[index520].lateral=(int32_t)(0u);
int32_t index522=(int32_t)(5u);
if(index522<0||index522>5)FAIL(5);
w->opponents[index522].contacts=(uint16_t)(0u);
return 0;
}

static int32_t native_15(NativeWorld*w){
uint32_t v584=(uint32_t)w->renderRequest;
uint64_t nv585=(uint64_t)(v584)+(uint64_t)(1u);
if(nv585>4294967295ull)FAIL(1);
uint32_t v585=(uint32_t)nv585;
w->renderRequest=(uint32_t)(v585);
return 0;
}

static int32_t native_16(NativeWorld*w){
if(0u>7u)FAIL(32);
w->renderFlags=(uint16_t)(0u);
return 0;
}
#undef FAIL
static RallyRenderContextV1 renderer={.struct_bytes=sizeof(renderer)};
static RallyRenderBindingsV1 render_binding={76,1,0,{50300,1,0u,149518u},{{50301,2,0u,20480u},{50302,2,0u,2048u},{50303,2,0u,256u}},2101713653u,3635234752u,{0,5,120,63970,63984,63930}};
static int32_t renderer_hook(const vdplet_host_v1*h,unsigned entry,uint8_t*state,const NativeWorld*w){
unsigned op=0;switch(entry){
case 13:op=1;break;
case 15:op=2;break;
case 14:op=1;break;
case 16:op=3;break;
default:return 0;}
RallyRenderCompletionV1 done={.struct_bytes=48,.schema=1};
RallyRenderStateV1 s={.struct_bytes=108,.schema=1};
s.session=(uint32_t)w->renderSession;
s.request_generation=(uint32_t)w->renderRequest;
s.simulation_tick=(uint32_t)w->worldTick;
s.player_station=(uint32_t)w->playerStation;
s.player_lateral_q8=signed32((uint32_t)w->playerLateral);
s.phase=(uint32_t)w->renderPhase;
s.steering=signed16((uint32_t)w->renderSteering);
s.flags=(uint32_t)w->renderFlags;
if(!s.session||s.session!=get32(state+8)||(uint32_t)w->playerStation>2147483647u)return VDPL_E_ARGUMENT;
int32_t rc=0;
if(op==1){render_binding.session=s.session;rc=rally_render_bind_v1(h,&renderer,&render_binding,&done);}
else if(op==3)rc=rally_render_stop_v1(&renderer,&done);
else {int32_t heading=signed32((uint32_t)w->routeHeading);if(heading< -1920||heading>1920)return VDPL_E_ARGUMENT;
for(unsigned i=0;i<6;++i)s.opponents[i].station=w->opponents[i].position;
for(unsigned i=0;i<6;++i)s.opponents[i].lateral_q8=w->opponents[i].lateral;
for(unsigned i=0;i<6;++i)s.opponents[i].active=w->opponents[i].active;
for(unsigned i=0;i<6;++i){if(s.opponents[i].active)s.opponents[i].heading_turn16=(int16_t)heading;else s.opponents[i]=(RallyRenderOpponentV1){0,0,0,0};}rc=rally_render_prepare_v1(h,&renderer,&s,&done);}
if(done.reason==RALLY_RENDER_REASON_RELEASE)return rc;
vdplet_view_v1 out={sizeof(out),0,0,0,0};int32_t pr=h->buffer_acquire(h->context,50304,VDPL_WRITE,0,48,&out);if(pr)return pr;memcpy(out.data,&done,48);pr=h->buffer_release(h->context,out.lease);return pr?pr:rc;}
#include "publication.inc"
/* Legacy diagnostics are boundary exports, never live numerical storage. */
static int32_t export_arrays(const vdplet_host_v1*h,const NativeWorld*w){
{vdplet_view_v1 v={sizeof(v),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,2,VDPL_WRITE,0,12,&v);if(rc)return rc;
for(unsigned i=0;i<6;++i)put(v.data+i*2,(uint32_t)w->opponents[i].active);
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
{vdplet_view_v1 v={sizeof(v),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,3,VDPL_WRITE,0,24,&v);if(rc)return rc;
for(unsigned i=0;i<6;++i)put32(v.data+i*4,(uint32_t)w->opponents[i].progress);
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
{vdplet_view_v1 v={sizeof(v),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,4,VDPL_WRITE,0,24,&v);if(rc)return rc;
for(unsigned i=0;i<6;++i)put32(v.data+i*4,(uint32_t)w->opponents[i].position);
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
{vdplet_view_v1 v={sizeof(v),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,5,VDPL_WRITE,0,24,&v);if(rc)return rc;
for(unsigned i=0;i<6;++i)put32(v.data+i*4,(uint32_t)w->opponents[i].lateral);
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
{vdplet_view_v1 v={sizeof(v),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,6,VDPL_WRITE,0,12,&v);if(rc)return rc;
for(unsigned i=0;i<6;++i)put(v.data+i*2,(uint32_t)w->opponents[i].contacts);
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
return 0;
}
static int32_t import_overrides(const vdplet_host_v1*h,NativeWorld*w){
{vdplet_view_v1 v={sizeof(v),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,4,VDPL_READ,0,24,&v);if(rc)return rc;
for(unsigned i=0;i<6;++i)w->opponents[i].position=(uint32_t)get32(v.data+i*4);
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
{vdplet_view_v1 v={sizeof(v),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,5,VDPL_READ,0,24,&v);if(rc)return rc;
for(unsigned i=0;i<6;++i)w->opponents[i].lateral=(int32_t)get32(v.data+i*4);
rc=h->buffer_release(h->context,v.lease);if(rc)return rc;}
return 0;
}
#undef ROOT_FAIL
#define ROOT_FAIL(n,code) do {put(state+12,(n));rc=(code);goto done;}while(0)
__attribute__((visibility("default")))
int32_t vdplet_entry(const vdplet_host_v1*h,const vdplet_request_v1*r){
if(!h||!r||h->struct_bytes<sizeof(*h)||r->struct_bytes<sizeof(*r)||h->abi_major!=1||!(h->capabilities&VDPL_CAP_BUFFERS)||!h->buffer_acquire||!h->buffer_release)return VDPL_E_ABI;
if(r->operation==VDPL_INIT){initialized=poisoned=0;owner_session=0;renderer.bound=0;return identity==0x474c3332u?0:VDPL_E_INIT;}
if(r->operation==VDPL_FINI){initialized=poisoned=0;owner_session=0;renderer.bound=0;return 0;}
if(r->operation!=VDPL_RUN || (r->entry_id!=3 && r->entry_id!=13 && r->entry_id!=15 && r->entry_id!=16 && r->entry_id!=17))return VDPL_E_UNSUPPORTED;
if(r->argument_bytes!=2)return VDPL_E_ARGUMENT;
vdplet_view_v1 args={sizeof(args),0,0,0,0},view={sizeof(view),0,0,0,0};
int32_t rc=h->buffer_acquire(h->context,r->argument_buffer,VDPL_READ,0,2,&args);if(rc)return rc;
uint16_t id=get(args.data);rc=h->buffer_release(h->context,args.lease);if(rc)return rc;
rc=h->buffer_acquire(h->context,id,VDPL_WRITE,0,VDPL_WHOLE_BUFFER,&view);if(rc)return rc;
if(view.bytes!=310){h->buffer_release(h->context,view.lease);return VDPL_E_BOUNDS;}
uint8_t*state=view.data;put(state+12,0);
unsigned entry=r->entry_id==17?3:r->entry_id;
if(r->entry_id!=17 && get(state+28)!=entry)ROOT_FAIL(7,VDPL_E_ARGUMENT);
static const uint8_t offsets[] __attribute__((aligned(4)))={0,1,2,3,4,5,6,7,26,27,30,31,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,91,92,93,94,95,96,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,};
static const uint8_t values[] __attribute__((aligned(4)))={82,71,1,0,112,0,54,1,4,0,0,0,17,0,198,0,0,0,0,0,48,53,50,82,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,};
static const uint8_t errors[] __attribute__((aligned(4)))={1,1,2,2,3,3,3,3,3,3,6,6,3,3,3,3,6,6,6,6,6,6,6,6,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,5,};
for(unsigned i=0;i<sizeof(offsets);++i)if(state[offsets[i]]!=values[i])ROOT_FAIL(errors[i],VDPL_E_ARGUMENT);
if(!get32(state+8))ROOT_FAIL(4,VDPL_E_ARGUMENT);


if(entry!=13 && (!initialized || owner_session!=get32(state+8)))ROOT_FAIL(4,VDPL_E_INIT);
if(poisoned && entry!=13 && entry!=16)ROOT_FAIL(4,VDPL_E_INIT);
if(entry==13){import_globals(&world,state);owner_session=get32(state+8);initialized=1;poisoned=0;}
world.failure=0;put(state+14,0);
unsigned count=r->entry_id==17?4:1;
for(unsigned i=0;i<count;++i){
 put(state+28,entry);
 rc=native_validate(&world);
 if(!rc){switch(entry){case 3:rc=native_3(&world);break;case 13:rc=native_13(&world);break;case 15:rc=import_overrides(h,&world);if(!rc)rc=native_15(&world);break;case 16:rc=native_16(&world);break;}}
 if(rc){poisoned=1;break;}
 if(entry==3){put32(state+20,get32(state+20)+1u);put(state+24,3);put32(state+32,get32(state+8));}
}
export_globals(state,&world);put(state+14,world.failure);
if(entry==3 || entry==13){int32_t exported=export_arrays(h,&world);if(!rc)rc=exported;}
if(rc)goto done;
if(entry!=3){
 uint32_t next_generation=get32(state+20)+1u,next_request=world.renderRequest;
 rc=renderer_hook(h,entry,state,&world);if(rc)goto done;
 put32(state+20,next_generation);put(state+24,entry);put32(state+32,get32(state+8));
 if(entry==15)rc=r28_check_publication(h,state,next_generation,next_request);
}
done:{int32_t rr=h->buffer_release(h->context,view.lease);return rr?rr:rc;}
}
