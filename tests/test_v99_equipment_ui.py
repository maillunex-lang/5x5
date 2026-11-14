import unittest
from pathlib import Path
S=Path(__file__).resolve().parents[1].joinpath('scripts/main.gd').read_text()
class EquipmentUI(unittest.TestCase):
 def test_filters_and_hero_selection(self):
  for text in ('func _set_equipment_filter(value: String)', 'func _set_equipment_target_hero(hero_id: int)', 'var target_picker := OptionButton.new()', 'КОМУ ПОДОБРАТЬ СНАРЯЖЕНИЕ?', 'КАТЕГОРИИ'):
   self.assertIn(text,S)
 def test_equip_actions_preserved(self):
  for text in ('_buy_equipment.bind(i)', '_reforge_equipment.bind(i)', '_equip_item.bind(i,equipment_target_hero)', 'equipment_filter != "Все"'):
   self.assertIn(text,S)
 def test_save_version_unchanged(self):
  self.assertIn('const SAVE_VERSION := 14',S)