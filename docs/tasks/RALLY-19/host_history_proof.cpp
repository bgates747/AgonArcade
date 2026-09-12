// Every pair of panorama bearings, both pages and both validity states.
#include "road.hpp"
#include "scenery.hpp"
#include <cmath>
#include <cstdio>
#include <array>
int main(){
    unsigned checks=0;
    for(unsigned slot=0;slot<2;++slot)for(unsigned valid=0;valid<2;++valid)
    for(int old=0;old<1024;++old)for(int offset=0;offset<1024;++offset){
        rally::SceneryHistory history;history.slot=slot;history.offsets[slot]=old;history.valid[slot]=valid;
        history.offsets[slot^1]=777;
        auto expected=history.prepare(offset);history.swapped();
        float raw=(float(offset)-float(old))+1536.0f;
        unsigned quotient=unsigned(std::floor(raw/1024.0f));
        int remainder=int(std::floor(raw-float(quotient)*1024.0f));
        int delta=remainder-512;
        bool full=!valid||remainder<257||remainder>767;
        int left=0,right=0;bool repaint=false;
        if(full){delta=0;right=319;repaint=true;}
        else if(delta>0){left=320-delta;right=319;repaint=true;}
        else if(delta<0){right=-delta-1;repaint=true;}
        if(remainder<0||remainder>1023||delta<-255||delta>255||left<0||right>319||
           expected.delta!=delta||expected.left!=left||expected.right!=right||expected.repaint!=repaint||
           history.slot!=(slot^1)||history.offsets[slot]!=offset||!history.valid[slot]||history.offsets[slot^1]!=777){
            fprintf(stderr,"history mismatch %u %u %d %d\n",slot,valid,old,offset);return 1;
        }
        ++checks;
    }
    printf("{\"pass\":true,\"history_checks\":%u,\"tracks\":[",checks);
    unsigned trackIndex=0;
    for(const auto*track:{&rally::TriOval,&rally::Fuji}){
        std::array<int,1024> positions;positions.fill(-1);unsigned count=0;
        for(int position=0;position<track->length*100&&count<1024;++position){
            auto tangent=rally::trackSample(position/100*256+(position%100)*256/100,*track);
            int heading=rally::sceneryHeading(tangent.tx,tangent.ty);
            if(positions[heading]<0){positions[heading]=position;++count;}
        }
        if(trackIndex)putchar(',');
        printf("{\"track\":\"%s\",\"bearings\":%u,\"positions\":[",trackIndex++?"fuji":"oval",count);
        for(unsigned i=0;i<1024;++i){if(i)putchar(',');printf("%d",positions[i]);}
        printf("]}");
    }
    puts("]}");return 0;
}
