# ETERNAL LEGENDS ONLINE v6.0 | Combat integrity and Android readiness

- Fixed an edge case in auto-battle: poison can kill the last combatant during a tick, and subsequent units no longer take extra actions.
- Guarded health bar against zero max HP and clamped visual percentage to 0..100.
- Reject negative and implausibly large gold in save files.
- Added six regression checks.
- Preserved save schema v13 and prior offline game content.
- No Godot runtime or Android APK validation claimed. No VPS, GitHub, or other games touched.