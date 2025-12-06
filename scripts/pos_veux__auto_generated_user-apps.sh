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
User_Apps="/data/adb/modules/pos/scripts/user-apps.pos"
TMP_FILE="/data/adb/modules/pos/scripts/user-apps.tmp"

# --- Create tmp folder if missing ---
mkdir -p "$(dirname "$User_Apps")"

# --- Delete existing User Apps if present ---
[ -f "$User_Apps" ] && rm -f "$User_Apps"

# --- List all user packages ---
pm list packages -3 | sed 's/package://g' > "$TMP_FILE"

# --- Save to User Apps safely ---
while read -r pkg; do
    echo "$pkg" >> "$User_Apps"
done < "$TMP_FILE"

# --- Cleanup ---
rm -f "$TMP_FILE"

# --- Done ---
wc -l "$User_Apps"

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
