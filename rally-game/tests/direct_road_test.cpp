#include "direct_road.hpp"
#include "game_scene.hpp"
#include "signs.hpp"
#include <cassert>
#include <vector>
#include <cstdio>
using namespace rally;
static std::vector<uint8_t> reference(Road &r) {
    // Independent preserved donor emission into small per-quad scratch buffers;
    // the donor's 4 KiB whole-frame buffer is not assumed sufficient.
    Stream s;std::vector<uint8_t> b;
    auto append=[&](){assert(!s.overflow);b.insert(b.end(),s.data,s.data+s.size);s.size=0;};
    s.rect(0,RoadTop,319,Bottom,2);append();
    for(int y=RoadTop;y<=Bottom;) {
        const int end=r.bandEnd(y);
        r.strip(s,y,end+1,-106,106,r.paint[y]?9:15);append();
        r.strip(s,y,end+1,-90,90,8);append();
        r.strip(s,y,end+1,-86,-84,r.paint[y]?11:15);append();
        r.strip(s,y,end+1,84,86,r.paint[y]?11:15);append();
        if(r.paint[y]) {r.strip(s,y,end+1,-2,2,11);append();}
        y=end+1;
    }
    s.rect(0,224,319,239,0);append();return b;
}
int main(){
    unsigned cases=0,maxBytes=0,maxChunks=0;
    for(auto track:{&Fuji,&TriOval}) {
        DirectRoad direct;Road donor;direct.track=donor.track=track;direct.init();donor.init();
        for(int position=0;position<track->length*100;position+=1700)
        for(int phase:{0,1,3999,4000,7999})
        for(int offset:{-38400,0,38400}) {
            direct.project(position,phase,offset);donor.project(position,phase,offset);
            for(int y=RoadTop;y<=Bottom+1;++y)assert(direct.centerAt(y)==donor.centers[y]/256);
            const auto cam=trackSample((position/100)*256+(position%100)*256/100,*track);
            const auto ahead=trackSample((position/100)*256+(position%100)*256/100+2048000/7,*track);
            assert(direct.centerAt(103)==(40960+((-(ahead.x-cam.x)*cam.ty+(ahead.y-cam.y)*cam.tx)/4096-offset)*7/50)/256);
            Stream s;std::vector<uint8_t>b;unsigned chunks=0;
            direct.emitTo(s,[&](const uint8_t*p,unsigned n){assert(n&&n<=4096);++chunks;b.insert(b.end(),p,p+n);});
            assert(!s.overflow&&s.size==0);assert(b==reference(donor));
            // Only colour and PLOT opcodes may occur in the road command stream.
            for(size_t i=0;i<b.size();) {const auto op=b[i];assert(op==18||op==25);i+=op==18?3:6;assert(i<=b.size());}
            if(b.size()>maxBytes)maxBytes=b.size();
            if(chunks>maxChunks)maxChunks=chunks;
            ++cases;
        }
        // Force maximal geometric fragmentation to exercise multiple flushes.
        for(int y=RoadTop;y<=Bottom+1;++y){direct.centers[y]=donor.centers[y]=(y&1)?300*256:0;direct.paint[y]=donor.paint[y]=y&1;}
        Stream s;std::vector<uint8_t>b;unsigned chunks=0;
        direct.emitTo(s,[&](const uint8_t*p,unsigned n){assert(n<=4096);++chunks;b.insert(b.end(),p,p+n);});
        assert(b==reference(donor)&&chunks>1&&!s.overflow);
    }
    printf("%u direct-road poses exact; max %u bytes/frame, %u chunks; fragmented overflow stress passes\n",cases,maxBytes,maxChunks);
}
