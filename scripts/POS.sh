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

# ====================================
# Main Variables
# ====================================
POS_ID="Performance of Sadness"
POS_ID_AI="Performance of Sadness AI"
GAME_LIST="/data/adb/modules/pos/scripts/game-list.pos"
WHITE_LIST="/sdcard/whitelist.prop"
ALL_APPS="/data/adb/modules/pos/scripts/all-apps.pos"
Performance_Script="/data/adb/modules/pos/scripts/perf_profile.pos"
Restore_Script="/data/adb/modules/pos/scripts/perf_profile_restore.pos"

# Additional Variables
CURRENT_PKG=""
IS_GAME=0
PREV_IS_GAME=0
RESTORE_PID=""

# ====================================
# Helper Functions
# ====================================
toast() {
    local msg="$1"
    cmd toast "$msg" 2>/dev/null && return
    su -lp 2000 -c "cmd notification post -t \"$POS_ID_AI\" \"POS_TOAST\" \"$msg\"" >/dev/null 2>&1
}

script_ok() {
    [ -f "$1" ] && [ -x "$1" ]
}

# Create whitelist on first boot
create_whitelist() {
    sleep 30
    if [ ! -f "$WHITE_LIST" ]; then
        echo "# Add your allowed packages here" > "$WHITE_LIST"
        echo "# Example:" >> "$WHITE_LIST"
        echo "com.android.systemui" >> "$WHITE_LIST"
        echo "com.android.launcher3" >> "$WHITE_LIST"
        echo "com.android.settings" >> "$WHITE_LIST"
    fi
}
create_whitelist &

# ====================================
# Initial Checks
# ====================================
[ ! -f "$GAME_LIST" ] && toast "Game list missing!" && exit 1
[ ! -f "$ALL_APPS" ] && toast "App list missing!" && exit 1
[ ! -f "$Performance_Script" ] && toast "Warning: Performance script missing!" && exit 1
[ ! -f "$Restore_Script" ] && toast "Warning: Restore script missing!" && exit 1

# ====================================
# Welcome Note
# ====================================
toast "Hello! Thanks for using $POS_ID ☺️🇵🇭"

# ====================================
# Kill All Non-Whitelisted Apps
# ====================================
kill_non_whitelisted_apps() {
    local game_pkg="$1"
    WL=$(cat "$WHITE_LIST" 2>/dev/null)

    for pkg in $(cat "$ALL_APPS"); do
        [ "$pkg" = "$game_pkg" ] && continue
        [ "$pkg" = "com.android.systemui" ] && continue
        echo "$WL" | grep -qxF "$pkg" && continue
        am force-stop "$pkg" >/dev/null 2>&1
    done
}

# ====================================
# Logcat Method Game Detection
# Event-Based 0.1-0.4% CPU Usage
# Extremely Do NOT Modify the logic
# ====================================
logcat -b events -v brief | grep --line-buffered "input_focus" | while read -r line; do
    pkg=$(echo "$line" | sed -n 's/.*Focus .* \([^ ]*\)\/.*/\1/p')
    [ -z "$pkg" ] && continue
    echo "$pkg" | grep -q "\." || continue
    [ "$pkg" = "$CURRENT_PKG" ] && continue

    CURRENT_PKG="$pkg"

    # Detect game
    if grep -qxF "$pkg" "$GAME_LIST"; then
        IS_GAME=1
    else
        IS_GAME=0
    fi

    # ================================
    # GAME DETECTED
    # ================================
    if [ "$IS_GAME" -eq 1 ]; then
        local RETURNED=0

        if [ -n "$RESTORE_PID" ] && kill -0 "$RESTORE_PID" 2>/dev/null; then
            kill "$RESTORE_PID" 2>/dev/null
            unset RESTORE_PID
            RETURNED=1
            toast "Game Detected — $CURRENT_PKG"
        fi

        if [ "$PREV_IS_GAME" -eq 0 ] && [ "$RETURNED" -eq 0 ]; then

            # Performance
            if script_ok "$Performance_Script"; then
                toast "Applying Performance Profile"
                sh "$Performance_Script" >/dev/null 2>&1 &
            fi

            # Vulkan Renderer
            if [ -z "$(getprop debug.hwui.renderer)" ] || [ "$(getprop debug.hwui.renderer)" != "skiavk" ]; then
                toast "Applying Vulkan Renderer..."
                setprop debug.hwui.renderer skiavk
                
            fi

            sleep 1

            # Restart game
            toast "Restarting $CURRENT_PKG..."
            am force-stop "$CURRENT_PKG"
            sleep 1
            monkey -p "$CURRENT_PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
            
            # Force stop non whitelisted apps and danger apps
            kill_non_whitelisted_apps "$CURRENT_PKG"
        fi

        PREV_IS_GAME=1

    # ================================
    # NON-GAME — RESTORE AFTER 20s
    # ================================
    else
        if [ "$PREV_IS_GAME" -eq 1 ]; then
            toast "No game detected — Restoring in 20 seconds..."

            (
                sleep 20

                # Restore OpenGL only if needed (Improvement #1)
                if [ -z "$(getprop debug.hwui.renderer)" ] || [ "$(getprop debug.hwui.renderer)" != "opengl" ]; then
                    toast "Restoring OpenGL Renderer..."
                    setprop debug.hwui.renderer opengl
                fi

                if script_ok "$Restore_Script"; then
                    toast "Restoring Default Profile..."
                    sh "$Restore_Script" >/dev/null 2>&1 &
                    toast "Default Profile Restored"
                fi
            ) &
            RESTORE_PID=$!
        fi

        PREV_IS_GAME=0
    fi

done
