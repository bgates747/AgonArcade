#!/usr/bin/env python3
"""Reproduce the task-local host generator and retain input/data identities."""
from pathlib import Path
import hashlib
import json
import subprocess

TASK = Path(__file__).resolve().parent
ROOT = TASK.parents[2]


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def main():
    work = TASK / ".work"
    data = TASK / "data"
    work.mkdir(exist_ok=True)
    data.mkdir(exist_ok=True)
    binary = work / "generate_road"
    command = ["clang++", "-O3", "-std=c++17", "-Wall", "-Wextra", "-Werror",
               "-I", str(ROOT / "rally/include"), "-I", str(TASK),
               str(TASK / "generate_road.cpp"), "-o", str(binary)]
    subprocess.run(command, check=True)
    result = subprocess.run([str(binary), str(data)], check=True, text=True, capture_output=True)
    print(result.stdout, end="")
    inputs = [ROOT / "rally/include/track.hpp", ROOT / "rally/include/road.hpp",
              TASK / "generate_road.cpp", TASK / "generate_road.py", TASK / "lookup_format.hpp"]
    manifest = {"format_version": 1, "generator_command": command,
                "inputs": {str(p.relative_to(ROOT)): digest(p) for p in inputs},
                "files": {p.name: {"sha256": digest(p), "bytes": p.stat().st_size}
                          for p in sorted(data.glob("*.road"))},
                "generation_output": result.stdout}
    (data / "manifest.json").write_text(json.dumps(manifest, indent=2) + "\n")


if __name__ == "__main__":
    main()
