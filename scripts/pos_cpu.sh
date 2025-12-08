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
PROP="/sdcard/POS.prop"

# ====================================
# Trim helper
# ====================================
_trim() {
    echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# ====================================
# Load CPU Tweaks From POS.prop (Fast Method)
# ====================================

MIN_L=""
MAX_L=""
MIN_B=""
MAX_B=""
GOV=""

if [ -f "$PROP" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        line=$(_trim "$line")

        case "$line" in
            ""|\#*) continue ;;
        esac

        key="${line%%=*}"
        value="${line#*=}"

        key=$(_trim "$key")
        value=$(_trim "$value")

        case "$value" in
            \"*\" )
                value="${value#\"}"
                value="${value%\"}"
                ;;
            \'*\' )
                value="${value#\'}"
                value="${value%\'}"
                ;;
        esac

        case "$key" in
            pos_cpu_tweak_min_freq_l) MIN_L="$value" ;;
            pos_cpu_tweak_max_freq_l) MAX_L="$value" ;;
            pos_cpu_tweak_min_freq_b) MIN_B="$value" ;;
            pos_cpu_tweak_max_freq_b) MAX_B="$value" ;;
            pos_cpu_tweak_governor)   GOV="$value" ;;
        esac

    done < "$PROP"
fi

# ====================================
# Default fallback values
# ====================================

[ -z "$MIN_L" ] && MIN_L=576000
[ -z "$MIN_B" ] && MIN_B=691200
[ -z "$MAX_L" ] && MAX_L=1804800
[ -z "$MAX_B" ] && MAX_B=2208000
[ -z "$GOV" ] && GOV="schedutil"

case "$GOV" in
    performance|schedutil|ondemand|interactive) ;; 
    *) GOV="performance" ;;
esac

# ====================================
# Apply CPU Governor
# ====================================

[ -f "$POL0/scaling_governor" ] && echo "$GOV" > "$POL0/scaling_governor"
[ -f "$POL6/scaling_governor" ] && echo "$GOV" > "$POL6/scaling_governor"

# ====================================
# Policy 0 — LITTLE Cluster (0–5)
# ====================================

[ -f "$POL0/scaling_min_freq" ] && echo "$MIN_L" > "$POL0/scaling_min_freq"
[ -f "$POL0/scaling_max_freq" ] && echo "$MAX_L" > "$POL0/scaling_max_freq"
[ -f "$POL0/hispeed_freq" ] && echo "$MAX_L" > "$POL0/hispeed_freq"
[ -f "$POL0/hispeed_load" ] && echo 0 > "$POL0/hispeed_load"
[ -f "$POL0/boost" ] && echo 0 > "$POL0/boost"
[ -f "$POL0/boostpulse" ] && echo 0 > "$POL0/boostpulse"

for S in 0 1; do
    [ -f "$POL0/cpu0/cpuidle/state$S/disable" ] && echo 1 > "$POL0/cpu0/cpuidle/state$S/disable"
done

# ====================================
# Policy 6 — BIG Cluster (6–7)
# ====================================

[ -f "$POL6/scaling_min_freq" ] && echo "$MIN_B" > "$POL6/scaling_min_freq"
[ -f "$POL6/scaling_max_freq" ] && echo "$MAX_B" > "$POL6/scaling_max_freq"
[ -f "$POL6/hispeed_freq" ] && echo "$MAX_B" > "$POL6/hispeed_freq"
[ -f "$POL6/hispeed_load" ] && echo 0 > "$POL6/hispeed_load"
[ -f "$POL6/boost" ] && echo 0 > "$POL6/boost"
[ -f "$POL6/boostpulse" ] && echo 0 > "$POL6/boostpulse"

for S in 0 1; do
    [ -f "$POL6/cpu6/cpuidle/state$S/disable" ] && echo 1 > "$POL6/cpu6/cpuidle/state$S/disable"
done

# ====================================
# Apply Min/Max to All Cores
# ====================================

for CORE in 0 1 2 3 4 5; do
    if [ -d "$CPU/cpu$CORE/cpufreq" ]; then
        [ -f "$CPU/cpu$CORE/cpufreq/scaling_min_freq" ] && echo "$MIN_L" > "$CPU/cpu$CORE/cpufreq/scaling_min_freq"
        [ -f "$CPU/cpu$CORE/cpufreq/scaling_max_freq" ] && echo "$MAX_L" > "$CPU/cpu$CORE/cpufreq/scaling_max_freq"
    fi
done

for CORE in 6 7; do
    if [ -d "$CPU/cpu$CORE/cpufreq" ]; then
        [ -f "$CPU/cpu$CORE/cpufreq/scaling_min_freq" ] && echo "$MIN_B" > "$CPU/cpu$CORE/cpufreq/scaling_min_freq"
        [ -f "$CPU/cpu$CORE/cpufreq/scaling_max_freq" ] && echo "$MAX_B" > "$CPU/cpu$CORE/cpufreq/scaling_max_freq"
    fi
done

# ====================================
# Global CPU Settings
# ====================================

for CORE in 0 1 2 3 4 5 6 7; do
    [ -f "$CPU/cpu$CORE/online" ] && echo 1 > "$CPU/cpu$CORE/online"
done

[ -f "/proc/sys/kernel/sched_rt_runtime_us" ] && echo -1 > /proc/sys/kernel/sched_rt_runtime_us
[ -f "/proc/sys/kernel/sched_min_granularity_ns" ] && echo 10000 > /proc/sys/kernel/sched_min_granularity_ns
[ -f "/proc/sys/kernel/sched_wakeup_granularity_ns" ] && echo 10000 > /proc/sys/kernel/sched_wakeup_granularity_ns

[ -f "/sys/power/autosleep" ] && echo disabled > /sys/power/autosleep


# ====================================
# Exit to prevent further execution
# ====================================
exit 0
