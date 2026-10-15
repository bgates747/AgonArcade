// Private second translation unit: actual gameplay state advances independently
// of the deterministic scene fixture. No product scheduler/physics change.
#define gameMain shadow_unused_game
#define preserved_product_main shadow_unused_main
#include "workload.hpp"
uint32_t count=0;
extern "C" void shadow_init(){count=0;capacity::setup(0);}
extern "C" void shadow_step(){if(count && !(count%1024))capacity::setup(unsigned(count/1024)%4);capacity::step(unsigned(count)%1024);++count;}
extern "C" void shadow_snapshot(uint32_t *out){capacity::snapshot(0,[&](unsigned,unsigned k,uint32_t v){out[k]=v;});}
