from pathlib import Path
import re,unittest
ROOT=Path(__file__).resolve().parents[1]
S=(ROOT/'scripts/main.gd').read_text()
class HardeningContracts(unittest.TestCase):
 def test_fixed_timestep(self):
  self.assertIn('while tick >= BATTLE_STEP',S)
  self.assertIn('clampf(delta, 0.0, MAX_FRAME_DELTA)',S)
 def test_battle_statistics(self):
  self.assertIn('total_damage += applied',S)
  self.assertIn('total_healing += healed',S)
 def test_quest_streak(self):
  self.assertIn('best_streak = maxi(best_streak,current_streak)',S)
  self.assertIn('current_streak = 0',S)
 def test_backup_recovery(self):
  self.assertIn('if FileAccess.file_exists(SAVE_PATH):',S)
  self.assertIn('FileAccess.file_exists(BACKUP_PATH)',S)
 def test_save_upgrade(self):
  self.assertRegex(S, r'const SAVE_VERSION := (?:[3-9]|[1-9][0-9]+)')
  self.assertIn('"best_streak":best_streak',S)
 def test_no_redefined_functions(self):
  names=re.findall(r'^func (\w+)\(',S,re.M)
  self.assertEqual(len(names),len(set(names)))
if __name__=='__main__':unittest.main()