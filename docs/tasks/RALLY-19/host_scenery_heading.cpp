// Independent accepted track/scenery functions for native fixture expectations.
#include "road.hpp"
#include "scenery.hpp"
#include <cstdio>
#include <cstring>
int main(int argc,char**argv){
    if(argc!=2)return 1;
    const auto&track=strcmp(argv[1],"fuji")==0?rally::Fuji:rally::TriOval;
    long position;
    while(scanf("%ld",&position)==1){
        if(position<0||position>=track.length*100)return 2;
        auto tangent=rally::trackSample(position/100*256+(position%100)*256/100,track);
        const auto&a=track.points[position/6400];
        const auto&b=track.points[(position/6400+1)%track.count];
        printf("%d,%d,%d,%d,%d\n",tangent.tx,tangent.ty,
               int(rally::sceneryHeading(tangent.tx,tangent.ty)),a.ty,b.ty-a.ty);
    }
    return 0;
}
