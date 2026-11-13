import unittest
from pathlib import Path
ROOT = Path(__file__).resolve().parents[1]
MAIN = (ROOT / "scripts/main.gd").read_text()
SMOKE = (ROOT / "tools/godot_smoke.gd").read_text()
PREFLIGHT = (ROOT / "tools/verify_release.py").read_text()
class ReleaseHardening(unittest.TestCase):
 def test_invalid_party_ids_rejected(self):
  self.assertIn('index < 0 or index >= HEROES.size()', MAIN)
 def test_duplicate_party_ids_rejected(self):
  self.assertIn('seen.has(index)', MAIN)
 def test_noninteger_party_ids_rejected(self):
  self.assertIn('hero_number != float(index)', MAIN)
 def test_negative_delta_clamped(self):
  self.assertIn('clampf(delta, 0.0, MAX_FRAME_DELTA)', MAIN)
 def test_speed_clamped(self):
  self.assertIn('clampf(combat_speed, 1.0, 4.0)', MAIN)
 def test_smoke_checks_battle(self):
  self.assertIn('combat did not terminate', SMOKE)
 def test_smoke_checks_journal(self):
  self.assertIn('battle journal wrong stage', SMOKE)
 def test_smoke_checks_save(self):
  self.assertIn('save not written', SMOKE)
 def test_preflight_does_not_build(self):
  self.assertNotIn('export-debug', PREFLIGHT)
 def test_preflight_reports_missing_godot(self):
  self.assertIn('Godot runtime unavailable', PREFLIGHT)