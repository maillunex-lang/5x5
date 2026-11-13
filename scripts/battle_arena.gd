extends Control
# Lightweight vector art, procedural regional landscapes, animated heroes and combat VFX.
# All drawing is authored locally. No downloaded textures or GPU-heavy shaders.
const MAX_VISUAL_EVENTS := 24
const MAX_SPARK_PARTICLES := 4
const PALETTE := [Color("#e3b977"), Color("#79d8a2"), Color("#c2a8f1"), Color("#f0a17c"), Color("#8ecbfa")]
var snapshot: Array = []
var elapsed := 0.0
var region_index := 0
var hero_roles: Array = []
var recent_impacts: Array = []
var previous_hp: Array = []
var reduced_effects := false
var recent_skills: Array = []
var previous_energy: Array = []

func reset_battle() -> void:
 previous_hp.clear()
 recent_impacts.clear()
 recent_skills.clear()
 previous_energy.clear()
 snapshot.clear()
 elapsed = 0.0
 queue_redraw()

func configure(region: int, roles: Array) -> void:
 region_index = clampi(region, 0, 11)
 hero_roles = roles.duplicate()
 queue_redraw()

func set_units(next_units: Array, time_seconds: float) -> void:
 var now_hp: Array = []
 var now_energy: Array = []
 for i in range(next_units.size()):
  var unit: Dictionary = next_units[i]
  var hp := float(unit.get("hp", 0))
  now_hp.append(hp)
  var energy := float(unit.get("energy", 0))
  now_energy.append(energy)
  if not reduced_effects and i < previous_energy.size() and float(previous_energy[i]) >= 75.0 and energy < 25.0 and hp > 0:
   recent_skills.append({"slot":i, "until":time_seconds + 0.6, "role":str(unit.get("role","Воин"))})
   if recent_skills.size() > MAX_VISUAL_EVENTS:
    recent_skills.pop_front()
  if not reduced_effects and i < previous_hp.size() and hp < float(previous_hp[i]):
   recent_impacts.append({"slot":i, "until":time_seconds + 0.42, "damage":int(previous_hp[i] - hp), "critical":bool(unit.get("last_critical",false))})
   if recent_impacts.size() > MAX_VISUAL_EVENTS:
    recent_impacts.pop_front()
 previous_hp = now_hp
 previous_energy = now_energy
 snapshot = next_units.duplicate(true)
 elapsed = time_seconds
 recent_impacts = recent_impacts.filter(func(effect: Dictionary) -> bool: return float(effect["until"]) > elapsed)
 recent_skills = recent_skills.filter(func(effect: Dictionary) -> bool: return float(effect["until"]) > elapsed)
 queue_redraw()

func _unit_position(index: int, w: float, h: float) -> Vector2:
 var side := 1 if index >= 5 else 0
 var slot := index % 5
 var col := slot % 3
 var row := int(slot / 3)
 var x := w * (0.20 + float(col) * 0.30) + (w * 0.15 if row == 1 else 0.0)
 var y := h * (0.37 if side == 1 else 0.72) + float(row) * h * 0.115
 return Vector2(x, y)

func _draw() -> void:
 var w := size.x
 var h := size.y
 if w < 20.0 or h < 20.0:
  return
 _draw_landscape(w, h)
 for side in [1, 0]:
  for slot in range(5):
   var index := slot + (5 if side == 1 else 0)
   var position := _unit_position(index, w, h)
   var unit: Dictionary = snapshot[index] if index < snapshot.size() else {}
   _draw_hero(position, index, side, unit)
 if reduced_effects:
  return
 for effect in recent_impacts:
  _draw_impact(_unit_position(int(effect["slot"]), w, h), effect)
 for effect in recent_skills:
  _draw_skill(_unit_position(int(effect["slot"]), w, h), effect)

func _draw_landscape(w: float, h: float) -> void:
 var sky: Color = [Color("#152c46"), Color("#173c34"), Color("#21374a"), Color("#193e50"), Color("#3a314a"), Color("#593b38")][region_index % 6]
 var ground: Color = [Color("#294c43"), Color("#23493b"), Color("#3c4a50"), Color("#235565"), Color("#4b4c42"), Color("#574438")][region_index % 6]
 draw_rect(Rect2(Vector2.ZERO, size), sky)
 var sun_x := w * (0.77 if region_index % 2 == 0 else 0.2)
 var sun_y := h * 0.15
 for ring in range(3, 0, -1):
  draw_circle(Vector2(sun_x, sun_y), float(11 + ring * 12), Color(1.0, 0.77, 0.45, 0.045))
 draw_circle(Vector2(sun_x, sun_y), 12.0, Color("#f8d18a"))
 if region_index % 4 == 2:
  for star in range(11):
   var sx := w * float((star * 37 + 11) % 100) / 100.0
   var sy := h * float((star * 17 + 9) % 29) / 100.0
   draw_circle(Vector2(sx,sy), 1.1, Color("#cde7ff",0.65))
 if not reduced_effects and region_index % 3 == 1:
  for drop in range(13):
   var dx := fposmod(float(drop * 47) + elapsed * 12.0, w)
   var dy := fposmod(float(drop * 31) + elapsed * 22.0, h * 0.65)
   draw_line(Vector2(dx,dy), Vector2(dx-3.0,dy+9.0), Color("#a6d3ed",0.24),1.0)
 for ridge in range(3):
  var points := PackedVector2Array()
  points.append(Vector2(0, h))
  for i in range(9):
   var x := w * float(i) / 8.0
   var phase := float(i * 7 + ridge * 11 + region_index * 3)
   var height_offset := sin(phase * 1.41) * 0.045 + cos(phase * 0.7) * 0.035
   points.append(Vector2(x, h * (0.40 + ridge * 0.105 + height_offset)))
  points.append(Vector2(w, h))
  draw_colored_polygon(points, sky.lerp(ground, 0.25 + ridge * 0.28))
 draw_rect(Rect2(0, h * 0.68, w, h * 0.32), ground)
 for i in range(14):
  var x := w * float(i) / 13.0
  var y := h * (0.62 + float((i * 7 + region_index) % 5) * 0.014)
  if region_index % 4 == 3:
   draw_line(Vector2(x, y), Vector2(x + 9, y), Color("#8cc5d4", 0.35), 1.5)
  else:
   draw_line(Vector2(x, y), Vector2(x - 4, y - 11), Color("#80ae81", 0.42), 2.0)
 for i in range(9):
  var x := w * float(i + 1) / 10.0
  var y := h * (0.91 + float(i % 3) * 0.025)
  draw_line(Vector2(x, y), Vector2(x + 8, y - 5), Color("#a7ba8d", 0.25), 1.0)

func _draw_hero(position: Vector2, index: int, side: int, unit: Dictionary) -> void:
 var hp_fraction := clampf(float(unit.get("hp", 1)) / maxf(1.0, float(unit.get("max_hp", 1))), 0.0, 1.0)
 var alive := hp_fraction > 0.0
 var role := str(unit.get("role", "Воин"))
 if side == 0 and index < hero_roles.size():
  role = str(hero_roles[index])
 var accent: Color = Color("#e98783") if side == 1 else Color(PALETTE[index % PALETTE.size()])
 if not alive:
  accent = Color("#65717a")
 var bob := sin(elapsed * 3.4 + float(index) * 1.7) * (0.0 if reduced_effects else 2.5) if alive else 0.0
 var p := position + Vector2(0, bob)
 _ellipse(position + Vector2(0, 17), Vector2(23, 6), Color(0, 0, 0, 0.35))
 draw_set_transform(p)
 var cape := PackedVector2Array([Vector2(-10,-12), Vector2(12,-12), Vector2(21,17), Vector2(-19,17)])
 draw_colored_polygon(cape, accent.darkened(0.45))
 draw_colored_polygon(PackedVector2Array([Vector2(-12, 1), Vector2(-9,-16), Vector2(9,-16), Vector2(12,1), Vector2(7,13), Vector2(-7,13)]), accent)
 draw_circle(Vector2(0,-22), 8, Color("#e9c2a0") if alive else Color("#9d9993"))
 draw_arc(Vector2(0,-25), 8.5, PI, TAU, 9, accent.darkened(0.35), 4)
 if role == "Танк":
  draw_circle(Vector2(-15,0), 9, Color("#718c9e"))
  draw_arc(Vector2(-15,0), 8, 0, TAU, 12, Color("#e6c77f"), 2)
 elif role == "Стрелок":
  draw_arc(Vector2(15,-6), 17, -PI * 0.55, PI * 0.55, 14, Color("#d5b887"), 2)
  draw_line(Vector2(15,-23), Vector2(15,11), Color("#f5e8c7"), 1)
 elif role == "Маг":
  draw_circle(Vector2(15,-8), 5, Color("#b9a2ff"))
  draw_arc(Vector2(15,-8), 10, 0, TAU, 12, Color("#c8b4ff",0.55), 2)
 elif role == "Поддержка":
  draw_line(Vector2(15,-17), Vector2(15,14), Color("#e6d5a3"), 3)
  draw_circle(Vector2(15,-19), 5, Color("#91efb7"))
 elif role == "Убийца":
  draw_line(Vector2(12,-8), Vector2(24,9), Color("#e7e8ee"), 3)
 else:
  draw_line(Vector2(14,-21), Vector2(14,11), Color("#d7dfe7"), 3)
  draw_line(Vector2(8,4), Vector2(20,4), Color("#e5bf7a"), 2)
 if alive and not reduced_effects:
  var shimmer := 0.5 + 0.5 * sin(elapsed * 5.0 + float(index))
  draw_circle(Vector2(0,6), 3, Color(1,1,1,shimmer * 0.5))
 draw_rect(Rect2(-19,-40,38,5), Color("#101a22"))
 draw_rect(Rect2(-19,-40,38 * hp_fraction,5), Color("#80e5b0") if side == 0 else Color("#f2a091"))
 # Combat state markers are drawn in local hero coordinates.
 # Keep them readable without requiring external fonts or textures.
 if alive:
  _draw_status_markers(unit)
 draw_set_transform(Vector2.ZERO)

func _draw_status_markers(unit: Dictionary) -> void:
 var marker_x := -17.0
 if int(unit.get("shield", 0)) > 0:
  draw_arc(Vector2(0, -17), 27.0, PI * 0.1, PI * 0.9, 20, Color("#75caff", 0.95), 2.8)
  draw_rect(Rect2(marker_x, -51, 9, 7), Color("#57bdf4"))
  draw_line(Vector2(marker_x + 2, -48), Vector2(marker_x + 4, -45), Color("#f0fcff"), 1.5)
  marker_x += 12.0
 if int(unit.get("poison", 0)) > 0:
  draw_circle(Vector2(marker_x + 4, -48), 4.0, Color("#a8e76b"))
  draw_circle(Vector2(marker_x + 2, -49), 1.1, Color("#345329"))
  marker_x += 12.0
 if int(unit.get("stun", 0)) > 0:
  var spark := 0.8 + 0.2 * sin(elapsed * 9.0)
  draw_colored_polygon(PackedVector2Array([Vector2(marker_x + 3,-54), Vector2(marker_x + 8,-49), Vector2(marker_x + 4,-49), Vector2(marker_x + 6,-43), Vector2(marker_x,-49), Vector2(marker_x + 3,-49)]), Color(1.0, 0.87, 0.32, spark))

func _draw_impact(position: Vector2, effect: Dictionary) -> void:
 var remaining := clampf((float(effect["until"]) - elapsed) / 0.42, 0.0, 1.0)
 var radius := 7.0 + (1.0 - remaining) * 24.0
 var tint := Color(1.0,0.38,0.28,remaining) if bool(effect.get("critical",false)) else Color(1.0,0.83,0.52,remaining * 0.85)
 draw_arc(position + Vector2(0,-10), radius, 0, TAU, 18, tint, 4.0 if bool(effect.get("critical",false)) else 2.5)
 for i in range(5):
  var angle := float(i) * TAU / 5.0
  var direction := Vector2(cos(angle),sin(angle))
  draw_line(position + Vector2(0,-10) + direction * radius * 0.7, position + Vector2(0,-10) + direction * radius, Color(1,0.9,0.6,remaining), 2)

func _ellipse(center: Vector2, radii: Vector2, color: Color) -> void:
 draw_set_transform(center, 0.0, Vector2(radii.x / radii.y, 1.0))
 draw_circle(Vector2.ZERO, radii.y, color)
 draw_set_transform(Vector2.ZERO)

func _draw_skill(position: Vector2, effect: Dictionary) -> void:
 var remaining := clampf((float(effect["until"]) - elapsed) / 0.6, 0.0, 1.0)
 var radius := 12.0 + (1.0 - remaining) * 35.0
 var tint := Color("#a6e8ff")
 match str(effect["role"]):
  "Маг":
   tint = Color("#bd91ff")
  "Поддержка":
   tint = Color("#8fffc0")
  "Танк":
   tint = Color("#78c9ff")
  "Убийца":
   tint = Color("#f7b3d5")
  "Босс":
   tint = Color("#ff866b")
 tint.a = remaining * 0.85
 draw_arc(position + Vector2(0, -10), radius, 0.0, TAU, 16, tint, 3.0)
 for i in range(MAX_SPARK_PARTICLES):
  var angle := TAU * float(i) / float(MAX_SPARK_PARTICLES) + elapsed
  var direction := Vector2(cos(angle), sin(angle))
  draw_circle(position + Vector2(0, -10) + direction * radius, 2.5 * remaining, tint)