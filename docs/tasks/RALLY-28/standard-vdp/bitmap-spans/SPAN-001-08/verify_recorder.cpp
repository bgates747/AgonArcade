#include "frame_records.hpp"
#include <cassert>
#include <cstdio>
using agon_frame_records::Recorder;
int main(){Recorder r;
assert(r.reset()&&r.begin(0,100)&&r.end(0,120,130)&&r.stop());auto p=r.get(0);assert(p&&p->submitted_us==20&&p->completed_us==30&&p->drain_us==10);
assert(r.reset()&&r.begin(0,0xfffffff0U)&&r.end(0,0xfffffff8U,5)&&r.stop());p=r.get(0);assert(p&&p->submitted_us==8&&p->completed_us==21&&p->drain_us==13);
assert(r.reset()&&!r.end(0,1,2)&&r.fault()&&!r.stop()&&!r.get(0));
assert(r.reset()&&!r.begin(1,0)&&r.fault());
assert(r.reset()&&r.begin(0,0)&&!r.begin(0,1)&&r.fault());
assert(r.reset()&&r.begin(0,0)&&!r.stop()&&r.fault());
assert(r.reset()&&r.begin(0,0)&&r.end(0,1,2)&&r.stop()&&!r.begin(1,3));
assert(r.reset());for(unsigned i=0;i<agon_frame_records::Capacity;++i)assert(r.begin(i,0)&&r.end(i,1,2));assert(!r.begin(agon_frame_records::Capacity,0)&&r.fault());
assert(r.reset()&&r.begin(0,0)&&r.end(0,1,2)&&r.stop()&&!r.get(1));
puts("9 recorder timing/order/overflow scenarios passed");}
