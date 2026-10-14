/* Ordinary/sanitized C integration fixture. Heap, faults and cleanup are host-only. */
#include "integration_model.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "fixtures.h"

typedef struct Buffer {uint16_t id;uint8_t *data;uint32_t bytes,offset,length;} Buffer;
typedef struct Lease {uint32_t token;uint8_t *data;uint32_t bytes;uint16_t access;} Lease;
typedef struct Fixture {
    ModelModule module;vdplet_host_v1 host;Buffer buffers[12];unsigned count;
    Lease leases[16];unsigned live,peak,acquires,releases,next;
    unsigned fail_acquire,fail_release,leaked_before_cleanup,cleanup_count;
    int hold_failed_release,fail_copy,copy_calls,helper_overlap;
    ModelObservation observation;
} Fixture;
static unsigned checks,failures;
#define CHECK(x) do {++checks;if(!(x)){fprintf(stderr,"FAIL %s:%d: %s\n",__FILE__,__LINE__,#x);++failures;exit(2);}} while(0)
static Buffer *buffer(Fixture *f,uint16_t id){for(unsigned i=0;i<f->count;++i)if(f->buffers[i].id==id)return &f->buffers[i];return NULL;}
static uint8_t *root(Fixture *f){Buffer *b=buffer(f,f->module.map.root.buffer);return b->data+f->module.map.root.offset;}
static RallyRenderCompletionV1 completion(Fixture *f){RallyRenderCompletionV1 c;Buffer *b=buffer(f,f->module.map.completion.buffer);memcpy(&c,b->data+f->module.map.completion.offset,sizeof(c));return c;}
static int32_t acquire(void *context,uint16_t id,uint16_t access,uint32_t offset,uint32_t bytes,vdplet_view_v1 *out){
    Fixture *f=context;++f->acquires;if(f->acquires==f->fail_acquire)return VDPL_E_BUFFER;
    Buffer *b=buffer(f,id);if(!b)return VDPL_E_BUFFER;
    if(offset>b->bytes || bytes>b->bytes-offset)return VDPL_E_BOUNDS;
    if(f->live>=3)return VDPL_E_LIMIT;
    uint8_t *p=b->data+offset;
    for(unsigned i=0;i<16;++i){Lease *v=&f->leases[i];
        if(v->token && (uintptr_t)p<(uintptr_t)v->data+v->bytes && (uintptr_t)v->data<(uintptr_t)p+bytes && ((access|v->access)&VDPL_WRITE))return VDPL_E_BUSY;
    }
    /* Publication must follow all helper views; the root alone may be live. */
    if(id==f->module.map.completion.buffer && f->observation.attempted && f->live!=1)f->helper_overlap=1;
    for(unsigned i=0;i<16;++i)if(!f->leases[i].token){
        unsigned token=++f->next;f->leases[i]=(Lease){token,p,bytes,access};
        ++f->live;if(f->live>f->peak)f->peak=f->live;
        out->lease=token;out->data=p;out->bytes=bytes;out->access=access;return 0;
    }
    return VDPL_E_LIMIT;
}
static int32_t release(void *context,uint32_t token){
    Fixture *f=context;++f->releases;
    for(unsigned i=0;i<16;++i)if(f->leases[i].token==token){
        if(f->releases==f->fail_release){
            if(!f->hold_failed_release){f->leases[i].token=0;--f->live;}
            return VDPL_E_HANDLE;
        }
        f->leases[i].token=0;--f->live;return 0;
    }
    return VDPL_E_HANDLE;
}
static int32_t copy_completion(void *context,uint8_t *target,const void *source,uint32_t n){
    Fixture *f=context;++f->copy_calls;
    /* Full write then error intentionally leaves resident ready=1. */
    memcpy(target,source,n);return f->fail_copy?VDPL_E_BOUNDS:0;
}
static void install(Fixture *f,uint16_t id,uint32_t offset,uint32_t length,const uint8_t *data){
    CHECK(f->count<12 && !buffer(f,id));Buffer *b=&f->buffers[f->count++];
    *b=(Buffer){id,NULL,offset+length+11,offset,length};b->data=malloc(b->bytes);CHECK(b->data);
    memset(b->data,0xcc,b->bytes);if(data)memcpy(b->data+offset,data,length);else memset(b->data+offset,0,length);
}
static void init(Fixture *f,const ModelMap *m,const uint8_t *asset){
    memset(f,0,sizeof(*f));f->module.map=*m;f->module.renderer.struct_bytes=sizeof(f->module.renderer);
    f->host=(vdplet_host_v1){sizeof(f->host),1,0,VDPL_CAP_BUFFERS,f,acquire,release,NULL,NULL,NULL};
    install(f,m->root.buffer,m->root.offset,m->root.bytes,NULL);model_init_root(root(f),m,m->bindings.session);
    uint8_t arg[2];model_put16(arg,m->root.buffer);install(f,m->argument.buffer,m->argument.offset,2,arg);
    RallyRenderCompletionV1 c={.struct_bytes=sizeof(c),.schema=1};
    install(f,m->completion.buffer,m->completion.offset,48,(const uint8_t *)&c);
    install(f,m->bindings.asset.buffer,m->bindings.asset.offset,m->bindings.asset.bytes,asset);
    for(unsigned i=0;i<3;++i){const RallyRenderRangeV1 *r=&m->bindings.output[i];install(f,r->buffer,r->offset,r->bytes,NULL);}
    for(unsigned i=0;i<4;++i){const uint8_t *d=m->descriptors+16*i;
        if(model_u16(d+2))install(f,model_u16(d+2),model_u32(d+4),model_u32(d+8),NULL);
    }
}
static void canaries(Fixture *f){
    for(unsigned i=0;i<f->count;++i){Buffer *b=&f->buffers[i];
        for(unsigned j=0;j<b->offset;++j)CHECK(b->data[j]==0xcc);
        for(unsigned j=b->offset+b->length;j<b->bytes;++j)CHECK(b->data[j]==0xcc);
    }
}
static void destroy(Fixture *f){CHECK(!f->live);canaries(f);for(unsigned i=0;i<f->count;++i)free(f->buffers[i].data);}
static void cleanup(Fixture *f){
    /* Explicit simulated SDK entry cleanup, never credited to helper/glue. */
    if(f->live){f->leaked_before_cleanup+=f->live;++f->cleanup_count;}
    memset(f->leases,0,sizeof(f->leases));f->live=0;
}
static int32_t invoke(Fixture *f,uint16_t entry,const RallyRenderStateV1 *s,uint16_t language){
    uint8_t *p=root(f);f->observation=(ModelObservation){model_u32(p+20),s->session,s->request_generation,s->simulation_tick,entry,0,0};
    int32_t rc=model_clear_ready(&f->host,&f->module.map);
    if(!rc){f->observation.attempted=1;rc=model_dispatch(&f->host,&f->module,entry,s,language,copy_completion,f);}
    /* Transport result and forced lease cleanup belong to the mock owner. */
    cleanup(f);model_put32(p+16,(uint32_t)rc);f->observation.runtime_result=rc;return rc;
}
static int draw(Fixture *f){RallyRenderCompletionV1 c=completion(f);return model_can_draw(&f->module.map,root(f),f->module.map.root.bytes,&c,&f->observation);}
static RallyRenderStateV1 state(unsigned index){
    /* Decode explicit little-endian fixture fields; not memcpy of wire C structs. */
    const uint8_t *p=fixture_states[index];RallyRenderStateV1 s={0};
    s.struct_bytes=model_u16(p);s.schema=model_u16(p+2);s.session=model_u32(p+4);
    s.request_generation=model_u32(p+8);s.simulation_tick=model_u32(p+12);
    s.player_station=(int32_t)model_u32(p+16);s.player_lateral_q8=(int32_t)model_u32(p+20);
    s.phase=model_u16(p+24);s.steering=(int16_t)model_u16(p+26);s.flags=model_u16(p+28);
    s.presentation_profile=model_u16(p+30);s.reference_crash_remaining=model_u16(p+32);s.reference_invulnerable=model_u16(p+34);
    for(unsigned i=0;i<6;++i){const uint8_t *o=p+36+i*12;s.opponents[i]=(RallyRenderOpponentV1){(int32_t)model_u32(o),(int32_t)model_u32(o+4),(int16_t)model_u16(o+8),model_u16(o+10)};}
    return s;
}
static void start(Fixture *f,const ModelMap *m,const uint8_t *asset,const RallyRenderStateV1 *s){
    init(f,m,asset);CHECK(!invoke(f,m->entries[MODEL_INIT],s,0));CHECK(f->module.renderer.bound);CHECK(!draw(f));
    f->acquires=f->releases=0;f->peak=0;f->copy_calls=0;
}
static void dump(FILE *out,Fixture *f){
    RallyRenderCompletionV1 c=completion(f);uint8_t n[4];
    for(unsigned i=0;i<3;++i){const RallyRenderRangeV1 *r=&f->module.map.bindings.output[i];
        Buffer *b=buffer(f,r->buffer);model_put32(n,c.output_bytes[i]);CHECK(fwrite(n,1,4,out)==4);
        CHECK(fwrite(b->data+r->offset,1,c.output_bytes[i],out)==c.output_bytes[i]);
    }
}
static void gate_tests(Fixture *f){
    const ModelMap *m=&f->module.map;uint8_t saved[128];CHECK(m->root.bytes<=sizeof(saved));
    memcpy(saved,root(f),m->root.bytes);RallyRenderCompletionV1 c=completion(f),changed;
    ModelObservation obs=f->observation;
    const unsigned root_offsets[]={8,12,14,16,20,24,28,32};
    for(unsigned i=0;i<sizeof(root_offsets)/sizeof(*root_offsets);++i){
        root(f)[root_offsets[i]]^=1;CHECK(!draw(f));memcpy(root(f),saved,m->root.bytes);
    }
    const unsigned completion_offsets[]={0,2,4,8,12,16,20,24,28,32,42,44,46};
    for(unsigned i=0;i<sizeof(completion_offsets)/sizeof(*completion_offsets);++i){
        changed=c;unsigned off=completion_offsets[i];
        if(off==24 || off==28 || off==32)memset((uint8_t *)&changed+off,0,4);
        else ((uint8_t *)&changed)[off]^=1;
        CHECK(!model_can_draw(m,root(f),m->root.bytes,&changed,&obs));
    }
    obs.attempted=0;CHECK(!model_can_draw(m,root(f),m->root.bytes,&c,&obs));obs=f->observation;
    obs.before_generation++;CHECK(!model_can_draw(m,root(f),m->root.bytes,&c,&obs));
    obs=f->observation;obs.runtime_result=8;CHECK(!model_can_draw(m,root(f),m->root.bytes,&c,&obs));
    CHECK(!model_can_draw(m,root(f),111,&c,&f->observation));CHECK(draw(f));
}
static unsigned failure_tests(const ModelMap *m,const uint8_t *asset){
    Fixture f;RallyRenderStateV1 s=state(0);unsigned cases=0;
    start(&f,m,asset,&s);CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,0));CHECK(draw(&f));
    unsigned na=f.acquires,nr=f.releases;CHECK(f.peak==3 && !f.helper_overlap);gate_tests(&f);++cases;destroy(&f);
    /* Every callback boundary in clear/argument/root/descriptors/helper/publication/root-release. */
    for(unsigned release_fault=0;release_fault<2;++release_fault){unsigned n=release_fault?nr:na;
        for(unsigned k=1;k<=n;++k)for(unsigned hold=0;hold<=(release_fault?1u:0u);++hold){
            start(&f,m,asset,&s);CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,0));CHECK(draw(&f));
            f.acquires=f.releases=0;f.hold_failed_release=(int)hold;
            if(release_fault)f.fail_release=k;else f.fail_acquire=k;
            uint32_t before=model_u32(root(&f)+20);CHECK(invoke(&f,m->entries[MODEL_RENDER],&s,0)!=0);CHECK(!draw(&f));
            if(release_fault && k==nr)CHECK(model_u32(root(&f)+20)==before+1u);
            else CHECK(model_u32(root(&f)+20)==before);
            if(hold)CHECK(f.leaked_before_cleanup && f.cleanup_count);
            CHECK(f.peak<=3 && !f.helper_overlap);++cases;destroy(&f);
        }
    }
    start(&f,m,asset,&s);f.fail_copy=1;uint32_t before=model_u32(root(&f)+20);
    CHECK(invoke(&f,m->entries[MODEL_RENDER],&s,0)==3);CHECK(completion(&f).ready==1);
    CHECK(model_u32(root(&f)+20)==before && model_u32(root(&f)+112)==2 && !draw(&f));++cases;destroy(&f);
    /* Publication acquire/release failures leave helper output, never success authorization. */
    for(unsigned mode=0;mode<2;++mode){start(&f,m,asset,&s);before=model_u32(root(&f)+20);
        if(mode)f.fail_release=nr-1;else f.fail_acquire=na;
        CHECK(invoke(&f,m->entries[MODEL_RENDER],&s,0)!=0);CHECK(!draw(&f));CHECK(model_u32(root(&f)+20)==before);
        if(mode){CHECK(completion(&f).ready==1);}
        ++cases;destroy(&f);
    }
    start(&f,m,asset,&s);before=model_u32(root(&f)+20);CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,5));
    CHECK(model_u16(root(&f)+14)==5 && model_u32(root(&f)+112)==2 && model_u32(root(&f)+20)==before && !f.copy_calls && !draw(&f));++cases;destroy(&f);
    start(&f,m,asset,&s);CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,0));before=model_u32(root(&f)+20);
    CHECK(invoke(&f,65535,&s,0)==9 && !completion(&f).ready && !draw(&f));CHECK(model_u32(root(&f)+20)==before);++cases;destroy(&f);
    /* Metadata rejection preserves previous language/source/success fields. */
    const unsigned offsets[]={0,2,4,6,8,26,30,36,38,40,44,50};
    for(unsigned i=0;i<sizeof(offsets)/sizeof(*offsets);++i){
        start(&f,m,asset,&s);uint8_t *p=root(&f);model_put16(p+14,32);before=model_u32(p+20);uint32_t effects=model_u32(p+112);
        if(offsets[i]==8)model_put32(p+8,0);else p[offsets[i]]^=1;
        CHECK(invoke(&f,m->entries[MODEL_RENDER],&s,0)!=0);CHECK(model_u16(p+12)!=0);
        CHECK(model_u16(p+14)==32 && model_u32(p+20)==before && model_u32(p+112)==effects && !draw(&f));++cases;destroy(&f);
    }
    start(&f,m,asset,&s);s.player_station=-1;before=model_u32(root(&f)+20);
    CHECK(invoke(&f,m->entries[MODEL_RENDER],&s,0)==1 && !draw(&f));CHECK(completion(&f).result==1 && !completion(&f).ready);
    CHECK(model_u32(root(&f)+112)==2 && model_u32(root(&f)+20)==before);++cases;destroy(&f);s=state(0);
    start(&f,m,asset,&s);CHECK(!invoke(&f,m->entries[MODEL_STOP],&s,0));CHECK(!f.module.renderer.bound && !draw(&f));
    CHECK(invoke(&f,m->entries[MODEL_RENDER],&s,0)==12 && !draw(&f));
    CHECK(!invoke(&f,m->entries[MODEL_RESET],&s,0));CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,0) && draw(&f));++cases;destroy(&f);
    start(&f,m,asset,&s);CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,0));
    f.module.map.bindings.asset_checksum^=1;before=model_u32(root(&f)+20);
    CHECK(invoke(&f,m->entries[MODEL_RESET],&s,0)==4 && !f.module.renderer.bound && !draw(&f));
    CHECK(model_u32(root(&f)+20)==before && completion(&f).result==4);++cases;destroy(&f);
    start(&f,m,asset,&s);model_put32(root(&f)+20,UINT32_MAX);s.request_generation=s.simulation_tick=UINT32_MAX;
    CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,0) && draw(&f) && model_u32(root(&f)+20)==0);
    s.request_generation=s.simulation_tick=0;CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,0) && draw(&f));++cases;destroy(&f);s=state(0);
    start(&f,m,asset,&s);buffer(&f,m->root.buffer)->bytes=m->root.offset+111;before=model_u32(root(&f)+20);
    CHECK(invoke(&f,m->entries[MODEL_RENDER],&s,0)==3 && !draw(&f) && model_u32(root(&f)+20)==before);++cases;destroy(&f);
    start(&f,m,asset,&s);Buffer *arg=buffer(&f,m->argument.buffer);model_put16(arg->data+m->argument.offset,65534);
    CHECK(invoke(&f,m->entries[MODEL_RENDER],&s,0)==1 && !draw(&f));++cases;destroy(&f);
    return cases;
}
int main(int argc,char **argv){
    CHECK(argc==3);FILE *in=fopen(argv[1],"rb");CHECK(in);uint8_t *asset=malloc(fixture_maps[0].bindings.asset.bytes);CHECK(asset);
    CHECK(fread(asset,1,fixture_maps[0].bindings.asset.bytes,in)==fixture_maps[0].bindings.asset.bytes);CHECK(fgetc(in)==EOF);fclose(in);
    unsigned total_cases=0,max_peak=0,scenes=0;
    for(unsigned mapping=0;mapping<2;++mapping){const ModelMap *m=&fixture_maps[mapping];Fixture f;RallyRenderStateV1 s=state(0);
        char path[4096];CHECK(snprintf(path,sizeof(path),"%s/map-%u.commands",argv[2],mapping)>0);FILE *out=fopen(path,"wb");CHECK(out);
        start(&f,m,asset,&s);
        for(unsigned i=0;i<FIXTURE_COUNT;++i){s=state(i);
            if(i==FIXTURE_COUNT/2){CHECK(!invoke(&f,m->entries[MODEL_STOP],&s,0));CHECK(!draw(&f));CHECK(!invoke(&f,m->entries[MODEL_RESET],&s,0));}
            CHECK(!invoke(&f,m->entries[MODEL_RENDER],&s,0));CHECK(draw(&f));CHECK(!f.helper_overlap && !f.cleanup_count);
            RallyRenderCompletionV1 c=completion(&f);
            CHECK(c.bands==fixture_counts[i][0] && c.cars==fixture_counts[i][1] && c.signs==fixture_counts[i][2]);
            dump(out,&f);++scenes;
            if(f.peak>max_peak)max_peak=f.peak;
        }
        CHECK(!invoke(&f,m->entries[MODEL_TICK],&s,0) && !draw(&f));
        CHECK(!invoke(&f,m->entries[MODEL_STOP],&s,0) && !draw(&f));fclose(out);destroy(&f);
        total_cases+=failure_tests(m,asset);
    }
    free(asset);printf("{\"c_assertions\":%u,\"failure_lifecycle_groups\":%u,\"scene_renders\":%u,\"peak_mock_views\":%u,\"failures\":%u}\n",checks,total_cases,scenes,max_peak,failures);return failures?2:0;
}
