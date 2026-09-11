#include "game.hpp"
namespace defender {
namespace {
int absval(int v) {
    return v < 0 ? -v : v;
}
int clamp(int v, int lo, int hi) {
    return v < lo ? lo : v > hi ? hi : v;
}
} // namespace
int wrap(int v) {
    v %= World * Scale;
    return v < 0 ? v + World * Scale : v;
}
int delta(int a, int b) {
    int d = wrap(a - b);
    return d > World * Scale / 2 ? d - World * Scale : d;
}
int ground(int px) {
    int t = (px % 256 + 256) % 256;
    return 219 - (t < 128 ? t : 256 - t) / 9;
}
int Game::random(int n) {
    rng = rng * 1664525UL + 1013904223UL;
    return int((rng >> 16) % unsigned(n));
}
void Game::reset() {
    state = Playing;
    x = 1024 * Scale;
    y = 110 * Scale;
    vx = vy = 0;
    facing = 1;
    carrying = -1;
    lives = 3;
    bombs = 3;
    wave = 1;
    score = 0;
    frame = 0;
    invulnerable = 90;
    cooldown = 0;
    clearTimer = 0;
    flash = 0;
    for (auto &s : shots)
        s.life = 0;
    for (auto &s : sparks)
        s.life = 0;
    spawnWave();
}
void Game::spawnWave() {
    banner = 100;
    clearTimer = 0;
    for (int i = 0; i < People; ++i)
        people[i] = {wrap((120 + i * 190) * Scale), 198 * Scale, 0, Ground};
    for (int i = 0; i < Enemies; ++i) {
        auto &e = enemies[i];
        e = {wrap(x + (230 + i * 117) * Scale),
             (50 + random(65)) * Scale,
             0,
             0,
             -1,
             0,
             100 + random(140),
             i < 6 + wave * 2};
    }
    carrying = -1;
}
void Game::burst(int px, int py, int color) {
    for (int j = 0; j < 9; ++j) {
        int slot = -1;
        for (int i = 0; i < Sparks; ++i)
            if (sparks[i].life == 0) {
                slot = i;
                break;
            }
        if (slot < 0)
            slot = random(Sparks);
        sparks[slot] = {px, py, random(41) - 20, random(41) - 20, 12 + random(14), color};
    }
}
void Game::kill(int i) {
    auto &e = enemies[i];
    if (!e.alive)
        return;
    if (e.target >= 0 && people[e.target].state == Abducted) {
        auto &p = people[e.target];
        p.state = Falling;
        p.vy = 0;
    }
    e.alive = false;
    score += e.kind ? 250 : 150;
    burst(e.x, e.y, e.kind ? 3 : 1);
    sounds |= Explosion;
}
void Game::hurt() {
    if (invulnerable)
        return;
    sounds |= Damage;
    burst(x, y, 2);
    --lives;
    invulnerable = 100;
    vx = vy = 0;
    if (carrying >= 0) {
        people[carrying].state = Falling;
        people[carrying].vy = 0;
        carrying = -1;
    }
    if (lives <= 0)
        state = Over;
}
int Game::alive() const {
    int n = 0;
    for (const auto &e : enemies)
        n += e.alive;
    return n;
}
int Game::survivors() const {
    int n = 0;
    for (const auto &p : people)
        n += p.state != Dead;
    return n;
}
void Game::tick(unsigned keys) {
    sounds = 0;
    unsigned pressed = keys & ~previous;
    previous = keys;
    if (pressed & Quit) {
        quit = true;
        return;
    }
    if (pressed & Mute)
        muted = !muted;
    if (state == Title || state == Over) {
        if (pressed & (Start | Fire))
            reset();
        return;
    }
    if (pressed & Pause)
        state = state == Paused ? Playing : Paused;
    if (state != Playing)
        return;
    frame = (frame + 1) % 30000;
    if (banner)
        --banner;
    if (flash)
        --flash;
    if (invulnerable)
        --invulnerable;
    if (cooldown)
        --cooldown;
    if (keys & Left) {
        vx -= 3;
        facing = -1;
    }
    if (keys & Right) {
        vx += 3;
        facing = 1;
    }
    if (!(keys & (Left | Right)))
        vx = vx * 31 / 32;
    if (keys & Up)
        vy -= 3;
    if (keys & Down)
        vy += 3;
    if (!(keys & (Up | Down)))
        vy = vy * 7 / 8;
    vx = clamp(vx, -40, 40);
    vy = clamp(vy, -24, 24);
    x = wrap(x + vx);
    y = clamp(y + vy, 46 * Scale, 195 * Scale);
    if ((keys & Fire) && !cooldown) {
        for (auto &s : shots)
            if (!s.life) {
                s = {wrap(x + facing * 12 * Scale), y, facing * 100 + vx, 0, 24, false};
                cooldown = 5;
                sounds |= Laser;
                break;
            }
    }
    if ((pressed & Bomb) && bombs) {
        --bombs;
        flash = 8;
        sounds |= Blast;
        for (int i = 0; i < Enemies; ++i)
            if (enemies[i].alive && absval(delta(enemies[i].x, x)) < 165 * Scale)
                kill(i);
        for (auto &s : shots)
            if (s.hostile)
                s.life = 0;
    }
    for (int i = 0; i < Enemies; ++i) {
        auto &e = enemies[i];
        if (!e.alive)
            continue;
        if (e.kind) {
            e.vx = clamp(e.vx + (delta(x, e.x) > 0 ? 2 : -2), -27, 27);
            e.vy = clamp(e.vy + (y > e.y ? 2 : -2), -18, 18);
        } else {
            if (e.target < 0 || people[e.target].state == Dead || people[e.target].state == Safe ||
                people[e.target].state == Carried || people[e.target].state == Falling) {
                e.target = -1;
                int distance = World * Scale;
                for (int p = 0; p < People; ++p)
                    if (people[p].state == Ground) {
                        bool claimed = false;
                        for (int j = 0; j < Enemies; ++j)
                            if (j != i && enemies[j].alive && enemies[j].target == p)
                                claimed = true;
                        int d = absval(delta(people[p].x, e.x));
                        if (!claimed && d < distance) {
                            distance = d;
                            e.target = p;
                        }
                    }
            }
            if (e.target >= 0) {
                auto &p = people[e.target];
                if (p.state == Abducted) {
                    e.vx = 0;
                    e.vy = -6;
                    p.x = e.x;
                    p.y = e.y + 9 * Scale;
                    if (e.y < 43 * Scale) {
                        p.state = Dead;
                        e.target = -1;
                        e.kind = 1;
                        sounds |= Abduction;
                        burst(e.x, e.y, 3);
                    }
                } else {
                    int d = delta(p.x, e.x);
                    e.vx = clamp(d, -12, 12);
                    e.vy = absval(d) < 12 * Scale ? 4 : 0;
                    if (e.y >= 186 * Scale && absval(d) < 10 * Scale) {
                        p.state = Abducted;
                        sounds |= Abduction;
                    }
                }
            } else {
                e.vx = delta(x, e.x) > 0 ? 10 : -10;
                e.vy = y > e.y ? 3 : -3;
            }
        }
        e.x = wrap(e.x + e.vx);
        e.y = clamp(e.y + e.vy, 40 * Scale, 190 * Scale);
        if (--e.cooldown <= 0) {
            e.cooldown = 100 + random(100);
            int dx = delta(x, e.x), dy = y - e.y;
            if (absval(dx) < 200 * Scale) {
                int len = absval(dx) + absval(dy);
                if (len < 1)
                    len = 1;
                for (auto &s : shots)
                    if (!s.life) {
                        s = {e.x, e.y, dx * 20 / len, dy * 20 / len, 100, true};
                        break;
                    }
            }
        }
        if (absval(delta(x, e.x)) < 12 * Scale && absval(y - e.y) < 9 * Scale)
            hurt();
    }
    for (auto &s : shots)
        if (s.life) {
            int oldx = s.x;
            s.x = wrap(s.x + s.vx);
            s.y += s.vy;
            --s.life;
            if (s.y < 40 * Scale || s.y > 204 * Scale) {
                s.life = 0;
                continue;
            }
            if (s.hostile) {
                if (absval(delta(x, s.x)) < 10 * Scale && absval(y - s.y) < 6 * Scale) {
                    s.life = 0;
                    hurt();
                }
            } else
                for (int i = 0; i < Enemies; ++i) {
                    const auto &e = enemies[i];
                    int d = delta(e.x, oldx);
                    if (e.alive && absval(e.y - s.y) < 9 * Scale &&
                        ((s.vx > 0 && d >= -8 * Scale && d <= s.vx + 8 * Scale) ||
                         (s.vx < 0 && d <= 8 * Scale && d >= s.vx - 8 * Scale))) {
                        kill(i);
                        s.life = 0;
                        break;
                    }
                }
        }
    for (int i = 0; i < People; ++i) {
        auto &p = people[i];
        if (p.state == Falling) {
            p.vy = clamp(p.vy + 1, 0, 18);
            p.y += p.vy;
            if (p.y >= 198 * Scale) {
                if (p.vy > 12) {
                    p.state = Dead;
                    burst(p.x, p.y, 3);
                } else
                    p.state = Ground;
                p.y = 198 * Scale;
            }
        }
        if ((p.state == Ground || p.state == Falling) && carrying < 0 &&
            absval(delta(p.x, x)) < 12 * Scale && absval(p.y - y) < 15 * Scale) {
            p.state = Carried;
            carrying = i;
            sounds |= Rescue;
            score += 100;
        }
        if (p.state == Carried) {
            p.x = x;
            p.y = y + 10 * Scale;
            int pad = (x / Scale + 128) % 256 - 128;
            if (absval(pad) < 21 && y >= 183 * Scale && absval(vx) < 18) {
                p.state = Safe;
                carrying = -1;
                score += 500;
                sounds |= Rescue;
                burst(x, y, 0);
            }
        }
    }
    for (auto &p : sparks)
        if (p.life) {
            --p.life;
            p.x = wrap(p.x + p.vx);
            p.y += p.vy;
            p.vy += 1;
        }
    if (!alive() && state == Playing) {
        if (!clearTimer)
            clearTimer = 125;
        if (--clearTimer == 0) {
            score += unsigned(survivors() * 100);
            ++wave;
            bombs = clamp(bombs + 1, 0, 3);
            spawnWave();
        }
    }
    if (score > best)
        best = score;
}
} // namespace defender
