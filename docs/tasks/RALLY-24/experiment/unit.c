/* Bounds/rounding leaf tests with actual candidate source, run under sanitizers. */
#include "module.c"
#include <assert.h>
#include <stdio.h>
int main(void) {
    uint8_t guarded[512];
    for (unsigned i = 0; i < sizeof(guarded); ++i)
        guarded[i] = 0xcc;
    for (unsigned cap = 0; cap < 160; ++cap) {
        for (unsigned i = 0; i < sizeof(guarded); ++i)
            guarded[i] = 0xcc;
        Out out = {guarded + 1, 0, cap, 0};
        section(&out, -100, 500, 104, 224, 1);
        end(&out);
        assert(guarded[0] == 0xcc);
        for (unsigned i = cap + 1; i < sizeof(guarded); ++i)
            assert(guarded[i] == 0xcc);
        assert(out.error == (cap < (VDPL_VARIANT == 1 ? 31u : 141u)));
        assert(out.n <= cap);
    }
    assert(nearest(-128) == -1 && nearest(128) == 1 && nearest(-127) == 0);
    puts("capacity canaries and signed half-pixel rounding passed");
    return 0;
}
