#pragma once
#include <stdint.h>
#include "track.hpp"
namespace rally {
constexpr int Horizon = 96, RoadTop = 103, CameraHeight = 50;
constexpr int Bottom = 223, Period = 80;
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
inline Sample trackSample(int32_t distanceQ8) {
    unsigned index=unsigned(distanceQ8>>14)&(TrackCount-1);
    int32_t f=distanceQ8&16383;
    const auto &a=Track[index]; const auto &b=Track[(index+1)&(TrackCount-1)];
    return {int32_t(a.x)*256+((int32_t(b.x-a.x)*f)>>6),
            int32_t(a.y)*256+((int32_t(b.y-a.y)*f)>>6),
            a.tx+((int32_t(b.tx-a.tx)*f)>>14),
            a.ty+((int32_t(b.ty-a.ty)*f)>>14)};
}
struct Motion {
    int32_t phase=0, position=0, speed=0;
    int32_t lateral=0, lateralVelocity=0; // Q8 world units, Q8 units/sec
    int steering=0, yawStep=0;
    bool offroad() const { return lateral>78L*256 || lateral< -78L*256; }
    int view() const { return 4-yawStep; } // Blender positive yaw turns toward -X.
    int carX() const { return 128+int(lateral*3/1024); }
    int32_t cameraOffset() const { return lateral*2/3; }
    void steerFrame(bool left, bool right) {
        // Called exactly once per rendered frame, independent of key repeat.
        if(left!=right) {
            if(left && yawStep> -4) --yawStep;
            if(right && yawStep<4) ++yawStep;
        }
        steering=yawStep*250;
    }
    void tick(bool accelerate, bool brake) {
        speed+=brake?-4:accelerate?2:0;
        if(offroad() && speed>90) speed-=4;
        if(speed<0) speed=0;
        if(speed>300) speed=300;
        int32_t p=(position/100)*256+(position%100)*256/100;
        Sample a=trackSample(p), b=trackSample(p+64L*256);
        int32_t bend=(a.tx*b.ty-a.ty*b.tx)/4096;
        int32_t outward= -speed*speed*bend/737280L;
        int32_t wanted=(int32_t(steering)*speed/1500+outward)*256;
        lateralVelocity+=(wanted-lateralVelocity)/12;
        if(speed==0) lateralVelocity=0;
        lateral+=lateralVelocity/100;
        if(lateral>150L*256) { lateral=150L*256; lateralVelocity=0; }
        if(lateral< -150L*256) { lateral= -150L*256; lateralVelocity=0; }
        position=(position+speed)%(TrackLength*100);
        phase=(phase+speed)%(Period*100);
    }
};
struct Road {
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
        Sample camera=trackSample(p);
        for(int y=RoadTop;y<=Bottom+1;++y) {
            Sample ahead=trackSample(p+depthQ8[y-Horizon]);
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
    void render(Stream &s, int32_t phase, int32_t position=0, int32_t cameraOffset=0) {
        project(position,phase,cameraOffset);
        s.size=0; s.overflow=false; bands=0;
        s.rect(0,0,319,RoadTop-1,4);
        s.rect(0,RoadTop,319,223,2);
        int y=RoadTop;
        while(y<=Bottom) {
            int end=bandEnd(y);
            strip(s,y,end+1,-98,98,paint[y]?9:15);
            strip(s,y,end+1,-90,90,8);
            if(paint[y]) strip(s,y,end+1,-2,2,11);
            ++bands;
            y=end+1;
        }
        s.rect(0,224,319,239,0);
    }
};
}
