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
GAME_PACKAGES="com.activision.callofduty.shooter com.activision.callofduty.warzone com.garena.game.codm com.mobile.legends com.tencent.tmgp.sgame com.levelinfinite.sgameGlobal com.riotgames.league.wildrift com.roblox.client com.tencent.ig com.vng.pubgmobile com.pubg.imobile com.pubg.newstate com.carxtech.carxstreet com.miHoYo.GenshinImpact com.hoYoverse.hkrpg com.mojang.minecraftpe com.mojang.minecrafttrialpe com.mojang.minecrafteducation com.robtopx.geometryjump com.popcap.pvz_row com.ea.game.pvz2_row com.kiloo.subwaysurf com.sybo.subwaysurf org.linaro.android.cpustress com.antutu.ABenchMark com.antutu.benchmark.full com.antutu.benchmark.lite com.antutu.ABenchMark3D com.antutu.benchmark3d.lite org.geekbench.benchmark com.primatelabs.geekbench6"
PERF_SCRIPT="/vendor/bin/perf_profile.sh"
RESTORE_SCRIPT="/vendor/bin/restore_perf_profile.sh"
MARKER="/data/local/tmp/.perf_active"
DEVICE_MARKETNAME=$(getprop ro.product.marketname)
DEVICE_MANUFACTURER=$(getprop ro.product.manufacturer)
DEVICE_BRAND=$(getprop ro.product.brand)
DEVICE_MODEL=$(getprop ro.product.model)
DEVICE=$(getprop ro.product.device)

# --- Logging Function ---
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') $1" >> "$LOGFILE"
}

# --- Check if script executable ---
script_ok() { [ -x "$1" ]; }

sleep 38

# --- Clear Logs Every Boot ---
if [ -f "$LOGFILE" ]; then
> "$LOGFILE"
fi

# --- Display Device Currently Using ---
echo "Device: $DEVICE_MARKETNAME " >> $LOGFILE
echo "Manufacturer: $DEVICE_MANUFACTURER " >> $LOGFILE
echo "Brand: $DEVICE_BRAND " >> $LOGFILE
echo "Model: $DEVICE_MODEL " >> $LOGFILE
echo "Codename: $DEVICE " >> $LOGFILE

# ==============================
#  Vulkan Renderer Switch
# ==============================
log "[Performance of Sadness AI] Applying Vulkan Renderer..."
setprop debug.hwui.renderer skiavk

# Small delay to ensure property propagation before killing apps
sleep 1.5

log "[Performance of Sadness AI] Restarting user apps..."
# Gracefully restart only user apps (skip system ones)
for a in $(pm list packages -3 | cut -f2 -d:); do
    am force-stop "$a" >/dev/null 2>&1 &
done

# Add a final sync and cache flush to stabilize UI compositor
sleep 0.5
sync
setprop debug.hwui.disable_vulkan 0
setprop debug.hwui.use_buffer_age false

log "[Performance of Sadness AI] Vulkan renderer applied successfully and user apps restarted."

# ==============================
#  Performance of Sadness AI
# ==============================
apply_profile() {
    if [ ! -f "$MARKER" ]; then
        log "[Performance Of Sadness AI] Game detected, applying performance profile."
        touch "$MARKER"
        script_ok "$PERF_SCRIPT" && sh "$PERF_SCRIPT" >> "$LOGFILE" 2>&1 &
    fi
}

restore_profile() {
    if [ -f "$MARKER" ]; then
        log "[Performance Of Sadness AI] Game closed, restoring default profile."
        rm -f "$MARKER"
        script_ok "$RESTORE_SCRIPT" && sh "$RESTORE_SCRIPT" >> "$LOGFILE" 2>&1 &
    fi
}

log "[Performance Of Sadness AI] Service started."

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
