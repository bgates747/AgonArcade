/* Host-only visibility; neither this file nor capture code enters the target. */
#include <stdint.h>
#include <stddef.h>
#ifdef R28_HOST_CAPTURE
static uint8_t *host_span_base;
static uint32_t host_span_count, host_span_overflow;
static int32_t host_span_rows[20000][4];
static void host_record_span(uint8_t *row, int left, int right, uint8_t colour) {
    if (!host_span_base) return;
    if (host_span_count >= 20000u) { host_span_overflow = 1; return; }
    int32_t *out = host_span_rows[host_span_count++];
    out[0] = (int32_t)(row - host_span_base);
    out[1] = left; out[2] = right; out[3] = colour;
}
void host_capture_begin(uint8_t *base) {
    host_span_base = base; host_span_count = host_span_overflow = 0;
}
uint32_t host_capture_count(void) { return host_span_count; }
uint32_t host_capture_overflow(void) { return host_span_overflow; }
void host_capture_read(uint32_t i, int32_t *out) {
    for (unsigned j = 0; j < 4; ++j) out[j] = host_span_rows[i][j];
}
#endif
#include "native.c"
void host_actor(unsigned slot, int32_t *out) {
    const RallyRenderActorScratchV1 *actor = slot < 6 ? &renderer.cars[slot] : &renderer.signs[slot - 6];
    memcpy(out, actor, sizeof(*actor));
}
