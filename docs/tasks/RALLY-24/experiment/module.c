/* Native Rally visual generator. No SDK/runtime edits or host game dependency. */
#include "vdplet.h"
#include <stddef.h>
#ifdef __XTENSA__
/* GCC lowers aggregate initialization/copies to these even with -fno-builtin. */
void *memset(void *dst, int c, size_t n) {
    volatile uint8_t *p = dst;
    while (n--)
        *p++ = (uint8_t)c;
    return dst;
}
void *memcpy(void *dst, const void *src, size_t n) {
    volatile uint8_t *d = dst;
    const volatile uint8_t *s = src;
    while (n--)
        *d++ = *s++;
    return dst;
}
#endif
#include ".work/asset_meta.h"
#ifndef VDPL_VARIANT
#define VDPL_VARIANT 2
#endif
static uint16_t u16(const uint8_t *p) { return p[0] | (uint16_t)p[1] << 8; }
static uint32_t u32(const uint8_t *p) { return u16(p) | (uint32_t)u16(p + 2) << 16; }
static int s16(const uint8_t *p) { return (int16_t)u16(p); }
static int32_t s32(const uint8_t *p) { return (int32_t)u32(p); }
static void w16(uint8_t *p, unsigned v) {
    p[0] = v;
    p[1] = v >> 8;
}
static void w32(uint8_t *p, uint32_t v) {
    w16(p, v);
    w16(p + 2, v >> 16);
}
static void copy(uint8_t *d, const uint8_t *s, unsigned n) {
    while (n--)
        *d++ = *s++;
}
static int equal(const uint8_t *a, const uint8_t *b, unsigned n) {
    while (n--)
        if (*a++ != *b++)
            return 0;
    return 1;
}
static uint32_t hash(const uint8_t *p, unsigned n) {
    uint32_t h = 2166136261u;
    while (n--)
        h = (h ^ *p++) * 16777619u;
    return h;
}
static uint8_t config[32], state[112];
static unsigned bound, which, last_seq;
static const unsigned sizes[6] = {112, 0, 32, 20480, 2048, 256};
/* Never retain acquired pointers in persistent module state. */
typedef struct {
    const uint8_t *t[10];
    int lap, count, bin_offset, f, ff;
    const uint8_t *coeff;
} Assets;
typedef struct {
    uint8_t *p;
    unsigned n, cap;
    int error;
} Out;
static void byte(Out *o, unsigned v) {
    if (o->n < o->cap)
        o->p[o->n++] = v;
    else
        o->error = 1;
}
static void word(Out *o, int v) {
    byte(o, v);
    byte(o, (unsigned)v >> 8);
}
static void command(Out *o, unsigned id, unsigned op) {
    byte(o, 23);
    byte(o, 0);
    byte(o, 160);
    word(o, id);
    byte(o, op);
}
static void end(Out *o) { command(o, 65535, 7); }
static void plot(Out *o, int op, int x, int y) {
    byte(o, 25);
    byte(o, op);
    word(o, x);
    word(o, y);
}
static void colour(Out *o, int c) {
    byte(o, 18);
    byte(o, 0);
    byte(o, c);
}
static void rect(Out *o, int x, int y, int xx, int yy, int c) {
    colour(o, c);
    plot(o, 4, x, y);
    plot(o, 101, xx, yy);
}
static void viewport(Out *o, int top) {
    byte(o, 24);
    word(o, 0);
    word(o, 223);
    word(o, 319);
    word(o, top);
    plot(o, 4, 0, top);
}
static void affine(Out *o, int id) {
    byte(o, 23);
    byte(o, 0);
    byte(o, 150);
    byte(o, 1);
    word(o, id);
}
static void bitmap(Out *o, int b, int matrix, int x, int y) {
    byte(o, 23);
    byte(o, 27);
    byte(o, 0);
    byte(o, b);
    affine(o, matrix);
    byte(o, 23);
    byte(o, 27);
    byte(o, 3);
    word(o, x);
    word(o, y);
}
static void matrix(Out *o, int id, int xx, int scale, int translation) {
    command(o, id, 32);
    byte(o, 0);
    command(o, id, 32);
    byte(o, 11);
    byte(o, 200);
    word(o, xx);
    word(o, 0);
    word(o, translation);
    word(o, 0);
    word(o, scale);
    word(o, 0);
}
/* FractionQ14 cannot be reconstructed from Q12: keep its two low bits. */
static int centre_exact(const Assets *a, int y, int fraction14) {
    if (y < 103 || y > 224)
        return 40960;
    int q = y - 96, k = (fraction14 + s32(a->t[7] + q * 4)) >> 14;
    const uint8_t *z = a->coeff + k * 12;
    int aa = s16(z) * 4 + s16(z + 2) * a->f / 4096;
    int bb = s32(z + 4) + s16(z + 8) * a->f / 4096 + s16(z + 10) * a->ff / 4096;
    return aa + bb * q / 16;
}
static int frac14;
static int cx(const Assets *a, int y) { return centre_exact(a, y, frac14) / 256; }
static int nearest(int n) { return n >= 0 ? (n + 128) / 256 : -((-n + 128) / 256); }
static void section(Out *o, int ct, int cb, int yt, int yb, int marked) {
#if VDPL_VARIANT == 1
    command(o, 30000, 5);
    byte(o, 194);
    word(o, 0);
    word(o, 8);
    word(o, ct);
    word(o, cb);
    word(o, yt);
    word(o, yb);
    command(o, marked ? 30008 : 30009, 1);
#else
    /* Preserve binary32 matrix order; conversion is explicit signed truncation.
       Physical DSP accumulator parity remains a later qualification gate. */
    float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
    float b = (float)(cb - ct), c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
    static const int left[5] = {-106, -90, -86, 84, -2}, right[5] = {106, 90, -84, 86, 2};
    for (int i = 0; i < (marked ? 5 : 4); ++i) {
        colour(o, i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : (marked ? 11 : 15));
        for (int v = 0; v < 2; ++v)
            for (int side = 0; side < 2; ++side) {
                int u = side ? right[i] : left[i];
                float x = a * (float)u;
                x = x + b * (float)v;
                x = x + c * (float)(u * v);
                x = x + (float)ct;
                plot(o, v ? 85 : 4, (int)x, v ? yb : yt);
            }
    }
#endif
}
static int ahead(int car, int camera, int lap) {
    int d = car - camera;
    return d < 0 ? d + lap : d;
}
static unsigned road(Out *o, const Assets *a) {
    int pos = s32(state + 20), phase = u16(state + 24), first = phase < 4000;
    const uint8_t *stripe = a->t[6] + u16(a->t[5] + a->t[4][phase % 4000] * 2);
    const uint8_t *curve = a->t[3] + u16(a->t[2] + (pos / 1600 + a->bin_offset) * 2);
    int y = 104, ct = nearest(centre_exact(a, y, frac14)), marked = 0;
    unsigned bands = 0;
    rect(o, 0, 104, 319, 223, 2);
    while (y < 224 && bands < 120) {
        int yc = *curve + 1, ys = *stripe, yy = yc < ys ? yc : ys;
        if (yy <= y || yy > 224) {
            o->error = 1;
            break;
        }
        int cb = nearest(centre_exact(a, yy, frac14));
        section(o, ct, cb, y, yy, marked);
        ++bands;
        if (yy == yc)
            ++curve;
        if (yy == ys) {
            marked = yy == 116 ? first : !marked;
            ++stripe;
        }
        y = yy;
        ct = cb;
    }
    rect(o, 0, 224, 319, 239, 0);
    int z = ahead(0, pos, a->lap) / 100;
    if (z >= 64 && z <= 1000) {
        int yy = 96 + 8000 / z, h = (yy - 96) / 16;
        if (h < 1)
            h = 1;
        if (yy >= 104 && yy <= 223)
            for (int row = 0; row < 2; ++row) {
                int r = yy + row * h;
                if (r > 223)
                    break;
                int c = cx(a, r), half = (r - 96) * 90 / 50, bottom = r + h - 1;
                if (bottom > 223)
                    bottom = 223;
                for (int j = 0; j < 12; ++j)
                    rect(o, c - half + half * 2 * j / 12, r, c - half + half * 2 * (j + 1) / 12 - 1,
                         bottom, ((j + row) & 1) ? 15 : 0);
            }
    }
    end(o);
    return bands;
}
static int tangent(const Assets *a, int pos, int axis) {
    int d = (pos / 100) * 256, index = d >> 14, f = d & 16383,
        next = index + 1 == a->count ? 0 : index + 1;
    int x = s16(a->t[1] + index * 8 + axis), y = s16(a->t[1] + next * 8 + axis);
    return x + ((y - x) * f >> 14);
}
static int bearing(const Assets *a, int center) {
    int x = center - 160, neg = x < 0;
    if (neg)
        x = -x;
    if (x > 512)
        x = 512;
    int i = x >> 1, v = s16(a->t[8] + i * 2);
    if (x & 1)
        v += (s16(a->t[8] + (i + 1) * 2) - v + 1) / 2;
    return neg ? -v : v;
}
static int heading(const Assets *a, int cross) {
    int neg = cross < 0;
    if (neg)
        cross = -cross;
    if (cross > 4096)
        cross = 4096;
    int i, f, s;
    if (cross <= 3584) {
        i = cross >> 5;
        f = cross & 31;
        s = 5;
    } else if (cross <= 3968) {
        i = 112 + ((cross - 3584) >> 3);
        f = (cross - 3584) & 7;
        s = 3;
    } else {
        i = 160 + cross - 3968;
        f = 0;
        s = 0;
    }
    int v = s16(a->t[9] + i * 2);
    if (f)
        v += ((s16(a->t[9] + (i + 1) * 2) - v) * f) >> s;
    return neg ? -v : v;
}
typedef struct {
    int bitmap, matrix, scale, xx, translation, x, y;
} Car;
static int view(int yaw) {
    if (yaw < 0)
        yaw = -yaw;
    int v = (yaw + 672) / 1344;
    return v > 4 ? 4 : v;
}
static unsigned actors(Out *o, const Assets *a, unsigned *sign_count) {
    static Car cars[6], signs[2];
    static int order[6], distance[6];
    int pos = s32(state + 20), flags = u16(state + 32), n = 0, ns = 0;
    for (int i = 0; i < 6; ++i) {
        order[i] = i;
        distance[i] = state[50 + i * 12] ? ahead(s32(state + 40 + i * 12), pos, a->lap) : 0;
    }
    for (int i = 0; i < 5; ++i)
        for (int j = i + 1; j < 6; ++j)
            if (distance[order[i]] < distance[order[j]]) {
                int t = order[i];
                order[i] = order[j];
                order[j] = t;
            }
    int tx = tangent(a, pos, 4), ty = tangent(a, pos, 6);
    for (int j = 0; j < 6; ++j) {
        int i = order[j];
        const uint8_t *p = state + 40 + i * 12;
        int z = distance[i] / 100;
        if (!(flags & 1) || !p[10] || z < 64 || z > 1100)
            continue;
        int q = 8000 / z, y = 96 + q, c = cx(a, y) + (s32(p + 4) / 256) * q / 50, scale = q * 2;
        int cross = (tx * tangent(a, s32(p), 6) - ty * tangent(a, s32(p), 4)) / 4096;
        int yaw = heading(a, cross) + ((i & 1) ? -1 : 1) * s16(p + 8);
        if (flags & 4)
            yaw -= bearing(a, c);
        Car r = {(i + 1) * 5 + view(yaw),
                 63970 + i,
                 scale,
                 yaw > 0 ? -scale : scale,
                 yaw > 0 ? 101 * scale : 0,
                 c - 51 * scale / 256,
                 y - 70 * scale / 256};
        cars[n++] = r;
    }
    int total = a->lap / 48000, near = pos * total / a->lap;
    for (int k = -1; k <= 2; ++k) {
        int i = (near + k + total) % total, station = (i * a->lap / total + 24000) % a->lap,
            z = ahead(station, pos, a->lap) / 100;
        if (z < 64 || z > 500)
            continue;
        int q = 8000 / z, ground = 96 + q, scale = q * 2, y = ground - 64 * scale / 256;
        if (y < 104 || ground > 223)
            continue;
        int x = cx(a, ground) + ((i & 1) ? -1 : 1) * 134 * q / 50 - 32 * scale / 256;
        if (x >= 320 || x + 64 * scale / 256 <= 0)
            continue;
        if (ns < 2) {
            Car r = {120 + i % 8, 63930, scale, scale, 0, x, y};
            signs[ns++] = r;
        }
    }
    if (ns == 2 && signs[0].scale > signs[1].scale) {
        Car t = signs[0];
        signs[0] = signs[1];
        signs[1] = t;
    }
    int c = 0, s = 0;
    while (c < n || s < ns) {
        int sign = s < ns && (c == n || signs[s].scale <= cars[c].scale);
        Car *r = sign ? &signs[s++] : &cars[c++];
        if (sign)
            viewport(o, 104);
        matrix(o, r->matrix, r->xx, r->scale, r->translation);
        bitmap(o, r->bitmap, r->matrix, r->x, r->y);
        if (sign)
            viewport(o, flags & 2 ? 88 : 24);
    }
    affine(o, 65535);
    end(o);
    *sign_count = ns;
    return n;
}
static void player(Out *o, const Assets *a) {
    int c = cx(a, 214) + s32(state + 28) * 118 / (50 * 256), remaining = u16(state + 34),
        inv = u16(state + 36), steering = s16(state + 26);
    if (remaining) {
        int age = 150 - remaining, radius = 8 + (age < 60 ? age / 3 : 20 - (age - 60) / 5);
        if (radius < 4)
            radius = 4;
        const int8_t dx[8] = {0, 7, 10, 7, 0, -7, -10, -7}, dy[8] = {-10, -7, 0, 7, 10, 7, 0, -7};
        for (int i = 0; i < 8; ++i) {
            int x = c + dx[i] * radius / 10, y = 193 + dy[i] * radius / 10,
                size = 3 + (i + age / 8) % 6;
            rect(o, x - size, y - size, x + size, y + size,
                 (i + age / 6) % 3 == 0 ? 15 : ((i & 1) ? 11 : 9));
        }
        rect(o, c - 6, 187, c + 6, 199, 15);
    } else if (!inv || !((inv / 10) & 1)) {
        int yaw = steering * 256 - bearing(a, c), mirror, v;
        if (u16(state + 32) & 4) {
            v = view(yaw);
            mirror = yaw > 0;
        } else {
            mirror = steering > 0;
            v = ((steering < 0 ? -steering : steering) * 4 + 10) / 21;
        }
        bitmap(o, v, mirror ? 63984 : 65535, c - (mirror ? 50 : 51), 154);
        affine(o, 65535);
    }
    end(o);
}
static int acquire(const vdplet_host_v1 *h, unsigned id, unsigned access, vdplet_view_v1 *v) {
    v->struct_bytes = sizeof(*v);
    v->lease = 0;
    return h->buffer_acquire(h->context, id, access, 0, VDPL_WHOLE_BUFFER, v);
}
static void release(const vdplet_host_v1 *h, vdplet_view_v1 *v) {
    if (v->lease)
        h->buffer_release(h->context, v->lease);
    v->lease = 0;
}
static int state_valid(const Assets *a) {
    if (u32(state) != 0x53343252u || u16(state + 4) != 1 || u16(state + 6) != 112 ||
        u32(state + 8) != u32(config + 8) || !u32(state + 12) || u32(state + 12) <= last_seq ||
        u32(state + 20) >= (unsigned)a->lap || u16(state + 24) >= 8000 || s16(state + 26) < -21 ||
        s16(state + 26) > 21 || s32(state + 28) < -38400 || s32(state + 28) > 38400 ||
        u16(state + 32) > 7 || u16(state + 34) > 150 || u16(state + 36) > 120 || u16(state + 38))
        return 0;
    for (int i = 0; i < 6; ++i) {
        const uint8_t *p = state + 40 + i * 12;
        if (p[10] > 1 || p[11])
            return 0;
        if (!p[10]) {
            for (int j = 0; j < 10; ++j)
                if (p[j])
                    return 0;
        } else if (u32(p) >= (unsigned)a->lap || s32(p + 4) < -14260 || s32(p + 4) > 14260 ||
                   s16(p + 8) < -1920 || s16(p + 8) > 1920)
            return 0;
    }
    return 1;
}
__attribute__((visibility("default"))) int32_t vdplet_entry(const vdplet_host_v1 *h,
                                                            const vdplet_request_v1 *r) {
    if (!h || !r || h->struct_bytes < sizeof(*h) || r->struct_bytes < sizeof(*r) ||
        h->abi_major != 1 || !(h->capabilities & 1) || !h->buffer_acquire || !h->buffer_release)
        return VDPL_E_ABI;
    if (r->operation == VDPL_INIT || r->operation == VDPL_FINI) {
        bound = last_seq = 0;
        return 0;
    }
    if (r->operation != VDPL_RUN || r->entry_id > 1)
        return VDPL_E_UNSUPPORTED;
    if (r->entry_id == 0)
        bound = last_seq = 0;
    if (r->reserved || r->argument_bytes != 32)
        return VDPL_E_ARGUMENT;
    vdplet_view_v1 v = {0}, asset = {0}, status = {0};
    uint8_t args[32];
    int rc = acquire(h, r->argument_buffer, VDPL_READ, &v);
    if (rc)
        return rc;
    if (v.bytes != 32) {
        release(h, &v);
        return VDPL_E_ARGUMENT;
    }
    copy(args, v.data, 32);
    release(h, &v);
    if (u32(args) != 0x41343252u || u16(args + 4) != 1 || u16(args + 6) != 32 || !u32(args + 8) ||
        u32(args + 28))
        return VDPL_E_ARGUMENT;
    if (r->entry_id == 0) {
        bound = 0;
        last_seq = 0;
        which = u32(args + 24) == asset_meta[0][0] ? 0 : 1;
        if (u32(args + 24) != asset_meta[which][0])
            return VDPL_E_FORMAT;
        /* Check all application ranges including arguments, even read aliases. */
        uintptr_t starts[7];
        unsigned lengths[7];
        for (unsigned i = 0; i < 7; ++i) {
            unsigned id = i == 6 ? r->argument_buffer : u16(args + 12 + 2 * i);
            rc = acquire(h, id, VDPL_READ, &v);
            if (rc)
                return rc;
            starts[i] = (uintptr_t)v.data;
            lengths[i] = v.bytes;
            release(h, &v);
            unsigned expected = i == 6 ? 32 : i == 1 ? asset_meta[which][2] : sizes[i];
            if (lengths[i] != expected)
                return VDPL_E_BOUNDS;
            for (unsigned j = 0; j < i; ++j)
                if (starts[i] <= starts[j] ? starts[j] - starts[i] < lengths[i]
                                           : starts[i] - starts[j] < lengths[j])
                    return VDPL_E_ARGUMENT;
        }
    } else if (!bound || !equal(args, config, 32))
        return VDPL_E_ARGUMENT;
    rc = acquire(h, u16(args + 14), VDPL_READ, &asset);
    if (rc)
        return rc;
    if (asset.bytes != asset_meta[which][2]) {
        rc = VDPL_E_BOUNDS;
        goto done;
    }
    if (r->entry_id == 0) {
        if (u32(asset.data) != 0x54343252u || u16(asset.data + 4) != 1 ||
            u16(asset.data + 6) != 10 || u32(asset.data + 8) != asset.bytes ||
            u32(asset.data + 12) != asset_meta[which][0] ||
            u16(asset.data + 16) != asset_meta[which][3] || u16(asset.data + 18) ||
            u32(asset.data + 20) != asset_meta[which][3] * 64 ||
            u32(asset.data + 24) != asset_meta[which][1] || u32(asset.data + 28) ||
            hash(asset.data + 32, asset.bytes - 32) != asset_meta[which][1]) {
            rc = VDPL_E_FORMAT;
            goto done;
        }
        // Validate directory arithmetic independently of the content checksum.
        static const uint8_t widths[10] = {12, 8, 2, 1, 1, 2, 1, 4, 2, 2};
        static const uint16_t counts[8] = {2408, 16803, 4000, 101, 1060, 129, 257, 289};
        unsigned previous_end = 192;
        for (unsigned i = 0; i < 10; ++i) {
            const uint8_t *record = asset.data + 32 + i * 16;
            unsigned count = i < 2 ? asset_meta[which][3] * (i ? 1 : 19) : counts[i - 2];
            unsigned offset = u32(record + 8), bytes = count * widths[i];
            if (u16(record) != i + 1 || u16(record + 2) != widths[i] || u32(record + 4) != count ||
                u32(record + 12) != bytes || offset % 4 || offset < previous_end ||
                offset > asset.bytes || bytes > asset.bytes - offset) {
                rc = VDPL_E_FORMAT;
                goto done;
            }
            previous_end = offset + bytes;
        }
        copy(config, args, 32);
        bound = 1;
        goto done;
    }
    rc = acquire(h, u16(config + 16), VDPL_WRITE, &status);
    if (rc)
        goto done;
    if (status.bytes != 32) {
        rc = VDPL_E_BOUNDS;
        goto done;
    }
    for (unsigned i = 0; i < 32; ++i)
        status.data[i] = 0;
    w16(status.data + 2, VDPL_E_ARGUMENT);
    rc = acquire(h, u16(config + 12), VDPL_READ, &v);
    if (rc)
        goto done;
    if (v.bytes != 112) {
        rc = VDPL_E_BOUNDS;
        goto done;
    }
    copy(state, v.data, 112);
    release(h, &v);
    Assets a;
    a.lap = asset_meta[which][3] * 6400;
    a.count = asset_meta[which][3];
    a.bin_offset = which ? 0 : 360;
    for (int i = 0; i < 10; ++i)
        a.t[i] = asset.data + u32(asset.data + 40 + i * 16);
    if (!state_valid(&a)) {
        rc = VDPL_E_ARGUMENT;
        goto done;
    }
    int local = s32(state + 20) % 6400;
    frac14 = (local / 100) * 256 + (local % 100) * 256 / 100;
    a.f = frac14 / 4;
    a.ff = a.f * a.f / 4096;
    a.coeff = a.t[0] + (s32(state + 20) / 6400) * 228;
    for (unsigned i = 3; i < 6; ++i) {
        rc = acquire(h, u16(config + 12 + i * 2), VDPL_WRITE, &v);
        if (rc)
            goto done;
        if (v.bytes != sizes[i]) {
            rc = VDPL_E_BOUNDS;
            goto done;
        }
        Out out = {v.data, 0, v.bytes, 0};
        unsigned n = 0, ns = 0;
        if (i == 3)
            n = road(&out, &a);
        else if (i == 4)
            n = actors(&out, &a, &ns);
        else
            player(&out, &a);
        if (out.error) {
            rc = VDPL_E_BOUNDS;
            goto done;
        }
        w16(status.data + 12 + (i - 3) * 2, out.n);
        if (i == 3)
            w16(status.data + 18, n);
        if (i == 4) {
            w16(status.data + 20, n);
            w16(status.data + 22, ns);
        }
        release(h, &v);
    }
    last_seq = u32(state + 12);
    w32(status.data + 4, u32(config + 8));
    w32(status.data + 8, last_seq);
    w16(status.data + 2, 0);
    status.data[0] = 1;
done:
    if (rc && status.lease && status.bytes == 32) {
        status.data[0] = 0;
        w16(status.data + 2, rc);
    }
    release(h, &v);
    release(h, &status);
    release(h, &asset);
    return rc;
}
