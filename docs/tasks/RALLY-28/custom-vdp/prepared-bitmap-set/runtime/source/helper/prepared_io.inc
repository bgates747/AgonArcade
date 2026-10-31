static const RallyRenderRangeV1 r28_prepared_range={51999,VDPL_READ,0,10628};
static int32_t r28_prepared_admit(const vdplet_host_v1 *h,uint32_t session){
    r28_prepared_session=0;
    for(unsigned i=0;i<8;++i)r28_prepared_counts[i]=0;
    vdplet_view_v1 v;int32_t rc=acquire(h,&r28_prepared_range,&v);
    if(!rc){
        if(!view_ok(&v,&r28_prepared_range))rc=VDPL_E_BOUNDS;
        else {
            for(unsigned i=0;i<64;++i)if(v.data[i]!=r28_prepared_header[i]){rc=VDPL_E_FORMAT;break;}
            if(!rc && hash(v.data+64,10564)!=u32(r28_prepared_header+12))rc=VDPL_E_FORMAT;
        }
    }
    int32_t rr=release(h,&v);if(rr)return rr;
    if(!rc)r28_prepared_session=session;return rc;
}
static int32_t r28_prepared_publish(const vdplet_host_v1 *h){
    const RallyRenderRangeV1 range={51996,VDPL_WRITE,0,32};
    vdplet_view_v1 v;int32_t rc=acquire(h,&range,&v);
    if(!rc){if(!view_ok(&v,&range))rc=VDPL_E_BOUNDS;
        else for(unsigned i=0;i<8;++i){uint32_t n=r28_prepared_counts[i];
            for(unsigned b=0;b<4;++b)v.data[4*i+b]=(uint8_t)(n>>(8*b));}}
    int32_t rr=release(h,&v);r28_prepared_session=0;return rr?rr:rc;
}
