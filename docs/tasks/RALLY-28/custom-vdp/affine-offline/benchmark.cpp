// Host-only timing of extracted stock pixel kernels with original Rally art.
// No firmware cycles or PSRAM timing are inferred from this process.
#include "stock/stock.hpp"
#include <algorithm>
#include <array>
#include <cmath>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <iterator>
#include <stdexcept>
#include <string>
#include <time.h>
#include <vector>

static volatile uint64_t sink = 0;
static uint64_t clock_ns(clockid_t id) {
    timespec t{};
    if (clock_gettime(id, &t)) throw std::runtime_error("clock_gettime");
    return uint64_t(t.tv_sec) * 1000000000ull + uint64_t(t.tv_nsec);
}
static uint64_t checksum(const std::vector<uint8_t>& bytes) {
    uint64_t value = 1469598103934665603ull;
    for (auto pixel : bytes) { value ^= pixel; value *= 1099511628211ull; }
    return value;
}
struct Case {
    std::string name, path;
    int w, h, xx, yy, tx, ty, x, y;
    stock::Rect clip;
    std::vector<uint8_t> source, prepared;
    stock::Bitmap bitmap{0,0,nullptr}, transformed{0,0,nullptr};
    stock::Affine affine{};
    stock::StockSurface surface;
    int min_x, min_y, output_w, output_h;
    void prepare() {
        std::ifstream input(path, std::ios::binary);
        if (!input) throw std::runtime_error("Missing original bitmap " + path);
        source.assign(std::istreambuf_iterator<char>(input), {});
        if (source.size() != size_t(w * h)) throw std::runtime_error("Bitmap size");
        bitmap = {w, h, source.data()};
        affine = stock::make_affine(xx / 256.0f, yy / 256.0f, tx / 256.0f, ty / 256.0f);
        // Match command40 resize+translate's integer corner bounding policy.
        const auto geometry = stock::natural_buffer_size(bitmap, affine);
        min_x = geometry.xOffset; min_y = geometry.yOffset;
        output_w = geometry.width; output_h = geometry.height;
        prepared = stock::transform_buffer(bitmap, affine, output_w, output_h, min_x, min_y);
        transformed = {output_w, output_h, prepared.data()};
    }
};
enum Operation { Empty, MatrixModel, CachedAffine, RebuiltAffineModel,
                 TransformKernel, TransformPlot, PreparedPlot, OriginalPlot, Count };
static const char* names[Count] = {"empty", "matrix_setup_host_model", "cached_affine",
    "rebuilt_affine_host_model", "transform_bitmap_kernel", "transform_then_plot",
    "ordinary_pretransformed", "ordinary_original_size"};
static void execute(Operation op, Case& c, uint64_t count) {
    for (uint64_t i = 0; i < count; ++i) {
        switch (op) {
        case Empty: sink = sink + c.source[0]; break;
        case MatrixModel: {
            const auto m = stock::make_affine(c.xx / 256.0f, c.yy / 256.0f,
                                              c.tx / 256.0f, c.ty / 256.0f);
            uint32_t bits; std::memcpy(&bits, &m.inverse[0], sizeof bits);
            sink = sink + bits; break;
        }
        case CachedAffine: c.surface.draw_affine(c.bitmap, c.affine, c.clip, c.x, c.y); break;
        case RebuiltAffineModel: {
            const auto m = stock::make_affine(c.xx / 256.0f, c.yy / 256.0f,
                                              c.tx / 256.0f, c.ty / 256.0f);
            c.surface.draw_affine(c.bitmap, m, c.clip, c.x, c.y); break;
        }
        case TransformKernel: {
            auto data = stock::transform_buffer(c.bitmap, c.affine, c.output_w, c.output_h,
                                                c.min_x, c.min_y);
            sink = sink + data.back(); break;
        }
        case TransformPlot: {
            auto data = stock::transform_buffer(c.bitmap, c.affine, c.output_w, c.output_h,
                                                c.min_x, c.min_y);
            stock::Bitmap image{c.output_w, c.output_h, data.data()};
            c.surface.draw_plain(image, c.clip, c.x + c.min_x, c.y + c.min_y); break;
        }
        case PreparedPlot:
            c.surface.draw_plain(c.transformed, c.clip, c.x + c.min_x, c.y + c.min_y); break;
        case OriginalPlot: c.surface.draw_plain(c.bitmap, c.clip, c.x, c.y); break;
        default: throw std::runtime_error("Unknown operation");
        }
    }
}
static void checks(Case& c, std::ofstream& output) {
    c.surface.clear(0xc1); execute(CachedAffine, c, 1);
    const auto cached = c.surface.pixels();
    c.surface.clear(0xc1); execute(RebuiltAffineModel, c, 1);
    if (cached != c.surface.pixels()) throw std::runtime_error("Cached/fresh mismatch");
    c.surface.clear(0xc1); execute(TransformPlot, c, 1);
    const auto transformed = c.surface.pixels();
    c.surface.clear(0xc1); execute(PreparedPlot, c, 1);
    if (transformed != c.surface.pixels()) throw std::runtime_error("Prepared/rebuilt mismatch");
    size_t different = 0;
    for (size_t i = 0; i < cached.size(); ++i) different += cached[i] != transformed[i];
    output << c.name << ',' << c.w << ',' << c.h << ',' << c.output_w << ',' << c.output_h
           << ',' << checksum(cached) << ',' << checksum(transformed) << ',' << different << '\n';
}
int main(int argc, char** argv) {
    try {
        if (argc != 5) throw std::runtime_error("cases.tsv output_prefix min_cpu_ms trials");
        const double minimum_ms = std::stod(argv[3]); const int trials = std::stoi(argv[4]);
        if (minimum_ms <= 0 || trials < 1) throw std::runtime_error("Timing configuration");
        std::ifstream list(argv[1]); if (!list) throw std::runtime_error("Case list");
        std::ofstream output(std::string(argv[2]) + ".csv");
        std::ofstream verified(std::string(argv[2]) + "-checks.csv");
        output << "case,operation,trial,iterations,cpu_ns,wall_ns,cpu_ns_per_operation,wall_ns_per_operation,checksum\n";
        verified << "case,source_width,source_height,buffer_width,buffer_height,cached_checksum,buffer_plot_checksum,differing_pixels\n";
        std::string name, path;
        while (list >> name >> path) {
            Case c{}; c.name = name; c.path = path;
            if (!(list >> c.w >> c.h >> c.xx >> c.yy >> c.tx >> c.ty >> c.x >> c.y
                  >> c.clip.X1 >> c.clip.Y1 >> c.clip.X2 >> c.clip.Y2))
                throw std::runtime_error("Invalid case row");
            c.prepare(); checks(c, verified); verified.flush();
            std::array<uint64_t, Count> counts{};
            for (int op = 0; op < Count; ++op) {
                uint64_t n = 1;
                for (;;) {
                    const auto start = clock_ns(CLOCK_THREAD_CPUTIME_ID);
                    execute(Operation(op), c, n);
                    if (double(clock_ns(CLOCK_THREAD_CPUTIME_ID) - start) >= minimum_ms * 1000000.0
                        || n >= (1u << 24)) break;
                    n *= 2;
                }
                counts[op] = n;
            }
            for (int trial = 0; trial < trials; ++trial) {
                for (int index = 0; index < Count; ++index) {
                    const int op = trial % 2 ? Count - 1 - index : index;
                    c.surface.clear(0xc1);
                    const auto wall0 = clock_ns(CLOCK_MONOTONIC_RAW);
                    const auto cpu0 = clock_ns(CLOCK_THREAD_CPUTIME_ID);
                    execute(Operation(op), c, counts[op]);
                    const auto cpu = clock_ns(CLOCK_THREAD_CPUTIME_ID) - cpu0;
                    const auto wall = clock_ns(CLOCK_MONOTONIC_RAW) - wall0;
                    output << c.name << ',' << names[op] << ',' << trial << ',' << counts[op]
                           << ',' << cpu << ',' << wall << ',' << std::fixed << std::setprecision(6)
                           << double(cpu) / counts[op] << ',' << double(wall) / counts[op]
                           << ',' << checksum(c.surface.pixels()) << '\n';
                    output.flush();
                }
            }
            std::cout << c.name << " checked and timed\n" << std::flush;
        }
        if (!list.eof()) throw std::runtime_error("Case read failed");
        std::cout << "host-only checksum " << sink << '\n';
    } catch (const std::exception& error) {
        std::cerr << error.what() << '\n'; return 1;
    }
}
