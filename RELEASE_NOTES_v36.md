# ETERNAL LEGENDS ONLINE v3.3–v3.6

## v3.3 Audit
- Guard arena configuration/reset against missing arena nodes.
- Explicit integer conversion for shield caps and boss shield calculations.

## v3.4 Automated checks
- Added 12 regression checks covering battle math invariants, boss phase guard, timeout and victory checks, and mobile layout source invariants.
- 140 Python tests pass; these are static/invariant tests, NOT engine-executed battles.

## v3.5 Balance
- Added explicit enemy HP, attack, and boss HP scaling constants, currently all set to 1.0 to preserve existing gameplay balance.
- Tested increasing enemy HP by campaign stage, boss HP advantage, and positive attack values.

## v3.6 Adaptive Android UI
- Navigation now uses two rows of three controls instead of six compressed buttons in one row.
- Safe area margins are recalculated on viewport resize, including all four sides for cutouts/insets.
- Hero battle bars use a five-column grid.

## Unverified
- Godot 4 parser, engine runtime, on-device visual layout, frame rate, and APK export have not been verified in this environment. APK not generated.
- These changes are a source candidate, not an Android beta.

No changes to VPS, GitHub, or other game projects.