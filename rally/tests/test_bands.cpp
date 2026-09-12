#include "road.hpp"
#include <algorithm>
#include <cassert>
#include <cstdio>
#include <vector>
using namespace rally;

int main() {
    Road road;road.init();road.fixedBands=true;
    Stream stream;
    unsigned maxBytes=0,maxBands=0,views=0;
    double maxError=0;
    // Every distinct material pattern: phase changes only at these thresholds.
    std::vector<int> phases{0};
    for(int y=116;y<=Bottom;++y) for(int value:{0,Period*50})
        phases.push_back((value-road.depth[y-Horizon]%(Period*100)+Period*100)%(Period*100));
    std::sort(phases.begin(),phases.end());
    phases.erase(std::unique(phases.begin(),phases.end()),phases.end());
    for(const TrackDef *track:{&TriOval,&Fuji}) {
        road.track=track;
        // Check every table against every material pattern, irrespective of
        // lap position/phase correlation. Bytes depend on those two alone.
        for(int32_t p=0;p<track->length*100;p+=BandBinWorld*100) {
            road.project(p,0);
            for(int phase:phases) {
                for(int y=RoadTop;y<=Bottom+1;++y) road.paint[y]=y>=116 && road.painted(y,phase);
                road.emit(stream,false);
                if(stream.overflow) {
                    std::fprintf(stderr,"Overflow %s position %ld phase %d bands %u\n",track->name,long(p),phase,road.bands);
                    return 1;
                }
                maxBytes=std::max(maxBytes,stream.size);maxBands=std::max(maxBands,road.bands);
            }
        }
        // Held-out 0.37-unit spacing, offsets at both driving limits, and
        // independent material phase. Include both sides of every bin seam.
        std::vector<int32_t> positions;
        for(int32_t p=0;p<track->length*100;p+=37) positions.push_back(p);
        for(int32_t p=BandBinWorld*100;p<track->length*100;p+=BandBinWorld*100) {
            positions.push_back(p-1);positions.push_back(p);positions.push_back(p+1);
        }
        positions.push_back(track->length*100-1);
        for(int32_t p:positions) for(int offset:{-100*256,0,100*256}) {
            road.project(p,(p*13+397)%8000,offset);++views;
            for(int y=RoadTop;y<=Bottom;) {
                int end=road.bandEnd(y);
                assert(end>=y && end<=Bottom);
                for(int row=y;row<=end;++row) {
                    assert(road.paint[row]==road.paint[y]);
                    int64_t error=int64_t(road.centers[y]-road.centers[row])*(end+1-y)
                        +int64_t(road.centers[end+1]-road.centers[y])*(row-y);
                    double pixels=double(std::abs(error))/(256*(end+1-y));
                    maxError=std::max(maxError,pixels);
                    assert(pixels<=1.0);
                }
                y=end+1;
            }
        }
    }
    std::printf("Fixed bands: %u held-out views, %.6f px max error; all %zu material patterns/table: %u bytes, %u bands max.\n",
                views,maxError,phases.size(),maxBytes,maxBands);
}
