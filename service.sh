#!/system/bin/sh
# ==========================================================
# Performance of Sadness
# Copyright (C) 2025  AkasTKzume
#
# This script is part of the "Performance of Sadness" project.
# Unauthorized copying, modification, or distribution of this file,
# via any medium, is strictly prohibited without prior permission
# from the author.
#
# Licensed under the GNU General Public License v3.0 (GPLv3)
# You may obtain a copy of the License at:
#     https://www.gnu.org/licenses/gpl-3.0.html
#
# Author: AkasTKzume
# ==========================================================

# ==========================================================
#   Main Variables
# ==========================================================
POSid="Performance of Sadness AI"
Logfile="/sdcard/Performance-of-Sadness.log"
Games="/vendor/etc/game-list.pos"
Launcher="/vendor/etc/launcher-list.pos"
Performance_Script="/vendor/bin/perf_profile.pos"
Restore_Script="/vendor/bin/perf_profile_restore.pos"
Marker="/data/local/tmp/.perf_active"

# --- Additional Variables ---
Vulkan_Applied=0
LastApp=""
LastGame=0

# --- Logging ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$Logfile"
}

# --- Check script executability ---
script_ok() {
    [ -x "$1" ]
}

sleep 35
> "$Logfile"

# --- Check Required Files ---
if [ ! -r "$Games" ]; then
    log "[$POSid] ERROR: Game list not found or unreadable!"
    exit 1
fi
# Extra check: Make sure launcher list isn't empty
if [ -z "$(cat "$Games")" ]; then
    log "[$POSid] ERROR: Game list is empty!"
    exit 1
fi
if [ ! -r "$Launcher" ]; then
    log "[$POSid] ERROR: Launcher list not found or unreadable!"
    exit 1
fi
# Extra check: Make sure launcher list isn't empty
if [ -z "$(cat "$Launcher")" ]; then
    log "[$POSid] ERROR: Launcher list is empty!"
    exit 1
fi
if [ ! -r "$Performance_Script" ]; then
    log "[$POSid] ERROR: Performance Script not found or unreadable!"
    exit 1
fi
if [ ! -r "$Restore_Script" ]; then
    log "[$POSid] ERROR: Restore Script not found or unreadable!"
    exit 1
fi

# Device Info
echo "Device: $(getprop ro.product.marketname)"       >> "$Logfile"
echo "Brand: $(getprop ro.product.brand)"             >> "$Logfile"
echo "Model: $(getprop ro.product.model)"             >> "$Logfile"
echo "Codename: $(getprop ro.product.device)"         >> "$Logfile"
echo "ROM: $(getprop ro.build.flavor)"                >> "$Logfile"
renderer_val=$(getprop debug.hwui.renderer)
[ -z "$renderer_val" ] && renderer_val="Not set (Default)"
echo "Renderer: $renderer_val" >> "$Logfile"

# ==========================================================
#   Helper Functions
# ==========================================================

apply_vulkan() {
    if [ "$Vulkan_Applied" -eq 0 ]; then
        log "[$POSid] Applying Vulkan Renderer..."
        setprop debug.hwui.renderer skiavk
        sleep 1
        sync
        setprop debug.hwui.disable_vulkan 0
        setprop debug.hwui.use_buffer_age false

        # Find running game process
        running_game=""
        for pkg in $(cat "$Games"); do
            if pidof "$pkg" >/dev/null 2>&1; then
                running_game="$pkg"
                break
            fi
        done

        if [ -n "$running_game" ]; then
            log "[$POSid] Restarting $running_game ..."
            am force-stop "$running_game"
            sleep 2
            monkey -p "$running_game" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
        fi

        Vulkan_Applied=1
    fi
}

restore_opengl() {
    if [ "$Vulkan_Applied" -eq 1 ]; then
        log "[$POSid] Restoring OpenGL..."
        setprop debug.hwui.renderer opengl
        setprop debug.hwui.disable_vulkan 1
        setprop debug.hwui.use_buffer_age true
        Vulkan_Applied=0
    fi
}

apply_profile() {
    if [ ! -f "$Marker" ]; then
        log "[$POSid] Applying Performance Profile..."
        touch "$Marker"
        script_ok "$Performance_Script" && sh "$Performance_Script" >/dev/null 2>&1 &
    fi
}

restore_profile() {
    if [ -f "$Marker" ]; then
        log "[$POSid] Restoring Default Profile..."
        rm -f "$Marker"
        script_ok "$Restore_Script" && sh "$Restore_Script" >/dev/null 2>&1 &
    fi
}

log "[$POSid] Service Started."

# ==========================================================
#   Foreground App Detection
# ==========================================================

while true; do
    # Get current foreground app (fixed minor syntax for readability)
    top_app=$(dumpsys window | grep mCurrentFocus | sed 's/.*u0 //;s/\/.*//')

    [ -z "$top_app" ] && { sleep 1; continue; }

    if [ "$top_app" != "$LastApp" ]; then
        LastApp="$top_app"

        # Case 1: Entering a game → apply settings
        if grep -q "^$top_app$" "$Games"; then
            if [ "$LastGame" -eq 0 ]; then
                log "[$POSid] Game Detected: $top_app"
                apply_vulkan
                apply_profile
                LastGame=1
            fi
        # Case 2: Not a game → check if switching to a launcher
        else
            is_launcher=0
            # READ THE CONTENT OF THE LAUNCHER FILE (not the file path!)
            while read -r launcher; do
                # Skip empty lines in the file
                [ -z "$launcher" ] && continue
                # Check if current app matches the launcher package
                if [ "$top_app" = "$launcher" ]; then
                    is_launcher=1
                    break
                fi
            done < "$Launcher"  # Feed the file into the loop

            # Only restore if coming from a game AND switching to a launcher
            if [ "$LastGame" -eq 1 ] && [ "$is_launcher" -eq 1 ]; then
                log "[$POSid] Game Closed: $top_app detected"
                restore_opengl
                restore_profile
                LastGame=0
            fi
        fi
    fi

    sleep 2
done &
