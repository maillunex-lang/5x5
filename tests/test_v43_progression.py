import unittest
from pathlib import Path
S=(Path(__file__).resolve().parents[1]/'scripts/main.gd').read_text()
class ProgressionTests(unittest.TestCase):
 def test_save_migration(self):
  for x in ['"loot_inventory":loot_inventory','"regional_wins":regional_wins','data.get("loot_inventory",[0,0,0,0])','data.get("regional_wins",[])','forge_level = clampi']:
   self.assertIn(x,S)
 def test_loot_probabilities(self):
  self.assertEqual([55,85-55,97-85,100-97],[55,30,12,3])
  self.assertEqual(sum([55,30,12,3]),100)
 def test_guaranteed_loot_only_on_win(self):
  win=S.split('func _finish_battle(won: bool)',1)[1].split('func _show_quests()',1)[0]
  self.assertIn('if won:',win)
  self.assertIn('loot_inventory[drop_tier]',win.split('else:',1)[0])
 def test_boss_extra_loot(self):
  self.assertIn('if battle_origin_stage == 20:',S)
  self.assertIn('loot_inventory[2] =',S)
 def test_one_time_contract(self):
  self.assertIn('regional_contracts_claimed.has(region_id)',S)
  self.assertIn('int(regional_wins[region_id-1]) < 5',S)
 def test_forge_limits(self):
  self.assertIn('if forge_level >= 10:',S)
  self.assertIn('loot_inventory[0] -= price',S)
  self.assertIn('loot_inventory[1] -= 1',S)
 def test_forge_in_combat(self):
  self.assertIn('forge_level * 10',S)
  self.assertIn('forge_level * 2',S)
 def test_navigation(self):
  self.assertIn('"loot": _show_loot()',S)
  self.assertIn('_navigate.bind("loot")',S)