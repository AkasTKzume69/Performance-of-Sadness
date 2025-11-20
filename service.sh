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
POS_ID="Performance of Sadness"
POS_ID_AI="Performance of Sadness AI"
POS_Service="/data/local/tmp/pos-service.sh"

toast() {
    local msg="$1"
    cmd toast "$msg" 2>/dev/null && return
    su -lp 2000 -c "cmd notification post -t \"$POS_ID_AI\" \"POS_TOAST\" \"$msg\"" >/dev/null 2>&1
}

# --- Wait until device fully boot ---
sleep 20
toast "Setting up $POS_ID"
sleep 5

# --- Create detection script ---
cat > "$POS_Service" <<'EOF'
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
POS_ID="Performance of Sadness"
POS_ID_AI="Performance of Sadness AI"

# ------------------------------
# Helper Functions
# ------------------------------
toast() {
    local msg="$1"
    cmd toast "$msg" 2>/dev/null && return
    su -lp 2000 -c "cmd notification post -t \"$POS_ID_AI\" \"POS_TOAST\" \"$msg\"" >/dev/null 2>&1
}

script_ok() {
    [ -f "$1" ] && [ -x "$1" ]
}


# ------------------------------
# Configuration (Do not modify)
# ------------------------------
GAME_LIST="/vendor/etc/game-list.pos"                  # Path to your game list
Performance_Script="/vendor/bin/perf_profile.pos"   # Replace with YOUR performance script path
Restore_Script="/vendor/bin/perf_profile_restore.pos"    # Replace with YOUR restore script path


# ------------------------------
# Tracking Variables
# ------------------------------
CURRENT_PKG=""       # Current active app package
IS_GAME=0            # 1 if current app is a game, 0 otherwise
PREV_IS_GAME=0       # Previous app's game state
RESTORE_PID=""       # PID of the 20s restore countdown process


# ------------------------------
# Initial Checks
# ------------------------------
# Verify game list exists
if [ ! -f "$GAME_LIST" ]; then
    toast "Error: Game list not found at $GAME_LIST"
    exit 1
fi

# Warn if performance/restore scripts are missing
[ ! -f "$Performance_Script" ] && toast "Warning: Performance script not found!"
[ ! -f "$Restore_Script" ] && toast "Warning: Restore script not found!"


# ------------------------------
# MAIN GAME DETECTION LOOP
# ------------------------------
logcat -b events -v brief | grep --line-buffered "input_focus" | while read -r line; do
    # Extract package name from logcat line
    pkg=$(echo "$line" | sed -n 's/.*Focus .* \([^ ]*\)\/.*/\1/p')

    # Skip empty packages or system components (no dot in name)
    [ -z "$pkg" ] && continue
    echo "$pkg" | grep -q "\." || continue

    # Skip duplicate packages (avoid spam/CPU usage)
    [ "$pkg" = "$CURRENT_PKG" ] && continue

    # Update current active package
    CURRENT_PKG="$pkg"


    # ------------------------------
    # Check if app is a game
    # ------------------------------
    if grep -qxF "$pkg" "$GAME_LIST"; then
        IS_GAME=1
    else
        IS_GAME=0
    fi


    # ------------------------------
    # Process game detection
    # ------------------------------
    if [ "$IS_GAME" -eq 1 ]; then
        local RETURNED_FROM_COUNTDOWN=0

        # ONLY cancel countdown if process is STILL running (fixes dead PID issue)
        if [ -n "$RESTORE_PID" ] && kill -0 "$RESTORE_PID" 2>/dev/null; then
            kill "$RESTORE_PID" 2>/dev/null
            unset RESTORE_PID
            RETURNED_FROM_COUNTDOWN=1
            toast "Game Detected — $CURRENT_PKG"
        fi

        # Apply profile/renderer ONLY if:
        # 1. Coming from a non-game OR
        # 2. First time launching the game (PREV_IS_GAME=0)
        # AND not returning from a countdown (to avoid restarting)
        if [ "$PREV_IS_GAME" -eq 0 ] && [ "$RETURNED_FROM_COUNTDOWN" -eq 0 ]; then
            # Apply performance profile
            if script_ok "$Performance_Script"; then
                toast "Applying Performance Profile"
                sh "$Performance_Script" >/dev/null 2>&1 &
                toast "Performance Profile Applied"
            else
                toast "Error: Failed to run Performance Script"
            fi

            # Apply Vulkan renderer and restart game
            toast "Applying Vulkan Renderer..."
            setprop debug.hwui.renderer skiavk
            sleep 1
            toast "Restarting $CURRENT_PKG to apply changes..."
            am force-stop "$CURRENT_PKG"
            sleep 2  # Ensure app is fully closed before relaunch
            monkey -p "$CURRENT_PKG" -c android.intent.category.LAUNCHER 1 >/dev/null 2>&1
            toast "Vulkan Applied — $CURRENT_PKG restarted"
        fi

        # Update previous game state
        PREV_IS_GAME=1


    # ------------------------------
    # Process non-game app
    # ------------------------------
    else
        # Start 20s restore countdown ONLY if coming from a game
        if [ "$PREV_IS_GAME" -eq 1 ]; then
            toast "No game detected — Restoring Default Profile in 20s..."
            (
                sleep 20
                # Restore OpenGL renderer
                toast "Restoring OpenGL Renderer..."
                setprop debug.hwui.renderer opengl

                # Restore default performance profile
                if script_ok "$Restore_Script"; then
                    toast "Restoring Default Profile"
                    sh "$Restore_Script" >/dev/null 2>&1 &
                    toast "Default Profile Restored"
                else
                    toast "Error: Failed to run Restore Script"
                fi
                # Note: Can't unset RESTORE_PID here (subshell can't modify parent)
            ) &
            RESTORE_PID=$!  # Save PID to cancel later if needed
        fi

        # Update previous game state
        PREV_IS_GAME=0
    fi

done
EOF

chmod 755 "$POS_Service"
su -c "$POS_Service &"
toast "Hello! Thank you for using $POS_ID module☺️🇵🇭"
sleep 3
