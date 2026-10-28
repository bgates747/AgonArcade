/* R28 diagnostic only. Raw per-core CCOUNT values, never calibrated time. */
#define PHASE_LOG_BUFFER 50305u /* Reuse module upload staging only AFTER LOAD. */
#define PHASE_HEADER_BYTES 32u
#define PHASE_ROW_BYTES 52u
#define PHASE_MAX_FRAMES 128u
#define PHASE_FIRST_ENTRY 60000u
static uint32_t phase_values[13], phase_count, phase_capacity, phase_stage;
static uint32_t phase_enabled, phase_ticks, phase_rendered, phase_core;
static int32_t phase_error;
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
    if(!v->lease || !v->data || v->bytes<PHASE_HEADER_BYTES ||
       v->bytes>PHASE_HEADER_BYTES+PHASE_ROW_BYTES*PHASE_MAX_FRAMES ||
       (v->bytes-PHASE_HEADER_BYTES)%PHASE_ROW_BYTES || !(v->access&VDPL_WRITE)) {
        if(v->lease)h->buffer_release(h->context,v->lease);
        return phase_bad(VDPL_E_BOUNDS);
    }
    return VDPL_OK;
}
static int32_t phase_private(const vdplet_host_v1 *h, unsigned entry) {
    unsigned op=entry-PHASE_FIRST_ENTRY;
    if(op==0) {
        vdplet_view_v1 v;int32_t rc=phase_view(h,&v);if(rc)return rc;
        phase_capacity=(v.bytes-PHASE_HEADER_BYTES)/PHASE_ROW_BYTES;
        if(!phase_capacity){h->buffer_release(h->context,v.lease);return phase_bad(VDPL_E_BOUNDS);}
        for(unsigned i=0;i<v.bytes;++i)v.data[i]=0;
        for(unsigned i=0;i<13;++i)phase_values[i]=0;
        phase_count=phase_stage=phase_ticks=phase_rendered=0;phase_error=0;
        phase_core=phase_cpu();
        uint32_t minimum=UINT32_MAX,maximum=0;
        for(unsigned i=0;i<16;++i){uint32_t a=phase_clock(),b=phase_clock(),d=b-a;
            if(d<minimum)minimum=d;if(d>maximum)maximum=d;}
        phase_u32(v.data,0x43383250u); /* P28C */
        phase_u16(v.data+4,1);phase_u16(v.data+6,PHASE_ROW_BYTES);
        phase_u16(v.data+8,(uint16_t)phase_capacity);
        phase_u16(v.data+14,1); /* raw CCOUNT, no Hz assertion */
        phase_u32(v.data+16,minimum);phase_u32(v.data+20,maximum);
        phase_u32(v.data+24,phase_core);
        rc=h->buffer_release(h->context,v.lease);
        phase_enabled=rc?0:1;return rc?phase_bad(rc):0;
    }
    if(!phase_enabled)return phase_bad(VDPL_E_INIT);
    if(phase_error)return phase_error;
    if(phase_cpu()!=phase_core)return phase_bad(VDPL_E_UNSUPPORTED);
    if(op==8)return (phase_stage || phase_ticks || phase_rendered ||
                         phase_count!=phase_capacity)?phase_bad(VDPL_E_ARGUMENT):0;
    if(op<1 || op>7)return phase_bad(VDPL_E_UNSUPPORTED);
    if(op!=phase_stage+1 || phase_ticks!=4 || phase_rendered!=1)
        return phase_bad(VDPL_E_ARGUMENT);
    phase_values[op+5]=phase_clock();
    phase_stage=op;
    if(op!=7)return 0;
    if(phase_count>=phase_capacity)return phase_bad(VDPL_E_LIMIT);
    vdplet_view_v1 v;int32_t rc=phase_view(h,&v);if(rc)return rc;
    if(v.bytes!=PHASE_HEADER_BYTES+phase_capacity*PHASE_ROW_BYTES) {
        h->buffer_release(h->context,v.lease);return phase_bad(VDPL_E_BOUNDS);
    }
    phase_values[0]=phase_count+1;
    for(unsigned i=0;i<13;++i)
        phase_u32(v.data+PHASE_HEADER_BYTES+phase_count*PHASE_ROW_BYTES+i*4,phase_values[i]);
    ++phase_count;phase_u16(v.data+10,(uint16_t)phase_count);
    rc=h->buffer_release(h->context,v.lease);if(rc)return phase_bad(rc);
    for(unsigned i=0;i<13;++i)phase_values[i]=0;
    phase_stage=phase_ticks=phase_rendered=0;
    return 0;
}
