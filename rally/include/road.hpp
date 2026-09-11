#pragma once
#include <stdint.h>
#include "track.hpp"
namespace rally {
constexpr int Horizon = 96, RoadTop = 103, CameraHeight = 50;
constexpr int Bottom = 223, Period = 80;
constexpr int RoadHalfWidth=90, KerbOuterWidth=106, CarHalfWidth=12;
enum class Surface { Road, Kerb, Grass };
struct Stream {
    uint8_t data[4096];
    unsigned size = 0;
    bool overflow = false;
    void byte(unsigned v) {
        if (size < sizeof(data)) data[size++] = uint8_t(v);
        else overflow = true;
    }
    void word(int v) { byte(uint16_t(v)); byte(uint16_t(v) >> 8); }
    void color(int c) { byte(18); byte(0); byte(c); }
    void plot(int mode, int x, int y) { byte(25); byte(mode); word(x); word(y); }
    void rect(int x, int y, int xx, int yy, int c) {
        color(c); plot(4,x,y); plot(0x65,xx,yy);
    }
    void quad(int l, int r, int y, int ll, int rr, int yy, int c) {
        color(c); plot(4,l,y); plot(4,r,y); plot(0x55,ll,yy); plot(0x55,rr,yy);
    }
};
struct Sample { int32_t x,y,tx,ty; };
inline Sample trackSample(int32_t distanceQ8, const TrackDef &track=Fuji) {
    unsigned index=unsigned(distanceQ8>>14);
    if(index>=track.count) index%=track.count;
    int32_t f=distanceQ8&16383;
    const auto &a=track.points[index]; const auto &b=track.points[index+1==track.count?0:index+1];
    return {int32_t(a.x)*256+((int32_t(b.x-a.x)*f)>>6),
            int32_t(a.y)*256+((int32_t(b.y-a.y)*f)>>6),
            a.tx+((int32_t(b.tx-a.tx)*f)>>14),
            a.ty+((int32_t(b.ty-a.ty)*f)>>14)};
}
struct Motion {
    const TrackDef *track=&Fuji;
    int32_t phase=0, position=0, speed=0;
    int32_t lateral=0, lateralVelocity=0; // Q8 world units, Q8 units/sec
    int16_t steering=0; // Signed 256-unit circle angle, three units per held frame.
    int grip=60;
    Surface surface() const {
        int32_t outer=(lateral<0?-lateral:lateral)+CarHalfWidth*256L;
        if(outer>KerbOuterWidth*256L) return Surface::Grass;
        if(outer>RoadHalfWidth*256L) return Surface::Kerb;
        return Surface::Road;
    }
    bool offroad() const { return surface()==Surface::Grass; }
    const char *surfaceName() const {
        return surface()==Surface::Grass?"GRASS":surface()==Surface::Kerb?"KERB ":"ROAD ";
    }
    int view() const { return ((steering<0?-steering:steering)*4+10)/21; }
    bool mirrored() const { return steering>0; } // Positive Blender yaw faces left.
    int carX() const { return 128+int(lateral*3/1024); }
    int32_t cameraOffset() const { return lateral*2/3; }
    void steerFrame(bool left, bool right) {
        // Called exactly once per rendered frame, independent of key repeat.
        if(left!=right) {
            steering+=right?3:-3;
            if(steering>21) steering=21;
            if(steering< -21) steering= -21;
        }
    }
    void gripFrame(bool less,bool more) {
        if(less!=more) grip+=more?5:-5;
        if(grip<25) grip=25;
        if(grip>200) grip=200;
    }
    void lateralStep(int32_t centripetal) { // Q8 world acceleration required by curve
        int32_t wanted=int32_t(steering)*speed*512/63;
        int32_t required=(wanted-lateralVelocity)*100/12+centripetal;
        int32_t limit=int32_t(grip)*180*256/100;
        if(surface()==Surface::Grass) limit=limit/2;
        else if(surface()==Surface::Kerb) limit=limit*115/100;
        int32_t available=required;
        if(available>limit) available=limit;
        if(available< -limit) available= -limit;
        lateralVelocity+=(available-centripetal)/100;
        if(speed==0) lateralVelocity=0;
    }
    void speedStep(bool accelerate, bool brake) {
        speed+=brake?-4:accelerate?2:0;
        Surface contact=surface();
        int floor=contact==Surface::Grass?90:160;
        int drag=contact==Surface::Grass?4:3;
        if(contact!=Surface::Road && speed>floor) {
            speed-=drag;
            if(speed<floor) speed=floor;
        }
        if(speed<0) speed=0;
        if(speed>224) speed=224;
    }
    void tick(bool accelerate, bool brake) {
        speedStep(accelerate,brake);
        int32_t p=(position/100)*256+(position%100)*256/100;
        Sample a=trackSample(p,*track), b=trackSample(p+64L*256,*track);
        int32_t bend=(a.tx*b.ty-a.ty*b.tx)/4096;
        // v^2 / radius: tangent change is Q12 over 64 world units.
        lateralStep(speed*speed*bend/1024);
        lateral+=lateralVelocity/100;
        if(lateral>150L*256) { lateral=150L*256; lateralVelocity=0; }
        if(lateral< -150L*256) { lateral= -150L*256; lateralVelocity=0; }
        position=(position+speed)%(track->length*100);
        phase=(phase+speed)%(Period*100);
    }
};
struct Road {
    const TrackDef *track=&Fuji;
    int32_t depth[Bottom-Horizon+2]; // hundredth units for material phase
    int32_t depthQ8[Bottom-Horizon+2];
    int32_t centers[Bottom+2]; // projected Q8 pixels
    bool paint[Bottom+2];
    unsigned bands=0;
    void init() {
        depth[0]=depthQ8[0]=0;
        for (int q=1; q<=Bottom+1-Horizon; ++q) {
            depth[q]=(160L*CameraHeight*100)/q;
            depthQ8[q]=(160L*CameraHeight*256)/q;
        }
    }
    bool painted(int y, int32_t phase) const {
        return ((depth[y-Horizon]+phase) % (Period*100)) < Period*50;
    }
    static int edge(int y, int width) { return (y-Horizon)*width/CameraHeight; }
    void project(int32_t position, int32_t phase, int32_t cameraOffset=0) {
        int32_t p=(position/100)*256+(position%100)*256/100;
        Sample camera=trackSample(p,*track);
        for(int y=RoadTop;y<=Bottom+1;++y) {
            Sample ahead=trackSample(p+depthQ8[y-Horizon],*track);
            int32_t dx=ahead.x-camera.x, dy=ahead.y-camera.y;
            // Right vector in map coordinates (-ty, tx). Arc distance supplies
            // depth: intentionally an arcade approximation, not a full 3D camera.
            int32_t lateral=(-dx*camera.ty+dy*camera.tx)/4096;
            centers[y]=160L*256+(lateral-cameraOffset)*(y-Horizon)/CameraHeight;
            paint[y]=y>=116 && painted(y,phase);
        }
    }
    int bandEnd(int y) const {
        int end=y;
        // Greedily grow a band only while all intermediate row centers stay
        // within one pixel of the segment and the material does not change.
        while(end<Bottom && paint[end+1]==paint[y]) {
            int candidate=end+1;
            int endpoint=candidate+1;
            bool fits=true;
            for(int row=y+1;row<=candidate;++row) {
                int32_t error=(centers[y]-centers[row])*(endpoint-y)
                    +(centers[endpoint]-centers[y])*(row-y);
                int32_t tolerance=256L*(endpoint-y);
                if(error>tolerance || error< -tolerance) { fits=false; break; }
            }
            if(!fits) break;
            end=candidate;
        }
        return end;
    }
    void strip(Stream &s, int y, int yy, int a, int b, int color) const {
        int c=int(centers[y]/256), cc=int(centers[yy]/256);
        s.quad(c+edge(y,a),c+edge(y,b),y,
               cc+edge(yy,a),cc+edge(yy,b),yy,color);
    }
    void render(Stream &s, int32_t phase, int32_t position=0, int32_t cameraOffset=0, bool fillSky=true) {
        project(position,phase,cameraOffset);
        s.size=0; s.overflow=false; bands=0;
        if(fillSky) s.rect(0,0,319,RoadTop-1,4);
        s.rect(0,RoadTop,319,223,2);
        int y=RoadTop;
        while(y<=Bottom) {
            int end=bandEnd(y);
            strip(s,y,end+1,-KerbOuterWidth,KerbOuterWidth,paint[y]?9:15);
            strip(s,y,end+1,-RoadHalfWidth,RoadHalfWidth,8);
            // Two-unit inset shoulder stripe; paired overdraw avoids extra edges.
            strip(s,y,end+1,-86,86,paint[y]?11:15);
            strip(s,y,end+1,-84,84,8);
            if(paint[y]) strip(s,y,end+1,-2,2,11);
            ++bands;
            y=end+1;
        }
        s.rect(0,224,319,239,0);
    }
};
}
