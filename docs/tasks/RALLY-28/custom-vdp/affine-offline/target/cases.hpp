#pragma once
#include <stdint.h>
struct AffineCase {const char *name;uint16_t source;int matrix[6];int x,y,minX,minY;int clip[4];};
constexpr unsigned CaseCount=6;
constexpr AffineCase Cases[]={
{"traffic-far",64005,{-14,0,1414,0,14,0},153,100,0,0,{0,24,319,223}},
{"traffic-middle",64015,{76,0,0,0,76,0},172,114,0,0,{0,24,319,223}},
{"traffic-near",64030,{246,0,0,0,246,0},199,152,0,0,{0,88,319,223}},
{"sign-far",64120,{32,0,0,0,32,0},198,104,0,0,{0,104,319,223}},
{"sign-near",64123,{136,0,0,0,136,0},-23,130,0,0,{0,104,319,223}},
{"player-fixed-mirror",64000,{-256,0,25856,0,256,0},110,154,-1,0,{0,24,319,223}},
};
