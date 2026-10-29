/* INC-001-03 isolated fill replay. Raw CCOUNT is not physical CPU cycles. */
#include "vdplet.h"
#include <stddef.h>
#include <stdint.h>
#if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
#error "Pinned probe wire format requires little endian"
#endif
typedef struct {uint16_t row,left,right;uint8_t colour,reserved;} PhaseSpan;
_Static_assert(sizeof(PhaseSpan)==8,"Pinned span input record size");

#define PH_INPUT 50900u
#define PH_BYTE 50901u
#define PH_WIDE 50902u
#define PH_LOG 50903u
#define PH_PIXELS 38400u
#define PH_SCRATCH 38432u
#define PH_REPEATS 8u
#define PH_HEADER 32u
#define PH_ROW 56u
#define PH_INPUT_HEADER 32u
#define PH_DESC 32u

#ifdef __XTENSA__
static inline uint32_t phase_clock(void) { uint32_t x; __asm__ __volatile__("rsr.ccount %0":"=a"(x)::"memory"); return x; }
static inline uint32_t phase_cpu(void) { uint32_t x; __asm__ __volatile__("rsr.prid %0":"=a"(x)::"memory"); return x; }
#else
static uint32_t phase_fake_clock;
static inline uint32_t phase_clock(void) { return phase_fake_clock+=17u; }
static inline uint32_t phase_cpu(void) { return 0; }
#endif

/* Exact native.c byte implementation, with its original -fno-builtin build. */
void *memset(void *d,int v,size_t n) { uint8_t *a=d; for(size_t i=0;i<n;++i)a[i]=(uint8_t)v; return d; }

/* Exact frozen render_core.inc body; only name and noinline are diagnostic. */
static __attribute__((noinline)) void phase_byte(uint8_t *row,int left,int right,uint8_t colour) {
    if (left < right) memset(row + left, colour, (unsigned)(right - left));
}

/* The builder copies the actual candidate primitive into this include. */
#define r28_span_fill phase_wide
#include "phase_wide.inc"
#undef r28_span_fill

static __attribute__((noinline)) void phase_empty(uint8_t *row,int left,int right,uint8_t colour) {
#ifdef __XTENSA__
    __asm__ __volatile__(""::"a"(row),"a"(left),"a"(right),"a"(colour):"memory");
#else
    (void)row;(void)left;(void)right;(void)colour;
#endif
}

static uint16_t get16(const uint8_t *p) { return (uint16_t)p[0]|(uint16_t)p[1]<<8; }
static uint32_t get32(const uint8_t *p) { return (uint32_t)get16(p)|(uint32_t)get16(p+2)<<16; }
static void put32(uint8_t *p,uint32_t n) { for(unsigned i=0;i<4;++i)p[i]=(uint8_t)(n>>(i*8)); }
static uint32_t phase_crc(const uint8_t *p,unsigned n) {
    uint32_t c=UINT32_MAX;
    while(n--) { c^=*p++; for(unsigned k=0;k<8;++k)c=(c>>1)^((0u-(c&1u))&UINT32_C(0xedb88320)); }
    return ~c;
}
typedef void (*PhaseFill)(uint8_t *,int,int,uint8_t);
static __attribute__((noinline)) void phase_replay(PhaseFill fn,uint8_t *pixels,const uint8_t *records,unsigned count) {
    for(unsigned repeat=0;repeat<PH_REPEATS;++repeat) {
        const uint8_t *p=records;
        for(unsigned i=0;i<count;++i,p+=8)
            fn(pixels+get16(p),(int)get16(p+2),(int)get16(p+4),p[6]);
    }
}
static uint32_t phase_done,phase_core,phase_input_crc;
static int32_t phase_error;

static int32_t phase_measure(const vdplet_host_v1 *h) {
    vdplet_view_v1 views[4]={{sizeof(vdplet_view_v1),0,0,0,0},{sizeof(vdplet_view_v1),0,0,0,0},
                          {sizeof(vdplet_view_v1),0,0,0,0},{sizeof(vdplet_view_v1),0,0,0,0}};
    const uint16_t ids[4]={PH_INPUT,PH_BYTE,PH_WIDE,PH_LOG};
    int32_t rc=0;
    for(unsigned i=0;i<4;++i) {
        rc=h->buffer_acquire(h->context,ids[i],i?VDPL_WRITE:VDPL_READ,0,VDPL_WHOLE_BUFFER,&views[i]);
        if(rc)goto release;
        if(!views[i].lease || !views[i].data || (views[i].access&(i?VDPL_WRITE:VDPL_READ))==0) {rc=VDPL_E_BUFFER;goto release;}
    }
    const uint8_t *input=views[0].data;
    if(views[0].bytes<PH_INPUT_HEADER || get32(input)!=UINT32_C(0x53383250) || get32(input+4)!=1 ||
       get32(input+8)!=8 || get32(input+20)!=PH_PIXELS || get32(input+24)!=PH_REPEATS || get32(input+28)) {rc=VDPL_E_FORMAT;goto release;}
    unsigned sequences=get32(input+12),records=get32(input+16),rows=sequences*8u;
    if(!sequences || sequences>10 || records>16000 ||
       PH_INPUT_HEADER+sequences*PH_DESC+records*8u!=views[0].bytes ||
       views[1].bytes!=PH_SCRATCH || views[2].bytes!=PH_SCRATCH || views[3].bytes!=PH_HEADER+rows*PH_ROW ||
       phase_done>=rows) {rc=VDPL_E_BOUNDS;goto release;}
    if(!phase_done) {phase_core=phase_cpu();phase_input_crc=phase_crc(input,views[0].bytes);}
    if(phase_cpu()!=phase_core) {rc=VDPL_E_UNSUPPORTED;goto release;}
    unsigned sequence=phase_done/8u,shift=(phase_done/2u)%4u,order=phase_done%2u;
    const uint8_t *desc=input+PH_INPUT_HEADER+sequence*PH_DESC;
    unsigned frame=get32(desc),first=get32(desc+4),count=get32(desc+8),written=get32(desc+12);
    uint32_t expected_crc=get32(desc+16+shift*4u);
    if(!count || first>records || count>records-first) {rc=VDPL_E_BOUNDS;goto release;}
    const uint8_t *spans=input+PH_INPUT_HEADER+sequences*PH_DESC+first*8u;
    unsigned checked_bytes=0;
    for(unsigned i=0;i<count;++i) {
        const uint8_t *p=spans+i*8u;unsigned row=get16(p),left=get16(p+2),right=get16(p+4);
        if(row>=PH_PIXELS || row%320u || left>right || right>320u || p[7]) {rc=VDPL_E_BOUNDS;goto release;}
        checked_bytes+=right-left;
    }
    if(checked_bytes!=written) {rc=VDPL_E_FORMAT;goto release;}
    uint8_t *byte=views[1].data,*wide=views[2].data;
    memset(byte,0xa5,PH_SCRATCH);memset(wide,0xa5,PH_SCRATCH);
    uint8_t *byte_pixels=byte+8u+shift,*wide_pixels=wide+8u+shift;
    uint32_t b0,b1,w0,w1,e0,e1;
    if(!order) {
        b0=phase_clock();phase_replay(phase_byte,byte_pixels,spans,count);b1=phase_clock();
        w0=phase_clock();phase_replay(phase_wide,wide_pixels,spans,count);w1=phase_clock();
    } else {
        w0=phase_clock();phase_replay(phase_wide,wide_pixels,spans,count);w1=phase_clock();
        b0=phase_clock();phase_replay(phase_byte,byte_pixels,spans,count);b1=phase_clock();
    }
    e0=phase_clock();phase_replay(phase_empty,wide_pixels,spans,count);e1=phase_clock();
    if(phase_cpu()!=phase_core) {rc=VDPL_E_UNSUPPORTED;goto release;}
    uint32_t baseline=b1-b0,candidate=w1-w0,empty=e1-e0;
    if(!baseline || !candidate || !empty || (baseline|candidate|empty)>=UINT32_C(0x80000000)) {rc=VDPL_E_LIMIT;goto release;}
    unsigned mismatch=0,guards=0;
    for(unsigned i=0;i<PH_SCRATCH;++i) {
        mismatch+=byte[i]!=wide[i];
        if(i<8u+shift || i>=8u+shift+PH_PIXELS)guards+=(byte[i]!=0xa5)+(wide[i]!=0xa5);
    }
    uint32_t byte_crc=phase_crc(byte,PH_SCRATCH),wide_crc=phase_crc(wide,PH_SCRATCH);
    if(mismatch || guards || byte_crc!=expected_crc || wide_crc!=expected_crc) {rc=VDPL_E_ARGUMENT;goto release;}
    uint8_t *log=views[3].data;
    uint32_t header[8]={UINT32_C(0x46383250),1,PH_ROW,rows,phase_done+1,phase_core,phase_input_crc,PH_REPEATS};
    uint32_t row[14]={frame,shift,order,count,written,PH_REPEATS,baseline,candidate,empty,byte_crc,wide_crc,mismatch,guards,phase_core};
    for(unsigned i=0;i<8;++i)put32(log+i*4u,header[i]);
    for(unsigned i=0;i<14;++i)put32(log+PH_HEADER+phase_done*PH_ROW+i*4u,row[i]);
    ++phase_done;
release:
    for(unsigned i=4;i>0;--i)if(views[i-1].lease) {
        int32_t released=h->buffer_release(h->context,views[i-1].lease);
        if(released)rc=released;
    }
    return rc;
}

__attribute__((visibility("default")))
int32_t vdplet_entry(const vdplet_host_v1 *h,const vdplet_request_v1 *r) {
    if(!h || !r || h->struct_bytes<sizeof(*h) || r->struct_bytes<sizeof(*r) || h->abi_major!=1 ||
       !(h->capabilities&VDPL_CAP_BUFFERS) || !h->buffer_acquire || !h->buffer_release)return VDPL_E_ABI;
    if(r->operation==VDPL_INIT) {phase_done=0;phase_core=0;phase_input_crc=0;phase_error=0;return 0;}
    if(r->operation==VDPL_FINI)return 0;
    if(r->operation!=VDPL_RUN || r->entry_id!=1)return VDPL_E_UNSUPPORTED;
    if(r->reserved || r->argument_bytes!=2)return VDPL_E_ARGUMENT;
    if(phase_error)return phase_error;
    phase_error=phase_measure(h);
    return phase_error;
}
