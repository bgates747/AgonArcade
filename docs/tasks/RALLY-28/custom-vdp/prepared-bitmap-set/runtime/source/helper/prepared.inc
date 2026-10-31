/* Private full-set lookup. Only an entry-scoped Assets pointer is borrowed. */
#define R28_SPRITE_FIRST 50710u
static unsigned r28_sprite_bytes(unsigned slot){return slot<6?7425u:3844u;}
#include "prepared_pins.inc"
static uint32_t r28_prepared_session;
static uint32_t r28_prepared_counts[8];
static void r28_sprite_emit(Out *o,const Assets *a,const Car *r,int sign,int top,unsigned slot){
    (void)slot;
    ++r28_prepared_counts[0];
    int mirror=r->xx<0,source=r->bitmap,s=r->scale;
    const uint8_t *p=a->prepared;
    if(!p || s<14 || s>250 || (s&1) || r->xx!=(mirror?-s:s) ||
       r->translation!=(mirror?101*s:0) ||
       (sign?(source<120 || source>127 || mirror):(source<5 || source>34))){
        ++r28_prepared_counts[3];o->error=1;return;
    }
    unsigned dir=sign?60u+(unsigned)(source-120):2u*(unsigned)(source-5)+(unsigned)mirror;
    const uint8_t *d=p+64+16*dir;
    unsigned q=(unsigned)s/2,first=u16(d+4),n=u16(d+6),map=u32(d+8);
    if(u16(d)!=(unsigned)source || (d[3]&1)!=(unsigned)mirror || map<1152 || map>3420-126){
        ++r28_prepared_counts[3];o->error=1;return;
    }
    unsigned index=p[map+q];
    if(index==255 || index>=n || first+index>=901){++r28_prepared_counts[3];o->error=1;return;}
    const uint8_t *record=p+3420+8*(first+index);
    unsigned bitmap=u16(record),width=record[2],height=record[3];
    if(bitmap!=52000+first+index || !width || width>99 || !height || height>75){
        ++r28_prepared_counts[3];o->error=1;return;
    }
    int x=r->x+(sign?32:51)*s/256-s16(record+4);
    int y=r->y+(sign?64:70)*s/256-s16(record+6);
    int cliptop=sign?104:top,left=x<0?0:x,t=y<cliptop?cliptop:y;
    int right=x+(int)width,bottom=y+(int)height;
    if(right>319)right=319;if(bottom>223)bottom=223;
    if(left>=right || t>=bottom){++r28_prepared_counts[2];return;}
    byte(o,24);word(o,left);word(o,bottom-1);word(o,right-1);word(o,t);
    plot(o,4,left,t);affine(o,65535);
    byte(o,23);byte(o,27);byte(o,32);word(o,bitmap);
    byte(o,23);byte(o,27);byte(o,3);word(o,x);word(o,y);
    viewport(o,top);++r28_prepared_counts[1];
}
