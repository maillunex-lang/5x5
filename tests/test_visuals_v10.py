import unittest
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]

class VisualV10Tests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.arena = (ROOT/'scripts/battle_arena.gd').read_text()
        cls.main = (ROOT/'scripts/main.gd').read_text()
    def test_12_region_indices(self):
        self.assertIn('clampi(region, 0, 11)', self.arena)
    def test_class_silhouettes(self):
        for role in ('Танк','Стрелок','Маг','Поддержка','Убийца'):
            self.assertIn('role == "'+role+'"', self.arena)
    def test_animated_idle(self):
        self.assertIn('sin(elapsed * 3.4', self.arena)
    def test_impact_decay(self):
        self.assertIn('time_seconds + 0.42', self.arena)
        self.assertIn('recent_impacts = recent_impacts.filter(', self.arena)
    def test_arena_configured_by_chapter(self):
        self.assertIn('arena.call("configure", chapter - 1', self.main)
    def test_hero_health_visual(self):
        self.assertIn('38 * hp_fraction', self.arena)
    def test_mobile_lightweight(self):
        self.assertNotIn('ShaderMaterial', self.arena)
        self.assertIn('queue_redraw()', self.arena)