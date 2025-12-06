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
RESTORE_DIR="/data/adb/modules/pos/scripts"
RESTORE_FILE="$RESTORE_DIR/restore_cpu.sh"

CPU="/sys/devices/system/cpu"
CPUP="/sys/devices/system/cpu/cpufreq"
POL0="$CPUP/policy0"
POL6="$CPUP/policy6"

mkdir -p "$RESTORE_DIR"

# ====================================
# Write restore header
# ====================================
cat <<'EOF' > "$RESTORE_FILE"
#!/system/bin/sh
# ====================================
# Auto-generated CPU restore script
# Created by Performance of Sadness AI
# ====================================
EOF

# ====================================
# List of CPU keys to back up (Policy 0 & 6)
# ====================================
CPU_KEYS_POL0="
$POL0/scaling_governor
$POL0/scaling_min_freq
$POL0/scaling_max_freq
$POL0/hispeed_freq
$POL0/hispeed_load
$POL0/boost
$POL0/boostpulse
$POL0/cpu0/cpuidle/state0/disable
$POL0/cpu0/cpuidle/state1/disable
"

CPU_KEYS_POL6="
$POL6/scaling_governor
$POL6/scaling_min_freq
$POL6/scaling_max_freq
$POL6/hispeed_freq
$POL6/hispeed_load
$POL6/boost
$POL6/boostpulse
$POL6/cpu6/cpuidle/state0/disable
$POL6/cpu6/cpuidle/state1/disable
"

CPU_CORES="
$CPU/cpu0/online
$CPU/cpu1/online
$CPU/cpu2/online
$CPU/cpu3/online
$CPU/cpu4/online
$CPU/cpu5/online
$CPU/cpu6/online
$CPU/cpu7/online
"

SCHED_KEYS="
/proc/sys/kernel/sched_rt_runtime_us
/proc/sys/kernel/sched_min_granularity_ns
/proc/sys/kernel/sched_wakeup_granularity_ns
"

POWER_KEYS="
/sys/power/autosleep
"

# ====================================
# Function: Save a key's current value
# ====================================
save_key() {
    FILE="$1"

    if [ -f "$FILE" ]; then
        val=$(cat "$FILE" 2>/dev/null)

        if [ "${#val}" -le 4096 ]; then
            {
                echo ""
                echo "# ---- Restore $FILE ----"
                echo "    echo $val > $FILE 2>/dev/null"
            } >> "$RESTORE_FILE"
        fi
    fi
}

# ====================================
# Backup all keys
# ====================================
for f in $CPU_KEYS_POL0 $CPU_KEYS_POL6 $CPU_CORES $SCHED_KEYS $POWER_KEYS; do
    save_key "$f"
done

# ====================================
# Footer
# ====================================
cat <<'EOF' >> "$RESTORE_FILE"

exit 0
EOF

chmod 755 "$RESTORE_FILE"

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
