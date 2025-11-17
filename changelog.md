### V8 2025-11-17
* Introduced new Dynamic Vulkan Pipeline Renderer Switch (Only applies when game launched)
* Introduced new game-list.pof (This file stores all game that includes on Performance of Sadness AI apply settings)
* Introduced new Dalvik Hyperthreading
* Introduced new pof_profile and pof_restore_profile
* Improved Performance of Sadness AI
* Improved GPU Frequencies on pof_profile
* Improved log scripts on /sdcard/Performance-of-Sadness.log
* Fixed video color bug (Vulkan Pipeline)
* Fixed some miscellaneous and scripts
* Dropped /vendor/bin/perf_profile.sh
* Dropped /vendor/bin/restore_perf_profile.sh
* Many under the hood changes.

### V7 2025-11-05
* Fixed some miscellaneous and scripts

### V6 2025-11-04
* Improved Performance of Sadness AI
* Introduced new Dynamic CPU Throttling (Zero CPU/RAM usage)
* Added more games detection of Performance Sadness AI
* Added CPU/GPU Tuning on Performance of Sadness AI
* Added Virtual Memory and Memory Tuning on Performance of Sadness AI
* Added I/O Scheduler Tuning on Performance of Sadness AI
* Added Background Tasks Pressure Reduction on Performance of Sadness AI
* Reverted to stock all /vendor/etc/thermal*conf
* Improved logs at /sdcard/Performance-of-Sadness.log
* Fixed some miscellaneous and scripts

### V5 2025-11-03
* Introduced new Performance of Sadness AI (Zero CPU/RAM usage)
* Introduced new /vendor/perf_profile.sh
* Introduced new /vendor/restore_perf_profile.sh
* Introduced new Performance of Sadness log /sdcard/Performance-of-Sadness.log
* Switched to vulkan renderthread backend pipeline (Global)

### V4 2025-11-02
* Introduced new Touch Boost system prop
* Introduced new /vendor/etc/msm_irqbalance.conf
* Added mdss, smem-rpm, mpm, kgsl, glink_lpass /vendor/etc/msm_irqbalance.conf

### V3 2025-10-24
* Introduced new /vendor/etc/powerhint.json
* Increased aggressive CPULittleClusterMinFreq /vendor/etc/powerhint.json
* Increased aggressive CPUBigClusterMinFreq /vendor/etc/powerhint.json
* Increased aggressive GPUMinFreq /vendor/etc/powerhint.json
* Increased SUSTAINED_PERFORMANCE CPUBigClusterMaxFreq 1401600 to Highest
* Increased SUSTAINED_PERFORMANCE CPULittleClusterMaxFreq 1651200 to Highest
* Increased INTERACTION CPUBigClusterMaxFreq 1228800 to 1651200
* Reverted to stock /vendor/etc/thermal-class0.conf
* Reverted to stock /vendor/etc/thermal-camera.conf
* Reverted to stock /vendor/etc/thermal-phone.conf
* Reverted to stock /vendor/etc/thermal-video.conf
* Reverted to stock /vendor/etc/thermal-youtube.conf

### V2 2025-10-18
* Removed /vendor/etc/thermal-arvr.conf
* Removed /vendor/etc/thermal-camera.conf
* Removed /vendor/etc/thermal-class0.conf
* Removed /vendor/etc/thermal-engine.conf
* Removed /vendor/etc/thermal-extreme.conf
* Removed /vendor/etc/thermal-high.conf
* Removed /vendor/etc/thermal-map.conf
* Removed /vendor/etc/thermal-mgame.conf
* Removed /vendor/etc/thermal-nolimits.conf
* Removed /vendor/etc/thermal-normal.conf
* Removed /vendor/etc/thermal-phone.conf
* Removed /vendor/etc/thermal-tgame.conf
* Removed /vendor/etc/thermal-video.conf
* Removed /vendor/etc/thermal-youtube.conf

### V1 2025-10-17
* Initial release
