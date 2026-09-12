// Reproduce the scene.csv state written by the isolated guest diagnostics.
// Uses the same headers but native host integer widths to detect differences
// in guest arithmetic, file loading and frame-history sequencing.
#include "lookup_road.hpp"
#include "scene.hpp"
#include "task_workload.hpp"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <limits.h>

namespace {
struct Options {
    bool lookup=false,perspective=false,snapshot=false;
    const rally::TrackDef *track=&rally::TriOval;
    const char *data="docs/tasks/RALLY-18/data";
    unsigned pose=0;
    int lateral=0,steering=0;
};

void usage() {
    fprintf(stderr,"usage: host_scene --variant live|lookup --track oval|fuji [--perspective] [--snapshot pose,lateral,steering] [--data directory]\n");
    exit(2);
}

int integer(const char *text,const char **end) {
    char *tail=nullptr;
    long value=strtol(text,&tail,10);
    if(tail==text || value<INT_MIN || value>INT_MAX) usage();
    *end=tail;return int(value);
}

Options parse(int argc,char **argv) {
    Options options;
    bool variant=false,track=false;
    for(int i=1;i<argc;++i) {
        if(strcmp(argv[i],"--perspective")==0) options.perspective=true;
        else if(strcmp(argv[i],"--variant")==0 && i+1<argc) {
            ++i;variant=true;
            if(strcmp(argv[i],"lookup")==0) options.lookup=true;
            else if(strcmp(argv[i],"live")!=0) usage();
        } else if(strcmp(argv[i],"--track")==0 && i+1<argc) {
            ++i;track=true;
            if(strcmp(argv[i],"fuji")==0) options.track=&rally::Fuji;
            else if(strcmp(argv[i],"oval")!=0) usage();
        } else if(strcmp(argv[i],"--data")==0 && i+1<argc) options.data=argv[++i];
        else if(strcmp(argv[i],"--snapshot")==0 && i+1<argc) {
            const char *end;
            int pose=integer(argv[++i],&end);
            if(pose<0 || pose>=int(rally::WorkloadFrames) || *end!=',') usage();
            options.pose=unsigned(pose);options.snapshot=true;
            options.lateral=integer(end+1,&end);
            if(*end!=',') usage();
            options.steering=integer(end+1,&end);
            if(*end || options.lateral< -150 || options.lateral>150 ||
               options.steering< -21 || options.steering>21) usage();
        } else usage();
    }
    if(!variant || !track) usage();
    return options;
}

void loadRoad(rally::SectionRoad &,const Options &) {}
void loadRoad(rally::LookupRoad &road,const Options &options) {
    const uint16_t endian=1;
    if(*reinterpret_cast<const uint8_t *>(&endian)!=1) {
        fprintf(stderr,"Host must be little endian for the guest's coefficient layout.\n");exit(3);
    }
    char filename[4096];
    int size=snprintf(filename,sizeof filename,"%s/%s.road",options.data,
                      options.track==&rally::Fuji?"fuji":"oval");
    if(size<0 || unsigned(size)>=sizeof filename) {fprintf(stderr,"Data path too long.\n");exit(3);}
    if(!road.load(filename)) {fprintf(stderr,"%s: %s\n",filename,road.error());exit(3);}
}

template<class Road> void run(const Options &options) {
    rally::Motion motion;rally::Traffic traffic;Road road;rally::SceneryHistory history;
    volatile rally::r18::SceneState scene{};
    motion.track=road.track=options.track;road.init();loadRoad(road,options);
    history.swapped(); // taskDiagnostic's initial stock swap.
    if(options.snapshot) {
        rally::r18::pose(options.pose,motion,traffic);
        motion.lateral=options.lateral*256L;motion.steering=options.steering;
        for(unsigned i=0;i<2;++i) {
            rally::r18::prepareScene(motion,traffic,road,history,scene,options.perspective);
            history.swapped();
        }
    } else {
        for(unsigned i=0;i<rally::WorkloadWarmup;++i) {
            rally::r18::pose(0,motion,traffic);
            motion.tick(false,false);traffic.tick(motion.track->length*100);
            rally::r18::prepareScene(motion,traffic,road,history,scene,options.perspective);
            history.swapped();
        }
        for(unsigned frame=0;frame<rally::WorkloadFrames;++frame) {
            rally::r18::pose(frame,motion,traffic);
            motion.tick(false,false);traffic.tick(motion.track->length*100);
            rally::r18::prepareScene(motion,traffic,road,history,scene,options.perspective);
            history.swapped();
        }
    }
    // Same output order and decimal representations as guest saveScene().
    // Agon libc's text-mode file translates its newline to CRLF; reproduce
    // those bytes explicitly so the comparison needs no normalization.
    printf("%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld,%ld\r\n",long(scene.skyOffset),long(scene.skyDelta),
           long(scene.skyLeft),long(scene.skyRight),long(scene.skyRepaint),long(scene.playerBitmap),
           long(scene.playerMirror),long(scene.playerX),long(scene.cars));
    for(unsigned i=0;i<road.boundaryCount;++i)
        printf("R,%u,%ld,%u\r\n",unsigned(road.rows[i]),long(road.centersQ8[i]),
               unsigned(i<road.bands?road.materials[i]:0));
    for(unsigned i=0;i<scene.cars;++i) {
        volatile const auto &c=scene.traffic[i];
        printf("C,%d,%d,%d,%d,%d,%d\r\n",c.bitmap,c.scale,c.mirrored,c.x,c.y,c.translation);
    }
}
}

int main(int argc,char **argv) {
    Options options=parse(argc,argv);
    if(options.lookup) run<rally::LookupRoad>(options);
    else run<rally::SectionRoad>(options);
    return 0;
}
