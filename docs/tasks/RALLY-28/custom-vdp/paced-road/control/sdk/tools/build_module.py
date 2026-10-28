#!/usr/bin/env python3
"""Compile and package a standalone C/C++ VDPlet for classic ESP32 hardware."""
from pathlib import Path
import argparse
import hashlib
import json
import struct
import subprocess
import re

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
POLICY_PATH = ROOT / "src/vdplet_policy.h"
POLICY = {name: int(value) for name, value in re.findall(r"^#define VDPL_(\w+) (\d+)u$", POLICY_PATH.read_text(), re.M)}

def run(args, **kwargs):
    return subprocess.run([str(x) for x in args], check=True, **kwargs)

def build_one(source, output, compiler, name, variant, build_id, capabilities,
              text_limit=POLICY['DEFAULT_TEXT'], data_limit=POLICY['DEFAULT_DATA'],
              stack_limit=POLICY['DEFAULT_STACK'], image_limit=POLICY['DEFAULT_IMAGE']):
    source, output, compiler = Path(source).resolve(), Path(output).resolve(), Path(compiler).resolve()
    output.mkdir(parents=True, exist_ok=True)
    for key, value in (("TEXT", text_limit), ("DATA", data_limit), ("STACK", stack_limit), ("IMAGE", image_limit)):
        if not 0 < value <= POLICY['MAX_' + key]:
            raise ValueError(f"invalid {key.lower()} allowance: {value}")
    if source.suffix not in (".c", ".cpp"):
        raise ValueError("module source must be .c or .cpp")
    if not name or Path(name).name != name or name in (".", ".."):
        raise ValueError("module name must be a filename without a directory")
    if not 0 <= build_id <= 0xFFFFFFFF or not 0 <= capabilities <= 3:
        raise ValueError("invalid build ID or unsupported capability mask")
    version = subprocess.check_output([str(compiler), "--version"], text=True).splitlines()[0]
    if "esp-2021r2-patch5" not in version or "8.4.0" not in version:
        raise ValueError(f"wrong compiler: {version}")
    obj = output / f"{name}.o"
    elf = output / f"{name}.elf"
    stripped = output / f"{name}.upload.elf"
    prefix = str(compiler).removesuffix("gcc")
    flags = ["-I", str(ROOT / "include"), "-Os", "-fPIC", "-mlongcalls", "-mtext-section-literals",
             "-fvisibility=hidden", "-ffunction-sections", "-fdata-sections",
             "-fno-builtin", "-ffp-contract=off", "-fstack-usage", "-fno-common"]
    if source.suffix == ".cpp":
        flags += ["-std=c++17", "-fno-exceptions", "-fno-rtti", "-fno-threadsafe-statics"]
    run([compiler, *flags, f"-DVDPL_VARIANT={variant}", "-c", source, "-o", obj])
    link_flags=[]
    if source.suffix==".cpp":
        link_flags=[f"-Wl,--version-script={HERE/'module.exports'}"]
    run([compiler, "-nostdlib", "-nostartfiles", "-shared", "-Wl,--gc-sections",
         "-Wl,-e,vdplet_entry", "-Wl,--no-undefined", *link_flags, obj, "-o", elf])
    run([prefix + "strip", "--strip-unneeded", "--remove-section=.got.loc",
         "--remove-section=.got", "--remove-section=.dynamic", "--remove-section=.comment",
         "--remove-section=.xt.lit", "--remove-section=.xt.prop", "--remove-section=.xtensa.info",
         "-o", stripped, elf])
    data = bytearray(stripped.read_bytes())
    # Stripping .dynamic leaves an unused PT_DYNAMIC descriptor. Null it so
    # ordinary ELF inspection has no dangling dynamic-segment warning.
    phoff = struct.unpack_from("<I", data, 28)[0]
    phsize, phcount = struct.unpack_from("<HH", data, 42)
    for index in range(phcount):
        at = phoff + index * phsize
        if struct.unpack_from("<I", data, at)[0] == 2:
            struct.pack_into("<I", data, at, 0)
    stripped.write_bytes(data)
    for suffix, command in [("readelf.txt", [prefix + "readelf", "-hSWr", stripped]),
                            ("disassembly.txt", [prefix + "objdump", "-drs", elf])]:
        with (output / f"{name}.{suffix}").open("w") as log:
            run(command, stdout=log)
    shoff = struct.unpack_from("<I", data, 32)[0]
    shcount, names_index = struct.unpack_from("<HH", data, 48)
    names_offset, names_bytes = struct.unpack_from("<II", data, shoff + names_index*40 + 16)
    names = data[names_offset:names_offset+names_bytes]
    sections = {}
    for index in range(shcount):
        fields = struct.unpack_from("<IIIIIIIIII", data, shoff + index*40)
        start = fields[0]
        section_name = bytes(names[start:names.index(0, start)]).decode("ascii")
        sections[section_name] = {"virtual_address": fields[3], "bytes": fields[5], "type": fields[1]}
    text_bytes = (sections[".text"]["bytes"]+3)&~3
    resident_data_bytes = sum((sections.get(name, {}).get("bytes", 0)+3)&~3
                              for name in (".rodata", ".data", ".bss", ".data.rel.ro"))
    if text_bytes > text_limit or resident_data_bytes > data_limit:
        raise ValueError(f"module exceeds declared text/data envelope: text {text_bytes}/{text_limit}, data {resident_data_bytes}/{data_limit}")
    envelope = struct.pack("<4sHHIIHHIIIIIIIIIII", b"VDPL", 1, 64, 64+len(data),
                           0x32505345, 1, 0, capabilities, text_limit, data_limit, stack_limit,
                           build_id, 64, len(data), 80400, 0, 0, 0)
    assert len(envelope) == 64
    payload = envelope + bytes(data)
    if len(payload) > image_limit:
        raise ValueError(f"module image exceeds selected image limit: {len(payload)}/{image_limit}")
    package = output / f"{name}.vdpl"
    package.write_bytes(payload)
    return {"name": name, "source": str(source), "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
            "policy_sha256": hashlib.sha256(POLICY_PATH.read_bytes()).hexdigest(),
            "declared_limits": {"text": text_limit, "data": data_limit, "stack": stack_limit, "image": image_limit},
            "build_id": f"0x{build_id:08x}", "capabilities": capabilities,
            "envelope_bytes": 64, "elf_bytes": len(data), "package_bytes": len(payload),
            "sha256": hashlib.sha256(payload).hexdigest(), "package": str(package),
            "elf": str(elf), "entry_virtual": struct.unpack_from("<I", data, 24)[0],
            "resident_text_bytes": text_bytes, "resident_data_bytes": resident_data_bytes,
            "relative_relocations": sections.get(".rela.dyn", {}).get("bytes", 0)//12,
            "allocated_sections": {name: sections[name] for name in
                                   (".text", ".rodata", ".data", ".bss", ".data.rel.ro") if name in sections}}

def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="standalone .c or .cpp module")
    parser.add_argument("--compiler", type=Path,
                        default=Path.home()/".platformio/packages/toolchain-xtensa-esp32/bin/xtensa-esp32-elf-gcc")
    parser.add_argument("--output", type=Path, default=ROOT/"build/modules")
    parser.add_argument("--name", help="output basename; defaults to the source stem")
    parser.add_argument("--variant", type=int, default=1)
    parser.add_argument("--build-id", type=lambda value: int(value, 0), default=1)
    parser.add_argument("--capabilities", type=lambda value: int(value, 0), default=1,
                        help="required services: buffers=1, packed framebuffer=2, both=3")
    for key in ('text', 'data', 'stack', 'image'):
        parser.add_argument('--' + key + '-limit', type=int, default=POLICY['DEFAULT_' + key.upper()])
    args = parser.parse_args()
    entry = build_one(args.source, args.output, args.compiler, args.name or args.source.stem,
                      args.variant, args.build_id, args.capabilities,
                      args.text_limit, args.data_limit, args.stack_limit, args.image_limit)
    manifest = {
        "compiler": subprocess.check_output([str(args.compiler), "--version"], text=True).splitlines()[0],
        "abi_header_sha256": hashlib.sha256((ROOT/"include/vdplet.h").read_bytes()).hexdigest(),
        "module": entry,
    }
    (args.output/f"{entry['name']}.json").write_text(json.dumps(manifest, indent=2)+"\n")
    print(json.dumps(manifest, indent=2))


if __name__ == "__main__":
    main()
