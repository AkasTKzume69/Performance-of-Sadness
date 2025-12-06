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

for d in /sys/block/*; do
    dev=$(basename "$d")

    case "$dev" in
        loop*|zram*) continue ;;
    esac

    Q="$d/queue"
    [ -d "$Q" ] || continue

    # --- Performance values ---
    READ_AHEAD_KB=1024
    NR_REQUESTS=256
    NOMERGES=2
    IOSTATS=0
    ADD_RANDOM=0

    # Apply silently only if writable
    [ -w "$Q/read_ahead_kb" ]  && echo "$READ_AHEAD_KB"  > "$Q/read_ahead_kb"  2>/dev/null
    [ -w "$Q/nr_requests" ]   && echo "$NR_REQUESTS"     > "$Q/nr_requests"    2>/dev/null
    [ -w "$Q/nomerges" ]      && echo "$NOMERGES"        > "$Q/nomerges"       2>/dev/null
    [ -w "$Q/iostats" ]       && echo "$IOSTATS"         > "$Q/iostats"        2>/dev/null
    [ -w "$Q/add_random" ]    && echo "$ADD_RANDOM"      > "$Q/add_random"     2>/dev/null

done

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
