// Linux-only observation of stock native swaps. No firmware or command changes.
// Resolve once during warmup; hot hooks only call real code, clock and atomics.
#include <SDL3/SDL.h>
#include <dlfcn.h>
#include <atomic>
#include <cstdint>
#include <cstdio>
#include <cstdlib>
#include <ctime>
#include <unistd.h>
namespace {
constexpr unsigned Capacity=8192;
struct Record {uint64_t begin,end;unsigned kind,ordinal;};
Record records[Capacity]{};
std::atomic<unsigned> used{0},canvas{0},paletted{0},completeCanvas{0};
std::atomic<bool> ready[Capacity]{};
static_assert(std::atomic<unsigned>::is_always_lock_free);
uint64_t now(){timespec t{};if(clock_gettime(CLOCK_MONOTONIC,&t))std::_Exit(91);return uint64_t(t.tv_sec)*1000000000+uint64_t(t.tv_nsec);}
void *symbol(const char *name){
    const char *path=std::getenv("R19_VDP_MODULE");
    void *module=path?dlopen(path,RTLD_NOW|RTLD_NOLOAD):nullptr;
    void *value=module?dlsym(module,name):nullptr;
    if(!value){std::fprintf(stderr,"swap probe missing %s: %s\n",name,dlerror());std::_Exit(92);}
    return value;
}
void save(unsigned kind,unsigned ordinal,uint64_t begin,uint64_t end){
    unsigned index=used.fetch_add(1,std::memory_order_relaxed);
    if(index>=Capacity)std::_Exit(93);
    records[index]={begin,end,kind,ordinal};ready[index].store(true,std::memory_order_release);
}
}
extern "C" void canvasSwap(void*) asm("_ZN5fabgl6Canvas11swapBuffersEv");
extern "C" void canvasSwap(void *self){
    static auto real=reinterpret_cast<void(*)(void*)>(symbol("_ZN5fabgl6Canvas11swapBuffersEv"));
    unsigned ordinal=canvas.fetch_add(1,std::memory_order_relaxed);
    uint64_t begin=now();real(self);uint64_t end=now();save(0,ordinal,begin,end);
    completeCanvas.fetch_add(1,std::memory_order_release);
}
extern "C" void palettedSwap(void*) asm("_ZN5fabgl21VGAPalettedController11swapBuffersEv");
extern "C" void palettedSwap(void *self){
    static auto real=reinterpret_cast<void(*)(void*)>(symbol("_ZN5fabgl21VGAPalettedController11swapBuffersEv"));
    unsigned ordinal=paletted.fetch_add(1,std::memory_order_relaxed);
    uint64_t begin=now();real(self);uint64_t end=now();save(1,ordinal,begin,end);
}
extern "C" bool SDL_RenderPresent(SDL_Renderer *renderer){
    static auto real=reinterpret_cast<bool(*)(SDL_Renderer*)>(dlsym(RTLD_NEXT,"SDL_RenderPresent"));
    if(!real)std::_Exit(94);
    bool result=real(renderer);
    static const unsigned target=[](){const char*p=std::getenv("R19_SWAP_COUNT");return p?unsigned(std::strtoul(p,nullptr,10)):0u;}();
    static bool written=false;
    // No file checks or writes until the entire known finite swap batch ends.
    if(!written && target && completeCanvas.load(std::memory_order_acquire)>=target){
        const char *stop=std::getenv("R19_SWAP_STOP"),*output=std::getenv("R19_SWAP_OUTPUT");
        if(stop && output && access(stop,F_OK)==0){
            unsigned count=used.load(std::memory_order_acquire);
            for(unsigned i=0;i<count;++i)if(!ready[i].load(std::memory_order_acquire))return result;
            FILE*f=std::fopen(output,"w");if(!f)std::_Exit(95);
            std::fprintf(f,"kind,ordinal,begin_ns,end_ns\n");
            for(unsigned i=0;i<count;++i){const auto&r=records[i];
                std::fprintf(f,"%u,%u,%llu,%llu\n",r.kind,r.ordinal,
                             (unsigned long long)r.begin,(unsigned long long)r.end);}
            std::fprintf(f,"# complete\n");if(std::fclose(f))std::_Exit(96);written=true;
        }
    }
    return result;
}
