import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath('scripts/battle_arena.gd').read_text()
class Stage(unittest.TestCase):
 def test_feature(self):
  self.assertIn('7.0 if bool(effect.get("critical",false)) else 5.0',s)