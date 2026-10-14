#ifndef RALLY_SCENE_HOST_BRIDGE_H
#define RALLY_SCENE_HOST_BRIDGE_H
#include "integration_model.h"
/* Host fixture mapping, NOT a new Golem/VDPlet wire or binding schema. */
typedef struct SceneLayout {
    uint32_t struct_bytes;
    uint16_t root,root_bytes,tick_entry,entry_count;
    uint32_t tick_offset,heading_offset,player_offset,lateral_offset,lap;
    RallyRenderRangeV1 active,position,lateral;
} SceneLayout;
typedef struct SceneProof {
    uint32_t session,tick,success_generation;
    int32_t observed_runtime;
    uint32_t request;
} SceneProof;
typedef struct ScenePresentation {
    uint16_t phase;int16_t steering;uint16_t flags,reserved;
} ScenePresentation;
_Static_assert(sizeof(SceneLayout)==68,"host layout ABI");
_Static_assert(sizeof(SceneProof)==20,"host proof ABI");
_Static_assert(sizeof(ScenePresentation)==8,"host presentation ABI");
int32_t scene_marshal(const vdplet_host_v1 *,const SceneLayout *,const SceneProof *,
                      const ScenePresentation *,RallyRenderStateV1 *);
#endif
