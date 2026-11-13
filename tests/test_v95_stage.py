import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath("scripts/main.gd").read_text()
class Stage(unittest.TestCase):
 def test_stage(self):
  self.assertIn('# v9.5: throttle UI text',s)
  self.assertIn('battle_hud_accumulator += delta',s)
  self.assertIn('if battle_hud_accumulator <',s)