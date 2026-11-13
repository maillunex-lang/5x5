# ETERNAL LEGENDS ONLINE v2.6: combat and save hardening

- Bosses on stage 20 now accumulate energy and execute a stronger charged strike with a battle-log warning. This is a prototype combat mechanic and has not been balanced on-device.
- Support units no longer consume their healing energy when no ally has missing health.
- Procedural arena resets damage flashes and HP history at the start of each new battle.
- Save schema v9; backup replacement now requires a recognizable save structure, and load falls back to the backup when the primary file is structurally invalid.
- Added 9 static regression checks. Updated old version assertion to accept forward-compatible schema versions.

## Validation

Run `python -m unittest discover -s tests -v` in project root. These tests inspect source contracts only. Godot headless parse/runtime tests and Android APK export remain **not executed** due to missing toolchain. No production servers, GitHub repositories or other games were modified.