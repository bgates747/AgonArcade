"""Compare actual C++ interpreter output with the independent Python planner."""
import subprocess
from generate_routes import ROOT, cycle

actual = subprocess.check_output([str(ROOT/'bin/traffic-test'), 'replay'], text=True)
expected = ''.join(','.join(map(str,row))+'\n' for row in cycle())
assert actual == expected, 'C++ and independent Python route replay differ'
print('All 600 route ticks agree exactly between Python and C++')
