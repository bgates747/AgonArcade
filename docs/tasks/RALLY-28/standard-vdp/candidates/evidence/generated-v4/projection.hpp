#pragma once
#include "lookup_road.hpp"
#include "scenery.hpp"
#include "projection_tables.hpp"
namespace rally::r28 {
struct Tangent {int32_t tx,ty;};
inline Tangent tangentAt(int32_t station,const TrackDef &track) {
    const int32_t p=(station/100)*256+(station%100)*256/100;
    unsigned i=unsigned(p>>14);if(i>=track.count)i%=track.count;
    const auto &a=track.points[i],&b=track.points[i+1==track.count?0:i+1];
    const int32_t f=p&16383;
    return {a.tx+((int32_t(b.tx-a.tx)*f)>>14),a.ty+((int32_t(b.ty-a.ty)*f)>>14)};
}
struct SharedRoad:LookupRoad {
    bool coarse=false;
    Tangent camera{},yawCamera{};int heading=0;
    mutable bool ready[122]={};mutable int16_t pixels[122]={};
    mutable bool qReady[122]={};mutable int32_t qCenters[122]={};
    void project(int32_t position,int32_t phase,int32_t offset=0) {
        LookupRoad::project(position,phase,offset);
        memset(ready,0,sizeof ready);memset(qReady,0,sizeof qReady);
        for(unsigned i=0;i<boundaryCount;++i){const unsigned k=rows[i]-103;qCenters[k]=centersQ8[i];qReady[k]=true;}
        camera=tangentAt(position,*track);
        yawCamera=position%100?tangentAt(position/100*100,*track):camera;
        heading=sceneryHeading(camera.tx,camera.ty);
        if(coarse && bands) {
            const unsigned count=bands;unsigned out=0;bool active=materials[0],previous=active;
            for(unsigned i=1;i<=count;++i) {
                const bool next=i<count?materials[i]:false;
                const bool stripe=i==count || next!=previous;
                if(stripe || rows[i]-rows[out]>=24) {
                    materials[out]=active;++out;rows[out]=rows[i];centersQ8[out]=centersQ8[i];active=next;
                }
                previous=next;
            }
            bands=out;boundaryCount=out+1;
        }
    }
    int centerAt(int y) const {
        if(y<103 || y>224)return 160;
        const unsigned k=unsigned(y-103);
        if(!ready[k]) {
            int pixel=160;
            if(coarse && bands && y>=rows[0]) {
                unsigned i=0;while(i+1<bands && y>rows[i+1])++i;
                const int a=sectionCentrePixel(centersQ8[i]),b=sectionCentrePixel(centersQ8[i+1]);
                pixel=a+(b-a)*(y-rows[i])/(rows[i+1]-rows[i]);
            } else {
                if(!qReady[k]){qCenters[k]=LookupRoad::centerQ8At(y);qReady[k]=true;}
                pixel=sectionCentrePixel(qCenters[k]);
            }
            pixels[k]=int16_t(pixel);ready[k]=true;
        }
        return pixels[k];
    }
    int edgeAt(int y,unsigned edge) const {return centerAt(y)+EdgeOffset[y-103][edge];}
    static int depthRow(int32_t z){return 96+DistanceQ[unsigned(z)-64];}
    template<class Send> void emitTo(Stream &s,Send send,bool sky=false) const {
        s.size=0;s.overflow=false;if(sky)s.rect(0,0,319,103,4);s.rect(0,104,319,223,2);
        for(unsigned i=0;i<bands;++i) {
            if(s.size+155>sizeof s.data){send(s.data,s.size);s.size=0;}
            const int y=rows[i],yy=rows[i+1],top=centerAt(y),bottom=centerAt(yy);const bool paint=materials[i];
            const int16_t *upper=EdgeOffset[y-103],*lower=EdgeOffset[yy-103];
            for(unsigned layer=0;layer<(paint?5u:4u);++layer) {
                const unsigned e=layer*2;const int ink=layer==0?(paint?9:15):layer==1?8:paint?11:15;
                s.quad(top+upper[e],top+upper[e+1],y,bottom+lower[e],bottom+lower[e+1],yy,ink);
            }
        }
        if(s.size+15>sizeof s.data){send(s.data,s.size);s.size=0;}
        s.rect(0,224,319,239,0);if(s.size)send(s.data,s.size);s.size=0;
    }
};
}
