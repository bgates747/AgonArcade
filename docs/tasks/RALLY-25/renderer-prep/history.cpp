// Observe frozen retained-page code. Python supplies independent expectations.
#include "hud.hpp"
#include "scenery.hpp"
#include <iostream>
using namespace rally;
using namespace rally::game;
int main() {
    Hud hud;SceneryHistory history;
    unsigned version,offset,reset;
    while(std::cin>>version>>offset>>reset) {
        if(reset){hud.invalidate();history.valid[0]=history.valid[1]=false;}
        HudImage image;image.put(0,0,version?"SCORE 002":"SCORE 001");
        Stream s;hud.emit(s,history.slot,image);
        const auto u=history.prepare(int(offset));
        Stream viewport;skyViewport(viewport,0,0,319,103);
        std::cout<<history.slot<<','<<s.size<<','<<u.delta<<','<<u.left<<','<<u.right<<','<<u.repaint<<','
                 <<unsigned(viewport.data[7])<<','<<unsigned(viewport.data[8])<<'\n';
        history.swapped();
    }
}
