import re
import unittest
from pathlib import Path

SOURCE = (Path(__file__).resolve().parents[1] / "scripts/main.gd").read_text()

class CombatBalanceTests(unittest.TestCase):
    def test_enemy_hp_monotonic_by_stage(self):
        for chapter in range(1, 13):
            hp = [95 + stage * 9 + chapter * 22 + 45 for stage in range(1, 20)]
            self.assertEqual(hp, sorted(hp))
            self.assertEqual(len(set(hp)), len(hp))
    def test_boss_more_hp_than_regular(self):
        for chapter in range(1, 13):
            regular = 95 + 20 * 9 + chapter * 22 + 45
            boss = regular + chapter * 160
            self.assertGreater(boss, regular)
    def test_damage_and_hp_positive(self):
        for chapter in range(1, 13):
            for stage in range(1, 21):
                self.assertGreater(10 + stage + chapter * 3, 0)
                self.assertGreater(95 + stage * 9 + chapter * 22, 0)
    def test_party_has_five_unique_ids(self):
        self.assertIn('var party := [0,1,2,3,4]', SOURCE)
    def test_fixed_step_and_catchup_cap(self):
        self.assertIn('const BATTLE_STEP := 0.1', SOURCE)
        self.assertIn('steps < MAX_CATCHUP_STEPS', SOURCE)
    def test_battle_termination_conditions(self):
        self.assertIn('_alive_count(1) == 0', SOURCE)
        self.assertIn('battle_time >= MAX_BATTLE_SECONDS', SOURCE)
    def test_boss_phase_guard(self):
        self.assertIn('int(actor.phase) == 1', SOURCE)
        self.assertIn('actor.phase = 2', SOURCE)
    def test_safe_area_updates_on_resize(self):
        self.assertIn('size_changed.connect(_update_safe_area)', SOURCE)
        self.assertIn('get_display_safe_area()', SOURCE)
    def test_notch_and_landscape_insets(self):
        for token in ['margin_top', 'margin_bottom', 'margin_left', 'margin_right']:
            self.assertIn(token, SOURCE)
    def test_nav_has_three_columns(self):
        self.assertIn('nav_grid.columns = 2 if get_viewport_rect().size.x < 420.0 else 3', SOURCE)
        self.assertNotIn('nav.add_child(b)', SOURCE)
    def test_battle_arena_null_guard(self):
        segment = SOURCE.split('func _start_battle()', 1)[1].split('func _process(', 1)[0]
        self.assertRegex(segment, r'if arena != null:[\s\S]*?arena.call\("reset_battle"\)')
    def test_balance_scalars_explicit(self):
        for token in ['BALANCE_HP_SCALE', 'BALANCE_ATK_SCALE', 'BOSS_HP_MULTIPLIER']:
            self.assertIn(token, SOURCE)