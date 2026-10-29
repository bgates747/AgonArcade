/* Host-only lease/wire/checksum qualification; fake clocks have no timing use. */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define memset phase_host_memset
#include "phase_probe.c"
#undef memset

static struct {uint8_t *data;unsigned bytes;unsigned leased;} memory[4];
static unsigned granted,released;
static int32_t acquire(void *ctx,uint16_t id,uint16_t access,uint32_t offset,uint32_t bytes,vdplet_view_v1 *view) {
    (void)ctx;
    if(id<PH_INPUT || id>PH_LOG || offset || (access!=VDPL_READ && access!=VDPL_WRITE))return VDPL_E_ARGUMENT;
    unsigned i=id-PH_INPUT;
    if(memory[i].leased)return VDPL_E_BUSY;
    if(bytes!=VDPL_WHOLE_BUFFER && bytes!=memory[i].bytes)return VDPL_E_BOUNDS;
    memory[i].leased=1;++granted;
    *view=(vdplet_view_v1){sizeof(*view),i+1,memory[i].data,memory[i].bytes,access};
    return 0;
}
static int32_t release(void *ctx,uint32_t lease) {
    (void)ctx;
    if(!lease || lease>4 || !memory[lease-1].leased)return VDPL_E_HANDLE;
    memory[lease-1].leased=0;++released;return 0;
}
int main(int argc,char **argv) {
    assert(argc==3);
    FILE *input=fopen(argv[1],"rb");assert(input);assert(!fseek(input,0,SEEK_END));long size=ftell(input);assert(size>0);rewind(input);
    memory[0].bytes=(unsigned)size;memory[0].data=malloc((size_t)size);assert(memory[0].data);
    assert(fread(memory[0].data,1,(size_t)size,input)==(size_t)size);assert(!fclose(input));
    unsigned rows=get32(memory[0].data+12)*8u;
    for(unsigned i=1;i<4;++i) {memory[i].bytes=i==3?PH_HEADER+rows*PH_ROW:PH_SCRATCH;memory[i].data=calloc(1,memory[i].bytes);assert(memory[i].data);}
    vdplet_host_v1 h={.struct_bytes=sizeof(h),.abi_major=1,.capabilities=VDPL_CAP_BUFFERS,.buffer_acquire=acquire,.buffer_release=release};
    vdplet_request_v1 r={sizeof(r),VDPL_INIT,0,50904,0,2};assert(!vdplet_entry(&h,&r));
    r.operation=VDPL_RUN;r.entry_id=1;
    for(unsigned i=0;i<rows;++i) {int32_t rc=vdplet_entry(&h,&r);if(rc)fprintf(stderr,"sample %u error %d\n",i,rc);assert(!rc);assert(granted==released);}
    assert(get32(memory[3].data+16)==rows);
    FILE *out=fopen(argv[2],"wb");assert(out);assert(fwrite(memory[3].data,1,memory[3].bytes,out)==memory[3].bytes);assert(!fclose(out));
    assert(vdplet_entry(&h,&r)==VDPL_E_BOUNDS);assert(granted==released);
    r.operation=VDPL_FINI;assert(!vdplet_entry(&h,&r));
    printf("%u sample windows; %u granted/released leases; extra-window rejection passes\n",rows,granted);
    for(unsigned i=0;i<4;++i)free(memory[i].data);
    return 0;
}
