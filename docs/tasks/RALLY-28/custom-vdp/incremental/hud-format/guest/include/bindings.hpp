#pragma once
#include <stdint.h>
// Frozen original native simulation ABI; generated from interface/backends.
// Module length is supplied by the per-variant R28F configuration, not code.
namespace fs {
constexpr uint32_t Root=1;
constexpr uint32_t RootBytes=310;
constexpr uint32_t Args=9;
constexpr uint32_t Staging=50305;
constexpr uint32_t Completion=50304;
constexpr uint32_t Init=13;
constexpr uint32_t Tick=3;
constexpr uint32_t Render=15;
constexpr uint32_t Stop=16;
constexpr uint32_t TickWrapper=13;
constexpr uint32_t HandleOffset=37;
constexpr uint32_t PlayerStation=198;
constexpr uint32_t PlayerLateral=202;
constexpr uint32_t RenderPhase=304;
constexpr uint32_t RenderSteering=306;
constexpr uint32_t RenderFlags=308;
constexpr uint32_t RenderRequest=296;
constexpr uint32_t PlayerUnwrapped=300;
constexpr uint32_t WorldTick=136;
constexpr uint32_t FrameCount=900;
constexpr uint32_t WrapperCount=17;
constexpr uint32_t StateBytes=406;
constexpr uint32_t PositionBuffer=4;
constexpr uint32_t LateralBuffer=5;
constexpr uint32_t SpanBuffer=50700;
constexpr uint32_t SamplerFirst=50710;
constexpr uint16_t Wrappers[]={10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26};
constexpr uint16_t Outputs[]={50301,50302,50303};
struct Buffer {uint16_t id,offset,bytes;};
constexpr Buffer Buffers[]={{1,0,310},{2,0,12},{3,0,24},{4,0,24},{5,0,24},{6,0,12}};
}
