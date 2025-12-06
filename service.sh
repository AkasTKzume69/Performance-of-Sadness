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
POS_AI="/data/adb/modules/pos/scripts/pos_ai.sh"
CPU_Restore="/data/adb/modules/pos/scripts/pos_veux__auto_generated_cpu.sh"
GPU_Restore="/data/adb/modules/pos/scripts/pos_veux__auto_generated_gpu.sh"
IO_Restore="/data/adb/modules/pos/scripts/pos_veux__auto_generated_io.sh"
Thermal_Restore="/data/adb/modules/pos/scripts/pos_veux__auto_generated_thermal.sh"
Thermal_Disable_Restore="/data/adb/modules/pos/scripts/pos_veux__auto_generated_thermal_disable.sh"
User_Apps="/data/adb/modules/pos/scripts/pos_veux__auto_generated_user-apps.sh"

# --- Wait until device fully boot ---
sleep 20

# --- Set permissions ---
chmod 777 "$UFS_Checker"
chmod 777 "$CPU_Restore"
chmod 777 "$GPU_Restore"
chmod 777 "$IO_Restore"
chmod 777 "$Thermal_Restore"
chmod 777 "$Thermal_Disable_Restore"
chmod 777 "$User_Apps"
chmod 777 "$POS_AI"

# --- Execute Scripts Sequentially ---
su -c "$CPU_Restore"
su -c "$GPU_Restore"
su -c "$IO_Restore"
su -c "$Thermal_Restore"
su -c "$Thermal_Disable_Restore"
su -c "$User_Apps"
# --- Only proceed when All is done ---
su -c "$POS_AI"

# --- Exit to prevent further execution ---
exit 0
