"""Compile actual guest transaction/error/length/cleanup functions with fake I/O.

This tests the reply and partial-cleanup branches without an emulator. It does
not model Bitmap registration, allocation capacity or page readback.
"""
from pathlib import Path
import hashlib
import json
import os
import subprocess

HERE=Path(__file__).resolve().parent
CUSTOM=HERE.parents[1]
CONTROL=CUSTOM/'incremental/round-trips'
sha=lambda p:hashlib.sha256(Path(p).read_bytes()).hexdigest()


def function(text,name):
    start=text.index(name)
    start=text.rfind('\n',0,start)+1
    brace=text.index('{',start);end=brace+1;depth=1
    while depth:
        if text[end]=='{':depth+=1
        elif text[end]=='}':depth-=1
        end+=1
    return text[start:end]


def run():
    work=HERE/'.work/branches';work.mkdir(parents=True,exist_ok=True)
    native=(CONTROL/'guest/include/native.hpp').read_text()
    actual=(HERE/'capacity.hpp').read_text()
    transaction=function(native,'uint16_t transaction(')
    funcs={n:function(actual,n) for n in ('uint16_t errorRead(','bool length(','void cleanup(')}
    prelude=r'''
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
'''
    native_tail=r'''
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
'''
    tests=r'''
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
'''
    code=prelude+transaction+native_tail+'\n'.join(funcs.values())+tests
    (work/'branches.cpp').write_text(code)
    result={}
    for mode,flags in [('ordinary',[]),('asan-ubsan',['-fsanitize=address,undefined','-fno-omit-frame-pointer','-fno-sanitize-recover=all'])]:
        binary=work/mode
        build=subprocess.run(['c++','-std=c++17','-O1','-g','-Wall','-Wextra','-Werror',
            '-Wno-misleading-indentation',*flags,'-I'+str(HERE),str(work/'branches.cpp'),'-o',str(binary)],
            text=True,stdout=subprocess.PIPE,stderr=subprocess.STDOUT)
        (HERE/('BRANCH-BUILD-'+mode+'.txt')).write_text(build.stdout);assert build.returncode==0,build.stdout
        # This executor uses ptrace, which LeakSanitizer explicitly rejects.
        # Address/UB checks remain enabled; ownership is asserted by the tests.
        env=dict(os.environ,ASAN_OPTIONS='detect_leaks=0:halt_on_error=1',UBSAN_OPTIONS='halt_on_error=1')
        run=subprocess.run([str(binary)],env=env,text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE)
        (HERE/('BRANCH-RUN-'+mode+'.txt')).write_text(run.stdout+run.stderr)
        assert run.returncode==0,(mode,run.stdout,run.stderr)
        result[mode]=json.loads(run.stdout)
    assert result['ordinary']==result['asan-ubsan']
    output=dict(schema='rally.aff03.expected-error-branches.v1',passed=True,
        results=result,actual_transaction_sha256=hashlib.sha256(transaction.encode()).hexdigest(),
        actual_capacity_functions_sha256={n:hashlib.sha256(v.encode()).hexdigest() for n,v in funcs.items()},
        generated_host_source_sha256=sha(work/'branches.cpp'),test_producer_sha256=sha(Path(__file__)),
        fake_uart_and_buffer_store=True,leak_sanitizer_disabled_due_to_executor_ptrace=True,
        no_target_capacity_or_page_claim=True,no_emulator_launched=True)
    (HERE/'LOCAL-BRANCHES.json').write_text(json.dumps(output,indent=2)+'\n')
    (HERE/'branches.cpp').write_bytes((work/'branches.cpp').read_bytes())
    print(json.dumps(dict(passed=True,modes=list(result),tests_per_mode=result['ordinary']['tests']),indent=2))


if __name__=='__main__':run()
