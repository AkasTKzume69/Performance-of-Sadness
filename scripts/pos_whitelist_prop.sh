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
POS_PROP="/sdcard/POS.prop"
WHITE_LIST="/sdcard/POS_Whitelist.prop"

# Default
pos_whitelist_prop="false"

# Trim helper
_trim() {
    echo "$1" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
}

# ====================================
# Read POS.prop
# ====================================
if [ -f "$POS_PROP" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        line=$(_trim "$line")

        # Skip empty or comment
        case "$line" in
            ""|\#*) continue ;;
        esac

        key="${line%%=*}"
        value="${line#*=}"

        key=$(_trim "$key")
        value=$(_trim "$value")

        # Remove quotes
        case "$value" in
            \"*\" ) value="${value#\"}"; value="${value%\"}" ;;
            \'*\' ) value="${value#\'}"; value="${value%\'}" ;;
        esac

        case "$key" in
            pos_whitelist_prop) pos_whitelist_prop="$value" ;;
        esac
    done < "$POS_PROP"
fi

# ====================================
# If whitelist feature NOT enabled → EXIT
# ====================================
[ "$pos_whitelist_prop" = "true" ] || exit 0

# ====================================
# Create whitelist file directly in /sdcard
# ====================================
echo "# List of user apps that will NOT be force-stopped while gaming" > "$WHITE_LIST"
echo "# No reboot needed; changes apply instantly" >> "$WHITE_LIST"
echo "# Add one package name per line" >> "$WHITE_LIST"
echo "# Example recommended system packages:" >> "$WHITE_LIST"
echo "me.weishu.kernelsu" >> "$WHITE_LIST"
echo "com.rifsxd.ksunext" >> "$WHITE_LIST"
echo "# Add your package here↓" >> "$WHITE_LIST"
echo "" >> "$WHITE_LIST"

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
