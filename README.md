# 🎮 Performance of Sadness
  <img src="https://raw.githubusercontent.com/AkasTKzume69/Performance-of-Sadness/master/assert/banner.png" alt="Performance of Sadness Banner" width="100%">
</p>

A lightweight Magisk/KernelSU module designed to boost gaming performance and optimize system resources on Android devices — all **systemlessly** installed.

## Quick Access

[![Officially Supported Games](https://img.shields.io/badge/Games-List-brightgreen)](https://github.com/AkasTKzume69/Performance-of-Sadness/blob/master/common/game-list.md)
[![Changelog](https://img.shields.io/badge/Changelog-Updates-blue)](https://github.com/AkasTKzume69/Performance-of-Sadness/blob/master/changelog.md)
[![Installation Guide](https://img.shields.io/badge/Install-Guide-yellow)](https://github.com/AkasTKzume69/Performance-of-Sadness/blob/master/common/installation.md)
[![Support Group](https://img.shields.io/badge/Support-Telegram-blueviolet)](https://t.me/AkasTKzumeOFFICIAL)

## ⚠️ WARNING

- **Your warranty is now void.**
- I am not responsible for bricked devices, dead SD cards, thermonuclear war, you getting fired because your alarm app failed, or you falling into a hole because your flashlight wouldn’t turn on.
- Please do some research if you have any concerns about the features included in this module before flashing it!
- **YOU** are choosing to make these modifications, and if you point the finger at me for messing up your device, **I will laugh at you.**

## ✨ Features Overview (Systemless)
 - Smart game detection via logcat (Event-driven, with near-zero CPU usage: ~0.1%)
 - Auto-applies performance profile for games (CPU, GPU, I/O, and memory tweaks)
 - Dynamically switches to Vulkan Renderer for smoother gaming (restores to default when no game is running)
 - Force-stops background user apps (excluding whitelisted apps) to free up system resources
 - Auto-creates a whitelist file on first boot (editable via `/sdcard/whitelist.prop`)
 - UFS Health Checker monitors storage wear (sends detailed toast notifications)
 - Systemless installation — no permanent changes to your device’s firmware; fully restores on module uninstall
 - Provides friendly toast notifications for all key actions

## Help & Resources

Found a bug? Report it in our support group:  [Report Bug](https://t.me/AkasTKzumeOFFICIAL)

Learn how to exclude package names in `/sdcard/whitelist.prop`: [Whitelist Tutorial](https://github.com/AkasTKzume69/Performance-of-Sadness/blob/master/whitelist.md)

## 📝 IMPORTANT NOTE

Please do not DM me for random issues. Use the Support Group so others can help and solutions stay public. If you DM me asking why your phone lags while running 200 apps at once — I will pretend I never saw it.

© 2025 AkasTKzume | Licensed under the [GNU General Public License v3.0 (GPLv3)](https://www.gnu.org/licenses/gpl-3.0.html)
