import pathlib, unittest
S=(pathlib.Path(__file__).resolve().parents[1]/"scripts/main.gd").read_text()
class EightStages(unittest.TestCase):
 def test_formation(self): self.assertIn('func _set_formation(index: int)',S)
 def test_talents(self): self.assertIn('func _buy_talent(index: int)',S)
 def test_talent_cap(self): self.assertIn('talent_points[index] >= 10',S)
 def test_battle_journal(self): self.assertIn('battle_history.resize(20)',S)
 def test_bestiary(self): self.assertIn('func _show_bestiary()',S)
 def test_codex(self): self.assertEqual(S.count('"Агидель хранит'),1)
 def test_region_rewards(self): self.assertIn('claimed_region_rewards.has(region_id)',S)
 def test_accessibility(self): self.assertIn('func _toggle_large_text()',S)
 def test_expedition_ledger(self): self.assertIn('expedition_total_gold = mini(2000000000, expedition_total_gold + expedition_reward)',S)
 def test_save_fields(self):
  for field in ['formation_index','talent_points','battle_history','discovered_bosses','claimed_region_rewards','accessibility_large_text','expedition_total_gold','codex_seen']:
   self.assertIn('"'+field+'":'+field,S)
 def test_load_migration(self): self.assertIn('data.get("talent_points",[0,0,0])',S)
 def test_one_claim(self): self.assertIn('claimed_region_rewards.append(region_id)',S)