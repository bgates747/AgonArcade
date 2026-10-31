/* Host-only linkage of the actual accepted sampler, not a reimplementation. */
#include "checked.c"
int host_sample_image(const uint8_t *source,uint8_t *destination,int id,int mirror,int q,int *shape){
    Car car={id,63970,2*q,mirror?-2*q:2*q,mirror?202*q:0,0,0};R28SpritePlan p;
    if(!r28_sprite_plan(&car,id>=120,0,&p))return 0;
    r28_sprite_sample(destination,source,&p);
    shape[0]=p.width;shape[1]=p.height;shape[2]=p.stride;
    return 1;
}
