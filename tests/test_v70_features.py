import unittest
from pathlib import Path
S=(Path(__file__).resolve().parents[1]/"scripts/main.gd").read_text()
class V70Features(unittest.TestCase):
 def test_ability_count(self): self.assertIn("ability_triggers = mini(100000,ability_triggers + 1)",S)
 def test_enemy_region_scaling(self): self.assertIn("var region_guard :=",S)
 def test_affinity_cap(self): self.assertIn("const REGION_AFFINITY_CAP := 10",S)
 def test_affinity_persist(self): self.assertIn('"region_affinity":region_affinity',S)
 def test_reforge_cap(self): self.assertIn("const EQUIPMENT_REFORGE_CAP := 3",S)
 def test_reforge_checks_owned(self): self.assertIn("not owned_equipment.has(item_id)",S)
 def test_reforge_persist(self): self.assertIn('"equipment_reforges":equipment_reforges',S)
 def test_reforge_array_size(self): self.assertIn("var equipment_reforges := [0,0,0,0,0]",S)
 def test_touch_target(self): self.assertIn("b.custom_minimum_size.y = 56",S)
 def test_migration(self): self.assertIn('data.get("equipment_reforges",[])',S)