#pragma once
#include "records.hpp"
#include <stdio.h>
#ifdef AGONDEV
#include <agon/mos.h>
#endif
namespace rally::game {
inline bool readRecords(const char *name,Records &records) {
    FILE *f=fopen(name,"rb");if(!f)return false;
    uint8_t bytes[Records::Bytes];
    bool ok=fread(bytes,1,sizeof(bytes),f)==sizeof(bytes) && fgetc(f)==EOF;
    fclose(f);return ok && records.decode(bytes,sizeof(bytes));
}
inline bool writeRecords(const char *name,const Records &records) {
    uint8_t bytes[Records::Bytes];records.encode(bytes);
    FILE *f=fopen(name,"wb");if(!f)return false;
    bool ok=fwrite(bytes,1,sizeof(bytes),f)==sizeof(bytes);
    if(fclose(f)!=0)ok=false;
    if(!ok)return false;
    Records verify;
    if(!readRecords(name,verify))return false;
    for(unsigned i=0;i<Records::Count;++i)
        if(records.entries[i].score!=verify.entries[i].score || records.entries[i].lap!=verify.entries[i].lap)return false;
    return true;
}
inline bool saveRecords(const Records &records) {
    // The verified new file precedes any mutation of the active record. Keep
    // the old valid file independently readable through failed activation.
    if(!writeRecords("rally.new",records))return false;
    Records prior;
    if(readRecords("rally.sav",prior) && !writeRecords("rally.bak",prior))return false;
    FILE *f=fopen("rally.sav","rb");
    if(f) {fclose(f);if(remove("rally.sav")!=0)return false;}
#ifdef AGONDEV
    return mos_ren("rally.new","rally.sav")==0;
#else
    return rename("rally.new","rally.sav")==0;
#endif
}
}
