/* INC-001-03: exact byte coverage with aligned repeated-colour word stores.
   Callers retain the existing clipped, half-open endpoints. The buffer ABI
   promises byte storage, so align the actual destination rather than assuming
   allocation alignment. GCC's may_alias type permits these word accesses to
   the retained byte array without disabling strict aliasing for the module. */
#include <stdint.h>
typedef uint32_t R28SpanWord __attribute__((__may_alias__));
static __attribute__((noinline)) void r28_span_fill(uint8_t *row, int left, int right, uint8_t colour) {
    if (left >= right) return;
    uint8_t *p = row + left;
    unsigned bytes = (unsigned)(right - left);
    while (bytes && ((uintptr_t)p & 3u)) {
        *p++ = colour;
        --bytes;
    }
    const uint32_t repeated = (uint32_t)colour * UINT32_C(0x01010101);
    while (bytes >= 4u) {
        *(R28SpanWord *)(void *)p = repeated;
        p += 4;
        bytes -= 4u;
    }
    while (bytes) {
        *p++ = colour;
        --bytes;
    }
}
