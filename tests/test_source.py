"""Static source contract checks. Does not execute Godot or prove playability."""
from pathlib import Path
import re, unittest
ROOT=Path(__file__).resolve().parents[1]
S=(ROOT/'scripts/main.gd').read_text()
CFG=(ROOT/'project.godot').read_text()
SCENE=(ROOT/'scenes/main.tscn').read_text()
class SourceContracts(unittest.TestCase):
 def test_entrypoint(self):
  self.assertIn('res://scenes/main.tscn',CFG)
  self.assertIn('res://scripts/main.gd',SCENE)
 def test_mobile(self):
  self.assertIn('viewport_width=540',CFG)
  self.assertIn('viewport_height=960',CFG)
  self.assertIn('get_display_safe_area',S)
 def test_heroes(self):
  heroes=S.split('const HEROES := [',1)[1].split('\n]',1)[0]
  self.assertEqual(10,len(re.findall(r'"name":',heroes)))
 def test_regions(self):
  regions=S.split('const REGIONS := [',1)[1].split('\n]',1)[0]
  self.assertEqual(12,len(re.findall(r'"name":',regions)))
 def test_battle(self):
  for x in ('func _start_battle','func _combat_tick','func _finish_battle','func _toggle_speed','frontline','faction_bonus'):
   self.assertIn(x,S)
 def test_afk_and_quests(self):
  for x in ('func _claim_afk','func _show_quests','func _claim_quest','quests_claimed'):
   self.assertIn(x,S)
 def test_save(self):
  self.assertIn('func _save_data',S)
  self.assertIn('func _load_data',S)
 def test_functions_unique(self):
  funcs=re.findall(r'^func (\w+)\(',S,re.M)
  self.assertEqual(len(funcs),len(set(funcs)))
 def test_no_tabs(self):
  self.assertNotIn('\t',S)
if __name__=='__main__':unittest.main()