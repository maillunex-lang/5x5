import unittest
from pathlib import Path
S=Path(__file__).resolve().parents[1].joinpath("scripts/main.gd").read_text()
class VIP(unittest.TestCase):
 def test_demo_only(self):
  self.assertIn("const VIP_TRIAL_SECONDS := 7 * 24 * 3600",S)
  self.assertIn("const VIP_UNLOCK_WINS := 5",S)
  self.assertIn("if vip_trial_claimed or battle_wins < VIP_UNLOCK_WINS:",S)
  self.assertIn("vip_expires_at = int(Time.get_unix_time_from_system()) + VIP_TRIAL_SECONDS",S)
 def test_save_load(self):
  self.assertIn('"vip_expires_at":vip_expires_at,"vip_trial_claimed":vip_trial_claimed',S)
  self.assertIn('data.get("vip_trial_claimed",false)',S)
  self.assertIn('data.get("vip_expires_at",0)',S)
 def test_no_battle_buff(self):
  vip=S[S.index("func _vip_active()"):S.index("func _show_settings()")]
  self.assertNotIn("actor.atk =",vip)
  self.assertNotIn("relics +=",vip)
 def test_navigation(self):
  self.assertIn('"vip": _show_vip()',S)
  self.assertIn('_navigate.bind("vip")',S)