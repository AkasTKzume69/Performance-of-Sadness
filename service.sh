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

LOGFILE="/sdcard/Performance-of-Sadness.log"
GAME_PACKAGES="com.mobile.legends com.roblox.client com.activision.callofduty.shooter com.garena.game.codm"
PERF_SCRIPT="/system/vendor/bin/perf_profile.sh"
RESTORE_SCRIPT="/system/vendor/bin/restore_perf_profile.sh"
MARKER="/data/local/tmp/.perf_active"

# --- Logging Function ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOGFILE"
}

# --- Check if script executable ---
script_ok() { [ -x "$1" ]; }

# ==============================
#  Vulkan Renderer Switch
# ==============================
log "[VulkanRendererSwitch] Waiting 30s for system boot..."
sleep 30

log "[VulkanRendererSwitch] Restarting user apps to apply Vulkan renderer..."
for a in $(pm list packages -3 | cut -f2 -d:); do
    am force-stop "$a" >/dev/null 2>&1 &
done
log "[VulkanRendererSwitch] Forced user apps restart complete."

# ==============================
#  Performance of Sadness AI
# ==============================
apply_profile() {
    if [ ! -f "$MARKER" ]; then
        log "[PerformanceOfSadnessAI] Game detected, applying performance profile."
        touch "$MARKER"
        script_ok "$PERF_SCRIPT" && sh "$PERF_SCRIPT" >> "$LOGFILE" 2>&1 &
    fi
}

restore_profile() {
    if [ -f "$MARKER" ]; then
        log "[PerformanceOfSadnessAI] Game closed, restoring default profile."
        rm -f "$MARKER"
        script_ok "$RESTORE_SCRIPT" && sh "$RESTORE_SCRIPT" >> "$LOGFILE" 2>&1 &
    fi
}

log "[PerformanceOfSadnessAI] Service started."

while true; do
    current_count=0
    for pkg in $GAME_PACKAGES; do
        pidof "$pkg" >/dev/null 2>&1 && current_count=$((current_count + 1))
    done

    if [ "$current_count" -gt 0 ]; then
        apply_profile
        # Game running → check every 5 seconds for closure
        sleep 5
        continue
    else
        restore_profile
        # Idle state → sleep long, wake only on process table change
        old_ps_size=$(ps -A | wc -l)
        for i in $(seq 1 60); do
            sleep 10
            new_ps_size=$(ps -A | wc -l)
            [ "$new_ps_size" != "$old_ps_size" ] && break
        done
    fi
done &
