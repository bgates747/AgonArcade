/* RALLY-28 span experiment. Frozen float/quad endpoints and legacy band rows.
   This file is inserted after the ordinary command/geometry helpers. */
#include <string.h>
#define R28_SPAN_BUFFER 50700u
#define R28_SPAN_WIDTH 320
#define R28_SPAN_TOP 104
#define R28_SPAN_HEIGHT 120
#define R28_SPAN_BYTES (R28_SPAN_WIDTH * R28_SPAN_HEIGHT)
static const RallyRenderRangeV1 r28_span_range = {R28_SPAN_BUFFER, VDPL_WRITE, 0, R28_SPAN_BYTES};

/* Default 64-colour mode palette -> opaque AABBGGRR, not physical VGA bytes.
   Relevant logical colours: grass2, asphalt8, red9, yellow11 and white15. */
static uint8_t r28_span_colour(int logical) {
    switch (logical) {
    case 2: return 0xc8;
    case 8: return 0xd5;
    case 9: return 0xc3;
    case 11: return 0xcf;
    default: return 0xff;
    }
}

/* floor quotient and positive remainder make each step exact for both slopes.
   The displayed intersection is ceil(top + step * delta/height), as in fillPath. */
typedef struct { int x, q, r, error, height; } R28SpanEdge;
static R28SpanEdge r28_span_edge(int top, int bottom, int height) {
    int delta = bottom - top, q = delta / height, r = delta % height;
    if (r < 0) { --q; r += height; }
    R28SpanEdge e = {top, q, r, 0, height};
    return e;
}
static int r28_span_step(R28SpanEdge *e) {
    e->x += e->q;
    e->error += e->r;
    if (e->error >= e->height) { ++e->x; e->error -= e->height; }
    return e->x + (e->error != 0);
}
static int r28_span_clip(int x) { return x < 0 ? 0 : x > R28_SPAN_WIDTH ? R28_SPAN_WIDTH : x; }
static void r28_span_fill(uint8_t *row, int left, int right, uint8_t colour) {
    if (left < right) memset(row + left, colour, (unsigned)(right - left));
}
static void r28_span_edges(int ct, int cb, int yt, int yb, int *top, int *bottom) {
    static const int boundaries[10] = {-106,-90,-86,-84,-2,2,84,86,90,106};
    float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
    float b = (float)(cb - ct);
    float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
    for (int i = 0; i < 10; ++i) {
        int u = boundaries[i];
        float x = a * (float)u;
        x = x + b * 0.0f;
        x = x + c * (float)(u * 0);
        x = x + (float)ct;
        top[i] = (int)x;
        x = a * (float)u;
        x = x + b;
        x = x + c * (float)u;
        x = x + (float)ct;
        bottom[i] = (int)x;
    }
}
static int r28_span_section(uint8_t *pixels, int ct, int cb, int yt, int yb, int marked) {
    if (!pixels || yt < R28_SPAN_TOP || yb > R28_SPAN_TOP + R28_SPAN_HEIGHT || yt >= yb)
        return 0;
    int top[10], bottom[10];
    R28SpanEdge edge[10];
    r28_span_edges(ct, cb, yt, yb, top, bottom);
    for (int i = 0; i < 10; ++i) {
        if (i && (top[i] < top[i-1] || bottom[i] < bottom[i-1])) return 0;
        edge[i] = r28_span_edge(top[i], bottom[i], yb - yt);
    }
    uint8_t kerb = r28_span_colour(marked ? 9 : 15);
    uint8_t line = r28_span_colour(marked ? 11 : 15);
    for (int y = yt + 1; y <= yb; ++y) {
        int x[10];
        for (int i = 0; i < 10; ++i) x[i] = r28_span_clip(r28_span_step(&edge[i]));
        if (y >= R28_SPAN_TOP + R28_SPAN_HEIGHT) continue;
        uint8_t *row = pixels + (y - R28_SPAN_TOP) * R28_SPAN_WIDTH;
        r28_span_fill(row, 0, x[0], r28_span_colour(2));
        for (int i = 0; i < 9; ++i) {
            uint8_t colour = i == 0 || i == 8 ? kerb :
                             i == 2 || i == 6 || (i == 4 && marked) ? line : r28_span_colour(8);
            int next = i + 1;
            if (i == 3 && !marked) next = 6;
            r28_span_fill(row, x[i], x[next], colour);
            i = next - 1;
        }
        r28_span_fill(row, x[9], R28_SPAN_WIDTH, r28_span_colour(2));
    }
    return 1;
}
static void r28_span_bitmap(Out *o) {
    affine(o, 65535); /* Ordinary untransformed plot, irrespective of old state. */
    byte(o, 23); byte(o, 27); byte(o, 32); word(o, R28_SPAN_BUFFER);
    byte(o, 23); byte(o, 27); byte(o, 3); word(o, 0); word(o, R28_SPAN_TOP);
}
