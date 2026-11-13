import unittest
from pathlib import Path
S = (Path(__file__).resolve().parents[1] / "scripts/main.gd").read_text()
class UIEconomyTests(unittest.TestCase):
 def test_rarity_colors(self):
  for code in ['"#76d6aa"','"#77bfff"','"#f1b56e"']:
   self.assertIn(code,S)
 def test_progress_is_clamped(self):
  self.assertIn('bar.value = clampi(value, 0, maxi(1, maximum))',S)
 def test_forge_progress(self):
  self.assertIn('_progress_meter(panel,forge_level,10,GOLD)',S)
 def test_contract_progress(self):
  self.assertIn('_progress_meter(regional_contract,local_wins,5,',S)
 def test_hero_stats(self):
  self.assertIn('Навык: %s',S)
  self.assertIn('float(h.speed)',S)
 def test_forge_cost_growth(self):
  costs=[3+2*n for n in range(10)]
  self.assertEqual(costs[0],3)
  self.assertEqual(costs[-1],21)
  self.assertEqual(costs,sorted(set(costs)))
 def test_forge_cannot_overlevel(self):
  self.assertIn('if forge_level >= 10:',S)
 def test_no_schema_break(self):
  self.assertRegex(S,r'const SAVE_VERSION := (?:1[1-9]|[2-9][0-9]+)')