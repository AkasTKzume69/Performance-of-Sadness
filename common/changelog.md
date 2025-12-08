<h3>
<strong>
V1-20251208 (December 08 2025)
</strong>
</h3>

### Module
* [Service] Don't call multiple <code>su</code> to execute all scripts
* [Service] Wait until device fully boots
* [Service] Execute all auto generated restore scripts
* [Service] Execute auto detect user apps

### Performance of Sadness
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
