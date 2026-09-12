// Full accepted road endpoint/material trace; never sent to the candidate.
#include "lookup_road.hpp"
#include <cstdio>
int main(int argc,char**argv) {
    if(argc!=3)return 1;
    rally::LookupRoad road;road.track=argv[1][0]=='o'?&rally::TriOval:&rally::Fuji;
    if(!road.load(argv[2]))return 2;
    long position,phase;
    while(scanf("%ld %ld",&position,&phase)==2) {
        road.project(position,phase);printf("%u",road.bands);
        for(unsigned i=0;i<=road.bands;++i)
            printf(" %u %d %u %ld",unsigned(road.rows[i]),rally::sectionCentrePixel(road.centersQ8[i]),i<road.bands?unsigned(road.materials[i]):0,long(road.centersQ8[i]));
        puts("");
    }
}
