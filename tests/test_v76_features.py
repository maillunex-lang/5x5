import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MAIN = (ROOT / 'scripts/main.gd').read_text()
ARENA = (ROOT / 'scripts/battle_arena.gd').read_text()

class V76Features(unittest.TestCase):
    def test_critical_hit_vfx(self):
        self.assertIn('var critical_hit := rng.randf() < 0.12', MAIN)
        self.assertIn('target["last_critical"] = critical_hit', MAIN)
        self.assertIn('bool(effect.get("critical",false))', ARENA)
    def test_gear_comparison(self):
        self.assertIn('var current := _equipment_bonus(hero_id)', MAIN)
        self.assertIn('ΔATK %+d / ΔHP %+d', MAIN)
    def test_regional_weather(self):
        self.assertIn('region_index % 3 == 1', ARENA)
        self.assertIn('region_index % 4 == 2', ARENA)
        self.assertIn('if not reduced_effects and region_index % 3 == 1', ARENA)
    def test_mobile_navigation(self):
        self.assertIn('nav_grid.columns = 5', MAIN)
        self.assertIn('b.custom_minimum_size.y = 56', MAIN)
    def test_boss_telegraph(self):
        self.assertIn('actor.energy >= 75.0 and actor.energy < 100.0', MAIN)
        self.assertIn('На 50% HP включает щит', MAIN)

if __name__ == '__main__':
    unittest.main()