# ETERNAL LEGENDS ONLINE v1.5 | five-stage source update

This is a **source-only candidate**, not a tested APK. It has not been parsed or run by Godot.

## Implemented in sequence
1. **v1.1 Equipment:** five purchasable items, ownership, assigning one item to each hero, HP/attack modifiers in combat, persistent save.
2. **v1.2 Regional bosses:** the lead enemy on every twentieth stage is named for the region, has extra HP/attack, and awards a relic plus bonus gold upon victory.
3. **v1.3 Daily challenge:** three victories per UTC day earn a one-time 150 gold claim; reset on UTC day change, saved locally.
4. **v1.4 Achievements:** one-time rewards for 5/25/75/150 victories, persistent claim bitmask.
5. **v1.5 Mobile UX:** equipment navigation, reduced visual effects setting, persisted configuration, migration defaults for older save files.

## Validation
- 80/80 Python static source-contract tests pass. They verify source structure, **not runtime correctness**.
- No Godot 4 executable or Android SDK available in isolated container. No APK or physical device test.
- NEXUS project remains inspection-only, and production servers were not touched.

## Known limitations
- Combat balance is preliminary; boss difficulty and equipment economy require real playtesting.
- Daily tasks use UTC calendar days rather than local time zone; clock manipulation is possible with offline saves.
- Only one equipped item per hero; this is a first inventory iteration, not a complete multi-slot system.
- No multiplayer, online account or server authority.

## Next gates
Run Godot 4.3 headless import/parser, smoke test, Android debug export, and Android device QA. Fix any reported parser/runtime issues before labeling this a beta.