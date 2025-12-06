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
UFS_Base="/sys/devices/platform/soc/4804000.ufshc/health_descriptor"
UFS_ID="UFS Health"

# ====================================
# Helper Functions
# ====================================
toast() {
    su -lp 2000 -c "
        cmd notification post \
        --style bigtext \
        -t \"$UFS_ID\" \
        \"UFS_Health\" \
        \"$1\"
    " >/dev/null 2>&1
}

hex_to_percent() {
    case "$1" in
        0x00) echo "0–10%" ;;
        0x01) echo "10–20%" ;;
        0x02) echo "20–30%" ;;
        0x03) echo "30–40%" ;;
        0x04) echo "40–50%" ;;
        0x05) echo "50–60%" ;;
        0x06) echo "60–70%" ;;
        0x07) echo "70–80%" ;;
        0x08) echo "80–90%" ;;
        0x09) echo "90–100%" ;;
        *) echo "Unknown" ;;
    esac
}

health_icon() {
    case "$1" in
        0x00) echo "🟢 Normal" ;;
        0x01) echo "🟡 Warning" ;;
        0x02) echo "🔴 Critical" ;;
        *) echo "❓ Unknown" ;;
    esac
}

bar() {
    p=$(echo "$1" | sed 's/%//; s/.*–//')
    filled=$((p / 10))

    bar=""
    for i in $(seq 1 10); do
        if [ $i -le $filled ]; then
            bar="${bar}█"
        else
            bar="${bar}░"
        fi
    done

    echo "$bar"
}
# ====================================
# Detect EOL Path
# ====================================
EOL_FILES="
$UFS_Base/eol_info
$UFS_Base/bEolInfo
$UFS_Base/eol
$UFS_Base/eeol_info
"

detect_eol() {
    for file in $EOL_FILES; do
        if su -c "test -f $file"; then
            val=$(su -c "cat $file" 2>/dev/null)
            if [ -n "$val" ]; then
                echo "$val"
                return
            fi
        fi
    done

    echo "unknown"
}

# ====================================
# Read UFS wear
# ====================================
LTA=$(su -c "cat $UFS_Base/life_time_estimation_a")
LTB=$(su -c "cat $UFS_Base/life_time_estimation_b")
EOL=$(detect_eol)

P_A=$(hex_to_percent "$LTA")
P_B=$(hex_to_percent "$LTB")
P_E=$(health_icon "$EOL")

BAR_A=$(bar "$P_A")
BAR_B=$(bar "$P_B")

# ====================================
# Toast Notification Message
# ====================================
msg="𝐋𝐢𝐟𝐞 𝐀: $BAR_A
𝐋𝐢𝐟𝐞 𝐁: $BAR_B
𝐄𝐎𝐋 𝐒𝐭𝐚𝐭𝐮𝐬: $P_E"
toast "$msg"

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
