/* Timestamp existing UART trace events without changing game or wire bytes. */
#define _POSIX_C_SOURCE 200809L
#include "input.c"
#include <fcntl.h>
#include <pthread.h>
#include <stdatomic.h>
#include <stdint.h>
#include <time.h>
#include <unistd.h>

static _Atomic(FILE *) outgoing, incoming;
static pthread_once_t trace_once = PTHREAD_ONCE_INIT;
static int trace_fd = -1;

static void trace_open_once(void) {
    const char *name = getenv("WOLF_TIMED_TRACE");
    if (!name) abort();
    trace_fd = open(name, O_WRONLY | O_CREAT | O_EXCL | O_APPEND, 0600);
    if (trace_fd < 0) abort();
}

static void stamp(char kind, unsigned seq, int32_t x, int32_t y, unsigned angle) {
    pthread_once(&trace_once, trace_open_once);
    struct timespec now;
    clock_gettime(CLOCK_MONOTONIC, &now);
    char line[160];
    int n = snprintf(line, sizeof line, "%llu,%c,%u,%d,%d,%u\n",
        (unsigned long long)now.tv_sec * 1000000000ull + now.tv_nsec,
        kind, seq, x, y, angle);
    if (n <= 0 || n >= (int)sizeof line || write(trace_fd, line, n) != n) abort();
}

FILE *fopen(const char *name, const char *mode) {
    static FILE *(*real_open)(const char *, const char *);
    if (!real_open) *(void **)(&real_open) = dlsym(RTLD_NEXT, "fopen");
    FILE *stream = real_open(name, mode);
    size_t n = strlen(name);
    const char tx[] = "/mos-to-vdp.bin", rx[] = "/vdp-to-mos-delivered.bin";
    if (n >= sizeof tx - 1 && !strcmp(name + n - sizeof tx + 1, tx))
        atomic_store(&outgoing, stream);
    if (n >= sizeof rx - 1 && !strcmp(name + n - sizeof rx + 1, rx))
        atomic_store(&incoming, stream);
    return stream;
}

int fputc(int value, FILE *stream) {
    static int (*real_put)(int, FILE *);
    if (!real_put) *(void **)(&real_put) = dlsym(RTLD_NEXT, "fputc");
    int result = real_put(value, stream);
    if (stream == atomic_load(&outgoing)) {
        static unsigned char w[17];
        static unsigned count;
        static int32_t x, y;
        static unsigned angle;
        const unsigned char pose[] = {23,0,0xa0,1,0,0x4a,2};
        const unsigned char render[] = {23,0,0xa0,1,0,0x4a,7};
        memmove(w, w + 1, 16); w[16] = (unsigned char)value;
        if (count < 17) count++;
        if (count == 17 && !memcmp(w, pose, sizeof pose)) {
            uint32_t ux = (uint32_t)w[7] | (uint32_t)w[8]<<8 | (uint32_t)w[9]<<16 | (uint32_t)w[10]<<24;
            uint32_t uy = (uint32_t)w[11] | (uint32_t)w[12]<<8 | (uint32_t)w[13]<<16 | (uint32_t)w[14]<<24;
            x = (int32_t)ux; y = (int32_t)uy; angle = w[15] | (unsigned)w[16]<<8;
            stamp('P', 0, x, y, angle);
        }
        if (count >= 7 && !memcmp(w + 10, render, sizeof render)) stamp('R', 0, x, y, angle);
        if (count >= 3 && w[14] == 23 && w[15] == 0 && w[16] == 0xc3) stamp('C', 0, 0, 0, 0);
    } else if (stream == atomic_load(&incoming)) {
        static unsigned char w[12];
        static unsigned count;
        const unsigned char done[] = {0x81,10,'W','3','D','R',1,1,0x3d,0x57};
        const unsigned char fizzle[] = {0x81,10,'W','3','D','R',1,2};
        memmove(w, w + 1, 11); w[11] = (unsigned char)value;
        if (count < 12) count++;
        if (count == 12 && !memcmp(w, done, sizeof done))
            stamp('D', w[10] | (unsigned)w[11]<<8, 0, 0, 0);
        if (count == 12 && !memcmp(w, fizzle, sizeof fizzle))
            stamp('F', w[10] | (unsigned)w[11]<<8, 0, 0, 0);
    }
    return result;
}
