import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath("scripts/main.gd").read_text()
class Stage(unittest.TestCase):
 def test_stage(self):
  self.assertIn('# v9.2: guard against damage spikes',s)
  self.assertIn('damage = clampi(damage, 1, maxi(1,int(actor.atk) * 8))',s)