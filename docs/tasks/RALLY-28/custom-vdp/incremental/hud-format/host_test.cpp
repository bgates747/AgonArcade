// Compare the actual extracted old/new presentation functions and emitted bytes.
#include "rules.hpp"
#include "records.hpp"
#include "hud.hpp"
#include "scenery.hpp"
#include "race_traffic.hpp"
#include <cassert>
#include <cstdarg>
#include <cstdio>
#include <cstring>
#include <vector>
static unsigned calls=0;
int counted_format(char *out,size_t bytes,const char *format,...) {
    ++calls;va_list args;va_start(args,format);
    const int result=vsnprintf(out,bytes,format,args);va_end(args);return result;
}
#define snprintf counted_format
#include "hud_format.hpp"
#define PRESENTATION_STATE \
using namespace rally::game; \
rally::Motion motion;Rules rules;Records records;Hud hud;HudFormat hudFormat; \
rally::SceneryHistory sceneryHistory;rally::Stream stream; \
const rally::TrackDef *selected=&rally::Fuji;unsigned steeringStep=2;uint32_t topScore=0; \
struct {unsigned bands=17;} road;struct {unsigned cars=6;} scene; \
std::vector<uint8_t> output; \
void flush(){assert(!stream.overflow);output.insert(output.end(),stream.data,stream.data+stream.size);stream.size=0;stream.overflow=false;} \
void text(int x,int y,const char *s,int ink=15,int paper=SkyColour){ \
    const uint8_t head[]={17,uint8_t(ink),17,uint8_t(128+paper),31,uint8_t(x),uint8_t(y)}; \
    output.insert(output.end(),head,head+sizeof head);output.insert(output.end(),s,s+strlen(s));}
namespace reference {
PRESENTATION_STATE
#include "reference.inc"
}
namespace candidate {
PRESENTATION_STATE
#include "candidate.inc"
}
#undef snprintf
static unsigned frames=0,referenceCalls=0,candidateCalls=0;
static void compare(unsigned page,bool invalidate=false) {
    candidate::motion=reference::motion;candidate::rules=reference::rules;
    candidate::records=reference::records;candidate::selected=reference::selected;
    candidate::steeringStep=reference::steeringStep;
    reference::sceneryHistory.slot=candidate::sceneryHistory.slot=page;
    if(invalidate){reference::hud.invalidate();candidate::hud.invalidate();}
    reference::output.clear();candidate::output.clear();
    calls=0;reference::drawHud(4);reference::bottom();referenceCalls+=calls;
    calls=0;candidate::drawHud(4);candidate::bottom();candidateCalls+=calls;
    assert(reference::output==candidate::output);
    for(unsigned p=0;p<2;++p) {
        assert(reference::hud.valid[p]==candidate::hud.valid[p]);
        assert(!memcmp(reference::hud.previous[p].text,candidate::hud.previous[p].text,120));
        assert(!memcmp(reference::hud.previous[p].colour,candidate::hud.previous[p].colour,120));
    }
    assert(reference::topScore==candidate::topScore);++frames;
}
static uint32_t randomValue=0x528001;
static uint32_t random(){randomValue^=randomValue<<13;randomValue^=randomValue>>17;randomValue^=randomValue<<5;return randomValue;}
int main(int argc,char **argv) {
    assert(argc==2);
    // Repeated values, transitions, records, policies, pages and invalidation.
    for(unsigned n=0;n<12000;++n) {
        if(n%3==0){
            reference::rules.phase=rally::game::Phase(random()%10);
            reference::rules.policy=rally::game::Policy(random()%2);
            reference::rules.remaining=random()%15000;
            reference::rules.elapsed=random()%216001;
            reference::rules.lapBegin=reference::rules.elapsed/3;
            reference::rules.lapTime=random()%216001;
            reference::rules.score=random()%10000000;
            reference::rules.rank=uint8_t(1+random()%7);
            reference::rules.laps=uint8_t(random()%7);
            reference::rules.settings.laps=uint8_t(1+random()%6);
            reference::rules.extensionNotice=uint16_t(random()%3);
            reference::motion.speed=int32_t(random()%601)-300;
            reference::motion.grip=25+int(random()%36)*5;
            reference::rules.maxGrip=25+int(random()%36)*5;
            reference::selected=random()%2?&rally::Fuji:&rally::TriOval;
            reference::steeringStep=1+random()%2;
            for(auto &r:reference::records.entries)r.score=random()%10000000;
        }
        compare(n&1,n%71==0);
    }
    // Key edges, including old zero/invalid initialization and full u32 clock
    // arithmetic. Same source-width overflow behavior, not a new clock format.
    const uint32_t edges[]={0,1,119,120,121,7199,7200,216000,9999999,0xffffffffu};
    for(auto v:edges){reference::rules.remaining=v;reference::rules.elapsed=v;reference::rules.lapBegin=0;
        reference::rules.lapTime=v;reference::rules.score=v;reference::motion.speed=int32_t(v);
        compare(0,true);compare(1);compare(0);}
    // Original 900-frame Fuji workload, two warm pages, actual rank changes.
    FILE *file=fopen(argv[1],"rb");assert(file);uint8_t motion[21600];
    assert(fread(motion,1,sizeof motion,file)==sizeof motion);assert(fgetc(file)==EOF);fclose(file);
    reference::records={};reference::rules={};reference::motion={};
    reference::selected=&rally::Fuji;reference::steeringStep=2;
    reference::rules.settings=rally::game::FujiRules;reference::rules.policy=rally::game::Policy::Circuit;
    reference::rules.lapLength=3276800;reference::rules.maxGrip=200;
    reference::rules.raceReady();reference::rules.enter(rally::game::Phase::Race);
    reference::motion.track=&rally::Fuji;reference::motion.grip=200;
    reference::motion.position=3246800;reference::motion.phase=6800;
    reference::hud={};candidate::hud={};candidate::hudFormat={};
    compare(0);compare(1);referenceCalls=candidateCalls=0;
    rally::game::RouteCursor pace;
    for(unsigned n=0;n<900;++n){
        for(unsigned step=0;step<4;++step){unsigned advance=pace.tick();reference::motion.speed=advance/2;
            reference::motion.position=(reference::motion.position+advance)%3276800;
            reference::motion.phase=(reference::motion.phase+advance)%8000;reference::rules.tick(advance);}
        unsigned ahead=0;
        for(unsigned i=0;i<6;++i){const uint8_t *p=motion+n*24+i*4;
            uint32_t v=uint32_t(p[0])|uint32_t(p[1])<<8|uint32_t(p[2])<<16|uint32_t(p[3])<<24;
            int32_t gap=int32_t(v)-reference::motion.position;
            if(gap>1638400)gap-=3276800;else if(gap<-1638400)gap+=3276800;if(gap>0)++ahead;}
        reference::rules.rank=uint8_t(1+ahead);compare(n&1);
    }
    assert(candidateCalls<referenceCalls);
    printf("{\"passed\":true,\"comparisons\":%u,\"race_frames\":900,\"race_reference_format_calls\":%u,\"race_cached_format_calls\":%u,\"exact_emitted_bytes_and_both_page_cells\":true}\n",frames,referenceCalls,candidateCalls);
}
