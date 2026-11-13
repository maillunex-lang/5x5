import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath('scripts/battle_arena.gd').read_text()
class V79SkillAnimations(unittest.TestCase):
 def test_class_visuals(self):
  for role in ['Маг','Поддержка','Танк','Убийца','Стрелок','Босс']:
   self.assertIn('"'+role+'":',s)
 def test_attack_pose(self):
  self.assertIn('p.y -= attack_pose * 5.0',s)
  self.assertIn('draw_set_transform(p, breathe + attack_pose',s)
 def test_accessibility(self):
  self.assertIn('if not reduced_effects and alive:',s)
  self.assertIn('if reduced_effects:\n  return',s)
 def test_effect_cap(self):
  self.assertIn('recent_skills.size() > MAX_VISUAL_EVENTS',s)