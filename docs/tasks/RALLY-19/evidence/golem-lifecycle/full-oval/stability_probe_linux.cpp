// Untimed, read-only inspection after a stock finite submit program returns.
// Reuse the qualified heap_caps tracker and its idle-phase SDL snapshot hook.
#include "memory_probe_linux.cpp"
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <vector>
// Exact POD declarations from pinned stock buffers.h. No global definitions or
// private container layouts are imported. LP64 ABI is verified explicitly.
struct AdvancedOffset {uint32_t blockOffset=0;size_t blockIndex=0;};
union MatrixSize {struct {uint8_t rows:4;uint8_t columns:4;};uint8_t value;};
static_assert(sizeof(AdvancedOffset)==16 && offsetof(AdvancedOffset,blockIndex)==8);
static_assert(sizeof(MatrixSize)==1 && sizeof(float)==4);
namespace {
using Read=bool(*)(uint16_t,AdvancedOffset&,void*,uint16_t,bool);
bool bytes(uint16_t id,void*out,uint16_t n){
    static auto read=reinterpret_cast<Read>(moduleSymbol("_Z15readBufferBytestR14AdvancedOffsetPvtb"));
    AdvancedOffset offset{};return read(id,offset,out,n,false);
}
const std::vector<uint16_t>& owned(){
    static const auto ids=[](){
        const char*path=std::getenv("R19_STABILITY_IDS");FILE*f=path?std::fopen(path,"r"):nullptr;
        if(!f)std::_Exit(101);
        std::vector<uint16_t> result;unsigned id;
        while(std::fscanf(f,"%u",&id)==1){if(id>65535)std::_Exit(102);result.push_back(id);}
        if(!std::feof(f)||result.empty())std::_Exit(103);
        std::fclose(f);return result;
    }();return ids;
}
unsigned word(const uint8_t*p){return p[0]+256u*p[1];}
void inspect(){
    static FILE*out=[](){const char*p=std::getenv("R19_STABILITY_OUTPUT");FILE*f=p?std::fopen(p,"w"):nullptr;
        if(!f)std::_Exit(104);
        std::fprintf(f,"call,valid,wrap,count,last,error,expected,matrices,nonfinite,read_errors,live_allocs,live_bytes,active_hex\n");return f;}();
    static auto shape=reinterpret_cast<MatrixSize(*)(uint16_t)>(moduleSymbol("_Z13getMatrixSizet"));
    static auto matrix=reinterpret_cast<bool(*)(uint16_t,float*,MatrixSize,bool)>(moduleSymbol("_Z19getMatrixFromBuffertPf10MatrixSizeb"));
    static unsigned calls=0;
    uint8_t status[12]{},active[80]{};unsigned errors=0,nonfinite=0,matrices=0;
    errors+=!bytes(1002,status,10);errors+=!bytes(1003,status+10,2);errors+=!bytes(1001,active,80);
    for(auto id:owned()){
        MatrixSize s=shape(id);if(!s.value)continue;
        if(!s.rows||!s.columns){++errors;continue;}
        float values[225]{}; // Native packed shape permits at most15*15.
        if(!matrix(id,values,s,false)){++errors;continue;}
        ++matrices;for(unsigned i=0;i<unsigned(s.rows)*s.columns;++i)nonfinite+=!std::isfinite(values[i]);
    }
    float road[33]{};if(!bytes(1724,road,sizeof(road)))++errors;
    else for(float value:road)nonfinite+=!std::isfinite(value);
    size_t count,live;
    internal=true;{auto&t=trace();std::lock_guard<std::mutex> guard(t.lock);count=t.live.size();live=t.bytes;}internal=false;
    std::fprintf(out,"%u",calls++);
    for(unsigned i=0;i<6;++i)std::fprintf(out,",%u",word(status+2*i));
    std::fprintf(out,",%u,%u,%u,%zu,%zu,",matrices,nonfinite,errors,count,live);
    for(auto value:active)std::fprintf(out,"%02x",unsigned(value));
    std::fprintf(out,"\n");std::fflush(out);
}
}
extern "C" void observeCall(void*,uint16_t,AdvancedOffset) asm("_ZN18VDUStreamProcessor10bufferCallEt14AdvancedOffset");
extern "C" void observeCall(void*self,uint16_t id,AdvancedOffset offset){
    static auto real=reinterpret_cast<void(*)(void*,uint16_t,AdvancedOffset)>(moduleSymbol("_ZN18VDUStreamProcessor10bufferCallEt14AdvancedOffset"));
    real(self,id,offset);
    if(id==2000)inspect();
}
