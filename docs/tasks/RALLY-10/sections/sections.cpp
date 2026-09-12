#define main farAuditMain
#include "audit.cpp"
#undef main
#include <set>
int main() {
    Road road;road.init();
    std::set<std::vector<int>> lists;
    std::set<std::pair<std::vector<int>,bool>> templates;
    int minPitch=99,maxPitch=0;
    for(int phase=0;phase<4000;++phase) {
        std::vector<int> list{116};
        for(int y=117;y<=223;++y) if(road.painted(y,phase)!=road.painted(y-1,phase)) list.push_back(y);
        list.push_back(224);lists.insert(list);templates.insert({list,road.painted(116,phase)});
        minPitch=std::min(minPitch,int(list.size()-1));maxPitch=std::max(maxPitch,int(list.size()-1));
    }
    int sumBytes=0;for(const auto &l:lists)sumBytes+=l.size();
    std::printf("half period phase 0..3999 (hundredths): %zu distinct row lists, %zu including first-material boolean, %d..%d pitch bands; %d boundary bytes packed before indexing\n",lists.size(),templates.size(),minPitch,maxPitch,sumBytes);
    for(const TrackDef *track:{&TriOval,&Fuji}) {
        road.track=track;
        int samples=0,maxTotal=0,maxNear=0,maxPitch=0,minTotal=999,minNear=999,allNearFit=0;double sumTotal=0,sumNear=0,sumPitch=0,worstPitch=0;int worstPose=0,worstPhase=0;
        for(int pose=0;pose<64;++pose) {
            int p=int(int64_t(track->length)*100*pose/64);
            road.project(p,0);
            double err[225][225];
            for(int a=104;a<224;++a) for(int b=a+1;b<=224;++b) err[a][b]=error(road,a,b,true);
            auto minSegments=[&](int a,int b) {
                int dp[225];dp[a]=0;
                for(int end=a+1;end<=b;++end) {dp[end]=999;for(int start=a;start<end;++start) if(err[start][end]<=1) dp[end]=std::min(dp[end],dp[start]+1);}
                return dp[b];
            };
            int far=minSegments(104,116);
            for(int phase=0;phase<8000;phase+=500) {
                int near=0,pitch=0,start=116;double localWorst=0;
                for(int b=117;b<=224;++b) {
                    if(b<224 && road.painted(b,phase)==road.painted(start,phase))continue;
                    ++pitch;near+=minSegments(start,b);localWorst=std::max(localWorst,err[start][b]);start=b;
                }
                ++samples;sumNear+=near;sumTotal+=near+far;sumPitch+=pitch;allNearFit+=localWorst<=1;
                maxTotal=std::max(maxTotal,near+far);maxNear=std::max(maxNear,near);maxPitch=std::max(maxPitch,pitch);minNear=std::min(minNear,near);minTotal=std::min(minTotal,near+far);
                if(localWorst>worstPitch){worstPitch=localWorst;worstPose=pose;worstPhase=phase;}
            }
        }
        std::printf("%s 64 lap poses x16 phases=%d: pitch bands avg%.2f max%d; marked <=1px segments avg%.2f min%d max%d; total incl far avg%.2f min%d max%d; onechord per marked pitch worst error%.3fpx @pose%d phase%d; all marked sections fit1px %.2f%%\n",track->name,samples,sumPitch/samples,maxPitch,sumNear/samples,minNear,maxNear,sumTotal/samples,minTotal,maxTotal,worstPitch,worstPose,worstPhase,100.*allNearFit/samples);
    }
}
