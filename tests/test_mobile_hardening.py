import unittest
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
MAIN = (ROOT/'scripts/main.gd').read_text()
class MobileHardening(unittest.TestCase):
    def test_safe_area_uses_viewport_not_uninitialized_control_size(self):
        self.assertIn('var viewport_size := get_viewport_rect().size', MAIN)
        self.assertIn('viewport_size.y / float(screen_size.y)', MAIN)
        self.assertNotIn('safe_rect.position.y) * size.y', MAIN)
    def test_arena_redraw_throttled(self):
        self.assertIn('arena_redraw_accumulator >= (ARENA_UPDATE_INTERVAL_REDUCED if reduced_effects else ARENA_UPDATE_INTERVAL)', MAIN)
        self.assertIn('arena_redraw_accumulator = 0.0', MAIN)
    def test_fixed_timestep_preserved(self):
        self.assertIn('while tick >= BATTLE_STEP and steps < MAX_CATCHUP_STEPS and active:', MAIN)
    def test_android_no_runtime_claim(self):
        self.assertIn('run/main_scene="res://scenes/main.tscn"',(ROOT/'project.godot').read_text())