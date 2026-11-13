# ETERNAL LEGENDS ONLINE v3.7–v3.9 (source candidate)

## v3.7 Visual combat
- Preserved role-specific procedural skill effects and hit bursts.
- Reduced visual particle count and arc subdivisions, retained role palettes.

## v3.8 Android performance
- Capped pending impact and skill effect arrays at 24 events each.
- Reduced-effects setting now disables idle shimmer and bobbing, and throttles battle arena redraws from 10 to 5 Hz.
- Combat simulation remains on its existing fixed timestep; performance mode affects visuals only.

## v3.9 Android build preparation
- Added read-only `tools/android_preflight.py` for engine, ADB, Java and project checks.
- Existing `tools/build_android.sh` remains the actual export entry point; it requires Godot and Android SDK/export templates.
- In this execution environment: Godot and ADB unavailable. APK was NOT built. No Godot parser/runtime verification was possible.

## Validation
- 146 Python static/contract tests passed; no device performance measurements or engine runtime tests.
- Working servers, GitHub, other games and paid services were not touched.