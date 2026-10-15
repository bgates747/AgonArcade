"""Inspect unchanged Rally sources with AgonDev; never link or launch a game.

Run with the repository's .venv/bin/python. Generated assembly/IR/objects stay
in this directory's ignored .work/. AUDIT.json records static evidence only.
"""
from collections import Counter
import hashlib
import json
from pathlib import Path
import re
import subprocess

HERE = Path(__file__).resolve().parent
ROOT = HERE.parents[3]
WORK = HERE / ".work"
SDK = Path("/Agon/agondev/release")
CC = SDK / "bin/ez80-none-elf-clang"
OBJCOPY = SDK / "bin/ez80-none-elf-objcopy"
COMMANDS = []


def sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def run(args, cwd=ROOT, stdin=None):
    args = [str(a) for a in args]
    COMMANDS.append({"argv": args, "cwd": str(cwd)})
    result = subprocess.run(args, cwd=cwd, input=stdin, text=True,
                            capture_output=True)
    if result.returncode:
        raise RuntimeError(f"Command failed ({result.returncode}): {args}\n{result.stderr}")
    if result.stderr:
        raise RuntimeError(result.stderr)
    return result.stdout


def flags():
    return ["-mllvm", "-z80-gas-style", "-mllvm", "-z80-print-zero-offset",
            "-nostdinc", "-I./include", "-isystem", SDK / "include",
            "-target", "ez80-none-elf", "-DAGONDEV", "-Oz",
            "-Wa,-march=ez80+full", "-fno-threadsafe-statics",
            "-fcolor-diagnostics"]


def cpp_flags():
    return ["-isystem", SDK / "include/c++", "-std=c++17", "-Wall",
            "-Wextra", "-Werror", "-fno-exceptions", "-fno-rtti"]


def assembly_inventory(path):
    functions = []
    current = None
    for number, line in enumerate(path.read_text().splitlines(), 1):
        match = re.match(r"\s*\.type\s+(\S+),@function", line)
        if match:
            current = {"symbol": match[1], "assembly_line": number,
                       "instructions": 0, "transfers": []}
            functions.append(current)
        elif line.startswith("\t.size\t"):
            current = None
        elif current and re.match(r"\t[a-z][a-z.]*\b", line):
            current["instructions"] += 1
            transfer = re.match(r"\s*(call|jp)\s+(?:(\w+),\s*)?(_\w+)$", line)
            if transfer:
                current["transfers"].append({"kind": transfer[1],
                    "condition": transfer[2], "target": transfer[3], "line": number})
    names = [f["symbol"][1:] if f["symbol"].startswith("__Z") else f["symbol"]
             for f in functions]
    demangled = run(["c++filt"], stdin="\n".join(names) + "\n").splitlines()
    for function, name in zip(functions, demangled):
        function["name"] = name
        function["helper_sites"] = dict(sorted(Counter(
            t["target"] for t in function["transfers"]
            if t["target"].startswith("__") and not t["target"].startswith("__Z")
        ).items()))
    return functions


def ir_inventory(path):
    functions = {}
    current = None
    for line in path.read_text().splitlines():
        match = re.match(r"define\s+.*?@([^ (]+)\(", line)
        if match:
            current = match[1].strip('"')
            functions[current] = Counter()
        elif line == "}":
            current = None
        elif current:
            op = re.search(r"= (mul|sdiv|udiv|srem|urem|add|sub|shl|ashr|lshr|and|or|xor)"
                           r"\s+(?:(?:nsw|nuw|exact)\s+)*(i\d+)\b", line)
            if op:
                functions[current][f"{op[1]} {op[2]}"] += 1
    return {k: dict(sorted(v.items())) for k, v in functions.items()}


def compile_source(label, cwd, extra_flags, existing):
    base = [CC, *flags(), *cpp_flags(), *extra_flags, "src/main.cpp"]
    for suffix, mode in (("s", ["-S"]), ("ll", ["-S", "-emit-llvm"]),
                         ("o", ["-c"])):
        run([*base, *mode, "-o", WORK / f"{label}.{suffix}"], cwd=cwd)
    for name, obj in (("existing", existing), ("inspection", WORK / f"{label}.o")):
        run([OBJCOPY, "-O", "binary", "--only-section=.text", obj,
             WORK / f"{label}-{name}.text"])
    same_text = ((WORK / f"{label}-existing.text").read_bytes() ==
                 (WORK / f"{label}-inspection.text").read_bytes())
    if not same_text:
        raise RuntimeError(f"{label}: emitted text differs from preserved object")
    assembly = assembly_inventory(WORK / f"{label}.s")
    ir = ir_inventory(WORK / f"{label}.ll")
    for function in assembly:
        symbol = function["symbol"]
        function["llvm_operations"] = ir.get(symbol[1:], {})
    return {"source_sha256": sha(cwd / "src/main.cpp"),
            "existing_object_sha256": sha(existing),
            "inspection_object_sha256": sha(WORK / f"{label}.o"),
            "object_identical": sha(existing) == sha(WORK / f"{label}.o"),
            "text_identical": same_text,
            "artifacts": {suffix: sha(WORK / f"{label}.{suffix}")
                          for suffix in ("s", "ll", "o")},
            "floating_ir_operations": len(re.findall(
                r"\b(?:fadd|fsub|fmul|fdiv|frem|fptosi|fptoui|sitofp|uitofp)\b",
                (WORK / f"{label}.ll").read_text())),
            "functions": assembly}


def runtime_inventory():
    archive = SDK / "lib/libagon.a"
    mapping = (ROOT / "rally-game/bin/rally.map").read_text()
    binary = (ROOT / "rally-game/bin/rally.bin").read_bytes()
    items = {}
    for name in ("imulu", "lmulu", "idvrmu", "ldvrmu", "idivs", "ldivs"):
        source = Path("/Agon/agondev/src/lib/libclang") / (name + ".src")
        member = WORK / f"runtime-{name}.o"
        argv = [str(SDK / "bin/ez80-none-elf-ar"), "p", str(archive), name + ".o"]
        COMMANDS.append({"argv": argv, "cwd": str(ROOT)})
        member.write_bytes(subprocess.run(argv, capture_output=True, check=True).stdout)
        rebuilt = WORK / f"runtime-{name}-source.o"
        run([SDK / "bin/ez80-none-elf-as", "-march=ez80+full", source, "-o", rebuilt])
        for label, obj in (("archive", member), ("source", rebuilt)):
            run([OBJCOPY, "-O", "binary", "--only-section=.text", obj,
                 WORK / f"runtime-{name}-{label}.text"])
        text = (WORK / f"runtime-{name}-archive.text").read_bytes()
        item = {"source_sha256": sha(source), "archive_text_sha256":
                hashlib.sha256(text).hexdigest(), "bytes": len(text),
                "source_text_matches_archive": text == (WORK / f"runtime-{name}-source.text").read_bytes()}
        # These four routines have no relocations; compare to the actual game.
        if name in ("imulu", "lmulu", "idvrmu", "ldvrmu"):
            match = re.search(r" \.text\s+(0x[0-9a-f]+)\s+0x[0-9a-f]+ .*libagon\.a\("
                              + name + r"\.o\)", mapping)
            assert match, name
            offset = int(match[1], 16) - 0x40000
            item["text_matches_preserved_binary"] = binary[offset:offset + len(text)] == text
            assert item["text_matches_preserved_binary"], name
        assert item["source_text_matches_archive"], name
        items[name] = item
    return {"archive_sha256": sha(archive), "helpers": items}


def main():
    WORK.mkdir(exist_ok=True)
    manifest_path = ROOT / "rally-game/bin/build.json"
    manifest = json.loads(manifest_path.read_text())
    assert manifest["flags"] == "", "Expected ordinary standard game"
    for path, expected in manifest["inputs"].items():
        assert sha(ROOT / path) == expected, path
    assert sha(ROOT / "rally-game/bin/rally.bin") == manifest["sha256"]
    native = ROOT / "docs/tasks/RALLY-25/full-scene"
    native_build = native / ".work/build"
    # Existing fixture sources are inspected, not regenerated by its build.py.
    protected = [ROOT / p for p in manifest["inputs"]]
    protected += [manifest_path, *(ROOT / "rally-game/bin").glob("rally*"),
                  *(ROOT / "rally-game/obj").glob("*.o")]
    protected += [p for p in native.rglob("*") if p.is_file()
                  and not p.is_symlink() and "__pycache__" not in p.parts]
    protected = sorted(set(protected))
    before = {str(p.relative_to(ROOT)): sha(p) for p in protected}
    result = {"schema": 1, "task": "MATH-001-01", "date": "2026-10-14",
              "kind": "static source/compiler audit; no runtime timing",
              "compiler": run([CC, "--version"]), "compiler_sha256": sha(CC),
              "standard_manifest_sha256": sha(manifest_path),
              "standard_binary_sha256": manifest["sha256"],
              "standard_manifest_inputs_verified": len(manifest["inputs"])}
    macros = run([CC, *flags(), "-x", "c++", "-dM", "-E", "-"], stdin="")
    wanted = ("__SIZEOF_", "__INT_WIDTH__", "__LONG_WIDTH__", "__SHRT_WIDTH__",
              "__INT24_TYPE__", "__INT32_TYPE__", "__UINT24_TYPE__", "__UINT32_TYPE__")
    result["abi_macros"] = dict((m[1], m[2]) for line in macros.splitlines()
        if (m := re.match(r"#define (\S+) (.*)", line)) and m[1].startswith(wanted))
    result["standard"] = compile_source("standard", ROOT / "rally-game",
        ["-I../rally-production/include"], ROOT / "rally-game/obj/main.o")
    result["custom_ez80"] = compile_source("custom", native_build,
        ["-I" + str(ROOT / "rally-game/include"),
         "-I" + str(ROOT / "rally-production/include"),
         "-Wno-unused-function", "-Wno-unused-variable"], native_build / "obj/main.o")
    # Diagnostic ABI expressions, not game candidates or benchmark programs.
    probe = WORK / "abi.cpp"
    probe.write_text('#include <stdint.h>\n'
        'extern "C" int promoted16(uint16_t a,uint16_t b){return a*b;}\n'
        'extern "C" int native24(int a,int b){return a*b;}\n'
        'extern "C" int32_t wide32(int32_t a,int32_t b){return a*b;}\n')
    run([CC, *flags(), *cpp_flags(), probe, "-S", "-emit-llvm", "-o", WORK / "abi.ll"])
    run([CC, *flags(), *cpp_flags(), probe, "-S", "-o", WORK / "abi.s"])
    result["abi_probe_operations"] = ir_inventory(WORK / "abi.ll")
    result["abi_probe_assembly"] = assembly_inventory(WORK / "abi.s")
    result["runtime"] = runtime_inventory()
    sampler = next(f for f in result["standard"]["functions"]
                   if f["name"].startswith("rally::trackSample("))
    assert sampler["helper_sites"]["__lmulu"] == 4
    assert sampler["llvm_operations"]["mul i32"] == 4
    result["source_derived_counts"] = {
        "kind": "loop/source deductions checked against emitted code, not a runtime trace",
        "projected_rows_per_frame": 121,
        "wide_multiplies_in_dense_row_work_per_frame": 121 * (4 + 3),
        "wide_multiplies_for_unused_ahead_tangents_per_frame": 121 * 2,
        "wide_divides_in_dense_row_work_per_frame": 121 * 2,
        "wide_stripe_remainders_per_frame": 224 - 116 + 1,
        "identical_full_fraction_camera_samples_per_frame": 3,
        "attract_driver_track_samples_per_frame": 2 + 9 * 2,
        "road_material_quads_per_band": [4, 5],
        "strip_wide_centre_divides_per_quad": 2,
        "strip_native24_edge_multiplies_and_divides_per_quad": [4, 4],
    }
    track_text = (ROOT / "rally-production/include/track.hpp").read_text()
    result["track_table_ranges"] = {}
    for name, body in re.findall(r"static const TrackPoint (\w+)\[\d+\] = \{(.*?)\n\};",
                                 track_text, re.S):
        points = [tuple(map(int, m)) for m in re.findall(
            r"\{\s*(-?\d+),\s*(-?\d+),\s*(-?\d+),\s*(-?\d+)\s*\}", body)]
        result["track_table_ranges"][name] = {
            "count": len(points), "fields": ["x", "y", "tx", "ty"],
            "ranges": [[min(p[i] for p in points), max(p[i] for p in points)]
                       for i in range(4)],
            "max_adjacent_delta": [max(abs(p[i] - points[(j + 1) % len(points)][i])
                                       for j, p in enumerate(points)) for i in range(4)]}
    runtime = Path("/Agon/agondev/src/lib/libclang")
    refs = [runtime / (name + ".src") for name in
            ("imulu", "lmulu", "idivs", "ldivs", "idvrmu", "ldvrmu")]
    refs += [Path("/Agon/agondev/src/lib/libvdp/vdp_swap.c"),
             SDK / "config/makefile.inc", SDK / "include/stdint.h"]
    result["toolchain_references"] = {str(p): sha(p) for p in refs}
    after = {str(p.relative_to(ROOT)): sha(p) for p in protected}
    assert after == before, "Preserved input or artifact changed during audit"
    result["protected_files"] = before
    result["protected_file_count"] = len(before)
    result["protected_files_unchanged"] = True
    result["commands"] = COMMANDS
    (HERE / "AUDIT.json").write_text(json.dumps(result, indent=2) + "\n")
    print(json.dumps({"standard_text_identical": result["standard"]["text_identical"],
        "custom_text_identical": result["custom_ez80"]["text_identical"],
        "protected_files_unchanged": len(before), "receipt": str(HERE / "AUDIT.json")}))


if __name__ == "__main__":
    main()
