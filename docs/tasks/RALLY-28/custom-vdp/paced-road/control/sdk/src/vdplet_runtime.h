#ifndef AGON_VDPLET_RUNTIME_H
#define AGON_VDPLET_RUNTIME_H
#include <esp_heap_caps.h>
#include <memory>
#include "vdplet.h"
#include "vdplet_image.h"

namespace vdpl_runtime {
struct Lease {
    std::shared_ptr<BufferStream> owner;
    uint32_t token=0, offset=0, bytes=0, access=0;
    uint16_t buffer=0;
};
struct Runtime {
    vdpl::Image image;
    Lease leases[4];
    std::shared_ptr<BufferStream> argument_owner;
    uint16_t handle=0;
    uint32_t generation=0, lease_generation=0, loads=0;
    uint16_t last_status=0, argument_buffer=65535;
    bool busy=false;
    uint32_t frame_lease=0, frame_width=0, frame_height=0;
    int32_t frame_x=0, frame_y=0;
};
static Runtime state;
static void *allocate(uint32_t bytes, bool executable) {
    return heap_caps_malloc(bytes, executable ? MALLOC_CAP_EXEC|MALLOC_CAP_32BIT : MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT);
}
static void release(void *p) { heap_caps_free(p); }
static void close_leases() { for (auto &lease:state.leases) lease=Lease{}; }
static void close_frame() {
    if (state.frame_lease) canvas->endUpdate();
    state.frame_lease=0;
    state.frame_width=state.frame_height=0;
}
static int32_t acquire(void *, uint16_t buffer, uint16_t access,
                       uint32_t offset, uint32_t bytes, vdplet_view_v1 *out) {
    if (!state.busy || !out || out->struct_bytes<sizeof(*out) ||
        (access!=VDPL_READ && access!=VDPL_WRITE)) return VDPL_E_ARGUMENT;
    if (access==VDPL_WRITE && buffer==state.argument_buffer) return VDPL_E_ARGUMENT;
    auto it=buffers.find(buffer);
    if (it==buffers.end() || it->second.size()!=1 || !it->second[0]) return VDPL_E_BUFFER;
    auto owner=it->second[0];
    if (access==VDPL_WRITE && owner==state.argument_owner) return VDPL_E_ARGUMENT;
    // Resolve the whole-block sentinel before any offset/length arithmetic.
    if (offset>owner->size()) return VDPL_E_BOUNDS;
    if (bytes==VDPL_WHOLE_BUFFER) bytes=owner->size()-offset;
    if (!vdpl::span(offset,bytes,owner->size())) return VDPL_E_BOUNDS;
    Lease *free=nullptr;
    for (auto &lease:state.leases) {
        if (!lease.token) { if (!free) free=&lease; continue; }
        if (lease.owner==owner && (access==VDPL_WRITE || lease.access==VDPL_WRITE) &&
            (offset<=lease.offset ? lease.offset-offset<bytes : offset-lease.offset<lease.bytes)) return VDPL_E_BUSY;
    }
    if (!free || state.lease_generation==UINT32_MAX) return VDPL_E_LIMIT;
    free->owner=owner; free->buffer=buffer; free->offset=offset;
    free->bytes=bytes; free->access=access; free->token=++state.lease_generation;
    *out={sizeof(*out),free->token,owner->getBuffer()+offset,bytes,access};
    return VDPL_OK;
}
static int32_t relinquish(void *, uint32_t token) {
    if (!state.busy || !token) return VDPL_E_ARGUMENT;
    for (auto &lease:state.leases) if (lease.token==token) { lease=Lease{}; return VDPL_OK; }
    return VDPL_E_HANDLE;
}
static int32_t frame_begin(void *, int32_t x, int32_t y, uint32_t width,
                           uint32_t height, vdplet_frame_v1 *out) {
    if (!state.busy || !out || out->struct_bytes<sizeof(*out)) return VDPL_E_ARGUMENT;
    if (state.frame_lease) return VDPL_E_BUSY;
    if (!_VGAController || !canvas || getVGAColourDepth()!=2 ||
        _VGAController->nativePixelFormat()!=fabgl::NativePixelFormat::PALETTE2 ||
        _VGAController->isDoubleBuffered()) return VDPL_E_UNSUPPORTED;
    int32_t screen_width=_VGAController->getViewPortWidth();
    int32_t screen_height=_VGAController->getViewPortHeight();
    if (x<0 || y<0 || !width || !height || x>=screen_width || y>=screen_height ||
        width>uint32_t(screen_width-x) || height>uint32_t(screen_height-y)) return VDPL_E_BOUNDS;
    if ((x&7) || (width&7)) return VDPL_E_ARGUMENT;
    if (state.lease_generation==UINT32_MAX) return VDPL_E_LIMIT;
    // Validate every mapping before the module can write any row. Rows are
    // controller-owned and cannot change mode while this command is active.
    for (uint32_t row=0;row<height;++row)
        if (!fabgl::VGAPalettedController::sgetScanline(y+row)) return VDPL_E_FORMAT;
    canvas->beginUpdate();
    canvas->waitCompletion(false);
    state.frame_lease=++state.lease_generation;
    state.frame_x=x; state.frame_y=y;
    state.frame_width=width; state.frame_height=height;
    *out={sizeof(*out),state.frame_lease,VDPL_FORMAT_PACKED_MSB1,width,height,width/8};
    return VDPL_OK;
}
static int32_t frame_row(void *, uint32_t lease, uint32_t row, vdplet_view_v1 *out) {
    if (!state.busy || !out || out->struct_bytes<sizeof(*out)) return VDPL_E_ARGUMENT;
    if (!state.frame_lease || state.frame_lease!=lease) return VDPL_E_HANDLE;
    if (row>=state.frame_height) return VDPL_E_BOUNDS;
    *out={sizeof(*out),lease,fabgl::VGAPalettedController::sgetScanline(state.frame_y+row)+state.frame_x/8,
          state.frame_width/8,VDPL_WRITE};
    return VDPL_OK;
}
static int32_t frame_end(void *, uint32_t lease) {
    if (!state.busy) return VDPL_E_ARGUMENT;
    if (!state.frame_lease || state.frame_lease!=lease) return VDPL_E_HANDLE;
    close_frame();
    return VDPL_OK;
}
static const vdplet_host_v1 host={sizeof(vdplet_host_v1),VDPL_ABI_MAJOR,VDPL_ABI_MINOR,
    VDPL_CAP_BUFFERS|VDPL_CAP_PALETTE2,&state,acquire,relinquish,frame_begin,frame_row,frame_end};
static int32_t call(uint16_t operation, uint16_t entry, uint16_t arguments, uint32_t argument_bytes) {
    if (state.busy) return VDPL_E_BUSY;
    if (!state.image.entry) return VDPL_E_HANDLE;
    vdplet_request_v1 request={sizeof(request),operation,entry,arguments,0,argument_bytes};
    state.busy=true;
    state.argument_buffer=arguments;
    if (arguments!=65535) {
        auto it=buffers.find(arguments);
        if (it!=buffers.end() && it->second.size()==1) state.argument_owner=it->second[0];
    }
    // Internal IRAM is uncached on classic ESP32. Order writes and instruction fetch.
    __asm__ __volatile__("memw\n\tisync" ::: "memory");
    auto function=reinterpret_cast<vdplet_entry_v1>(state.image.entry);
    int32_t result=function(&host,&request);
    close_frame();
    close_leases();
    state.argument_owner.reset();
    state.argument_buffer=65535;
    state.busy=false;
    return result;
}
static int32_t install(uint16_t buffer, uint32_t bytes) {
    if (state.busy || state.handle) return VDPL_E_BUSY;
    if (state.generation>=65535) return VDPL_E_LIMIT;
    auto it=buffers.find(buffer);
    if (it==buffers.end() || it->second.size()!=1 || !it->second[0]) return VDPL_E_BUFFER;
    auto source=it->second[0];
    if (source->size()!=bytes) return VDPL_E_BOUNDS;
    int32_t rc=vdpl::load(source->getBuffer(),bytes,state.image,allocate,release,host.capabilities);
    if (rc) return rc;
    rc=call(VDPL_INIT,0,65535,0);
    if (rc) { vdpl::dispose(state.image,release); return rc; }
    state.handle=uint16_t(++state.generation);
    ++state.loads;
    force_debug_log("VDPL LOAD handle=%u build=%08x entry=%08x text=%08x/%u data=%08x/%u relocs=%u\n\r",
        state.handle,state.image.build,unsigned(state.image.entry),unsigned(uintptr_t(state.image.text)),
        state.image.text_bytes,unsigned(uintptr_t(state.image.data)),state.image.data_bytes,state.image.relocation_count);
    return VDPL_OK;
}
static int32_t invoke(uint16_t handle, uint16_t entry, uint16_t arguments) {
    if (!state.handle || handle!=state.handle) return VDPL_E_HANDLE;
    auto it=buffers.find(arguments);
    if (it==buffers.end() || it->second.size()!=1 || !it->second[0]) return VDPL_E_BUFFER;
    auto owner=it->second[0];
    if (owner->size()>32) return VDPL_E_ARGUMENT;
    return call(VDPL_RUN,entry,arguments,owner->size());
}
static int32_t unload(uint16_t handle) {
    if (state.busy) return VDPL_E_BUSY;
    if (!state.handle || handle!=state.handle) return VDPL_E_HANDLE;
    int32_t rc=call(VDPL_FINI,0,65535,0);
    vdpl::dispose(state.image,release);
    state.handle=0;
    force_debug_log("VDPL UNLOAD status=%d\n\r",rc);
    return rc;
}
static int32_t info(uint16_t field, uint16_t &value) {
    uint32_t wide=0;
    switch (field) {
        case 0: value=0x0100; break;
        case 1: value=host.capabilities; break;
        case 2: value=state.handle; break;
        case 3: value=state.last_status; break;
        case 4: value=state.image.text_bytes; break;
        case 5: value=state.image.data_bytes; break;
        case 6: value=state.image.entry&65535; break;
        case 7: value=(state.image.entry>>16)&65535; break;
        case 8: value=state.loads; break;
        case 9: case 10: wide=heap_caps_get_free_size(MALLOC_CAP_EXEC|MALLOC_CAP_32BIT); value=wide>>((field-9)*16); break;
        case 11: case 12: wide=heap_caps_get_largest_free_block(MALLOC_CAP_EXEC|MALLOC_CAP_32BIT); value=wide>>((field-11)*16); break;
        case 13: case 14: wide=heap_caps_get_free_size(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT); value=wide>>((field-13)*16); break;
        case 15: case 16: wide=heap_caps_get_largest_free_block(MALLOC_CAP_INTERNAL|MALLOC_CAP_8BIT); value=wide>>((field-15)*16); break;
        case 17: value=uxTaskGetStackHighWaterMark(nullptr); break; // ESP-IDF reports bytes.
        default: return VDPL_E_UNSUPPORTED;
    }
    return VDPL_OK;
}
static int32_t read16(uint16_t buffer, uint32_t offset, uint16_t &value) {
    auto it=buffers.find(buffer);
    if (it==buffers.end() || it->second.size()!=1 || !it->second[0]) return VDPL_E_BUFFER;
    auto owner=it->second[0];
    if (!vdpl::span(offset,2,owner->size())) return VDPL_E_BOUNDS;
    value=vdpl::u16(owner->getBuffer()+offset);
    return VDPL_OK;
}
}

void VDUStreamProcessor::vdu_sys_vdplet(bool discovery) {
    auto reply=[this](uint8_t kind,uint16_t token,uint16_t value) {
        uint8_t bytes[]={'V','D','P','L',VDPL_PROTOCOL,kind,uint8_t(token),uint8_t(token>>8),uint8_t(value),uint8_t(value>>8)};
        send_packet(PACKET_KEYCODE,sizeof(bytes),bytes);
    };
    if (discovery) { reply(VDPL_REPLY_IDENT,0,vdpl_runtime::host.capabilities); return; }
    int32_t length=readWord_t();
    if (length<0) return;
    uint8_t payload[32];
    if (length>32) {
        uint32_t remaining=length;
        while (remaining) {
            uint32_t chunk=std::min<uint32_t>(remaining,sizeof(payload));
            if (readIntoBuffer(payload,chunk)) return;
            remaining-=chunk;
        }
        vdpl_runtime::state.last_status=VDPL_E_ARGUMENT;
        return;
    }
    if (readIntoBuffer(payload,length)) { vdpl_runtime::state.last_status=VDPL_E_ARGUMENT; return; }
    if (length<6) { vdpl_runtime::state.last_status=VDPL_E_ARGUMENT; return; }
    uint16_t token=vdpl::u16(payload+2), value=0;
    uint8_t operation=payload[1], flags=payload[4], kind=VDPL_REPLY_DONE;
    int32_t rc=VDPL_OK;
    if (payload[0]!=VDPL_PROTOCOL) rc=VDPL_E_ABI;
    else if ((flags&~VDPL_REPLY) || payload[5]) rc=VDPL_E_ARGUMENT;
    else switch (operation) {
        case VDPL_LOAD:
            if (length!=14 || vdpl::u16(payload+12)) rc=VDPL_E_ARGUMENT;
            else { rc=vdpl_runtime::install(vdpl::u16(payload+6),vdpl::u32(payload+8)); value=vdpl_runtime::state.handle; kind=VDPL_REPLY_LOADED; }
            break;
        case VDPL_INVOKE:
            if (length!=12) rc=VDPL_E_ARGUMENT;
            else rc=vdpl_runtime::invoke(vdpl::u16(payload+6),vdpl::u16(payload+8),vdpl::u16(payload+10));
            break;
        case VDPL_UNLOAD:
            if (length!=8) rc=VDPL_E_ARGUMENT;
            else rc=vdpl_runtime::unload(vdpl::u16(payload+6));
            break;
        case VDPL_INFO:
            if (length!=8) rc=VDPL_E_ARGUMENT;
            else { rc=vdpl_runtime::info(vdpl::u16(payload+6),value); kind=VDPL_REPLY_VALUE; }
            break;
        case VDPL_READ16:
            if (length!=12) rc=VDPL_E_ARGUMENT;
            else { rc=vdpl_runtime::read16(vdpl::u16(payload+6),vdpl::u32(payload+8),value); kind=VDPL_REPLY_VALUE; }
            break;
        default: rc=VDPL_E_UNSUPPORTED;
    }
    if (rc || (operation!=VDPL_INFO && operation!=VDPL_READ16)) vdpl_runtime::state.last_status=uint16_t(rc);
    if (rc) { kind=VDPL_REPLY_ERROR; value=uint16_t(rc); force_debug_log("VDPL ERROR op=%u status=%d\n\r",operation,rc); }
    if (flags&VDPL_REPLY) reply(kind,token,value);
}
#endif
