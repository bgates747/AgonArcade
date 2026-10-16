"""Finish authorized sequential qualification after the bounded parent campaign."""
import os,time,subprocess
from pathlib import Path
ROOT=Path(__file__).resolve().parent.parents[5]
# Exact active owned campaign PID is supplied explicitly; do not touch it.
import sys
pid=int(sys.argv[1])
while Path('/proc') .joinpath(str(pid)).exists():time.sleep(1)
subprocess.run([str(ROOT/'.venv/bin/python'),str(Path(__file__).with_name('sparse_control.py'))],check=True,cwd=ROOT)
subprocess.run([str(ROOT/'.venv/bin/python'),str(Path(__file__).with_name('short_probes.py'))],check=True,cwd=ROOT)
subprocess.run([str(ROOT/'.venv/bin/python'),str(Path(__file__).parent.parent/'SPAN-001-09/physics_run.py')],check=True,cwd=ROOT)
