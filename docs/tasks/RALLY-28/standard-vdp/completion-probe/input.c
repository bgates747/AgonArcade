/* Headless SDL3 key events enter Flexe's PS/2 model and actual stock firmware.
 * No packet/mailbox injection. MIT, Brandon Gates, 2026. */
#define _POSIX_C_SOURCE 200809L
#include <SDL3/SDL.h>
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
typedef struct {unsigned ms; SDL_Scancode key; bool down;} Action;
static const Action actions[]={
    {100,SDL_SCANCODE_UP,true},{200,SDL_SCANCODE_LEFT,true},
    {350,SDL_SCANCODE_UP,false},{450,SDL_SCANCODE_LEFT,false},
    {1200,SDL_SCANCODE_A,true},{1400,SDL_SCANCODE_A,false},
    {1600,SDL_SCANCODE_F12,true},{1800,SDL_SCANCODE_F12,false}
};
bool SDL_PollEvent(SDL_Event *event){
    static bool (*real_poll)(SDL_Event*);static uint64_t start;static unsigned index;
    if(!real_poll)*(void**)(&real_poll)=dlsym(RTLD_NEXT,"SDL_PollEvent");
    struct timespec t;clock_gettime(CLOCK_MONOTONIC,&t);uint64_t now=(uint64_t)t.tv_sec*1000+t.tv_nsec/1000000;
    if(!start){const char *p=getenv("SYNC_READY_LOG");FILE *f=p?fopen(p,"rb"):NULL;
        if(f){char text[32769];size_t n=fread(text,1,sizeof(text)-1,f);fclose(f);text[n]=0;
            // Binary control bytes can contain NUL, so search with explicit lengths.
            const char token[]="SYNC_INPUT_READY";
            for(size_t i=0;i+sizeof(token)-1<=n;++i)if(!memcmp(text+i,token,sizeof(token)-1)){start=now;break;}
        }
    }
    if(start && event && index<sizeof(actions)/sizeof(actions[0]) && now-start>=actions[index].ms){
        const Action *a=&actions[index++];memset(event,0,sizeof(*event));event->type=a->down?SDL_EVENT_KEY_DOWN:SDL_EVENT_KEY_UP;
        event->key.scancode=a->key;event->key.key=SDL_GetKeyFromScancode(a->key,0,false);event->key.down=a->down;
        return true;
    }
    return real_poll(event);
}
