#include "frontend_state.hpp"
#include <cstdio>
#include <cstdint>
int main(int argc,char**argv){
    if(argc!=3)return 1;
    FILE*input=fopen(argv[1],"rb"),*output=fopen(argv[2],"wb");if(!input||!output)return 2;
    uint16_t count;if(fread(&count,2,1,input)!=1||count>1024)return 3;
    for(unsigned i=0;i<count;++i){
        uint16_t options[4];int32_t words[17];
        if(fread(options,sizeof(options),1,input)!=1||fread(words,sizeof(words),1,input)!=1)return 4;
        rally::Motion motion;rally::Traffic traffic;
        motion.track=options[0]==0?&rally::TriOval:options[0]==1?&rally::Fuji:nullptr;
        motion.grip=options[3];motion.position=words[0];motion.phase=words[1];motion.lateral=words[2];
        motion.steering=int16_t(words[3]);motion.speed=words[4];
        for(unsigned car=0;car<6;++car){traffic.cars[car].position=words[5+2*car];traffic.cars[car].lane=words[6+2*car];}
        rally::r19::State state;state.position=999;
        uint8_t result[98]{};
        bool accepted=rally::r19::stateFromMotion(motion,traffic,options[1],options[2]&1,options[2]&2,state);
        if(accepted){if(!rally::r19::packet(state,result+1,97))return 5;result[0]=1;}
        else if(state.position!=999)return 6;
        if(fwrite(result,sizeof(result),1,output)!=1)return 7;
    }
    if(fgetc(input)!=EOF)return 8;
    fclose(input);return fclose(output)==0?0:9;
}
