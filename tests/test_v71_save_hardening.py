import unittest
from pathlib import Path
S=(Path(__file__).resolve().parents[1]/"scripts/main.gd").read_text()
class SaveHardening(unittest.TestCase):
 def test_nan_guard(self): self.assertIn("is_nan(number) or is_inf(number)",S)
 def test_numeric_bounds(self): self.assertIn("absf(number) > 2000000000.0",S)
 def test_hero_nan_guard(self): self.assertIn("is_nan(hero_number) or is_inf(hero_number)",S)
 def test_hero_range_before_cast(self): self.assertLess(S.index("hero_number >= float(HEROES.size())"),S.index("var index := int(hero_number)"))