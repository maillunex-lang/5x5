extends SceneTree
func _initialize() -> void:
 call_deferred("_run")
func _run() -> void:
 var game: Control = load("res://scenes/main.tscn").instantiate()
 root.add_child(game)
 await process_frame
 game.tutorial_seen = true
 game._navigate("equipment")
 await process_frame
 if game.screen != "equipment":
  push_error("Inventory navigation failed")
  quit(1)
  return
 game._set_equipment_filter("Оружие")
 if game.equipment_filter != "Оружие":
  push_error("Category filter failed")
  quit(1)
  return
 game._set_equipment_filter("Все")
 game._set_equipment_target_hero(1)
 if game.equipment_target_hero != 1:
  push_error("Hero selection failed")
  quit(1)
  return
 game._set_equipment_target_hero(999)
 if game.equipment_target_hero != 1:
  push_error("Invalid hero was selected")
  quit(1)
  return
 game.gold = 9999
 game._buy_equipment(0)
 if not game.owned_equipment.has(0):
  push_error("Purchase failed")
  quit(1)
  return
 game._equip_item(0,1)
 if int(game.equipped.get("1",-1)) != 0:
  push_error("Equip failed")
  quit(1)
  return
 game.loot_inventory[0] = 10
 game._reforge_equipment(0)
 if int(game.equipment_reforges[0]) != 1:
  push_error("Reforge failed")
  quit(1)
  return
 print("ELO EQUIPMENT UI PASS: filter, hero selection, purchase, equip and reforge")
 quit(0)