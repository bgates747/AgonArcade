#pragma once
#include "projection.hpp"
namespace rally::r28 {
// Application-owned IDs, disjoint from assets/font/matrix IDs. Templates only
// copy final integer command fields; all geometry remains on eZ80.
constexpr unsigned Parameters=54000,Drawing4=54001,Drawing5=54002,Run4=54003,Run5=54004;
template<class Send> void bufferPrefix(unsigned id,unsigned op,Send send){const uint8_t b[]={23,0,160,uint8_t(id),uint8_t(id>>8),uint8_t(op)};send(b,sizeof b);}
template<class Send> void upload(unsigned id,const uint8_t *p,unsigned n,Send send) {
    bufferPrefix(id,2,send);const uint8_t b[]={23,0,160,uint8_t(id),uint8_t(id>>8),0,uint8_t(n),uint8_t(n>>8)};
    send(b,sizeof b);send(p,n);
}
template<class Send> void templates(Send send) {
    uint8_t zero[44]={};upload(Parameters,zero,44,send);
    for(unsigned layers=4;layers<=5;++layers) {
        Stream drawing,run;const unsigned draw=layers==4?Drawing4:Drawing5;
        const unsigned execute=layers==4?Run4:Run5;
        for(unsigned layer=0;layer<layers;++layer) {
            const int ink=layer==0?(layers==5?9:15):layer==1?8:layers==5?11:15;
            drawing.quad(0,0,0,0,0,0,ink);
            for(unsigned vertex=0;vertex<4;++vertex)for(unsigned axis=0;axis<2;++axis) {
                // SET two bytes from the compact plane into draw command x/y.
                const unsigned destination=layer*27+3+vertex*6+2+axis*2;
                const unsigned source=axis?layers*8+(vertex<2?0:2):layer*8+vertex*2;
                run.byte(23);run.byte(0);run.byte(160);run.word(draw);run.byte(5);run.byte(0xe2);
                run.word(destination);run.word(2);run.word(Parameters);run.word(source);
            }
        }
        run.byte(23);run.byte(0);run.byte(160);run.word(draw);run.byte(1);
        upload(draw,drawing.data,drawing.size,send);upload(execute,run.data,run.size,send);
    }
}
template<class Road,class Send> void emitBuffered(const Road &road,Stream &s,Send send) {
    s.size=0;s.rect(0,104,319,223,2);send(s.data,s.size);s.size=0;
    for(unsigned i=0;i<road.bands;++i) {
        const unsigned layers=road.materials[i]?5:4;const int y=road.rows[i],yy=road.rows[i+1],top=road.centerAt(y),bottom=road.centerAt(yy);
        const int16_t *upper=EdgeOffset[y-103],*lower=EdgeOffset[yy-103];
        // Patch header11 + packed coordinates36/44 + CALL6.
        s.byte(23);s.byte(0);s.byte(160);s.word(Parameters);s.byte(5);s.byte(0xc2);s.word(0);s.word(layers*8+4);
        for(unsigned layer=0;layer<layers;++layer) {
            const unsigned e=layer*2;s.word(top+upper[e]);s.word(top+upper[e+1]);
            s.word(bottom+lower[e]);s.word(bottom+lower[e+1]);
        }
        s.word(y);s.word(yy);
        s.byte(23);s.byte(0);s.byte(160);s.word(layers==5?Run5:Run4);s.byte(1);
        send(s.data,s.size);s.size=0;
    }
    s.rect(0,224,319,239,0);send(s.data,s.size);s.size=0;
}
}
