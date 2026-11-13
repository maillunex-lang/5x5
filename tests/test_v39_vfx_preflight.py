import unittest
from pathlib import Path
from tools.android_preflight import inspect
ROOT=Path(__file__).resolve().parents[1]
ARENA=(ROOT/'scripts/battle_arena.gd').read_text()
MAIN=(ROOT/'scripts/main.gd').read_text()

class VfxPreflight(unittest.TestCase):
    def test_visual_event_cap(self):
        self.assertIn('MAX_VISUAL_EVENTS := 24', ARENA)
        self.assertIn('recent_skills.pop_front()', ARENA)
        self.assertIn('recent_impacts.pop_front()', ARENA)
    def test_reduced_effects_disables_shimmer(self):
        self.assertIn('if alive and not reduced_effects:', ARENA)
    def test_reduced_effects_slowdown(self):
        self.assertIn('ARENA_UPDATE_INTERVAL_REDUCED := 0.2', MAIN)
        self.assertIn('if reduced_effects else ARENA_UPDATE_INTERVAL', MAIN)
    def test_skill_vfx_has_palette(self):
        self.assertIn('func _draw_skill(', ARENA)
        for role in ('Маг','Танк','Убийца','Босс'):
            self.assertIn('"'+role+'":', ARENA)
    def test_project_preflight(self):
        report=inspect()
        self.assertTrue(report['project_godot'])
        self.assertTrue(report['main_scene'])
        self.assertTrue(report['android_export_preset'])
    def test_preflight_does_not_build(self):
        source=(ROOT/'tools/android_preflight.py').read_text()
        self.assertNotIn('export-debug',source)
        self.assertNotIn('rm -rf',source)