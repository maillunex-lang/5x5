from pathlib import Path
import unittest
S = (Path(__file__).resolve().parents[1] / 'scripts' / 'main.gd').read_text()
class EconomyV16(unittest.TestCase):
    def test_save_schema(self): self.assertRegex(S, r'const SAVE_VERSION := (?:[7-9]|[1-9][0-9]+)')
    def test_final_boss_one_time_reward(self):
        self.assertIn('not campaign_first_clear_rewards.has(chapter)', S)
        self.assertIn('campaign_first_clear_rewards.append(chapter)', S)
    def test_final_completion_saved(self): self.assertIn('"completed_campaign":completed_campaign', S)
    def test_inventory_uniqueness_migration(self):
        self.assertIn('var assigned_items: Array = []', S)
        self.assertIn('not assigned_items.has(item_id)', S)
        self.assertIn('assigned_items.append(item_id)', S)
    def test_reassignment_removes_old_owner(self):
        self.assertIn('if int(equipped[key]) == item_id:', S)
        self.assertIn('equipped.erase(key)', S)
    def test_purchase_does_not_duplicate(self): self.assertIn('owned_equipment.has(item_id):', S)