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
GPU="/sys/class/kgsl/kgsl-3d0"

# --- Force GPU awake ---
echo 1 > $GPU/force_clk_on
echo 1 > $GPU/force_bus_on
echo 1 > $GPU/force_rail_on
echo 1 > $GPU/force_no_nap

# --- Lock GPU at max frequency ---
if [ -f "$GPU/max_clock_mhz" ]; then
    echo 840 > $GPU/max_clock_mhz
fi

# --- Devfreq max/min capping ---
if [ -d "$GPU/devfreq" ]; then
    echo 840000000 > $GPU/devfreq/min_freq 2>/dev/null
    echo 840000000 > $GPU/devfreq/max_freq 2>/dev/null
fi

if [ -f "$GPU/min_clock_mhz" ]; then
    echo 840 > $GPU/min_clock_mhz
fi

# --- Set pwrlevel to maximum performance ---
if [ -f "$GPU/min_pwrlevel" ]; then
    echo 0 > $GPU/min_pwrlevel
fi

if [ -f "$GPU/max_pwrlevel" ]; then
    echo 0 > $GPU/max_pwrlevel
fi

if [ -f "$GPU/default_pwrlevel" ]; then
    echo 0 > $GPU/default_pwrlevel
fi

# --- Ensure thermal logic cannot override the power level. ---
if [ -f "$GPU/thermal_pwrlevel" ]; then
    echo 0 > $GPU/thermal_pwrlevel
fi

# --- Enable L3 Cache Boost ---
if [ -f "$GPU/gpu_llc_slice_enable" ]; then
    echo 1 > $GPU/gpu_llc_slice_enable
fi

# --- Disable all GPU Idle / Sleep ---
if [ -f "$GPU/skipsaverestore" ]; then
    echo 0 > $GPU/skipsaverestore
fi

if [ -f "$GPU/idle_timer" ]; then
    echo 0 > $GPU/idle_timer
fi

if [ -f "$GPU/wake_timeout" ]; then
    echo 0 > $GPU/wake_timeout
fi

# --- Keep GPU Active ---
if [ -f "$GPU/wake_nice" ]; then
    echo -1 > $GPU/wake_nice
fi

# --- Relax FT Policy for extreme FPS ---
if [ -f "$GPU/ft_policy" ]; then
    echo 0x00 > $GPU/ft_policy
fi

# --- Force immediate preempt mode ---
if [ -f "$GPU/preempt_level" ]; then
    echo 2 > $GPU/preempt_level
fi

if [ -f "$GPU/preemption" ]; then
    echo 1 > $GPU/preemption
fi

#if [ -f "$GPU/preempt_count" ]; then
#    echo 1 > $GPU/preempt_count
#fi

# --- Bandwidth Boost ---
#if [ -f "$GPU/popp" ]; then
#    echo 1 > $GPU/popp
#fi

if [ -f "$GPU/bus_split" ]; then
    echo 1 > $GPU/bus_split
fi

# --- Disable HWCG ---
if [ -f "$GPU/hwcg" ]; then
    echo 0 > $GPU/hwcg
fi

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
