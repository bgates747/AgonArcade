#include "game.hpp"
#include <assert.h>
#include <initializer_list>
#include <stdio.h>
using namespace defender;
void quiet(Game &g) {
    g.reset();
    for (auto &e : g.enemies)
        e.alive = false;
    g.enemies[Enemies - 1] = {0, 60 * Scale, 0, 0, -1, 0, 10000, true};
}
int main() {
    assert(wrap(-1) == World * Scale - 1);
    assert(delta(2, World * Scale - 2) == 4);
    assert(delta(World * Scale - 2, 2) == -4);
    uint8_t map[16] = {};
    for (int k : {26, 122, 58, 42, 99, 67, 74, 56, 113, 102})
        map[(k - 1) / 8] |= 1 << ((k - 1) % 8);
    assert(decode(map) == 1023);
    Game g;
    assert(g.state == Title);
    g.tick(Start);
    assert(g.state == Playing);
    quiet(g);
    int old = g.x;
    for (int i = 0; i < 30; ++i)
        g.tick(Right);
    assert(delta(g.x, old) > 0 && g.vx == 40);
    int speed = g.vx;
    g.tick(0);
    assert(g.vx > 0 && g.vx < speed);
    for (int i = 0; i < 40; ++i)
        g.tick(Left);
    assert(g.vx < 0 && g.facing == -1);
    g.x = World * Scale - 1;
    g.vx = 40;
    g.tick(Right);
    assert(g.x < 50);
    g.tick(Pause);
    old = g.x;
    g.tick(Right);
    assert(g.x == old && g.state == Paused);
    g.tick(0);
    g.tick(Pause);
    assert(g.state == Playing);
    quiet(g);
    g.x = 100 * Scale;
    g.y = 100 * Scale;
    g.enemies[0] = {125 * Scale, 100 * Scale, 0, 0, -1, 0, 100, true};
    g.tick(Fire);
    g.tick(Fire);
    assert(!g.enemies[0].alive && g.score >= 150);
    quiet(g);
    g.x = 100 * Scale;
    g.enemies[0] = {110 * Scale, 100 * Scale, 0, 0, -1, 0, 100, true};
    int bombs = g.bombs;
    g.previous = 0;
    g.tick(Bomb);
    assert(g.bombs == bombs - 1 && !g.enemies[0].alive);
    g.tick(Bomb);
    assert(g.bombs == bombs - 1);
    quiet(g);
    g.x = 100 * Scale;
    g.y = 100 * Scale;
    g.people[0] = {g.x, g.y + 5 * Scale, 0, Falling};
    g.tick(0);
    assert(g.carrying == 0 && g.people[0].state == Carried);
    g.x = 256 * Scale;
    g.y = 190 * Scale;
    g.vx = 0;
    g.tick(0);
    assert(g.carrying == -1 && g.people[0].state == Safe && g.score == 600);
    quiet(g);
    g.people[0] = {200 * Scale, 150 * Scale, 0, Abducted};
    g.enemies[0] = {200 * Scale, 141 * Scale, 0, -6, 0, 0, 100, true};
    g.kill(0);
    assert(g.people[0].state == Falling && !g.enemies[0].alive);
    quiet(g);
    g.people[0] = {200 * Scale, 50 * Scale, 0, Abducted};
    g.enemies[0] = {200 * Scale, 42 * Scale, 0, -6, 0, 0, 100, true};
    g.tick(0);
    assert(g.people[0].state == Dead && g.enemies[0].kind == 1);
    quiet(g);
    g.invulnerable = 0;
    g.carrying = 0;
    g.people[0].state = Carried;
    g.hurt();
    assert(g.lives == 2 && g.carrying == -1 && g.people[0].state == Falling);
    g.hurt();
    assert(g.lives == 2);
    quiet(g);
    for (auto &e : g.enemies)
        e.alive = false;
    for (int i = 0; i < 125; ++i)
        g.tick(0);
    assert(g.wave == 2 && g.alive() == 10);
    // Long randomized runs exercise wrapped motion, projectiles, captures, resets,
    // and bounded arrays under ASan/UBSan; explicitly check the state invariants.
    for (int run = 0; run < 8; ++run) {
        g.reset();
        for (int i = 0; i < 50000; ++i) {
            unsigned keys = unsigned(g.random(64));
            g.tick(keys);
            if (g.state == Over)
                g.reset();
            assert(g.x >= 0 && g.x < World * Scale && g.y >= 46 * Scale && g.y <= 195 * Scale);
            assert(g.lives >= 0 && g.lives <= 3 && g.bombs >= 0 && g.bombs <= 3);
            int carried = 0;
            for (int p = 0; p < People; ++p) {
                assert(g.people[p].x >= 0 && g.people[p].x < World * Scale);
                if (g.people[p].state == Carried) {
                    ++carried;
                    assert(g.carrying == p);
                }
            }
            assert(carried <= 1);
            assert((g.carrying >= 0) == (carried == 1));
            for (const auto &e : g.enemies) {
                assert(e.x >= 0 && e.x < World * Scale);
                assert(e.target >= -1 && e.target < People);
            }
        }
    }
    puts("All gameplay checks passed; 400,000 randomized simulation frames under ASan/UBSan.");
}
