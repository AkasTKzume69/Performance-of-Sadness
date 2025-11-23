### V12-20251124 ###
* Added force stop user apps when game detected
* Added whitelist.prop on /sdcard/whitelist.prop to exclude packages on force stop user apps
* Reverted to stock msm-irqbalance.conf
* Dropped powerhint.json (since veux/peux not implement yet)
* Nuked all ALPHA and BETA tweaks
* Improved Performance of Sadness AI
* Improved Dynamic Vulkan Switching
* Minor fixes to miscellaneous components and scripts
### V11-20251122 ###
* Introduced new UFS Health Checker
* Dropped all ALPHA and BETA tweaks
* Minor adjustments and fixes to miscellaneous components and scripts
### V10-20251120 ###
* Switched to logcat (Event-Based)  Game Detection (Extremely Optimized)
* Dropped logs from /sdcard/Performance-of-Sadness.log
* Reduced CPU usage on Game Detection
* Optimized performance and renderer switching
* Improved start of Performance of Sadness AI and service on every boot
* Added more supported games
* Major fixes to miscellaneous components and scripts
* Numerous under-the-hood optimizations and internal changes
### V9-20251118 ###
* Introduced new Toast Notification for Performance of Sadness updates
* Added restore countdown for restoring profile
* Improved Performance of Sadness AI logic and efficiency
* Reduced delay when relaunching game
* Fixed Current Renderer blank on Performance-of-Sadness.log
* Fixed miscellaneous issues and script errors
### V8 — 2025-11-17 ###
* Introduced the Dynamic Vulkan Pipeline Renderer Switch (applies only when a game is launched)
* Added new game-list.pof file (stores all supported games for Performance of Sadness AI)
* Added new Dalvik Hyperthreading
* Added new pof_profile and pof_restore_profile scripts
* Improved Performance of Sadness AI logic and efficiency
* Enhanced GPU frequency tuning in pof_profile
* Improved logging at /sdcard/Performance-of-Sadness.log
* Fixed video color issue related to the Vulkan pipeline
* Fixed various miscellaneous issues and script errors
* Dropped deprecated scripts:
        /vendor/bin/perf_profile.sh        /vendor/bin/restore_perf_profile.sh
* Numerous under-the-hood optimizations and internal changes
### V7 — 2025-11-05 ###
* Minor fixes to miscellaneous components and scripts
### V6 — 2025-11-04 ###
* Improved Performance of Sadness AI
* Introduced Dynamic CPU Throttling (Zero CPU/RAM usage)
* Expanded game detection capabilities
* Added CPU/GPU tuning options
* Added Virtual Memory and RAM tuning
* Added I/O Scheduler tuning
* Added Background Task Pressure Reduction
* Reverted all /vendor/etc/thermal*conf files to stock
* Improved logging at /sdcard/Performance-of-Sadness.log
* Fixed miscellaneous issues and script errors
### V5 — 2025-11-03 ###
* Introduced redesigned Performance of Sadness AI (Zero CPU/RAM usage)
* Added new /vendor/perf_profile.sh
* Added new /vendor/restore_perf_profile.sh
* Introduced new logging system at /sdcard/Performance-of-Sadness.log
* Switched globally to Vulkan renderthread backend pipeline
### V4 — 2025-11-02 ###
* Added new Touch Boost system property
    •Introduced /vendor/etc/msm_irqbalance.conf
* Added mdss, smem-rpm, mpm, kgsl, and glink_lpass entries
### V3 — 2025-10-24 ###
* Added new /vendor/etc/powerhint.json
* Increased aggressive Little Cluster minimum frequency
* Increased aggressive Big Cluster minimum frequency
* Increased aggressive GPU minimum frequency
* Updated SUSTAINED_PERFORMANCE and INTERACTION CPU maximum frequencies
* Reverted multiple /vendor/etc/thermal-*.conf files back to stock
### V2 — 2025-10-18 ###
* Removed multiple thermal configuration files, including:
      thermal-arvr.conf
      thermal-camera.conf
      thermal-class0.conf
      thermal-engine.conf
      thermal-extreme.conf
      thermal-high.conf
      thermal-map.conf
      thermal-mgame.conf
      thermal-nolimits.conf
      thermal-normal.conf
      thermal-phone.conf
      thermal-tgame.conf
      thermal-video.conf
      thermal-youtube.conf
### V1 — 2025-10-17 ###
* Initial release
