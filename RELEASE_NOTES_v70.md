# ETERNAL LEGENDS ONLINE v7.0

Five sequential development stages, isolated source tree.

- v6.6: ability activation counter in combat results, reset at battle start.
- v6.7: region-dependent opponent health multiplier (1.00 to 1.12).
- v6.8: regional familiarity up to 10 ranks, awarded on every fifth win in that region, +2 HP per rank to party members in that region.
- v6.9: owned equipment reforging up to three ranks, consuming common loot. Each rank adds +2 attack and +8 HP; values persisted and restored.
- v7.0: larger touch targets and clipped button labels; regression tests for the new systems.

Save schema: 14. Old saves load with zero defaults for new fields. Existing v13 saves remain compatible. Python unittest checks are static/contract checks, NOT Godot engine tests. No APK built. No production services, other games or GitHub modified.