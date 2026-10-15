// Compile to eZ80 assembly/IR only. No entry point or executable is produced.
#include "lookup_direct.hpp"
#include "direct_road.hpp"
extern "C" {
extern const unsigned r28_layout[]={sizeof(rally::LookupRoad),sizeof(rally::DirectRoad),
    sizeof(rally::BandOffsets),sizeof(rally::BandEnds),sizeof(rally::section_phase::PhaseIndex),
    sizeof(rally::section_phase::Offsets),sizeof(rally::section_phase::Rows),
    sizeof(rally::section_phase::DepthQ8),sizeof(rally::SectionRoad)};
void r28_project(rally::LookupRoad *road,int32_t position,int32_t phase) {
    road->project(position,phase,0);
}
int r28_center(rally::LookupRoad *road,int y){return road->centerAt(y);}
void r28_emit(rally::r28::DirectLookup *road,rally::Stream *out,
              void(*send)(const uint8_t*,unsigned)){road->emitTo(*out,send);}
void r28_live_project(rally::SectionRoad *road,int32_t position,int32_t phase) {
    road->project(position,phase,0);
}
void r28_live_emit(rally::r28::DirectLiveSections *road,rally::Stream *out,
                   void(*send)(const uint8_t*,unsigned)){road->emitTo(*out,send);}
}
