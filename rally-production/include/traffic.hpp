#include "tuning.hpp"
#pragma once
#include "road.hpp"
namespace rally {
constexpr int TrafficCount=6;
constexpr unsigned LiveryCount=TrafficCount+1;
constexpr unsigned TrafficMatrixBase=63970; // Keep clear of player mirror 63984.
constexpr uint8_t rgb(unsigned r,unsigned g,unsigned b) { return 0xc0|r|(g<<2)|(b<<4); }
// Dark/base/highlight body, complementary stripe/wing, contrasting helmet.
// Exact RGB222 entries; lookup tables are uploaded; VDP command 72 substitutes pixels.
inline uint8_t carColour(uint8_t pixel,unsigned livery) {
    static const uint8_t colours[TrafficCount][6]={
        {rgb(0,0,2),rgb(0,0,3),rgb(0,1,3),rgb(3,1,0),rgb(3,2,1),rgb(3,3,0)}, // blue/orange
        {rgb(0,1,0),rgb(0,1,0),rgb(0,2,0),rgb(3,0,0),rgb(3,2,2),rgb(3,3,3)}, // BRG/red
        {rgb(2,2,0),rgb(3,3,0),rgb(3,3,1),rgb(2,0,3),rgb(2,1,3),rgb(0,0,3)}, // yellow/violet
        {rgb(0,2,2),rgb(0,3,3),rgb(1,3,3),rgb(3,0,0),rgb(3,1,1),rgb(3,3,3)}, // cyan/red
        {rgb(2,1,2),rgb(2,1,3),rgb(3,2,3),rgb(3,3,0),rgb(3,3,1),rgb(0,1,0)}, // lavender/yellow
        {rgb(2,1,0),rgb(3,1,0),rgb(3,2,0),rgb(0,1,3),rgb(1,2,3),rgb(0,3,3)}, // orange/blue
    };
    if(livery==0 || livery>=LiveryCount) return pixel;
    const auto &c=colours[livery-1];
    switch(pixel) {
        case 0xc2:return c[0]; case 0xc3:return c[1]; case 0xc7:return c[2];
        case 0xcf:return c[3]; // nose stripe
        case 0xef:return c[4]; // cream wings
        case 0xf8:return c[5]; // cyan helmet, dark visor preserved
        default:return pixel; // tyres, metal, visor and transparent pixels
    }
}
struct Opponent {
    int32_t position=0;
    int speed=0, lane=0;
    void tick(int32_t lap) { position=(position+speed*WorldSpeedMultiplier)%lap; }
};
struct Traffic {
    Opponent cars[TrafficCount];
    void init(int32_t start,int32_t lap) {
        for(int i=0;i<TrafficCount;++i) cars[i]={int32_t((start+(160L+i*90L)*100)%lap),140+(i%3)*20,((i%3)-1)*45};
    }
    void tick(int32_t lap) { for(auto &car:cars) car.tick(lap); }
    static int32_t ahead(int32_t position,int32_t player,int32_t lap) {
        return (position-player+lap)%lap;
    }
};
}
