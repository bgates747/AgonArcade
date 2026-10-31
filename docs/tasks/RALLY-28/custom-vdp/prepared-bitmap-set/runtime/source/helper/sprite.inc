/* Restricted 16.8 scale/mirror sampler. Fixed backing images, clipped plots.
   No per-pixel floating point/division and no per-frame bitmap allocation. */
#define R28_SPRITE_FIRST 50710u
#define R28_SPRITE_CAR_WIDTH 99
#define R28_SPRITE_CAR_HEIGHT 75
#define R28_SPRITE_SIGN_WIDTH 62
#define R28_SPRITE_SIGN_HEIGHT 62
typedef struct R28SpritePlan {
    int x,y,width,height,skip_x,skip_y,source_width,source_height,scale,mirror,stride;
} R28SpritePlan;
static int r28_sprite_plan(const Car *r,int sign,int cliptop,R28SpritePlan *p) {
    if(!r || !p || r->scale<14 || r->scale>250 || (r->scale&1))return 0;
    int sw=sign?64:102,sh=sign?64:77,mirror=r->xx<0;
    if(sign && mirror)return 0;
    int width=(mirror?101:sw)*r->scale/256,height=sh*r->scale/256;
    int left=r->x<0?0:r->x,top=r->y<cliptop?cliptop:r->y;
    int right=r->x+width,bottom=r->y+height;
    /* Preserve the stock transformed loop's exclusive final clip edge. */
    if(right>319)right=319;
    if(bottom>223)bottom=223;
    if(left>=right || top>=bottom)return 0;
    *p=(R28SpritePlan){left,top,right-left,bottom-top,left-r->x,top-r->y,
                      sw,sh,r->scale,mirror,sign?62:99};
    return 1;
}
static void r28_sprite_sample(uint8_t *dst,const uint8_t *src,const R28SpritePlan *p) {
    uint8_t map[R28_SPRITE_CAR_WIDTH];
    int step=256/p->scale,carry=256%p->scale;
    int start=p->skip_x*256,quot=start/p->scale,rem=start%p->scale;
    for(int x=0;x<p->width;++x){
        map[x]=(uint8_t)(p->mirror?101-quot-(rem!=0):quot);
        quot+=step;rem+=carry;
        if(rem>=p->scale){rem-=p->scale;++quot;}
    }
    start=p->skip_y*256;quot=start/p->scale;rem=start%p->scale;
    for(int y=0;y<p->height;++y){
        const uint8_t *row=src+quot*p->source_width;
        for(int x=0;x<p->width;++x)dst[x]=row[map[x]];
        dst+=p->stride;
        quot+=step;rem+=carry;
        if(rem>=p->scale){rem-=p->scale;++quot;}
    }
}
#ifndef R28_SPRITE_UNIT_ONLY
static unsigned r28_sprite_bytes(unsigned slot) { return slot<6?99u*75u:62u*62u; }
static void r28_sprite_emit(Out *o,const Car *r,int sign,int top,unsigned slot) {
    R28SpritePlan p;
    if(!r28_sprite_plan(r,sign,sign?104:top,&p))return;
    /* Sampling starts at the clipped source coordinate and scratch (0,0).
       Restrict the plot to initialized pixels; stale backing pixels never draw. */
    byte(o,24);word(o,p.x);word(o,p.y+p.height-1);word(o,p.x+p.width-1);word(o,p.y);
    /* VDU24 stores the viewport; PLOT move activates its canvas clipping. */
    plot(o,4,p.x,p.y);
    affine(o,65535);
    byte(o,23);byte(o,27);byte(o,32);word(o,R28_SPRITE_FIRST+slot);
    byte(o,23);byte(o,27);byte(o,3);word(o,p.x);word(o,p.y);
    viewport(o,top);
}
#endif
