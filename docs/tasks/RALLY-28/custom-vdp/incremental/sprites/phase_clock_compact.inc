/* R28 diagnostic only. Raw per-core CCOUNT values, never calibrated time. */
#include <string.h>
#if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
#error "Compact phase serialization requires the pinned little-endian target/host"
#endif
#define PHASE_LOG_BUFFER 50305u /* Reuse module upload staging only AFTER LOAD. */
#define PHASE_HEADER_BYTES 32u
#define PHASE_ROW_BYTES 52u
#define PHASE_MAX_FRAMES 128u
#define PHASE_FIRST_ENTRY 60000u
/* A shared base avoids repeated separate global-address literals on Xtensa. */
static struct {
    uint32_t values[13],progress,count,capacity,enabled,core;
    int32_t error;
} phase_state;
#define phase_values phase_state.values
#define phase_count phase_state.count
#define phase_capacity phase_state.capacity
#define phase_enabled phase_state.enabled
#define phase_progress phase_state.progress
#define phase_core phase_state.core
#define phase_error phase_state.error
#if defined(__XTENSA__)
static inline uint32_t phase_clock(void) {
    uint32_t value;
    __asm__ __volatile__("rsr.ccount %0" : "=a"(value) :: "memory");
    return value;
}
static inline uint32_t phase_cpu(void) {
    uint32_t value;
    __asm__ __volatile__("rsr.prid %0" : "=a"(value) :: "memory");
    return value;
}
#else
/* Host protocol proof only; these values must NEVER become timing evidence. */
static uint32_t phase_host_clock;
static inline uint32_t phase_clock(void) { return phase_host_clock += 17u; }
static inline uint32_t phase_cpu(void) { return 0u; }
#endif

static void phase_u16(uint8_t *p, uint16_t v) {p[0]=v;p[1]=v>>8;}
static void phase_u32(uint8_t *p, uint32_t v) {
    phase_u16(p,(uint16_t)v);phase_u16(p+2,(uint16_t)(v>>16));
}
static int32_t phase_bad(int32_t error) {phase_error=error;return error;}
static int32_t phase_view(const vdplet_host_v1 *h, vdplet_view_v1 *v) {
    *v=(vdplet_view_v1){sizeof(*v),0,0,0,0};
    int32_t rc=h->buffer_acquire(h->context,PHASE_LOG_BUFFER,VDPL_WRITE,
                               0,VDPL_WHOLE_BUFFER,v);
    if(rc)return phase_bad(rc);
    uint32_t payload=v->bytes-PHASE_HEADER_BYTES;
    uint32_t row_bytes=PHASE_ROW_BYTES;
    /* Keep a single hardware remainder instruction on the pinned Xtensa
       compiler instead of expanding constant division into a magic multiply
       and shifts. The empty register constraint leaves the value unchanged. */
    __asm__("" : "+r"(row_bytes));
    if(!v->lease || !v->data || payload>PHASE_ROW_BYTES*PHASE_MAX_FRAMES ||
       payload%row_bytes || !(v->access&VDPL_WRITE)) {
        if(v->lease)h->buffer_release(h->context,v->lease);
        return phase_bad(VDPL_E_BOUNDS);
    }
    return VDPL_OK;
}
static int32_t phase_private(const vdplet_host_v1 *h, unsigned entry) {
    unsigned op=entry-PHASE_FIRST_ENTRY;
    if(op==0) {
        vdplet_view_v1 v;int32_t rc=phase_view(h,&v);if(rc)return rc;
        uint32_t capacity=(v.bytes-PHASE_HEADER_BYTES)/PHASE_ROW_BYTES;
        if(!capacity){h->buffer_release(h->context,v.lease);return phase_bad(VDPL_E_BOUNDS);}
        memset(v.data,0,v.bytes);
        memset(&phase_state,0,sizeof(phase_state));
        phase_capacity=capacity;
        phase_core=phase_cpu();
        uint32_t minimum=UINT32_MAX,maximum=0;
        for(unsigned i=0;i<16;++i){uint32_t a=phase_clock(),b=phase_clock(),d=b-a;
            if(d<minimum)minimum=d;if(d>maximum)maximum=d;}
        /* Stack words are aligned; memcpy still supports unaligned host views.
           The header bytes remain exactly the original little-endian schema. */
        uint32_t header[8]={0x43383250u,1u|(PHASE_ROW_BYTES<<16),phase_capacity,
                            1u<<16,minimum,maximum,phase_core,0};
        memcpy(v.data,header,sizeof(header));
        rc=h->buffer_release(h->context,v.lease);
        phase_enabled=rc?0:1;return rc?phase_bad(rc):0;
    }
    if(!phase_enabled)return phase_bad(VDPL_E_INIT);
    if(phase_error)return phase_error;
    if(phase_cpu()!=phase_core)return phase_bad(VDPL_E_UNSUPPORTED);
    if(op==8)return (phase_progress ||
                         phase_count!=phase_capacity)?phase_bad(VDPL_E_ARGUMENT):0;
    if(op<1 || op>7)return phase_bad(VDPL_E_UNSUPPORTED);
    /* Equivalent finite state: ticks0..4, prepared5, markers6..12. The
       public record still contains all original thirteen counter fields. */
    if(phase_progress!=op+4)
        return phase_bad(VDPL_E_ARGUMENT);
    phase_values[op+5]=phase_clock();
    ++phase_progress;
    if(op!=7)return 0;
    if(phase_count>=phase_capacity)return phase_bad(VDPL_E_LIMIT);
    vdplet_view_v1 v;int32_t rc=phase_view(h,&v);if(rc)return rc;
    if(v.bytes!=PHASE_HEADER_BYTES+phase_capacity*PHASE_ROW_BYTES) {
        h->buffer_release(h->context,v.lease);return phase_bad(VDPL_E_BOUNDS);
    }
    phase_values[0]=phase_count+1;
    memcpy(v.data+PHASE_HEADER_BYTES+phase_count*PHASE_ROW_BYTES,
           phase_values,sizeof(phase_values));
    ++phase_count;phase_u16(v.data+10,(uint16_t)phase_count);
    rc=h->buffer_release(h->context,v.lease);if(rc)return phase_bad(rc);
    memset(&phase_state,0,sizeof(phase_values)+sizeof(phase_progress));
    return 0;
}
