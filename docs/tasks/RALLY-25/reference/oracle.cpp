// Test-only observer of immutable pre-R27 headers. No game changes.
#include "race_traffic.hpp"
#include "lookup_road.hpp"
#include <iostream>
#include <string>
using namespace rally::game;
int main(int argc,char **argv) {
    if(argc<2)return 2;
    const std::string mode=argv[1];
    if(mode=="route") {
        RouteCursor c;unsigned forward=0;
        for(unsigned t=1;t<=1800;++t) {
            forward+=c.tick();
            std::cout<<t<<','<<unsigned(c.record)<<','<<c.remaining<<','<<c.heading<<','<<c.lateral<<','<<forward<<'\n';
        }
    } else if(mode=="sine") {
        for(int h=-32768;h<=32767;++h)std::cout<<routeSine(int16_t(h))<<'\n';
    } else if(mode=="contact") {
        int lap,position,lateral,player,pl;
        while(std::cin>>lap>>position>>lateral>>player>>pl) {
            RaceTraffic traffic;traffic.reset(Policy::Arcade,lap,1,6);
            auto &car=traffic.cars[0];car.active=true;car.position=position;car.lateral=lateral;
            std::cout<<unsigned(traffic.contactStation(player,pl))<<'\n';
        }
    } else if(mode=="spawn") {
        int lap,n,p;std::cin>>lap>>n;
        RaceTraffic traffic;traffic.reset(Policy::Arcade,lap,1,6);
        for(int i=0;i<n;++i) {std::cin>>p;std::cout<<unsigned(traffic.spawn(p))<<',';}
        std::cout<<'\n';
    } else if(mode=="lookup" && argc==4) {
        rally::LookupRoad road;
        road.track=std::string(argv[3])=="Fuji"?&rally::Fuji:&rally::TriOval;
        if(!road.load(argv[2]))return 3;
        int position,q;
        while(std::cin>>position>>q) {
            road.project(position,0);
            std::cout<<road.centerQ8At(96+q)<<'\n';
        }
    } else if(mode=="traffic" && argc==8) {
        const auto policy=std::string(argv[2])=="circuit"?Policy::Circuit:Policy::Arcade;
        const int lap=std::stoi(argv[3]),grid=std::stoi(argv[4]),laps=std::stoi(argv[5]),ticks=std::stoi(argv[6]),speed=std::stoi(argv[7]);
        RaceTraffic traffic;traffic.reset(policy,lap,uint8_t(grid),uint8_t(laps));
        for(int t=1;t<=ticks;++t) {
            const unsigned player=unsigned(t*speed);traffic.tick(player,unsigned(t));
            const auto &p=traffic.pace;
            std::cout<<t<<','<<unsigned(p.record)<<','<<p.remaining<<','<<p.heading<<','<<p.lateral<<','<<traffic.nextSpawn<<','<<unsigned(traffic.rank(player))<<','<<unsigned(traffic.contact(player,0));
            for(const auto &c:traffic.cars)std::cout<<','<<unsigned(c.active)<<','<<c.generation<<','<<unsigned(c.gridOrder)<<','<<c.progress<<','<<c.position<<','<<c.lateral<<','<<c.finish;
            std::cout<<'\n';
        }
    } else return 2;
}
