// Task-local UART sink. Stock CPU and UART scheduling are untouched.
#include <dlfcn.h>
#include <atomic>
#include <chrono>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <string>
#include <thread>
#include <unistd.h>
static void *stockLibrary(){
    static void *handle=[](){const char *path=getenv("RALLY_STOCK_VDP");if(!path)abort();void *p=dlopen(path,RTLD_NOW|RTLD_LOCAL);if(!p){fprintf(stderr,"%s\n",dlerror());abort();}return p;}();return handle;
}
static std::atomic<bool> active{false};
static std::atomic<uint64_t> count{0}, hash{14695981039346656037ULL};
static bool discard;
static void *symbol(const char *name) {
    void *p=dlsym(stockLibrary(),name); if(!p){fprintf(stderr,"Missing stock symbol %s\n",name);abort();}return p;
}
static void touch(const std::string &p){FILE*f=fopen(p.c_str(),"w");if(!f)abort();fclose(f);}
extern "C" void vdp_setup(){
    const char *stock=getenv("RALLY_STOCK_VDP"),*directory=getenv("RALLY_SINK_DIR"),*mode=getenv("RALLY_SINK_MODE");
    if(!stock||!directory||!mode)abort();
    discard=std::string(mode)=="sink";
    if(!discard&&std::string(mode)!="count")abort();
    reinterpret_cast<void(*)()>(symbol("vdp_setup"))();
    std::thread([dir=std::string(directory)]{
        while(access((dir+"/start.snk").c_str(),F_OK))std::this_thread::sleep_for(std::chrono::milliseconds(2));
        active.store(true);touch(dir+"/go.snk");
        while(access((dir+"/done.snk").c_str(),F_OK))std::this_thread::sleep_for(std::chrono::milliseconds(2));
        active.store(false);
        FILE*f=fopen((dir+"/sink.json").c_str(),"w");if(!f)abort();
        fprintf(f,"{\"bytes\":%llu,\"fnv1a64\":\"%016llx\",\"discard\":%s}\n",(unsigned long long)count.load(),(unsigned long long)hash.load(),discard?"true":"false");fclose(f);
        touch(dir+"/stop.snk");
    }).detach();
}
extern "C" void z80_send_to_vdp(uint8_t b){
    static auto f=reinterpret_cast<void(*)(uint8_t)>(symbol("z80_send_to_vdp"));
    if(active.load()){count.fetch_add(1,std::memory_order_relaxed);hash.store((hash.load(std::memory_order_relaxed)^b)*1099511628211ULL,std::memory_order_relaxed);if(discard)return;}f(b);
}
extern "C" bool z80_uart0_is_cts(){static auto f=reinterpret_cast<bool(*)()>(symbol("z80_uart0_is_cts"));return active.load()&&discard?true:f();}
#define FORWARD(ret,name,args,call) extern "C" ret name args { static auto target=reinterpret_cast<ret(*)args>(symbol(#name));return target call; }
FORWARD(void,vdp_loop,(),())
FORWARD(void,vdp_shutdown,(),())
FORWARD(void,signal_vblank,(),())
FORWARD(void,copyVgaFramebuffer,(uint32_t*w,uint32_t*h,uint8_t*b,float*f),(w,h,b,f))
FORWARD(void,set_startup_screen_mode,(uint32_t m),(m))
FORWARD(bool,z80_recv_from_vdp,(uint8_t*b),(b))
FORWARD(void,sendVKeyEventToFabgl,(uint32_t k,uint8_t d),(k,d))
FORWARD(void,sendPS2KbEventToFabgl,(uint16_t k,uint8_t d),(k,d))
FORWARD(void,sendHostMouseEventToFabgl,(const uint8_t*b),(b))
FORWARD(void,setVdpDebugLogging,(bool b),(b))
FORWARD(void,getAudioSamples,(uint8_t*b,uint32_t n),(b,n))
FORWARD(void,dump_vdp_mem_stats,(),())
