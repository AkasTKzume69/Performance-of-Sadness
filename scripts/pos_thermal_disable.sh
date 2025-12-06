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

# --- Function: Disable thermal zone safely ---
disable_zone() {
    ZONE="/sys/class/thermal/thermal_zone$1/mode"
    if [ -f "$ZONE" ]; then
        echo disabled > "$ZONE"
    fi
}

# ====================================
# CPU USR Thermal Zones (16–27)
# ====================================
for Z in 16 17 18 19 20 21 22 23 24 25 26 27; do
    disable_zone "$Z"
done

# ====================================
# CPU STEP Thermal Zones (41–50)
# ====================================
for Z in 41 42 43 44 45 46 47 48 49 50; do
    disable_zone "$Z"
done

# ====================================
# Touch / Skin Temperature Zones
# (Common touch-panel thermals)
# ====================================
for Z in 5 6 7 8 9 10 11 12 13 14 15; do
    disable_zone "$Z"
done

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
