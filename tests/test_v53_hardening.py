import unittest
from pathlib import Path
SOURCE=(Path(__file__).resolve().parents[1]/"scripts/main.gd").read_text()
class ReleaseHardening(unittest.TestCase):
 def test_catchup_is_bounded(self):
  self.assertIn("if steps >= MAX_CATCHUP_STEPS:",SOURCE)
  self.assertIn("tick = minf(tick, BATTLE_STEP)",SOURCE)
 def test_save_numeric_type_validation(self):
  self.assertIn('for key in ["version", "gold", "chapter", "stage"]:',SOURCE)
  self.assertIn("typeof(value[key]) != TYPE_INT",SOURCE)
 def test_save_integral_values(self):
  self.assertIn("number != float(int(number))",SOURCE)
 def test_save_chapter_bounds(self):
  self.assertIn('int(value["chapter"]) > REGIONS.size()',SOURCE)
 def test_save_stage_bounds(self):
  self.assertIn('int(value["stage"]) > 20',SOURCE)