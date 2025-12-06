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
RESTORE_DIR="/data/adb/modules/pos/scripts"
RESTORE_FILE="$RESTORE_DIR/restore_thermal_disable.sh"

mkdir -p "$RESTORE_DIR"

# ====================================
# Write restore header
# ====================================
cat <<'EOF' > "$RESTORE_FILE"
#!/system/bin/sh
# ====================================
# Auto-generated Thermal Disable restore script
# Created by Performance of Sadness AI
# ====================================
EOF

# ====================================
# Thermal Zones
# ====================================

THERMAL_ZONES="
/sys/class/thermal/thermal_zone5/mode
/sys/class/thermal/thermal_zone6/mode
/sys/class/thermal/thermal_zone7/mode
/sys/class/thermal/thermal_zone8/mode
/sys/class/thermal/thermal_zone9/mode
/sys/class/thermal/thermal_zone10/mode
/sys/class/thermal/thermal_zone11/mode
/sys/class/thermal/thermal_zone12/mode
/sys/class/thermal/thermal_zone13/mode
/sys/class/thermal/thermal_zone14/mode
/sys/class/thermal/thermal_zone15/mode

/sys/class/thermal/thermal_zone16/mode
/sys/class/thermal/thermal_zone17/mode
/sys/class/thermal/thermal_zone18/mode
/sys/class/thermal/thermal_zone19/mode
/sys/class/thermal/thermal_zone20/mode
/sys/class/thermal/thermal_zone21/mode
/sys/class/thermal/thermal_zone22/mode
/sys/class/thermal/thermal_zone23/mode
/sys/class/thermal/thermal_zone24/mode
/sys/class/thermal/thermal_zone25/mode
/sys/class/thermal/thermal_zone26/mode
/sys/class/thermal/thermal_zone27/mode

/sys/class/thermal/thermal_zone41/mode
/sys/class/thermal/thermal_zone42/mode
/sys/class/thermal/thermal_zone43/mode
/sys/class/thermal/thermal_zone44/mode
/sys/class/thermal/thermal_zone45/mode
/sys/class/thermal/thermal_zone46/mode
/sys/class/thermal/thermal_zone47/mode
/sys/class/thermal/thermal_zone48/mode
/sys/class/thermal/thermal_zone49/mode
/sys/class/thermal/thermal_zone50/mode
"

# ====================================
# Function: Save a key's current value
# ====================================
save_key() {
    FILE="$1"

    if [ -f "$FILE" ]; then
        val=$(cat "$FILE" 2>/dev/null)

        if [ "${#val}" -le 4096 ]; then
            {
                echo ""
                echo "# ---- Restore $FILE ----"
                echo "    echo $val > $FILE 2>/dev/null"
            } >> "$RESTORE_FILE"
        fi
    fi
}

# ====================================
# Backup all thermal keys
# ====================================
for f in $THERMAL_ZONES; do
    save_key "$f"
done

# ====================================
# Footer
# ====================================
cat <<'EOF' >> "$RESTORE_FILE"

exit 0
EOF

chmod 755 "$RESTORE_FILE"

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
