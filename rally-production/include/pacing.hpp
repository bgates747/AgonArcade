#pragma once
#include <stdint.h>

namespace rally {
constexpr uint32_t ClockHz=120;
constexpr uint32_t FenceTimeout=5*ClockHz;
constexpr uint32_t BenchmarkTicks=20*ClockHz;
inline uint32_t ticksSince(uint32_t now,uint32_t before) { return now-before; }
inline bool tickDue(uint32_t now,uint32_t deadline) {
    return ticksSince(now,deadline)<UINT32_C(0x80000000);
}

// A single outstanding stock GP request. A timeout is terminal: never reuse
// tokens after an undrained request. Startup chooses a token unlike the mailbox.
class PollFence {
    uint8_t token=0;
    bool started=false,failed=false;
public:
    template<class Backend> bool wait(Backend &backend,uint32_t timeout) {
        if(failed) return false;
        token=started?(token==0x5a?0xa5:0x5a):
                      (backend.poll()==0x5a?0xa5:0x5a);
        started=true;
        const uint32_t begin=backend.ticks();
        backend.send(token);
        for(;;) {
            if(ticksSince(backend.ticks(),begin)>=timeout) {
                failed=true;return false;
            }
            if(backend.poll()==token) return true;
        }
    }
};

struct FrameTiming {
    uint32_t start,interval,physics,projection,submit,fence;
    uint32_t geometry,bands;
    uint16_t pose,bandCount;
    uint16_t roadBytes;
    uint8_t cars,mirrored;
};
constexpr unsigned TimingCapacity=1024;
}
