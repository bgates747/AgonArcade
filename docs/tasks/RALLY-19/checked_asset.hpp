#pragma once
// Integrity check for compiler-produced local command assets. This detects
// damage/mismatched derivatives; FNV-1a is not an authentication mechanism.
#include <stdint.h>
#include <stdio.h>
namespace rally { namespace r19 {
struct AssetSignature {uint32_t bytes,hash;};
inline uint32_t assetHash(uint32_t hash,const uint8_t*data,unsigned count){
    for(unsigned i=0;i<count;++i)hash=(hash^data[i])*UINT32_C(16777619);
    return hash;
}
inline FILE* openAsset(const char*name,AssetSignature expected){
    if(!expected.bytes||expected.bytes>1024UL*1024)return nullptr;
    FILE*input=fopen(name,"rb");if(!input)return nullptr;
    uint8_t bytes[1024];unsigned count;uint32_t total=0,hash=UINT32_C(2166136261);
    while((count=fread(bytes,1,sizeof(bytes),input))){
        total+=count;if(total>expected.bytes){fclose(input);return nullptr;}
        hash=assetHash(hash,bytes,count);
    }
    bool ok=!ferror(input)&&total==expected.bytes&&hash==expected.hash;
    if(!ok||fseek(input,0,SEEK_SET)){fclose(input);return nullptr;}
    return input;
}
}}
