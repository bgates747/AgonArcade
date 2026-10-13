// Use the SDK's unchanged image loader to qualify the actual packaged artifacts.
#include "vdplet_image.h"
#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <fstream>
#include <vector>
int main(int argc, char **argv) {
    assert(argc == 2);
    std::ifstream f(argv[1], std::ios::binary);
    std::vector<uint8_t> b((std::istreambuf_iterator<char>(f)), {});
    vdpl::Image image;
    int rc =
        vdpl::load(b.data(), b.size(), image, [](uint32_t n, bool) { return malloc(n); }, free, 1);
    assert(rc == 0);
    printf("admitted: text=%u data=%u relocations=%u\n", image.text_bytes, image.data_bytes,
           image.relocation_count);
    vdpl::dispose(image, free);
}
