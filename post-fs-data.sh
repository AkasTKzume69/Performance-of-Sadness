#!/system/bin/sh
#####Switch to vulkan renderthread backend pipeline#####
#Set Vulkan renderer early before UI starts
setprop debug.hwui.renderer skiavk
#Log
echo "[VulkanRendererSwitch] Renderer set to Vulkan" > /data/local/tmp/vulkan_renderer.log
