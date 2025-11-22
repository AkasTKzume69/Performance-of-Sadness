#!/system/bin/sh
# ==========================================================
# Performance of Sadness
# Copyright (C) 2025  AkasTKzume
#
# This script is part of the "Performance of Sadness" project.
# Unauthorized copying, modification, or distribution of this file,
# via any medium, is strictly prohibited without prior permission.
#
# Licensed under the GNU General Public License v3.0 (GPLv3)
# Author: AkasTKzume
# ==========================================================

# --- Main Variables ---
POS="/data/adb/modules/pos/scripts/POS.sh"
Performance_Script="/data/adb/modules/pos/scripts/perf_profile.pos"   # Replace with YOUR performance script path
Restore_Script="/data/adb/modules/pos/scripts/perf_profile_restore.pos"    # Replace with YOUR restore script path
UFS_Checker="/data/adb/modules/pos/scripts/UFS_Checker.sh"

# --- Wait until device fully boot ---
sleep 20

# --- Set permission ---
chmod 755 "$POS"
chmod 777 "$Performance_Script"
chmod 777 "$Restore_Script"
chmod 755 "$UFS_Checker"

# --- Execute Scripts ---
su -c "$POS &"
su -c "$UFS_Checker &"
