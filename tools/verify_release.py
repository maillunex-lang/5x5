#!/usr/bin/env python3
"""Read-only Godot/Android preflight; never deploys or changes other projects."""
import os
import shutil
import subprocess
import sys
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
checks = {
 "Godot executable": shutil.which(os.environ.get("GODOT_BIN", "godot")),
 "Android SDK": os.environ.get("ANDROID_HOME") or os.environ.get("ANDROID_SDK_ROOT"),
 "Java": shutil.which("java"),
 "ADB": shutil.which("adb"),
}
for name, value in checks.items():
 print(f"{'OK' if value and (name != 'Android SDK' or Path(value).is_dir()) else 'MISSING'}: {name}: {value or '-'}")
required = ["project.godot", "scenes/main.tscn", "scripts/main.gd", "scripts/battle_arena.gd", "export_presets.cfg", "tools/godot_smoke.gd"]
for rel in required:
 if not (ROOT / rel).is_file():
  print("MISSING PROJECT FILE:", rel)
  sys.exit(2)
if not checks["Godot executable"]:
 print("Godot runtime unavailable; no engine checks or APK build performed")
 sys.exit(3)
print("Godot version:")
subprocess.run([checks["Godot executable"], "--version"], check=True)
print("Run the smoke test with: godot --headless --path . --script res://tools/godot_smoke.gd")