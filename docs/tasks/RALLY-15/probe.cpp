// Task-local native qualification: resident program versus direct PLOT reference.
#include "section_protocol.hpp"
#include "pacing.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
namespace {
rally::Stream stream;
struct Case {int top,bottom,y,yy;bool paint;};
constexpr Case Cases[]={
    {160,160,104,105,false}, {160,160,105,107,true},
    {160,160,107,108,false}, {160,160,108,111,true},
    {160,160,111,112,false}, {160,160,112,116,true},
    {160,184,116,132,true},
    {184,145,132,152,false}, {145,280,152,176,true},
    {280,20,176,192,false}, {20,-30,192,208,true},
    {-30,180,208,224,false}
};
int x(int centre,int y,int u) {return (centre*50+u*(y-96))/50;}
void strip(const Case &c,int left,int right,int colour) {
    stream.quad(x(c.top,c.y,left),x(c.top,c.y,right),c.y,
                x(c.bottom,c.yy,left),x(c.bottom,c.yy,right),c.yy,colour);
}
uint32_t ticks() {uint32_t a,b;do {a=sys_vars->time;b=sys_vars->time;}while(a!=b);return b;}
struct Backend {
    uint32_t ticks() {return ::ticks();}
    uint8_t poll() {return reinterpret_cast<volatile uint8_t *>(sys_vars)[0x37];}
    void send(uint8_t token) {uint8_t v[]={23,0,128,token};mos_puts((char *)v,sizeof(v),0);}
} backend;
}
int main(int argc,char **argv) {
    bool direct=false;
    for(int i=1;i<argc;++i) if(strcmp(argv[i],"direct")==0) direct=true;
    if(vdp_mode(136)<0) return 1;
    vdp_set_pixel_coordinates();vdp_reset_sprites();vdp_cursor_enable(false);
    mos_puts((char *)rally::section::Startup,rally::section::StartupSize,0);
    stream.rect(0,0,319,103,4);stream.rect(0,104,319,223,2);
    for(const auto &c:Cases) {
        if(!direct) rally::section::draw(stream,c.top,c.bottom,c.y,c.yy,c.paint);
        else {
            strip(c,-106,106,c.paint?9:15);strip(c,-90,90,8);
            strip(c,-86,-84,c.paint?11:15);strip(c,84,86,c.paint?11:15);
            if(c.paint)strip(c,-2,2,11);
        }
    }
    stream.rect(0,224,319,239,0);
    if(stream.overflow)return 2;
    mos_puts((char *)stream.data,stream.size,0);vdp_swap();
    rally::PollFence fence;
    bool acknowledged=fence.wait(backend,rally::FenceTimeout);
    FILE *file=fopen("probe.txt","w");
    if(file) {fprintf(file,"direct=%u acknowledged=%u bytes=%u\n",unsigned(direct),unsigned(acknowledged),stream.size);fclose(file);}
    if(!acknowledged) return 3;
    for(;;) {if(vdp_getKeyMap(14)&1)break;}
    vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    return 0;
}
