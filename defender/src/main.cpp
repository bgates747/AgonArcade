#include "assets.hpp"
#include "game.hpp"
#include <agon/mos.h>
#include <agon/vdp.h>
#include <stdio.h>
#include <string.h>
#include <time.h>
using namespace defender;
namespace {
Game game;
int drawnState = -1;
void text(int x, int y, int color, const char *s) {
    vdp_set_text_colour(color);
    vdp_cursor_tab(x, y);
    mos_puts(const_cast<char *>(s), strlen(s), 0);
}
void rect(int x, int y, int w, int h, int color) {
    vdp_gcol(0, color);
    vdp_filled_rectangle(x, y, x + w - 1, y + h - 1);
}
void line(int x, int y, int xx, int yy, int color) {
    vdp_gcol(0, color);
    vdp_move_to(x, y);
    vdp_line_to(xx, yy);
}
void center(int row, int color, const char *s) {
    text((40 - int(strlen(s))) / 2, row, color, s);
}
void bitmap(int id, int x, int y, bool visible = true) {
    if (!visible || x <= -24 || x >= 320 || y < 39 || y >= 214)
        return;
    vdp_select_bitmap(id);
    vdp_draw_bitmap(x, y);
}
void loadAssets() {
    vdp_reset_sprites();
    for (unsigned i = 0; i < sizeof(assets::bitmaps) / sizeof(assets::bitmaps[0]); ++i) {
        const auto &b = assets::bitmaps[i];
        vdp_adv_clear_buffer(64000 + i);
        vdp_adv_write_block_data(64000 + i, b.w * b.h, (char *)b.data);
        vdp_select_bitmap(i);
        vdp_adv_bitmap_from_buffer(b.w, b.h, 1);
    }
}

int screen(int px, int camera) {
    return delta(px, camera * Scale) / Scale + 160;
}
void landscape(int camera) {
    int origin = camera - 160;
    int start = (origin / 32) * 32 - 32;
    for (int i = 0; i < 13; ++i) {
        int wx = start + i * 32;
        int sx = wx - origin;
        int nx = sx + 32;
        if (nx < 0 || sx >= 320)
            continue;
        int y = ground(wx), ny = ground(wx + 32);
        int a = sx < 0 ? 0 : sx, b = nx > 319 ? 319 : nx;
        int ya = y + (ny - y) * (a - sx) / 32, yb = y + (ny - y) * (b - sx) / 32;
        line(a, ya, b, yb, 12);
    }
    for (int i = 0; i < 8; ++i) {
        int sx = screen(i * 256 * Scale, camera);
        if (sx >= -20 && sx < 340) {
            int l = sx - 20 < 0 ? 0 : sx - 20, r = sx + 20 > 319 ? 319 : sx + 20;
            if (l <= r) {
                line(l, 205, r, 205, 14);
                line(l, 206, r, 206, 4);
            }
        }
    }
    for (int i = 0; i < 23; ++i) {
        int sx = ((i * 137 - camera / 3) % 320 + 320) % 320;
        int sy = 49 + (i * 43) % 132;
        vdp_gcol(0, 8);
        vdp_point(sx, sy);
    }
}
void radar() {
    rect(88, 12, 144, 20, 0);
    line(88, 31, 231, 31, 8);
    for (int i = 0; i < People; ++i) {
        const auto &p = game.people[i];
        if (p.state != Dead && p.state != Safe)
            rect(88 + p.x / Scale * 144 / World, 28, 2, 2, 11);
    }
    for (const auto &e : game.enemies)
        if (e.alive)
            rect(88 + e.x / Scale * 144 / World, 14 + (e.y / Scale - 40) * 13 / 160, 2, 2,
                 e.kind ? 13 : 10);
    int sx = 88 + game.x / Scale * 144 / World;
    rect(sx, 14 + (game.y / Scale - 40) * 13 / 160, 3, 2, 15);
    int l = ((game.x / Scale - 160 + World) % World) * 144 / World + 88;
    int r = ((game.x / Scale + 160) % World) * 144 / World + 88;
    line(l, 12, l, 15, 14);
    line(r, 12, r, 15, 14);
}
void hud() {
    char value[48];
    snprintf(value, sizeof(value), "%07lu", (unsigned long)game.score);
    text(1, 2, 15, value);
    snprintf(value, sizeof(value), "HULL %d", game.lives);
    text(32, 1, 14, value);
    snprintf(value, sizeof(value), "BOMB %d", game.bombs);
    text(32, 3, 11, value);
    snprintf(value, sizeof(value), "SECTOR %02d", game.wave);
    text(1, 0, 14, value);
    if (game.clearTimer)
        center(28, 10, "SECTOR CLEAR / REGROUPING");
    else if (game.carrying >= 0)
        center(28, 11, "PASSENGER ABOARD / LAND ON CYAN PAD");
    else {
        snprintf(value, sizeof(value), "%d PEOPLE   X BOMB   P PAUSE   M %s", game.survivors(),
                 game.muted ? "OFF" : "ON ");
        center(28, 8, value);
    }
}
void render() {
    bool change = drawnState != game.state;
    if (change) {
        vdp_cls();
        drawnState = game.state;
    }
    if (game.state != Playing) {
        if (!change)
            return;
        center(3, 14, "A G O N   D E F E N D E R");
        line(20, 42, 300, 42, 4);
        if (game.state == Title) {
            center(8, 15, "THE LAST FLIGHT HOME");
            vdp_select_bitmap(0);
            vdp_draw_bitmap(150, 83);
            center(13, 14, "ARROW KEYS   THRUST / CLIMB / DIVE");
            center(15, 15, "SPACE  LASER       X  SMART BOMB");
            center(18, 11, "CATCH PEOPLE. LAND ON CYAN PADS.");
            center(20, 10, "STOP ABDUCTIONS. WATCH THE RADAR.");
            center(24, 15, "PRESS ENTER OR SPACE TO LAUNCH");
        } else if (game.state == Paused) {
            center(12, 14, "FLIGHT PAUSED");
            center(17, 15, "P TO RESUME");
        } else {
            center(11, 9, "DEFENSE GRID LOST");
            char s[48];
            snprintf(s, sizeof(s), "SCORE %lu    BEST %lu", (unsigned long)game.score,
                     (unsigned long)game.best);
            center(15, 15, s);
            center(21, 14, "ENTER / SPACE TO FLY AGAIN");
        }
        center(28, 8, "ESC RETURNS TO MOS");
        vdp_swap();
        return;
    }
    int camera = game.x / Scale;
    // Ordinary bitmap plots compose the complete off-screen frame; no software sprites.
    rect(0, 0, 320, 240, 0);
    landscape(camera);
    line(0, 37, 319, 37, 4);
    center(0, 8, "RADAR");
    hud();
    radar();
    bitmap(game.facing < 0 ? 1 : 0, 150, game.y / Scale - 4,
           game.invulnerable == 0 || (game.frame / 4) % 2 == 0);
    bool thrust = game.vx > 3 || game.vx < -3;
    bitmap(game.facing < 0 ? 8 : 7, game.facing > 0 ? 143 : 170, game.y / Scale - 1,
           thrust && game.frame % 4 < 2);
    for (int i = 0; i < Enemies; ++i) {
        const auto &e = game.enemies[i];
        bitmap(2 + e.kind, screen(e.x, camera) - 7, e.y / Scale - 4, e.alive);
    }
    for (int i = 0; i < People; ++i) {
        const auto &p = game.people[i];
        bitmap(4, screen(p.x, camera) - 3, p.y / Scale - 4, p.state != Dead && p.state != Safe);
    }
    for (int i = 0; i < Shots; ++i) {
        const auto &s = game.shots[i];
        bitmap(s.hostile ? 6 : 5, screen(s.x, camera) - (s.hostile ? 1 : 9), s.y / Scale - 1,
               s.life > 0);
    }
    for (int i = 0; i < Sparks; ++i) {
        const auto &s = game.sparks[i];
        bitmap(9 + s.color, screen(s.x, camera), s.y / Scale, s.life > 0);
    }
    line(0, 38, 319, 38, game.flash ? 15 : 0);
    vdp_swap();
}
void audioInit() {
    for (int i = 0; i < 4; ++i) {
        vdp_audio_enable_channel(i);
        vdp_audio_set_waveform(i, i == 1 ? VDP_AUDIO_WAVEFORM_NOISE : VDP_AUDIO_WAVEFORM_SQUARE);
        vdp_audio_volume_envelope_ADSR(i, 2, 35, 30, 80);
    }
    int16_t pitch[] = {-130, 6};
    vdp_audio_frequency_envelope_stepped(0, 1, 0, 12, pitch);
}
void silence() {
    for (int i = 0; i < 4; ++i)
        vdp_audio_set_volume(i, 0);
}
void audio() {
    if (game.muted || game.state == Paused) {
        silence();
        return;
    }
    if (game.sounds & Laser)
        vdp_audio_play_note(0, 65, 1300, 100);
    if (game.sounds & Explosion)
        vdp_audio_play_note(1, 85, 95, 180);
    if (game.sounds & Damage)
        vdp_audio_play_note(1, 110, 45, 400);
    if (game.sounds & Rescue)
        vdp_audio_play_note(2, 85, 1400, 220);
    if (game.sounds & Abduction)
        vdp_audio_play_note(3, 70, 240, 300);
    if (game.sounds & Blast)
        vdp_audio_play_note(1, 120, 60, 500);
}
unsigned input() {
    uint8_t map[16];
    for (int i = 0; i < 16; ++i)
        map[i] = vdp_getKeyMap(i);
    return decode(map);
}
} // namespace
int main(int argc, char **argv) {
    bool demo = argc > 1 && strcmp(argv[1], "demo") == 0;
    game.rng = uint32_t(clock()) + 1;
    if (vdp_mode(136) < 0)
        return 1;
    vdp_set_pixel_coordinates();
    vdp_cursor_enable(false);
    vdp_set_text_bg_colour(0);
    vdp_cls();
    loadAssets();
    audioInit();
    if (demo)
        game.reset();
    clock_t next = clock();
    while (!game.quit) {
        clock_t now = clock();
        if (long(now - next) < 0)
            continue;
        next += 2;
        if (long(now - next) > 6)
            next = now + 2;
        unsigned keys = input();
        if (demo) {
            if (game.state == Over)
                game.reset();
            keys |= Fire | Right | ((game.frame / 100) % 2 ? Up : Down);
        }
        game.tick(keys);
        audio();
        if (game.frame % 2 == 0 || drawnState != game.state)
            render();
    }
    silence();
    vdp_reset_sprites();
    vdp_mode(0);
    vdp_set_logical_coordinates();
    vdp_cursor_enable(true);
    printf("Agon Defender: flight ended.\n");
    return 0;
}
