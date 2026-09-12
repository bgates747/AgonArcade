// Offline sizing study; the selected polynomial representation is generated
// by generate_road.cpp. These rejected alternatives never enter the game.
#include "section_road.hpp"
#include <vector>
#include <array>
#include <algorithm>
#include <cstdio>
#include <cmath>
#include <set>
using namespace rally;
int main(){
for(auto t:{&TriOval,&Fuji}){
 SectionRoad r;r.track=t;
 for(int step:{32,16,8,4}){
  std::vector<std::array<int,122>> a(t->length/step);
  int min=999999,max=-999999;unsigned escapes=0;std::set<std::array<int,122>> uniq;
  for(unsigned i=0;i<a.size();++i){r.project(i*step*100,0);for(int y=103;y<=224;++y){int q=r.centerQ8At(y);a[i][y-103]=int(std::round(q/16.));min=std::min(min,q);max=std::max(max,q);}
   uniq.insert(a[i]);for(int y=1;y<122;++y)if(std::abs(a[i][y]-a[i][y-1])>127)++escapes;
  }
  size_t sparse=0;for(const auto &v:uniq){unsigned nodes=1;int y=0;while(y<121){int best=y+1;for(int end=y+2;end<122;++end){bool fits=true;for(int row=y+1;row<end;++row){int error=(v[y]-v[row])*(end-y)+(v[end]-v[y])*(row-y);if(std::abs(error)>end-y){fits=false;break;}}if(!fits)break;best=end;}y=best;++nodes;}sparse+=nodes*3+1;}
  sparse+=a.size()*2;
  double err=0;int wp=0,wy=0;for(int p=0;p<t->length*100;p+=25){r.project(p,0);int i=p/(step*100),f=p%(step*100);for(int y=0;y<122;++y){int v=a[i][y]+(a[(i+1)%a.size()][y]-a[i][y])*f/(step*100);double e=std::abs(v*16-r.centerQ8At(y+103))/256.;if(e>err){err=e;wp=p;wy=y+103;}}}
  printf("%s step%d valuesQ8=%d..%d unique=%zu/%zu dense=%zu delta_dedup=%zu sparse_rows_dedup=%zu temporal_error=%.6f at=%d/%d\n",t->name,step,min,max,uniq.size(),a.size(),a.size()*244,uniq.size()*123+escapes*2+a.size()*2,sparse,err,wp,wy);fflush(stdout);
 }
}
}
