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
WHITE_LIST="/sdcard/pos_whitelist.prop"

# ====================================
# Create if pos_whitelist.prop does not exist
# ====================================
create_whitelist() {
        echo "# This configuration prevents force-stopping selected user apps (like useful apps you want to run in the background while gaming)" > "$WHITE_LIST"
        echo "# No need to reboot to apply changes" >> "$WHITE_LIST"
        echo "# Add multiple allowed packages here" >> "$WHITE_LIST"
        echo "# Example:" >> "$WHITE_LIST"
        echo "com.android.systemui" >> "$WHITE_LIST"
        echo "com.android.launcher3" >> "$WHITE_LIST"
        echo "com.android.settings" >> "$WHITE_LIST"
        echo "me.weishu.kernelsu" >> "$WHITE_LIST"
        echo "com.rifsxd.ksunext" >> "$WHITE_LIST"
}
create_whitelist

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
