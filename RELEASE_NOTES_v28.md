# ETERNAL LEGENDS ONLINE v2.8: Combat Status Visuals

Implemented lightweight vector indicators in the battle arena for shield, poison and stun. Shield adds a cyan arc and small shield marker; poison shows a green marker; stun shows an animated yellow bolt. Markers appear only on living units and use the existing combat snapshot, so they do not alter game balance, saves, or network state.

Verification: `python -m unittest discover -s tests -q`: 123 tests passed (static/source contract checks). Godot runtime and Android APK are **not** verified in this environment. Production servers and GitHub were not touched.