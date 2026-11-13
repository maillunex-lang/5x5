import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath("scripts/main.gd").read_text()
class BattleEntry(unittest.TestCase):
 def test_auto_start_on_battle_navigation(self):
  self.assertIn('"battle":\n   _show_battle()\n   if not active and party.size() == 5:\n    _start_battle()',s)
 def test_controls_before_arena(self):
  b=s.split('func _show_battle() -> void:',1)[1].split('func _toggle_speed',1)[0]
  self.assertLess(b.index('var actions := _panel()'),b.index('arena = Control.new()'))
 def test_visible_status(self):
  self.assertIn('Автобой начался • 0 / 90 сек',s)