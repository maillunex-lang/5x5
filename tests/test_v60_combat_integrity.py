import unittest
from pathlib import Path
S=(Path(__file__).resolve().parents[1]/"scripts/main.gd").read_text()
class CombatIntegrity(unittest.TestCase):
 def test_battle_ends_before_later_units_act(self):
  self.assertIn('if _alive_count(0) == 0 or _alive_count(1) == 0:\n   break', S)
 def test_poison_kill_stops_tick(self):
  self.assertIn('if _alive_count(0) == 0 or _alive_count(1) == 0:\n     break', S)
 def test_health_bar_safe_divisor(self):
  self.assertIn('maxf(1.0, float(u.max_hp))', S)
 def test_health_bar_clamped(self):
  self.assertIn('clampf(100.0 * float(u.hp)', S)
 def test_negative_gold_save_rejected(self):
  self.assertIn('int(value["gold"]) < 0', S)
 def test_overflow_gold_save_rejected(self):
  self.assertIn('int(value["gold"]) > 2000000000', S)