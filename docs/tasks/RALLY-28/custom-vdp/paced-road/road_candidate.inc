/* RALLY-28 experimental road emission. Physics, actors and ABI stay unchanged.
   R28_INTEGER, R28_QUAD and R28_STRIPS are independent build constants. */
static int road_edge(int centre, int y, int u) {
    /* Exact rational endpoint, truncated toward zero only after translation.
       Bounds are established from the frozen asset in BOUNDS.json. */
    return (centre * 50 + (y - 96) * u) / 50;
}

static void road_shape(Out *o, int tl, int tr, int bl, int br,
                       int yt, int yb, int colour_index) {
    colour(o, colour_index);
    plot(o, 4, tl, yt);
    plot(o, 4, tr, yt);
#if R28_QUAD
    /* Perimeter order. Next GCOL or buffered RETURN closes this resident path. */
    plot(o, 221, br, yb);
    plot(o, 221, bl, yb);
#else
    plot(o, 85, bl, yb);
    plot(o, 85, br, yb);
#endif
}

static void section(Out *o, int ct, int cb, int yt, int yb, int marked) {
    static const int boundaries[10] = {-106,-90,-86,-84,-2,2,84,86,90,106};
    int top[10], bottom[10];
#if !R28_INTEGER
    float a = (float)yt * (1.0f / 50.0f) + (-96.0f / 50.0f);
    float b = (float)(cb - ct);
    float c = (float)yt * (-1.0f / 50.0f) + (float)yb * (1.0f / 50.0f);
#endif
    for (int i = 0; i < 10; ++i) {
        int u = boundaries[i];
#if R28_INTEGER
        top[i] = road_edge(ct, yt, u);
        bottom[i] = road_edge(cb, yb, u);
#else
        /* Original binary32 expression/order, shared by all material users. */
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
#endif
    }
    int kerb = marked ? 9 : 15, line = marked ? 11 : 15;
#if R28_STRIPS
    /* Partition the final image into disjoint material intervals. */
    for (int i = 0; i < 9; ++i) {
        int next = i + 1;
        int col = i == 0 || i == 8 ? kerb : i == 2 || i == 6 ? line : 8;
        if (i == 4) col = marked ? line : 8;
        if (!marked && i == 3) {next = 6; i = 5;}
        int left = next == 6 && !marked ? 3 : i;
        road_shape(o, top[left], top[next], bottom[left], bottom[next], yt, yb, col);
    }
#else
    static const unsigned left[5] = {0,1,2,6,4}, right[5] = {9,8,3,7,5};
    for (int i = 0; i < (marked ? 5 : 4); ++i)
        road_shape(o, top[left[i]], top[right[i]], bottom[left[i]], bottom[right[i]],
                   yt, yb, i == 0 ? kerb : i == 1 ? 8 : line);
#endif
}
