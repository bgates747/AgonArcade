// Offline RALLY-18 projected screen-line table generator. Host floating-point
// math is deliberate; the emitted data and runtime evaluator are fixed-point.
#include "lookup_format.hpp"
#include <array>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <string>
#include <vector>
using namespace rally;

namespace {
double cross(double x,double y,double tx,double ty) {
    return (-x*ty+y*tx)/(4096.0*CameraHeight);
}
std::array<double,5> coefficients(const TrackDef &track,unsigned i,unsigned k) {
    const TrackPoint &a=track.points[i],&b=track.points[(i+1)%track.count];
    const TrackPoint &c=track.points[(i+k)%track.count],&d=track.points[(i+k+1)%track.count];
    const double vx=b.x-a.x,vy=b.y-a.y,ux=d.x-c.x,uy=d.y-c.y;
    const double ttx=b.tx-a.tx,tty=b.ty-a.ty;
    const double ax=c.x-a.x-ux*k,ay=c.y-a.y-uy*k;
    const double bx=ux-vx,by=uy-vy;
    // Depth in world units is 8000/q. Dividing by the 64-world-unit track
    // interval gives 125/q. Substituting the linear stored track segments and
    // interpolated camera tangent into the reference projection gives the
    // projected screen-line polynomial A+B*t+q*(C+D*t+E*t*t).
    return {160+125*cross(ux,uy,a.tx,a.ty),125*cross(ux,uy,ttx,tty),
            cross(ax,ay,a.tx,a.ty),cross(bx,by,a.tx,a.ty)+cross(ax,ay,ttx,tty),
            cross(bx,by,ttx,tty)};
}
int32_t quantize(double x,unsigned scale,int32_t minimum,int32_t maximum) {
    const double q=std::round(x*scale);
    if(!std::isfinite(q) || q<minimum || q>maximum) {
        std::fprintf(stderr,"coefficient out of range: %.12f x %u\n",x,scale);std::exit(1);
    }
    return int32_t(q);
}
void put16(std::vector<uint8_t> &out,unsigned value) {
    out.push_back(uint8_t(value));out.push_back(uint8_t(value>>8));
}
void put32(std::vector<uint8_t> &out,uint32_t value) {
    put16(out,unsigned(value));put16(out,unsigned(value>>16));
}
void header16(std::vector<uint8_t> &h,unsigned offset,unsigned value) {
    h[offset]=uint8_t(value);h[offset+1]=uint8_t(value>>8);
}
void header32(std::vector<uint8_t> &h,unsigned offset,uint32_t value) {
    header16(h,offset,unsigned(value));header16(h,offset+2,unsigned(value>>16));
}
}

int main(int argc,char **argv) {
    if(argc!=2) {std::fprintf(stderr,"usage: generate_road OUTPUT_DIRECTORY\n");return 2;}
    for(const TrackDef *track:{&TriOval,&Fuji}) {
        std::vector<uint8_t> payload;
        for(unsigned i=0;i<track->count;++i) for(unsigned k=0;k<lookup_format::Lookahead;++k) {
            const auto z=coefficients(*track,i,k);
            put16(payload,unsigned(quantize(z[0],64,-32768,32767)));
            put16(payload,unsigned(quantize(z[1],256,-32768,32767)));
            put32(payload,uint32_t(quantize(z[2],4096,INT32_MIN,INT32_MAX)));
            put16(payload,unsigned(quantize(z[3],4096,-32768,32767)));
            put16(payload,unsigned(quantize(z[4],4096,-32768,32767)));
        }
        if(payload.size()>lookup_format::MaximumPayload) return 1;
        uint32_t hash=UINT32_C(2166136261);
        for(uint8_t b:payload) hash=lookup_format::hashByte(hash,b);
        std::vector<uint8_t> header(lookup_format::HeaderSize,0);
        const char magic[8]={'R','1','8','R','O','A','D',0};
        std::copy(magic,magic+8,header.begin());
        header16(header,8,lookup_format::Version);header16(header,10,header.size());
        header32(header,12,lookup_format::trackIdentity(*track));
        header32(header,16,uint32_t(track->length));header16(header,20,track->count);
        header16(header,22,lookup_format::IntervalWorld);header16(header,24,lookup_format::Lookahead);
        header16(header,26,lookup_format::RecordSize);header[28]=lookup_format::FirstRow;
        header[29]=lookup_format::LastRow;header[30]=Horizon;header[31]=CameraHeight;
        header32(header,32,uint32_t(payload.size()));header32(header,36,hash);
        header32(header,40,1);header32(header,44,64);header32(header,48,256);header32(header,52,4096);
        const std::string name=track==&Fuji?"fuji":"oval";
        std::ofstream out(std::string(argv[1])+"/"+name+".road",std::ios::binary);
        out.write(reinterpret_cast<const char*>(header.data()),header.size());
        out.write(reinterpret_cast<const char*>(payload.data()),payload.size());
        if(!out) return 1;
        std::printf("%s: %u records, %zu payload bytes, %zu disk bytes, track %08x, payload %08x\n",
                    name.c_str(),track->count*lookup_format::Lookahead,payload.size(),header.size()+payload.size(),
                    lookup_format::trackIdentity(*track),hash);
    }
}
