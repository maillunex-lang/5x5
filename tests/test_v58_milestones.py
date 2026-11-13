import unittest
from pathlib import Path
S=(Path(__file__).resolve().parents[1]/'scripts/main.gd').read_text()
class Milestones(unittest.TestCase):
 def test_54_arena_preloaded(self): self.assertIn('const ARENA_SCRIPT := preload(',S)
 def test_55_battle_summary(self): self.assertIn('Союзники %d/5 · Противники %d/5',S)
 def test_56_mastery_cap(self): self.assertIn('if rank >= 5 or gold < price:',S)
 def test_56_mastery_cost(self): self.assertIn('var price := 150 * (rank + 1)',S)
 def test_56_mastery_health(self): self.assertIn('mastery * 12',S)
 def test_56_mastery_attack(self): self.assertIn('mastery*3',S)
 def test_56_save(self): self.assertIn('"hero_mastery":hero_mastery',S)
 def test_56_legacy_save(self): self.assertIn('data.get("hero_mastery",[])',S)
 def test_57_boss_phase(self): self.assertIn('if battle_origin_chapter % 3 == 0:',S)
 def test_58_loot_bound(self): self.assertEqual(S.count('loot_total = mini(4000000,loot_total + 1)'),2)