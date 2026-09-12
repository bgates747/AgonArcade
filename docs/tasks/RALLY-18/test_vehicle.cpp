#include "vehicle.hpp"
#include "road.hpp"
#include "car.hpp"
#include <assert.h>
#include <math.h>
#include <stdio.h>
#include <initializer_list>

namespace {
using namespace rally;
using namespace rally::r18;
constexpr double Tau=6.283185307179586476925286766559;

bool equal(Pose a,Pose b) { return a.view==b.view && a.mirrored==b.mirrored; }
bool black(int view,int x,int y) {
    return CarPixels[view][(y*48/77)*64+x*64/102]==0xc0;
}

void controlPoses() {
    Motion motion;
    for(int steering=-21;steering<=21;++steering) {
        motion.steering=steering;
        for(int x=-200;x<=520;++x) {
            auto pose=playerPose(steering,x,false);
            assert(pose.view==motion.view());
            assert(pose.mirrored==motion.mirrored());
        }
    }
    for(int cross=-5000;cross<=5000;++cross) {
        int magnitude=cross<0?-cross:cross;
        Pose original={uint8_t(magnitude<264?0:magnitude<787?1:magnitude<1297?2:magnitude<1785?3:4),cross>0};
        assert(equal(trafficPose(cross,20,false),original));
        assert(equal(trafficPose(cross,300,false),original));
    }
}

void placement() {
    Motion motion;
    assert(PlayerDrawY+PlayerAnchorY==PlayerContactY);
    int left=102,right=-1,last=-1;
    for(int y=55;y<77;++y) for(int x=0;x<102;++x) if(black(0,x,y)) {
        if(x<left) left=x;
        if(x>right) right=x;
        if(y>last) last=y;
    }
    assert(left==23 && right==79 && last==59);
    assert((left+right)/2==PlayerAnchorX);
    assert(101-PlayerAnchorX==PlayerMirrorAnchorX);
    double projectedHalf=CarHalfWidth*double(PlayerProjectionQ)/CameraHeight;
    assert(fabs(projectedHalf-(right-left)/2.0)<0.5);
    for(int centre: {123,160,197}) {
        motion.lateral=0;
        assert(playerCenterX(motion,centre)==centre);
        assert(playerDrawX(motion,centre,false)+PlayerAnchorX==centre);
        assert(playerDrawX(motion,centre,true)+PlayerMirrorAnchorX==centre);
        for(int side: {-1,1}) {
            motion.lateral=side*78L*256;
            assert(motion.surface()==Surface::Road);
            // Tyres meet the asphalt edge within one raster pixel. Actual
            // surface decisions remain exact world-space tests in Motion.
            int outer=playerCenterX(motion,centre)+side*(right-left)/2;
            int edge=centre+side*Road::edge(PlayerContactY,RoadHalfWidth);
            assert(abs(outer-edge)<=1);
            motion.lateral+=side;
            assert(motion.surface()==Surface::Kerb);
            motion.lateral=side*94L*256;
            assert(motion.surface()==Surface::Kerb);
            outer=playerCenterX(motion,centre)+side*(right-left)/2;
            edge=centre+side*Road::edge(PlayerContactY,KerbOuterWidth);
            assert(abs(outer-edge)<=1);
            motion.lateral+=side;
            assert(motion.surface()==Surface::Grass);
        }
    }
    int previous=-10000;
    for(int lateral=-150*256;lateral<=150*256;++lateral) {
        motion.lateral=lateral;
        int x=playerCenterX(motion);
        assert(x>=previous);
        previous=x;
        motion.lateral=-lateral;
        assert(playerCenterX(motion)+x==320);
    }
    motion.lateral=-150L*256;
    assert(playerDrawX(motion)+102<0); // Deliberate extreme clipping.
    motion.lateral=150L*256;
    assert(playerDrawX(motion)>319);
}

void perspective(double &bearingError,double &headingError) {
    bearingError=headingError=0;
    int previous=-32768;
    for(int x=-352;x<=672;++x) {
        int actual=viewingBearing(x);
        double expected=atan(double(x-160)/160)*65536/Tau;
        double error=fabs(actual-expected);
        if(error>bearingError) bearingError=error;
        assert(error<1.1);
        assert(actual>=previous);previous=actual;
        assert(actual==-viewingBearing(320-x));
    }
    assert(viewingBearing(-10000)==viewingBearing(-352));
    assert(viewingBearing(10000)==viewingBearing(672));
    previous=-32768;
    for(int cross=-4096;cross<=4096;++cross) {
        int actual=headingFromCross(cross);
        double expected=asin(double(cross)/4096)*65536/Tau;
        double error=fabs(actual-expected);
        if(error>headingError) headingError=error;
        assert(error<1.5);
        assert(actual>=previous);previous=actual;
        assert(actual==-headingFromCross(-cross));
    }
    assert(headingFromCross(-5000)==headingFromCross(-4096));
    assert(headingFromCross(5000)==headingFromCross(4096));
    for(int x=-50;x<=370;++x) {
        auto rear=playerPose(0,x,true);
        auto traffic=trafficPose(0,x,true);
        assert(equal(rear,traffic));
        assert(rear.view<=4);
        assert(rear.mirrored==(x<160));
        auto reflected=playerPose(0,320-x,true);
        assert(rear.view==reflected.view);
        for(int steering=-21;steering<=21;++steering) {
            auto pose=playerPose(steering,x,true);
            auto other=playerPose(-steering,320-x,true);
            assert(pose.view==other.view);
            if(steering*256!=viewingBearing(x)) assert(pose.mirrored!=other.mirrored);
        }
    }
    assert(equal(playerPose(0,160,true),Pose{0,false}));
    assert(equal(trafficPose(0,160,true),Pose{0,false}));
    // Same lateral lane at increasingly distant depths: appearance converges
    // toward the rear view because projected lateral displacement decreases.
    unsigned lastView=4;
    for(int q: {125,80,40,20,8}) {
        int x=160+45*q/50;
        auto pose=trafficPose(0,x,true);
        assert(pose.view<=lastView);lastView=pose.view;
        assert(!pose.mirrored);
    }
    assert(lastView==0);
    // Rightward heading and a matching rightward viewing bearing cancel.
    assert(trafficPose(1295,160,true).view==2);
    assert(trafficPose(1295,213,true).view==0);
    assert(trafficPose(1295,107,true).view==4);
    assert(playerPose(14,160,true).mirrored);
    assert(!playerPose(-14,160,true).mirrored);
    assert(playerPose(21,-100,true).view==4);
    assert(playerPose(-21,420,true).view==4);
    // A monotonic line-of-sight sweep cannot jump over a source view. Mirror
    // changes happen only while the selected view is the symmetric rear view.
    for(int steering=-21;steering<=21;++steering) {
        auto before=playerPose(steering,-50,true);
        for(int x=-49;x<=370;++x) {
            auto after=playerPose(steering,x,true);
            assert(abs(int(after.view)-int(before.view))<=1);
            if(after.mirrored!=before.mirrored) assert(after.view==0 && before.view==0);
            before=after;
        }
    }
}
}

int main() {
    controlPoses();placement();
    double bearingError,headingError;
    perspective(bearingError,headingError);
    printf("vehicle tests passed: bearing max %.6f degrees; heading max %.6f degrees; tables %zu bytes\n",
           bearingError*360/65536,headingError*360/65536,sizeof(BearingAngles)+sizeof(HeadingAngles));
}
