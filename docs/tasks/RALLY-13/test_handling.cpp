#include "road.hpp"
#include "traffic.hpp"
#include <cassert>
#include <cstdio>
int main(){
 for(int sign=-1;sign<=1;sign+=2) {
  rally::Motion a;a.speed=126;a.grip=200;a.cornerAssist=false;
  a.lateralStep(sign*51200);assert(sign*a.lateralVelocity<0);
  rally::Motion b;b.speed=126;b.grip=200;b.cornerAssist=true;
  b.lateralStep(sign*51200);assert(b.lateralVelocity==0);
  rally::Motion c;c.speed=126;c.grip=200;c.cornerAssist=false;c.steering=sign*6;
  c.lateralStep(sign*51200);assert(c.lateralVelocity==0);
  c.grip=25;c.lateralStep(sign*51200);assert(sign*c.lateralVelocity<0);
 }
 rally::Motion straight;straight.cornerAssist=false;straight.speed=126;straight.lateralStep(0);assert(straight.lateralVelocity==0);
 rally::Motion forward;forward.cornerAssist=false;forward.speed=100;
 forward.tick(false,false);assert(forward.position==200 && forward.phase==200);
 rally::Opponent opponent;opponent.speed=100;opponent.tick(10000);assert(opponent.position==200);
 puts("Manual handling: both bend signs, balancing steering, grip saturation, straight and optional assist passed.");
}
