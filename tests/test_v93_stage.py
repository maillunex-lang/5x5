import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath("scripts/main.gd").read_text()
class Stage(unittest.TestCase):
 def test_stage(self):
  self.assertIn('Следующий ранг: +12 HP',s)
  self.assertIn('Следующий уровень: +15 HP',s)