// Appended to the qualified opaque transport (whose main is renamed).
// Group timing ends at a stock GP parser echo, NOT a raster completion event.
namespace {
int constructionTiming() {
    if(vdp_mode(136)<0 || !upload() || !poll(0xa5))return 1;
    vdp_set_pixel_coordinates();vdp_cursor_enable(false);
    FILE*input=fopen("cases.dat","rb");if(!input)return 2;
    uint8_t header[6],poses[64][6];
    if(fread(header,1,6,input)!=6 || header[0]!='G' || header[1]!='1' || header[2]!='9' || header[3]!='T' || header[4]!=64 || header[5])return 3;
    if(fread(poses,1,sizeof(poses),input)!=sizeof(poses) || fgetc(input)!=EOF)return 4;
    fclose(input);
    FILE*output=fopen("results.dat","wb");if(!output)return 5;
    for(unsigned pass=0;pass<3;++pass)for(unsigned i=0;i<64;++i) {
        uint8_t update[]={23,0,160,232,3,5,194,0,0,6,0};send(update,sizeof(update));send(poses[i],6);
        if(!poll(0xa5))return 6;
        uint32_t start=ticks();call(2100);if(!poll(0xa5))return 7;
        uint32_t elapsed=ticks()-start;
        if(pass && fwrite(&elapsed,1,4,output)!=4)return 8;
    }
    fclose(output);return 0;
}
}
int main() {
    int result=constructionTiming();vdp_mode(0);vdp_set_logical_coordinates();vdp_cursor_enable(true);
    FILE*f=fopen("exit.txt","w");if(f){fprintf(f,"%d\n",result);fclose(f);}return result;
}
