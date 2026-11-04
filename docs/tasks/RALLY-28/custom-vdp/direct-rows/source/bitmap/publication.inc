/* Rally-owned validation, existing scoped buffer ABI only. Root stays leased
 * by the generated entry. No returned pointer is retained after this call. */
static int32_t r28_check_publication(const vdplet_host_v1 *h,const uint8_t *root,
                                   uint32_t generation,uint32_t request){
    if(get32(root+20)!=generation || get(root+24)!=15 ||
       get32(root+32)!=get32(root+8) || get32(root+292)!=get32(root+8) ||
       get32(root+296)!=request)return VDPL_E_FORMAT;
    vdplet_view_v1 v={sizeof(v),0,0,0,0};
    int32_t rc=h->buffer_acquire(h->context,50304,VDPL_READ,0,48,&v);
    if(rc)return rc;
    if(!v.data || v.bytes!=48)rc=VDPL_E_BOUNDS;
    else if(get(v.data)!=48 || get(v.data+2)!=1 || get32(v.data+4) ||
            get32(v.data+8) || get32(v.data+12)!=get32(root+8) ||
            get32(v.data+16)!=request || get32(v.data+20)!=get32(root+136) ||
            get(v.data+44)!=1 || get(v.data+46))rc=VDPL_E_FORMAT;
    int32_t released=h->buffer_release(h->context,v.lease);
    return released?released:rc;
}
