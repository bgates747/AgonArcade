// Export retained tables without modifying or regenerating production geometry.
#include "lookup_road.hpp"
#include "vehicle.hpp"
#include <cassert>
#include <filesystem>
#include <fstream>
#include <vector>
using Bytes = std::vector<uint8_t>;
static void word(Bytes &b, unsigned at, unsigned v) {
    b[at] = v;
    b[at + 1] = v >> 8;
}
static void dword(Bytes &b, unsigned at, uint32_t v) {
    for (int i = 0; i < 4; ++i)
        b[at + i] = v >> (8 * i);
}
template <class T> Bytes bytes(const T *p, unsigned n) {
    Bytes b(n * sizeof(T));
    for (unsigned i = 0; i < n; ++i)
        for (unsigned j = 0; j < sizeof(T); ++j)
            b[i * sizeof(T) + j] = uint32_t(p[i]) >> (8 * j);
    return b;
}
int main(int argc, char **argv) {
    assert(argc == 3);
    std::filesystem::create_directories(argv[2]);
    std::ofstream meta(std::string(argv[2]) + "/asset_meta.h");
    meta << "/* Generated from preserved renderer tables; see assets.cpp. */\n";
    meta << "static const uint32_t asset_meta[2][4] = {\n";
    for (unsigned t = 0; t < 2; ++t) {
        const auto &track = t ? rally::TriOval : rally::Fuji;
        const char *name = t ? "oval" : "fuji";
        std::ifstream in(std::string(argv[1]) + "/" + name + ".road", std::ios::binary);
        Bytes lookup((std::istreambuf_iterator<char>(in)), {});
        assert(lookup.size() > 64);
        rally::LookupRoad validate;
        validate.track = &track;
        assert(validate.load((std::string(argv[1]) + "/" + name + ".road").c_str()));
        Bytes pts(track.count * 8);
        for (unsigned i = 0; i < track.count; ++i) {
            const auto &p = track.points[i];
            word(pts, i * 8, p.x);
            word(pts, i * 8 + 2, p.y);
            word(pts, i * 8 + 4, p.tx);
            word(pts, i * 8 + 6, p.ty);
        }
        using namespace rally;
        using namespace section_phase;
        using namespace r18;
        Bytes tables[] = {Bytes(lookup.begin() + 64, lookup.end()),
                          pts,
                          bytes(BandOffsets, sizeof(BandOffsets) / 2),
                          bytes(BandEnds, sizeof(BandEnds)),
                          bytes(PhaseIndex, sizeof(PhaseIndex)),
                          bytes(Offsets, sizeof(Offsets) / 2),
                          bytes(Rows, sizeof(Rows)),
                          bytes(DepthQ8, sizeof(DepthQ8) / 4),
                          bytes(BearingAngles, 257),
                          bytes(HeadingAngles, 289)};
        const unsigned widths[] = {12, 8, 2, 1, 1, 2, 1, 4, 2, 2};
        Bytes out(192, 0);
        for (unsigned i = 0; i < 10; ++i) {
            while (out.size() % 4)
                out.push_back(0);
            unsigned a = 32 + i * 16;
            word(out, a, i + 1);
            word(out, a + 2, widths[i]);
            dword(out, a + 4, tables[i].size() / widths[i]);
            dword(out, a + 8, out.size());
            dword(out, a + 12, tables[i].size());
            out.insert(out.end(), tables[i].begin(), tables[i].end());
        }
        out[0] = 'R';
        out[1] = '2';
        out[2] = '4';
        out[3] = 'T';
        word(out, 4, 1);
        word(out, 6, 10);
        dword(out, 8, out.size());
        dword(out, 12, lookup_format::trackIdentity(track));
        word(out, 16, track.count);
        dword(out, 20, track.length);
        uint32_t hash = 2166136261u;
        for (unsigned i = 32; i < out.size(); ++i)
            hash = lookup_format::hashByte(hash, out[i]);
        dword(out, 24, hash);
        std::ofstream f(std::string(argv[2]) + "/" + name + ".r24", std::ios::binary);
        f.write((char *)out.data(), out.size());
        meta << "{" << lookup_format::trackIdentity(track) << "u," << hash << "u," << out.size()
             << "u," << track.count << "u},\n";
    }
    meta << "};\n";
}
