#include <agon/mos.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#ifndef PROBE_GP
#define PROBE_GP 0
#endif
extern "C" {
void probe_callback();
volatile uint8_t probe_events[2550],probe_count,probe_overflow,probe_marker,probe_hits;
volatile uint8_t *probe_sysvars;
}
namespace {
constexpr uint16_t FirstBuffer=52800;
constexpr uint16_t FirstFrame=53200;
constexpr unsigned Frames=52;
// Tagged MOS 3.0.2 map: _sysvars=BC3BF, _user_kbvector=BC42B.
// The generated profile pins the exact official ROM/map. No MOS code is patched.
constexpr unsigned CallbackOffset=0x6c;
struct Frame {
    uint32_t submit,returned,completion,observed,counter,passes;
    uint8_t marker,hits,pixel,r,g,b,heavy,token;
};
Frame rows[Frames];
uint8_t block[4096],keymap_before[16],keymap_after[16];
unsigned used=0,completed=0;
uint32_t last_clock=0,counter=0,passes=0,begin_clock=0,end_clock=0,idle_hits=0;
const char *failure=nullptr;
bool installed=false,restored=false;
void (*previous)()=nullptr;

void send(const uint8_t *p,unsigned n){mos_puts(reinterpret_cast<const char*>(p),n,0);}
void byte(uint8_t b){block[used++]=b;}
void word(uint16_t w){byte(w&255);byte(w>>8);}
void rectangle(uint8_t colour,uint16_t x,uint16_t y,uint16_t right,uint16_t bottom){
    byte(18);byte(0);byte(colour);byte(25);byte(4);word(x);word(y);
    byte(25);byte(101);word(right);word(bottom);
}
void buffered(uint16_t id,uint8_t op){uint8_t b[]={23,0,160,uint8_t(id),uint8_t(id>>8),op};send(b,sizeof b);}
void store(uint16_t id){
    buffered(id,2);
    uint8_t b[]={23,0,160,uint8_t(id),uint8_t(id>>8),0,uint8_t(used),uint8_t(used>>8)};
    send(b,sizeof b);send(block,used);
}
void install(uint16_t id,bool heavy,uint8_t colour){
    used=0;
    for(unsigned i=0;i<(heavy?192u:1u);++i)
        rectangle(uint8_t(1+i%7),0,64,319,215);
    rectangle(colour,300,225,319,239);
    store(id);
}
void install_frame(unsigned i){
    bool heavy=i>=24 && i<48;uint8_t marker=i<48?0:170,token=uint8_t(40+i);
    uint16_t draw=FirstBuffer+(heavy?2:0)+(i&1);used=0;
    byte(23);byte(0);byte(160);word(draw);byte(1);
    // The seven-byte completion tail is executed from this stored buffer.
    byte(23);byte(0);byte(0xCA);byte(23);byte(0);byte(PROBE_GP?0x80:0x99);byte(PROBE_GP?token:marker);
    store(FirstFrame+i);
}
uint32_t clock_now(){return getsysvar_time();}
void service(){uint32_t now=clock_now();counter+=uint32_t(now-last_clock);last_clock=now;++passes;}
bool elapsed(uint32_t start,uint32_t ticks){return uint32_t(clock_now()-start)>=ticks;}
void idle(uint32_t ticks){uint32_t start=clock_now();uint8_t hits=probe_hits;
    while(!elapsed(start,ticks)){service();if(probe_overflow){failure="keyboard capture overflow";break;}}
    idle_hits+=uint8_t(probe_hits-hits);
}
uint8_t gp(){return probe_sysvars[sysvar_gp];}
bool fence(uint8_t token){uint8_t b[]={23,0,0xCA,23,0,0x80,token};send(b,sizeof b);
    uint32_t start=clock_now();while(gp()!=token && !elapsed(start,600))service();return gp()==token;}

bool frame(unsigned i){
    Frame &f=rows[i];f.heavy=i>=24 && i<48;f.marker=i<48?0:170; // VK_NONE / VK_F12
    f.token=uint8_t(40+i);probe_marker=f.marker;
    uint8_t hits=probe_hits,events=probe_count;
    uint8_t colour=i&1?4:2;
    f.submit=clock_now();buffered(FirstFrame+i,1);
    f.returned=clock_now();service();uint32_t counted=counter,loops=passes;
    bool seen=false;
    while(!elapsed(f.submit,600)){
        service();
        if(probe_overflow){failure="keyboard capture overflow";return false;}
        bool signalled=PROBE_GP?gp()==f.token:probe_hits!=hits;
        if(signalled && !seen){seen=true;f.completion=clock_now();f.counter=counter-counted;f.passes=passes-loops;
            if(!PROBE_GP){uint8_t count=probe_count;
                for(unsigned e=events;e<count;++e)if(probe_events[e*10+2]==f.marker){
                    const volatile uint8_t *p=probe_events+e*10+4;
                    f.completion=uint32_t(p[0])|(uint32_t(p[1])<<8)|(uint32_t(p[2])<<16)|(uint32_t(p[3])<<24);break;
                }
            }
        }
        if(seen)break;
    }
    // Verify only AFTER the primary signal. No poll/readback command is needed
    // to elicit the key callback, and this ordering is independently trace-checked.
    if(!seen){failure="completion timeout";return false;}
    probe_sysvars[sysvar_vdp_pflags]&=uint8_t(~vdp_pflag_point);
    uint8_t verify_token=PROBE_GP?uint8_t(100+i):f.token;
    uint8_t check[]={23,0,0x84,54,1,230,0,23,0,0x80,verify_token};send(check,sizeof check);
    uint32_t verify_start=clock_now();
    while((gp()!=verify_token || !(probe_sysvars[sysvar_vdp_pflags]&vdp_pflag_point)) && !elapsed(verify_start,600))service();
    f.observed=clock_now();
    f.hits=uint8_t(probe_hits-hits);f.pixel=probe_sysvars[sysvar_scrpixelIndex];
    f.r=probe_sysvars[sysvar_scrpixel];f.g=probe_sysvars[sysvar_scrpixel+1];f.b=probe_sysvars[sysvar_scrpixel+2];
    if(gp()!=verify_token || !(probe_sysvars[sysvar_vdp_pflags]&vdp_pflag_point)){failure="readback/drain timeout";return false;}
    if(!PROBE_GP && f.hits!=1){failure="duplicate/ambiguous marker";return false;}
    if(f.pixel!=colour){failure="final pixel mismatch";return false;}
    ++completed;return true;
}
bool write(uint8_t file,const char *data){return mos_fwrite(file,const_cast<char*>(data),strlen(data))==strlen(data);}
bool save(){
    uint8_t summary=mos_fopen("summary.txt",FA_WRITE|FA_CREATE_NEW),events=mos_fopen("events.csv",FA_WRITE|FA_CREATE_NEW);
    if(!summary || !events){if(summary)mos_fclose(summary);if(events)mos_fclose(events);return false;}
    char line[300];
    snprintf(line,sizeof line,"schema=1\r\nbackend=%s\r\nfirmware=official-v2.16.0\r\nmos=official-v3.0.2\r\nclock_hz=120\r\ncompleted=%u\r\nplanned=%u\r\nelapsed_ticks=%lu\r\ncounter_ticks=%lu\r\nidle_marker_hits=%lu\r\nkeyboard_packets=%u\r\noverflow=%u\r\ncallback_restored=%u\r\nfailure=%s\r\n",PROBE_GP?"general-poll":"keyboard-callback",completed,Frames,(unsigned long)(end_clock-begin_clock),(unsigned long)counter,(unsigned long)idle_hits,unsigned(probe_count),unsigned(probe_overflow),unsigned(restored),failure?failure:"none");
    bool ok=write(summary,line);
    snprintf(line,sizeof line,"keymap_before=");ok=ok&&write(summary,line);
    for(uint8_t v:keymap_before){snprintf(line,sizeof line,"%02x",unsigned(v));ok=ok&&write(summary,line);}
    ok=ok&&write(summary,"\r\nkeymap_after=");
    for(uint8_t v:keymap_after){snprintf(line,sizeof line,"%02x",unsigned(v));ok=ok&&write(summary,line);}
    ok=ok&&write(summary,"\r\n");
    ok=ok&&write(events,"kind,index,heavy,marker,submit,returned,completion,observed,pending_counter,passes,hits,pixel,r,g,b,token\r\n");
    for(unsigned i=0;i<completed;++i){const Frame &f=rows[i];snprintf(line,sizeof line,"frame,%u,%u,%u,%lu,%lu,%lu,%lu,%lu,%lu,%u,%u,%u,%u,%u,%u\r\n",i,unsigned(f.heavy),unsigned(f.marker),(unsigned long)f.submit,(unsigned long)f.returned,(unsigned long)f.completion,(unsigned long)f.observed,(unsigned long)f.counter,(unsigned long)f.passes,unsigned(f.hits),unsigned(f.pixel),unsigned(f.r),unsigned(f.g),unsigned(f.b),unsigned(f.token));ok=ok&&write(events,line);}
    ok=ok&&write(events,"kind,index,ascii,modifiers,vkey,down,tick,gp,pflags\r\n");
    for(unsigned i=0;i<probe_count;++i){const volatile uint8_t *p=probe_events+i*10;uint32_t t=uint32_t(p[4])|(uint32_t(p[5])<<8)|(uint32_t(p[6])<<16)|(uint32_t(p[7])<<24);
        snprintf(line,sizeof line,"key,%u,%u,%u,%u,%u,%lu,%u,%u\r\n",i,unsigned(p[0]),unsigned(p[1]),unsigned(p[2]),unsigned(p[3]),(unsigned long)t,unsigned(p[8]),unsigned(p[9]));ok=ok&&write(events,line);}
    mos_fclose(events);mos_fclose(summary);return ok;
}
}
int main(){
    probe_sysvars=mos_sysvars();
    auto vector=reinterpret_cast<void(**)()>(const_cast<uint8_t*>(probe_sysvars)+CallbackOffset);
    previous=*vector;
    uint8_t init[]={22,8,23,0,192,0,23,1,0,12};send(init,sizeof init);
    printf("RALLY-28 STOCK COMPLETION PROBE\r\n%s / official VDP 2.16.0\r\nSimple drawing; background counter continues.\r\nTry arrows/A/Z; marker tests include F12.\r\n",PROBE_GP?"GENERAL POLL":"KEYBOARD CALLBACK");
    for(unsigned i=0;i<4;++i)install(FirstBuffer+i,i>=2,i&1?4:2);
    for(unsigned i=0;i<Frames;++i)install_frame(i);
    if(!fence(0xE1)){failure="setup fence timeout";save();return 1;}
    memcpy(keymap_before,mos_getkbmap(),16);probe_marker=0;
    mos_setkbvector(probe_callback,0);installed=true;
    printf("SYNC_INPUT_READY\r\n");
    counter=passes=0;
    begin_clock=last_clock=clock_now();
    idle(120);
    uint32_t next=clock_now();
    for(unsigned i=0;i<Frames && !failure;++i){while(int32_t(clock_now()-next)<0)service();
        if(!frame(i))break;next+=4;
        // Bound submission rather than catching up several renders after a stall.
        if(int32_t(clock_now()-next)>=0)next=clock_now()+4;
    }
    probe_marker=0;idle(120);if(idle_hits && !failure)failure="unsolicited marker during request-free control";
    if(!fence(0xE2) && !failure)failure="cleanup fence timeout";
    end_clock=clock_now();service();
    if(installed){mos_setkbvector(previous,0);restored=*vector==previous;installed=false;}
    memcpy(keymap_after,mos_getkbmap(),16);
    for(unsigned i=0;i<4;++i)buffered(FirstBuffer+i,2);
    for(unsigned i=0;i<Frames;++i)buffered(FirstFrame+i,2);
    bool saved=save();
    printf("\r\n%s: %u/%u completions, %lu counter ticks\r\n%s\r\n",failure||!saved?"FAIL":"PASS",completed,Frames,(unsigned long)counter,failure?failure:saved?"Saved summary.txt and events.csv":"Could not create result files (use a fresh directory)");
    uint8_t show[]={23,1,1};send(show,sizeof show);
    if(saved){uint8_t done=mos_fopen("done.txt",FA_WRITE|FA_CREATE_NEW);if(done){write(done,failure?"FAIL\r\n":"PASS\r\n");mos_fclose(done);}else saved=false;}
    return failure||!saved?1:0;
}
