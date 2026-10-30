// Independent stock-command/page model exercising the actual maintained
// presentation functions used by the real eZ80 guest.
#include "rules.hpp"
#include "crash.hpp"
#include "records.hpp"
#include "hud.hpp"
#include "engine.hpp"
#include "scenery.hpp"
#include "scene.hpp"
#include "font_data.hpp"
#include <algorithm>
#include <array>
#include <cassert>
#include <cstdio>
#include <cstring>
#include <vector>
namespace fs {unsigned scrollCalls=0,repaintCalls=0,skyRepairCalls=0;}
namespace {
using namespace rally::game;
rally::Motion motion;rally::SceneryHistory sceneryHistory;
rally::r18::SceneState scene{};rally::Stream stream;Rules rules;Crash crash;
Hud hud;Engine engine;Records records;
const rally::TrackDef *selected=&rally::Fuji;
unsigned steeringStep=2;uint32_t topScore=0;
constexpr unsigned Font=63940,LargeFont=63941;
std::array<uint8_t,320*240> pages[2];unsigned page=0;
struct Clip {int l=0,t=0,r=319,b=239;} pendingClip,clip;
int plotX=0,plotY=0,gcol=0,ink=15,paper=20,textX=0,textY=0,bitmap=100;
uint64_t wire=0,hudComparisons=0,skyComparisons=0;unsigned swaps=0,engineCommands=0;
int16_t get16(const uint8_t *p){return int16_t(uint16_t(p[0])|uint16_t(p[1])<<8);}
uint8_t panorama(int x,int y){x&=1023;unsigned at=unsigned(y)*1024+unsigned(x);uint8_t v=rally::SceneryPixels[at/2];return rally::SceneryPalette[(at&1)?(v&15):(v>>4)];}
void pixel(int x,int y,uint8_t v){if(x>=clip.l&&x<=clip.r&&y>=clip.t&&y<=clip.b&&x>=0&&x<320&&y>=0&&y<240)pages[page][y*320+x]=v;}
void glyph(int x,int y,unsigned ch,int fg,int bg){for(unsigned yy=0;yy<8;++yy)for(unsigned xx=0;xx<8;++xx){int px=x*8+int(xx),py=y*8+int(yy);if(px>=0&&px<320&&py>=0&&py<240)pages[page][py*320+px]=(FontPixels[ch*8+yy]&(128>>xx))?uint8_t(fg):uint8_t(bg);}}
void send(const uint8_t *p,unsigned n){wire+=n;for(unsigned i=0;i<n;){unsigned op=p[i++];if(op==24){assert(i+8<=n);pendingClip={get16(p+i),get16(p+i+6),get16(p+i+4),get16(p+i+2)};i+=8;}else if(op==25){assert(i+5<=n);unsigned mode=p[i++];int x=get16(p+i),y=get16(p+i+2);i+=4;clip=pendingClip;if(mode==4){plotX=x;plotY=y;}else{assert(mode==101);for(int yy=std::max(0,std::min(plotY,y));yy<=std::min(239,std::max(plotY,y));++yy)for(int xx=std::max(0,std::min(plotX,x));xx<=std::min(319,std::max(plotX,x));++xx)pixel(xx,yy,uint8_t(gcol));plotX=x;plotY=y;}}else if(op==18){assert(i+2<=n);assert(p[i++]==0);gcol=p[i++];}else if(op==17){assert(i<n);unsigned c=p[i++];if(c&128)paper=c-128;else ink=c;}else if(op==31){assert(i+2<=n);textX=p[i++];textY=p[i++];}else if(op==23){assert(i+4<=n);assert(p[i]==0&&p[i+1]==0x85);unsigned cmd=p[i+3],bytes=4+(cmd==3?2:(cmd==2||cmd==4?1:0));assert(i+bytes<=n);i+=bytes;++engineCommands;}else{assert(op>=32&&op<128);glyph(textX++,textY,op,ink,paper);}}}
void flush(){assert(!stream.overflow);send(stream.data,stream.size);stream.size=0;stream.overflow=false;}
bool panelVisible(){return false;}
void vdp_adv_use_affine_matrix(uint8_t,uint16_t){wire+=6;}
void vdp_select_bitmap(int id){bitmap=id;wire+=4;}
void vdp_draw_bitmap(int x,int y){wire+=7;if(bitmap==100){for(int yy=std::max(0,clip.t);yy<=std::min(239,clip.b);++yy)for(int xx=std::max(0,clip.l);xx<=std::min(319,clip.r);++xx)if(xx>=x&&xx<x+1024&&yy>=y&&yy<y+104)pixel(xx,yy,panorama(xx-x,yy-y));}}
void vdp_scroll_screen_extent(int extent,int direction,int speed){assert(extent==2&&(direction==0||direction==1));wire+=5;auto old=pages[page];for(int y=clip.t;y<=clip.b;++y)for(int x=clip.l;x<=clip.r;++x){int source=x+(direction==1?speed:-speed);pixel(x,y,source>=clip.l&&source<=clip.r?old[y*320+source]:0);}}
void vdp_set_text_colour(int c){ink=c;wire+=2;}
void vdp_set_text_bg_colour(int c){paper=c;wire+=2;}
void vdp_cursor_tab(int x,int y){textX=x;textY=y;wire+=3;}
void text(int x,int y,const char *s,int fg=15,int bg=SkyColour){vdp_set_text_colour(fg);vdp_set_text_bg_colour(bg);vdp_cursor_tab(x,y);send((const uint8_t*)s,unsigned(strlen(s)));}
#include "presentation-functions.inc"
void sky(){int32_t p=motion.position/100*256+(motion.position%100)*256/100;auto h=rally::trackSample(p,*motion.track);int offset=rally::sceneryHeading(h.tx,h.ty);auto u=sceneryHistory.prepare(offset);scene.skyOffset=offset;scene.skyDelta=u.delta;scene.skyLeft=u.left;scene.skyRight=u.right;scene.skyRepaint=u.repaint;drawScenery();for(int y=24;y<=103;++y)for(int x=0;x<320;++x){assert(pages[page][y*320+x]==panorama(x+offset,y));++skyComparisons;}}
void hudCheck(){const auto &img=hud.previous[page];char expected[50];snprintf(expected,sizeof expected,"TIME %03lu",(unsigned long)((rules.remaining+Hz-1)/Hz));assert(!memcmp(img.text+14,expected,8));snprintf(expected,sizeof expected,"SPEED %03ld",(long)motion.speed);assert(!memcmp(img.text+40+16,expected,9));assert(!memcmp(img.text,"TOP 0000000",11));for(unsigned ch=0;ch<120;++ch)for(unsigned y=0;y<8;++y)for(unsigned x=0;x<8;++x){uint8_t want=(FontPixels[uint8_t(img.text[ch])*8+y]&(128>>x))?img.colour[ch]:SkyColour;assert(pages[page][(ch/40*8+y)*320+ch%40*8+x]==want);++hudComparisons;}}
void paint(){sky();viewport(stream,0,HudHeight,319,239);stream.rect(0,224,319,239,0);flush();
// Simulated opaque road and moving traffic marks. Dirty sky pixels must be
// restored by the next use of this page, including a changed panorama bearing.
for(int y=104;y<224;++y)for(int x=0;x<320;++x)pages[page][y*320+x]=83;
for(int y=100;y<104;++y)for(int x=43;x<78;++x)pages[page][y*320+x]=246;
viewport(stream,0,0,319,239);flush();drawHud(4);bottom();hudCheck();page^=1;sceneryHistory.swapped();++swaps;}
}
int main(int argc,char **argv){assert(argc==2);FILE *f=fopen(argv[1],"rb");assert(f);std::array<uint8_t,21600> motionInput{};assert(fread(motionInput.data(),1,motionInput.size(),f)==motionInput.size());assert(fgetc(f)==EOF);fclose(f);
for(auto &p:pages)for(unsigned i=0;i<p.size();++i)p[i]=uint8_t(i*17+113);
rules.settings=FujiRules;rules.policy=Policy::Circuit;rules.lapLength=3276800;rules.maxGrip=200;rules.raceReady();rules.enter(Phase::Race);motion.track=selected;motion.position=3246800;motion.phase=6800;motion.grip=200;
paint();paint();engine.start(send);rally::game::RouteCursor pace;unsigned audioChanges=0,finishFrames=0;
for(unsigned frame=0;frame<900;++frame){for(unsigned step=0;step<4;++step){unsigned advance=pace.tick();motion.speed=advance/2;motion.position=(motion.position+advance)%3276800;motion.phase=(motion.phase+advance)%8000;rules.tick(advance);}unsigned ahead=0;for(unsigned c=0;c<6;++c){const uint8_t *p=motionInput.data()+frame*24+c*4;uint32_t station=uint32_t(p[0])|uint32_t(p[1])<<8|uint32_t(p[2])<<16|uint32_t(p[3])<<24;int32_t gap=int32_t(station)-motion.position;if(gap>1638400)gap-=3276800;else if(gap< -1638400)gap+=3276800;if(gap>0)++ahead;}rules.rank=uint8_t(1+ahead);unsigned old=engine.frequency;engine.update(motion.speed,send);if(old!=engine.frequency)++audioChanges;paint();int32_t z=(3276800-motion.position)%3276800/100;if(z>=64&&z<=1000)++finishFrames;}
unsigned mainScroll=fs::scrollCalls,mainRepaint=fs::repaintCalls-2,mainRepair=fs::skyRepairCalls;
// Exercise footer notice expiry on both pages; the black road-output strip
// must erase the old text even when the ordinary race footer is unchanged.
rules.extensionNotice=1;paint();paint();rules.extensionNotice=0;paint();paint();for(auto &p:pages)for(int y=224;y<232;++y)for(int x=23*8;x<39*8;++x)assert(p[y*320+x]==0);
RaceTraffic traffic;traffic.reset(Policy::Circuit,3276800,7,2);for(auto &c:traffic.cars)c.active=false;crash.begin(motion);scene.playerCentre=160;scene.playerX=109;scene.playerBitmap=0;scene.playerMirror=false;unsigned bursts=0,blink=0,recovered=0;
for(unsigned n=0;n<272;++n){if(crash.remaining)++bursts;else if(crash.invulnerable&&((crash.invulnerable/10)&1))++blink;drawPlayer();if(crash.tick(motion,traffic,0)&&!crash.remaining)++recovered;}
assert(bursts==150&&blink==60&&recovered==1);engine.stop(send);
printf("{\"schema\":1,\"passed\":true,\"main_frames\":900,\"warm_frames\":2,\"main_physics_ticks\":3600,\"sky_pixel_comparisons\":%llu,\"hud_pixel_comparisons\":%llu,\"scroll_calls\":%u,\"repaint_calls\":%u,\"repair_calls\":%u,\"main_scroll_calls\":%u,\"main_repaint_calls\":%u,\"main_repair_calls\":%u,\"audio_changes\":%u,\"finish_frames\":%u,\"rules_ticks\":%lu,\"rules_remaining\":%lu,\"score\":%lu,\"rank\":%u,\"player_station\":%ld,\"player_phase\":%ld,\"explosion_frames\":%u,\"blink_hidden_frames\":%u,\"recovery_transitions\":%u,\"footer_expiry_both_pages\":true}\n",(unsigned long long)skyComparisons,(unsigned long long)hudComparisons,fs::scrollCalls,fs::repaintCalls,fs::skyRepairCalls,mainScroll,mainRepaint,mainRepair,audioChanges,finishFrames,(unsigned long)rules.phaseTicks,(unsigned long)rules.remaining,(unsigned long)rules.score,unsigned(rules.rank),(long)motion.position,(long)motion.phase,bursts,blink,recovered);
}
