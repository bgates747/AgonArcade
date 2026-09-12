#include <SDL3/SDL.h>
#include <stdio.h>
int main(void) {
    if(!SDL_Init(SDL_INIT_VIDEO))return 2;
    SDL_Window *w=SDL_CreateWindow("headless capture qualification",32,24,0);
    SDL_Renderer *r=w?SDL_CreateRenderer(w,"software"):NULL;
    if(!r)return 3;
    unsigned down=0,up=0,quit=0,frames=0;
    for(;frames<20 && !quit;){
        SDL_SetRenderDrawColor(r,17,34,51,255);SDL_RenderClear(r);
        if(!SDL_RenderPresent(r))return 4;
        ++frames;SDL_Event e;
        while(SDL_PollEvent(&e)){
            if(e.type==SDL_EVENT_KEY_DOWN && e.key.scancode==SDL_SCANCODE_RIGHT)++down;
            if(e.type==SDL_EVENT_KEY_UP && e.key.scancode==SDL_SCANCODE_RIGHT)++up;
            if(e.type==SDL_EVENT_QUIT)++quit;
        }
    }
    printf("presents=%u down=%u up=%u quit=%u\n",frames,down,up,quit);
    SDL_DestroyRenderer(r);SDL_DestroyWindow(w);SDL_Quit();
    return frames==8 && down==1 && up==1 && quit==1?0:5;
}
