#include "lookup_road.hpp"
#include "signs.hpp"
#include <cassert>
#include <cstdio>
#include <initializer_list>
using namespace rally;
using namespace rally::game;
int main() {
    for(const TrackDef *track:{&TriOval,&Fuji}) {
        LookupRoad road;road.track=track;road.init();
        assert(road.load(track==&Fuji?"../rally-production/fuji.road":"../rally-production/oval.road"));
        Motion motion;motion.track=track;Billboards signs;
        unsigned seen=0,frames=0;
        for(int32_t position=0;position<track->length*100;position+=100) {
            motion.position=position;road.project(position,position);
            signs.prepare(motion,road);assert(signs.count<=2);
            for(unsigned i=0;i<signs.count;++i) {
                const auto &s=signs.visible[i];
                assert(s.y>=RoadTop && s.y+64*s.scale/256<=Bottom);
                assert(s.x<320 && s.x+64*s.scale/256>0);
                assert(s.bitmap>=SignBitmapBase && s.bitmap<SignBitmapBase+8);
                assert(!i || signs.visible[i-1].scale<=s.scale);
                seen|=1u<<(s.bitmap-SignBitmapBase);++frames;
            }
        }
        assert(seen==255 && frames>1000);
        printf("%s: all eight signs visible, %u projections stay inside road-refreshed rows\n",
               track==&Fuji?"Fuji":"Oval",frames);
    }
}
