#pragma once
namespace capacity {
inline uint32_t sceneProgress=0;
void setupScene(){
selected=&rally::Fuji;
    rules=Rules{};motion=rally::Motion{};motion.track=selected;motion.position=selected->length*100-6800;
    road.track=selected;road.init();raceTraffic.reset(Policy::Circuit,selected->length*100,7,2);
    sceneProgress=0;loadCars();loadFont();loadSigns();engine.start(send);
}
void advanceScene(){
        // Exact R27-05 deterministic full-scene motion/traffic schedule: the
        // wire census is separate from actual-player physics capacity.
        for(unsigned t=0;t<4;++t) {
            const auto &pace=raceTraffic.pace;const unsigned k=pace.remaining?pace.record:(pace.record+1)%6;
            motion.speed=Route[k].speed;motion.lateral=motion.lateralVelocity=motion.steering=0;
            const int32_t advance=motion.speed*rally::WorldSpeedMultiplier;
            motion.position=(motion.position+advance)%(selected->length*100);motion.phase=(motion.phase+advance)%8000;
            sceneProgress+=advance;raceTraffic.tick(sceneProgress,rules.phaseTicks+1);rules.tick(0);
            if(sceneProgress>=uint32_t(selected->length*100)) {sceneProgress-=selected->length*100;
                for(auto &c:raceTraffic.cars){c.progress=c.position;c.finish=0;}}
        }
        raceTraffic.view(traffic,motion.position);
}
template<class Stage> void drawScene(Stage stage){
        stage("audio");engine.update(motion.speed,send);
        stage("scenery");drawScenery();stage("road");road.emitTo(stream,send);finishLine();
        stage("viewport");viewport(stream,0,88,319,223);flush();stage("traffic_signs");drawTraffic();
        stage("player");drawPlayer();stage("viewport");viewport(stream,0,0,319,239);flush();
        stage("panel");drawPanel();stage("hud");drawHud(4);stage("bottom");bottom();stage("swap");vdp_swap();
}
}
