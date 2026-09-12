// Full-road headless visual transport; candidate receives only raw game state.
#define main admission_main
#include "transport.inc"
#undef main
#ifdef ROAD_ORACLE
#include "lookup_road.hpp"
#endif
namespace {
void marker(const char *name,int result) {FILE*f=fopen(name,"w");if(f){fprintf(f,"%d\n",result);fclose(f);}}
bool nextKey(){return vdp_getKeyMap(15)&2;}
bool escapeKey(){return vdp_getKeyMap(14)&1;}
int visual() {
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_cursor_enable(false);
#ifdef ROAD_ORACLE
    send(rally::section::Startup,rally::section::StartupSize);
    rally::LookupRoad road;
#ifdef ROAD_FUJI
    road.track=&rally::Fuji;if(!road.load("fuji.road"))return 2;
#else
    road.track=&rally::TriOval;if(!road.load("oval.road"))return 2;
#endif
#else
    if(!upload())return 2;
#endif
    if(!poll(0xa5))return 3;
    const uint8_t reply[]={23,0,128,0};vdp_adv_clear_buffer(Query);vdp_adv_write_block_data(Query,4,(char*)reply);
    FILE*input=fopen("poses.dat","rb"),*output=fopen("geometry.dat","wb");if(!input || !output)return 4;
    uint8_t header[2];if(fread(header,1,2,input)!=2)return 5;
    unsigned count=header[0]+256u*header[1];if(!count || count>40)return 6;
    for(unsigned i=0;i<count;++i) {
#ifdef ROAD_ADMITTED
        uint8_t state[80];enum {PositionOffset=8,PhaseOffset=12,Output=1020,Status=1021};
#else
        uint8_t state[12];enum {PositionOffset=0,PhaseOffset=4,Output=1001,Status=1002};
#endif
        if(fread(state,1,sizeof(state),input)!=sizeof(state))return 7;
#ifdef ROAD_ORACLE
        const uint8_t*p=state+PositionOffset;
        int32_t position=int32_t(p[0])+256L*p[1]+65536L*p[2]+16777216L*p[3];
        road.project(position,state[PhaseOffset]+256u*state[PhaseOffset+1]);
#endif
        for(unsigned frame=0;frame<2;++frame) {
            // Sky is constant in this road-only test; resident candidate clears
            // the moving road/footer. No host-drawn road rectangles per frame.
            if(i==0){vdp_gcol(0,2);vdp_filled_rectangle(0,0,319,103);}
#ifdef ROAD_ORACLE
            rally::Stream stream;road.emit(stream,false);send(stream.data,stream.size);
#else
            uint8_t update[]={23,0,160,232,3,5,194,0,0,sizeof(state),0};send(update,sizeof(update));send(state,sizeof(state));
            call(2000);
#ifdef ROAD_ADMITTED
            unsigned seq=state[4]+256u*state[5];seq=seq==65534?0:seq+1;word(state+4,seq);word(state+76,seq);
#endif
#endif
            vdp_swap();if(!poll(0xa5))return 8;
        }
        uint8_t geometry[200];unsigned bands;
#ifdef ROAD_ORACLE
        bands=road.bands;word(geometry,bands);
        for(unsigned r=0;r<=bands;++r){
            word(geometry+2+r*6,road.rows[r]);word(geometry+4+r*6,rally::sectionCentrePixel(road.centersQ8[r]));
            word(geometry+6+r*6,r<bands?unsigned(road.materials[r]):0);
        }
#else
        if(!query(Output,60,geometry[0]) || !query(Output,61,geometry[1]))return 9;
        bands=geometry[0]+256u*geometry[1];if(!bands || bands>32)return 10;
        for(unsigned j=0;j<2;++j){uint8_t value;if(!query(Output,62+j,value) || value)return 11;}
        for(unsigned j=0;j<10;++j){uint8_t value;if(!query(Status,j,value) || value!=(j%2?0:1))return 12;}
#ifdef ROAD_ADMITTED
        for(unsigned j=0;j<2;++j){uint8_t value;if(!query(1002,j,value) || value!=(j?0:1))return 19;}
        uint8_t lo,hi;if(!query(1002,4,lo) || !query(1002,5,hi) || lo+256u*hi!=2*(i+1))return 20;
#endif
        for(unsigned j=0;j<(bands+1)*6;++j)if(!query(1600,j,geometry[2+j]))return 13;
#endif
        if(!bands || bands>32 || fwrite(geometry,1,2+(bands+1)*6,output)!=2+(bands+1)*6)return 14;
        fflush(output);if(i==0)marker("ready.viz",0);
        while(nextKey())if(escapeKey())return 15;
        while(!nextKey())if(escapeKey()){
            if(i+1!=count)return 16;fclose(input);fclose(output);return 0;
        }
        if(i+1==count)return 17;
    }
    return 18;
}
}
int main(){int result=visual();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);marker("exit.viz",result);return result;}
