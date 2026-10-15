#include <cassert>
#include <map>
#include <vector>
#include <string>
#include <cstdio>
#include "workload.hpp"
#include "scene_workload.hpp"
static_assert(sizeof(VDU_A_B_CMD_x_y)==7 && sizeof(VDU_ADV_CMD_W)==8,"wire packing");
std::map<std::string,std::vector<uint8_t>> capture;
std::string part="excluded";
SYSVAR hostVars{};volatile SYSVAR *sys_vars=&hostVars;
extern "C" void mos_puts(const char *p,uint24_t n,char) {
    if(!n)n=strlen(p);
    if(n)capture[part].insert(capture[part].end(),p,p+n);
}
extern "C" int putch(int c) {const char b=c;mos_puts(&b,1,0);return c;}
extern "C" uint8_t *mos_getkbmap() {return heldKeys;}
int main(int argc,char **argv) {
    assert(argc==2);
    if(std::string(argv[1])=="physics") {
        for(unsigned s=0;s<4;++s){capacity::setup(s);for(unsigned i=0;i<1024;++i)capacity::step(i);
            capacity::snapshot(s,[](unsigned s,unsigned k,uint32_t v){printf("%u,%u,%u\n",s,k,v);});}
        assert(capture.empty());return 0;
    }
    assert(std::string(argv[1])=="wire");part="setup";capacity::setupScene();
    FILE *setup=fopen("setup.bin","wb");assert(setup);
    const auto &bytes=capture["setup"];assert(fwrite(bytes.data(),1,bytes.size(),setup)==bytes.size());fclose(setup);
    capture.clear();
    printf("frame,road,traffic_signs,player,scenery,hud,panel,bottom,viewport,swap,audio,bands,cars,signs,scroll,repaint\n");
    for(unsigned frame=0;frame<900;++frame) {
        capacity::advanceScene();rally::game::prepareGameScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);billboards.prepare(motion,road);capacity::drawScene([](const char *name){part=name;});
        printf("%u",frame);
        for(const char *key:{"road","traffic_signs","player","scenery","hud","panel","bottom","viewport","swap","audio"})printf(",%zu",capture[key].size());
        printf(",%u,%u,%u,%d,%d\n",road.bands,unsigned(scene.cars),billboards.count,scene.skyDelta!=0,scene.skyRepaint);
        assert(!stream.overflow);
        for(const auto &kv:capture) {
            const std::string filename=std::string("wire-")+kv.first+".bin";
            FILE *f=fopen(filename.c_str(),"ab");assert(f);if(!kv.second.empty())assert(fwrite(kv.second.data(),1,kv.second.size(),f)==kv.second.size());fclose(f);
        }
        capture.clear();sceneryHistory.swapped();
    }
    assert(motion.position==1202800 && motion.phase==1600);
}
