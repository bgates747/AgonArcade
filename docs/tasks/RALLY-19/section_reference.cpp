// Query the complete accepted band containing row160. Candidate receives no corners.
#include "lookup_road.hpp"
#include <cstdio>
int main(int argc,char**argv) {
    if(argc!=3)return 1;
    rally::LookupRoad road;road.track=argv[1][0]=='o'?&rally::TriOval:&rally::Fuji;
    if(!road.load(argv[2]))return 2;
    long position,phase;
    while(scanf("%ld %ld",&position,&phase)==2) {
        road.project(position,phase);
        for(unsigned i=0;i<road.bands;++i)if(road.rows[i]<=160 && 160<road.rows[i+1]) {
            printf("%u %u %d %d %d\n",unsigned(road.rows[i]),unsigned(road.rows[i+1]),
                rally::sectionCentrePixel(road.centersQ8[i]),rally::sectionCentrePixel(road.centersQ8[i+1]),int(road.materials[i]));
            break;
        }
    }
}
