#pragma once
#include <stdint.h>
namespace defender {
constexpr int World = 2048, Scale = 8, People = 10, Enemies = 18, Shots = 24, Sparks = 32;
enum Key {
    Left = 1,
    Right = 2,
    Up = 4,
    Down = 8,
    Fire = 16,
    Bomb = 32,
    Start = 64,
    Pause = 128,
    Quit = 256,
    Mute = 512
};
enum Sound { Laser = 1, Explosion = 2, Rescue = 4, Damage = 8, Abduction = 16, Blast = 32 };
enum State { Title, Playing, Paused, Over };
enum PersonState { Ground, Falling, Carried, Abducted, Safe, Dead };
struct Person {
    int x, y, vy;
    PersonState state;
};
struct Enemy {
    int x, y, vx, vy, target, kind, cooldown;
    bool alive;
};
struct Shot {
    int x, y, vx, vy, life;
    bool hostile;
};
struct Spark {
    int x, y, vx, vy, life, color;
};
struct Game {
    State state = Title;
    Person people[People]{};
    Enemy enemies[Enemies]{};
    Shot shots[Shots]{};
    Spark sparks[Sparks]{};
    int x = 1024 * Scale, y = 110 * Scale, vx = 0, vy = 0, facing = 1, carrying = -1;
    int lives = 3, bombs = 3, wave = 1, invulnerable = 0, cooldown = 0, frame = 0, banner = 0,
        clearTimer = 0;
    uint32_t score = 0, best = 0;
    uint32_t rng = 1;
    unsigned previous = 0, sounds = 0;
    bool quit = false, muted = false;
    int flash = 0;
    int random(int n);
    void reset();
    void spawnWave();
    void tick(unsigned keys);
    void burst(int px, int py, int color);
    void kill(int index);
    void hurt();
    int alive() const;
    int survivors() const;
};
int wrap(int x);
int delta(int a, int b);
int ground(int x);
inline bool physical(const uint8_t *map, int key) {
    return map[(key - 1) / 8] & (1 << ((key - 1) % 8));
}
inline unsigned decode(const uint8_t *m) {
    return (physical(m, 26) ? Left : 0) | (physical(m, 122) ? Right : 0) |
           (physical(m, 58) ? Up : 0) | (physical(m, 42) ? Down : 0) |
           (physical(m, 99) ? Fire : 0) | (physical(m, 67) ? Bomb : 0) |
           (physical(m, 74) ? Start : 0) | (physical(m, 56) ? Pause : 0) |
           (physical(m, 113) ? Quit : 0) | (physical(m, 102) ? Mute : 0);
}
} // namespace defender
