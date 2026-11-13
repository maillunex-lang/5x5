# ETERNAL LEGENDS ONLINE v0.6: environment and validation

## Verified
- Source archive v0.5 inspected; Godot entry scene and scripts present.
- Local isolated container has Java but **no `godot`, `godot4`, `adb`, `sdkmanager`, or Android SDK**.
- Outbound DNS resolution to github.com fails in this container; cannot download Godot/export templates.
- NEXUS `nexus_godot_build_project(eternal-legends-online)` returned `unknown_or_unconfigured_project` (allowlist only agroempire, basheco, watermmo).
- NEXUS `nexus_godot_validate_change` returned `unknown_project` for eternal-legends-online.
- The only Termalin host is `Lunex`, an existing server. It was **not used or modified**, as the user requires no changes to working servers.
- Updated UI safe-area sizing to use viewport dimensions, not potentially zero `Control.size` in `_ready`.
- Throttled battle arena redraw/deep-copy to 10 Hz to reduce mobile CPU load.
- Ran Python source-contract tests. These do **not** compile or execute GDScript.

## Not verified / not produced
- Godot import, parse and runtime checks.
- Android export, APK signing, on-device FPS, notch layout, and game balance.
- No APK has been built. Do not label this package a beta APK.

## Commands when a clean isolated build runner becomes available
1. Install Godot 4.3+ and matching export templates, Android SDK and Java.
2. `godot --headless --path . --editor --quit` to import/parse resources.
3. `godot --headless --path . --quit-after 120` to smoke-test the main scene.
4. Configure Android export preset with local SDK/keystore paths, then `godot --headless --path . --export-debug Android eternal-legends-debug.apk`.
5. Inspect APK, install on an Android device, verify Safe Area, combat, saves and offline progression.