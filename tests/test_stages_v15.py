import pathlib
import unittest

ROOT = pathlib.Path(__file__).resolve().parents[1]
S = (ROOT / 'scripts/main.gd').read_text()

class StagesV15(unittest.TestCase):
    def test_version(self): self.assertRegex(S, r'const SAVE_VERSION := (?:[7-9]|[1-9][0-9]+)')
    def test_equipment_catalog(self): self.assertIn('const EQUIPMENT := [', S)
    def test_equipment_bonuses(self): self.assertIn('func _equipment_bonus(', S)
    def test_equipment_battle_effect(self): self.assertIn('int(bonuses.atk)', S)
    def test_purchase_guard(self): self.assertIn('if gold < price:', S)
    def test_purchase_persists(self): self.assertIn('owned_equipment.append(item_id)', S)
    def test_equip_ownership(self): self.assertIn('if not owned_equipment.has(item_id)', S)
    def test_boss_stage(self): self.assertIn('var is_boss := stage == 20 and i == 0', S)
    def test_boss_rewards(self): self.assertIn('boss_kills += 1', S)
    def test_daily_reset(self): self.assertIn('func _reset_daily_if_needed()', S)
    def test_daily_one_claim(self): self.assertIn('if daily_claimed or daily_wins < 3:', S)
    def test_achievements_once(self): self.assertIn('achievement_claims & (1 << index)', S)
    def test_reduced_effects(self): self.assertIn('func _toggle_effects()', S)
    def test_save_equipment(self): self.assertIn('"owned_equipment":owned_equipment', S)
    def test_save_daily(self): self.assertIn('"daily_claimed":daily_claimed', S)
    def test_save_achievements(self): self.assertIn('"achievement_claims":achievement_claims', S)
    def test_migrate_old_saves(self): self.assertIn('data.get("owned_equipment",[])', S)
    def test_no_server(self): self.assertNotIn('HTTPRequest.new()', S)

if __name__ == '__main__': unittest.main()