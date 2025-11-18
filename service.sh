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
POSid="Performance of Sadness"
POSidai="Performance of Sadness AI"
Games="/vendor/etc/game-list.pos"
Performance_Script="/vendor/bin/perf_profile.pos"
Restore_Script="/vendor/bin/perf_profile_restore.pos"
Marker="/data/local/tmp/.perf_active"
Vulkan_Applied=0
GameActive=0
RestoreAllowed=0

# --- Toast ---
toast() {
    local msg="$1"
    cmd toast "$msg" 2>/dev/null && return
    su -lp 2000 -c "cmd notification post -t \"$POSidai\" \"POS_TOAST\" \"$msg\"" >/dev/null 2>&1
}

# --- Check script exec ---
script_ok() {
    [ -x "$1" ]
}

# --- Give a time to fully start system ---
sleep 60

# ----------------------------------------------------------
# BOOT TOAST (WELCOME NOTE)
# ----------------------------------------------------------
toast "Thank you for using $POSid module☺️🇵🇭"

# ==========================================================
# Helper Functions
# ==========================================================

apply_vulkan() {
    if [ "$Vulkan_Applied" -eq 0 ]; then
        toast "Applying Vulkan Renderer..."

        setprop debug.hwui.renderer skiavk
        sleep 1
        sync
        setprop debug.hwui.disable_vulkan 0
        setprop debug.hwui.use_buffer_age false

        # Restart any detected game process
        running_game=""
        for pkg in $(cat "$Games"); do
            if pidof "$pkg" >/dev/null 2>&1; then
                running_game="$pkg"
                break
            fi
        done

        if [ -n "$running_game" ]; then
            am force-stop "$running_game"
            sleep 2
            monkey -p "$running_game" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
        fi

        Vulkan_Applied=1
        toast "Vulkan Applied"
    fi
}

restore_opengl() {
    if [ "$Vulkan_Applied" -eq 1 ]; then
        toast "Restoring OpenGL..."

        setprop debug.hwui.renderer opengl
        setprop debug.hwui.disable_vulkan 1
        setprop debug.hwui.use_buffer_age true
        sync

        Vulkan_Applied=0
    fi
}

apply_profile() {
    if [ ! -f "$Marker" ]; then
        toast "Performance Profile Applied"
        touch "$Marker"
        script_ok "$Performance_Script" && sh "$Performance_Script" >/dev/null 2>&1 &
    fi
}

restore_profile() {
    if [ -f "$Marker" ]; then
        toast "Restoring Performance Profile..."
        rm -f "$Marker"
        script_ok "$Restore_Script" && sh "$Restore_Script" >/dev/null 2>&1 &
    fi
    toast "Restore default profile completed..."
}

# ==========================================================
# PIDOF-Based Game Detection (Optimized)
# ==========================================================

NoGameTimer=0

while true; do
    game_found=""
    # Loop through game list and check if any process is running
    for pkg in $(cat "$Games"); do
        if pidof "$pkg" >/dev/null 2>&1; then
            game_found="$pkg"
            break
        fi
    done

    if [ -n "$game_found" ]; then
        # Game detected
        NoGameTimer=0
        RestoreAllowed=1

        if [ $GameActive -eq 0 ]; then
            toast "Game detected: $game_found"
            GameActive=1
        fi

        apply_vulkan
        apply_profile

        sleep 2
        continue
    fi

    # No game detected
    if [ $GameActive -eq 1 ]; then
        toast "Game closed, countdown started..."
        GameActive=0
    fi

    NoGameTimer=$((NoGameTimer + 2))

    if [ $RestoreAllowed -eq 1 ]; then
        case "$NoGameTimer" in
            2)
                toast "Automatically restore to default if no game detected in 20 seconds"
                ;;
            20)
                toast "No game detected (20 seconds)"

                restore_opengl
                restore_profile

                RestoreAllowed=0
                NoGameTimer=0
                ;;
        esac
    fi

    sleep 2
done
