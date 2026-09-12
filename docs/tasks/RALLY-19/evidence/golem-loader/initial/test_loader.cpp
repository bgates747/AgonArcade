// Real stdio, accepted simulation/protocol and actual GolemRenderer; only SDK
// transport is replaced. Inject errors at every read/seek/close boundary.
#include <cstdio>
#include <cstdint>
#include <cstdlib>
#include <cassert>
#include <cstring>
#include <vector>
#include <string>
#include <algorithm>
namespace fault {
unsigned reads=0,closes=0,seeks=0,failRead=0,failClose=0,failSeek=0;
FILE*error=nullptr;
void reset(){reads=closes=seeks=failRead=failClose=failSeek=0;error=nullptr;}
size_t read(void*p,size_t size,size_t count,FILE*f){
    if(++reads==failRead){error=f;return 0;}return std::fread(p,size,count,f);
}
int close(FILE*f){int rc=std::fclose(f);if(error==f)error=nullptr;return ++closes==failClose?EOF:rc;}
int seek(FILE*f,long n,int whence){if(++seeks==failSeek)return -1;return std::fseek(f,n,whence);}
int errorCode(FILE*f){return error==f?1:std::ferror(f);}
}
std::vector<uint8_t> staging,expectedBootstrap,expectedClear;
unsigned installs=0,clears=0,cleanupCalls=0;
void mos_puts(const char*data,unsigned size,char){
    const uint8_t call[]={23,0,160,0,0,1};
    if(size==6&&std::memcmp(data,call,6)==0){assert(staging==expectedBootstrap);++installs;}
    else {assert(size==expectedClear.size());assert(std::memcmp(data,expectedClear.data(),size)==0);++cleanupCalls;}
}
void vdp_adv_clear_buffer(unsigned id){assert(id==0);staging.clear();++clears;}
void vdp_adv_write_block_data(unsigned id,unsigned size,char*data){assert(id==0&&size&&size<=1024);staging.insert(staging.end(),data,data+size);}
#define fread fault::read
#define fclose fault::close
#define fseek fault::seek
#define ferror fault::errorCode
#include "golem_renderer.hpp"
#undef fread
#undef fclose
#undef fseek
#undef ferror

std::vector<uint8_t> readFile(const char*name){
    FILE*f=std::fopen(name,"rb");assert(f);std::vector<uint8_t> result;uint8_t block[1024];size_t n;
    while((n=std::fread(block,1,sizeof(block),f)))result.insert(result.end(),block,block+n);
    assert(!std::ferror(f));assert(!std::fclose(f));return result;
}
void writeFile(const char*name,const std::vector<uint8_t>&data){
    FILE*f=std::fopen(name,"wb");assert(f);assert(std::fwrite(data.data(),1,data.size(),f)==data.size());assert(!std::fclose(f));
}
unsigned cases=0;
int main(){
    for(bool fuji:{false,true}){
        const char*boot=fuji?"fuji.vdp":"oval.vdp",*clear=fuji?"fuji.clr":"oval.clr";
        expectedBootstrap=readFile(boot);expectedClear=readFile(clear);
        auto originalBootstrap=expectedBootstrap,originalClear=expectedClear;
        auto reset=[&](){fault::reset();installs=clears=cleanupCalls=0;staging.clear();};
        auto restore=[&](){writeFile(boot,originalBootstrap);writeFile(clear,originalClear);};
        reset();rally::r19::GolemRenderer renderer;assert(renderer.load(fuji));
        unsigned loadReads=fault::reads,loadCloses=fault::closes,loadSeeks=fault::seeks;
        assert(installs==1&&staging.empty());assert(!renderer.load(!fuji));assert(installs==1);
        fault::reset();assert(renderer.unload());
        unsigned unloadReads=fault::reads,unloadCloses=fault::closes,unloadSeeks=fault::seeks;
        assert(cleanupCalls==1);assert(renderer.unload());assert(cleanupCalls==1);++cases;
        // A failed preflight has no UART side effects; later upload faults may
        // touch staging0 but must clear it and never execute the bootstrap.
        for(unsigned type=0;type<3;++type){
            unsigned count=type==0?loadReads:type==1?loadCloses:loadSeeks;
            for(unsigned at=1;at<=count;++at){
                reset();if(type==0)fault::failRead=at;else if(type==1)fault::failClose=at;else fault::failSeek=at;
                rally::r19::GolemRenderer failed;assert(!failed.load(fuji));
                assert(installs==0&&cleanupCalls==0&&staging.empty());
                fault::reset();assert(failed.load(fuji));assert(failed.unload());++cases;
            }
        }
        for(unsigned type=0;type<3;++type){
            unsigned count=type==0?unloadReads:type==1?unloadCloses:unloadSeeks;
            for(unsigned at=1;at<=count;++at){
                reset();rally::r19::GolemRenderer failed;assert(failed.load(fuji));fault::reset();
                if(type==0)fault::failRead=at;else if(type==1)fault::failClose=at;else fault::failSeek=at;
                assert(!failed.unload());assert(cleanupCalls==0);fault::reset();assert(failed.unload());assert(cleanupCalls==1);++cases;
            }
        }
        for(unsigned which=0;which<2;++which){
            const char*name=which?clear:boot;const auto&original=which?originalClear:originalBootstrap;
            for(size_t cut:std::vector<size_t>{0,1,2,3,5,6,7,255,256,1023,1024,original.size()/2,original.size()-1}){
                reset();restore();writeFile(name,std::vector<uint8_t>(original.begin(),original.begin()+cut));
                rally::r19::GolemRenderer failed;assert(!failed.load(fuji));assert(installs==clears&&clears==0);++cases;
            }
            for(size_t at:std::vector<size_t>{0,1,2,5,6,255,1024,original.size()/2,original.size()-1}){
                reset();restore();auto bad=original;bad[at]^=0x80;writeFile(name,bad);
                rally::r19::GolemRenderer failed;assert(!failed.load(fuji));assert(installs==clears&&clears==0);++cases;
            }
            reset();restore();auto extra=original;extra.push_back(0);writeFile(name,extra);
            rally::r19::GolemRenderer failed;assert(!failed.load(fuji));assert(!installs&&!clears);++cases;
            reset();restore();assert(!std::remove(name));rally::r19::GolemRenderer missing;
            assert(!missing.load(fuji));assert(!installs&&!clears);++cases;
        }
        // Wrong/missing cleanup after installation must remain retryable and
        // emit no partial cleanup bytes, regardless of whether preflight fails.
        reset();restore();rally::r19::GolemRenderer retry;assert(retry.load(fuji));
        auto bad=originalClear;bad.back()^=1;writeFile(clear,bad);assert(!retry.unload());assert(!cleanupCalls);
        restore();assert(retry.unload());assert(cleanupCalls==1);++cases;
        reset();restore();auto tooLarge=originalBootstrap;tooLarge.resize(1024*1024+1);writeFile(boot,tooLarge);
        rally::r19::GolemRenderer huge;assert(!huge.load(fuji));assert(!installs&&!clears);restore();++cases;
    }
    std::printf("loader cases=%u: missing/truncated/corrupt/oversize assets, every read/seek/close fault, retry and ownership pass\n",cases);
}
