#!/usr/bin/env python3
"""Host road qualification; all executables/reports remain in this task."""
from pathlib import Path
import argparse
import hashlib
import json
import subprocess

TASK = Path(__file__).resolve().parent
ROOT = TASK.parents[2]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--quick", action="store_true", help="sample positions instead of exhausting every hundredth")
    args = parser.parse_args()
    work, results = TASK / ".work", TASK / "road-results"
    work.mkdir(exist_ok=True)
    results.mkdir(exist_ok=True)
    protected = [ROOT / "rally/include/track.hpp", ROOT / "rally/include/road.hpp",
                 ROOT / "rally/include/band_table.hpp", TASK.parent / "RALLY-18.md"]
    before = {str(p.relative_to(ROOT)): digest(p) for p in protected}
    commands, reports = [], []

    def run(source, name, flags, arguments, report):
        binary = work / name
        command = ["clang++", "-std=c++17", "-Wall", "-Wextra", "-Werror", *flags,
                   "-I", str(ROOT / "rally/include"), "-I", str(TASK),
                   str(TASK / source), "-o", str(binary)]
        commands.append(command)
        subprocess.run(command, check=True)
        command = [str(binary), *arguments]
        commands.append(command)
        with (results / report).open("w") as output:
            subprocess.run(command, check=True, stdout=output, stderr=subprocess.STDOUT)
        reports.append(report)

    run("test_lookup_road.cpp", "test_lookup_road", ["-O3"],
        [str(TASK / "data"), str(work), "1607" if args.quick else "1"],
        "geometry-quick.txt" if args.quick else "geometry-exhaustive.txt")
    run("test_lookup_road.cpp", "test_lookup_road_sanitized",
        ["-O1", "-g", "-fsanitize=address,undefined", "-fno-omit-frame-pointer"],
        [str(TASK / "data"), str(work), "1607"], "sanitizers.txt")
    run("size_road_candidates.cpp", "size_road_candidates", ["-O3"], [], "sizing.txt")
    after = {str(p.relative_to(ROOT)): digest(p) for p in protected}
    if after != before:
        raise RuntimeError("protected input changed during road qualification")
    inputs = list(TASK.glob("*road*.cpp")) + list(TASK.glob("*road*.hpp"))
    inputs += [TASK / "lookup_format.hpp", TASK / "section_phase.hpp", TASK / "section_protocol.hpp"]
    inputs += list((TASK / "data").glob("*.road"))
    inputs += [Path(__file__).resolve()]
    manifest = {"position_coverage": "sampled" if args.quick else "every legal hundredth position",
                "commands": commands, "protected_inputs": before,
                "inputs": {str(p.relative_to(ROOT)): digest(p) for p in sorted(inputs)},
                "reports": {name: digest(results / name) for name in reports}}
    (results / ("quick-manifest.json" if args.quick else "manifest.json")).write_text(json.dumps(manifest, indent=2) + "\n")
    print("Road qualification passed; reports in", results)


if __name__ == "__main__":
    main()
