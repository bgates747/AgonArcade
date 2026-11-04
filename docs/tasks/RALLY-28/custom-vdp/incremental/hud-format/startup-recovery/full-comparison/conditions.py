"""Read-only boundary witnesses; no emulator, control or host-setting mutation."""
from pathlib import Path
import json
import os
import socket
import subprocess
import time


def snapshot(label):
    paths={
        'boot_id':'/proc/sys/kernel/random/boot_id',
        'boost':'/sys/devices/system/cpu/cpufreq/boost',
        'online_cpus':'/sys/devices/system/cpu/online',
        'governor':'/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor',
        'cpu0_current_khz':'/sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq',
        'kernel':'/proc/sys/kernel/osrelease'}
    result=dict(label=label,host=socket.gethostname(),wall_unix_ns=time.time_ns(),
                monotonic_ns=time.monotonic_ns(),load_average=list(os.getloadavg()),
                supervisor_affinity=sorted(os.sched_getaffinity(0)),read_errors={})
    for key,name in paths.items():
        try:result[key]=Path(name).read_text().strip()
        except OSError as error:result[key]=None;result['read_errors'][key]=repr(error)
    try:
        ps=subprocess.run(['ps','-eo','pid,ppid,etimes,pcpu,comm','--sort=-pcpu'],
                          text=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,timeout=3)
        result['processes_top20']=ps.stdout.splitlines()[:21]
        result['process_list_exit']=ps.returncode
        result['process_cpu_is_lifetime_average']=True
    except (OSError,subprocess.TimeoutExpired) as error:
        result['processes_top20']=None;result['read_errors']['processes']=repr(error)
    result['boundary_not_aligned_to_guest_race_clock']=True
    return result


if __name__=='__main__':print(json.dumps(snapshot('manual-preflight'),indent=2))
