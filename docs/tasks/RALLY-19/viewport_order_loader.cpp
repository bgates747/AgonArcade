// Isolate VDU24 wire order in pixel coordinates; no Golem candidate involved.
#define main admission_main
#include "transport.inc"
#undef main
namespace {
void marker(const char*name,int value){FILE*f=fopen(name,"w");if(f){fprintf(f,"%d\n",value);fclose(f);}}
bool right(){return vdp_getKeyMap(15)&2;}
bool escape(){return vdp_getKeyMap(14)&1;}
int visual(){
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_cursor_enable(false);
    for(unsigned i=0;i<6;++i){
        for(unsigned frame=0;frame<2;++frame){
            const uint8_t reset=26;send(&reset,1);
            vdp_gcol(0,8);vdp_filled_rectangle(0,0,319,239);
            unsigned left=20,rightEdge=i>=4?20:39;
            if(i%2==0)vdp_set_graphics_viewport(left,30,rightEdge,49);
            else vdp_set_graphics_viewport(left,49,rightEdge,30);
            if(i==2 || i==3)vdp_set_graphics_viewport(0,0,319,239);
            vdp_gcol(0,9);vdp_filled_rectangle(0,0,319,239);
            vdp_swap();if(!poll(0xa5))return 2;
        }
        if(i==0)marker("ready.viz",0);
        while(right())if(escape())return 3;
        while(!right())if(escape())return i==5?0:4;
    }
    return 5;
}
}
int main(){int result=visual();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);marker("exit.viz",result);return result;}
