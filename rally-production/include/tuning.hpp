#pragma once
// World-distance advance per speed unit. 1 = previous scale; 2 = double.
#ifndef RALLY_WORLD_SPEED_MULTIPLIER
#define RALLY_WORLD_SPEED_MULTIPLIER 2
#endif
namespace rally {
constexpr int WorldSpeedMultiplier = RALLY_WORLD_SPEED_MULTIPLIER;
static_assert(WorldSpeedMultiplier > 0, "World speed multiplier must be positive");
}
