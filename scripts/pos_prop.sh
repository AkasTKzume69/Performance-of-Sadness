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
POS_PROP="/sdcard/pos.prop"

# ====================================
# Create if pos.prop not exist
# ====================================
create_pos_prop() {
echo "# ==========================================" > "$POS_PROP"
echo "# Performance of Sadness Configuration File" >> "$POS_PROP"
echo "# Automatically generated default configuration" >> "$POS_PROP"
echo "# A reboot is required to apply changes" >> "$POS_PROP"
echo "# No extra spaces, symbols, or unnecessary capitalization" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "### Check UFS lifespan on every boot" >> "$POS_PROP"
echo "pos_ufs_health_show=true" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "### CPU, GPU, and I/O tweaks applied when a game is detected" >> "$POS_PROP"
echo "pos_cpu_tweak=true" >> "$POS_PROP"
echo "pos_gpu_tweak=true" >> "$POS_PROP"
echo "pos_io_tweak=true" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "### CPU behavior settings" >> "$POS_PROP"
echo "# Only works if pos_cpu_tweak=true" >> "$POS_PROP"
echo "# Available frequencies:" >> "$POS_PROP"
echo "# LITTLE: 576000 691200 940800 1113600 1324800 1516800 1651200 1708800 1804800" >> "$POS_PROP"
echo "# BIG:    691200 940800 1228800 1401600 1516800 1651200 1804800 2054400 2208000" >> "$POS_PROP"
echo "# Minimum LITTLE CPU frequency" >> "$POS_PROP"
echo "pos_cpu_tweak_min_freq_l=576000" >> "$POS_PROP"
echo "# Minimum BIG CPU frequency" >> "$POS_PROP"
echo "pos_cpu_tweak_min_freq_b=691200" >> "$POS_PROP"
echo "# Maximum LITTLE CPU frequency" >> "$POS_PROP"
echo "pos_cpu_tweak_max_freq_l=1804800" >> "$POS_PROP"
echo "# Maximum BIG CPU frequency" >> "$POS_PROP"
echo "pos_cpu_tweak_max_freq_b=2208000" >> "$POS_PROP"
echo "# CPU governor" >> "$POS_PROP"
echo "pos_cpu_tweak_governor=schedutil" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "### Thermal tweaks applied when a game is detected" >> "$POS_PROP"
echo "pos_thermal_tweak=false" >> "$POS_PROP"
echo "pos_force_thermal_disable=false" >> "$POS_PROP"
echo "# Adjust the temperature threshold for throttling" >> "$POS_PROP"
echo "# Only works if pos_thermal_tweak=true" >> "$POS_PROP"
echo "pos_thermal_tweak_temp=55°C" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "### Force-stop user apps when a game is detected (excluding whitelist)" >> "$POS_PROP"
echo "pos_force_stop_user_apps=true" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "### Whitelist settings" >> "$POS_PROP"
echo "pos_whitelist_prop=true" >> "$POS_PROP"
echo "pos_whitelist_prop_location=/sdcard" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "### Renderer switching when a game is detected" >> "$POS_PROP"
echo "pos_renderer_switch=true" >> "$POS_PROP"
echo "# Renderer pipelines:" >> "$POS_PROP"
echo "# Vulkan (Skia)= skiavk" >> "$POS_PROP"
echo "# Vulkan (Legacy)= vulkan" >> "$POS_PROP"
echo "# OpenGL (Skia) = skiagl" >> "$POS_PROP"
echo "# OpenGL = opengl" >> "$POS_PROP"
echo "pos_renderer_switch_pipeline=skiavk" >> "$POS_PROP"
echo "pos_renderer_switch_individual=false" >> "$POS_PROP"
echo "# Auto-relaunch apps to apply renderer changes properly" >> "$POS_PROP"
echo "# Only works if pos_renderer_switch=true" >> "$POS_PROP"
echo "pos_renderer_switch_relaunch=true" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "### List of games that should use Vulkan" >> "$POS_PROP"
echo "# Only works if pos_renderer_switch_individual=true" >> "$POS_PROP"
echo "# Example:" >> "$POS_PROP"
echo "# pos_renderer_games=com.mobile.legends com.garena.game.codm com.roblox.client" >> "$POS_PROP"
echo "pos_renderer_games=" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "# Experimental Section (Developer Side)" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "# Overclock GPU Clock Frequency to 960mHz" >> "$POS_PROP"
echo "# Warning: Kernel Side!" >> "$POS_PROP"
echo "pos_gpu_tweak_overclock=false" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "# Overclock BIG Cluster CPU Clock Frequency to 2627mHz" >> "$POS_PROP"
echo "# Warning: Kernel Side!" >> "$POS_PROP"
echo "pos_cpu_tweak_overclock=false" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "# Increase WiFi and Data signal" >> "$POS_PROP"
echo "# Warning: Kernel Side!" >> "$POS_PROP"
echo "pos_ant_tweak=false" >> "$POS_PROP"
echo "# ==========================================" >> "$POS_PROP"
echo "# Overclock Touch Sampling Rate to 512Hz" >> "$POS_PROP"
echo "# Warning: Kernel Side!" >> "$POS_PROP"
echo "pos_touch_tweak_overclock=false" >> "$POS_PROP"
}
create_pos_prop

# ====================================
# Exit to prevent further execution
# ====================================
exit 0
