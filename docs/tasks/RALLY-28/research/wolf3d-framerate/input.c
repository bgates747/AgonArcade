/* Ordinary SDL3 events for silent headless benchmark control. MIT. */
#define _POSIX_C_SOURCE 200809L
#include <SDL3/SDL.h>
#include <dlfcn.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

bool SDL_PollEvent(SDL_Event *event) {
    static bool (*real_poll)(SDL_Event *);
    static FILE *commands;
    if (!real_poll) *(void **)(&real_poll) = dlsym(RTLD_NEXT, "SDL_PollEvent");
    const char *name = getenv("WOLF_KEY_EVENTS");
    if (!commands && name) commands = fopen(name, "rb");
    if (commands && event) {
        char line[80];
        long offset = ftell(commands);
        clearerr(commands);
        if (fgets(line, sizeof line, commands)) {
            if (!strchr(line, '\n')) fseek(commands, offset, SEEK_SET);
            else {
                unsigned key, down;
                if (sscanf(line, "%u %u", &key, &down) != 2 || down > 1) abort();
                memset(event, 0, sizeof *event);
                event->type = down ? SDL_EVENT_KEY_DOWN : SDL_EVENT_KEY_UP;
                event->key.scancode = (SDL_Scancode)key;
                event->key.key = SDL_GetKeyFromScancode(event->key.scancode, 0, false);
                event->key.down = down;
                return true;
            }
        }
    }
    return real_poll(event);
}
