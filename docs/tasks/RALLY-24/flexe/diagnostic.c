/* Task-only wrapper. Production module and runtime ABI stay unchanged. */
#define R24_ENTRY_VISIBILITY static
#define vdplet_entry rally_entry
#include "../experiment/module.c"
#undef vdplet_entry
static unsigned sample;
static uint32_t start_count, generation;
static int result;
static inline uint32_t cycles(void) {
    uint32_t n;
    __asm__ volatile("rsr.ccount %0" : "=a"(n));
    return n;
}
static __attribute__((noinline)) int finish(const vdplet_host_v1 *h) {
    uint32_t end = cycles();
    vdplet_view_v1 log = {0}, status = {0}, data = {0};
    int rc = acquire(h, 31012, VDPL_WRITE, &log);
    if (rc) return rc;
    if (log.bytes != 32 * 32) { release(h, &log); return VDPL_E_BOUNDS; }
    uint8_t *p = log.data + 32 * sample++;
    w32(p, sample); w32(p+4, generation); w32(p+8, start_count);
    w32(p+12, end); w32(p+28, result);
    if (generation) {
        rc = acquire(h, 31004, VDPL_READ, &status);
        if (!rc && status.bytes == 32 && status.data[0] == 1) {
            for (unsigned i=0; i<3; ++i) {
                rc = acquire(h, 31005+i, VDPL_READ, &data);
                unsigned n=u16(status.data+12+i*2);
                if (rc || n>data.bytes) { rc=VDPL_E_BOUNDS; break; }
                w32(p+16+i*4, hash(data.data,n));
                release(h,&data);
            }
        } else rc=VDPL_E_ARGUMENT;
    }
    if (rc) w32(p+28,rc);
    release(h,&data); release(h,&status); release(h,&log);
    return rc;
}
__attribute__((visibility("default"))) int32_t vdplet_entry(const vdplet_host_v1 *h,
                                                           const vdplet_request_v1 *r) {
    if (r->operation != VDPL_RUN || r->entry_id == 0) {
        sample = 0;
        return rally_entry(h, r);
    }
    if (r->entry_id == 1) {
        start_count = cycles();
        result = rally_entry(h, r);
        generation = cycles() - start_count;
        return result;
    }
    /* Entry 3 starts a replay measurement; entry 2 ends either type after swap.
       Hashing happens after the end timestamp, still adds diagnostic batch cost. */
    if (r->entry_id == 3) {
        start_count = cycles(); generation = 0; result = 0;
        return 0;
    }
    if (r->entry_id != 2 || sample >= 32) return VDPL_E_BOUNDS;
    return finish(h);
}
