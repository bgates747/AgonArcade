#include "workload.hpp"
#include "scene_workload.hpp"
extern "C" {
void timing_irq(),timing_start(),timing_stop(),timing_release();
uint24_t timing_ticks(),timing_claim();
volatile uint24_t ticks=0,elapsed=0;
}
extern uint32_t cpuBytes;
int main() {
    capacity::setupScene();cpuBytes=0;
    if(!timing_claim())return 1;
    auto old=reinterpret_cast<void(*)()>(mos_setintvector(0x0c,timing_irq));
    uint32_t advance=0,geometry=0,emission=0;timing_start();const uint32_t begin=rawClock();
    for(unsigned frame=0;frame<900;++frame) {
        const uint32_t a=timing_ticks();capacity::advanceScene();
        const uint32_t b=timing_ticks();
        rally::game::prepareGameScene(motion,traffic,raceTraffic,road,sceneryHistory,scene,false);
        billboards.prepare(motion,road);const uint32_t c=timing_ticks();
        capacity::drawScene([](const char*){});sceneryHistory.swapped();const uint32_t d=timing_ticks();
        advance+=(b-a)&0xffffff;geometry+=(c-b)&0xffffff;emission+=(d-c)&0xffffff;
    }
    const uint32_t end=rawClock();timing_stop();const uint32_t total=elapsed;
    auto installed=reinterpret_cast<void(*)()>(mos_setintvector(0x0c,old));timing_release();
    char data[600];const int len=snprintf(data,sizeof data,
        "schema=1\r\nframes=900\r\nmos_units=%lu\r\nprt_ticks=%lu\r\nadvance_prt=%lu\r\ngeometry_prt=%lu\r\nemission_prt=%lu\r\nbytes=%lu\r\nposition=%ld\r\nphase=%ld\r\nvector_restored=%u\r\n",
        (unsigned long)(end-begin),(unsigned long)total,(unsigned long)advance,(unsigned long)geometry,
        (unsigned long)emission,(unsigned long)cpuBytes,(long)motion.position,(long)motion.phase,installed==timing_irq);
    uint8_t f=mos_fopen("summary.txt",6);if(!f)return 2;
    const bool ok=mos_fwrite(f,data,len)==unsigned(len);mos_fclose(f);if(!ok)return 3;
    f=mos_fopen("done.txt",6);if(!f)return 4;const bool done=mos_fwrite(f,const_cast<char*>("complete\n"),9)==9;mos_fclose(f);return done?0:5;
}
