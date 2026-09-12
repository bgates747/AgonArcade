// Headless R19-06 visual transport. Candidate path only forwards raw state.
// Reuse the separately qualified uploader/readback, including its GP caveat.
#define main admission_main
#include "transport.inc"
#undef main
#ifdef SECTION_ORACLE
#include "lookup_road.hpp"
#endif
namespace {
void marker(const char *name,int result) {
    FILE*f=fopen(name,"w");if(f){fprintf(f,"%d\n",result);fclose(f);}
}
bool nextKey() { return vdp_getKeyMap(15)&2; } // right, code122
bool escapeKey() { return vdp_getKeyMap(14)&1; }
int visual() {
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_cursor_enable(false);
#ifdef SECTION_ORACLE
    send(rally::section::Startup,rally::section::StartupSize);
    rally::LookupRoad road;
#ifdef SECTION_FUJI
    road.track=&rally::Fuji;if(!road.load("fuji.road"))return 2;
#else
    road.track=&rally::TriOval;if(!road.load("oval.road"))return 2;
#endif
#else
    if(!upload())return 2;
#endif
    if(!poll(0xa5))return 3;
    const uint8_t reply[]={23,0,128,0};
    vdp_adv_clear_buffer(Query);vdp_adv_write_block_data(Query,4,(char*)reply);
    FILE *input=fopen("poses.dat","rb"),*output=fopen("geometry.dat","wb");
    if(!input || !output)return 4;
    uint8_t header[2];if(fread(header,1,2,input)!=2)return 5;
    unsigned count=header[0]+256u*header[1];if(!count || count>40)return 6;
    for(unsigned i=0;i<count;++i) {
        uint8_t state[12];if(fread(state,1,12,input)!=12)return 7;
#ifdef SECTION_ORACLE
        int32_t position=int32_t(state[0])+256L*state[1]+65536L*state[2]+16777216L*state[3];
        unsigned phase=state[4]+256u*state[5];road.project(position,phase);
        unsigned band=0;while(band<road.bands && !(road.rows[band]<=160 && 160<road.rows[band+1]))++band;
        if(band==road.bands)return 8;
        int cxTop=rally::sectionCentrePixel(road.centersQ8[band]),cxBottom=rally::sectionCentrePixel(road.centersQ8[band+1]);
        uint8_t geometry[10];word(geometry,cxTop);word(geometry+2,cxBottom);
        word(geometry+4,road.rows[band]);word(geometry+6,road.rows[band+1]);word(geometry+8,road.materials[band]);
        if(fwrite(geometry,1,10,output)!=10)return 9;
#else
        uint8_t update[]={23,0,160,232,3,5,194,0,0,12,0};send(update,sizeof(update));send(state,sizeof(state));
#endif
        for(unsigned frame=0;frame<2;++frame) {
            vdp_gcol(0,2);vdp_filled_rectangle(0,0,319,239);
#ifdef SECTION_ORACLE
            rally::Stream stream;rally::section::draw(stream,cxTop,cxBottom,road.rows[band],road.rows[band+1],road.materials[band]);send(stream.data,stream.size);
#else
            call(2000);
#endif
            vdp_swap();if(!poll(0xa5))return 10;
        }
#ifndef SECTION_ORACLE
        for(unsigned off=28;off<=34;off+=2)for(unsigned byte=0;byte<2;++byte) {
            uint8_t value;if(!query(1001,off+byte,value) || fwrite(&value,1,1,output)!=1)return 11;
        }
        for(unsigned byte=0;byte<2;++byte){uint8_t value;if(!query(1001,56+byte,value) || fwrite(&value,1,1,output)!=1)return 12;}
#endif
        fflush(output);if(i==0)marker("ready.viz",0);
        // Scheduled input advances poses; Escape is mandatory clean-exit proof.
        while(nextKey())if(escapeKey())return 13;
        while(!nextKey())if(escapeKey()) {
            if(i+1!=count)return 14;
            fclose(input);fclose(output);return 0;
        }
        if(i+1==count)return 15;
    }
    return 16;
}
}
int main() {
    int result=visual();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    marker("exit.viz",result);return result;
}
