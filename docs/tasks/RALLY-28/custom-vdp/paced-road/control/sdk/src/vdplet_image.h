#ifndef AGON_VDPLET_IMAGE_H
#define AGON_VDPLET_IMAGE_H
#include <stdint.h>
#include <stddef.h>
#include <string.h>
#include "vdplet_policy.h"

/* A small, deliberately restricted ELF32/Xtensa relative relocation loader.
 * Its section mapping follows the classic ESP32 split-IRAM/DRAM approach
 * documented by Espressif elf_loader 1.3.4. This is independent implementation,
 * not an unrestricted ELF loader or a sandbox. */
namespace vdpl {
enum { OK=0, IMAGE=10, RELOCATION=11, MEMORY=6, LIMIT=13, ABI=5 };
inline uint16_t u16(const uint8_t *p) { return uint16_t(p[0]) | uint16_t(p[1]) << 8; }
inline uint32_t u32(const uint8_t *p) { return uint32_t(p[0]) | uint32_t(p[1]) << 8 | uint32_t(p[2]) << 16 | uint32_t(p[3]) << 24; }
inline bool span(uint32_t offset, uint32_t bytes, uint32_t total) { return offset <= total && bytes <= total-offset; }
inline uint32_t align4(uint32_t n) { return (n+3u)&~3u; }
struct Section {
    uint32_t virtual_address=0, bytes=0, offset=0, type=0, alignment=0;
    uint8_t *loaded=nullptr;
};
struct Image {
    Section sections[5]; // text, rodata, data, bss, data.rel.ro
    void *text=nullptr, *data=nullptr;
    uint32_t text_bytes=0, data_bytes=0, entry_offset=0, build=0, capabilities=0;
    uintptr_t entry=0;
    uint32_t relocation_count=0;
};
typedef void *(*Allocate)(uint32_t, bool);
typedef void (*Release)(void *);
inline void dispose(Image &out, Release release) {
    if (out.text) release(out.text);
    if (out.data) release(out.data);
    out=Image{};
}
inline uintptr_t mapped(const Image &out, uint32_t virtual_address, uint32_t bytes=1) {
    for (const auto &s:out.sections)
        if (s.bytes && virtual_address >= s.virtual_address &&
            span(virtual_address-s.virtual_address, bytes, s.bytes))
            return reinterpret_cast<uintptr_t>(s.loaded)+(virtual_address-s.virtual_address);
    return 0;
}
inline int identify(const char *name) {
    if (!strcmp(name,".text")) return 0;
    if (!strcmp(name,".rodata")) return 1;
    if (!strcmp(name,".data")) return 2;
    if (!strcmp(name,".bss")) return 3;
    if (!strcmp(name,".data.rel.ro")) return 4;
    return -1;
}
inline int load(const uint8_t *package, uint32_t package_bytes, Image &out,
                Allocate allocate, Release release, uint32_t host_capabilities) {
    if (out.text || out.data) return IMAGE;
    if (!package || package_bytes<64 || package_bytes>VDPL_MAX_IMAGE ||
        memcmp(package,"VDPL",4) || u16(package+4)!=1 || u16(package+6)!=64 ||
        u32(package+8)!=package_bytes || u32(package+12)!=0x32505345u ||
        u16(package+16)!=1 || u16(package+18)!=0 || u32(package+48)!=80400 ||
        u32(package+52) || u32(package+56) || u32(package+60)) return IMAGE;
    uint32_t text_limit=u32(package+24), data_limit=u32(package+28);
    if (!text_limit || text_limit>VDPL_MAX_TEXT || !data_limit || data_limit>VDPL_MAX_DATA ||
        u32(package+32)>VDPL_MAX_STACK) return LIMIT;
    uint32_t capabilities=u32(package+20);
    if ((capabilities & host_capabilities)!=capabilities) return ABI;
    uint32_t elf_offset=u32(package+40), elf_bytes=u32(package+44);
    if (elf_offset!=64 || !span(elf_offset,elf_bytes,package_bytes) ||
        elf_bytes!=package_bytes-64 || elf_bytes<52) return IMAGE;
    const uint8_t *elf=package+elf_offset;
    if (memcmp(elf,"\177ELF",4) || elf[4]!=1 || elf[5]!=1 || elf[6]!=1 ||
        u16(elf+16)!=3 || u16(elf+18)!=94 || u32(elf+20)!=1 ||
        u16(elf+40)!=52 || u16(elf+46)!=40) return IMAGE;
    uint32_t section_offset=u32(elf+32), section_count=u16(elf+48), names_index=u16(elf+50);
    if (!section_count || section_count>32 || names_index>=section_count ||
        !span(section_offset,section_count*40,elf_bytes)) return IMAGE;
    const uint8_t *table=elf+section_offset;
    const uint8_t *names_header=table+40*names_index;
    uint32_t names_offset=u32(names_header+16), names_bytes=u32(names_header+20);
    if (u32(names_header+4)!=3 || !span(names_offset,names_bytes,elf_bytes)) return IMAGE;
    const char *names=reinterpret_cast<const char *>(elf+names_offset);
    uint32_t data_bytes=0;
    Image image;
    image.capabilities=capabilities;
    image.build=u32(package+36);
    for (uint32_t i=0;i<section_count;++i) {
        const uint8_t *sh=table+i*40;
        uint32_t name_offset=u32(sh), type=u32(sh+4), flags=u32(sh+8);
        uint32_t address=u32(sh+12), offset=u32(sh+16), bytes=u32(sh+20), alignment=u32(sh+32);
        if (name_offset>=names_bytes || !memchr(names+name_offset,0,names_bytes-name_offset) ||
            (type!=8 && !span(offset,bytes,elf_bytes))) return IMAGE;
        if (type==11 || type==2) { // No imports, including weak undefined symbols.
            if (u32(sh+36)!=16 || bytes%16) return IMAGE;
            for (uint32_t k=16;k<bytes;k+=16)
                if (u16(elf+offset+k+14)==0) return RELOCATION;
        }
        if (!(flags&2) || !bytes) continue;
        const char *name=names+name_offset;
        int index=identify(name);
        if (index<0) {
            // These allocated sections are linker metadata, never runtime data.
            if ((type==5 && !strcmp(name,".hash")) || (type==11 && !strcmp(name,".dynsym")) ||
                (type==3 && !strcmp(name,".dynstr")) || (type==4 && !strcmp(name,".rela.dyn"))) continue;
            return IMAGE;
        }
        uint32_t expected_flags=index==0 ? 6u : (index==1 ? 2u : 3u);
        if (image.sections[index].bytes || flags!=expected_flags || (alignment>4) ||
            (alignment && (alignment&(alignment-1))) || (address&3) ||
            (index==0 ? type!=1 || !(flags&4) : flags&4) ||
            (index==3 ? type!=8 : type!=1)) return IMAGE;
        for (const auto &s:image.sections) {
            if (!s.bytes) continue;
            if (address <= s.virtual_address ? s.virtual_address-address < bytes : address-s.virtual_address < s.bytes) return IMAGE;
        }
        if (!span(address,bytes,UINT32_MAX)) return IMAGE;
        image.sections[index]={address,bytes,offset,type,alignment,nullptr};
        if (index==0) image.text_bytes=align4(bytes);
        else { if (bytes>data_limit || align4(bytes)>data_limit || data_bytes>data_limit-align4(bytes)) return LIMIT; data_bytes+=align4(bytes); }
    }
    if (!image.text_bytes || image.text_bytes>text_limit || data_bytes>data_limit) return LIMIT;
    image.data_bytes=data_bytes;
    auto &text=image.sections[0];
    uint32_t entry=u32(elf+24);
    if (entry<text.virtual_address || entry-text.virtual_address>=text.bytes) return IMAGE;
    image.entry_offset=entry-text.virtual_address;
    image.text=allocate(image.text_bytes,true);
    if (!image.text) return MEMORY;
    if (data_bytes) image.data=allocate(data_bytes,false);
    if (data_bytes && !image.data) { dispose(image,release); return MEMORY; }
    uint32_t data_position=0;
    for (uint32_t i=0;i<5;++i) {
        auto &s=image.sections[i];
        if (!s.bytes) continue;
        if (i==0) {
            s.loaded=reinterpret_cast<uint8_t *>(image.text);
            // Executable-only ESP32 IRAM requires aligned 32-bit accesses.
            auto *words=reinterpret_cast<uint32_t *>(image.text);
            for (uint32_t p=0;p<image.text_bytes;p+=4) {
                uint32_t word=0;
                for (uint32_t b=0;b<4 && p+b<s.bytes;++b) word|=uint32_t(elf[s.offset+p+b])<<(8*b);
                words[p/4]=word;
            }
        } else {
            s.loaded=reinterpret_cast<uint8_t *>(image.data)+data_position;
            if (s.type==8) memset(s.loaded,0,s.bytes);
            else memcpy(s.loaded,elf+s.offset,s.bytes);
            data_position+=align4(s.bytes);
        }
    }
    for (uint32_t i=0;i<section_count;++i) {
        const uint8_t *sh=table+i*40;
        if (u32(sh+4)==9) { dispose(image,release); return RELOCATION; } // No REL form.
        if (u32(sh+4)!=4) continue;
        uint32_t offset=u32(sh+16), bytes=u32(sh+20);
        if (bytes%12 || u32(sh+36)!=12) { dispose(image,release); return RELOCATION; }
        for (uint32_t r=0;r<bytes;r+=12) {
            const uint8_t *rela=elf+offset+r;
            uint32_t address=u32(rela), info=u32(rela+4);
            uintptr_t where=mapped(image,address,4);
            if ((address&3) || !where || info!=5 || u32(rela+8)!=0) { dispose(image,release); return RELOCATION; }
            uint32_t old=*reinterpret_cast<uint32_t *>(where);
            uintptr_t value=mapped(image,old);
            if (!value) { dispose(image,release); return RELOCATION; }
            *reinterpret_cast<uint32_t *>(where)=uint32_t(value);
            ++image.relocation_count;
        }
    }
    image.entry=reinterpret_cast<uintptr_t>(image.text)+image.entry_offset;
    out=image;
    return OK;
}
}
#endif
