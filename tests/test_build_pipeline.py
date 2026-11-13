import pathlib
import unittest
ROOT = pathlib.Path(__file__).resolve().parents[1]

class BuildPipelineTests(unittest.TestCase):
    def test_smoke_script(self):
        script = (ROOT / 'tools/godot_smoke.gd').read_text()
        self.assertIn('extends SceneTree', script)
        self.assertIn('game._start_battle()', script)
        self.assertIn('quit(0)', script)
    def test_android_preset(self):
        text = (ROOT / 'export_presets.cfg').read_text()
        self.assertIn('platform="Android"', text)
        self.assertIn('architectures/arm64-v8a=true', text)
        self.assertIn('permissions/internet=false', text)
    def test_ci_runs_godot(self):
        text = (ROOT / '.github/workflows/godot-check.yml').read_text()
        self.assertIn('--editor --quit', text)
        self.assertIn('godot_smoke.gd', text)
    def test_build_script_fails_without_toolchain(self):
        text = (ROOT / 'tools/build_android.sh').read_text()
        self.assertIn('set -euo pipefail', text)
        self.assertIn('test -s build/eternal-legends-debug.apk', text)
    def test_dynamic_arena_method_safe(self):
        text = (ROOT / 'scripts/main.gd').read_text()
        self.assertIn('arena.call("set_units", units, battle_time)', text)

class RuntimeBuildSafetyTests(unittest.TestCase):
    def test_arena_shadow_restores_unit_transform(self):
        arena = (ROOT / 'scripts/battle_arena.gd').read_text()
        self.assertIn('_ellipse(position + Vector2(0, 17)', arena)
        self.assertIn('draw_set_transform(p)', arena)
        self.assertLess(arena.index('_ellipse(position + Vector2(0, 17)'), arena.index('draw_set_transform(p)'))
        self.assertIn('draw_set_transform(Vector2.ZERO)', arena)
    def test_ci_exports_and_uploads_apk(self):
        ci = (ROOT / '.github/workflows/godot-check.yml').read_text()
        self.assertIn('--export-debug Android', ci)
        self.assertIn('actions/upload-artifact@v4', ci)
        self.assertIn('test -s build/eternal-legends-debug.apk', ci)
    def test_ci_is_manual_triggerable(self):
        ci = (ROOT / '.github/workflows/godot-check.yml').read_text()
        self.assertIn('workflow_dispatch:', ci)
    def test_build_script_emits_hash_file(self):
        script = (ROOT / 'tools/build_android.sh').read_text()
        self.assertIn('build/SHA256SUMS.txt', script)