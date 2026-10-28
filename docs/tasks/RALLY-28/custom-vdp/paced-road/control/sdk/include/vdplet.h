#ifndef AGON_VDPLET_ABI_H
#define AGON_VDPLET_ABI_H
#include <stdint.h>

/* VDPlet Runtime ABI, classic ESP32 / windowed Xtensa GCC 8.4. */
#define VDPL_ABI_MAJOR 1u
#define VDPL_ABI_MINOR 0u
#define VDPL_SELECTOR 0xD8u
#define VDPL_DISCOVER 0xD9u
#define VDPL_PROTOCOL 1u
#define VDPL_CAP_BUFFERS 1u
#define VDPL_CAP_PALETTE2 2u
#define VDPL_READ 1u
#define VDPL_WRITE 2u
#define VDPL_WHOLE_BUFFER UINT32_MAX
#define VDPL_FORMAT_PACKED_MSB1 1u
#define VDPL_INIT 1u
#define VDPL_RUN 2u
#define VDPL_FINI 3u
#define VDPL_LOAD 1u
#define VDPL_INVOKE 2u
#define VDPL_UNLOAD 3u
#define VDPL_INFO 4u
#define VDPL_READ16 5u
#define VDPL_REPLY 1u
#define VDPL_REPLY_IDENT 1u
#define VDPL_REPLY_LOADED 2u
#define VDPL_REPLY_DONE 3u
#define VDPL_REPLY_VALUE 4u
#define VDPL_REPLY_ERROR 5u
#define VDPL_OK 0
#define VDPL_E_ARGUMENT 1
#define VDPL_E_BUFFER 2
#define VDPL_E_BOUNDS 3
#define VDPL_E_FORMAT 4
#define VDPL_E_ABI 5
#define VDPL_E_MEMORY 6
#define VDPL_E_BUSY 7
#define VDPL_E_HANDLE 8
#define VDPL_E_UNSUPPORTED 9
#define VDPL_E_IMAGE 10
#define VDPL_E_RELOCATION 11
#define VDPL_E_INIT 12
#define VDPL_E_LIMIT 13

typedef struct vdplet_view_v1 {
    uint32_t struct_bytes;
    uint32_t lease;
    uint8_t *data;
    uint32_t bytes;
    uint32_t access;
} vdplet_view_v1;
typedef struct vdplet_frame_v1 {
    uint32_t struct_bytes;
    uint32_t lease;
    uint32_t format;
    uint32_t width;
    uint32_t height;
    uint32_t row_bytes;
} vdplet_frame_v1;
typedef struct vdplet_request_v1 {
    uint32_t struct_bytes;
    uint16_t operation;
    uint16_t entry_id;
    uint16_t argument_buffer;
    uint16_t reserved;
    uint32_t argument_bytes;
} vdplet_request_v1;
typedef struct vdplet_host_v1 {
    uint32_t struct_bytes;
    uint16_t abi_major;
    uint16_t abi_minor;
    uint32_t capabilities;
    void *context;
    int32_t (*buffer_acquire)(void *, uint16_t, uint16_t, uint32_t, uint32_t, vdplet_view_v1 *);
    int32_t (*buffer_release)(void *, uint32_t);
    int32_t (*frame_begin)(void *, int32_t, int32_t, uint32_t, uint32_t, vdplet_frame_v1 *);
    int32_t (*frame_row)(void *, uint32_t, uint32_t, vdplet_view_v1 *);
    int32_t (*frame_end)(void *, uint32_t);
} vdplet_host_v1;
typedef int32_t (*vdplet_entry_v1)(const vdplet_host_v1 *, const vdplet_request_v1 *);

#if defined(__cplusplus)
static_assert(sizeof(void *) == 4, "ESP32 pointer ABI");
static_assert(sizeof(vdplet_host_v1) == 36, "host ABI");
static_assert(sizeof(vdplet_request_v1) == 16, "request ABI");
static_assert(sizeof(vdplet_view_v1) == 20, "view ABI");
static_assert(sizeof(vdplet_frame_v1) == 24, "frame ABI");
#endif
#endif
