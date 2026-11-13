# ETERNAL LEGENDS ONLINE v1.6: economy hardening

## Changes
- Unique campaign completion relic for the final chapter boss cannot be farmed by replaying the last stage. Regular gold for replay remains available.
- Save migration now deduplicates equipped item IDs, preserving the first valid assignment for a purchased item.
- Save schema bumped to 6; older saves remain supported by existing optional-field defaults.
- Added six regression/static source tests. Updated schema assertion.

## Validation
- `python -m unittest discover -s tests -q`: 86 tests passed (static/source contract tests only).
- No Godot executable or Android SDK was available in this environment; GDScript runtime and Android APK remain unverified.
- No production servers, repositories, or other games changed.