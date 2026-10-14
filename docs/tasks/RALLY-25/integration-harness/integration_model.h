#ifndef RALLY_INTEGRATION_MODEL_H
#define RALLY_INTEGRATION_MODEL_H
/* Rally-owned host model of accepted glue; not a compiler export or SDK ABI. */
#include "rally_render.h"

enum { MODEL_INIT, MODEL_TICK, MODEL_RENDER, MODEL_RESET, MODEL_STOP, MODEL_ENTRIES };
typedef struct ModelMap {
    RallyRenderRangeV1 root,argument,completion;
    RallyRenderBindingsV1 bindings;
    uint16_t entries[MODEL_ENTRIES],entry_count,globals_bytes;
    uint8_t descriptors[64];
} ModelMap;
typedef struct ModelModule {
    RallyRenderContextV1 renderer;
    ModelMap map;
} ModelModule;
typedef struct ModelObservation {
    uint32_t before_generation,session,request,tick;
    uint16_t entry;
    int32_t runtime_result;
    int attempted;
} ModelObservation;
/* Synthetic copy-failure seam; not a proposed SDK callback. */
typedef int32_t (*ModelCopy)(void *,uint8_t *,const void *,uint32_t);
int32_t model_dispatch(const vdplet_host_v1 *,ModelModule *,uint16_t,
                       const RallyRenderStateV1 *,uint16_t,ModelCopy,void *);
int32_t model_clear_ready(const vdplet_host_v1 *,const ModelMap *);
int model_can_draw(const ModelMap *,const uint8_t *,uint32_t,
                   const RallyRenderCompletionV1 *,const ModelObservation *);
uint16_t model_u16(const uint8_t *);
uint32_t model_u32(const uint8_t *);
void model_put16(uint8_t *,uint16_t);
void model_put32(uint8_t *,uint32_t);
void model_init_root(uint8_t *,const ModelMap *,uint32_t);
#endif
