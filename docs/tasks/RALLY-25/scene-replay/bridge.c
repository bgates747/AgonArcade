#include "bridge.h"
#include <string.h>
static uint16_t u16(const uint8_t *p){return p[0]|(uint16_t)p[1]<<8;}
static uint32_t u32(const uint8_t *p){return u16(p)|(uint32_t)u16(p+2)<<16;}
static int32_t s32(const uint8_t *p){uint32_t n=u32(p);return n>INT32_MAX?-1-(int32_t)(UINT32_MAX-n):(int32_t)n;}
static int32_t close_view(const vdplet_host_v1 *h,vdplet_view_v1 *v){
    if(!v->lease)return 0;
    uint32_t lease=v->lease;v->lease=0;return h->buffer_release(h->context,lease);
}
static int32_t open_view(const vdplet_host_v1 *h,const RallyRenderRangeV1 *r,vdplet_view_v1 *v){
    memset(v,0,sizeof(*v));v->struct_bytes=sizeof(*v);
    int32_t rc=h->buffer_acquire(h->context,r->buffer,VDPL_READ,r->offset,VDPL_WHOLE_BUFFER,v);
    if(!rc && (!v->lease || !v->data || v->bytes!=r->bytes || !(v->access&VDPL_READ)))rc=VDPL_E_BOUNDS;
    return rc;
}
int32_t scene_marshal(const vdplet_host_v1 *h,const SceneLayout *l,const SceneProof *p,
                      const ScenePresentation *v,RallyRenderStateV1 *out){
    if(!h || h->struct_bytes<sizeof(*h) || h->abi_major!=1 || !(h->capabilities&VDPL_CAP_BUFFERS) ||
       !h->buffer_acquire || !h->buffer_release || !l || l->struct_bytes!=sizeof(*l) ||
       !p || !v || !out || l->root_bytes<112 || !l->root || !l->lap || l->lap>3276800 ||
       l->tick_entry>=l->entry_count || p->observed_runtime || !p->session ||
       v->phase>=8000 || v->steering< -21 || v->steering>21 || v->flags>7 || v->reserved)return VDPL_E_ARGUMENT;
    const uint32_t offsets[4]={l->tick_offset,l->heading_offset,l->player_offset,l->lateral_offset};
    for(unsigned i=0;i<4;++i)if(offsets[i]>l->root_bytes-4u)return VDPL_E_BOUNDS;
    const RallyRenderRangeV1 ranges[3]={l->active,l->position,l->lateral};
    for(unsigned i=0;i<3;++i)
        if(!ranges[i].buffer || ranges[i].buffer==l->root || ranges[i].access!=VDPL_READ ||
           ranges[i].bytes!=(i?24u:12u) || ranges[i].offset>UINT32_MAX-ranges[i].bytes)return VDPL_E_ARGUMENT;
    if(l->active.buffer==l->position.buffer || l->active.buffer==l->lateral.buffer || l->position.buffer==l->lateral.buffer)return VDPL_E_ARGUMENT;
    memset(out,0,sizeof(*out));out->struct_bytes=sizeof(*out);out->schema=1;
    vdplet_view_v1 root={0};RallyRenderRangeV1 r={l->root,VDPL_READ,0,l->root_bytes};
    int32_t rc=open_view(h,&r,&root),rr;
    if(rc)goto done;
    const uint8_t *data=root.data;
    if(u16(data)!=0x4752 || u16(data+2)!=1 || u16(data+4)!=112 || u16(data+6)!=l->root_bytes ||
       u16(data+12) || u16(data+14) || u32(data+16) || u16(data+26)!=4 || u16(data+30) ||
       u16(data+36)!=l->entry_count || u16(data+38)!=l->root_bytes-112 || u32(data+40) || u32(data+44)!=0x52323530 ||
       u32(data+8)!=p->session || u32(data+32)!=p->session || u16(data+24)!=l->tick_entry ||
       u16(data+28)!=l->tick_entry || u32(data+20)!=p->success_generation || u32(data+l->tick_offset)!=p->tick){rc=VDPL_E_ARGUMENT;goto done;}
    int32_t heading=s32(data+l->heading_offset),lateral=s32(data+l->lateral_offset);uint32_t station=u32(data+l->player_offset);
    if(heading< -1920 || heading>1920 || station>=l->lap || lateral< -38400 || lateral>38400){rc=VDPL_E_ARGUMENT;goto done;}
    out->session=p->session;out->request_generation=p->request;out->simulation_tick=p->tick;
    out->player_station=(int32_t)station;out->player_lateral_q8=lateral;out->phase=v->phase;out->steering=v->steering;out->flags=v->flags;
    for(unsigned i=0;i<3 && !rc;++i){
        vdplet_view_v1 a;rc=open_view(h,&ranges[i],&a);
        if(!rc)for(unsigned j=0;j<6 && !rc;++j){
            RallyRenderOpponentV1 *o=&out->opponents[j];
            if(i==0){o->active=u16(a.data+2*j);if(o->active>1)rc=VDPL_E_ARGUMENT;}
            else if(o->active){
                if(i==1){uint32_t pos=u32(a.data+4*j);if(pos>=l->lap)rc=VDPL_E_ARGUMENT;else o->station=(int32_t)pos;}
                else {int32_t lat=s32(a.data+4*j);if(lat< -14260 || lat>14260)rc=VDPL_E_ARGUMENT;else o->lateral_q8=lat;}
            }
            /* The renderer, not this adapter, applies the alternating yaw sign. */
            if(o->active)o->heading_turn16=(int16_t)heading;
        }
        rr=close_view(h,&a);if(rr)rc=rr;
    }
done:
    rr=close_view(h,&root);return rr?rr:rc;
}
