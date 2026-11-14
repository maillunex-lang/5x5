import unittest
from pathlib import Path
S=Path(__file__).resolve().parents[1].joinpath('scripts/main.gd').read_text()
class UI(unittest.TestCase):
 def test_navigation(self):
  for fragment in ('func _go_back() -> void:', 'func _unhandled_input(event: InputEvent)', 'nav_history.append(screen)', 'scroll_view.scroll_vertical = 0','func _screen_topbar(destination: String)'):
   self.assertIn(fragment,S)
 def test_more_and_world(self):
  for fragment in ('func _show_more() -> void:', 'func _show_world() -> void:', '"preferences": _show_settings()', '"settings": _show_more()', '"world": _show_world()'):
   self.assertIn(fragment,S)
 def test_home_focus(self):
  body=S[S.index('func _show_map() -> void:'):S.index('func _show_world() -> void:')]
  self.assertIn('СОКРОВИЩНИЦА AFK',body)
  self.assertIn('ЧТО ДЕЛАЕМ ДАЛЬШЕ?',body)
  self.assertNotIn('for i in range(REGIONS.size())',body)
 def test_hero_controls_above_roster(self):
  section=S[S.index('func _show_heroes() -> void:'):S.index('func _upgrade_hero_mastery(')]
  self.assertLess(section.index('БОЕВОЕ ПОСТРОЕНИЕ'), section.index('СОСТАВ ГЕРОЕВ'))
  self.assertIn('formations_row.columns = 3',section)
 def test_existing_gameplay(self):
  self.assertIn('func _combat_tick(dt: float)',S)
  self.assertIn('func _save_data() -> void:',S)