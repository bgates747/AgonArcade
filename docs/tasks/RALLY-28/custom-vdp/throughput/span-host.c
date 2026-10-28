/* Test-only exports. Target module still builds unchanged generated native.c. */
#include "native.c"
#ifdef R28_SPAN_TEST
int span_test_colour(int logical) { return r28_span_colour(logical); }
int span_test_edge(int top, int bottom, int height, int *out, unsigned capacity) {
    if (!out || height < 1 || height > 120 || capacity < (unsigned)height ||
        top < -32768 || top > 32767 || bottom < -32768 || bottom > 32767) return 0;
    R28SpanEdge edge=r28_span_edge(top,bottom,height);
    for(int i=0;i<height;++i)out[i]=r28_span_step(&edge);
    return 1;
}
int span_test_section(uint8_t *pixels,unsigned bytes,int ct,int cb,int yt,int yb,int marked) {
    if(bytes!=R28_SPAN_BYTES || ct < -3183 || ct > 3183 || cb < -3183 || cb > 3183 ||
       marked < 0 || marked > 1)return 0;
    return r28_span_section(pixels,ct,cb,yt,yb,marked);
}
#else
unsigned span_control_section(uint8_t *out,unsigned capacity,int ct,int cb,int yt,int yb,int marked) {
    Out o={out,0,capacity,0};section(&o,ct,cb,yt,yb,marked);end(&o);
    return o.error?0:o.n;
}
#endif
