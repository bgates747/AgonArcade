// Headless stock affine bitmap comparison; host clears are diagnostic only.
#define main admission_main
#include "transport.inc"
#undef main
namespace {
void marker(const char *name,int value){FILE*f=fopen(name,"w");if(f){fprintf(f,"%d\n",value);fclose(f);}}
bool right(){return vdp_getKeyMap(15)&2;}
bool escape(){return vdp_getKeyMap(14)&1;}
int visual(){
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_cursor_enable(false);
    for(unsigned bitmap=0;bitmap<2;++bitmap){
        uint8_t pixels[64];
        for(unsigned y=0;y<8;++y)for(unsigned x=0;x<8;++x)
            pixels[y*8+x]=((x+2*y)%5==0)?0:uint8_t(192+((3*x+5*y+bitmap*19)%64));
        vdp_adv_clear_buffer(64000+bitmap);
        vdp_adv_write_block_data(64000+bitmap,64,(char*)pixels);
        vdp_select_bitmap(bitmap);vdp_adv_bitmap_from_buffer(8,8,1);
    }
#ifdef BITMAP_ORACLE
    const uint8_t feature[]={23,0,248,1,0,1,0};send(feature,sizeof(feature));
#else
    if(!upload())return 2;
#endif
    if(!poll(0xa5))return 3;
    FILE*input=fopen("poses.dat","rb");if(!input)return 4;
    uint8_t header[2];if(fread(header,1,2,input)!=2)return 5;
    unsigned count=header[0]+256u*header[1];if(!count || count>40)return 6;
    for(unsigned i=0;i<count;++i){
        uint8_t state[10];if(fread(state,1,10,input)!=10)return 7;
        for(unsigned frame=0;frame<2;++frame){
            vdp_gcol(0,8);vdp_filled_rectangle(0,0,319,239);
#ifdef BITMAP_ORACLE
            unsigned bitmap=state[0]+256u*state[1],scale=state[6]+256u*state[7],mirror=state[8]+256u*state[9];
            int x=int16_t(state[2]+256u*state[3]),y=int16_t(state[4]+256u*state[5]);
            uint8_t matrix[]={23,0,160,76,4,32,0,23,0,160,76,4,32,11,200,0,0,0,0,0,0,0,0,0,0,0,0};
            word(matrix+15,mirror?-int(scale):int(scale));word(matrix+19,mirror?7*scale:0);word(matrix+23,scale);
            send(matrix,sizeof(matrix));vdp_select_bitmap(bitmap);vdp_adv_use_affine_matrix(1,1100);vdp_draw_bitmap(x,y);
            vdp_adv_use_affine_matrix(1,65535);vdp_select_bitmap(1);vdp_draw_bitmap(180,100);
#else
            uint8_t update[]={23,0,160,232,3,5,194,0,0,10,0};send(update,sizeof(update));send(state,sizeof(state));call(2000);
#endif
            vdp_swap();if(!poll(0xa5))return 8;
        }
        if(i==0)marker("ready.viz",0);
        while(right())if(escape())return 9;
        while(!right())if(escape()){
            if(i+1!=count)return 10;fclose(input);return 0;
        }
        if(i+1==count)return 11;
    }
    return 12;
}
}
int main(){int result=visual();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);marker("exit.viz",result);return result;}
