/* Host-only wrappers around the actual candidate's pure planner and sampler.
   Owned by sampler unit qualification; no target ABI or renderer replacement. */
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int32_t bitmap, matrix, scale, xx, translation, x, y;
} Car;

#define R28_SPRITE_UNIT_ONLY 1
#include "sprite.inc"

_Static_assert(sizeof(R28SpritePlan) == 11 * sizeof(int), "unit plan layout");

int sampler_unit_plan(const Car *car, int sign, int cliptop, int *result) {
    R28SpritePlan plan;
    memset(&plan, 0x5a, sizeof(plan));
    int rc = r28_sprite_plan(car, sign, cliptop, &plan);
    if (rc) memcpy(result, &plan, sizeof(plan));
    return rc;
}

int sampler_unit_sample(uint8_t *destination, const uint8_t *source, const int *input) {
    R28SpritePlan plan;
    memcpy(&plan, input, sizeof(plan));
    unsigned source_bytes = (unsigned)(plan.source_width * plan.source_height);
    unsigned rows = plan.source_width == 102 ? 75u : 62u;
    unsigned destination_bytes = (unsigned)plan.stride * rows;
    uint8_t *src = malloc(source_bytes);
    uint8_t *allocation = malloc(destination_bytes + 64u);
    if (!src || !allocation) { free(src); free(allocation); return -1; }
    memcpy(src, source, source_bytes);
    memset(allocation, 0xd7, destination_bytes + 64u);
    memcpy(allocation + 32u, destination, destination_bytes);
    r28_sprite_sample(allocation + 32u, src, &plan);
    int bad = 0;
    for (unsigned i = 0; i < 32u; ++i)
        if (allocation[i] != 0xd7 || allocation[32u + destination_bytes + i] != 0xd7) bad = 1;
    memcpy(destination, allocation + 32u, destination_bytes);
    free(src);
    free(allocation);
    return bad;
}
