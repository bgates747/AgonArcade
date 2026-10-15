#pragma once
#include "lookup_road.hpp"

namespace rally::r28 {
// LOOKUP-001-01 host/code-generation feasibility component. Not integrated.
// Reuse the preserved coefficient/cache/band evaluator; replace only its
// buffered matrix emitter with final integer vertices on eZ80.
template<class Projection> struct DirectSections : Projection {
    template<class Send> void emitTo(Stream &out, Send send, bool fillSky=false) const {
        const auto &road=*this;
        out.size=0;out.overflow=false;
        if(fillSky)out.rect(0,0,319,RoadTop-1,4);
        out.rect(0,RoadTop,319,Bottom,2);
        int top=road.bands?sectionCentrePixel(road.centersQ8[0]):160;
        for(unsigned i=0;i<road.bands;++i) {
            // Retain R27's bounded stream; never split a primitive/band.
            if(out.size+155>sizeof(out.data)){send(out.data,out.size);out.size=0;}
            const int bottom=sectionCentrePixel(road.centersQ8[i+1]);
            const int y=road.rows[i],yy=road.rows[i+1];
            const bool marked=road.materials[i];
            auto strip=[&](int left,int right,int colour) {
                out.quad(top+Road::edge(y,left),top+Road::edge(y,right),y,
                    bottom+Road::edge(yy,left),bottom+Road::edge(yy,right),yy,colour);
            };
            strip(-106,106,marked?9:15);strip(-90,90,8);
            strip(-86,-84,marked?11:15);strip(84,86,marked?11:15);
            if(marked)strip(-2,2,11);
            top=bottom;
        }
        if(out.size+15>sizeof(out.data)){send(out.data,out.size);out.size=0;}
        out.rect(0,Bottom+1,319,239,0);
        if(out.size)send(out.data,out.size);
        out.size=0;
    }
};
using DirectLookup=DirectSections<LookupRoad>;
using DirectLiveSections=DirectSections<SectionRoad>;
}
