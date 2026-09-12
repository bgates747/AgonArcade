// Linux-only external diagnostic. No firmware patch, command or math replacement.
// Observe stock heap_caps_malloc allocations and actual libc frees (including
// delete[] paths that bypass stock heap_caps_free's accounting). Snapshot only
// at guest-declared idle phases; never use this interposer for performance.
#include <SDL3/SDL.h>
#include <dlfcn.h>
#include <atomic>
#include <cstdio>
#include <cstdlib>
#include <mutex>
#include <unordered_map>
extern "C" void __libc_free(void *);
namespace {
thread_local bool internal=false;
struct Allocation {size_t bytes;int caps;};
struct Trace {
    std::mutex lock;
    std::unordered_map<void*,Allocation> live;
    size_t bytes=0,peak=0,allocations=0,frees=0;
};
Trace &trace(){static Trace *value=new Trace;return *value;}
void *moduleSymbol(const char *name){
    const char *path=std::getenv("R19_VDP_MODULE");
    void *module=path?dlopen(path,RTLD_NOW|RTLD_NOLOAD):nullptr;
    void *symbol=module?dlsym(module,name):nullptr;
    if(!symbol){std::fprintf(stderr,"memory probe missing %s: %s\n",name,dlerror());std::_Exit(92);}
    return symbol;
}
}
void *heap_caps_malloc(size_t size,int caps){
    static auto real=reinterpret_cast<void*(*)(size_t,int)>(moduleSymbol("_Z16heap_caps_mallocmi"));
    void *p=real(size,caps);
    if(p){
        internal=true;
        auto &t=trace();
        {std::lock_guard<std::mutex> guard(t.lock);
            if(!t.live.emplace(p,Allocation{size,caps}).second)std::_Exit(93);
            t.bytes+=size;t.peak=std::max(t.peak,t.bytes);++t.allocations;
        }
        internal=false;
    }
    return p;
}
extern "C" void free(void *p) noexcept {
    if(p&&!internal){
        internal=true;
        auto &t=trace();
        {std::lock_guard<std::mutex> guard(t.lock);
            auto it=t.live.find(p);
            if(it!=t.live.end()){t.bytes-=it->second.bytes;t.live.erase(it);++t.frees;}
        }
        internal=false;
    }
    __libc_free(p);
}
extern "C" bool SDL_RenderPresent(SDL_Renderer *renderer){
    static auto real=reinterpret_cast<bool(*)(SDL_Renderer*)>(dlsym(RTLD_NEXT,"SDL_RenderPresent"));
    if(!real)std::_Exit(94);
    const char *path=std::getenv("R19_MEMORY_PHASE");
    static unsigned last=0;
    FILE *phase=path?std::fopen(path,"r"):nullptr;
    if(phase){
        unsigned value=0;char line[64],*end=nullptr;bool complete=false;
        if(std::fgets(line,sizeof(line),phase)){value=std::strtoul(line,&end,10);if(*end=='\r')++end;complete=*end=='\n'&&end[1]==0;}std::fclose(phase);
        if(complete&&value&&value!=last){
            last=value;
            const char *out=std::getenv("R19_MEMORY_REPORT");
            FILE *f=out?std::fopen(out,"a"):nullptr;if(!f)std::_Exit(95);
            internal=true;
            auto &t=trace();
            {std::lock_guard<std::mutex> guard(t.lock);
                std::fprintf(f,"%u,%zu,%zu,%zu,%zu,%zu\n",value,t.live.size(),t.bytes,t.peak,t.allocations,t.frees);
            }
            internal=false;std::fclose(f);
            if(value==999){
                SDL_Event event{};event.type=SDL_EVENT_KEY_DOWN;event.key.scancode=SDL_SCANCODE_ESCAPE;event.key.key=SDLK_ESCAPE;event.key.down=true;
                if(!SDL_PushEvent(&event))std::_Exit(96);
            }
        }
    }
    return real(renderer);
}
