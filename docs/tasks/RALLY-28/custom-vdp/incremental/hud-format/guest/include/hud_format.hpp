#pragma once
#include <stdint.h>
#include <stdio.h>
namespace rally::game {
// Cache strings before Hud::emit compares retained cells. The cache describes
// content, not screen pages: footer text must still draw after the road clears it.
// Constant initialization is required by the AgonDev startup used by this game.
template<unsigned N> struct HudFormattedText {
    char text[N]{};
    uint32_t key=0;
    bool valid=false;
    constexpr HudFormattedText() = default;
    bool changed(uint32_t next) const { return !valid || next!=key; }
    template<typename... Args> const char *get(uint32_t next,const char *format,Args... args) {
        if(changed(next)) {
            snprintf(text,sizeof(text),format,args...);
            key=next;valid=true;
        }
        return text;
    }
};
struct HudFormat {
    HudFormattedText<48> top,countdown,lap,score,speed,rank;
    HudFormattedText<40> footer;
    constexpr HudFormat() = default;
};
}
