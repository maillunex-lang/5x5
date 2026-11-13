import unittest
from pathlib import Path
S=(Path(__file__).resolve().parents[1]/'scripts/main.gd').read_text()
class FiveTasksTests(unittest.TestCase):
 def test_drop_before_use(self):
  block=S.split('func _finish_battle(won: bool) -> void:',1)[1].split('func _show_quests()',1)[0]
  self.assertLess(block.index('var drop_tier := _roll_loot_tier()'),block.index('last_battle_result = "Победа!'))
 def test_reward_cap(self): self.assertIn('gold = mini(2000000000,gold + reward)',S)
 def test_region_in_battle(self): self.assertIn('REGIONS[chapter-1].name,24,GOLD',S)
 def test_stage_in_battle(self): self.assertIn('Этап %d/20',S)
 def test_boss_label(self): self.assertIn('"БОСС" if stage == 20',S)
 def test_frontline_guard(self): self.assertIn('if party.size() >= 2:',S)
 def test_combat_speed_floor(self): self.assertIn('maxf(0.1,float(actor.speed))',S)
 def test_journal_winrate(self): self.assertIn('Успех: %d%%',S)
 def test_journal_stage(self): self.assertIn('entry.chapter,entry.stage,entry.damage,entry.healing',S)
 def test_save_schema(self): self.assertRegex(S,r'const SAVE_VERSION := 1[234]')
 def test_save_party_validation(self): self.assertIn('value["party"].size() != 5',S)
 def test_save_future_reject(self): self.assertIn('int(value["version"]) <= SAVE_VERSION',S)