#include "phase.hpp"
#include <cstdio>
int main(){unsigned checks=0;for(unsigned phase=0;phase<8000;++phase)for(unsigned y=104;y<=223;++y){
bool expected=y>=116 && ((800000L/(y-96)+phase)%8000)<4000;
if(span_phase::painted(y,phase)!=expected)return 1;++checks;}
std::printf("%u independently checked phase/row combinations\n",checks);}
