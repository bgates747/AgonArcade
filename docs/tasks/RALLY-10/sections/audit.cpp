#include "road.hpp"
#include <algorithm>
#include <cmath>
#include <cstdio>
#include <vector>
using namespace rally;
// Screen-space interval endpoint displacement; absent-to-present costs the
// visible interval width, rather than its arbitrary empty-interval position.
double clipError(double c,double approx,int y) {
    double w=(y-Horizon)*double(KerbOuterWidth)/CameraHeight;
    double l=std::clamp(c-w,0.,320.),r=std::clamp(c+w,0.,320.);
    double a=std::clamp(approx-w,0.,320.),b=std::clamp(approx+w,0.,320.);
    if(r<=l && b<=a) return 0;
    if(r<=l) return b-a;
    if(b<=a) return r-l;
    return std::max(std::abs(l-a),std::abs(r-b));
}
double error(const Road &road,int a,int b,bool clipped) {
    double worst=0;
    for(int y=a+1;y<b;++y) {
        double c=road.centers[y]/256.;
        double approx=(road.centers[a]+double(road.centers[b]-road.centers[a])*(y-a)/(b-a))/256.;
        worst=std::max(worst,clipped?clipError(c,approx,y):std::abs(c-approx));
    }
    return worst;
}
int main() {
    Road road;road.init();
    for(const TrackDef *track:{&TriOval,&Fuji}) {
        road.track=track;
        for(int camera:{0,-100*256,100*256}) {
            double worst1=0,worst2=0,raw1=0,raw2=0;int worstpos=0,pass1=0,pass2=0,pass2two=0,pass2four=0,maxsegments=0;double sumsegments=0;
            for(int p=0;p<track->length;++p) {
                road.project(p*100,0,camera);
                double e1=error(road,104,116,true),best=1e9,rawbest=1e9;
                for(int split=105;split<116;++split) {
                    best=std::min(best,std::max(error(road,104,split,true),error(road,split,116,true)));
                    rawbest=std::min(rawbest,std::max(error(road,104,split,false),error(road,split,116,false)));
                }
                if(best>worst2){worst2=best;worstpos=p;}
                worst1=std::max(worst1,e1);raw1=std::max(raw1,error(road,104,116,false));raw2=std::max(raw2,rawbest);
                pass1+=e1<=1;pass2+=best<=1;pass2two+=best<=2;pass2four+=best<=4;
                int dp[117];dp[104]=0;
                for(int b=105;b<=116;++b) {dp[b]=999;for(int a=104;a<b;++a) if(error(road,a,b,true)<=1) dp[b]=std::min(dp[b],dp[a]+1);}
                maxsegments=std::max(maxsegments,dp[116]);sumsegments+=dp[116];
            }
            std::printf("%s camera=%d, %d 1-world-unit poses: one worst clipped %.3f raw %.3f, two best-split worst clipped %.3f raw %.3f @position %d; <=1px one %.2f%% two %.2f%%; two<=2px %.2f%% <=4px %.2f%%; <=1px far chords max%d avg%.2f\n",track->name,camera/256,track->length,worst1,raw1,worst2,raw2,worstpos,100.*pass1/track->length,100.*pass2/track->length,100.*pass2two/track->length,100.*pass2four/track->length,maxsegments,sumsegments/track->length);
        }
    }
}
