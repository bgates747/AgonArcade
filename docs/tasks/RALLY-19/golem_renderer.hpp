#pragma once
#include "frontend_state.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
namespace rally { namespace r19 {
class GolemRenderer {
    uint16_t sequence_=0;
    uint8_t packet_[PacketBytes]{};
    bool loaded_=false;
    const char*cleanup_=nullptr;
    static void send(const uint8_t*data,unsigned size){mos_puts((char*)data,size,0);}
public:
    uint32_t sceneBytes=0,frames=0;
    bool load(bool fuji){
        const char*name=fuji?"fuji.vdp":"oval.vdp";
        FILE*input=fopen(name,"rb");if(!input)return false;
        uint8_t bytes[1024];unsigned count;uint32_t total=0;
        vdp_adv_clear_buffer(0);
        while((count=fread(bytes,1,sizeof(bytes),input))){
            total+=count;if(total>1024UL*1024){fclose(input);vdp_adv_clear_buffer(0);return false;}
            vdp_adv_write_block_data(0,count,(char*)bytes);
        }
        bool ok=!ferror(input)&&total>0;fclose(input);
        if(!ok){vdp_adv_clear_buffer(0);return false;}
        const uint8_t call[]={23,0,160,0,0,1};send(call,sizeof(call));
        // Every installed object owns its bytes; no resident operand refers to0.
        vdp_adv_clear_buffer(0);
        cleanup_=fuji?"fuji.clr":"oval.clr";loaded_=true;sequence_=0;sceneBytes=frames=0;
        return true;
    }
    bool prepare(const Motion&motion,const Traffic&traffic,bool demo,bool autosteer){
        State state;
        return loaded_&&stateFromMotion(motion,traffic,sequence_,demo,autosteer,state)&&packet(state,packet_,sizeof(packet_));
    }
    void submit(){send(packet_,sizeof(packet_));sequence_=nextSequence(sequence_);sceneBytes+=sizeof(packet_);++frames;}
    bool unload(){
        if(!loaded_)return true;
        FILE*input=fopen(cleanup_,"rb");if(!input)return false;
        uint8_t bytes[1024];unsigned count;
        while((count=fread(bytes,1,sizeof(bytes),input)))send(bytes,count);
        bool ok=!ferror(input);fclose(input);loaded_=false;
        return ok;
    }
};
}}
