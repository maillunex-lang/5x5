# ETERNAL LEGENDS ONLINE v5.2: Android beta validation hardening

- Validate saved party IDs for uniqueness, integer type and allowed 0..9 range before loading.
- Clamp invalid negative frame deltas and out-of-range combat speed in simulation.
- Expand Godot headless smoke test: scene, team, enemy stats, fight termination, journal stage, save file.
- Add read-only preflight utility `python3 tools/verify_release.py` that reports missing Godot/SDK/Java/ADB without claiming APK readiness.
- Add ten Python static regression tests. Save format remains v12.

**Validation boundary:** Python tests are source checks and independent balance assertions, not a Godot parser or device run. No APK is generated without engine and SDK. No live server/GitHub/other game changes.