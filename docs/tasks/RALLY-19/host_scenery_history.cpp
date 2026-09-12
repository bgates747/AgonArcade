// Independent accepted page-history reference for a sequence of raw positions.
#include "road.hpp"
#include "scenery.hpp"
#include <cstdio>
#include <cstring>
int main(int argc,char**argv){
    if(argc!=2)return 1;
    const auto&track=strcmp(argv[1],"fuji")==0?rally::Fuji:rally::TriOval;
    rally::SceneryHistory history;long position;
    while(scanf("%ld",&position)==1){
        if(position<0||position>=track.length*100)return 2;
        auto tangent=rally::trackSample(position/100*256+(position%100)*256/100,track);
        int heading=rally::sceneryHeading(tangent.tx,tangent.ty);
        unsigned slot=history.slot;int old=history.offsets[slot];bool valid=history.valid[slot];
        auto update=history.prepare(heading);history.swapped();
        printf("%d,%d,%d,%u,%d,%d,%d,%d,%u,%d,%d,%d,%d\n",heading,old,int(valid),slot,
               update.delta,update.left,update.right,int(update.repaint),history.slot,
               history.offsets[0],int(history.valid[0]),history.offsets[1],int(history.valid[1]));
    }
    return 0;
}
