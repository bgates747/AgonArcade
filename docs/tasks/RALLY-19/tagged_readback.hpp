#pragma once
// Missing-buffer proofs use two different retained-copy tags. An existing byte
// equal to one tag cannot be mistaken for absence on both independent reads.
namespace r19tag {
bool query(unsigned id,unsigned offset,uint8_t&value,uint8_t tag){
    uint8_t parts[2];
    for(unsigned nibble=0;nibble<2;++nibble){
        r19read::adjust(2,tag);
        uint8_t c[]={23,0,160,0,0,5,0xe2,3,0,1,0,0,0,0,0};
        r19read::word(c+3,r19read::Query);r19read::word(c+11,id);r19read::word(c+13,offset);r19read::send(c,sizeof(c));
        r19read::adjust(5,nibble?0xf0:0x0f);r19read::adjust(6,nibble?0x08:0x10);
        auto&gp=reinterpret_cast<volatile uint8_t*>(sys_vars)[0x37];gp=0xff;r19read::call(r19read::Query);
        uint32_t start=rawClock();while(gp==0xff)if(rally::ticksSince(rawClock(),start)>240)return false;
        parts[nibble]=gp;if(nibble?((parts[nibble]&15)!=8):((parts[nibble]&0xf0)!=0x10))return false;
    }
    value=(parts[0]&15)|(parts[1]&0xf0);return true;
}
bool collect(FILE*out,unsigned id){
    const uint8_t tags[]={0x55,0xaa};
    for(uint8_t tag:tags){
        uint8_t value;if(!query(id,0,value,tag)||fwrite(&value,1,1,out)!=1)return false;
    }
    return true;
}
}
