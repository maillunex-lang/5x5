import re
import unittest
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
MAIN=(ROOT/'scripts/main.gd').read_text()
ARENA=(ROOT/'scripts/battle_arena.gd').read_text()
class BetaContracts(unittest.TestCase):
 def test_visual_arena_linked(self):
  self.assertIn('res://scripts/battle_arena.gd',MAIN)
  self.assertIn('func _draw()',ARENA)
  self.assertIn('arena.call("set_units", units, battle_time)',MAIN)
 def test_expeditions(self):
  for s in ['func _show_expeditions()', 'func _start_expedition(', 'func _claim_expedition()', 'EXPEDITION_SECONDS']:
   self.assertIn(s,MAIN)
 def test_expedition_single_claim(self):
  method=MAIN.split('func _claim_expedition()')[1].split('\nfunc ',1)[0]
  self.assertIn('expedition_start = 0',method)
  self.assertIn('expedition_start < EXPEDITION_SECONDS',method)
 def test_save_schema(self):
  for s in ['"version":SAVE_VERSION','"expedition_start":expedition_start','"relics":relics','BACKUP_PATH']:
   self.assertIn(s,MAIN)
 def test_no_duplicate_functions(self):
  names=re.findall(r'^func\s+(\w+)\(',MAIN,re.M)
  self.assertEqual(len(names),len(set(names)))
 def test_no_server_claim(self):
  self.assertNotIn('http_request',MAIN.lower())
 def test_mobile_orientation(self):
  config=(ROOT/'project.godot').read_text()
  self.assertIn('window/handheld/orientation=1',config)
  self.assertIn('gl_compatibility',config)
if __name__=='__main__': unittest.main()