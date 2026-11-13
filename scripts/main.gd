extends Control
# ETERNAL LEGENDS ONLINE: standalone first playable, no server connection.
const SAVE_PATH := "user://eternal_legends_v01.json"
const BACKUP_PATH := "user://eternal_legends_backup.json"
const SAVE_VERSION := 14
const ARENA_SCRIPT := preload("res://scripts/battle_arena.gd")
const BALANCE_HP_SCALE := 1.0
const BALANCE_ATK_SCALE := 1.0
const BOSS_HP_MULTIPLIER := 1.0
const MAX_BATTLE_SECONDS := 90.0
const BATTLE_STEP := 0.1
const MAX_FRAME_DELTA := 0.25
const MAX_CATCHUP_STEPS := 16
const MAX_BATTLE_EVENTS := 8
const ARENA_UPDATE_INTERVAL := 0.1
const ARENA_UPDATE_INTERVAL_REDUCED := 0.2
const EXPEDITION_SECONDS := 7200
const HEROES := [
 {"name":"Айдар", "role":"Танк", "faction":"Рассвет", "symbol":"🛡", "hp":225, "atk":15, "speed":0.85, "skill":"Щит"},
 {"name":"Айсылу", "role":"Стрелок", "faction":"Лес", "symbol":"🏹", "hp":112, "atk":29, "speed":1.3, "skill":"Точный выстрел"},
 {"name":"Булат", "role":"Воин", "faction":"Буря", "symbol":"⚔", "hp":175, "atk":22, "speed":1.0, "skill":"Удар молота"},
 {"name":"Зарифа", "role":"Поддержка", "faction":"Лес", "symbol":"✦", "hp":128, "atk":14, "speed":0.95, "skill":"Исцеление"},
 {"name":"Арден", "role":"Танк", "faction":"Рассвет", "symbol":"◆", "hp":205, "atk":17, "speed":0.9, "skill":"Клятва"},
 {"name":"Каэль", "role":"Убийца", "faction":"Пепел", "symbol":"✧", "hp":100, "atk":33, "speed":1.4, "skill":"Тень"},
 {"name":"Морвена", "role":"Маг", "faction":"Пепел", "symbol":"☾", "hp":115, "atk":28, "speed":0.95, "skill":"Проклятие"},
 {"name":"Гаррок", "role":"Воин", "faction":"Буря", "symbol":"♜", "hp":165, "atk":25, "speed":1.1, "skill":"Ярость"},
 {"name":"Ауриэль", "role":"Поддержка", "faction":"Небо", "symbol":"✹", "hp":132, "atk":18, "speed":1.0, "skill":"Свет"},
 {"name":"Ноктис", "role":"Маг", "faction":"Бездна", "symbol":"✺", "hp":105, "atk":32, "speed":1.05, "skill":"Бездна"}
]
const REGIONS := [
 {"name":"Уфа", "zone":"Цитадель Рассвета", "boss":"Змей Агидели"},
 {"name":"Бирск", "zone":"Шепчущие чащи", "boss":"Страж Лесов"},
 {"name":"Прикамье", "zone":"Туманные рубежи", "boss":"Туманный Зверь"},
 {"name":"Аслыкуль", "zone":"Зеркальные воды", "boss":"Хранитель Озера"},
 {"name":"Торатау", "zone":"Каменные врата", "boss":"Страж Торатау"},
 {"name":"Янгантау", "zone":"Огненные недра", "boss":"Огненный Исполин"},
 {"name":"Белорецк", "zone":"Железные горы", "boss":"Железный Страж"},
 {"name":"Иремель", "zone":"Престол Ветров", "boss":"Грозокрыл"},
 {"name":"Шульган-Таш", "zone":"Подземное царство", "boss":"Страж Подземной Реки"},
 {"name":"Учалы", "zone":"Долина Кристаллов", "boss":"Кристальный Пожиратель"},
 {"name":"Сибай", "zone":"Рубеж Бездны", "boss":"Пожиратель Руды"},
 {"name":"Южный Урал", "zone":"Сердце Разлома", "boss":"Архонт Разлома"}
]
const BG := Color("#0a1422")
const PANEL := Color("#142438")
const PANEL2 := Color("#1b3148")
const GOLD := Color("#eac783")
const TEXT := Color("#f2e9d6")
const MUTED := Color("#9db1bf")
var gold := 200
var level := 1
var chapter := 1
var stage := 1
var last_claim := 0
var party := [0,1,2,3,4]
var active := false
var units: Array = []
var battle_time := 0.0
var tick := 0.0
var rng := RandomNumberGenerator.new()
var body: VBoxContainer
var safe_container: MarginContainer
var nav_grid: GridContainer
var hud: Label
var log_label: Label
var hero_bars: Array = []
var battle_status: Label
var battle_summary: Label
var battle_button: Button
var screen := "map"
var battle_wins := 0
var quests_claimed := 0
var sound_enabled := true
var combat_speed := 1.0
var battle_events: Array[String] = []
var faction_bonus := 1.0
var arena: Control
var expedition_start := 0
var expedition_region := 0
var expedition_claims := 0
var relics := 0
var best_chapter := 1
var battle_seed := 0
var last_battle_result := ""
var total_damage := 0
var total_healing := 0
var best_streak := 0
var current_streak := 0
var tutorial_seen := false
var completed_campaign := false
var auto_repeat := false
var victory_count := 0
var arena_redraw_accumulator := 0.0
# v1.1–v1.5: persistent equipment, boss rewards, daily tasks, achievements, UX.
const EQUIPMENT := [
 {"name":"Клинок Агидели", "slot":"Оружие", "atk":8, "hp":0, "cost":220},
 {"name":"Щит Торатау", "slot":"Броня", "atk":0, "hp":70, "cost":260},
 {"name":"Посох Иремеля", "slot":"Оружие", "atk":14, "hp":0, "cost":450},
 {"name":"Плащ Шульган-Таш", "slot":"Броня", "atk":3, "hp":105, "cost":520},
 {"name":"Корона Южного Урала", "slot":"Реликвия", "atk":10, "hp":95, "cost":900}
]
var owned_equipment: Array = []
var equipped: Dictionary = {}
var boss_kills := 0
var daily_day := 0
var daily_wins := 0
var daily_claimed := false
var achievement_claims := 0
var reduced_effects := false
# v1.7-v2.4: eight self-contained offline gameplay systems.
const FORMATIONS := [[0,1,2,3,4],[0,4,1,3,2],[2,7,0,8,1]]
const LORE := [
 "Агидель хранит предания о древних речных стражах.",
 "В лесах Бирска слышны голоса забытых хранителей.",
 "Туманы Прикамья скрывают древние переправы.",
 "Аслыкуль отражает звёзды даже в ненастье.",
 "Торатау возвышается над каменными вратами.",
 "Янгантау согревает землю подземным пламенем.",
 "Белорецкие хребты берегут железные тайны.",
 "Иремель встречает путников ветрами.",
 "Шульган-Таш хранит следы древнего мира.",
 "Учалинские долины сияют кристаллами.",
 "Сибай открывает рудные глубины.",
 "Сердце Южного Урала ждёт своих защитников."
]
const TALENTS := ["Сила", "Стойкость", "Вдохновение"]
var formation_index := 0
var talent_points := [0,0,0]
var battle_history: Array = []
var discovered_bosses: Array = []
var claimed_region_rewards: Array = []
var accessibility_large_text := false
var expedition_total_gold := 0
var codex_seen: Array = []
var campaign_first_clear_rewards: Array = []
var battle_origin_chapter := 1
var battle_origin_stage := 1
# v4.0-v4.3: guaranteed progression, regional contracts and loot economy.
const LOOT_NAMES := ["Осколок Агидели", "Лесная эссенция", "Камень Торатау", "Искра Иремеля"]
const LOOT_RARITY := ["Обычный", "Необычный", "Редкий", "Эпический"]
var loot_inventory := [0,0,0,0]
var loot_total := 0
var regional_wins := [0,0,0,0,0,0,0,0,0,0,0,0]
var regional_contracts_claimed: Array = []
var forge_level := 0
var hero_mastery := [0,0,0,0,0,0,0,0,0,0]
# v6.6: battle ability tracker; v6.8: region affinity; v6.9: equipment reforging.
var ability_triggers := 0
var region_affinity := [0,0,0,0,0,0,0,0,0,0,0,0]
var equipment_reforges := [0,0,0,0,0]
const REGION_AFFINITY_CAP := 10
const EQUIPMENT_REFORGE_CAP := 3



func _ready() -> void:
 rng.randomize()
 _load_data()
 var bg := ColorRect.new()
 bg.color = BG
 bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(bg)
 safe_container = MarginContainer.new()
 safe_container.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 add_child(safe_container)
 _update_safe_area()
 get_viewport().size_changed.connect(_update_safe_area)
 var root := VBoxContainer.new()
 root.add_theme_constant_override("separation", 9)
 safe_container.add_child(root)
 var title := Label.new()
 title.text = "✦  ETERNAL LEGENDS"
 title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 title.add_theme_font_size_override("font_size", 23)
 title.add_theme_color_override("font_color", GOLD)
 root.add_child(title)
 var subtitle := Label.new()
 subtitle.text = "ЛЕГЕНДЫ ЮЖНОГО УРАЛА"
 subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 subtitle.add_theme_font_size_override("font_size", 13)
 subtitle.add_theme_color_override("font_color", MUTED)
 root.add_child(subtitle)
 hud = Label.new()
 hud.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
 hud.add_theme_color_override("font_color", GOLD)
 root.add_child(hud)
 nav_grid = GridContainer.new()
 nav_grid.columns = 3
 nav_grid.add_theme_constant_override("h_separation", 6)
 nav_grid.add_theme_constant_override("v_separation", 6)
 root.add_child(nav_grid)
 for item in [{"t":"Карта","s":"map"},{"t":"Герои","s":"heroes"},{"t":"Бой","s":"battle"},{"t":"Поход","s":"expeditions"},{"t":"Снаряж.","s":"equipment"},{"t":"Опции","s":"settings"}]:
  var b := _button(item.t)
  b.add_theme_font_size_override("font_size", 14)
  b.custom_minimum_size.y = 48
  b.clip_text = true
  b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  b.pressed.connect(_navigate.bind(item.s))
  nav_grid.add_child(b)
 var scroll := ScrollContainer.new()
 scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
 scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
 root.add_child(scroll)
 body = VBoxContainer.new()
 body.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 body.add_theme_constant_override("separation", 12)
 scroll.add_child(body)
 _navigate("map")
 if not tutorial_seen:
  _show_tutorial()

func _update_safe_area() -> void:
 if safe_container == null:
  return
 var viewport_size := get_viewport_rect().size
 var screen_size := DisplayServer.screen_get_size()
 var safe_rect := DisplayServer.get_display_safe_area()
 var top := 18
 var bottom := 18
 var left := 12
 var right := 12
 if DisplayServer.has_feature(DisplayServer.FEATURE_TOUCHSCREEN) and screen_size.x > 0 and screen_size.y > 0 and safe_rect.size.x > 0 and safe_rect.size.y > 0:
  var scale_x := viewport_size.x / float(screen_size.x)
  var scale_y := viewport_size.y / float(screen_size.y)
  top = maxi(top, ceili(float(safe_rect.position.y) * scale_y) + 8)
  bottom = maxi(bottom, ceili(float(screen_size.y - safe_rect.end.y) * scale_y) + 8)
  left = maxi(left, ceili(float(safe_rect.position.x) * scale_x) + 8)
  right = maxi(right, ceili(float(screen_size.x - safe_rect.end.x) * scale_x) + 8)
 safe_container.add_theme_constant_override("margin_top", top)
 safe_container.add_theme_constant_override("margin_bottom", bottom)
 safe_container.add_theme_constant_override("margin_left", left)
 safe_container.add_theme_constant_override("margin_right", right)

func _panel() -> VBoxContainer:
 var panel := PanelContainer.new()
 var style := StyleBoxFlat.new()
 style.bg_color = PANEL
 style.corner_radius_top_left = 14
 style.corner_radius_top_right = 14
 style.corner_radius_bottom_left = 14
 style.corner_radius_bottom_right = 14
 style.content_margin_left = 15
 style.content_margin_right = 15
 style.content_margin_top = 15
 style.content_margin_bottom = 15
 panel.add_theme_stylebox_override("panel", style)
 body.add_child(panel)
 var v := VBoxContainer.new()
 v.add_theme_constant_override("separation", 10)
 panel.add_child(v)
 return v

func _label(parent: Node, text_value: String, size := 18, color := TEXT) -> Label:
 var l := Label.new()
 l.text = text_value
 l.add_theme_font_size_override("font_size", size)
 l.add_theme_color_override("font_color", color)
 l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
 parent.add_child(l)
 return l

func _button(value: String) -> Button:
 var b := Button.new()
 b.text = value
 b.custom_minimum_size.y = 56
 b.add_theme_font_size_override("font_size", 17)
 b.clip_text = true
 b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 return b

func _clear() -> void:
 for child in body.get_children():
  body.remove_child(child)
  child.queue_free()
 hero_bars.clear()
 arena = null
 battle_status = null
 battle_summary = null
 battle_button = null

func _navigate(destination: String) -> void:
 if active and destination != "battle":
  return
 screen = destination
 _clear()
 _refresh_hud()
 match destination:
  "map": _show_map()
  "heroes": _show_heroes()
  "battle": _show_battle()
  "quests": _show_quests()
  "settings": _show_settings()
  "expeditions": _show_expeditions()
  "equipment": _show_equipment()
  "achievements": _show_achievements()
  "tutorial": _show_tutorial()
  "codex": _show_codex()
  "bestiary": _show_bestiary()
  "talents": _show_talents()
  "journal": _show_journal()
  "regions": _show_region_rewards()
  "loot": _show_loot()

func _refresh_hud() -> void:
 if hud != null:
  hud.text = "✦ %d золота   •   Ур. %d   •   Этап %d-%d" % [gold, level, chapter, stage]

func _show_tutorial() -> void:
 if active:
  return
 screen = "tutorial"
 _clear()
 var p := _panel()
 _label(p,"ДОБРО ПОЖАЛОВАТЬ, ХРАНИТЕЛЬ!",22,GOLD)
 _label(p,"Разлом пробудил древние силы Южного Урала. Соберите пятерых героев и защитите долину Агидели.",17)
 _label(p,"1. Откройте «Герои» и проверьте состав.\n2. На «Карте» выберите бой.\n3. Побеждайте, улучшайте отряд и собирайте AFK-награды.\n4. Отправляйте экспедиции за реликвиями.",16)
 var start := _button("НАЧАТЬ ПРИКЛЮЧЕНИЕ")
 start.pressed.connect(_finish_tutorial)
 p.add_child(start)

func _finish_tutorial() -> void:
 tutorial_seen = true
 _save_data()
 _navigate("map")

func _show_map() -> void:
 var p := _panel()
 var region: Dictionary = REGIONS[mini(chapter-1, REGIONS.size()-1)]
 _label(p,"🏰  %s · %s" % [region.name, region.zone],22,GOLD)
 _label(p,"Разломы Вечности пробудили древних стражей. Исследуйте земли Башкортостана и восстановите Сердце Урала.",16)
 _label(p,"Босс региона: %s" % region.boss,15,MUTED)
 var route := _panel()
 _label(route,"КАРТА ПРИКЛЮЧЕНИЙ",19,GOLD)
 for i in range(5):
  var idx := i + 1
  var icon_text := "●" if idx <= int(ceil(float(stage)/4.0)) else "○"
  var place_names := ["Цитадель", "Древние леса", "Переправа", "Старая башня", "Разлом"]
  _label(route,"%s  %s" % [icon_text,place_names[i]],17)
 var progress := _panel()
 _label(progress,"ПУТЬ ХРАНИТЕЛЯ",19,GOLD)
 _label(progress,"Глава %d / 12 • Бой %d / 20" % [chapter,stage],18)
 if completed_campaign:
  _label(progress,"Кампания завершена! Последний бой доступен для повторения.",15,GOLD)
 var regional_contract := _panel()
 _label(regional_contract,"КОНТРАКТ РЕГИОНА",19,GOLD)
 var local_wins := int(regional_wins[chapter-1])
 _label(regional_contract,"Победить 5 противников региона: %d / 5" % mini(5,local_wins),16)
 _progress_meter(regional_contract,local_wins,5,Color("#76d6aa"))
 var contract_button := _button("Награда получена" if regional_contracts_claimed.has(chapter) else "ЗАБРАТЬ 250 ЗОЛОТА" if local_wins >= 5 else "Нужно 5 побед")
 contract_button.disabled = local_wins < 5 or regional_contracts_claimed.has(chapter)
 contract_button.pressed.connect(_claim_regional_contract.bind(chapter))
 regional_contract.add_child(contract_button)
 var loot_button := _button("ДОБЫЧА И КУЗНИЦА")
 loot_button.pressed.connect(_navigate.bind("loot"))
 regional_contract.add_child(loot_button)
 var regions_panel := _panel()
 _label(regions_panel,"РЕГИОНЫ БАШКОРТОСТАНА",19,GOLD)
 for i in range(REGIONS.size()):
  var reg: Dictionary = REGIONS[i]
  _label(regions_panel,"%s  %02d · %s" % ["●" if i < chapter else "○",i+1,reg.name],14,GOLD if i < chapter else MUTED)
 var go := _button("⚔  НАЧАТЬ СРАЖЕНИЕ")
 go.pressed.connect(_navigate.bind("battle"))
 progress.add_child(go)
 var quests := _panel()
 _label(quests,"ЗАДАНИЯ ХРАНИТЕЛЯ",19,GOLD)
 var q := _button("ПОСМОТРЕТЬ ЗАДАНИЯ")
 q.pressed.connect(_navigate.bind("quests"))
 quests.add_child(q)
 _reset_daily_if_needed()
 var daily := _panel()
 _label(daily,"ЕЖЕДНЕВНОЕ ИСПЫТАНИЕ",19,GOLD)
 _label(daily,"Победы сегодня: %d / 3" % mini(3,daily_wins),16)
 var daily_button := _button("Награда получена" if daily_claimed else "ЗАБРАТЬ 150 ЗОЛОТА" if daily_wins >= 3 else "Нужно 3 победы")
 daily_button.disabled = daily_claimed or daily_wins < 3
 daily_button.pressed.connect(_claim_daily)
 daily.add_child(daily_button)
 var achievements_button := _button("ДОСТИЖЕНИЯ")
 achievements_button.pressed.connect(_navigate.bind("achievements"))
 daily.add_child(achievements_button)
 var exp := _panel()
 _label(exp,"ЭКСПЕДИЦИИ И РЕЛИКВИИ",19,GOLD)
 _label(exp,"Реликвии: %d • завершённых экспедиций: %d" % [relics,expedition_claims],15)
 var codex_button := _button("ЛЕТОПИСЬ РЕГИОНОВ")
 codex_button.pressed.connect(_navigate.bind("codex"))
 exp.add_child(codex_button)
 var bestiary_button := _button("БЕСТИАРИЙ БОССОВ")
 bestiary_button.pressed.connect(_navigate.bind("bestiary"))
 exp.add_child(bestiary_button)
 var region_button := _button("НАГРАДЫ РЕГИОНОВ")
 region_button.pressed.connect(_navigate.bind("regions"))
 exp.add_child(region_button)
 var journal_button := _button("ЖУРНАЛ СРАЖЕНИЙ")
 journal_button.pressed.connect(_navigate.bind("journal"))
 exp.add_child(journal_button)
 var exp_btn := _button("ОТКРЫТЬ ЭКСПЕДИЦИИ")
 exp_btn.pressed.connect(_navigate.bind("expeditions"))
 exp.add_child(exp_btn)
 var idle := _panel()
 _label(idle,"AFK-СОКРОВИЩНИЦА",19,GOLD)
 var elapsed := maxi(0,int(Time.get_unix_time_from_system()) - last_claim)
 var earned := (mini(elapsed,12*3600) / 60) * (2 + chapter)
 _label(idle,"Накоплено: %d золота" % earned,20)
 _label(idle,"До 12 часов офлайн-добычи. Награды рассчитываются по времени устройства в этом прототипе.",14,MUTED)
 var claim := _button("ЗАБРАТЬ НАГРАДЫ")
 claim.disabled = earned < 1
 claim.pressed.connect(_claim_afk)
 idle.add_child(claim)

func _claim_afk() -> void:
 var elapsed := maxi(0,int(Time.get_unix_time_from_system()) - last_claim)
 gold += (mini(elapsed,12*3600) / 60) * (2 + chapter)
 last_claim = int(Time.get_unix_time_from_system())
 _save_data()
 _navigate("map")

func _show_heroes() -> void:
 var top := _panel()
 _label(top,"ВАШ ОТРЯД • %d/5" % party.size(),20,GOLD)
 _label(top,"Выберите ровно пять героев. Первые два места: передняя линия. Остальные: задняя линия.",15,MUTED)
 _label(top,"Построение: %s" % ", ".join(_party_names()),14,GOLD)
 for i in range(HEROES.size()):
  var h: Dictionary = HEROES[i]
  var p := _panel()
  var line := HBoxContainer.new()
  p.add_child(line)
  var text_value := "%s  %s\n%s • %s" % [h.symbol,h.name,h.faction,h.role]
  var info_column := VBoxContainer.new()
  info_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  line.add_child(info_column)
  var info := _label(info_column,text_value,19 if accessibility_large_text else 17)
  info.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  _label(info_column,"❤ %d    ⚔ %d    ⚡ %.2f" % [int(h.hp) + level * 15 + int(hero_mastery[i]) * 12 + forge_level * 10,int(h.atk) + level * 3 + int(hero_mastery[i]) * 3 + forge_level * 2,float(h.speed)],14,MUTED)
  _label(info_column,"Навык: %s" % h.skill,14,GOLD)
  _label(info_column,"Мастерство: %d/5" % int(hero_mastery[i]),14,GOLD)
  _label(info_column,"Бонус мастерства: +%d HP · +%d атаки" % [int(hero_mastery[i]) * 12,int(hero_mastery[i]) * 3],13,MUTED)
  var mastery_button := _button("Улучшить · %d зол." % (150 * (int(hero_mastery[i]) + 1)))
  mastery_button.disabled = int(hero_mastery[i]) >= 5 or gold < 150 * (int(hero_mastery[i]) + 1)
  mastery_button.pressed.connect(_upgrade_hero_mastery.bind(i))
  info_column.add_child(mastery_button)
  var b := _button("✓" if party.has(i) else "+")
  b.disabled = party.has(i) and party.size() <= 1
  b.pressed.connect(_toggle_hero.bind(i))
  line.add_child(b)
 var formation := _panel()
 _label(formation,"ПОСТРОЕНИЕ ОТРЯДА",18,GOLD)
 _label(formation,"Первые два героя принимают основной удар.",14,MUTED)
 for i in range(FORMATIONS.size()):
  var form_button := _button("Построение %d%s" % [i+1," ✓" if formation_index == i else ""])
  form_button.pressed.connect(_set_formation.bind(i))
  formation.add_child(form_button)
 var talents_button := _button("ТАЛАНТЫ ОТРЯДА")
 talents_button.pressed.connect(_navigate.bind("talents"))
 formation.add_child(talents_button)
 var upgrade := _panel()
 _label(upgrade,"ОБУЧЕНИЕ ГЕРОЕВ",20,GOLD)
 var cost := 100 * level
 _label(upgrade,"Уровень отряда: %d • Цена: %d золота" % [level,cost],17)
 var equipment_button := _button("СНАРЯЖЕНИЕ ГЕРОЕВ")
 equipment_button.pressed.connect(_navigate.bind("equipment"))
 upgrade.add_child(equipment_button)
 var up := _button("⬆  УЛУЧШИТЬ ОТРЯД")
 up.disabled = gold < cost
 up.pressed.connect(_upgrade)
 upgrade.add_child(up)

func _upgrade_hero_mastery(hero_id: int) -> void:
 if hero_id < 0 or hero_id >= HEROES.size():
  return
 var rank := int(hero_mastery[hero_id])
 var price := 150 * (rank + 1)
 if rank >= 5 or gold < price:
  return
 gold -= price
 hero_mastery[hero_id] = rank + 1
 _save_data()
 _navigate("heroes")

func _party_names() -> PackedStringArray:
 var result := PackedStringArray()
 for id in party:
  result.append(str(HEROES[id].name))
 return result

func _toggle_hero(index: int) -> void:
 if party.has(index):
  if party.size() > 1:
   party.erase(index)
 elif party.size() < 5:
  party.append(index)
 _save_data()
 _navigate("heroes")

func _set_formation(index: int) -> void:
 if index < 0 or index >= FORMATIONS.size():
  return
 formation_index = index
 var order: Array = FORMATIONS[index]
 var selected: Array = []
 for hero_id in order:
  if party.has(hero_id):
   selected.append(hero_id)
 for hero_id in party:
  if not selected.has(hero_id):
   selected.append(hero_id)
 party = selected
 _save_data()
 _navigate("heroes")

func _upgrade() -> void:
 var cost := 100 * level
 if gold < cost:
  return
 gold -= cost
 level += 1
 _save_data()
 _navigate("heroes")

func _show_battle() -> void:
 var p := _panel()
 _label(p,"⚔  БИТВА · %s" % REGIONS[chapter-1].name,22,GOLD)
 _label(p,"Регион %d/12 · Этап %d/20 · %s" % [chapter,stage,"БОСС" if stage == 20 else "Обычный бой"],15,MUTED)
 battle_status = _label(p,"Подготовка к бою",19 if accessibility_large_text else 17,MUTED)
 var field := _panel()
 _label(field,"ПРОТИВНИКИ",16,Color("#ed9a9a"))
 arena = Control.new()
 arena.set_script(ARENA_SCRIPT)
 arena.custom_minimum_size = Vector2(0,240)
 arena.size_flags_horizontal = Control.SIZE_EXPAND_FILL
 field.add_child(arena)
 arena.call("configure", chapter - 1, party.map(func(hero_id: int) -> String: return str(HEROES[hero_id].role)))
 arena.set("reduced_effects", reduced_effects)
 arena.call("reset_battle")
 for side in [1,0]:
  var row := GridContainer.new()
  row.columns = 5
  row.add_theme_constant_override("h_separation",4)
  field.add_child(row)
  for i in range(5):
   var box := VBoxContainer.new()
   box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
   box.custom_minimum_size.x = 0
   row.add_child(box)
   var avatar := Label.new()
   avatar.text = "♜" if side == 1 else str(HEROES[party[i % party.size()]].symbol)
   avatar.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
   avatar.add_theme_font_size_override("font_size",24 if reduced_effects else 30)
   avatar.add_theme_color_override("font_color",Color("#ec9999") if side == 1 else GOLD)
   box.add_child(avatar)
   var bar := ProgressBar.new()
   bar.custom_minimum_size.y = 12
   bar.show_percentage = false
   bar.max_value = 100
   bar.value = 100
   box.add_child(bar)
   hero_bars.append({"side":side,"index":i,"bar":bar})
  if side == 1:
   _label(field,"                 ⚡  VS  ⚡",18,GOLD)
 _label(field,"ВАШИ ГЕРОИ",16,Color("#8de4b9"))
 var actions := _panel()
 battle_button = _button("⚔  В БОЙ!")
 battle_button.pressed.connect(_start_battle)
 actions.add_child(battle_button)
 var speed_btn := _button("Скорость боя ×%d" % int(combat_speed))
 speed_btn.pressed.connect(_toggle_speed.bind(speed_btn))
 actions.add_child(speed_btn)
 log_label = _label(actions,"Соберите пять героев и начните автоматическое сражение.",17 if accessibility_large_text else 15,MUTED)
 battle_summary = _label(actions,"Союзники 5/5 · Противники 5/5",17 if accessibility_large_text else 15,GOLD)
 if party.size() >= 2:
  _label(actions,"Передняя линия: %s, %s" % [HEROES[party[0]].name,HEROES[party[1]].name],14,GOLD)
 if last_battle_result != "":
  _label(actions,last_battle_result,14,GOLD)
 if active:
  battle_button.disabled = true

func _toggle_speed(button: Button) -> void:
 combat_speed = 2.0 if combat_speed == 1.0 else 4.0 if combat_speed == 2.0 else 1.0
 button.text = "Скорость боя ×%d" % int(combat_speed)

func _start_battle() -> void:
 if active or party.size() != 5:
  if party.size() != 5 and log_label != null:
   log_label.text = "Нужно выбрать ровно пять героев в разделе «Герои»."
  return
 active = true
 battle_time = 0.0
 battle_origin_chapter = chapter
 battle_origin_stage = stage
 tick = 0.0
 arena_redraw_accumulator = 0.0
 if arena != null:
  arena.call("configure", chapter - 1, party.map(func(hero_id: int) -> String: return str(HEROES[hero_id].role)))
  arena.set("reduced_effects", reduced_effects)
  arena.call("reset_battle")
 total_damage = 0
 total_healing = 0
 ability_triggers = 0
 battle_events.clear()
 battle_seed = int(Time.get_ticks_msec())
 rng.seed = battle_seed
 var factions: Dictionary = {}
 for hero_id in party:
  var faction := str(HEROES[hero_id].faction)
  factions[faction] = int(factions.get(faction, 0)) + 1
 var largest := 0
 for count in factions.values():
  largest = maxi(largest,int(count))
 faction_bonus = 1.12 if largest == 5 else 1.06 if largest >= 3 else 1.0
 units.clear()
 for i in range(5):
  var h: Dictionary = HEROES[party[i]]
  var bonuses := _equipment_bonus(party[i])
  var mastery := int(hero_mastery[party[i]])
  var hp: int = int(h.hp) + level * 15 + mastery * 12 + relics * 3 + int(bonuses.hp) + talent_points[1] * 20 + forge_level * 10 + int(region_affinity[chapter-1]) * 2
  units.append({"side":0,"slot":i,"name":h.name,"hp":hp,"max_hp":hp,"atk":int((int(h.atk)+level*3+mastery*3+int(bonuses.atk) + talent_points[0] * 3 + forge_level * 2)*faction_bonus),"speed":float(h.speed),"energy":0.0,"cooldown":0.0,"role":h.role,"hero_id":party[i],"shield":0,"poison":0,"stun":0})
 for i in range(5):
  var is_boss := stage == 20 and i == 0
  # v6.7: region-specific enemy scaling and boss identity.
  var region_guard := 1.0 + float((chapter - 1) % 4) * 0.04
  var hp: int = maxi(1, int(float(95 + stage * 9 + chapter * 22 + (45 if i < 2 else 0) + (chapter * 160 if is_boss else 0)) * BALANCE_HP_SCALE * region_guard * (BOSS_HP_MULTIPLIER if is_boss else 1.0)))
  var enemy_names := ["Страж","Лучник","Шаман","Налётчик","Защитник"]
  var enemy_roles := ["Танк","Стрелок","Маг","Убийца","Танк"]
  var enemy_type := i if i < 2 else 2 + ((i - 2 + stage + chapter) % 3)
  units.append({"side":1,"slot":i,"name":str(REGIONS[chapter-1].boss) if is_boss else enemy_names[enemy_type],"hp":hp,"max_hp":hp,"atk":maxi(1,int(float(10+stage+chapter*3+(chapter*4 if is_boss else 0)) * BALANCE_ATK_SCALE)),"speed":0.8+float(i%3)*0.1,"energy":0.0,"cooldown":0.0,"role":("Босс" if is_boss else enemy_roles[enemy_type]),"hero_id":-1,"shield":0,"poison":0,"stun":0,"phase":1})
 battle_button.disabled = true
 log_label.text = "Герои вступили в бой. Навыки срабатывают автоматически."

func _process(delta: float) -> void:
 if not active:
  return
 # Fixed-step simulation prevents frame-rate-dependent attack frequency.
 tick += clampf(delta, 0.0, MAX_FRAME_DELTA) * clampf(combat_speed, 1.0, 4.0)
 var steps := 0
 while tick >= BATTLE_STEP and steps < MAX_CATCHUP_STEPS and active:
  tick -= BATTLE_STEP
  battle_time += BATTLE_STEP
  _combat_tick(BATTLE_STEP)
  steps += 1
  if _alive_count(1) == 0:
   _finish_battle(true)
  elif _alive_count(0) == 0 or battle_time >= MAX_BATTLE_SECONDS:
   _finish_battle(false)
 # Discard excess accumulated simulation time after a stalled frame to avoid a catch-up spiral.
 if steps >= MAX_CATCHUP_STEPS:
  tick = minf(tick, BATTLE_STEP)
 # Limit costly deep copies and canvas redraws to 10 Hz.
 arena_redraw_accumulator += delta
 if arena != null and (arena_redraw_accumulator >= (ARENA_UPDATE_INTERVAL_REDUCED if reduced_effects else ARENA_UPDATE_INTERVAL) or not active):
  arena.call("set_units", units, battle_time)
  arena_redraw_accumulator = 0.0
 _update_bars()
 if battle_status != null and active:
  battle_status.text = "Автобой • %d / 90 сек" % mini(90,int(battle_time))
 if battle_summary != null and active:
  battle_summary.text = "Союзники %d/5 · Противники %d/5 · Урон %d · Лечение %d" % [_alive_count(0),_alive_count(1),total_damage,total_healing]

func _announce_ability(message: String) -> void:
 ability_triggers = mini(100000,ability_triggers + 1)
 # Single helper for skill feedback; never grow a battle log without bounds.
 if log_label != null:
  log_label.text = message
 battle_events.append(message)
 if battle_events.size() > MAX_BATTLE_EVENTS:
  battle_events.pop_front()

func _alive_count(side: int) -> int:
 var count := 0
 for u in units:
  if u.side == side and u.hp > 0:
   count += 1
 return count

func _combat_tick(dt: float) -> void:
 for actor in units:
  # Stop the tick as soon as one side is defeated, including damage-over-time kills.
  if _alive_count(0) == 0 or _alive_count(1) == 0:
   break
  if actor.hp <= 0:
   continue
  # Debuffs advance on the fixed simulation step, independently of FPS.
  if int(actor.poison) > 0:
   actor.hp = maxi(0, int(actor.hp) - maxi(1, int(actor.max_hp) / 250))
   actor.poison = maxi(0, int(actor.poison) - 1)
   if actor.hp <= 0:
    # A poison kill may end the encounter; do not allow later units to act.
    if _alive_count(0) == 0 or _alive_count(1) == 0:
     break
    continue
  if int(actor.stun) > 0:
   actor.stun = maxi(0, int(actor.stun) - 1)
   continue
  # Boss phase transition: one-time shield and faster attacks below half health.
  if actor.side == 1 and actor.role == "Босс" and int(actor.phase) == 1 and float(actor.hp) <= float(actor.max_hp) * 0.5:
   actor.phase = 2
   actor.shield = maxi(int(actor.shield), int(float(actor.max_hp) / 8.0))
   actor.speed = float(actor.speed) * 1.25
   # Every third region has a sturdier second phase.
   if battle_origin_chapter % 3 == 0:
    actor.shield += int(float(actor.max_hp) * 0.08)
   if log_label != null:
    _announce_ability("⚠ %s переходит во вторую фазу" % actor.name)
  actor.cooldown -= dt
  if actor.cooldown > 0:
   continue
  actor.cooldown = 1.0 / maxf(0.1,float(actor.speed))
  var target: Dictionary = {}
  var candidates: Array = []
  for enemy in units:
   if enemy.side != actor.side and enemy.hp > 0:
    candidates.append(enemy)
  if candidates.is_empty():
   continue
  # Frontline absorbs attacks unless an assassin bypasses it.
  var frontline: Array = []
  for enemy in candidates:
   if int(enemy.slot) < 2:
    frontline.append(enemy)
  var pool: Array = candidates if actor.role == "Убийца" or frontline.is_empty() else frontline
  target = pool[rng.randi_range(0,pool.size()-1)]
  if actor.side == 0 and actor.role == "Поддержка" and actor.energy >= 60.0:
   var ally: Dictionary = actor
   for possible in units:
    if possible.side == 0 and possible.hp > 0 and float(possible.hp)/float(possible.max_hp) < float(ally.hp)/float(ally.max_hp):
     ally = possible
   var healed := mini(int(ally.max_hp) - int(ally.hp), int(actor.atk) * 3 + talent_points[2] * 5)
   ally.hp = int(ally.hp) + healed
   total_healing += healed
   if healed > 0:
    actor.energy = 0.0
    if log_label != null:
     _announce_ability("✚ %s восстанавливает %d здоровья" % [actor.name, healed])
    continue
  var damage := int(actor.atk)
  # Enemy bosses telegraph their charged attacks through the battle log.
  if actor.side == 1 and int(actor.slot) == 0 and battle_origin_stage == 20 and actor.energy >= 100.0:
   damage = int(float(damage) * (1.85 if battle_origin_chapter % 3 == 0 else 1.7))
   actor.energy = 0.0
   if log_label != null:
    _announce_ability("⚠ %s готовит сокрушительный удар" % actor.name)
  elif actor.side == 1:
   actor.energy += 22.0
  if actor.side == 0 and actor.energy >= 100.0:
   damage = int(float(damage)*2.4)
   actor.energy = 0.0
   if log_label != null:
    _announce_ability("✦ %s применяет ультимативный навык" % actor.name)
  elif actor.side == 0:
   actor.energy += 27.0
  # Enemy archetypes: ranged focus, caster pressure, assassin backline access.
  if actor.side == 1:
   match str(actor.role):
    "Стрелок":
     damage = int(float(damage) * 1.15)
    "Маг":
     if actor.energy >= 60.0:
      damage = int(float(damage) * 1.45)
      actor.energy = 0.0
    "Убийца":
     damage = int(float(damage) * 1.12)
    "Танк":
     damage = int(float(damage) * 0.85)
  if actor.side == 0 and actor.role == "Танк":
   damage = int(float(damage) * 0.85)
  if actor.side == 0 and actor.role == "Маг" and actor.energy >= 70.0:
   damage = int(float(damage) * 1.35)
  if rng.randf() < 0.12:
   damage = int(float(damage)*1.5)
  # Hero-specific automatic abilities, intentionally deterministic per seed.
  if actor.side == 0:
   match int(actor.hero_id):
    0, 4: # Aidar/Arden: a defensive shield on the lowest-HP ally.
     if rng.randf() < 0.18:
      var guarded: Dictionary = actor
      for candidate in units:
       if candidate.side == 0 and candidate.hp > 0 and float(candidate.hp) / float(candidate.max_hp) < float(guarded.hp) / float(guarded.max_hp):
        guarded = candidate
      guarded.shield = mini(int(float(guarded.max_hp) / 3.0), int(guarded.shield) + maxi(5, int(actor.atk)))
    1: # Aisylu: precise shot.
     if rng.randf() < 0.22:
      damage = int(float(damage) * 1.75)
    2, 7: # Bulat/Garrok: heavy strikes.
     if rng.randf() < 0.17:
      damage = int(float(damage) * 1.5)
    5: # Kael: brief interruption.
     if rng.randf() < 0.14:
      target.stun = maxi(int(target.stun), 5)
    6, 9: # Morvena/Noctis: damage over time.
     if rng.randf() < 0.2:
      target.poison = maxi(int(target.poison), 20)
    8: # Auriel: a small protective blessing.
     if rng.randf() < 0.2:
      actor.shield = mini(int(float(actor.max_hp) / 3.0), int(actor.shield) + 12)
  var absorbed := mini(int(target.shield), damage)
  target.shield = maxi(0, int(target.shield) - absorbed)
  damage -= absorbed
  var applied := mini(int(target.hp), damage)
  target.hp = maxi(0,int(target.hp)-damage)
  if actor.side == 0:
   total_damage += applied
  if actor.side == 0 and rng.randf() < 0.15:
   battle_events.append("%s наносит %d урона" % [actor.name,damage])
   if battle_events.size() > MAX_BATTLE_EVENTS:
    battle_events.pop_front()

func _roll_loot_tier() -> int:
 # Four rarity bands, probability sum 100%; deterministic for a battle seed.
 var roll := rng.randi_range(1,100)
 if roll <= 55:
  return 0
 if roll <= 85:
  return 1
 if roll <= 97:
  return 2
 return 3

func _claim_regional_contract(region_id: int) -> void:
 if region_id < 1 or region_id > REGIONS.size() or regional_contracts_claimed.has(region_id):
  return
 if int(regional_wins[region_id-1]) < 5:
  return
 regional_contracts_claimed.append(region_id)
 gold = mini(2000000000,gold + 250)
 _save_data()
 _navigate("map")

func _rarity_color(tier: int) -> Color:
 match tier:
  0: return MUTED
  1: return Color("#76d6aa")
  2: return Color("#77bfff")
  3: return Color("#f1b56e")
 return TEXT

func _progress_meter(parent: Node, value: int, maximum: int, tint: Color) -> void:
 var bar := ProgressBar.new()
 bar.custom_minimum_size.y = 15
 bar.max_value = maxi(1, maximum)
 bar.value = clampi(value, 0, maxi(1, maximum))
 bar.show_percentage = false
 var fill := StyleBoxFlat.new()
 fill.bg_color = tint
 fill.corner_radius_top_left = 5
 fill.corner_radius_top_right = 5
 fill.corner_radius_bottom_left = 5
 fill.corner_radius_bottom_right = 5
 bar.add_theme_stylebox_override("fill", fill)
 parent.add_child(bar)

func _show_loot() -> void:
 var panel := _panel()
 _label(panel,"ДОБЫЧА И КУЗНИЦА",22,GOLD)
 _label(panel,"Каждая победа приносит один материал. Боссы дополнительно дают редкий осколок.",15,MUTED)
 for tier in range(LOOT_NAMES.size()):
  var rarity_row := HBoxContainer.new()
  panel.add_child(rarity_row)
  var rarity_label := _label(rarity_row,"%s · %s" % [LOOT_RARITY[tier],LOOT_NAMES[tier]],16,_rarity_color(tier))
  rarity_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
  _label(rarity_row,"× %d" % loot_inventory[tier],17,GOLD)
 _label(panel,"Уровень кузницы: %d / 10" % forge_level,18,GOLD)
 _progress_meter(panel,forge_level,10,GOLD)
 _label(panel,"Каждый уровень кузницы усиливает атаку всего отряда на 2 и здоровье на 10.",15)
 var price := 3 + forge_level * 2
 var craft := _button("УЛУЧШИТЬ КУЗНИЦУ · %d обычных + 1 необычный" % price)
 craft.disabled = forge_level >= 10 or int(loot_inventory[0]) < price or int(loot_inventory[1]) < 1
 craft.pressed.connect(_upgrade_forge)
 panel.add_child(craft)

func _upgrade_forge() -> void:
 if forge_level >= 10:
  return
 var price := 3 + forge_level * 2
 if int(loot_inventory[0]) < price or int(loot_inventory[1]) < 1:
  return
 loot_inventory[0] -= price
 loot_inventory[1] -= 1
 forge_level += 1
 _save_data()
 _navigate("loot")

func _update_bars() -> void:
 for item in hero_bars:
  var unit_index: int = int(item.index) + (5 if int(item.side) == 1 else 0)
  if unit_index < units.size():
   var u: Dictionary = units[unit_index]
   item.bar.value = clampf(100.0 * float(u.hp) / maxf(1.0, float(u.max_hp)), 0.0, 100.0)

func _finish_battle(won: bool) -> void:
 active = false
 if won:
  var reward := 50 + stage * 12
  # The last campaign boss can be replayed, but its unique relic is awarded once.
  # A region boss first-clear bonus is granted only once, including after loading old saves.
  if stage == 20 and not campaign_first_clear_rewards.has(chapter):
   campaign_first_clear_rewards.append(chapter)
   if not discovered_bosses.has(chapter):
    discovered_bosses.append(chapter)
   relics += 1
   boss_kills += 1
   gold = mini(2000000000,gold + chapter * 40)
  _reset_daily_if_needed()
  daily_wins += 1
  # Roll before displaying the result; previous code referenced drop_tier too early.
  var drop_tier := _roll_loot_tier()
  last_battle_result = "Победа! +%d золота · %s" % [reward,LOOT_NAMES[drop_tier]]
  gold = mini(2000000000,gold + reward)
  battle_wins += 1
  # v6.8: slow capped regional familiarity, never an infinite stat source.
  if int(region_affinity[battle_origin_chapter-1]) < REGION_AFFINITY_CAP and int(regional_wins[battle_origin_chapter-1]) % 5 == 4:
   region_affinity[battle_origin_chapter-1] += 1
  regional_wins[battle_origin_chapter-1] = mini(1000000,int(regional_wins[battle_origin_chapter-1]) + 1)
  # One deterministic drop per victory; bosses award an extra rare shard.
  loot_inventory[drop_tier] = mini(1000000,int(loot_inventory[drop_tier]) + 1)
  loot_total = mini(4000000,loot_total + 1)
  if battle_origin_stage == 20:
   loot_inventory[2] = mini(1000000,int(loot_inventory[2]) + 1)
   loot_total = mini(4000000,loot_total + 1)
  current_streak += 1
  best_streak = maxi(best_streak,current_streak)
  if chapter == 12 and stage == 20:
   stage = 20
   completed_campaign = true
  else:
   stage += 1
   if stage > 20:
    stage = 1
    chapter = mini(12, chapter + 1)
  if log_label != null:
   log_label.text = "ПОБЕДА! +%d золота · %s" % [reward,LOOT_NAMES[drop_tier]]
  if battle_status != null:
   battle_status.text = "✦ ПОБЕДА ✦"
 else:
  current_streak = 0
  last_battle_result = "Поражение. Измените состав или улучшите отряд."
  if log_label != null:
   log_label.text = "ПОРАЖЕНИЕ. Усильте отряд или измените состав героев."
  if battle_status != null:
   battle_status.text = "ПОРАЖЕНИЕ"
 best_chapter = maxi(best_chapter,chapter)
 battle_history.push_front({"win":won,"chapter":battle_origin_chapter,"stage":battle_origin_stage,"damage":total_damage,"healing":total_healing})
 if battle_history.size() > 20:
  battle_history.resize(20)
 _refresh_hud()
 _save_data()
 if log_label != null:
  log_label.text += "\nУрон: %d • Лечение: %d • Навыки: %d • Серия: %d" % [total_damage,total_healing,ability_triggers,current_streak]
 if battle_button != null:
  battle_button.text = "ПОВТОРИТЬ БОЙ" if not won else "СЛЕДУЮЩИЙ БОЙ"
  battle_button.disabled = false

func _show_quests() -> void:
 var p := _panel()
 _label(p,"📜 ЗАДАНИЯ ХРАНИТЕЛЯ",22,GOLD)
 _label(p,"Завершённые бои: %d • Лучшая серия: %d" % [battle_wins,best_streak],17)
 var goals := [1,3,10,20,50,100]
 for i in range(goals.size()):
  var goal: int = goals[i]
  var done := battle_wins >= goal
  var collected := (quests_claimed & (1 << i)) != 0
  var row := _panel()
  _label(row,"Победить в %d боях · Награда %d золота" % [goal,goal*35],16)
  var btn := _button("Получено" if collected else "Забрать" if done else "Не выполнено")
  btn.disabled = not done or collected
  btn.pressed.connect(_claim_quest.bind(i,goal))
  row.add_child(btn)

func _claim_quest(index: int, goal: int) -> void:
 if battle_wins < goal or (quests_claimed & (1 << index)) != 0:
  return
 quests_claimed |= (1 << index)
 gold += goal * 35
 _save_data()
 _navigate("quests")


func _show_expeditions() -> void:
 var p := _panel()
 _label(p,"ЭКСПЕДИЦИИ ПО БАШКОРТОСТАНУ",21,GOLD)
 _label(p,"Отправляйте отряд исследовать открытые регионы. Экспедиция длится 2 часа и не мешает боям.",15,MUTED)
 _label(p,"Реликвии: %d • Завершено: %d • Добыто золота: %d" % [relics,expedition_claims,expedition_total_gold],17,GOLD)
 if expedition_start > 0:
  var remaining := maxi(0,EXPEDITION_SECONDS - maxi(0, int(Time.get_unix_time_from_system()) - expedition_start))
  _label(p,"Регион: %s" % REGIONS[expedition_region].name,18)
  _label(p,"Осталось: %d мин" % int(ceil(float(remaining)/60.0)),17)
  var claim := _button("ЗАБРАТЬ ДОБЫЧУ" if remaining == 0 else "ЭКСПЕДИЦИЯ ИДЁТ")
  claim.disabled = remaining > 0
  claim.pressed.connect(_claim_expedition)
  p.add_child(claim)
 else:
  for i in range(mini(chapter,REGIONS.size())):
   var region: Dictionary = REGIONS[i]
   var b := _button("Исследовать: %s" % region.name)
   b.pressed.connect(_start_expedition.bind(i))
   p.add_child(b)

func _start_expedition(region_index: int) -> void:
 if expedition_start != 0 or region_index >= chapter or region_index < 0:
  return
 expedition_start = int(Time.get_unix_time_from_system())
 expedition_region = region_index
 _save_data()
 _navigate("expeditions")

func _claim_expedition() -> void:
 if expedition_start <= 0 or int(Time.get_unix_time_from_system()) - expedition_start < EXPEDITION_SECONDS:
  return
 var expedition_reward := 100 + expedition_region * 35
 gold = mini(2000000000, gold + expedition_reward)
 expedition_total_gold = mini(2000000000, expedition_total_gold + expedition_reward)
 relics = mini(2000000000, relics + 1)
 expedition_claims = mini(2000000000, expedition_claims + 1)
 expedition_start = 0
 _save_data()
 _navigate("expeditions")

func _show_settings() -> void:
 var p := _panel()
 _label(p,"⚙ НАСТРОЙКИ",22,GOLD)
 _label(p,"Автоматический бой · Портретный экран · Локальный прототип",16)
 var fx := _button("Эффекты: экономный режим" if reduced_effects else "Эффекты: обычный режим")
 fx.pressed.connect(_toggle_effects)
 p.add_child(fx)
 var large_text := _button("Крупный текст героев: ВКЛ" if accessibility_large_text else "Крупный текст героев: ВЫКЛ")
 large_text.pressed.connect(_toggle_large_text)
 p.add_child(large_text)
 var help := _button("ПОВТОРИТЬ ОБУЧЕНИЕ")
 help.pressed.connect(_show_tutorial)
 p.add_child(help)
 var toggle := _button("Звук: включён" if sound_enabled else "Звук: выключен")
 toggle.pressed.connect(_toggle_sound)
 p.add_child(toggle)
 _label(p,"Звук пока не подключён: переключатель сохраняет предпочтение.",13,MUTED)
 _label(p,"ВНИМАНИЕ: сохранения хранятся локально. Серверная синхронизация не реализована.",14,MUTED)

func _toggle_sound() -> void:
 sound_enabled = not sound_enabled
 _save_data()
 _navigate("settings")

func _save_data() -> void:
 var payload := JSON.stringify({"version":SAVE_VERSION,"gold":gold,"level":level,"chapter":chapter,"stage":stage,"party":party,"last_claim":last_claim,"battle_wins":battle_wins,"quests_claimed":quests_claimed,"sound_enabled":sound_enabled,"expedition_start":expedition_start,"expedition_region":expedition_region,"expedition_claims":expedition_claims,"relics":relics,"best_chapter":best_chapter,"best_streak":best_streak,"current_streak":current_streak,"tutorial_seen":tutorial_seen,"completed_campaign":completed_campaign,"owned_equipment":owned_equipment,"equipped":equipped,"boss_kills":boss_kills,"daily_day":daily_day,"daily_wins":daily_wins,"daily_claimed":daily_claimed,"achievement_claims":achievement_claims,"reduced_effects":reduced_effects,"formation_index":formation_index,"talent_points":talent_points,"battle_history":battle_history,"discovered_bosses":discovered_bosses,"claimed_region_rewards":claimed_region_rewards,"accessibility_large_text":accessibility_large_text,"expedition_total_gold":expedition_total_gold,"codex_seen":codex_seen,"campaign_first_clear_rewards":campaign_first_clear_rewards,"loot_inventory":loot_inventory,"loot_total":loot_total,"regional_wins":regional_wins,"regional_contracts_claimed":regional_contracts_claimed,"forge_level":forge_level,"hero_mastery":hero_mastery,"region_affinity":region_affinity,"equipment_reforges":equipment_reforges})
 # Preserve the previous valid save before writing the new one.
 if FileAccess.file_exists(SAVE_PATH):
  var old := FileAccess.open(SAVE_PATH,FileAccess.READ)
  if old != null:
   var old_text := old.get_as_text()
   if _is_valid_save(JSON.parse_string(old_text)):
    var backup := FileAccess.open(BACKUP_PATH,FileAccess.WRITE)
    if backup != null:
     backup.store_string(old_text)
 var f := FileAccess.open(SAVE_PATH,FileAccess.WRITE)
 if f != null:
  f.store_string(payload)

func _is_valid_save(value: Variant) -> bool:
 if typeof(value) != TYPE_DICTIONARY:
  return false
 # Reject truncated or unrelated JSON dictionaries before replacing a backup.
 if not (value.has("version") and value.has("gold") and value.has("chapter") and value.has("stage") and value.has("party")):
  return false
 if typeof(value["party"]) != TYPE_ARRAY or value["party"].size() != 5:
  return false
 var seen: Array = []
 for hero_id in value["party"]:
  if typeof(hero_id) != TYPE_INT and typeof(hero_id) != TYPE_FLOAT:
   return false
  var hero_number := float(hero_id)
  if is_nan(hero_number) or is_inf(hero_number) or hero_number < 0.0 or hero_number >= float(HEROES.size()):
   return false
  var index := int(hero_number)
  if index < 0 or index >= HEROES.size() or hero_number != float(index) or seen.has(index):
   return false
  seen.append(index)
 for key in ["version", "gold", "chapter", "stage"]:
  if typeof(value[key]) != TYPE_INT and typeof(value[key]) != TYPE_FLOAT:
   return false
  var number := float(value[key])
  if is_nan(number) or is_inf(number) or absf(number) > 2000000000.0:
   return false
  if number != float(int(number)):
   return false
 if int(value["gold"]) < 0 or int(value["gold"]) > 2000000000:
  return false
 if int(value["chapter"]) < 1 or int(value["chapter"]) > REGIONS.size():
  return false
 if int(value["stage"]) < 1 or int(value["stage"]) > 20:
  return false
 return int(value["version"]) >= 1 and int(value["version"]) <= SAVE_VERSION

func _load_data() -> void:
 last_claim = int(Time.get_unix_time_from_system())
 var data: Variant = null
 if FileAccess.file_exists(SAVE_PATH):
  var f := FileAccess.open(SAVE_PATH,FileAccess.READ)
  if f != null:
   data = JSON.parse_string(f.get_as_text())
 if not _is_valid_save(data) and FileAccess.file_exists(BACKUP_PATH):
  var backup := FileAccess.open(BACKUP_PATH,FileAccess.READ)
  if backup != null:
   data = JSON.parse_string(backup.get_as_text())
 if not _is_valid_save(data):
  return
 gold = clampi(int(data.get("gold",200)),0,2000000000)
 var loaded_affinity: Variant = data.get("region_affinity",[])
 if typeof(loaded_affinity) == TYPE_ARRAY and loaded_affinity.size() == REGIONS.size():
  for i in range(REGIONS.size()):
   region_affinity[i] = clampi(int(loaded_affinity[i]),0,REGION_AFFINITY_CAP)
 var loaded_reforges: Variant = data.get("equipment_reforges",[])
 if typeof(loaded_reforges) == TYPE_ARRAY and loaded_reforges.size() == EQUIPMENT.size():
  for i in range(EQUIPMENT.size()):
   equipment_reforges[i] = clampi(int(loaded_reforges[i]),0,EQUIPMENT_REFORGE_CAP)
 var loaded_loot: Variant = data.get("loot_inventory",[0,0,0,0])
 if typeof(loaded_loot) == TYPE_ARRAY and loaded_loot.size() == 4:
  for i in range(4):
   loot_inventory[i] = clampi(int(loaded_loot[i]),0,1000000)
 loot_total = maxi(0,int(data.get("loot_total",0)))
 var loaded_wins: Variant = data.get("regional_wins",[])
 if typeof(loaded_wins) == TYPE_ARRAY and loaded_wins.size() == 12:
  for i in range(12):
   regional_wins[i] = clampi(int(loaded_wins[i]),0,1000000)
 var loaded_contracts: Variant = data.get("regional_contracts_claimed",[])
 if typeof(loaded_contracts) == TYPE_ARRAY:
  for value in loaded_contracts:
   var region_id := int(value)
   if region_id >= 1 and region_id <= 12 and not regional_contracts_claimed.has(region_id):
    regional_contracts_claimed.append(region_id)
 forge_level = clampi(int(data.get("forge_level",0)),0,10)
 var loaded_mastery: Variant = data.get("hero_mastery",[])
 if typeof(loaded_mastery) == TYPE_ARRAY and loaded_mastery.size() == HEROES.size():
  for i in range(HEROES.size()):
   if typeof(loaded_mastery[i]) == TYPE_INT or typeof(loaded_mastery[i]) == TYPE_FLOAT:
    hero_mastery[i] = clampi(int(loaded_mastery[i]),0,5)
 expedition_start = clampi(int(data.get("expedition_start",0)),0,int(Time.get_unix_time_from_system()))
 expedition_region = clampi(int(data.get("expedition_region",0)),0,REGIONS.size()-1)
 expedition_claims = maxi(0,int(data.get("expedition_claims",0)))
 relics = clampi(int(data.get("relics",0)),0,100000)
 best_chapter = clampi(int(data.get("best_chapter",1)),1,12)
 best_streak = maxi(0,int(data.get("best_streak",0)))
 current_streak = clampi(int(data.get("current_streak",0)),0,best_streak)
 tutorial_seen = bool(data.get("tutorial_seen",false))
 completed_campaign = bool(data.get("completed_campaign",false))
 boss_kills = maxi(0,int(data.get("boss_kills",0)))
 daily_day = maxi(0,int(data.get("daily_day",0)))
 daily_wins = maxi(0,int(data.get("daily_wins",0)))
 daily_claimed = bool(data.get("daily_claimed",false))
 achievement_claims = maxi(0,int(data.get("achievement_claims",0)))
 reduced_effects = bool(data.get("reduced_effects",false))
 formation_index = clampi(int(data.get("formation_index",0)),0,FORMATIONS.size()-1)
 accessibility_large_text = bool(data.get("accessibility_large_text",false))
 expedition_total_gold = maxi(0,int(data.get("expedition_total_gold",0)))
 var loaded_talents: Variant = data.get("talent_points",[0,0,0])
 if typeof(loaded_talents) == TYPE_ARRAY and loaded_talents.size() == 3:
  talent_points = [clampi(int(loaded_talents[0]),0,10),clampi(int(loaded_talents[1]),0,10),clampi(int(loaded_talents[2]),0,10)]
 var loaded_history: Variant = data.get("battle_history",[])
 if typeof(loaded_history) == TYPE_ARRAY:
  for entry in loaded_history.slice(0,20):
   if typeof(entry) == TYPE_DICTIONARY:
    battle_history.append({"win":bool(entry.get("win",false)),"chapter":clampi(int(entry.get("chapter",1)),1,12),"stage":clampi(int(entry.get("stage",1)),1,20),"damage":maxi(0,int(entry.get("damage",0))),"healing":maxi(0,int(entry.get("healing",0)))})
 for field in ["discovered_bosses","claimed_region_rewards","codex_seen"]:
  var loaded: Variant = data.get(field,[])
  if typeof(loaded) == TYPE_ARRAY:
   var target: Array = discovered_bosses if field == "discovered_bosses" else claimed_region_rewards if field == "claimed_region_rewards" else codex_seen
   for value in loaded:
    var region_id := int(value)
    if region_id >= 1 and region_id <= 12 and not target.has(region_id):
     target.append(region_id)
 # Migrate boss first-clear flags from older saves to avoid repeat unique rewards.
 var loaded_first_clears: Variant = data.get("campaign_first_clear_rewards", data.get("discovered_bosses", []))
 if typeof(loaded_first_clears) == TYPE_ARRAY:
  for value in loaded_first_clears:
   var region_id := int(value)
   if region_id >= 1 and region_id <= 12 and not campaign_first_clear_rewards.has(region_id):
    campaign_first_clear_rewards.append(region_id)
 if bool(data.get("completed_campaign",false)) and not campaign_first_clear_rewards.has(12):
  campaign_first_clear_rewards.append(12)
 var saved_items: Variant = data.get("owned_equipment",[])
 if typeof(saved_items) == TYPE_ARRAY:
  for item in saved_items:
   var item_id := int(item)
   if item_id >= 0 and item_id < EQUIPMENT.size() and not owned_equipment.has(item_id):
    owned_equipment.append(item_id)
 var saved_equipped: Variant = data.get("equipped",{})
 if typeof(saved_equipped) == TYPE_DICTIONARY:
  var assigned_items: Array = []
  for key in saved_equipped:
   var hero_id := int(key)
   var item_id := int(saved_equipped[key])
   # Each purchased item represents a single physical copy.
   if hero_id >= 0 and hero_id < HEROES.size() and owned_equipment.has(item_id) and not assigned_items.has(item_id):
    equipped[str(hero_id)] = item_id
    assigned_items.append(item_id)
 _reset_daily_if_needed()
 battle_wins = maxi(0,int(data.get("battle_wins",0)))
 quests_claimed = maxi(0,int(data.get("quests_claimed",0)))
 sound_enabled = bool(data.get("sound_enabled",true))
 level = clampi(int(data.get("level",1)),1,240)
 chapter = clampi(int(data.get("chapter",1)),1,12)
 stage = clampi(int(data.get("stage",1)),1,20)
 last_claim = clampi(int(data.get("last_claim",last_claim)),0,int(Time.get_unix_time_from_system()))
 var saved = data.get("party",[0,1,2,3,4])
 if typeof(saved) == TYPE_ARRAY:
  var valid: Array = []
  for id in saved:
   var n := int(id)
   if n >= 0 and n < HEROES.size() and not valid.has(n) and valid.size() < 5:
    valid.append(n)
  if valid.size() == 5:
   party = valid


func _equipment_bonus(hero_id: int) -> Dictionary:
 var result := {"atk":0,"hp":0}
 var item_id := int(equipped.get(str(hero_id),-1))
 if item_id >= 0 and item_id < EQUIPMENT.size() and owned_equipment.has(item_id):
  result.atk = int(EQUIPMENT[item_id].atk) + int(equipment_reforges[item_id]) * 2
  result.hp = int(EQUIPMENT[item_id].hp) + int(equipment_reforges[item_id]) * 8
 return result

func _show_equipment() -> void:
 var p := _panel()
 _label(p,"СНАРЯЖЕНИЕ И АРТЕФАКТЫ",21,GOLD)
 _label(p,"Покупайте предметы за игровое золото и назначайте их героям. Один предмет можно закрепить за одним героем.",15,MUTED)
 for i in range(EQUIPMENT.size()):
  var item: Dictionary = EQUIPMENT[i]
  var row := _panel()
  _label(row,"%s · %s" % [item.name,item.slot],18,GOLD)
  _label(row,"Атака +%d · Здоровье +%d" % [int(item.atk) + int(equipment_reforges[i]) * 2,int(item.hp) + int(equipment_reforges[i]) * 8],15)
  _label(row,"Закалка: %d/%d" % [int(equipment_reforges[i]),EQUIPMENT_REFORGE_CAP],14,MUTED)
  if not owned_equipment.has(i):
   var buy := _button("КУПИТЬ · %d золота" % item.cost)
   buy.disabled = gold < int(item.cost)
   buy.pressed.connect(_buy_equipment.bind(i))
   row.add_child(buy)
  else:
   var reforge_cost := 2 + int(equipment_reforges[i]) * 2
   var reforge := _button("ЗАКАЛИТЬ · %d обычных осколков" % reforge_cost)
   reforge.disabled = int(equipment_reforges[i]) >= EQUIPMENT_REFORGE_CAP or int(loot_inventory[0]) < reforge_cost
   reforge.pressed.connect(_reforge_equipment.bind(i))
   row.add_child(reforge)
   for hero_id in party:
    var equip_label := "Надеть: %s" % HEROES[hero_id].name
    if int(equipped.get(str(hero_id),-1)) == i:
     equip_label = "✓ %s" % HEROES[hero_id].name
    var equip := _button(equip_label)
    equip.pressed.connect(_equip_item.bind(i,hero_id))
    row.add_child(equip)

func _reforge_equipment(item_id: int) -> void:
 if item_id < 0 or item_id >= EQUIPMENT.size() or not owned_equipment.has(item_id):
  return
 var rank := int(equipment_reforges[item_id])
 var price := 2 + rank * 2
 if rank >= EQUIPMENT_REFORGE_CAP or int(loot_inventory[0]) < price:
  return
 loot_inventory[0] -= price
 equipment_reforges[item_id] = rank + 1
 _save_data()
 _navigate("equipment")

func _buy_equipment(item_id: int) -> void:
 if item_id < 0 or item_id >= EQUIPMENT.size() or owned_equipment.has(item_id):
  return
 var price := int(EQUIPMENT[item_id].cost)
 if gold < price:
  return
 gold -= price
 owned_equipment.append(item_id)
 _save_data()
 _navigate("equipment")

func _equip_item(item_id: int, hero_id: int) -> void:
 if not owned_equipment.has(item_id) or hero_id < 0 or hero_id >= HEROES.size():
  return
 for key in equipped.keys():
  if int(equipped[key]) == item_id:
   equipped.erase(key)
 equipped[str(hero_id)] = item_id
 _save_data()
 _navigate("equipment")

func _reset_daily_if_needed() -> void:
 var today := int(floor(float(Time.get_unix_time_from_system()) / 86400.0))
 if today != daily_day:
  daily_day = today
  daily_wins = 0
  daily_claimed = false

func _claim_daily() -> void:
 _reset_daily_if_needed()
 if daily_claimed or daily_wins < 3:
  return
 daily_claimed = true
 gold += 150
 _save_data()
 _navigate("map")

func _show_achievements() -> void:
 var p := _panel()
 _label(p,"ДОСТИЖЕНИЯ ХРАНИТЕЛЯ",21,GOLD)
 var goals := [5,25,75,150]
 for i in range(goals.size()):
  var done: bool = battle_wins >= int(goals[i])
  var claimed := (achievement_claims & (1 << i)) != 0
  var row := _panel()
  _label(row,"Победы: %d / %d · Награда: %d золота" % [mini(battle_wins,goals[i]),goals[i],(i+1)*200],16)
  var btn := _button("Получено" if claimed else "ЗАБРАТЬ" if done else "Не выполнено")
  btn.disabled = claimed or not done
  btn.pressed.connect(_claim_achievement.bind(i,goals[i]))
  row.add_child(btn)

func _claim_achievement(index: int, goal: int) -> void:
 if battle_wins < goal or (achievement_claims & (1 << index)) != 0:
  return
 achievement_claims |= (1 << index)
 gold += (index+1)*200
 _save_data()
 _navigate("achievements")

func _toggle_effects() -> void:
 reduced_effects = not reduced_effects
 _save_data()
 _navigate("settings")

# v1.7 Formation, v1.8 Talents, v1.9 Battle journal, v2.0 Bestiary,
# v2.1 Codex, v2.2 Region rewards, v2.3 Accessibility, v2.4 Expedition ledger.
func _show_talents() -> void:
 var p := _panel()
 _label(p,"ТАЛАНТЫ ОТРЯДА",22,GOLD)
 var available := maxi(0,int(level / 5) - (talent_points[0] + talent_points[1] + talent_points[2]))
 _label(p,"Очки талантов: %d · одно очко за 5 уровней" % available,16)
 for i in range(TALENTS.size()):
  var row := _panel()
  _label(row,"%s: %d/10" % [TALENTS[i],talent_points[i]],17)
  var btn := _button("УЛУЧШИТЬ")
  btn.disabled = available <= 0 or talent_points[i] >= 10
  btn.pressed.connect(_buy_talent.bind(i))
  row.add_child(btn)

func _buy_talent(index: int) -> void:
 if index < 0 or index >= 3 or talent_points[index] >= 10:
  return
 if talent_points[0] + talent_points[1] + talent_points[2] >= int(level / 5):
  return
 talent_points[index] += 1
 _save_data()
 _navigate("talents")

func _show_journal() -> void:
 var p := _panel()
 _label(p,"ЖУРНАЛ ПОСЛЕДНИХ 20 БОЁВ",21,GOLD)
 var wins_recent := 0
 for entry in battle_history:
  if bool(entry.win):
   wins_recent += 1
 if not battle_history.is_empty():
  _label(p,"Побед: %d/%d · Успех: %d%%" % [wins_recent,battle_history.size(),int(round(100.0 * wins_recent / battle_history.size()))],15,GOLD)
 if battle_history.is_empty():
  _label(p,"Пока нет завершённых боёв.",16,MUTED)
 for entry in battle_history:
  _label(p,"%s · Регион %d, этап %d · Урон %d · Лечение %d" % ["Победа" if entry.win else "Поражение",entry.chapter,entry.stage,entry.damage,entry.healing],14)

func _show_bestiary() -> void:
 var p := _panel()
 _label(p,"БЕСТИАРИЙ ХРАНИТЕЛЕЙ",21,GOLD)
 for i in range(REGIONS.size()):
  var found := discovered_bosses.has(i+1)
  _label(p,"%02d · %s" % [i+1,REGIONS[i].boss if found else "Неизвестный страж"],16,GOLD if found else MUTED)

func _show_codex() -> void:
 var p := _panel()
 _label(p,"ЛЕТОПИСЬ ЮЖНОГО УРАЛА",21,GOLD)
 for i in range(mini(chapter,REGIONS.size())):
  _label(p,"%s · %s" % [REGIONS[i].name,LORE[i]],15)
  if not codex_seen.has(i+1):
   codex_seen.append(i+1)
 _save_data()

func _show_region_rewards() -> void:
 var p := _panel()
 _label(p,"НАГРАДЫ ЗА ОСВОЕНИЕ РЕГИОНОВ",21,GOLD)
 for i in range(REGIONS.size()):
  var region_id := i+1
  var cleared := region_id < chapter or (region_id == 12 and completed_campaign)
  var claimed := claimed_region_rewards.has(region_id)
  var row := _panel()
  _label(row,"%s · %d золота" % [REGIONS[i].name,region_id*75],15)
  var btn := _button("Получено" if claimed else "ЗАБРАТЬ" if cleared else "Закрыто")
  btn.disabled = claimed or not cleared
  btn.pressed.connect(_claim_region_reward.bind(region_id))
  row.add_child(btn)

func _claim_region_reward(region_id: int) -> void:
 if region_id < 1 or region_id > 12 or claimed_region_rewards.has(region_id):
  return
 if not (region_id < chapter or (region_id == 12 and completed_campaign)):
  return
 claimed_region_rewards.append(region_id)
 gold += region_id * 75
 _save_data()
 _navigate("regions")

func _toggle_large_text() -> void:
 accessibility_large_text = not accessibility_large_text
 _save_data()
 _navigate("settings")