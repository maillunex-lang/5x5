from pathlib import Path
import unittest
S = (Path(__file__).resolve().parents[1] / "scripts" / "main.gd").read_text()
class BossAndJournalRegression(unittest.TestCase):
 def test_save_schema_at_least_v8(self): self.assertRegex(S, r"const SAVE_VERSION := (?:[89]|[1-9][0-9]+)")
 def test_first_clear_persisted(self): self.assertIn('"campaign_first_clear_rewards":campaign_first_clear_rewards', S)
 def test_all_bosses_one_time(self):
  self.assertIn('if stage == 20 and not campaign_first_clear_rewards.has(chapter):', S)
  self.assertIn('campaign_first_clear_rewards.append(chapter)', S)
 def test_legacy_migration(self):
  self.assertIn('data.get("campaign_first_clear_rewards", data.get("discovered_bosses", []))', S)
  self.assertIn('data.get("completed_campaign",false)', S)
 def test_origin_recorded_before_combat(self):
  self.assertIn('battle_origin_chapter = chapter', S)
  self.assertIn('battle_origin_stage = stage', S)
 def test_history_uses_origin_not_next_stage(self):
  self.assertIn('"chapter":battle_origin_chapter,"stage":battle_origin_stage', S)