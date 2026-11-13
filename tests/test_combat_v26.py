from pathlib import Path
import unittest
ROOT=Path(__file__).resolve().parents[1]
S=(ROOT/'scripts/main.gd').read_text()
A=(ROOT/'scripts/battle_arena.gd').read_text()
class CombatV26(unittest.TestCase):
 def test_save_schema(self): self.assertRegex(S,r"const SAVE_VERSION := (?:9|1[0-9]|[2-9][0-9]+)")
 def test_backup_requires_valid_payload(self): self.assertIn('if _is_valid_save(JSON.parse_string(old_text)):',S)
 def test_load_fallback_validates_primary(self): self.assertIn('if not _is_valid_save(data) and FileAccess.file_exists(BACKUP_PATH):',S)
 def test_load_validates_backup(self): self.assertIn('if not _is_valid_save(data):\n  return',S)
 def test_required_save_fields(self): self.assertIn('value.has("party")',S)
 def test_arena_reset(self): self.assertIn('func reset_battle() -> void:',A);self.assertIn('arena.call("reset_battle")',S)
 def test_support_does_not_waste_heal(self): self.assertIn('if healed > 0:\n    actor.energy = 0.0',S)
 def test_boss_charge(self): self.assertIn('battle_origin_stage == 20 and actor.energy >= 100.0',S)
 def test_battle_event_cap(self): self.assertIn('const MAX_BATTLE_EVENTS := 8',S)