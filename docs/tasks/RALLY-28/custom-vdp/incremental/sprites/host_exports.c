/* Test-only visibility into the real generated module's renderer context. */
#include "native.c"
void host_actor(unsigned slot, int32_t *out) {
    const RallyRenderActorScratchV1 *actor = slot < 6 ? &renderer.cars[slot] : &renderer.signs[slot - 6];
    memcpy(out, actor, sizeof(*actor));
}
