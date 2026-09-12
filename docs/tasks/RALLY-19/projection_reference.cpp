// Uses the actual accepted oracle evaluator, not a duplicate float model.
#include "lookup_road.hpp"
#include <cstdio>
int main(int argc,char**argv){
    if(argc!=3)return 1;
    rally::LookupRoad road;road.track=argv[1][0]=='o'?&rally::TriOval:&rally::Fuji;
    if(!road.load(argv[2])){fprintf(stderr,"%s\n",road.error());return 2;}
    long position;int row;
    while(scanf("%ld %d",&position,&row)==2){
        road.project(position,0);
        int32_t q8=road.centerQ8At(row);
        printf("%ld %d\n",long(q8),rally::sectionCentrePixel(q8));
    }
}
