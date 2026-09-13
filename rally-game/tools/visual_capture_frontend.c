/* Visual/input evidence only. Never load this interposer for timing tests.
 * Adapted from RALLY-15/capture_macos.c; stock VDP and Fab stay unchanged. */
#include <SDL3/SDL.h>
#include <dlfcn.h>
#include <stdarg.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

typedef struct {
    unsigned frame;
    int kind; /* 0 capture, 1 key down, 2 key up, 3 quit */
    SDL_Scancode scan;
    SDL_Keycode key;
    char name[16];
} Action;
static Action actions[128];
static unsigned count, presented, frame;
static int initialized, ready;
static FILE *report;

static void record(const char *format, ...) {
    if (!report) return;
    va_list args;
    va_start(args, format);
    vfprintf(report, format, args);
    va_end(args);
    fputc('\n', report);
    fflush(report);
}

static int lookup_key(Action *a) {
    const struct {const char *name; SDL_Scancode scan; SDL_Keycode key;} keys[] = {
        {"left",SDL_SCANCODE_LEFT,SDLK_LEFT}, {"right",SDL_SCANCODE_RIGHT,SDLK_RIGHT},
        {"up",SDL_SCANCODE_UP,SDLK_UP}, {"down",SDL_SCANCODE_DOWN,SDLK_DOWN},
        {"space",SDL_SCANCODE_SPACE,SDLK_SPACE}, {"escape",SDL_SCANCODE_ESCAPE,SDLK_ESCAPE},
        {"minus",SDL_SCANCODE_MINUS,SDLK_MINUS}, {"equals",SDL_SCANCODE_EQUALS,SDLK_EQUALS}
    };
    for (unsigned i=0; i<sizeof(keys)/sizeof(keys[0]); ++i) {
        if (!strcmp(a->name,keys[i].name)) {
            a->scan=keys[i].scan; a->key=keys[i].key; return 1;
        }
    }
    return 0;
}

static void initialize(void) {
    initialized=1;
    const char *path=getenv("RALLY_VISUAL_LOG");
    if (path) report=fopen(path,"w");
    const char *configuration=getenv("RALLY_VISUAL_CONFIG");
    FILE *source=configuration?fopen(configuration,"r"):NULL;
    if (!report || !source || !getenv("RALLY_VISUAL_DIR")) {
        fprintf(stderr,"RALLY-22 visual configuration missing\n"); _Exit(90);
    }
    char line[128];
    while (fgets(line,sizeof(line),source)) {
        Action a={0}; char kind[16]={0}, direction[16]={0};
        int fields=sscanf(line,"%15s %u %15s %15s",kind,&a.frame,a.name,direction);
        if (!strcmp(kind,"capture") && fields==2) a.kind=0;
        else if (!strcmp(kind,"quit") && fields==2) a.kind=3;
        else if (!strcmp(kind,"key") && fields==4 && lookup_key(&a)) {
            if (!strcmp(direction,"down")) a.kind=1;
            else if (!strcmp(direction,"up")) a.kind=2;
            else {record("error invalid key direction");_Exit(91);}
        } else {record("error invalid configuration");_Exit(91);}
        if (!a.frame || count==sizeof(actions)/sizeof(actions[0])) {
            record("error action limit/frame");_Exit(91);
        }
        actions[count++]=a;
    }
    fclose(source);
    record("initialized actions=%u",count);
}

bool SDL_RenderPresent(SDL_Renderer *renderer) {
    static bool (*real_present)(SDL_Renderer*);
    if(!real_present) real_present=dlsym(RTLD_NEXT,"SDL_RenderPresent");
    if(!real_present) _Exit(92);
    if (!initialized) initialize();
    ++presented;
    if (!ready) {
        const char *path=getenv("RALLY_VISUAL_READY");
        if (!path || access(path,F_OK)==0) {
            ready=1; record("ready host_present=%u",presented);
        }
    }
    if (ready) {
        ++frame;
        for (unsigned i=0; i<count; ++i) {
            const Action *a=&actions[i];
            if (a->frame!=frame) continue;
            if (a->kind==0) {
                SDL_Surface *surface=SDL_RenderReadPixels(renderer,NULL);
                if (!surface) {record("error capture frame=%u %s",frame,SDL_GetError());continue;}
                char path[2048];
                int size=snprintf(path,sizeof(path),"%s/frame-%06u.bmp",getenv("RALLY_VISUAL_DIR"),frame);
                if (size<0 || (size_t)size>=sizeof(path) || !SDL_SaveBMP(surface,path))
                    record("error save frame=%u %s",frame,SDL_GetError());
                else record("capture frame=%u host_present=%u width=%d height=%d",frame,presented,surface->w,surface->h);
                SDL_DestroySurface(surface);
            } else {
                SDL_Event event={0};
                if (a->kind==3) event.type=SDL_EVENT_QUIT;
                else {
                    event.type=a->kind==1?SDL_EVENT_KEY_DOWN:SDL_EVENT_KEY_UP;
                    event.key.scancode=a->scan;event.key.key=a->key;event.key.down=a->kind==1;
                }
                if (!SDL_PushEvent(&event)) record("error push frame=%u %s",frame,SDL_GetError());
                else if (a->kind==3) record("quit frame=%u host_present=%u",frame,presented);
                else record("key frame=%u name=%s down=%u host_present=%u",frame,a->name,a->kind==1,presented);
            }
        }
    }
    return real_present(renderer);
}
