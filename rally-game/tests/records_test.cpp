#include "record_file.hpp"
#include <assert.h>
using namespace rally::game;
int main() {
    Records a,b;uint8_t bytes[Records::Bytes];
    bool seen[Records::Count]{};
    for(unsigned track=0;track<2;++track)for(unsigned mode=0;mode<2;++mode)
        for(unsigned step=1;step<3;++step)for(int grip=25;grip<=200;grip+=5) {
            unsigned index=Records::key(track,mode,step,grip);assert(index<Records::Count && !seen[index]);seen[index]=true;
        }
    assert(a.update(10,12345,1580));assert(!a.update(10,1,1700));
    assert(a.update(10,12400,1550));a.encode(bytes);assert(b.decode(bytes,sizeof(bytes)));
    assert(b.entries[10].score==12400 && b.entries[10].lap==1550);
    for(unsigned i=0;i<Records::Bytes;++i) {bytes[i]^=1;assert(!b.decode(bytes,sizeof(bytes)));bytes[i]^=1;}
    assert(!b.decode(bytes,sizeof(bytes)-1));assert(!b.update(288,1,1));
    Records::put32(bytes+16,10000000);Records::put32(bytes+12,Records::hash(bytes+16,Records::Bytes-16));
    assert(!b.decode(bytes,sizeof(bytes)));
    assert(saveRecords(a));assert(readRecords("rally.sav",b));
    assert(a.update(10,22222,1500));assert(saveRecords(a));
    assert(readRecords("rally.bak",b) && b.entries[10].score==12400);
    assert(readRecords("rally.sav",b) && b.entries[10].score==22222);
    remove("rally.sav");assert(readRecords("rally.bak",b));remove("rally.bak");
    puts("Record setting identities, corruption rejection, verified activation and backup passed");
}
