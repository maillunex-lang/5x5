extends SceneTree
# Verify VIP eligibility, single claim, save reload and expiry without touching real device data.
func _initialize() -> void:
 call_deferred("_run")

func _fail(message: String) -> void:
 push_error("VIP SMOKE FAILED: " + message)
 quit(1)

func _run() -> void:
 var scene: PackedScene = load("res://scenes/main.tscn")
 var game: Control = scene.instantiate()
 root.add_child(game)
 await process_frame
 game.tutorial_seen = true
 game.vip_trial_claimed = false
 game.vip_expires_at = 0
 game.battle_wins = 4
 game._claim_vip_trial()
 if game.vip_trial_claimed or game._vip_active():
  _fail("trial granted before five victories")
  return
 game.battle_wins = 5
 game._claim_vip_trial()
 if not game.vip_trial_claimed or not game._vip_active() or game.screen != "vip":
  _fail("VIP trial not activated or navigated")
  return
 var expiry: int = game.vip_expires_at
 game._claim_vip_trial()
 if expiry != game.vip_expires_at:
  _fail("VIP trial can be claimed twice")
  return
 game._save_data()
 var replacement: Control = scene.instantiate()
 root.add_child(replacement)
 await process_frame
 if not replacement._vip_active() or not replacement.vip_trial_claimed:
  _fail("VIP status was not restored from save")
  return
 replacement.vip_expires_at = int(Time.get_unix_time_from_system()) - 1
 if replacement._vip_active():
  _fail("VIP expiry ignored")
  return
 print("VIP SMOKE PASS: eligibility, claim, single-use, save and expiry")
 quit(0)