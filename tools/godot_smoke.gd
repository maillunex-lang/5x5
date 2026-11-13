extends SceneTree
# Requires Godot 4.3+. Run with: godot --headless --path . --script res://tools/godot_smoke.gd
func _initialize() -> void:
 call_deferred("_run")

func _fail(message: String, code: int) -> void:
 push_error("ELO SMOKE FAILED: " + message)
 quit(code)

func _run() -> void:
 var scene: PackedScene = load("res://scenes/main.tscn")
 if scene == null:
  _fail("main scene missing", 1)
  return
 var game: Control = scene.instantiate()
 root.add_child(game)
 await process_frame
 if game.party.size() != 5 or game.HEROES.size() != 10 or game.REGIONS.size() != 12:
  _fail("roster or map size", 2)
  return
 game._navigate("battle")
 game._start_battle()
 if not game.active or game.units.size() != 10:
  _fail("battle initialization", 3)
  return
 var enemy_count := 0
 for unit in game.units:
  if int(unit.side) == 1:
   enemy_count += 1
  if int(unit.hp) <= 0 or int(unit.max_hp) <= 0 or int(unit.atk) <= 0:
   _fail("invalid unit stats", 4)
   return
 if enemy_count != 5:
  _fail("invalid enemy roster", 5)
  return
 for i in range(1000):
  if not game.active:
   break
  game._process(0.1)
 if game.active:
  _fail("combat did not terminate", 6)
  return
 if game.battle_history.is_empty():
  _fail("missing battle journal entry", 7)
  return
 if game.battle_history[0].chapter != game.battle_origin_chapter or game.battle_history[0].stage != game.battle_origin_stage:
  _fail("battle journal wrong stage", 8)
  return
 game._save_data()
 if not FileAccess.file_exists(game.SAVE_PATH):
  _fail("save not written", 9)
  return
 print("ELO SMOKE PASS: scene, roster, combat, battle journal, save")
 quit(0)