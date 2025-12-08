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
CPU_PATH="/sys/devices/system/cpu"
THERM="/sys/class/thermal/thermal_zone16/temp"
PROP_FILE="/sdcard/POS.prop"

# ====================================
# Cluster Frequencies
# ====================================
# LITTLE 0–5
LITTLE_MAX="1804800"
LITTLE_MID="1516800"
LITTLE_LOW="576000"

# BIG 6–7
BIG_MAX="2208000"
BIG_MID="1651200"
BIG_LOW="691200"

# ====================================
# Load Temperature from pos.prop
# ====================================
if [ -f "$PROP_FILE" ]; then
    RAW_TEMP=$(grep -m1 "pos_thermal_tweak_temp" "$PROP_FILE" | cut -d "=" -f2 | tr -d "°C" | tr -d " ")
    if [ -n "$RAW_TEMP" ]; then
        USER_TEMP="$RAW_TEMP"
    fi
fi

# --- Exit if Temperature from pos.prop missing ---
if [ -z "$USER_TEMP" ]; then
    exit 1
fi

# ====================================
# Calculate thresholds
# ====================================
COOL_LIMIT=$USER_TEMP
MID_LIMIT=$((USER_TEMP + 3))
HOT_LIMIT=$((MID_LIMIT + 2))

# ====================================
# Disable User-Space Thermal
# ====================================
killall thermal-engine 2>/dev/null
killall vendor.thermal-engine 2>/dev/null
killall mi_thermald 2>/dev/null

for cdev in /sys/class/thermal/cooling_device*/cur_state; do
    echo 0 > "$cdev" 2>/dev/null
done

for trip in /sys/class/thermal/thermal_zone*/trip_point_*_temp; do
    echo 95000 > "$trip" 2>/dev/null
done

# ====================================
# Thermal Controller
# ====================================
while true; do
    TEMP=$(cat "$THERM")
    TEMP=$((TEMP / 1000))

    # --- Decide target frequency level ---
    if [ "$TEMP" -lt "$COOL_LIMIT" ]; then
        LITTLE_TARGET="$LITTLE_MAX"
        BIG_TARGET="$BIG_MAX"

    elif [ "$TEMP" -ge "$COOL_LIMIT" ] && [ "$TEMP" -lt "$MID_LIMIT" ]; then
        LITTLE_TARGET="$LITTLE_MID"
        BIG_TARGET="$BIG_MID"

    else
        LITTLE_TARGET="$LITTLE_LOW"
        BIG_TARGET="$BIG_LOW"
    fi

    # --- Apply LITTLE cores (0–5) ---
    for cpu in $(seq 0 5); do
        FREQ_PATH="$CPU_PATH/cpu$cpu/cpufreq/scaling_max_freq"
        chmod 644 "$FREQ_PATH"
        echo "$LITTLE_TARGET" > "$FREQ_PATH" 2>/dev/null
        chmod 444 "$FREQ_PATH"
    done

    # --- Apply BIG cores (6–7) ---
    for cpu in 6 7; do
        FREQ_PATH="$CPU_PATH/cpu$cpu/cpufreq/scaling_max_freq"
        chmod 644 "$FREQ_PATH"
        echo "$BIG_TARGET" > "$FREQ_PATH" 2>/dev/null
        chmod 444 "$FREQ_PATH"
    done

    sleep 1
done
