#include <agon/mos.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include "generated.hpp"
namespace {
volatile uint8_t *sys;
struct Pixel {unsigned view,x,y,expected,actual,r,g,b;};Pixel pixels[96];unsigned count=0,completed=0;const char*failure="none";
unsigned road_writes=0;unsigned long wire=0;uint8_t token=1;
void send(const uint8_t*p,unsigned n){mos_puts(reinterpret_cast<const char*>(p),n,0);wire+=n;}
void word(unsigned at,unsigned value){RoadCommand[ParameterOffset+at]=value;RoadCommand[ParameterOffset+at+1]=value>>8;}
bool fence(){uint8_t b[]={23,0,202,23,0,128,++token};send(b,sizeof b);uint32_t start=getsysvar_time();while(sys[sysvar_gp]!=token)if(uint32_t(getsysvar_time()-start)>600)return false;return true;}
bool painted(int y,unsigned phase){return y>=116 && ((800000L/(y-96)+phase)%8000)<4000;}
bool draw(int centre,unsigned phase){
 const uint8_t clear[]={18,0,2,25,4,0,0,104,0,25,101,63,1,223,0};send(clear,sizeof clear);
 for(unsigned i=0;i<120;++i){word(i*6,55100+unsigned(painted(i+104,phase)));word(i*6+2,centre);}
 ++road_writes;send(RoadCommand,sizeof RoadCommand);return fence();
}
bool point(unsigned view,unsigned x,unsigned y,unsigned expected){
 sys[sysvar_vdp_pflags]&=uint8_t(~vdp_pflag_point);uint8_t b[]={23,0,132,uint8_t(x),uint8_t(x>>8),uint8_t(y),uint8_t(y>>8)};send(b,sizeof b);
 if(!fence() || !(sys[sysvar_vdp_pflags]&vdp_pflag_point))return false;
 Pixel &p=pixels[count++];p={view,x,y,expected,sys[sysvar_scrpixelIndex],sys[sysvar_scrpixel],sys[sysvar_scrpixel+1],sys[sysvar_scrpixel+2]};
 return p.actual==expected;
}
bool write(uint8_t f,const char*s){return mos_fwrite(f,const_cast<char*>(s),strlen(s))==strlen(s);}
void label(unsigned view,int centre,unsigned phase){const uint8_t pos[]={31,0,0};send(pos,sizeof pos);printf("R28 BITMAP ROAD / VIEW %u OF 6       \r\nCentre %d  stripe phase %u          \r\n35x1 source; resident plots         \r\nNormal widths/stripes, thin lines   \r\nquantized. No game physics.         \r\n",view+1,centre,phase);}
}
int main(){
 sys=mos_sysvars();const uint8_t init[]={22,8,23,0,192,0,23,1,0,23,0,248,1,0,1,0,12,18,0,4,25,4,0,0,80,0,25,101,63,1,103,0};send(init,sizeof init);send(Setup,sizeof Setup);
 if(!fence())failure="setup timeout";
 for(unsigned view=0;view<6 && !strcmp(failure,"none");++view){
  int centre=view%3==0?160:view%3==1?40:280;unsigned phase=view<3?0:4000;
  label(view,centre,phase);if(!draw(centre,phase)){failure="draw timeout";break;}
  const unsigned ys[]={104,115,116,140,160,180,200,223};
  for(unsigned y:ys)if(!point(view,centre,y,painted(y,phase)?11:8)){failure="pixel mismatch";break;}
  // Check width and background on both sides wherever the edge is on screen.
  for(int side=-1;side<=1;side+=2){
   int outside=centre+side*105,inside=centre+side*96;
   if(outside>=0 && outside<320 && !point(view,unsigned(outside),140,2))failure="outer edge mismatch";
   if(inside>=0 && inside<320 && !point(view,unsigned(inside),140,painted(140,phase)?9:15))failure="kerb mismatch";
  }
  if(strcmp(failure,"none"))break;
  ++completed;uint32_t start=getsysvar_time();while(uint32_t(getsysvar_time()-start)<240){}
 }
 uint8_t f=mos_fopen("summary.txt",FA_WRITE|FA_CREATE_NEW);if(!f)return 2;
 char line[256];snprintf(line,sizeof line,"views=%u\r\npixel_checks=%u\r\nsource_width=35\r\nparameter_bytes=720\r\nroad_update_call_bytes=737\r\nroad_writes=%u\r\napplication_bytes_before_save=%lu\r\nfailure=%s\r\n",completed,count,road_writes,wire,failure);write(f,line);mos_fclose(f);
 f=mos_fopen("pixels.csv",FA_WRITE|FA_CREATE_NEW);if(!f)return 3;write(f,"view,x,y,expected,actual,r,g,b\r\n");
 for(unsigned i=0;i<count;++i){auto&p=pixels[i];snprintf(line,sizeof line,"%u,%u,%u,%u,%u,%u,%u,%u\r\n",p.view,p.x,p.y,p.expected,p.actual,p.r,p.g,p.b);write(f,line);}mos_fclose(f);
 f=mos_fopen("command.bin",FA_WRITE|FA_CREATE_NEW);if(!f)return 5;bool saved=mos_fwrite(f,reinterpret_cast<char*>(RoadCommand),sizeof RoadCommand)==sizeof RoadCommand;mos_fclose(f);if(!saved)return 6;
 f=mos_fopen("done.txt",FA_WRITE|FA_CREATE_NEW);if(!f)return 4;write(f,"done\n");mos_fclose(f);
 if(strcmp(failure,"none")){printf("FAIL: %s\r\n",failure);return 1;}
 label(0,160,0);draw(160,0);printf("\r\nPassed. SPACE: next view; Q: quit.\r\n");unsigned view=0;
 for(;;){uint8_t key=getchar();if(key=='q'||key=='Q'||key==27)break;if(key==' '){view=(view+1)%6;int centre=view%3==0?160:view%3==1?40:280;unsigned phase=view<3?0:4000;label(view,centre,phase);draw(centre,phase);}}
 const uint8_t end[]={23,0,150,1,255,255,23,1,1,22,0};send(end,sizeof end);return 0;
}
