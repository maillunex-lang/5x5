# ETERNAL LEGENDS ONLINE · Beta readiness

## Current build: v0.3 source candidate (not yet beta)

Completed in source:
- Godot 4 portrait project with local saving, 10 hero roster and 5-unit party.
- 5v5 automatic combat with cooldowns, energy, faction synergy, class behavior, 1/2/4 speed and win/loss rewards.
- Procedural arena backdrop with 10 character silhouettes, HP bars and Ural-inspired mountain landscape (2D prototype art, not production 2.5D assets).
- 12 named Bashkortostan regions, 20 encounters per chapter, quest rewards, AFK chest, 2-hour regional expeditions and relic rewards.
- Save schema v2 and backup copy (not cloud synchronization).
- 16 static Python tests passed at packaging time.

## Beta blockers (not verified)
1. Godot 4.3+ editor/headless parser import, scene load and actual combat playthrough.
2. Android export templates, SDK/JDK configuration, debug APK export and installation on physical device.
3. UI safe-area testing on portrait phones with camera notches and varied aspect ratios.
4. Gameplay balancing, accessibility and battery/thermal/performance measurements.
5. Replace temporary icons and silhouettes with original character models, animations and optimized textures.
6. Server authoritative login, persistence, battle and economy before advertising the game as online.
7. PvP, guilds, backend security, load tests, account recovery and privacy policy before online public beta.
8. Localization and cultural review of folklore-related references.

## Validation commands (on a machine with Godot 4.3+ installed)
```
python3 -m unittest discover -s tests -v
godot --headless --path . --editor --quit
godot --headless --path . --quit-after 120
```
`--quit-after 120` is a headless smoke check, not a substitute for playing on an Android device.

No VPS or existing project has been modified by this source package. Android APK was not produced.