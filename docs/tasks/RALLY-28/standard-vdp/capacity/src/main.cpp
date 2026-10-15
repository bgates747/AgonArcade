#include "workload.hpp"
extern "C" {
void timing_irq(),timing_start(),timing_stop(),timing_release();
uint24_t timing_ticks(),timing_claim();
volatile uint24_t ticks=0,elapsed=0;
}
namespace {
uint32_t states[4][105];
uint32_t prt[4]={},mos[4]={};unsigned rounds=0;
bool writeFile(const char *name,const char *s) {
    const uint8_t f=mos_fopen(name,6);if(!f)return false;
    const unsigned n=strlen(s);const bool ok=mos_fwrite(f,const_cast<char*>(s),n)==n;mos_fclose(f);return ok;
}
}
int main() {
    char count[16]={};uint8_t f=mos_fopen("count.txt",1);if(!f)return 1;
    const unsigned n=mos_fread(f,count,15);mos_fclose(f);if(!n)return 2;
    for(unsigned i=0;i<n && count[i]>='0' && count[i]<='9';++i)rounds=rounds*10+count[i]-'0';
    if(!rounds || rounds>1000 || !timing_claim())return 3;
    auto old=reinterpret_cast<void(*)()>(mos_setintvector(0x0c,timing_irq));
    mos_puts("CAP_BEGIN",9,0);
    timing_start();const uint32_t begin=rawClock();
    for(unsigned r=0;r<rounds;++r)for(unsigned scenario=0;scenario<4;++scenario) {
        const uint32_t p=timing_ticks(),m=rawClock();capacity::setup(scenario);
        for(unsigned i=0;i<capacity::Block;++i)capacity::step(i);
        prt[scenario]+=(timing_ticks()-p)&0xffffff;mos[scenario]+=rawClock()-m;
        if(r+1==rounds)capacity::snapshot(scenario,[](unsigned s,unsigned k,uint32_t v){states[s][k]=v;});
    }
    const uint32_t end=rawClock();timing_stop();const uint32_t total=elapsed;
    auto installed=reinterpret_cast<void(*)()>(mos_setintvector(0x0c,old));timing_release();
    mos_puts("CAP_END",7,0);
    // State came from the actual last timed blocks; all file I/O follows teardown.
    char text[700];snprintf(text,sizeof text,
        "schema=1\r\nrounds=%u\r\nsteps=%lu\r\nmos_begin=%lu\r\nmos_end=%lu\r\nmos_units=%lu\r\nprt_ticks=%lu\r\nvector_restored=%u\r\nnominal_mos_hz=120\r\nnominal_prt_hz=1000\r\nnumerical_tick=original-120-unit-clock-and-100-integrator\r\n",
        rounds,(unsigned long)(rounds*4096UL),(unsigned long)begin,(unsigned long)end,
        (unsigned long)(end-begin),(unsigned long)total,installed==timing_irq);
    bool ok=writeFile("summary.txt",text);
    f=mos_fopen("state.csv",6);if(!f)return 4;
    for(unsigned s=0;s<4;++s)capacity::snapshot(s,[&](unsigned,unsigned k,uint32_t){
        const int len=snprintf(text,sizeof text,"%u,%u,%lu\r\n",s,k,(unsigned long)states[s][k]);
        ok=mos_fwrite(f,text,len)==unsigned(len)&&ok;
    });
    mos_fclose(f);
    f=mos_fopen("phases.csv",6);if(!f)return 5;
    for(unsigned s=0;s<4;++s) {
        const int len=snprintf(text,sizeof text,"%u,%lu,%lu\r\n",s,(unsigned long)prt[s],(unsigned long)mos[s]);
        ok=mos_fwrite(f,text,len)==unsigned(len)&&ok;
    }mos_fclose(f);
    return ok && writeFile("done.txt","complete\n")?0:6;
}
