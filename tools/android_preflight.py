#!/usr/bin/env python3
"""Read-only environment and project readiness report. Never builds or deploys."""
import json
import shutil
import subprocess
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

def inspect():
    godot = shutil.which('godot') or shutil.which('godot4')
    adb = shutil.which('adb')
    java = shutil.which('java')
    report = {
        'project': str(ROOT),
        'project_godot': (ROOT / 'project.godot').is_file(),
        'main_scene': (ROOT / 'scenes/main.tscn').is_file(),
        'android_export_preset': 'name="Android"' in (ROOT / 'export_presets.cfg').read_text(),
        'godot_binary': godot,
        'adb_binary': adb,
        'java_binary': java,
        'godot_version': None,
        'can_attempt_android_export': bool(godot and java),
    }
    if godot:
        result = subprocess.run([godot, '--version'], capture_output=True, text=True, timeout=15)
        report['godot_version'] = (result.stdout or result.stderr).strip()
        report['godot_version_exit_code'] = result.returncode
    return report

if __name__ == '__main__':
    print(json.dumps(inspect(), ensure_ascii=False, indent=2))