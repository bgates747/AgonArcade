// Complete road/vehicle visual probe. Candidate receives production raw state.
#define main admission_main
#include "transport.inc"
#undef main
#include "car.hpp"
#include "traffic.hpp"
#include "scene_protocol.hpp"
#include <string.h>
#ifdef VEHICLE_ORACLE
#include "lookup_road.hpp"
#include "scene.hpp"
#endif
namespace {
void marker(const char *name,int value){FILE*f=fopen(name,"w");if(f){fprintf(f,"%d\n",value);fclose(f);}}
bool right(){return vdp_getKeyMap(15)&2;}
bool escape(){return vdp_getKeyMap(14)&1;}
uint8_t carUpload[102*77];
void artwork(){
    for(unsigned i=0;i<5;++i){
        vdp_adv_clear_buffer(64000+i);
        for(unsigned y=0;y<77;++y)for(unsigned x=0;x<102;++x)
            carUpload[y*102+x]=rally::CarPixels[i][(y*48/77)*64+x*64/102];
        vdp_adv_write_block_data(64000+i,sizeof(carUpload),(char*)carUpload);
        vdp_select_bitmap(i);vdp_adv_bitmap_from_buffer(102,77,1);
    }
    for(unsigned livery=1;livery<rally::LiveryCount;++livery){
        for(unsigned pixel=0;pixel<256;++pixel)carUpload[pixel]=rally::carColour(pixel,livery);
        vdp_adv_clear_buffer(63960);vdp_adv_write_block_data(63960,256,(char*)carUpload);
        for(unsigned i=0;i<5;++i){
            unsigned bitmap=livery*5+i;vdp_adv_clear_buffer(64000+bitmap);
            uint8_t map[]={23,0,160,0,0,72,16,0,0,216,249};word(map+3,64000+bitmap);word(map+7,64000+i);
            send(map,sizeof(map));vdp_select_bitmap(bitmap);vdp_adv_bitmap_from_buffer(102,77,1);
        }
    }
    vdp_adv_clear_buffer(63960);
}
#ifdef VEHICLE_ORACLE
void matrix(unsigned id,int xx,int scale,int translation){
    uint8_t bytes[]={23,0,160,0,0,32,0,23,0,160,0,0,32,11,200,0,0,0,0,0,0,0,0,0,0,0,0};
    word(bytes+3,id);word(bytes+10,id);word(bytes+15,xx);word(bytes+19,translation);word(bytes+23,scale);send(bytes,sizeof(bytes));
}
#endif
int visual(){
    if(vdp_mode(136)<0)return 1;
    vdp_set_pixel_coordinates();vdp_reset_sprites();vdp_cursor_enable(false);artwork();
#ifdef VEHICLE_ORACLE
    const uint8_t feature[]={23,0,248,1,0,1,0};send(feature,sizeof(feature));
    send(rally::section::Startup,rally::section::StartupSize);
    rally::LookupRoad road;rally::Motion motion;rally::Traffic traffic;rally::SceneryHistory history;
#ifdef VEHICLE_FUJI
    road.track=motion.track=&rally::Fuji;if(!road.load("fuji.road"))return 2;
#else
    road.track=motion.track=&rally::TriOval;if(!road.load("oval.road"))return 2;
#endif
    volatile rally::r18::SceneState scene{};
#else
    if(!upload())return 2;
#endif
    if(!poll(0xa5))return 3;
    const uint8_t reply[]={23,0,128,0};vdp_adv_clear_buffer(Query);vdp_adv_write_block_data(Query,4,(char*)reply);
    FILE*input=fopen("poses.dat","rb");if(!input)return 4;
    uint8_t header[2];if(fread(header,1,2,input)!=2)return 5;
    unsigned count=header[0]+256u*header[1];if(!count || count>40)return 6;
    for(unsigned i=0;i<count;++i){
        uint8_t state[80];if(fread(state,1,80,input)!=80)return 7;
#ifdef VEHICLE_ORACLE
        rally::r19::State decoded;if(!rally::r19::decode(state,80,decoded))return 21;
        motion.position=decoded.position;motion.phase=decoded.phase;motion.lateral=decoded.lateral;
        motion.steering=decoded.steering;motion.speed=decoded.speed;
        for(unsigned j=0;j<6;++j){traffic.cars[j].position=decoded.cars[j].position;traffic.cars[j].lane=decoded.cars[j].lane;}
#endif
        for(unsigned frame=0;frame<2;++frame){
            // Background intentionally fixed; scenery qualification is R19-09.
            if(i==0){vdp_gcol(0,2);vdp_filled_rectangle(0,0,319,103);}
#ifdef VEHICLE_ORACLE
            rally::r18::prepareScene(motion,traffic,road,history,scene,false);
            rally::Stream stream;road.emit(stream,false);send(stream.data,stream.size);
            for(unsigned j=0;j<scene.cars;++j){volatile const auto &c=scene.traffic[j];
                matrix(c.matrix,c.xx,c.scale,c.translation);vdp_select_bitmap(c.bitmap);
                vdp_adv_use_affine_matrix(1,c.matrix);vdp_draw_bitmap(c.x,c.y);
            }
            vdp_adv_use_affine_matrix(1,65535);vdp_select_bitmap(scene.playerBitmap);
            if(scene.playerMirror){matrix(63984,-256,256,101*256);vdp_adv_use_affine_matrix(1,63984);}
            vdp_draw_bitmap(scene.playerX,154);vdp_adv_use_affine_matrix(1,65535);
#else
            uint8_t update[]={23,0,160,232,3,5,194,0,0,80,0};send(update,sizeof(update));send(state,sizeof(state));call(2000);
            unsigned seq=state[4]+256u*state[5];seq=seq==65534?0:seq+1;word(state+4,seq);word(state+76,seq);
#endif
            vdp_swap();if(!poll(0xa5))return 8;
#ifdef VEHICLE_ORACLE
            history.swapped();
#endif
        }
        char name[24];snprintf(name,sizeof(name),"scene-%02u.csv",i);FILE*out=fopen(name,"w");if(!out)return 9;
#ifdef VEHICLE_ORACLE
        fprintf(out,"0,0,0,0,0,%d,%d,%d,%u\n",scene.playerBitmap,int(scene.playerMirror),scene.playerX,scene.cars);
        for(unsigned r=0;r<road.boundaryCount;++r)fprintf(out,"R,%u,%ld,%u\n",unsigned(road.rows[r]),long(road.centersQ8[r]),unsigned(r<road.bands?road.materials[r]:0));
        for(unsigned j=0;j<scene.cars;++j){volatile const auto &c=scene.traffic[j];fprintf(out,"C,%d,%d,%d,%d,%d,%d\n",c.bitmap,c.scale,int(c.mirrored),c.x,c.y,c.translation);}
#else
        uint8_t player[12],cars[96],flags[8];
        for(unsigned j=0;j<12;++j)if(!query(1716,j,player[j]))return 10;
        for(unsigned j=0;j<96;++j)if(!query(1714,j,cars[j]))return 11;
        for(unsigned j=0;j<8;++j)if(!query(1711,j,flags[j]))return 12;
        if(rally::r19::word(flags)!=1 || rally::r19::word(flags+2)!=1)return 13;
        fprintf(out,"0,0,0,0,0,%u,%u,%d,%u\n",unsigned(rally::r19::word(player)),unsigned(rally::r19::word(player+2)),int(rally::r19::signed16(rally::r19::word(player+4))),unsigned(rally::r19::word(flags+6)));
        uint8_t lo,hi;if(!query(1020,60,lo)||!query(1020,61,hi))return 14;unsigned bands=lo+256u*hi;if(!bands||bands>32)return 15;
        for(unsigned r=0;r<=bands;++r){uint8_t row[6],pixelBytes[4];for(unsigned j=0;j<6;++j)if(!query(1600,r*6+j,row[j]))return 16;
            for(unsigned j=0;j<4;++j)if(!query(1724,r*4+j,pixelBytes[j]))return 24;
            float pixel;memcpy(&pixel,pixelBytes,4);
            fprintf(out,"R,%u,%ld,%u\n",unsigned(rally::r19::word(row)),long(pixel*256),unsigned(rally::r19::word(row+4)));}
        for(unsigned j=0;j<6;++j){auto*c=cars+j*16;if(!rally::r19::word(c))continue;
            fprintf(out,"C,%u,%u,%u,%d,%d,%u\n",unsigned(rally::r19::word(c+4)),unsigned(rally::r19::word(c+6)),unsigned(rally::r19::word(c+8)),int(rally::r19::signed16(rally::r19::word(c+10))),int(rally::r19::signed16(rally::r19::word(c+12))),unsigned(rally::r19::word(c+14)));}
        if(!query(1002,4,lo)||!query(1002,5,hi)||lo+256u*hi!=2*(i+1))return 17;
        if(!query(1723,0,lo)||!query(1723,1,hi)||lo!=1||hi)return 22;
#endif
        if(fclose(out)!=0)return 18;if(i==0)marker("ready.viz",0);
        while(right())if(escape())return 19;
        while(!right())if(escape()){
            if(i+1!=count)return 20;fclose(input);return 0;
        }
    }
    return 23;
}
}
int main(){int result=visual();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);marker("exit.viz",result);return result;}
