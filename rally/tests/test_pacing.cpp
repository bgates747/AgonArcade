#include "pacing.hpp"
#include "workload.hpp"
#include <assert.h>
#include <stdio.h>
#include <string.h>
#include <initializer_list>

struct Backend {
    uint32_t now=0,replyAt=0;
    uint8_t mailbox=0x5a,pending=0;
    unsigned sent=0;
    bool respond=true;
    uint32_t ticks() { return now++; }
    uint8_t poll() {
        if(respond && sent && rally::tickDue(now,replyAt)) mailbox=pending;
        return mailbox;
    }
    void send(uint8_t token) { pending=token;replyAt=now+8;++sent; }
};
int main() {
    for(const auto *track:{&rally::TriOval,&rally::Fuji}) {
        rally::Motion left,right;left.track=right.track=track;
        rally::Traffic a,b;rally::Road road;road.track=track;road.init();
        uint32_t leftHash=0,rightHash=0;
        for(unsigned pose=0;pose<rally::WorkloadFrames;++pose) {
            rally::workloadPose(pose,left,a,false);rally::workloadPose(pose,right,b,true);
            assert(left.position==right.position && left.cameraOffset()==right.cameraOffset());
            assert(left.carX()==right.carX() && left.view()==right.view());
            assert(!left.mirrored() && right.mirrored());
            leftHash=rally::workloadHash(leftHash,left,a);rightHash=rally::workloadHash(rightHash,right,b);
            rally::Stream original,split;
            road.render(original,left.phase,left.position,left.cameraOffset(),false);
            road.project(right.position,right.phase,right.cameraOffset());road.emit(split,false);
            assert(!original.overflow && !split.overflow && original.size==split.size);
            assert(memcmp(original.data,split.data,original.size)==0);
            for(int i=0;i<rally::TrafficCount;++i)
                assert(rally::Traffic::ahead(a.cars[i].position,left.position,track->length*100)==(160L+i*90L)*100);
        }
        assert(leftHash==rightHash);
    }
    assert(rally::ticksSince(2,UINT32_MAX-3)==6);
    assert(!rally::tickDue(UINT32_MAX-1,2));
    assert(rally::tickDue(2,UINT32_MAX-1));
    Backend backend;rally::PollFence fence;
    assert(fence.wait(backend,30));
    assert(backend.pending==0xa5 && backend.now>=9); // stale mailbox rejected
    assert(fence.wait(backend,30));assert(backend.pending==0x5a);
    for(int i=0;i<300;++i) assert(fence.wait(backend,30));
    backend.now=UINT32_MAX-4;
    assert(fence.wait(backend,30)); // reply deadline wraps
    Backend missing;missing.respond=false;rally::PollFence timeout;
    assert(!timeout.wait(missing,20));assert(missing.sent==1);
    assert(!timeout.wait(missing,20));assert(missing.sent==1); // no token reuse
    Backend wrapping;wrapping.now=UINT32_MAX-4;wrapping.respond=false;
    rally::PollFence wrapTimeout;assert(!wrapTimeout.wait(wrapping,20));
    puts("Poll fence rejects stale replies, alternates tokens, times out and handles clock wrap.");
}
