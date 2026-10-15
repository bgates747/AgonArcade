#include <agon/mos.h>
#include <stdint.h>
#include <string.h>
extern "C" {
uint24_t timing_ticks();void uart_write(const char*,uint24_t,char);
uint32_t wire_bytes=0,wire_calls=0,send_ticks=0,uart_chunks=0;
void (*wire_service)()=nullptr;uint8_t transmit=0;
void fixture_puts(const char *p,uint24_t n,char d) {
    const uint24_t bytes=n?n:strlen(p);wire_bytes+=bytes;++wire_calls;
    if(transmit) {
        const uint24_t begin=timing_ticks();
        if(!n){uart_write(p,n,d);++uart_chunks;}
        else for(uint24_t at=0;at<n;) {
            const uint24_t count=n-at>64?64:n-at;uart_write(p+at,count,d);at+=count;++uart_chunks;
            if(wire_service)wire_service();
        }
        send_ticks+=(timing_ticks()-begin)&0xffffff;
    }
}
int fixture_putch(int c){const char b=char(c);fixture_puts(&b,1,0);return c;}
}
