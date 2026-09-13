#pragma once
#include <string.h>
#include "road.hpp"
namespace rally::game {
constexpr int HudHeight=24, SkyColour=20;
struct HudImage {
    char text[120];uint8_t colour[120];
    // Must stay constant-initializable: this agondev CRT's dynamic global
    // initializer walker calls the table end instead of its function pointer.
    // Local constexpr construction avoids entering that broken startup path.
    constexpr HudImage() : text{},colour{} {
        for(unsigned i=0;i<120;++i) {text[i]=' ';colour[i]=15;}
    }
    void put(unsigned x,unsigned y,const char *s,uint8_t ink=15) {
        for(;*s && x<40 && y<3;++s,++x) { text[y*40+x]=*s;colour[y*40+x]=ink; }
    }
};
// Each drawing page has independent retained cells. The VDP text background
// erases only replaced glyph cells. A turn never invalidates this cache.
struct Hud {
    HudImage previous[2];bool valid[2]={false,false};
    void invalidate() { valid[0]=valid[1]=false; }
    void emit(Stream &out,unsigned page,const HudImage &next) {
        if(!valid[page])out.rect(0,0,319,HudHeight-1,SkyColour);
        for(unsigned y=0;y<3;++y)for(unsigned x=0;x<40;) {
            unsigned at=y*40+x;
            if(valid[page] && previous[page].text[at]==next.text[at] &&
               previous[page].colour[at]==next.colour[at]) {++x;continue;}
            const uint8_t ink=next.colour[at];
            // The renderer stays in VDU4 text mode. Reissuing VDU4 here would
            // reselect the font/rebuild cursor state for every changed run.
            out.byte(17);out.byte(128+SkyColour);
            out.byte(17);out.byte(ink);out.byte(31);out.byte(x);out.byte(y);
            do {
                out.byte(next.text[at]);++x;++at;
            } while(x<40 && next.colour[at]==ink && (!valid[page] ||
                     previous[page].text[at]!=next.text[at] || previous[page].colour[at]!=ink));
        }
        previous[page]=next;valid[page]=true;
    }
};
// Pixel-coordinate viewport: SDK argument order is left,bottom,right,top.
// Keeping encoding here makes the sky/HUD exclusion host-testable.
inline void viewport(Stream &s,int left,int top,int right,int bottom) {
    s.byte(24);s.word(left);s.word(bottom);s.word(right);s.word(top);
    // Stock VDP stores VDU24 without updating canvas clipping. Direct bitmap
    // command23,27,3 uses the previous canvas clip, so activate it with MOVE.
    s.plot(4,left,top);
}
inline void skyViewport(Stream &s,int left,int top,int right,int bottom) {
    if(top<HudHeight)top=HudHeight;
    viewport(s,left,top,right,bottom);
}
}
