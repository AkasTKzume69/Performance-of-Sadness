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
POSid="Performance of Sadness AI"
Logfile="/sdcard/Performance-of-Sadness.log"
Games="/vendor/etc/game-list.pos"
Performance_Script="/vendor/bin/perf_profile.pos"
Restore_Script="/vendor/bin/perf_profile_restore.pos"
Marker="/data/local/tmp/.perf_active"
Vulkan_Applied=0
LastApp=""
GameActive=0          # Prevents restore on fresh boot
RestoreAllowed=0      # Restores only after game session

# --- Toast ---
toast() {
    local msg="$1"
    cmd toast "$msg" 2>/dev/null && return
    su -lp 2000 -c "cmd notification post -t \"Performance of Sadness\" \"POS_TOAST\" \"$msg\"" >/dev/null 2>&1
}

# --- Logging ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$Logfile"
}

# --- Check script exec ---
script_ok() {
    [ -x "$1" ]
}

sleep 35

# --- Clear logs every boot ---
> "$Logfile"

# --- Check Required Files ---
if [ ! -r "$Games" ]; then
    log "[$POSid] ERROR: Game list not found or unreadable!"
    exit 1
fi
if ! grep -qE '[^[:space:]]' "$Games"; then
    log "[$POSid] ERROR: Game list is empty!"
    exit 1
fi
if [ ! -r "$Performance_Script" ]; then
    log "[$POSid] ERROR: Performance Script not found!"
    exit 1
fi
if ! grep -qE '[^[:space:]]' "$Performance_Script"; then
    log "[$POSid] ERROR: Performance Script is empty!"
    exit 1
fi
if [ ! -r "$Restore_Script" ]; then
    log "[$POSid] ERROR: Restore Script not found!"
    exit 1
fi
if ! grep -qE '[^[:space:]]' "$Restore_Script"; then
    log "[$POSid] ERROR: Restore Script is empty!"
    exit 1
fi

# --- Device Info ---
echo "Device: $(getprop ro.product.marketname)"       >> "$Logfile"
echo "Brand: $(getprop ro.product.brand)"             >> "$Logfile"
echo "Model: $(getprop ro.product.model)"             >> "$Logfile"
echo "Codename: $(getprop ro.product.device)"         >> "$Logfile"
echo "ROM: $(getprop ro.build.flavor)"                >> "$Logfile"
echo "Renderer: $(getprop debug.hwui.renderer)"       >> "$Logfile"

# ==========================================================
# Helper Functions
# ==========================================================

apply_vulkan() {
    if [ "$Vulkan_Applied" -eq 0 ]; then
        log "[$POSid] Applying Vulkan Renderer..."
        toast "Applying Vulkan Renderer..."

        setprop debug.hwui.renderer skiavk
        sleep 1
        sync
        setprop debug.hwui.disable_vulkan 0
        setprop debug.hwui.use_buffer_age false

        running_game=""
        for pkg in $(cat "$Games"); do
            if pidof "$pkg" >/dev/null 2>&1; then
                running_game="$pkg"
                break
            fi
        done

        if [ -n "$running_game" ]; then
            log "[$POSid] Force-stopping and relaunching $running_game"
            am force-stop "$running_game"
            sleep 2
            monkey -p "$running_game" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
        fi

        Vulkan_Applied=1
        log "[$POSid] Vulkan renderer applied."
        toast "Vulkan Applied"
    fi
}

restore_opengl() {
    if [ "$Vulkan_Applied" -eq 1 ]; then
        log "[$POSid] Restoring OpenGL renderer..."
        toast "Restoring OpenGL..."

        setprop debug.hwui.renderer opengl
        setprop debug.hwui.disable_vulkan 1
        setprop debug.hwui.use_buffer_age true
        sync

        Vulkan_Applied=0
        log "[$POSid] OpenGL Restored."
    fi
}

apply_profile() {
    if [ ! -f "$Marker" ]; then
        log "[$POSid] Applying performance profile..."
        toast "Performance Profile Applied"
        touch "$Marker"
        script_ok "$Performance_Script" && sh "$Performance_Script" >/dev/null 2>&1 &
    fi
}

restore_profile() {
    if [ -f "$Marker" ]; then
        log "[$POSid] Restoring default profile..."
        toast "Restoring Performance Profile..."
        rm -f "$Marker"
        script_ok "$Restore_Script" && sh "$Restore_Script" >/dev/null 2>&1 &
    fi
    toast "Restore Completed..."
}

log "[$POSid] Service started."

# ==========================================================
# Foreground Detection
# ==========================================================

NoGameTimer=0

while true; do
    top_app=$(dumpsys window | grep mCurrentFocus | sed 's/.*u0 //;s/\/.*//' | awk '{print $NF}')

    # -------------------------------
    # Ignore SystemUI overlays:
    # if no dot -> NOT an app or game
    # -------------------------------
    case "$top_app" in
        *.*) ;;  # valid app
        *) sleep 1; continue ;;
    esac

    # Log app changes only
    if [ "$top_app" != "$LastApp" ]; then
        LastApp="$top_app"
        log "[$POSid] Foreground App: $top_app"
    fi

    # ========= GAME DETECTED =========
    if grep -q "^$top_app$" "$Games"; then
        NoGameTimer=0

        # Allow restoring later
        RestoreAllowed=1

        if [ $GameActive -eq 0 ]; then
            log "[$POSid] Game detected: $top_app"
            toast "Game detected: $top_app"
            GameActive=1
        fi

        apply_vulkan
        apply_profile

        sleep 2
        continue
    fi

    # ========= NO GAME DETECTED =========
    if [ $GameActive -eq 1 ]; then
        log "[$POSid] Game closed, starting countdown..."
        toast "Game closed, countdown started..."
        GameActive=0
    fi

    NoGameTimer=$((NoGameTimer + 2))

    # Only restore if a game was previously detected
    if [ $RestoreAllowed -eq 1 ]; then
        case "$NoGameTimer" in
            2)
                log "[$POSid] Automatically restore to default if no game detected in 20 seconds)"
                toast "Automatically restore to default if no game detected in 20 seconds"
                ;;
            20)
                log "[$POSid] No game detected (20 seconds)"
                toast "No game detected (20 seconds)"

                restore_opengl
                restore_profile

                RestoreAllowed=0   # <-- Prevent further restore until next game
                NoGameTimer=0
                ;;
        esac
    fi

    sleep 2
done &
