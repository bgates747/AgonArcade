
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <assert.h>
#include <map>
#include <string>
#include <vector>
#include "protocol.hpp"
volatile uint8_t fs_reply[10]={0},fs_ready=0;
enum Fault {None,WrongKind,WrongToken,WrongMagic,WrongVersion,WrongStatus,NoReply};
std::map<unsigned,std::vector<uint8_t>> buffers;
std::vector<unsigned> clears;
std::vector<std::vector<uint8_t>> sent;
Fault fault=None;unsigned faultId=0;uint32_t clockValue=0;
namespace fs {
uint16_t token=0;uint32_t waitMs=0;bool pending=false,healthy=true;
const char *failure="none";
uint8_t transcript[240000];unsigned transcriptBytes=0;
uint32_t now(){return clockValue++;}uint32_t timer(){return clockValue++;}
uint32_t difference(uint32_t a,uint32_t b){return (a-b)&0xffffff;}
void fail(const char *s){if(healthy)failure=s;healthy=false;}
void put16(uint8_t *p,uint16_t v){p[0]=v;p[1]=v>>8;}
void put32(uint8_t *p,uint32_t v){for(unsigned i=0;i<4;++i)p[i]=v>>(8*i);}
unsigned u16(const uint8_t *p){return unsigned(p[0])|(unsigned(p[1])<<8);}
void send(const uint8_t *p,unsigned n){
    sent.emplace_back(p,p+n);assert(n>=13&&p[0]==23&&p[2]==216&&p[5]==1);
    unsigned op=p[6],request=u16(p+7),id=u16(p+11),kind=3,value=0;
    if(op==5){
        assert(n==17);uint32_t off=0;for(unsigned i=0;i<4;++i)off|=uint32_t(p[13+i])<<(8*i);
        auto it=buffers.find(id);
        if(it==buffers.end()){kind=5;value=2;}
        else if(off>it->second.size()||it->second.size()-off<2){kind=5;value=3;}
        else {kind=4;value=u16(it->second.data()+off);}
    }
    uint8_t reply[]={'V','D','P','L',1,uint8_t(kind),uint8_t(request),uint8_t(request>>8),uint8_t(value),uint8_t(value>>8)};
    if(!faultId||faultId==id){
        switch(fault){
        case None:break;
        case WrongKind:reply[5]=reply[5]==3?5:3;break;
        case WrongToken:reply[6]^=1;break;
        case WrongMagic:reply[0]='X';break;
        case WrongVersion:reply[4]=2;break;
        case WrongStatus:reply[8]=6;break;
        case NoReply:return;
        }
    }
    for(unsigned i=0;i<10;++i)fs_reply[i]=reply[i];fs_ready=1;
}
uint16_t transaction(uint8_t op,const uint8_t *fields,unsigned count,uint8_t kind){
    if(pending||!healthy)return 0;
    uint8_t b[32]={23,0,216,0,0,1,op,0,0,1,0};put16(b+3,6+count);put16(b+7,++token);memcpy(b+11,fields,count);
    fs_ready=0;pending=true;send(b,11+count);uint32_t start=now(),begin=timer();
    while(!fs_ready){if(now()-start>=600){fail("VDPL callback timeout");return 0;}}
    waitMs+=difference(timer(),begin);pending=false;
    if(fs_reply[0]!='V'||fs_reply[1]!='D'||fs_reply[2]!='P'||fs_reply[3]!='L'||fs_reply[4]!=1||fs_reply[5]!=kind||uint16_t(fs_reply[6]|uint16_t(fs_reply[7])<<8)!=token){fail("VDPL reply identity");return 0;}
    if(transcriptBytes+10>sizeof transcript){fail("Transcript capacity");return 0;}
    for(unsigned i=0;i<10;++i)transcript[transcriptBytes++]=fs_reply[i];
    return uint16_t(fs_reply[8]|uint16_t(fs_reply[9])<<8);
}
uint16_t read16(uint16_t id,uint32_t off){uint8_t p[6];put16(p,id);put32(p+2,off);return transaction(5,p,6,4);}
void command(unsigned id,unsigned op){assert(op==2);clears.push_back(id);buffers.erase(id);}
void fence(){if(!healthy||pending)return;}
}
namespace capacity {
constexpr unsigned Index=51999,Matrix=51998,Telemetry=51997,First=52000,Count=901;
unsigned cleanupAbsent=0,activeId=0,failureKind=0,failureCode=0,attempted=0;
uint32_t startPrt=0,startMos=0,endMos=0,endPrt=0;
bool indexInstalled=false,matrixInstalled=false,telemetryInstalled=false,cleaned=false;
struct Memory {uint32_t internal,largest,psram;uint16_t buffers;};
Memory retained{},afterCleanup{};
unsigned memoryCalls=0;
Memory memory(const char *,unsigned){++memoryCalls;return {61100,29684,3442911,uint16_t(buffers.size())};}
uint16_t errorRead(unsigned id,unsigned offset,unsigned expected){
    uint8_t p[6];fs::put16(p,id);fs::put32(p+2,offset);unsigned status=fs::transaction(VDPL_READ16,p,6,VDPL_REPLY_ERROR);
    if(status!=expected)fs::fail("Capacity expected READ16 status");return status;
}
bool length(unsigned id,unsigned bytes){
    (void)fs::read16(id,bytes-2);if(!fs::healthy)return false;
    errorRead(id,bytes-1,3);return fs::healthy;
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
}
std::vector<std::string> names;
void reset(){
    fs::pending=false;fs::healthy=true;fs::failure="none";fs::token=0;fs::transcriptBytes=0;fs::waitMs=0;
    fs_ready=0;fault=None;faultId=0;clockValue=0;buffers.clear();clears.clear();sent.clear();
    capacity::cleanupAbsent=0;capacity::cleaned=false;capacity::endMos=0;
    capacity::indexInstalled=capacity::matrixInstalled=capacity::telemetryInstalled=false;capacity::memoryCalls=0;
}
void pass(const char *name){names.emplace_back(name);}
void installed(){
    buffers[1]=std::vector<uint8_t>(310,0);buffers[77]=std::vector<uint8_t>(8,0x66);
    buffers[51999]=std::vector<uint8_t>(10628,0x45);buffers[51998]=std::vector<uint8_t>(36,0);
    buffers[51997]=std::vector<uint8_t>(12,0);
    for(unsigned id=52000;id<52007;++id)buffers[id]=std::vector<uint8_t>(6,0);
    capacity::indexInstalled=capacity::matrixInstalled=capacity::telemetryInstalled=true;
}
int main(){
    static_assert(VDPL_REPLY_ERROR==5&&VDPL_E_BOUNDS==3&&VDPL_E_BUFFER==2,"Frozen protocol changed");
    reset();buffers[51999]=std::vector<uint8_t>(10628,0x45);
    assert(fs::read16(51999,10626)==0x4545&&fs::healthy&&fs::transcriptBytes==10);pass("legal-final-word-value");
    assert(capacity::errorRead(51999,10627,3)==3&&fs::healthy&&fs::transcriptBytes==20);pass("bounds-error-kind5-code3");
    assert(capacity::errorRead(52000,0,2)==2&&fs::healthy&&fs::transcriptBytes==30);pass("missing-error-kind5-code2");
    assert(capacity::length(51999,10628)&&sent.size()==5);pass("complete-length-positive-and-negative");
    reset();assert(!capacity::length(51999,10628)&&!fs::healthy&&sent.size()==1);pass("missing-buffer-rejects-length");
    reset();buffers[51999]=std::vector<uint8_t>(10630,0x45);assert(!capacity::length(51999,10628)&&!fs::healthy);pass("oversize-buffer-rejects-length");
    for(Fault f:{WrongKind,WrongToken,WrongMagic,WrongVersion}){
        reset();fault=f;capacity::errorRead(52000,0,2);
        assert(!fs::healthy&&!fs::pending&&fs::transcriptBytes==0);
        pass(f==WrongKind?"mismatched-kind-rejected":f==WrongToken?"mismatched-token-rejected":f==WrongMagic?"mismatched-magic-rejected":"mismatched-version-rejected");
    }
    reset();fault=WrongStatus;capacity::errorRead(52000,0,2);
    assert(!fs::healthy&&std::string(fs::failure)=="Capacity expected READ16 status"&&fs::transcriptBytes==10);pass("unexpected-error-status-rejected");
    reset();fault=NoReply;capacity::errorRead(52000,0,2);
    assert(!fs::healthy&&fs::pending&&std::string(fs::failure)=="VDPL callback timeout");pass("timeout-keeps-callback-pending");
    reset();fs::pending=true;capacity::errorRead(52000,0,2);assert(sent.empty()&&fs::pending&&!fs::healthy);pass("pending-reentry-rejected");
    reset();installed();capacity::cleanup();
    assert(fs::healthy&&capacity::cleaned&&capacity::cleanupAbsent==901&&capacity::memoryCalls==2);
    assert(clears.size()==904&&buffers.size()==2&&buffers.count(1)&&buffers.count(77));
    assert(clears.front()==52000&&clears[900]==52900&&clears[901]==51999&&clears[902]==51998&&clears[903]==51997);
    assert(sent.size()==903&&fs::transcriptBytes==9030);pass("successful-partial-resource-cleanup-901-absence-checks");
    reset();installed();fs::healthy=false;fs::failure="Original allocation failure";fs_reply[5]=5;fs_reply[8]=6;fs_reply[9]=0;capacity::cleanup();
    assert(!fs::healthy&&capacity::cleaned&&capacity::cleanupAbsent==901&&std::string(fs::failure)=="Original allocation failure");
    assert(capacity::failureKind==5&&capacity::failureCode==6&&buffers.size()==2);pass("failed-setup-cleans-and-preserves-cause");
    reset();installed();fault=WrongKind;faultId=52002;capacity::cleanup();
    assert(!fs::healthy&&!capacity::cleaned&&capacity::cleanupAbsent==2);pass("cleanup-unexpected-reply-not-success");
    reset();installed();fs::pending=true;capacity::cleanup();
    assert(clears.empty()&&sent.empty()&&!capacity::cleaned&&capacity::memoryCalls==0);pass("pending-callback-blocks-cleanup");
    printf("{\"passed\":true,\"tests\":%u,\"cases\":[",unsigned(names.size()));
    for(unsigned i=0;i<names.size();++i)printf("%s\"%s\"",i?",":"",names[i].c_str());printf("]}\n");
}
