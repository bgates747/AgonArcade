"""Compare guest scene.csv exactly with the matching host scene calculation.

Run with repository .venv/bin/python. No emulator is launched. Both live and
lookup are checked against their own host results, not against each other.
"""
from pathlib import Path
import argparse
import difflib
import hashlib
import json
import subprocess

TASK = Path(__file__).resolve().parent
REPO = TASK.parents[2]
WORK = TASK / ".work"


def sha(data):
    return hashlib.sha256(data).hexdigest()


def host_binary():
    """Rebuild when any shared calculation header changes."""
    WORK.mkdir(exist_ok=True)
    sources = [TASK / "host_scene.cpp", *sorted(TASK.glob("*.hpp")),
               *sorted((REPO / "rally/include").glob("*.hpp"))]
    identities = {str(p.relative_to(REPO)): sha(p.read_bytes()) for p in sources}
    fingerprint = sha(json.dumps(identities, sort_keys=True).encode())
    binary = WORK / "host_scene"
    stamp = WORK / "host_scene-build.json"
    if not binary.exists() or not stamp.exists() or json.loads(stamp.read_text())["source_fingerprint"] != fingerprint:
        command = ["c++", "-std=c++17", "-Wall", "-Wextra", "-Werror", "-fsanitize=address,undefined", "-g",
                   "-I" + str(REPO / "rally/include"), "-I" + str(TASK),
                   str(TASK / "host_scene.cpp"), "-o", str(binary)]
        subprocess.run(command, check=True, cwd=REPO)
        stamp.write_text(json.dumps({"source_fingerprint": fingerprint, "source_sha256": identities,
                                     "command": command, "binary_sha256": sha(binary.read_bytes())}, indent=2) + "\n")
    return binary


def compare(guest, variant, track, perspective=False, snapshot=None, data=None):
    guest = Path(guest)
    command = [str(host_binary()), "--variant", variant, "--track", track,
               "--data", str(Path(data) if data else TASK / "data")]
    if perspective:
        command.append("--perspective")
    if snapshot is not None:
        value = snapshot if isinstance(snapshot, str) else ",".join(map(str, snapshot))
        command += ["--snapshot", value]
    expected = subprocess.check_output(command, cwd=REPO)
    actual = guest.read_bytes()
    equal = actual == expected
    report = {"guest": str(guest.resolve()), "variant": variant, "track": track,
              "perspective": perspective, "snapshot": snapshot,
              "host_command": command, "exact_match": equal, "guest_sha256": sha(actual),
              "host_sha256": sha(expected), "bytes": len(actual),
              "host_build": str(WORK / "host_scene-build.json")}
    if not equal:
        report["diff"] = "".join(difflib.unified_diff(expected.decode().splitlines(keepends=True),
                                                     actual.decode().splitlines(keepends=True),
                                                     fromfile="host", tofile="guest"))
    return report


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("guest", type=Path)
    parser.add_argument("--variant", required=True, choices=("live", "lookup"))
    parser.add_argument("--track", required=True, choices=("oval", "fuji"))
    parser.add_argument("--perspective", action="store_true")
    parser.add_argument("--snapshot", metavar="POSE,LATERAL,STEERING")
    parser.add_argument("--data", type=Path, default=TASK / "data")
    parser.add_argument("--json", type=Path)
    args = parser.parse_args()
    report = compare(args.guest, args.variant, args.track, args.perspective, args.snapshot, args.data)
    if args.json:
        args.json.parent.mkdir(parents=True, exist_ok=True)
        args.json.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report, indent=2))
    raise SystemExit(0 if report["exact_match"] else 1)


if __name__ == "__main__":
    main()
