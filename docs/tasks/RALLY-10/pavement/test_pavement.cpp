#include "pavement.hpp"
#include <cassert>
#include <cstdio>
#include <cstring>
#include <cstdlib>
#include <algorithm>

int main() {
    using namespace rally;
    PavementRoad road;road.init();
    Stream stream,phaseStream;
    unsigned maxBytes=0,maxBands=0;
    for(const TrackDef *track:{&TriOval,&Fuji}) for(bool fixed:{false,true}) {
        road.track=track;road.fixedBands=fixed;
        for(int32_t p=0;p<track->length*100;p+=1700) for(int offset:{-25600,0,25600}) {
            road.render(stream,0,p,offset,false);
            assert(!stream.overflow);
            assert(stream.size==30+27*road.bands);
            for(unsigned i=15;i<stream.size-15;i+=27) {
                assert(stream.data[i]==18 && stream.data[i+1]==0 && stream.data[i+2]==8);
                assert(stream.data[i+3]==25 && stream.data[i+4]==4);
                assert(stream.data[i+9]==25 && stream.data[i+10]==4);
                assert(stream.data[i+15]==25 && stream.data[i+16]==0x55);
                assert(stream.data[i+21]==25 && stream.data[i+22]==0x55);
            }
            road.render(phaseStream,3971,p,offset,false);
            assert(stream.size==phaseStream.size);
            assert(std::memcmp(stream.data,phaseStream.data,stream.size)==0);
            for(int y=RoadTop;y<=Bottom;) {
                int end=road.bandEnd(y);assert(end>=y && end<=Bottom);
                for(int row=y;row<=end;++row) {
                    int64_t error=int64_t(road.centers[y]-road.centers[row])*(end+1-y)
                        +int64_t(road.centers[end+1]-road.centers[y])*(row-y);
                    assert(std::abs(error)<=256L*(end+1-y));
                }
                y=end+1;
            }
            maxBytes=std::max(maxBytes,stream.size);maxBands=std::max(maxBands,road.bands);
        }
    }
    std::printf("Pavement-only: both tracks/modes, phase-independent gray quads; max %u bytes, %u bands.\n",maxBytes,maxBands);
}
