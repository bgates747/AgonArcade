#include <SDL3/SDL.h>
#include <stdio.h>
#include <stdlib.h>
static bool capture_present(SDL_Renderer *renderer) {
    static unsigned frame;
    ++frame;
    const char *directory = getenv("RALLY_CAPTURE_DIR");
    if (directory && (frame == 600 || frame == 720 || frame == 840 || frame == 900)) {
        SDL_Surface *surface = SDL_RenderReadPixels(renderer, NULL);
        if (surface) {
            char path[1024];
            snprintf(path,sizeof(path),"%s/frame-%u.bmp",directory,frame);
            SDL_SaveBMP(surface,path);
            SDL_DestroySurface(surface);
        }
    }
    if (getenv("RALLY_TEST_KEYS")) {
        struct Key {unsigned frame; SDL_Scancode scan; SDL_Keycode key; bool down;};
        const struct Key sequence[]={{620,SDL_SCANCODE_SPACE,SDLK_SPACE,true},{626,SDL_SCANCODE_SPACE,SDLK_SPACE,false},
          {680,SDL_SCANCODE_RIGHT,SDLK_RIGHT,true},{710,SDL_SCANCODE_RIGHT,SDLK_RIGHT,false},
          {760,SDL_SCANCODE_LEFT,SDLK_LEFT,true},{790,SDL_SCANCODE_LEFT,SDLK_LEFT,false},
          {850,SDL_SCANCODE_ESCAPE,SDLK_ESCAPE,true},{870,SDL_SCANCODE_ESCAPE,SDLK_ESCAPE,false}};
        for(unsigned i=0;i<sizeof(sequence)/sizeof(sequence[0]);++i) if(sequence[i].frame==frame) {
            SDL_Event event={0};event.type=sequence[i].down?SDL_EVENT_KEY_DOWN:SDL_EVENT_KEY_UP;
            event.key.scancode=sequence[i].scan;event.key.key=sequence[i].key;event.key.down=sequence[i].down;
            SDL_PushEvent(&event);
        }
    }
    if (frame == 920) { SDL_Event event = {0}; event.type=SDL_EVENT_QUIT; SDL_PushEvent(&event); }
    return SDL_RenderPresent(renderer);
}
__attribute__((used)) static struct { const void *replacement; const void *original; }
interpose __attribute__((section("__DATA,__interpose"))) = { (const void *)capture_present, (const void *)SDL_RenderPresent };
