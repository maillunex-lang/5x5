extends SceneTree

func _initialize() -> void:
 call_deferred("_run")

func _fail(detail: String) -> void:
 push_error("ELO UI SMOKE FAILED: " + detail)
 quit(1)

func _run() -> void:
 var scene: PackedScene = load("res://scenes/main.tscn")
 var game: Control = scene.instantiate()
 root.add_child(game)
 await process_frame
 game.tutorial_seen = true
 # Ensure the new Home has a single prominent combat button.
 game._navigate("map")
 await process_frame
 if game.nav_buttons.size() != 5 or game.nav_grid.columns != 5:
  _fail("bottom navigation is not five tabs")
  return
 if game.scroll_view == null or game.body == null:
  _fail("scrolling content missing")
  return
 game._navigate("settings")
 if game.screen != "settings":
  _fail("More hub not reachable")
  return
 game._navigate("world")
 await process_frame
 if game.screen != "world":
  _fail("world screen not reachable")
  return
 game._go_back()
 if game.screen != "settings":
  _fail("back navigation did not return to previous section")
  return
 var destinations := ["map","heroes","equipment","settings","world","expeditions","quests","loot","talents","journal","regions","vip","preferences","achievements","codex","bestiary"]
 for destination in destinations:
  game._navigate(destination)
  await process_frame
  if game.screen != destination:
   _fail("wrong destination: " + destination)
   return
 game.party = [0,1,2,3]
 game._navigate("battle")
 await process_frame
 if game.active:
  _fail("battle started without five heroes")
  return
 if game.screen != "battle":
  _fail("battle screen not reachable")
  return
 game._navigate("map")
 await process_frame
 print("ELO UI SMOKE PASS: 16 routes, back stack, bottom navigation and battle guard")
 quit(0)