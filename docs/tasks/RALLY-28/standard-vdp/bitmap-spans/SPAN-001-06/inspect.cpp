#include "phase.hpp"
extern "C" bool lookup_phase(unsigned row,unsigned phase){return span_phase::painted(row,phase);}
extern "C" bool original_phase(unsigned row,unsigned phase){return row>=116 && ((800000L/(row-96)+phase)%8000)<4000;}
