#!/system/bin/sh
#####Switch to vulkanskia renderthread backend pipeline delayed cleanup#####
#Wait a bit to let system fully boot
sleep 30
#Kill user apps except system ones safely
for a in $(pm list packages -3 | cut -f2 -d:); do
    am force-stop "$a" >/dev/null 2>&1 &
done
#Log completion
echo "[VulkanRendererSwitch] Forced user apps restart to apply Vulkan" >> /storage/emulated/0/Performance-of-Sadness.log
