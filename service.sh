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
#
# Author: AkasTKzume
# ==========================================================

# --- Main Variables ---
POFid="Performance of Sadness AI"
Logfile="/sdcard/Performance-of-Sadness.log"
Games="/vendor/etc/game-list.pof"
Performance_Script="/vendor/bin/pof_profile.sh"
Restore_Script="/vendor/bin/pof_restore.sh"
Marker="/data/local/tmp/.perf_active"
VULKAN_APPLIED=0 # Flag to track Vulkan state

# --- Logging Function ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$Logfile"
}

# --- Check if script executable ---
script_ok() {
    [ -x "$1" ]
}

sleep 35

# --- Clear Logs Every Boot ---
if [ -f "$Logfile" ]; then
    > "$Logfile"
fi

# --- Critical Check: Ensure Game List File Exists & is Readable ---
if [ ! -f "$Games" ]; then
    echo "ERROR: Game list file not found at $Games" >> "$Logfile"
    log "[$POFid] Service failed to start: Game list file missing!"
    exit 1  # Exit script if file doesn't exist
elif [ ! -r "$Games" ]; then
    echo "ERROR: No read permission for game list file at $Games" >> "$Logfile"
    log "[$POFid] Service failed to start: Can't read game list file!"
    exit 1  # Exit script if file can't be read
fi

# --- Device Variables ---
Device_Marketname=$(getprop ro.product.marketname)
Device_Manufacturer=$(getprop ro.product.manufacturer)
Device_Brand=$(getprop ro.product.brand)
Device_Model=$(getprop ro.product.model)
Device=$(getprop ro.product.device)
Device_Flavor=$(getprop ro.build.flavor)
Device_Current_Renderer=$(getprop debug.hwui.renderer)

# --- Display Device Currently Using ---
echo "Device: $Device_Marketname " >> $Logfile
echo "Manufacturer: $Device_Manufacturer " >> $Logfile
echo "Brand: $Device_Brand " >> $Logfile
echo "Model: $Device_Model " >> $Logfile
echo "Codename: $Device " >> $Logfile
echo "ROM: $Device_Flavor " >> $Logfile

# --- Display Current Renderer ---
echo "Current Renderer: $Device_Current_Renderer" >> $Logfile
echo "Game List Path: $Games" >> $Logfile  # Log where game list is loaded from

# ==============================
#  Performance of Sadness AI Helper Functions
# ==============================
apply_vulkan() {
    if [ "$VULKAN_APPLIED" -eq 0 ]; then
        log "[$POFid] Applying Vulkan Renderer..."
        setprop debug.hwui.renderer skiavk
        sleep 1.5
        sync
        setprop debug.hwui.disable_vulkan 0
        setprop debug.hwui.use_buffer_age false

        # Build regex from game list file to find running games
        Game_Regex=$(cat "$Games" | sed 's/ /\(|\|^/g')
        log "[$POFid] Relaunching detected game to apply Vulkan..."

        # Find the specific running game's package name
        running_game=""
        for pkg in $(cat "$Games"); do
            if pidof "$pkg" >/dev/null 2>&1; then
                running_game="$pkg"
                break  # Found the running game, exit the loop
            fi
        done

        if [ -n "$running_game" ]; then
            # Restart only the specific running game with Vulkan
            log "[$POFid] Force-stopping $running_game and relaunching with monkey"
            am force-stop "$running_game"
            sleep 2
            monkey -p "$running_game" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
        fi

        VULKAN_APPLIED=1
        log "[$POFid] Vulkan renderer applied and game relaunched."
    fi
}

restore_opengl() {
    if [ "$VULKAN_APPLIED" -eq 1 ]; then
        log "[$POFid] Restoring OpenGL Renderer..."
        setprop debug.hwui.renderer opengl
        sync
        setprop debug.hwui.disable_vulkan 1
        setprop debug.hwui.use_buffer_age true
        VULKAN_APPLIED=0
        log "[$POFid] OpenGL renderer restored."
    fi
}

apply_profile() {
    if [ ! -f "$Marker" ]; then
        log "[$POFid] Game detected, applying performance profile."
        touch "$Marker"
        script_ok "$Performance_Script" && sh "$Performance_Script" >> "$Logfile" 2>&1 &
    fi
}

restore_profile() {
    if [ -f "$Marker" ]; then
        log "[$POFid] Game closed, restoring default profile."
        rm -f "$Marker"
        script_ok "$Restore_Script" && sh "$Restore_Script" >> "$Logfile" 2>&1 &
    fi
}

log "[$POFid] Service started successfully."

while true; do
    current_count=0
    # Read game packages directly from the separate file
    for pkg in $(cat "$Games"); do
        pidof "$pkg" >/dev/null 2>&1 && current_count=$((current_count + 1))
    done

    if [ "$current_count" -gt 0 ]; then
        apply_vulkan # Apply Vulkan when a game is running
        apply_profile # Apply performance profile
        # Game running → check every 5 seconds for closure
        sleep 5
        continue
    else
        restore_opengl # Restore OpenGL when no games are running
        restore_profile # Restore performance profile
        # Idle state → sleep long, wake only on process table change
        old_ps_size=$(ps -A | wc -l)
        for i in $(seq 1 60); do
            sleep 10
            new_ps_size=$(ps -A | wc -l)
            [ "$new_ps_size" != "$old_ps_size" ] && break
        done
    fi
done &
