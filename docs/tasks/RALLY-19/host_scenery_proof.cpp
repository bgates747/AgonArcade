// Exhaustive reachable-position proof of the proposed binary32 construction.
// Accepted trackSample/sceneryHeading remain an independently called oracle.
#include "road.hpp"
#include "scenery.hpp"
#include <cmath>
#include <cstdio>
#include <cstdint>
#include <vector>
struct Witness { const char*kind;int32_t position;int tx,ty,estimate,quotient; };
float component(int base,int delta,unsigned fraction) {
    unsigned h=fraction/64,l=fraction%64;
    float product=float(delta)*float(h);
    float biased=product+262144.0f;
    unsigned q=unsigned(biased*(1.0f/256));
    float multiple=float(q)*256.0f;
    unsigned r=unsigned(biased-multiple);
    float high=float(r)*64.0f,low=float(delta)*float(l);
    float correction=std::floor((high+low)*(1.0f/16384));
    float integer=float(q)-1024.0f;
    return float(base)+(integer+correction);
}
int main(){
    puts("{\"scope\":\"Every reachable hundredth-position; binary32 split interpolation and corrected atan ratio versus accepted integer oracle. Host proof only.\",\"tracks\":[");
    unsigned trackIndex=0;
    for(const auto*track:{&rally::TriOval,&rally::Fuji}){
        const char*name=trackIndex++?"fuji":"oval";
        int32_t lap=track->length*100;uint32_t floors=0,naiveDifferent=0,over=0,under=0;
        int minimumMajor=10000;std::vector<Witness>witnesses;
        bool haveNaive=false,haveOver=false,haveUnder=false,haveEqual=false,haveAxis=false;
        for(int32_t position=0;position<lap;++position){
            unsigned index=unsigned(position/6400),local=unsigned(position%6400);
            unsigned fraction=(local/100)*256+(local%100)*256/100;
            if(unsigned(float(local)*2.56f)!=fraction){fprintf(stderr,"fraction mismatch %s %ld\n",name,long(position));return 5;}
            auto&a=track->points[index];auto&b=track->points[(index+1)%track->count];
            int dx=b.tx-a.tx,dy=b.ty-a.ty;
            int tx=int(component(a.tx,dx,fraction)),ty=int(component(a.ty,dy,fraction));
            auto expected=rally::trackSample(position/100*256+(position%100)*256/100,*track);
            if(tx!=expected.tx||ty!=expected.ty){fprintf(stderr,"tangent mismatch %s %ld\n",name,long(position));return 1;}
            int naiveX=a.tx+int(std::floor(float(dx)*float(fraction)*(1.0f/16384)));
            int naiveY=a.ty+int(std::floor(float(dy)*float(fraction)*(1.0f/16384)));
            bool naive=naiveX!=tx||naiveY!=ty;if(naive)++naiveDifferent;
            int ax=tx<0?-tx:tx,ay=ty<0?-ty:ty;
            int major=ax>=ay?ax:ay,minor=ax>=ay?ay:ax;
            if(major<minimumMajor)minimumMajor=major;
            if(major<2048||major>4096){fprintf(stderr,"denominator bound %s %ld\n",name,long(position));return 2;}
            unsigned numerator=unsigned(minor)*256;
            float reciprocal=1.0f/float(major);
            unsigned estimate=unsigned(float(numerator)*reciprocal),q=estimate;
            if(q*unsigned(major)>numerator)--q;
            else if((q+1)*unsigned(major)<=numerator)++q;
            if(q!=numerator/unsigned(major)||q>256){fprintf(stderr,"ratio mismatch %s %ld\n",name,long(position));return 3;}
            int angle=ax>=ay?rally::HeadingAtan[q]:256-rally::HeadingAtan[q];
            if(tx<0)angle=512-angle;if(ty<0)angle=1024-angle;angle&=1023;
            if(angle!=rally::sceneryHeading(expected.tx,expected.ty)){fprintf(stderr,"angle mismatch %s %ld\n",name,long(position));return 4;}
            if(estimate>q)++over;if(estimate<q)++under;
            auto save=[&](const char*kind,bool &had){if(!had){witnesses.push_back({kind,position,tx,ty,int(estimate),int(q)});had=true;}};
            if(naive)save("rounded-product",haveNaive);
            if(estimate>q)save("estimate-too-high",haveOver);
            if(estimate<q)save("estimate-too-low",haveUnder);
            if(ax==ay)save("equal-components",haveEqual);
            if(tx==0||ty==0)save("axis",haveAxis);
            floors+=2;
        }
        if(trackIndex>1)puts(",");
        printf("{\"track\":\"%s\",\"positions\":%ld,\"component_checks\":%lu,\"native_fraction_matches\":true,\"naive_product_mismatches\":%lu,\"estimate_too_high\":%lu,\"estimate_too_low\":%lu,\"minimum_major\":%d,\"pass\":true,\"witnesses\":[",name,long(lap),(unsigned long)floors,(unsigned long)naiveDifferent,(unsigned long)over,(unsigned long)under,minimumMajor);
        for(unsigned i=0;i<witnesses.size();++i){auto&w=witnesses[i];if(i)putchar(',');printf("{\"kind\":\"%s\",\"position\":%ld,\"tx\":%d,\"ty\":%d,\"estimate\":%d,\"quotient\":%d}",w.kind,long(w.position),w.tx,w.ty,w.estimate,w.quotient);}
        printf("]}");
    }
    puts("],\"pass\":true}");return 0;
}
