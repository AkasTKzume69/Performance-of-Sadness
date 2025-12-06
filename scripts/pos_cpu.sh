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
    echo performance > "$POL0/scaling_governor"
fi

# --- Frequencies ---
if [ -f "$POL0/scaling_min_freq" ]; then
    echo 1804800 > "$POL0/scaling_min_freq"
fi

if [ -f "$POL0/scaling_max_freq" ]; then
    echo 1804800 > "$POL0/scaling_max_freq"
fi

# --- Hispeed ---
if [ -f "$POL0/hispeed_freq" ]; then
    echo 1804800 > "$POL0/hispeed_freq"
fi

if [ -f "$POL0/hispeed_load" ]; then
    echo 0 > "$POL0/hispeed_load"
fi

# --- Boost ---
if [ -f "$POL0/boost" ]; then
    echo 0 > "$POL0/boost"
fi

if [ -f "$POL0/boostpulse" ]; then
    echo 0 > "$POL0/boostpulse"
fi

# --- Idle States ---
if [ -f "$POL0/cpu0/cpuidle/state0/disable" ]; then
    echo 1 > "$POL0/cpu0/cpuidle/state0/disable"
fi

if [ -f "$POL0/cpu0/cpuidle/state1/disable" ]; then
    echo 1 > "$POL0/cpu0/cpuidle/state1/disable"
fi

# ====================================
# Policy 6  (Big Cluster)
# ====================================

# --- Governor ---
if [ -f "$POL6/scaling_governor" ]; then
    echo performance > "$POL6/scaling_governor"
fi

# --- Frequencies ---
if [ -f "$POL6/scaling_min_freq" ]; then
    echo 2208000 > "$POL6/scaling_min_freq"
fi

if [ -f "$POL6/scaling_max_freq" ]; then
    echo 2208000 > "$POL6/scaling_max_freq"
fi

# --- Hispeed ---
if [ -f "$POL6/hispeed_freq" ]; then
    echo 2208000 > "$POL6/hispeed_freq"
fi

if [ -f "$POL6/hispeed_load" ]; then
    echo 0 > "$POL6/hispeed_load"
fi

# --- Boost ---
if [ -f "$POL6/boost" ]; then
    echo 0 > "$POL6/boost"
fi

if [ -f "$POL6/boostpulse" ]; then
    echo 0 > "$POL6/boostpulse"
fi

# --- Idle States ---
if [ -f "$POL6/cpu6/cpuidle/state0/disable" ]; then
    echo 1 > "$POL6/cpu6/cpuidle/state0/disable"
fi

if [ -f "$POL6/cpu6/cpuidle/state1/disable" ]; then
    echo 1 > "$POL6/cpu6/cpuidle/state1/disable"
fi

# ====================================
# Global CPU Settings
# ====================================

# --- Bring all cores online ---
for CORE in 0 1 2 3 4 5 6 7; do
    if [ -f "$CPU/cpu$CORE/online" ]; then
        echo 1 > "$CPU/cpu$CORE/online"
    fi
done

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
# Exit to prevent further execution
# ====================================
exit 0
