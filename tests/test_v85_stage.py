import unittest
from pathlib import Path
s=Path(__file__).resolve().parents[1].joinpath('scripts/battle_arena.gd').read_text()
class Stage(unittest.TestCase):
 def test_feature(self):
  self.assertIn('draw_arc(Vector2(0,-17), 23.0',s)