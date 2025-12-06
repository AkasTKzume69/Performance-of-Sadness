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
RESTORE_FILE="$RESTORE_DIR/restore_io.sh"

mkdir -p "$RESTORE_DIR"

# ====================================
# Write header
# ====================================
cat <<'EOF' > "$RESTORE_FILE"
#!/system/bin/sh
# ====================================
# Auto-generated I/O restore script
# Created By Performance of Sadness AI
# ====================================
EOF

# --- Iterate over valid block devices ---
for d in /sys/block/*; do
    dev=$(basename "$d")

    case "$dev" in
        loop*|zram*) continue ;;
    esac

    Q="$d/queue"
    [ -d "$Q" ] || continue

    # --- Read existing values ---
    ra=$(cat "$Q/read_ahead_kb" 2>/dev/null)
    nr=$(cat "$Q/nr_requests"   2>/dev/null)
    nm=$(cat "$Q/nomerges"      2>/dev/null)
    io=$(cat "$Q/iostats"       2>/dev/null)
    ar=$(cat "$Q/add_random"    2>/dev/null)

    # --- Skip if values are empty (rare but safer) ---
    # --- Also avoids writing huge binary blobs ---
    [ "${#ra}" -le 4096 ] || ra=""
    [ "${#nr}" -le 4096 ] || nr=""
    [ "${#nm}" -le 4096 ] || nm=""
    [ "${#io}" -le 4096 ] || io=""
    [ "${#ar}" -le 4096 ] || ar=""

    # --- Append plain echo restore lines ---
    {
        echo ""
        echo "# ---- Restore for $dev ----"
        [ -n "$ra" ] && echo "echo $ra > $Q/read_ahead_kb 2>/dev/null"
        [ -n "$nr" ] && echo "echo $nr > $Q/nr_requests 2>/dev/null"
        [ -n "$nm" ] && echo "echo $nm > $Q/nomerges 2>/dev/null"
        [ -n "$io" ] && echo "echo $io > $Q/iostats 2>/dev/null"
        [ -n "$ar" ] && echo "echo $ar > $Q/add_random 2>/dev/null"
    } >> "$RESTORE_FILE"

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
