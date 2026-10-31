/* Rally-owned experiment. Stock commands; no retained service pointers/heap. */
typedef struct { int valid,id,xx,scale,translation; } R28Matrix;
typedef struct { int valid,bitmap,xx,scale,translation,bytes; } R28Image;
static R28Matrix r28_matrices[7];
static R28Image r28_images[8];
/* draws, matrix hits/misses, bitmap hits/misses, generated pixels, peak pixels */
static unsigned r28_counts[7];
static void r28_cache_reset(void) {
    memset(r28_matrices,0,sizeof r28_matrices);
    memset(r28_images,0,sizeof r28_images);
    memset(r28_counts,0,sizeof r28_counts);
}
static void r28_matrix(Out *o,const Car *r,unsigned slot) {
    R28Matrix *m=&r28_matrices[slot];
    if(m->valid && m->id==r->matrix && m->xx==r->xx &&
       m->scale==r->scale && m->translation==r->translation) {
        ++r28_counts[1];return;
    }
    ++r28_counts[2];
    matrix(o,r->matrix,r->xx,r->scale,r->translation);
    m->valid=1;m->id=r->matrix;m->xx=r->xx;
    m->scale=r->scale;m->translation=r->translation;
}
static void r28_actor(Out *o,const Assets *a,const Car *r,int sign,unsigned signslot) {
    unsigned identity=sign?6u:(unsigned)(r->matrix-a->resources->traffic_matrix_base);
    if(identity>6 || signslot>1) {o->error=1;return;}
    ++r28_counts[0];
#if R28_PREPARED
    unsigned slot=sign?6u+signslot:identity;
    R28Image *image=&r28_images[slot];
    if(!image->valid || image->bitmap!=r->bitmap || image->xx!=r->xx ||
       image->scale!=r->scale || image->translation!=r->translation) {
        ++r28_counts[4];
        r28_matrix(o,r,identity);
        command(o,50710u+slot,40);byte(o,5);
        word(o,r->matrix);word(o,64000+r->bitmap);
        /* Same truncation and transformed corner bounds as stock command40. */
        int width=sign?64:102,height=sign?64:77;
        int x0=r->translation/256,x1=(r->translation+r->xx*width)/256;
        int bytes=((x0>x1?x0-x1:x1-x0)+1)*(height*r->scale/256+1);
        image->valid=1;image->bitmap=r->bitmap;image->xx=r->xx;
        image->scale=r->scale;image->translation=r->translation;image->bytes=bytes;
        r28_counts[5]+=(unsigned)bytes;
        unsigned resident=0;
        for(unsigned i=0;i<8;++i)if(r28_images[i].valid)resident+=(unsigned)r28_images[i].bytes;
        if(resident>r28_counts[6])r28_counts[6]=resident;
    } else ++r28_counts[3];
    /* Stock auto-translation removes minX; restore it in the plot anchor. */
    int x0=r->translation/256,x1=(r->translation+r->xx*(sign?64:102))/256;
    affine(o,65535);
    byte(o,23);byte(o,27);byte(o,32);word(o,50710u+slot);
    byte(o,23);byte(o,27);byte(o,3);
    word(o,r->x+(x0<x1?x0:x1));word(o,r->y);
#else
    r28_matrix(o,r,identity);
    bitmap(o,r->bitmap,r->matrix,r->x,r->y);
#endif
}
