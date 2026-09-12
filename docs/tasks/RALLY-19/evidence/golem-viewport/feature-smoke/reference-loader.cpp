// Exact native comparison for typed viewport, clipping, scroll and restoration.
#define main admission_main
#include "transport.inc"
#undef main
namespace {
void marker(const char*name,int value){FILE*f=fopen(name,"w");if(f){fprintf(f,"%d\n",value);fclose(f);}}
bool right(){return vdp_getKeyMap(15)&2;}
bool escape(){return vdp_getKeyMap(14)&1;}
uint8_t pixels[128*128];
int visual(){
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_cursor_enable(false);
    for(unsigned y=0;y<128;++y)for(unsigned x=0;x<128;++x)
        pixels[y*128+x]=uint8_t(192+((x/3+5*(y/4))%64));
    vdp_adv_clear_buffer(64000);vdp_adv_write_block_data(64000,sizeof(pixels),(char*)pixels);
    vdp_select_bitmap(0);vdp_adv_bitmap_from_buffer(128,128,1);
    for(unsigned i=0;i<64;++i)pixels[i]=255;
    vdp_adv_clear_buffer(64001);vdp_adv_write_block_data(64001,64,(char*)pixels);
    vdp_select_bitmap(1);vdp_adv_bitmap_from_buffer(8,8,1);
#ifdef VIEWPORT_ORACLE
    const uint8_t feature[]={23,0,248,1,0,1,0};send(feature,sizeof(feature));
#else
    if(!upload())return 2;
#endif
    if(!poll(0xa5))return 3;
    FILE*input=fopen("poses.dat","rb");if(!input)return 4;
    uint8_t header[2];if(fread(header,1,2,input)!=2)return 5;
    unsigned count=header[0]+256u*header[1];if(!count||count>40)return 6;
    for(unsigned i=0;i<count;++i){
        uint8_t state[12];if(fread(state,1,12,input)!=12)return 7;
        for(unsigned frame=0;frame<2;++frame){
            const uint8_t reset=26;send(&reset,1);vdp_gcol(0,8);vdp_filled_rectangle(0,0,319,239);
#ifdef VIEWPORT_ORACLE
            unsigned v[6];for(unsigned j=0;j<6;++j)v[j]=state[2*j]+256u*state[2*j+1];
            vdp_set_graphics_viewport(v[0],v[3],v[2],v[1]);
            vdp_adv_use_affine_matrix(1,65535);vdp_select_bitmap(0);vdp_draw_bitmap(-10,-10);
            vdp_scroll_screen_extent(2,v[4],v[5]);
            vdp_set_graphics_viewport(0,239,319,0);
            vdp_select_bitmap(1);vdp_draw_bitmap(180,180);vdp_adv_use_affine_matrix(1,65535);
#else
            uint8_t update[]={23,0,160,232,3,5,194,0,0,12,0};send(update,sizeof(update));send(state,sizeof(state));call(2000);
#endif
            vdp_swap();if(!poll(0xa5))return 8;
        }
        if(i==0)marker("ready.viz",0);
        while(right())if(escape())return 9;
        while(!right())if(escape()){fclose(input);return i+1==count?0:10;}
    }
    return 11;
}
}
int main(){int result=visual();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);marker("exit.viz",result);return result;}
