<strong>
Upcoming Update
</strong>

* [Module] Fix error installing on Magisk
* [CPU] Use non-legacy tweaks
* [CPU] Add allow RT tasks to use CPU indefinitely
* [CPU] Add lowers latency for multiple competing RT tasks
* [CPU] Add Disable Energy-Aware Scheduling
* [CPU] Add Let child processes run immediately after forking
* [GPU] Use non-legacy tweaks
* [GPU] Add force GPU awake
* [GPU] Add GPU Frequency and Devfreq capping 
* [GPU] Add <code>min</code>, <code>max</code>, <code>thermal</code> pwrlevel
* [GPU] Add L3 cache boost
* [GPU] Add disable all GPU Idle / Sleep
* [GPU] Add GPU keep active
* [GPU] Add relax FT policy for extreme FPS
* [GPU] Add force immediate preempt mode
* [GPU] Add disable <code>HWCG</code>
* [I/O] Use non-legacy tweaks
* [I/O] Add <code>read_ahead_kb</code>
* [I/O] Add <code>nr_requests</code>
* [I/O] Add <code>nomerges</code>
* [I/O] Add <code>iostats</code>
* [I/O] Add <code>add_random</code>

<strong>
V1-20251208 (December 08 2025)
</strong>

* [Module] Separate scripts to avoid conflicts
* [Service] Don't call multiple <code>su</code> to execute all scripts
* [Service] Wait until device fully boots
* [Service] Execute all dynamic auto generated restore scripts
* [Service] Execute auto detect user apps
* [AI] Add UFS Health Checker every boot
* [AI] Add CPU, GPU, IO, Thermal, Thermal Disable, Renderer Switch and Kill User-apps
* [AI] Make sure user must unlock the keyguard before proceed
* [AI] Use dumpsys activity to detected the keyguard
* [AI] Break dumpsys activity if user unlock the keyguard already to save CPU usage
* [AI] Add initial checks for scripts to avoid missing files and exit if initial checks fail
* [AI] Add welcome note after keyguard unlock
* [AI] Add auto relaunch to make sure renderer applies properly
* [AI] Do not relaunch if renderer switch is off
* [AI] Use logcat brief event input-focus to detect game
* [AI] Do not countdown to restore if renderer switch is not true
* [AI] Use am force-stop to kill current game
* [AI] Use monkey -p to relaunch the current game
* [AI] Make sure all configurations before run the scripts
* [AI] Create POS_Whitelist.prop and POS.prop if not exist
* [CPU] Use legacy tweaks for now
* [CPU] Add policy 0 and policy 6
* [CPU] Read CPU configuration first before continue
* [CPU] Add default fallback
* [CPU] Separate Little and Big cluster
* [CPU] Add <code>governor</code>, <code>min/max</code> frequency, <code>hispeed_freq</code>, <code>hispeed_load</code>, <code>boost</code>, <code>boostpulse</code> both <code>policy 0</code> and <code>policy 6</code>
* [CPU] Make sure all cores are online
* [CPU] Exit to prevent further execution
* [GPU] Use legacy tweak for now
* [GPU] Force <code>clock</code>, <code>bus</code>, <code>rail</code>, and <code>nonap</code> on
* [GPU] Lock GPU and Devfreq at max frequency
* [GPU] Set min, max, and default power level to maximum performance
* [GPU] Ensure thermal logic cannot override the power level
* [GPU] Enable L3 Cache Boost
* [GPU] Disable all GPU Idle/Sleep
* [GPU] Keep GPU Active
* [GPU] Relax FT Policy for extreme FPS
* [GPU] Force immediate preempt mode
* [GPU] Enable Bus Split
* [GPU] Disable HWCG
* [GPU] Exit to prevent further execution
* [I/O] Use legacy tweak for now
* [I/O] Ignore loop and zram
* [I/O] Set <code>read-ahead</code> to 1024
* [I/O] Set <code>nr-request</code> to 256
* [I/O] Set <code>nomerges</code> to 2
* [I/O] Set <code>iostats</code> to 0
* [I/O] Set <code>add_random</code> to 0
* [I/O] Exit to prevent further execution
* [Thermal] Kill user-space thermal
* [Thermal] Use custom throttle on configurations
* [Thermal-Disable] Disable thermal using <code>mode</code>
* [Thermal-Disable] Include only CPU <code>usr</code>, <code>step</code>, <code>touch</code> zones
