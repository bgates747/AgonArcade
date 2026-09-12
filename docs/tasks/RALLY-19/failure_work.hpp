// Observe cleanup after gameMain itself returns; do not repair game state here.
#include "render_readback.hpp"
#include "tagged_readback.hpp"
int failureMain(int argc,char**argv){
    int result=gameMain(argc,argv);road.~LookupRoad();
    if(!waitForVDP())return 151;
    uint8_t status[12]{};if(!r19read::admission(status))return 152;
    const uint8_t reply[]={23,0,128,0};vdp_adv_write_block_data(r19read::Query,4,(char*)reply);
    FILE*ids=fopen("owned.dat","rb"),*out=fopen("failure-owned.dat","wb");if(!ids||!out)return 153;
    uint8_t pair[2];unsigned count=0;
    while(fread(pair,1,2,ids)==2){
        unsigned id=pair[0]+256u*pair[1];
        if(!r19tag::collect(out,id))return 154;++count;
    }
    if(ferror(ids)||fclose(ids)||fclose(out))return 155;
    vdp_adv_clear_buffer(r19read::Query);if(!waitForVDP())return 156;
    out=fopen("failure-summary.csv","w");if(!out)return 157;
    fprintf(out,"result,queried\n%d,%u\n# complete\n",result,count);if(fclose(out))return 158;
    out=fopen("memory.phase","w");if(!out)return 159;fprintf(out,"100\n");fclose(out);
    marker("failure-exit.snk");return result;
}
