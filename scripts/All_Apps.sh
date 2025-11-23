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

# Main Variables
ALL_APPS="/data/adb/modules/pos/scripts/all-apps.pos"
TMP_FILE="/data/adb/modules/pos/scripts/all-apps.tmp"

# Create tmp folder if missing
mkdir -p "$(dirname "$ALL_APPS")"

# Delete existing ALL_APPS if present
[ -f "$ALL_APPS" ] && rm -f "$ALL_APPS"

# Step 1: List all user packages
pm list packages -3 | sed 's/package://g' > "$TMP_FILE"

# Step 2: Save to ALL_APPS safely
while read -r pkg; do
    echo "$pkg" >> "$ALL_APPS"
done < "$TMP_FILE"

# Step 3: Cleanup
rm -f "$TMP_FILE"

# Done
wc -l "$ALL_APPS"
