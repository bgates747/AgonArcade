// Independent current-game oracle; never links native module code.
#include "game_scene.hpp"
#include "hud.hpp"
#include "lookup_road.hpp"
#include "signs.hpp"
#include <cassert>
#include <fstream>
#include <iostream>
#include <vector>
using namespace rally;
using namespace rally::game;
using Bytes = std::vector<uint8_t>;
static unsigned u16(const uint8_t *p) { return p[0] | unsigned(p[1]) << 8; }
static uint32_t u32(const uint8_t *p) { return u16(p) | uint32_t(u16(p + 2)) << 16; }
static void append(Bytes &b, Stream &s) {
    assert(!s.overflow);
    b.insert(b.end(), s.data, s.data + s.size);
    s.size = 0;
}
static void affine(Stream &s, int id) {
    s.byte(23);
    s.byte(0);
    s.byte(150);
    s.byte(1);
    s.word(id);
}
static void bitmap(Stream &s, int b, int m, int x, int y) {
    s.byte(23);
    s.byte(27);
    s.byte(0);
    s.byte(b);
    affine(s, m);
    s.byte(23);
    s.byte(27);
    s.byte(3);
    s.word(x);
    s.word(y);
}
static void matrix(Stream &s, int id, int xx, int scale, int tr) {
    section::buffered(s, id, 32);
    s.byte(0);
    section::buffered(s, id, 32);
    s.byte(11);
    s.byte(200);
    s.word(xx);
    s.word(0);
    s.word(tr);
    s.word(0);
    s.word(scale);
    s.word(0);
}
static void terminate(Stream &s) { section::buffered(s, 65535, 7); }
// Literal RALLY-15 coefficient/template reference: generic row-major multiply.
static void direct(Stream &s, int ct, int cb, int yt, int yb, bool marked) {
    const float co[40] = {0, 0, 1.f / 50, 0, -96.f / 50, -1, 1, 0, 0, 0, 0, 0, -1.f / 50, 1.f / 50,
                          0, 1, 0,        0, 0,          0,  0, 0, 0, 0, 0, 0, 0,         -1,
                          1, 0, 0,        0, 0,          0,  0, 0, 0, 1, 0, 0};
    float p[5] = {float(ct), float(cb), float(yt), float(yb), 1}, m[8] = {};
    for (int r = 0; r < 8; ++r)
        for (int k = 0; k < 5; ++k)
            m[r] += co[r * 5 + k] * p[k];
    const int edges[5][2] = {{-106, 106}, {-90, 90}, {-86, -84}, {84, 86}, {-2, 2}};
    for (int i = 0; i < (marked ? 5 : 4); ++i) {
        s.color(i == 0 ? (marked ? 9 : 15) : i == 1 ? 8 : marked ? 11 : 15);
        for (int v = 0; v < 2; ++v)
            for (int e = 0; e < 2; ++e) {
                float p2[4] = {float(edges[i][e]), float(v), float(edges[i][e] * v), 1};
                float result[2] = {};
                for (int row = 0; row < 2; ++row)
                    for (int k = 0; k < 4; ++k)
                        result[row] += m[row * 4 + k] * p2[k];
                assert(result[0] > -32768 && result[0] < 32768);
                s.plot(v ? 85 : 4, int(result[0]), int(result[1]));
            }
    }
}
static void size(unsigned n) {
    uint8_t p[4] = {uint8_t(n), uint8_t(n >> 8), uint8_t(n >> 16), uint8_t(n >> 24)};
    std::cout.write((char *)p, 4);
}
int main(int argc, char **argv) {
    assert(argc == 4);
    const auto *track = std::string(argv[2]) == "fuji" ? &Fuji : &TriOval;
    LookupRoad road;
    road.track = track;
    assert(road.load((std::string(argv[1]) + "/" + argv[2] + ".road").c_str()));
    bool native = std::string(argv[3]) == "B";
    uint8_t state[112];
    while (std::cin.read((char *)state, 112)) {
        Motion motion;
        motion.track = track;
        motion.position = int32_t(u32(state + 20));
        motion.phase = u16(state + 24);
        motion.steering = int16_t(u16(state + 26));
        motion.lateral = int32_t(u32(state + 28));
        RaceTraffic routes;
        Traffic traffic;
        for (unsigned i = 0; i < 6; ++i) {
            auto *p = state + 40 + 12 * i;
            traffic.cars[i].position = p[10] ? int32_t(u32(p)) : motion.position;
            traffic.cars[i].lane = int32_t(u32(p + 4)) / 256;
            routes.cars[i].cursor.heading = int16_t(u16(p + 8));
        }
        SceneryHistory history;
        SceneState scene{};
        prepareGameScene(motion, traffic, routes, road, history, scene, u16(state + 32) & 4);
        if (!(u16(state + 32) & 1))
            scene.cars = 0;
        Billboards signs;
        signs.prepare(motion, road);
        Stream s;
        Bytes outputs[3];
        if (native) {
            s.rect(0, 104, 319, 223, 2);
            append(outputs[0], s);
            for (unsigned i = 0; i < road.bands; ++i) {
                direct(s, sectionCentrePixel(road.centersQ8[i]),
                       sectionCentrePixel(road.centersQ8[i + 1]), road.rows[i], road.rows[i + 1],
                       road.materials[i]);
                append(outputs[0], s);
            }
            s.rect(0, 224, 319, 239, 0);
        } else
            road.emit(s, false);
        // These two visual blocks reproduce current main.cpp, not the candidate.
        int distance = Traffic::ahead(0, motion.position, track->length * 100) / 100;
        if (distance >= 64 && distance <= 1000) {
            int y = Horizon + 8000 / distance;
            if (y >= RoadTop && y <= Bottom) {
                int height = (y - Horizon) / 16;
                if (height < 1)
                    height = 1;
                for (int row = 0; row < 2; ++row) {
                    int yy = y + row * height;
                    if (yy > 223)
                        break;
                    int centre = road.centerAt(yy), half = (yy - Horizon) * 90 / 50;
                    for (int x = 0; x < 12; ++x) {
                        int bottom = yy + height - 1;
                        if (bottom > 223)
                            bottom = 223;
                        s.rect(centre - half + half * 2 * x / 12, yy,
                               centre - half + half * 2 * (x + 1) / 12 - 1, bottom,
                               ((x + row) & 1) ? 15 : 0);
                    }
                }
            }
        }
        terminate(s);
        append(outputs[0], s);
        unsigned car = 0, sign = 0;
        while (car < scene.cars || sign < signs.count) {
            if (sign < signs.count &&
                (car == scene.cars || signs.visible[sign].scale <= scene.traffic[car].scale)) {
                auto &p = signs.visible[sign++];
                viewport(s, 0, RoadTop, 319, 223);
                matrix(s, SignMatrix, p.scale, p.scale, 0);
                bitmap(s, p.bitmap, SignMatrix, p.x, p.y);
                viewport(s, 0, (u16(state + 32) & 2) ? 88 : 24, 319, 223);
            } else {
                auto &p = scene.traffic[car++];
                matrix(s, p.matrix, p.xx, p.scale, p.translation);
                bitmap(s, p.bitmap, p.matrix, p.x, p.y);
            }
        }
        affine(s, 65535);
        terminate(s);
        append(outputs[1], s);
        unsigned remaining = u16(state + 34), inv = u16(state + 36);
        if (remaining) {
            int age = 150 - remaining, centre = scene.playerCentre, y = 193;
            const int dx[] = {0, 7, 10, 7, 0, -7, -10, -7}, dy[] = {-10, -7, 0, 7, 10, 7, 0, -7};
            int radius = 8 + (age < 60 ? age / 3 : 20 - (age - 60) / 5);
            if (radius < 4)
                radius = 4;
            for (unsigned i = 0; i < 8; ++i) {
                int x = centre + dx[i] * radius / 10, yy = y + dy[i] * radius / 10,
                    size = 3 + (int(i) + age / 8) % 6;
                s.rect(x - size, yy - size, x + size, yy + size,
                       (i + unsigned(age / 6)) % 3 == 0 ? 15
                       : (i & 1)                        ? 11
                                                        : 9);
            }
            s.rect(centre - 6, y - 6, centre + 6, y + 6, 15);
        } else if (!inv || !((inv / 10) & 1)) {
            bitmap(s, scene.playerBitmap, scene.playerMirror ? 63984 : 65535, scene.playerX,
                   r18::PlayerDrawY);
            affine(s, 65535);
        }
        terminate(s);
        append(outputs[2], s);
        for (auto &b : outputs)
            size(b.size());
        size(road.bands);
        size(scene.cars);
        size(signs.count);
        for (auto &b : outputs)
            std::cout.write((char *)b.data(), b.size());
    }
}
