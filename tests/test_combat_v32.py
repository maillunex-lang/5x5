import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
MAIN=(ROOT/'scripts/main.gd').read_text()
ARENA=(ROOT/'scripts/battle_arena.gd').read_text()
class CombatV32(unittest.TestCase):
 def test_enemy_archetypes(self):
  for role in ['Стрелок','Маг','Убийца','Танк','Босс']:
   self.assertIn('"'+role+'"',MAIN)
 def test_boss_phase_once(self):
  self.assertIn('int(actor.phase) == 1',MAIN)
  self.assertIn('actor.phase = 2',MAIN)
  self.assertIn('actor.shield = maxi(',MAIN)
 def test_skills_visuals(self):
  self.assertIn('func _draw_skill(',ARENA)
  self.assertIn('recent_skills = recent_skills.filter',ARENA)
  self.assertIn('previous_energy.clear()',ARENA)
 def test_reduced_effects(self):
  self.assertIn('if not reduced_effects and i < previous_energy.size()',ARENA)
  self.assertIn('if reduced_effects:',ARENA)
 def test_no_duplicate_functions(self):
  import re
  for content in (MAIN,ARENA):
   names=re.findall(r'^func\s+(\w+)\(',content,re.M)
   self.assertEqual(len(names),len(set(names)))