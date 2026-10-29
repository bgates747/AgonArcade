/* Actor-only diagnostic. CCOUNT is raw and uncalibrated, never milliseconds. */
#include <string.h>
#if __BYTE_ORDER__ != __ORDER_LITTLE_ENDIAN__
#error "Actor-only phase format requires the pinned little-endian platform"
#endif
static struct {uint32_t prepare,begin,core,count,stage;int32_t error;} lite;
#ifdef __XTENSA__
static inline uint32_t lite_clock(void){uint32_t x;__asm__ __volatile__("rsr.ccount %0":"=a"(x)::"memory");return x;}
static inline uint32_t lite_cpu(void){uint32_t x;__asm__ __volatile__("rsr.prid %0":"=a"(x)::"memory");return x;}
#else
static uint32_t lite_fake_clock;
static inline uint32_t lite_clock(void){return lite_fake_clock+=17u;}
static inline uint32_t lite_cpu(void){return 0;}
#endif
static int32_t lite_bad(int32_t rc){lite.error=rc;return rc;}
static int32_t lite_marker(const vdplet_host_v1*h,unsigned op){
    uint32_t now=lite_clock();
    if(lite.error)return lite.error;
    if(op>1)return lite_bad(VDPL_E_UNSUPPORTED);
    if(lite_cpu()!=lite.core)return lite_bad(VDPL_E_UNSUPPORTED);
    if(lite.count>=128)return lite_bad(VDPL_E_LIMIT);
    if(lite.stage!=op+1)return lite_bad(VDPL_E_ARGUMENT);
    if(!op){lite.begin=now;lite.stage=2;return 0;}
    uint32_t elapsed=now-lite.begin;
    if(!lite.prepare || !elapsed || (lite.prepare|elapsed)>=0x80000000u)
        return lite_bad(VDPL_E_ARGUMENT);
    vdplet_view_v1 v={sizeof(v),0,0,0,0};
    int32_t rc=h->buffer_acquire(h->context,50305,VDPL_WRITE,0,VDPL_WHOLE_BUFFER,&v);
    if(!rc && (!v.lease || !v.data || v.bytes!=1552 || !(v.access&VDPL_WRITE)))rc=VDPL_E_BOUNDS;
    if(!rc){
        uint32_t header[4]={0x41383250u,1u|(12u<<16),128u|((lite.count+1)<<16),lite.core};
        uint32_t row[3]={lite.count+1,lite.prepare,elapsed};
        memcpy(v.data,header,sizeof(header));
        memcpy(v.data+16+lite.count*12,row,sizeof(row));
    }
    if(v.lease){int32_t released=h->buffer_release(h->context,v.lease);if(released)rc=released;}
    if(rc)return lite_bad(rc);
    ++lite.count;lite.stage=0;lite.prepare=0;
    return 0;
}
