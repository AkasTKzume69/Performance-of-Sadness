#!/system/bin/sh
# ====================================
# Performance of Sadness
# Copyright (C) 2025  AkasTKzume
#
# This script is part of the "Performance of Sadness" project.
# Unauthorized copying, modification, or distribution of this file,
# via any medium, is strictly prohibited without prior permission.
#
# Licensed under the GNU General Public License v3.0 (GPLv3)
# Author: AkasTKzume
# ====================================
# Main Variables
# ====================================
CPU="/sys/devices/system/cpu"
CPUP="/sys/devices/system/cpu/cpufreq"
POL0="$CPUP/policy0"
POL6="$CPUP/policy6"

# ====================================
# Policy 0  (Little Cluster)
# ====================================
# --- Governor ---
if [ -f "$POL0/scaling_governor" ]; then
    echo performance > $POL0/scaling_governor
fi

# --- Frequencies ---
if [ -f "$POL0/scaling_min_freq" ]; then
    echo 1804800 > $POL0/scaling_min_freq
fi

if [ -f "$POL0/scaling_max_freq" ]; then
    echo 1804800 > $POL0/scaling_max_freq
fi

# --- Hispeed ---
if [ -f "$POL0/hispeed_freq" ]; then
    echo 1804800 > $POL0/hispeed_freq
fi

if [ -f "$POL0/hispeed_load" ]; then
    echo 0 > $POL0/hispeed_load
fi

# --- Boost ---
if [ -f "$POL0/boost" ]; then
    echo 0 > $POL0/boost
fi

if [ -f "$POL0/boostpulse" ]; then
    echo 0 > $POL0/boostpulse
fi

# --- Idle States ---
if [ -f "$POL0/cpu0/cpuidle/state0/disable" ]; then
    echo 1 > $POL0/cpu0/cpuidle/state0/disable
fi

if [ -f "$POL0/cpu0/cpuidle/state1/disable" ]; then
    echo 1 > $POL0/cpu0/cpuidle/state1/disable
fi

# ====================================
# Policy 6  (Big Cluster)
# ====================================
# --- Governor ---
if [ -f "$POL6/scaling_governor" ]; then
    echo performance > $POL6/scaling_governor
fi

# --- Frequencies ---
if [ -f "$POL6/scaling_min_freq" ]; then
    echo 2208000 > $POL6/scaling_min_freq
fi

if [ -f "$POL6/scaling_max_freq" ]; then
    echo 2208000 > $POL6/scaling_max_freq
fi

# --- Hispeed ---
if [ -f "$POL6/hispeed_freq" ]; then
    echo 2208000 > $POL6/hispeed_freq
fi

if [ -f "$POL6/hispeed_load" ]; then
    echo 0 > $POL6/hispeed_load
fi

# --- Boost ---
if [ -f "$POL6/boost" ]; then
    echo 0 > $POL6/boost
fi

if [ -f "$POL6/boostpulse" ]; then
    echo 0 > $POL6/boostpulse
fi

# --- Idle States ---
if [ -f "$POL6/cpu6/cpuidle/state0/disable" ]; then
    echo 1 > $POL6/cpu6/cpuidle/state0/disable
fi

if [ -f "$POL6/cpu6/cpuidle/state1/disable" ]; then
    echo 1 > $POL6/cpu6/cpuidle/state1/disable
fi

# ====================================
# Global CPU Settings
# ====================================
# --- Bring all cores online ---
if [ -f "$CPU/cpu0/online" ]; then echo 1 > $CPU/cpu0/online; fi
if [ -f "$CPU/cpu1/online" ]; then echo 1 > $CPU/cpu1/online; fi
if [ -f "$CPU/cpu2/online" ]; then echo 1 > $CPU/cpu2/online; fi
if [ -f "$CPU/cpu3/online" ]; then echo 1 > $CPU/cpu3/online; fi
if [ -f "$CPU/cpu4/online" ]; then echo 1 > $CPU/cpu4/online; fi
if [ -f "$CPU/cpu5/online" ]; then echo 1 > $CPU/cpu5/online; fi
if [ -f "$CPU/cpu6/online" ]; then echo 1 > $CPU/cpu6/online; fi
if [ -f "$CPU/cpu7/online" ]; then echo 1 > $CPU/cpu7/online; fi

# --- Scheduler Tweaks ---
if [ -f "/proc/sys/kernel/sched_rt_runtime_us" ]; then
    echo -1 > /proc/sys/kernel/sched_rt_runtime_us
fi

if [ -f "/proc/sys/kernel/sched_min_granularity_ns" ]; then
    echo 10000 > /proc/sys/kernel/sched_min_granularity_ns
fi

if [ -f "/proc/sys/kernel/sched_wakeup_granularity_ns" ]; then
    echo 10000 > /proc/sys/kernel/sched_wakeup_granularity_ns
fi

# --- Autosleep Off ---
if [ -f "/sys/power/autosleep" ]; then
    echo disabled > /sys/power/autosleep
fi

# ====================================
# Thermal Controllers
# ====================================
# --- CPU USR zones ---
if [ -f "/sys/class/thermal/thermal_zone16/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone16/mode
fi
if [ -f "/sys/class/thermal/thermal_zone17/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone17/mode
fi
if [ -f "/sys/class/thermal/thermal_zone18/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone18/mode
fi
if [ -f "/sys/class/thermal/thermal_zone19/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone19/mode
fi
if [ -f "/sys/class/thermal/thermal_zone20/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone20/mode
fi
if [ -f "/sys/class/thermal/thermal_zone21/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone21/mode
fi
if [ -f "/sys/class/thermal/thermal_zone22/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone22/mode
fi
if [ -f "/sys/class/thermal/thermal_zone23/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone23/mode
fi
if [ -f "/sys/class/thermal/thermal_zone24/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone24/mode
fi
if [ -f "/sys/class/thermal/thermal_zone25/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone25/mode
fi
if [ -f "/sys/class/thermal/thermal_zone26/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone26/mode
fi
if [ -f "/sys/class/thermal/thermal_zone27/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone27/mode
fi

# --- CPU STEP zones ---
if [ -f "/sys/class/thermal/thermal_zone41/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone41/mode
fi
if [ -f "/sys/class/thermal/thermal_zone42/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone42/mode
fi
if [ -f "/sys/class/thermal/thermal_zone43/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone43/mode
fi
if [ -f "/sys/class/thermal/thermal_zone44/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone44/mode
fi
if [ -f "/sys/class/thermal/thermal_zone45/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone45/mode
fi
if [ -f "/sys/class/thermal/thermal_zone46/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone46/mode
fi
if [ -f "/sys/class/thermal/thermal_zone47/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone47/mode
fi
if [ -f "/sys/class/thermal/thermal_zone48/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone48/mode
fi
if [ -f "/sys/class/thermal/thermal_zone49/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone49/mode
fi
if [ -f "/sys/class/thermal/thermal_zone50/mode" ]; then
    echo disabled > /sys/class/thermal/thermal_zone50/mode
fi

exit 0
