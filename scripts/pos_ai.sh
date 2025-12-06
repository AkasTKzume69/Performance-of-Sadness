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
POS_ID="Performance of Sadness"
POS_ID_AI="Performance of Sadness AI"
GAME_LIST="/data/adb/modules/pos/scripts/pos-games.zip"
WHITE_LIST="/sdcard/whitelist.prop"
POS_PROP="/sdcard/pos.prop"
USER_APPS="/data/adb/modules/pos/scripts/user-apps.pos"

# Performance Variables
IO="/data/adb/modules/pos/scripts/pos_io.sh"
GPU="/data/adb/modules/pos/scripts/pos_gpu.sh"
CPU="/data/adb/modules/pos/scripts/pos_cpu.sh"
Thermal="/data/adb/modules/pos/scripts/pos_thermal.sh"
Thermal_Disable="/data/adb/modules/pos/scripts/pos_thermal_disable.sh"

# Performance Restore Variables
IO_Restore="/data/adb/modules/pos/scripts/restore_io.sh"
GPU_Restore="/data/adb/modules/pos/scripts/restore_gpu.sh"
CPU_Restore="/data/adb/modules/pos/scripts/restore_cpu.sh"
Thermal_Restore="/data/adb/modules/pos/scripts/restore_thermal.sh"
Thermal_Disable_Restore="/data/adb/modules/pos/scripts/restore_thermal_disable.sh"

# Additional Feature Variables
UFS_Health="/data/adb/modules/pos/scripts/pos_ufs_health.sh"

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
    # consider file exists; executable flag optional (some devices won't have +x)
    [ -f "$1" ]
}

# Wait user to unlock the device (Android 16 Storage Restrictions)
sleep 1

# Create whitelist if not exists
create_whitelist() {
    if [ ! -f "$WHITE_LIST" ]; then
        echo "# Add your allowed packages here" > "$WHITE_LIST"
        echo "# No need to reboot" >> "$WHITE_LIST"
        echo "# Example:" >> "$WHITE_LIST"
        echo "com.android.systemui" >> "$WHITE_LIST"
        echo "com.android.launcher3" >> "$WHITE_LIST"
        echo "com.android.settings" >> "$WHITE_LIST"
        echo "com.rifsxd.ksunext" >> "$WHITE_LIST"
    fi
}
create_whitelist

# Create pos.prop if not exists
create_pos_prop() {
    if [ ! -f "$POS_PROP" ]; then
        echo "# ==========================================" > "$POS_PROP"
        echo "# Performance of Sadness Configuration File" >> "$POS_PROP"
        echo "# Auto-generated default configuration" >> "$POS_PROP"
        echo "# Reboot required to apply changes" >> "$POS_PROP"
        echo "# No extra space, extra symbols, and no capitalization" >> "$POS_PROP"
        echo "# ==========================================" >> "$POS_PROP"
        echo "### Check UFS Lifespan every boot" >> "$POS_PROP"
        echo "pos_ufs_health_show=true" >> "$POS_PROP"
        echo "" >> "$POS_PROP"
        echo "### CPU, GPU, IO toggles that applied when game detected" >> "$POS_PROP"
        echo "pos_cpu_tweak=true" >> "$POS_PROP"
        echo "pos_gpu_tweak=true" >> "$POS_PROP"
        echo "pos_io_tweak=true" >> "$POS_PROP"
        echo "" >> "$POS_PROP"
        echo "### Thermal tweaks that applied when game detected" >> "$POS_PROP"
        echo "pos_thermal_tweak=false" >> "$POS_PROP"
        echo "pos_thermal_disable=false" >> "$POS_PROP"
        echo "" >> "$POS_PROP"
        echo "### Force-stop user apps when game detected except on whitelist" >> "$POS_PROP"
        echo "pos_force_stop_user_apps=true" >> "$POS_PROP"
        echo "" >> "$POS_PROP"
        echo "### Whitelist behavior" >> "$POS_PROP"
        echo "pos_whitelist_prop=true" >> "$POS_PROP"
        echo "pos_whitelist_prop_location=/sdcard" >> "$POS_PROP"
        echo "" >> "$POS_PROP"
        echo "### Renderer switching when game detected" >> "$POS_PROP"
        echo "pos_renderer_switch=true" >> "$POS_PROP"
        echo "pos_renderer_switch_individual=false" >> "$POS_PROP"
        echo "" >> "$POS_PROP"
        echo "# Renderer switch auto relaunch to apply renderer properly" >> "$POS_PROP"
        echo "# Only works if pos_renderer_switch=true" >> "$POS_PROP"
        echo "pos_renderer_switch_relaunch=true" >> "$POS_PROP"
        echo "" >> "$POS_PROP"
        echo "### List of games that should use Vulkan" >> "$POS_PROP"
        echo "# Only works if pos_renderer_switch_individual=true" >> "$POS_PROP"
        echo "# Example:" >> "$POS_PROP"
        echo "# pos_renderer_games=com.mobile.legends com.garena.game.codm com.roblox.client" >> "$POS_PROP"
        echo "pos_renderer_games=" >> "$POS_PROP"
    fi
}
create_pos_prop

_trim() {
    local var="$1"
    var="${var#"${var%%[![:space:]]*}"}"  # remove leading spaces
    var="${var%"${var##*[![:space:]]}"}"  # remove trailing spaces
    echo "$var"
}

# Read pos.prop if present
if [ -f "$POS_PROP" ]; then
    while IFS= read -r line || [ -n "$line" ]; do
        # Remove leading/trailing spaces
        line=$(_trim "$line")
        # skip comments and empty lines
        case "$line" in
            ""|\#*)
                continue
                ;;
        esac

        # split at first '=' only
        key="${line%%=*}"
        value="${line#*=}"

        key=$(_trim "$key")
        value=$(_trim "$value")

        # remove surrounding quotes from value if present
        case "$value" in
            \"*\" )
                value="${value#\"}"
                value="${value%\"}"
                ;;
            \'*\' )
                value="${value#\'}"
                value="${value%\'}"
                ;;
        esac

        # Assign to recognized variables only (avoid eval)
        case "$key" in
            pos_ufs_health_show) pos_ufs_health_show="$value" ;;
            pos_cpu_tweak) pos_cpu_tweak="$value" ;;
            pos_gpu_tweak) pos_gpu_tweak="$value" ;;
            pos_io_tweak) pos_io_tweak="$value" ;;
            pos_thermal_tweak) pos_thermal_tweak="$value" ;;
            pos_thermal_disable) pos_thermal_disable="$value" ;;
            pos_force_stop_user_apps) pos_force_stop_user_apps="$value" ;;
            pos_whitelist_prop) pos_whitelist_prop="$value" ;;
            pos_whitelist_prop_location) pos_whitelist_prop_location="$value" ;;
            pos_renderer_switch) pos_renderer_switch="$value" ;;
            pos_renderer_switch_individual) pos_renderer_switch_individual="$value" ;;
            pos_renderer_switch_relaunch) pos_renderer_switch_relaunch="$value" ;;
            pos_renderer_games) pos_renderer_games="$value" ;;
            *) 
                # unknown key: ignore (or log if you want)
                ;;
        esac
    done < "$POS_PROP"
fi

# If whitelist from prop is enabled, point WHITE_LIST to the configured location
if [ "$pos_whitelist_prop" = "true" ] || [ "$pos_whitelist_prop" = "True" ]; then
    WLLOC="$pos_whitelist_prop_location"
    [ -z "$WLLOC" ] && WLLOC="/sdcard"
    WHITE_LIST="${WLLOC%/}/whitelist.prop"
fi

# ====================================
# Thermal Logic Prop — Prevent Conflict
# ====================================
# Priority: Thermal Disable overrides Thermal Tweak
if [ "$pos_thermal_disable" = "true" ] || [ "$pos_thermal_disable" = "True" ]; then
    pos_thermal_tweak="false"
fi

# ====================================
# Initial Checks
# ====================================
[ ! -f "$GAME_LIST" ] && toast "[Script]Game list missing!" && exit 1
[ ! -f "$USER_APPS" ] && toast "[Script]App list missing!" && exit 1
[ ! -f "$CPU" ] && toast "[Script]CPU Tweak missing!" && exit 1
[ ! -f "$GPU" ] && toast "[Script]GPU Tweak missing!" && exit 1
[ ! -f "$IO" ] && toast "[Script]IO Tweak missing!" && exit 1
#[ ! -f "$Thermal" ] && toast "[Script]Thermal Tweak missing!" && exit 1
#[ ! -f "$Thermal_Disable" ] && toast "[Script]Thermal Disable missing!" && exit 1

[ ! -f "$CPU_Restore" ] && toast "[File] CPU Restore missing!" && exit 1
[ ! -f "$GPU_Restore" ] && toast "[File] GPU Restore missing!" && exit 1
[ ! -f "$IO_Restore" ] && toast "[File] IO Restore missing!" && exit 1
#[ ! -f "$Thermal_Restore" ] && toast "[File] Thermal Restore missing!" && exit 1
#[ ! -f "$Thermal_Disable_Restore" ] && toast "[File] Thermal Disable Restore missing!" && exit 1

# ====================================
# Welcome Note
# ====================================
toast "Hello! I'm $POS_ID_AI☺️ your game assistant!"

# ====================================
# Show UFS Health if enabled
# ====================================
if [ "$pos_ufs_health_show" = "true" ]; then
script_ok "$UFS_Health" && sh "$UFS_Health" >/dev/null 2>&1 &
fi
# ====================================
# Kill All Non-Whitelisted Apps
# ====================================
kill_non_whitelisted_apps() {
    local game_pkg="$1"
    # read whitelist lines safely
    WL=$(cat "$WHITE_LIST" 2>/dev/null || echo "")
    # avoid word-splitting of user apps: read line by line
    if [ -f "$USER_APPS" ]; then
        while IFS= read -r pkg || [ -n "$pkg" ]; do
            pkg=$(_trim "$pkg")
            [ -z "$pkg" ] && continue
            [ "$pkg" = "$game_pkg" ] && continue
            echo "$WL" | grep -qxF "$pkg" && continue
            am force-stop "$pkg" >/dev/null 2>&1
        done < "$USER_APPS"
    fi
}

# ====================================
# Logcat Method Game Detection
# Event-Based 0.1% CPU Usage
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
        RETURNED=0

        if [ -n "$RESTORE_PID" ] && kill -0 "$RESTORE_PID" 2>/dev/null; then
            kill "$RESTORE_PID" 2>/dev/null
            unset RESTORE_PID
            RETURNED=1
            toast "Game Detected — $CURRENT_PKG"
        fi

        if [ "$PREV_IS_GAME" -eq 0 ] && [ "$RETURNED" -eq 0 ]; then

            # --------------------------------------
                # CPU Performance
                # --------------------------------------
                if [ "$pos_cpu_tweak" = "true" ]; then
                    script_ok "$CPU" && sh "$CPU" >/dev/null 2>&1 &
                fi

                # --------------------------------------
                # GPU Performance
                # --------------------------------------
                if [ "$pos_gpu_tweak" = "true" ]; then
                    script_ok "$GPU" && sh "$GPU" >/dev/null 2>&1 &
                fi

                # --------------------------------------
                # I/O Performance
                # --------------------------------------
                if [ "$pos_io_tweak" = "true" ]; then
                    script_ok "$IO" && sh "$IO" >/dev/null 2>&1 &
                fi

                # --------------------------------------
                # Thermal Performance
                # --------------------------------------
                if [ "$pos_thermal_tweak" = "true" ]; then
                    script_ok "$Thermal" && sh "$Thermal" >/dev/null 2>&1 &
                fi

                # --------------------------------------
                # Thermal Disable
                # --------------------------------------
                if [ "$pos_thermal_disable" = "true" ]; then
                    script_ok "$Thermal_Disable" && sh "$Thermal_Disable" >/dev/null 2>&1 &
                fi

            sleep 1

            # -------------------------
            # Vulkan / Renderer switching
            # -------------------------
            if [ "$pos_renderer_switch" = "true" ]; then

                if [ "$pos_renderer_switch_individual" = "true" ]; then
                    # pos_renderer_games must be space-separated list of package names
                    echo "$pos_renderer_games" | tr ' ' '\n' | grep -qxF "$CURRENT_PKG"
                    if [ $? -eq 0 ]; then
                        setprop debug.hwui.renderer skiavk
                    else
                        setprop debug.hwui.renderer opengl
                    fi
                else
                    # always use Vulkan when gaming
                    setprop debug.hwui.renderer skiavk
                    cmd graphics reset 2>/dev/null
                    
                    # Restart game to apply changes
                    if [ "$pos_renderer_switch" = "true" ] && [ "$pos_renderer_switch_relaunch" = "true" ]; then
                      am force-stop "$CURRENT_PKG"
                      sleep 1
                      monkey -p "$CURRENT_PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
                    fi
                    sleep 1
                    
                    # Force stop non whitelisted apps (if enabled)
                    if [ "$pos_force_stop_user_apps" = "true" ]; then
                      kill_non_whitelisted_apps "$CURRENT_PKG"
                    fi
                fi
            fi
        fi

        PREV_IS_GAME=1
            
    # ================================
    # Non-Game — Restore after 20s
    # ================================
    else
        if [ "$PREV_IS_GAME" -eq 1 ]; then
            toast "No game detected — Restoring in 20 seconds..."
            (
                sleep 20
                # Restore renderer only if switching was enabled
                if [ "$pos_renderer_switch" = "true" ] || [ "$pos_renderer_switch" = "True" ]; then
                setprop debug.hwui.renderer opengl
                cmd graphics reset 2>/dev/null
                fi
                
                # --------------------------------------
                # CPU Restore
                # --------------------------------------
                if [ "$pos_cpu_tweak" = "true" ]; then
                script_ok "$CPU_Restore" && sh "$CPU_Restore" >/dev/null 2>&1 &
                fi
                
                # --------------------------------------
                # GPU Restore
                # --------------------------------------
                if [ "$pos_gpu_tweak" = "true" ]; then
                script_ok "$GPU_Restore" && sh "$GPU_Restore" >/dev/null 2>&1 &
                fi
                
                # --------------------------------------
                # IO Restore
                # --------------------------------------
                if [ "$pos_io_tweak" = "true" ]; then
                script_ok "$IO_Restore" && sh "$IO_Restore" >/dev/null 2>&1 &
                fi
                
                # --------------------------------------
                # Thermal Restore
                # --------------------------------------
                if [ "$pos_thermal_tweak" = "true" ]; then
                script_ok "$Thermal_Restore" && sh "$Thermal_Restore" >/dev/null 2>&1 &
                fi
                
                # --------------------------------------
                # Thermal Disable Restore
                # --------------------------------------
                if [ "$pos_thermal_disable" = "true" ]; then
                script_ok "$Thermal_Disable_Restore" && sh "$Thermal_Disable_Restore" >/dev/null 2>&1 &
                fi
                toast "Default Profile Restored"
            ) &
            RESTORE_PID=$!
        fi

        PREV_IS_GAME=0
    fi

done
