/* Fixture-private wrapper; existing INVOKE ABI, no firmware/SDK changes. */
__attribute__((visibility("default")))
int32_t vdplet_entry(const vdplet_host_v1 *h,const vdplet_request_v1 *r) {
    if(!h || !r || h->struct_bytes<sizeof(*h) || r->struct_bytes<sizeof(*r) ||
       h->abi_major!=1 || !(h->capabilities&VDPL_CAP_BUFFERS) ||
       !h->buffer_acquire || !h->buffer_release)return VDPL_E_ABI;
    if(r->operation==VDPL_INIT){phase_enabled=0;phase_error=0;}
    if(r->operation==VDPL_RUN && r->entry_id>=PHASE_FIRST_ENTRY) {
        if(r->argument_bytes!=2 || r->reserved)return VDPL_E_ARGUMENT;
        return phase_private(h,r->entry_id);
    }
    if(r->operation!=VDPL_RUN || !phase_enabled)
        return phase_original_entry(h,r);
    if(phase_error)return phase_error;
    if(phase_cpu()!=phase_core)return phase_bad(VDPL_E_UNSUPPORTED);
    unsigned id=r->entry_id;uint32_t begin=phase_clock();
    int32_t rc=phase_original_entry(h,r);
    uint32_t elapsed=phase_clock()-begin;
    if(phase_cpu()!=phase_core)return phase_bad(VDPL_E_UNSUPPORTED);
    if(rc)return rc;
    if(id==3){if(phase_stage || phase_rendered || phase_ticks>=4)
        return phase_bad(VDPL_E_ARGUMENT);++phase_ticks;phase_values[1]+=elapsed;}
    else if(id==15){if(phase_stage || phase_ticks!=4 || phase_rendered)
        return phase_bad(VDPL_E_ARGUMENT);phase_rendered=1;phase_values[2]=elapsed;}
    return rc;
}
