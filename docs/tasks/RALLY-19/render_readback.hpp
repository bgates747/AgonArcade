// Untimed post-batch admission readback, derived from qualified native_admission.
// No geometry readback or per-frame fence is present in the measured workload.
namespace r19read {
constexpr unsigned Query=1999;
void word(uint8_t*p,unsigned n){p[0]=n;p[1]=n>>8;}
void send(const uint8_t*p,unsigned n){mos_puts((char*)p,n,0);}
void call(unsigned id){uint8_t c[]={23,0,160,0,0,1};word(c+3,id);send(c,sizeof(c));}
void adjust(unsigned op,uint8_t value){
    uint8_t c[]={23,0,160,0,0,5,0,3,0,0};word(c+3,Query);c[6]=op;c[9]=value;send(c,sizeof(c));
}
bool query(unsigned id,unsigned offset,uint8_t&value){
    uint8_t parts[2];
    for(unsigned nibble=0;nibble<2;++nibble){
        adjust(2,0x55);
        uint8_t c[]={23,0,160,0,0,5,0xe2,3,0,1,0,0,0,0,0};
        word(c+3,Query);word(c+11,id);word(c+13,offset);send(c,sizeof(c));
        adjust(5,nibble?0xf0:0x0f);adjust(6,nibble?0x08:0x10);
        auto&gp=reinterpret_cast<volatile uint8_t*>(sys_vars)[0x37];gp=0xff;call(Query);
        uint32_t start=rawClock();while(gp==0xff)if(rally::ticksSince(rawClock(),start)>240)return false;
        parts[nibble]=gp;if(nibble?((parts[nibble]&15)!=8):((parts[nibble]&0xf0)!=0x10))return false;
    }
    value=(parts[0]&15)|(parts[1]&0xf0);return true;
}
bool admission(uint8_t*out){
    const uint8_t reply[]={23,0,128,0};vdp_adv_clear_buffer(Query);vdp_adv_write_block_data(Query,4,(char*)reply);
    for(unsigned i=0;i<10;++i)if(!query(1002,i,out[i]))return false;
    for(unsigned i=0;i<2;++i)if(!query(1003,i,out[10+i]))return false;
    vdp_adv_clear_buffer(Query);return true;
}
}
