#include "frontend_state.hpp"
#include "demo.hpp"
#include "task_workload.hpp"
#include <cstdio>
#include <cstdlib>
rally::Motion motion; rally::Traffic traffic; rally::DemoDriver demoDriver;
bool demoMode=true,demoInputArmed=false,escapeArmed=true,autosteer=false;
uint8_t heldKeys[16]{};
bool key(int code){return heldKeys[(code-1)/8]&(1<<((code-1)%8));}
#include "replay_step.hpp"
int main(int argc,char**argv){
if(argc!=3)return 1;motion.track=atoi(argv[1])?&rally::Fuji:&rally::TriOval;
traffic.reset(motion.track->length*100);
unsigned count=atoi(argv[2]);
for(unsigned i=0;i<count;++i){
if(!replayStep(i))return 2;
rally::r19::State state;uint8_t data[80];
if(!rally::r19::stateFromMotion(motion,traffic,i,demoMode,autosteer,state)||!rally::r19::encode(state,data,80))return 3;
if(fwrite(data,1,80,stdout)!=80)return 4;
}return 0;}
