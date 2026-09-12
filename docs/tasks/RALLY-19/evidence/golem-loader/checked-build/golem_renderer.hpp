#pragma once
#include "frontend_state.hpp"
#include "scene_assets.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
namespace rally { namespace r19 {
class GolemRenderer {
    uint16_t sequence_=0;
    uint8_t packet_[PacketBytes]{};
    bool loaded_=false;
    const char*cleanup_=nullptr;
    AssetSignature cleanupSignature_{};
    static void send(const uint8_t*data,unsigned size){mos_puts((char*)data,size,0);}
public:
    uint32_t sceneBytes=0,frames=0;
    bool load(bool fuji){
        if(loaded_)return false;
        const char*name=fuji?"fuji.vdp":"oval.vdp";
        const char*cleanup=fuji?"fuji.clr":"oval.clr";
        const auto&signatures=SceneAssets[fuji?1:0];
        FILE*input=openAsset(name,signatures[0]);if(!input)return false;
        FILE*clear=openAsset(cleanup,signatures[1]);
        if(!clear){fclose(input);return false;}
        if(fclose(clear)){fclose(input);return false;}
        uint8_t bytes[1024];unsigned count;uint32_t total=0,hash=UINT32_C(2166136261);
        vdp_adv_clear_buffer(0);
        while((count=fread(bytes,1,sizeof(bytes),input))){
            total+=count;if(total>signatures[0].bytes){fclose(input);vdp_adv_clear_buffer(0);return false;}
            hash=assetHash(hash,bytes,count);
            vdp_adv_write_block_data(0,count,(char*)bytes);
        }
        bool ok=!ferror(input)&&total==signatures[0].bytes&&hash==signatures[0].hash;
        ok=fclose(input)==0&&ok;
        if(!ok){vdp_adv_clear_buffer(0);return false;}
        const uint8_t call[]={23,0,160,0,0,1};send(call,sizeof(call));
        // Every installed object owns its bytes; no resident operand refers to0.
        vdp_adv_clear_buffer(0);
        cleanup_=cleanup;cleanupSignature_=signatures[1];loaded_=true;sequence_=0;sceneBytes=frames=0;
        return true;
    }
    bool prepare(const Motion&motion,const Traffic&traffic,bool demo,bool autosteer){
        State state;
        return loaded_&&stateFromMotion(motion,traffic,sequence_,demo,autosteer,state)&&packet(state,packet_,sizeof(packet_));
    }
    void submit(){send(packet_,sizeof(packet_));sequence_=nextSequence(sequence_);sceneBytes+=sizeof(packet_);++frames;}
    bool unload(){
        if(!loaded_)return true;
        // <=1024 owned IDs, six bytes/clear. Hold the whole verified stream so
        // a short file read cannot leave the outer VDP parser inside a command.
        if(cleanupSignature_.bytes>6144)return false;
        FILE*input=openAsset(cleanup_,cleanupSignature_);if(!input)return false;
        uint8_t bytes[6144];unsigned count=fread(bytes,1,sizeof(bytes),input);
        bool ok=!ferror(input)&&count==cleanupSignature_.bytes&&
            assetHash(UINT32_C(2166136261),bytes,count)==cleanupSignature_.hash;
        ok=fclose(input)==0&&ok;
        if(!ok)return false;
        send(bytes,count);loaded_=false;return true;
    }
};
}}
