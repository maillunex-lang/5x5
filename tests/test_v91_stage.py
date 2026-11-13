import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath("scripts/main.gd").read_text()
class Stage(unittest.TestCase):
 def test_stage(self):
  self.assertIn('# v9.1: predictable focus-fire',s)
  self.assertIn('if actor.role == "Убийца":',s)
  self.assertIn('target = chosen',s)