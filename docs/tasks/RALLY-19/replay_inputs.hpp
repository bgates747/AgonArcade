// Deterministic test-only held-key source. Does not alter the shipped frontend.
// Each40-second cycle covers64 frozen stress poses then ordinary input/physics.
void replayKey(unsigned code){heldKeys[(code-1)/8]|=uint8_t(1u<<((code-1)%8));}
bool replayInputs(unsigned frame){
    for(auto&value:heldKeys)value=0;
    unsigned phase=frame%1200;
    if(phase<64){
        rally::r18::pose(phase,motion,traffic);
        motion.tick(false,false);traffic.tick(motion.track->length*100);
        demoMode=false;autosteer=false;return true;
    }
    if(phase==64){demoMode=true;demoInputArmed=false;autosteer=false;}
    // First300 frames exercise demo assistance; then a held UP key takes over.
    // Subsequent held turns, braking, grip changes and assistance transitions
    // all pass through the byte-identical accepted input/physics body.
    if(phase>=360){
        if(phase%300<230)replayKey(58);else replayKey(42);
        unsigned turn=phase%240;
        if(turn<70)replayKey(26);else if(turn>=120&&turn<190)replayKey(122);
        if(phase>=600&&phase<640)replayKey(24);
        if(phase>=800&&phase<860)replayKey(94);
        autosteer=phase>=900;
    }
    return false;
}
