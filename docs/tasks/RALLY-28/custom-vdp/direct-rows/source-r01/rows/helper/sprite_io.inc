/* Called only AFTER releasing the actor-command output lease. Root+asset,
   source+destination fit the actual four-slot runtime. Never retain views. */
static int32_t r28_sample_actors(const vdplet_host_v1 *h,const Assets *a,
                                unsigned cars,unsigned signs,RallyRenderCompletionV1 *c) {
    for(unsigned slot=0;slot<8;++slot){
        int sign=slot>=6;unsigned index=sign?slot-6:slot;
        if(index>=(sign?signs:cars))continue;
        const Car *r=sign?&a->context->signs[index]:&a->context->cars[index];
        R28SpritePlan p;
        if(!r28_sprite_plan(r,sign,sign?104:(a->state->flags&2?88:24),&p))continue;
        RallyRenderRangeV1 source={(uint16_t)(64000+r->bitmap),VDPL_READ,0,
                                   (uint32_t)(p.source_width*p.source_height)};
        RallyRenderRangeV1 dest={(uint16_t)(R28_SPRITE_FIRST+slot),VDPL_WRITE,0,r28_sprite_bytes(slot)};
        vdplet_view_v1 src,dst;dst.lease=0;
        int reason=RALLY_RENDER_REASON_OK;
        int32_t rc=acquire(h,&source,&src);
        if(rc)reason=RALLY_RENDER_REASON_ACQUIRE;
        else if(!view_ok(&src,&source)){rc=VDPL_E_BOUNDS;reason=RALLY_RENDER_REASON_CAPACITY;}
        if(!rc){
            rc=acquire(h,&dest,&dst);
            if(rc)reason=RALLY_RENDER_REASON_ACQUIRE;
            else if(!view_ok(&dst,&dest)){rc=VDPL_E_BOUNDS;reason=RALLY_RENDER_REASON_CAPACITY;}
            else if(objects(src.data,src.bytes,dst.data,dst.bytes)){
                rc=VDPL_E_ARGUMENT;reason=RALLY_RENDER_REASON_ALIAS;
            }else r28_sprite_sample(dst.data,src.data,&p);
        }
        int32_t rd=release(h,&dst),rs=release(h,&src);
        if(rd || rs)return fail(c,RALLY_RENDER_REASON_RELEASE,rd?rd:rs,rd?rd:rs);
        if(rc)return fail(c,reason,rc,reason==RALLY_RENDER_REASON_ACQUIRE?rc:0);
    }
    return 0;
}
