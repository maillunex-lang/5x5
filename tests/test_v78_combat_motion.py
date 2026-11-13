import unittest
from pathlib import Path
source=Path(__file__).resolve().parents[1].joinpath('scripts/battle_arena.gd').read_text()
class CombatMotion(unittest.TestCase):
 def test_trails_are_bounded(self):
  self.assertIn('if attack_trails.size() > MAX_VISUAL_EVENTS:',source)
  self.assertIn('attack_trails.pop_front()',source)
 def test_reduced_effects(self):
  self.assertIn('if not reduced_effects and i < previous_hp.size()',source)
  self.assertIn('if reduced_effects:\n  return',source)
 def test_impact_recoil(self):
  self.assertIn('hit_offset.x = sin(',source)
 def test_trail_lifetime(self):
  self.assertIn('time_seconds + 0.28',source)
  self.assertIn('attack_trails = attack_trails.filter(',source)
 def test_reset(self):
  self.assertIn('attack_trails.clear()',source)