/* Rally-owned scoped output target. Geometry stays in render_core.inc. */
typedef struct R28RoadTarget {
    const vdplet_host_v1 *host;
    const vdplet_host_v1_6 *rows;
    vdplet_color_frame_v1 frame;
    uint32_t token;
    int32_t status;
} R28RoadTarget;

static int32_t r28_rows_begin(const vdplet_host_v1 *host, R28RoadTarget *target) {
    target->host = host;
    target->rows = vdplet_color_frame_host(host);
    target->token = 0;
    target->status = VDPL_OK;
    if (!target->rows)
        return target->status = VDPL_E_UNSUPPORTED;
    vdplet_color_frame_v1 *frame = &target->frame;
    *frame = (vdplet_color_frame_v1){0};
    frame->struct_bytes = sizeof(*frame);
    frame->x = 0;
    frame->y = 104;
    frame->width = 320;
    frame->height = 120;
    target->status = target->rows->color_frame(host->context,
                                               VDPL_COLOR_FRAME_BEGIN, frame);
    if (target->status != VDPL_OK)
        return target->status;
    target->token = frame->lease;
    /* This renderer deliberately supports only the qualified physical layout. */
    if (!target->token || frame->native_format != VDPL_NATIVE_RGB222 ||
        frame->x_bias != 0 || frame->pixel_xor != 2 ||
        frame->color_mask != 0x3f || frame->preserve_mask != 0xc0)
        target->status = VDPL_E_UNSUPPORTED;
    return target->status;
}

static uint8_t *r28_rows_row(R28RoadTarget *target, unsigned y) {
    if (target->status != VDPL_OK)
        return 0;
    target->frame.struct_bytes = sizeof(target->frame);
    target->frame.lease = target->token;
    target->frame.row = y - 104u;
    target->status = target->rows->color_frame(target->host->context,
                              VDPL_COLOR_FRAME_ROW, &target->frame);
    if (target->status != VDPL_OK)
        return 0;
    if (!target->frame.data || target->frame.row_bytes < 320u) {
        target->status = VDPL_E_BOUNDS;
        return 0;
    }
    return target->frame.data;
}

static int32_t r28_rows_end(R28RoadTarget *target) {
    if (!target->token)
        return target->status;
    target->frame.struct_bytes = sizeof(target->frame);
    target->frame.lease = target->token;
    int32_t result = target->rows->color_frame(target->host->context,
                               VDPL_COLOR_FRAME_END, &target->frame);
    target->token = 0;
    return target->status != VDPL_OK ? target->status : result;
}

static void r28_rows_fill(uint8_t *row, int left, int right, uint8_t rgba) {
    /* Alpha in the bitmap is NOT VGA sync. Preserve destination bits instead. */
    const uint8_t rgb = rgba & 0x3f;
    for (int x = left; x < right; ++x) {
        uint8_t *pixel = row + ((unsigned)x ^ 2u);
        *pixel = (*pixel & 0xc0u) | rgb;
    }
}
