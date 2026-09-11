#include "road.hpp"
#include <assert.h>
#include <stdio.h>
#include <initializer_list>
int main() {
    rally::Road road; rally::Stream s; rally::Motion m;
    road.init();
    for(int q=2;q<=127;++q) assert(road.depth[q]<road.depth[q-1]);
    assert(rally::Road::edge(223,90)==228);
    assert(rally::Road::edge(rally::RoadTop,90)==12);
    assert(road.depth[rally::RoadTop-rally::Horizon]>0);
    unsigned maximum=0;
    for(int phase=0;phase<8000;++phase) {
        road.render(s,phase);
        assert(!s.overflow);
        if(s.size>maximum) maximum=s.size;
        for(int y=116;y<=223;++y) assert(road.painted(y,phase)==road.painted(y,phase+8000));
    }
    unsigned curveMax=0, maxBands=0;
    for(int32_t pos=0;pos<rally::TrackLength*100;pos+=1700) {
        road.render(s,pos%8000,pos);
        assert(!s.overflow);
        if(s.size>curveMax) curveMax=s.size;
        if(road.bands>maxBands) maxBands=road.bands;
        for(int y=rally::RoadTop;y<=rally::Bottom;) {
            int end=road.bandEnd(y);
            for(int row=y;row<=end;++row) {
                assert(road.paint[row]==road.paint[y]);
                if(end>=y) {
                    int32_t line=road.centers[y]+(road.centers[end+1]-road.centers[y])*(row-y)/(end+1-y);
                    assert(line-road.centers[row]<=257 && line-road.centers[row]>=-257);
                }
                assert(road.centers[row]>-2000L*256 && road.centers[row]<2000L*256);
            }
            y=end+1;
        }
    }
    assert(curveMax<3000);
    // Continuous centreline/heading across every sample boundary, including wrap.
    for(int i=0;i<rally::TrackCount;++i) {
        int32_t p=int32_t(i)*rally::TrackStep*256;
        auto a=rally::trackSample(p+rally::TrackLength*256-1);
        auto b=rally::trackSample(p);
        assert(a.x-b.x<=2 && a.x-b.x>=-2);
        assert(a.y-b.y<=2 && a.y-b.y>=-2);
        assert(a.tx-b.tx<=2 && a.tx-b.tx>=-2);
        assert(a.ty-b.ty<=2 && a.ty-b.ty>=-2);
    }
    road.project(rally::TrackLength*100-1,0);
    int32_t seam[rally::Bottom+1];
    for(int y=rally::RoadTop;y<=rally::Bottom;++y) seam[y]=road.centers[y];
    road.project(0,0);
    for(int y=rally::RoadTop;y<=rally::Bottom;++y)
        assert(road.centers[y]-seam[y]<=256 && road.centers[y]-seam[y]>=-256);
    m.position=rally::TrackLength*100-1; m.speed=1; m.tick(false,false);
    assert(m.position==0);
    m.speed=0;
    printf("Full-loop curve budget: %u bytes, %u bands; interpolation and band error checks pass.\n",curveMax,maxBands);
    for(int i=0;i<1000;++i) m.tick(true,false);
    assert(m.speed==300);
    for(int i=0;i<1000;++i) m.tick(false,true);
    assert(m.speed==0);
    int32_t stopped=m.phase;
    for(int i=0;i<100;++i) m.tick(false,false);
    assert(m.phase==stopped);
    m.speed=100; m.phase=0;
    for(int i=0;i<100;++i) m.tick(false,false);
    assert(m.phase==2000);
    rally::Motion leftCar,rightCar;
    leftCar.speed=rightCar.speed=200;
    leftCar.steerFrame(true,false);rightCar.steerFrame(false,true);
    for(int i=0;i<40;++i) { leftCar.tick(false,false);rightCar.tick(false,false); }
    assert(leftCar.lateral<0 && rightCar.lateral>0);
    assert(leftCar.lateral== -rightCar.lateral);
    assert(leftCar.view()==5 && rightCar.view()==3);
    assert(leftCar.carX()<128 && rightCar.carX()>128);
    rightCar.steerFrame(false,false);
    for(int i=0;i<100;++i) rightCar.tick(false,false);
    assert(rightCar.view()==3 && rightCar.steering==250);
    rightCar.steerFrame(true,false);
    assert(rightCar.view()==4 && rightCar.steering==0);
    for(int i=0;i<200;++i) rightCar.tick(false,false);
    assert(rightCar.yawStep==0); // Physics catch-up never changes steering.
    rally::Motion detents;
    for(int i=1;i<=4;++i) {
        detents.steerFrame(false,true);assert(detents.yawStep==i);
    }
    for(int i=0;i<12;++i) detents.steerFrame(false,true);
    assert(detents.yawStep==4 && detents.view()==0);
    detents.steerFrame(true,true);assert(detents.yawStep==4);
    detents.steerFrame(false,false);assert(detents.yawStep==4);
    for(int i=0;i<12;++i) detents.steerFrame(true,false);
    assert(detents.yawStep== -4 && detents.view()==8);
    rightCar.lateral=100L*256;rightCar.speed=300;
    for(int i=0;i<150;++i) rightCar.tick(true,false);
    assert(rightCar.speed<=92 && rightCar.offroad());
    for(int i=0;i<200;++i) rightCar.tick(false,true);
    assert(rightCar.speed==0 && rightCar.lateralVelocity==0);
    int32_t rest=rightCar.lateral;
    for(int i=0;i<50;++i) rightCar.tick(false,false);
    assert(rightCar.lateral==rest);
    rally::Motion bendCar;
    bendCar.position=6144L*100;bendCar.speed=200;
    for(int i=0;i<40;++i) bendCar.tick(false,false);
    assert(bendCar.lateral<0); // Right bend pushes the unsteered car outward left.
    road.project(0,0,0);int32_t near=road.centers[210],far=road.centers[110];
    road.project(0,0,25L*256);
    assert(road.centers[210]<near && road.centers[110]<far);
    assert(near-road.centers[210]>far-road.centers[110]);
    for(int32_t pos=0;pos<rally::TrackLength*100;pos+=6400)
        for(int offset: {-100,100}) { road.render(s,pos%8000,pos,offset*256L);assert(!s.overflow); }
    printf("Steering symmetry, persistent steering detents, grass slowdown, stopped motion and camera parallax pass.\n");
    s.size=0; s.word(-2); assert(s.data[0]==254 && s.data[1]==255);
    printf("Projection, all 8000 material phases, speed bounds, stop/coast, wrap and encoding pass. Max road bytes: %u\n",maximum);
}
