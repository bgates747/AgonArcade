/* Host-only exact coverage and guard oracle for the actual candidate include. */
#include <inttypes.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define R28_SPAN_WIDTH 320
#define r28_span_fill r28_span_fill_baseline
#include "baseline_fill.inc"
#undef r28_span_fill
#include "wide_fill.inc"

enum { GUARD = 32, STORAGE = GUARD + R28_SPAN_WIDTH + 3 + GUARD };
static uint64_t cases, compared_bytes, prefix_bytes, word_stores, tail_bytes;
static uint64_t empty_cases, reversed_cases, colours_seen[4];
static unsigned alignments_seen;

static void fail(const char *reason, unsigned alignment, int left, int right,
                 unsigned colour, unsigned index) {
    fprintf(stderr, "%s: alignment=%u left=%d right=%d colour=%u index=%u\n",
            reason, alignment, left, right, colour, index);
    exit(1);
}

static uint8_t initial_byte(unsigned index) {
    return (uint8_t)(index * 37u + 17u);
}

static void run_case(unsigned alignment, int left, int right, uint8_t colour) {
    uint8_t actual[STORAGE] __attribute__((aligned(16)));
    uint8_t baseline[STORAGE] __attribute__((aligned(16)));
    const unsigned start = GUARD + alignment;
    uint8_t *row = actual + start;
    if (((uintptr_t)row & 3u) != alignment)
        fail("wrong actual base alignment", alignment, left, right, colour, 0);
    for (unsigned i = 0; i < STORAGE; ++i)
        actual[i] = baseline[i] = initial_byte(i);
    r28_span_fill(row, left, right, colour);
    r28_span_fill_baseline(baseline + start, left, right, colour);
    /* Independent oracle: inspect every allocated byte by its row coordinate.
       It uses no fill/copy primitive and no prefix/word/tail decomposition. */
    for (unsigned i = 0; i < STORAGE; ++i) {
        const int x = (int)i - (int)start;
        const uint8_t expected = left <= x && x < right ? colour : initial_byte(i);
        if (actual[i] != expected)
            fail("candidate differs from independent oracle", alignment, left, right, colour, i);
        if (baseline[i] != expected)
            fail("preserved baseline differs from independent oracle", alignment, left, right, colour, i);
    }
    ++cases;
    compared_bytes += STORAGE;
    colours_seen[colour / 64u] |= UINT64_C(1) << (colour % 64u);
    alignments_seen |= 1u << alignment;
    if (left == right) ++empty_cases;
    if (left > right) ++reversed_cases;
    if (left < right) {
        unsigned count = (unsigned)(right - left);
        unsigned prefix = (4u - ((alignment + (unsigned)left) & 3u)) & 3u;
        if (prefix > count) prefix = count;
        prefix_bytes += prefix;
        count -= prefix;
        word_stores += count / 4u;
        tail_bytes += count % 4u;
    }
}

static int oracle_clip(int x) {
    if (x < 0) return 0;
    if (x > 320) return 320;
    return x;
}

int main(void) {
    static const uint8_t road_colours[] = {0xc8, 0xd5, 0xc3, 0xcf, 0xff};
    static const int starts[] = {0, 1, 2, 3, 4, 7, 15, 16, 31, 63,
                                 127, 255, 303, 312, 316, 317, 318, 319, 320};
    static const int lengths[] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11,
                                  12, 13, 14, 15, 16, 17, 31, 32, 33, 63, 64,
                                  65, 127, 128, 129, 255, 256, 257, 319, 320};
    static const int raw[] = {INT_MIN, -640, -321, -320, -17, -4, -3, -2, -1,
                              0, 1, 2, 3, 4, 7, 8, 15, 16, 17, 31, 32, 63,
                              64, 127, 128, 255, 256, 303, 304, 305, 315, 316,
                              317, 318, 319, 320, 321, 322, 323, 324, 337, 640, INT_MAX};
    static const int noops[][2] = {{0, 0}, {1, 1}, {320, 320}, {1, 0},
                                   {-1, -1}, {-1, -2}, {INT_MAX, INT_MIN}};
    for (unsigned alignment = 0; alignment < 4; ++alignment)
        for (unsigned c = 0; c < sizeof(road_colours); ++c)
            for (int left = 0; left <= R28_SPAN_WIDTH; ++left)
                for (int right = 0; right <= R28_SPAN_WIDTH; ++right)
                    run_case(alignment, left, right, road_colours[c]);
    const uint64_t endpoints = cases;

    for (unsigned alignment = 0; alignment < 4; ++alignment)
        for (unsigned colour = 0; colour <= UINT8_MAX; ++colour)
            for (unsigned a = 0; a < sizeof(starts) / sizeof(starts[0]); ++a)
                for (unsigned b = 0; b < sizeof(lengths) / sizeof(lengths[0]); ++b) {
                    const int left = starts[a];
                    int right = left + lengths[b];
                    if (right > R28_SPAN_WIDTH) right = R28_SPAN_WIDTH;
                    run_case(alignment, left, right, (uint8_t)colour);
                }
    const uint64_t colours = cases - endpoints;

    unsigned clipped_values = 0;
    for (unsigned a = 0; a < sizeof(raw) / sizeof(raw[0]); ++a) {
        if (r28_span_clip(raw[a]) != oracle_clip(raw[a]))
            fail("preserved clip differs from oracle", 0, raw[a], raw[a], 0, a);
        ++clipped_values;
    }
    for (unsigned alignment = 0; alignment < 4; ++alignment)
        for (unsigned c = 0; c < sizeof(road_colours); ++c)
            for (unsigned a = 0; a < sizeof(raw) / sizeof(raw[0]); ++a)
                for (unsigned b = 0; b < sizeof(raw) / sizeof(raw[0]); ++b)
                    run_case(alignment, r28_span_clip(raw[a]), r28_span_clip(raw[b]), road_colours[c]);
    const uint64_t clipping = cases - endpoints - colours;

    /* The existing empty/reversed primitive must not evaluate row+left. */
    for (unsigned i = 0; i < sizeof(noops) / sizeof(noops[0]); ++i) {
        r28_span_fill(NULL, noops[i][0], noops[i][1], 0xff);
        r28_span_fill_baseline(NULL, noops[i][0], noops[i][1], 0xff);
    }
    for (unsigned i = 0; i < 4; ++i)
        if (colours_seen[i] != UINT64_MAX)
            fail("missing colour coverage", 0, 0, 0, i, 0);
    if (alignments_seen != 15u || !prefix_bytes || !word_stores || !tail_bytes)
        fail("missing alignment or path coverage", 0, 0, 0, 0, 0);
    printf("{\"passed\":true,\"exhaustive_endpoint_cases\":%" PRIu64
           ",\"all_colour_boundary_cases\":%" PRIu64 ",\"clipped_endpoint_cases\":%" PRIu64
           ",\"clip_values\":%u,\"null_empty_reversed_cases\":%zu"
           ",\"total_guarded_cases\":%" PRIu64 ",\"bytes_compared_per_implementation\":%" PRIu64
           ",\"empty_guarded_cases\":%" PRIu64 ",\"reversed_guarded_cases\":%" PRIu64
           ",\"actual_base_alignments\":[0,1,2,3],\"colours\":256"
           ",\"expected_scalar_prefix_bytes\":%" PRIu64 ",\"expected_word_stores\":%" PRIu64
           ",\"expected_scalar_tail_bytes\":%" PRIu64
           ",\"row_boundaries_and_guards_unchanged\":true,\"baseline_and_independent_oracle_exact\":true}\n",
           endpoints, colours, clipping, clipped_values, sizeof(noops) / sizeof(noops[0]),
           cases, compared_bytes, empty_cases, reversed_cases, prefix_bytes, word_stores, tail_bytes);
    return 0;
}
