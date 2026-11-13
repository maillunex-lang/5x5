import unittest
from pathlib import Path
ARENA = (Path(__file__).resolve().parents[1] / "scripts" / "battle_arena.gd").read_text()

class StatusVisualTests(unittest.TestCase):
 def test_statuses_read_from_combat_snapshot(self):
  for status in ("shield", "poison", "stun"):
   self.assertIn(f'unit.get("{status}", 0)', ARENA)
 def test_markers_are_local_to_unit(self):
  self.assertIn('_draw_status_markers(unit)', ARENA)
  self.assertLess(ARENA.index('_draw_status_markers(unit)'), ARENA.index('draw_set_transform(Vector2.ZERO)\n\nfunc _draw_status_markers'))
 def test_visuals_use_vector_primitives(self):
  for primitive in ('draw_arc(', 'draw_circle(', 'draw_colored_polygon('):
   self.assertIn(primitive, ARENA)
 def test_statuses_only_for_living_units(self):
  self.assertIn('if alive:\n  _draw_status_markers(unit)', ARENA)
 def test_no_external_assets(self):
  self.assertNotIn('load("res://', ARENA)