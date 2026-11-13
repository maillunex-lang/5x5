import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath('scripts/main.gd').read_text()
class UIv90(unittest.TestCase):
 def test_fixed_bottom_nav(self):
  self.assertIn('nav_grid.columns = 5',s)
  self.assertIn('root.add_child(nav_grid)',s)
  self.assertIn('"s":"equipment"',s)
 def test_safe_area_retained(self):
  self.assertIn('DisplayServer.get_display_safe_area()',s)
 def test_campaign_button(self):
  self.assertIn('battle_cta.pressed.connect(_navigate.bind("battle"))',s)
 def test_battle_arena(self):
  self.assertIn('Vector2(0,370)',s)
 def test_save_compatibility(self):
  self.assertIn('const SAVE_VERSION := 14',s)