import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath("scripts/main.gd").read_text()
class Stage(unittest.TestCase):
 def test_stage(self):
  self.assertIn('_progress_meter(p,EXPEDITION_SECONDS - remaining',s)
  self.assertIn('Награда по завершении:',s)