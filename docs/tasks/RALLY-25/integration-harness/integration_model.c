#include "integration_model.h"
#include <string.h>
uint16_t model_u16(const uint8_t *p){return p[0]|(uint16_t)p[1]<<8;}
uint32_t model_u32(const uint8_t *p){return model_u16(p)|(uint32_t)model_u16(p+2)<<16;}
void model_put16(uint8_t *p,uint16_t n){p[0]=(uint8_t)n;p[1]=(uint8_t)(n>>8);}
void model_put32(uint8_t *p,uint32_t n){model_put16(p,(uint16_t)n);model_put16(p+2,(uint16_t)(n>>16));}
void model_init_root(uint8_t *p,const ModelMap *m,uint32_t session){
    memset(p,0,m->root.bytes);model_put16(p,0x4752);model_put16(p+2,1);
    model_put16(p+4,112);model_put16(p+6,(uint16_t)m->root.bytes);
    model_put32(p+8,session);model_put16(p+24,65535);model_put16(p+26,4);
    model_put16(p+36,m->entry_count);model_put16(p+38,m->globals_bytes);
    model_put32(p+44,0x52323530);memcpy(p+48,m->descriptors,64);
}
static int32_t acquire(const vdplet_host_v1 *h,const RallyRenderRangeV1 *r,vdplet_view_v1 *v){
    memset(v,0,sizeof(*v));v->struct_bytes=sizeof(*v);
    int32_t rc=h->buffer_acquire(h->context,r->buffer,r->access,r->offset,r->bytes,v);
    if(!rc && (!v->lease || !v->data || v->bytes!=r->bytes || (v->access&r->access)!=r->access))return VDPL_E_BOUNDS;
    return rc;
}
static int32_t release(const vdplet_host_v1 *h,vdplet_view_v1 *v){
    if(!v->lease)return 0;
    uint32_t lease=v->lease;v->lease=0;return h->buffer_release(h->context,lease);
}
int32_t model_clear_ready(const vdplet_host_v1 *h,const ModelMap *m){
    vdplet_view_v1 v;int32_t rc=acquire(h,&m->completion,&v);
    if(!rc){if(v.bytes!=48)rc=VDPL_E_BOUNDS;else model_put16(v.data+44,0);}
    int32_t rr=release(h,&v);return rr?rr:rc;
}
static uint16_t envelope(const uint8_t *p,const ModelMap *m){
    if(model_u16(p)!=0x4752)return 1;
    if(model_u16(p+2)!=1)return 2;
    if(model_u16(p+4)!=112 || model_u16(p+6)!=m->root.bytes ||
       model_u16(p+26)!=4 || model_u16(p+36)!=m->entry_count ||
       model_u16(p+38)!=m->globals_bytes)return 3;
    if(!model_u32(p+8))return 4;
    if(memcmp(p+48,m->descriptors,64))return 5;
    if(model_u16(p+30) || model_u32(p+40) || model_u32(p+44)!=0x52323530)return 6;
    if(model_u16(p+28)>=m->entry_count)return 7;
    return 0;
}
static int32_t publish(const vdplet_host_v1 *h,const ModelMap *m,
                       const RallyRenderCompletionV1 *c,ModelCopy copy,void *copy_context){
    vdplet_view_v1 v;int32_t rc=acquire(h,&m->completion,&v);
    if(!rc){
        if(v.bytes!=sizeof(*c))rc=VDPL_E_BOUNDS;
        else if(copy)rc=copy(copy_context,v.data,c,sizeof(*c));
        else memcpy(v.data,c,sizeof(*c));
    }
    int32_t rr=release(h,&v);return rr?rr:rc;
}
int32_t model_dispatch(const vdplet_host_v1 *h,ModelModule *module,uint16_t entry,
                       const RallyRenderStateV1 *state,uint16_t source_failure,
                       ModelCopy copy,void *copy_context){
    const ModelMap *m=&module->map;int logical=-1;int32_t rc=0,rr;
    vdplet_view_v1 arg={0},root={0};
    for(unsigned i=0;i<MODEL_ENTRIES;++i)if(m->entries[i]==entry)logical=(int)i;
    /* SDK dispatcher rejection precedes all root access. */
    if(logical<0)return VDPL_E_UNSUPPORTED;
    if(m->root.bytes<112 || m->globals_bytes<4 || m->root.bytes!=112u+m->globals_bytes)
        return VDPL_E_BOUNDS;
    rc=acquire(h,&m->argument,&arg);
    uint16_t root_id=0;
    if(!rc){if(arg.bytes!=2)rc=VDPL_E_BOUNDS;else root_id=model_u16(arg.data);}
    rr=release(h,&arg);if(rr)rc=rr;
    if(rc)return rc;
    if(root_id!=m->root.buffer)return VDPL_E_ARGUMENT;
    rc=acquire(h,&m->root,&root);
    if(rc)goto done;
    uint8_t *p=root.data;model_put16(p+28,entry);
    uint16_t status=envelope(p,m);model_put16(p+12,status);
    if(status){rc=VDPL_E_ARGUMENT;goto done;}
    /* Native preflight scopes each declared range before source effects. */
    for(unsigned i=0;i<4;++i){
        const uint8_t *d=p+48+16*i;
        if(!model_u16(d+2))continue;
        RallyRenderRangeV1 r={model_u16(d+2),model_u16(d+12),model_u32(d+4),model_u32(d+8)};
        vdplet_view_v1 v;rc=acquire(h,&r,&v);rr=release(h,&v);if(rr)rc=rr;
        if(rc){model_put16(p+12,8);goto done;}
    }
    model_put16(p+14,0);
    /* An explicit source-effect sentinel tests no-rollback semantics. */
    model_put32(p+112,model_u32(p+112)+1u);
    if(source_failure){model_put16(p+14,source_failure);goto done;}
    RallyRenderCompletionV1 c={.struct_bytes=sizeof(c),.schema=1};
    if(logical==MODEL_INIT || logical==MODEL_RESET)
        rc=rally_render_bind_v1(h,&module->renderer,&m->bindings,&c);
    else if(logical==MODEL_RENDER)
        rc=rally_render_prepare_v1(h,&module->renderer,state,&c);
    else if(logical==MODEL_STOP)rc=rally_render_stop_v1(&module->renderer,&c);
    /* Tick is only a source sentinel here, never a physics implementation. */
    /* A failed release may leave an SDK lease live. Return for entry cleanup
       before any publication/re-entry, even if this mock released the lease. */
    if(logical!=MODEL_TICK && c.reason!=RALLY_RENDER_REASON_RELEASE){
        int32_t pr=publish(h,m,&c,copy,copy_context);if(pr)rc=pr;
    }
    if(!rc){
        model_put32(p+20,model_u32(p+20)+1u);model_put16(p+24,entry);
        model_put32(p+32,model_u32(p+8));
    }
done:
    rr=release(h,&root);return rr?rr:rc;
}
int model_can_draw(const ModelMap *m,const uint8_t *p,uint32_t bytes,
                   const RallyRenderCompletionV1 *c,const ModelObservation *o){
    if(!o->attempted || o->runtime_result || bytes!=m->root.bytes || bytes<112 ||
       envelope(p,m) || model_u16(p+12) || model_u16(p+14) || model_u32(p+16) ||
       model_u32(p+8)!=o->session || model_u32(p+32)!=o->session ||
       model_u16(p+24)!=m->entries[MODEL_RENDER] || o->entry!=m->entries[MODEL_RENDER] ||
       model_u16(p+28)!=o->entry || model_u32(p+20)!=o->before_generation+1u ||
       c->struct_bytes!=sizeof(*c) || c->schema!=1 || c->result || c->service_result ||
       c->reason || c->reserved || c->ready!=1 || c->session!=o->session ||
       c->request_generation!=o->request || c->simulation_tick!=o->tick)return 0;
    for(unsigned i=0;i<3;++i)if(!c->output_bytes[i] || c->output_bytes[i]>m->bindings.output[i].bytes)return 0;
    return 1;
}
