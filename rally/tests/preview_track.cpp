// Host-only VDU stream export for independent raster inspection.
#include "road.hpp"
#include <stdio.h>
#include <stdlib.h>
int main(int argc,char **argv) {
    if(argc!=2) return 1;
    rally::Road road; rally::Stream stream; road.init();
    int32_t position=strtol(argv[1],nullptr,10)*100;
    road.render(stream,position%8000,position);
    if(stream.overflow) return 2;
    fwrite(stream.data,1,stream.size,stdout);
}
