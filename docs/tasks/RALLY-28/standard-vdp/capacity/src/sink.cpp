// Separate translation unit, no LTO: callers must construct every command byte.
#include <agon/mos.h>
#include <stdint.h>
#include <string.h>
uint32_t cpuBytes=0;
extern "C" void census_puts(const char *p,uint24_t n,char) {cpuBytes+=n?n:strlen(p);}
extern "C" int census_putch(int n) {++cpuBytes;return n;}
