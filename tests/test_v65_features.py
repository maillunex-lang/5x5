import unittest
from pathlib import Path
S=(Path(__file__).resolve().parents[1]/"scripts/main.gd").read_text()
class V65(unittest.TestCase):
 def test_bounded_skill_log(self):
  self.assertIn('func _announce_ability(message: String)',S)
  self.assertIn('if battle_events.size() > MAX_BATTLE_EVENTS:',S)
 def test_healing_feedback(self): self.assertIn('восстанавливает %d здоровья',S)
 def test_mastery_tooltip(self): self.assertIn('Бонус мастерства: +%d HP',S)
 def test_enemy_variation(self): self.assertIn('2 + ((i - 2 + stage + chapter) % 3)',S)
 def test_frontline_preserved(self): self.assertIn('i if i < 2 else 2 +',S)
 def test_expedition_gold_cap(self): self.assertIn('gold = mini(2000000000, gold + expedition_reward)',S)
 def test_expedition_claim_cap(self): self.assertIn('expedition_claims = mini(2000000000, expedition_claims + 1)',S)
 def test_accessibility(self): self.assertIn('19 if accessibility_large_text else 17',S)
 def test_reduced_effects(self): self.assertIn('24 if reduced_effects else 30',S)