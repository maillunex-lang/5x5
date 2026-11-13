import unittest
from pathlib import Path
S=Path(__file__).resolve().parents[1].joinpath('scripts/main.gd').read_text()
class VipQuality(unittest.TestCase):
 def test_status(self):
  self.assertIn('func _vip_remaining_seconds() -> int:',S)
  self.assertIn('func _vip_status_text() -> String:',S)
  self.assertIn('Пробный VIP завершён',S)
 def test_live_expiry(self):
  self.assertIn('func _process_vip_ui(delta: float)',S)
  self.assertIn('_process_vip_ui(delta)',S)
  self.assertIn('vip_status_refresh_accumulator < 1.0',S)
 def test_no_paywall(self):
  self.assertIn('Все игровые возможности доступны и без VIP.',S)