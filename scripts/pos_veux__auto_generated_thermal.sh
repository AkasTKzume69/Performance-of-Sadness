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
RESTORE_FILE="$RESTORE_DIR/restore_thermal.sh"
CPU_PATH="/sys/devices/system/cpu"
THERMAL_ZONES="/sys/class/thermal"
COOLING_DEVICES="/sys/class/thermal"

mkdir -p "$RESTORE_DIR"

# ====================================
# Write restore header
# ====================================
cat <<'EOF' > "$RESTORE_FILE"
#!/system/bin/sh
# ====================================
# Auto-generated Thermal Restore Script
# Created by Performance of Sadness AI
# ====================================

# --- Restart stock thermal daemons ---
thermal-engine &
vendor.thermal-engine &
mi_thermald &

sleep 1
EOF


# ====================================
# 1. Restore cooling_device cur_state
# ====================================
for cdev in $COOLING_DEVICES/cooling_device*/cur_state; do
    if [ -f "$cdev" ]; then
        val=$(cat "$cdev" 2>/dev/null)

        echo "" >> "$RESTORE_FILE"
        echo "# Restore $cdev" >> "$RESTORE_FILE"
        echo "echo $val > $cdev 2>/dev/null" >> "$RESTORE_FILE"
    fi
done


# ====================================
# Restore ALL trip points
# ====================================
for trip in $THERMAL_ZONES/thermal_zone*/trip_point_*_temp; do
    if [ -f "$trip" ]; then
        val=$(cat "$trip" 2>/dev/null)

        echo "" >> "$RESTORE_FILE"
        echo "# Restore $trip" >> "$RESTORE_FILE"
        echo "echo $val > $trip 2>/dev/null" >> "$RESTORE_FILE"
    fi
done


# ====================================
# Restore CPU scaling_max_freq locks
# ====================================
for cpu in $(seq 0 7); do
    FREQ_PATH="$CPU_PATH/cpu$cpu/cpufreq/scaling_max_freq"
    if [ -f "$FREQ_PATH" ]; then

        old=$(cat "$FREQ_PATH" 2>/dev/null)

        {
            echo ""
            echo "# Restore CPU$cpu max freq"
            echo "chmod 644 $FREQ_PATH"
            echo "echo $old > $FREQ_PATH 2>/dev/null"
            echo "chmod 444 $FREQ_PATH"
        } >> "$RESTORE_FILE"

    fi
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
