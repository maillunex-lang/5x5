import unittest
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
MAIN = (ROOT/'scripts/main.gd').read_text()
class SkillTests(unittest.TestCase):
 def test_all_units_initialize_status(self):
  self.assertEqual(MAIN.count('"shield":0,"poison":0,"stun":0'),2)
 def test_status_ticks_are_deterministic(self):
  self.assertIn('actor.poison = maxi(0, int(actor.poison) - 1)',MAIN)
  self.assertIn('actor.stun = maxi(0, int(actor.stun) - 1)',MAIN)
 def test_shield_prevents_damage(self):
  self.assertIn('damage -= absorbed',MAIN)
  self.assertIn('target.shield = maxi(0, int(target.shield) - absorbed)',MAIN)
 def test_hero_skill_coverage(self):
  for line in ('0, 4:', '1:', '2, 7:', '5:', '6, 9:', '8:'):
   self.assertIn(line,MAIN)
 def test_save_version(self):
  self.assertRegex(MAIN, r'const SAVE_VERSION := (?:1[0-9]|[2-9][0-9]+)')
if __name__=='__main__': unittest.main()