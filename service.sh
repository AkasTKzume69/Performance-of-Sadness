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
POS="/data/adb/modules/performance-of-sadness/POS/POS.sh"

# --- Wait until device fully boot ---
sleep 20

# --- Set permission ---
chmod 755 "$POS"

# --- Execute Performance of Sadness AI ---
su -c "$POS &"
