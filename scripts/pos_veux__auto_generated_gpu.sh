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
RESTORE_FILE="$RESTORE_DIR/restore_gpu.sh"
GPU="/sys/class/kgsl/kgsl-3d0"

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

# --- Base GPU keys ---
GPU_KEYS="
$GPU/force_clk_on
$GPU/force_bus_on
$GPU/force_rail_on
$GPU/force_no_nap
$GPU/max_clock_mhz
$GPU/min_clock_mhz
$GPU/thermal_pwrlevel
$GPU/min_pwrlevel
$GPU/max_pwrlevel
$GPU/default_pwrlevel
$GPU/gpu_llc_slice_enable
$GPU/skipsaverestore
$GPU/idle_timer
$GPU/wake_timeout
$GPU/wake_nice
$GPU/ft_policy
$GPU/preempt_level
$GPU/preemption
$GPU/bus_split
$GPU/hwcg
"

# --- Devfreq keys ---
DEVFREQ_KEYS=""
DEVFREQ="$GPU/devfreq"
if [ -d "$DEVFREQ" ]; then
    for df in min_freq max_freq; do
        DEVFREQ_KEYS="$DEVFREQ_KEYS $DEVFREQ/$df"
    done
fi

# --- FUNCTION: Save a key's current value ---
save_key() {
    FILE="$1"
    if [ -f "$FILE" ]; then
        val=$(cat "$FILE" 2>/dev/null)
        if [ "${#val}" -le 4096 ]; then
            {
                echo ""
                echo "# ---- Restore $FILE ----"
                echo "echo $val > $FILE 2>/dev/null"
            } >> "$RESTORE_FILE"
        fi
    fi
}

# --- Save all keys ---
for f in $GPU_KEYS $DEVFREQ_KEYS; do
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
