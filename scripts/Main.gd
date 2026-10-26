extends Control
# ACCA Study Buddy - Godot 4 port of the HTML prototype (preview/index.html).
# Everything is built in code; Main.tscn is a single Control. Screens live under `stage` (720 x 1280).
#   Main.gd     this file: top bar, screens (title, home, menus, records, syllabus, boss lobby), helpers
#   Book.gd     Chapter Book + lessons (Learn / Apply it / Worked example / Your turn)
#   Battle.gd   Pokémon-style battle (chapters, training, Shrine, lesson practice, Boss Arena gauntlet)
#   Mtq.gd      Section B 15-mark boss
#   Exam.gd     Exam Hall: CBE-style mocks and full 100-mark mocks
#   Planner.gd  Study plan, calendar, Notebook, exam dates, key dates
#   Calc.gd     the calculator overlay
#   Help.gd     the "?" overlay: what this screen is for and what its buttons do
# Game.gd (autoload) saves progress; UI.gd (autoload) is the theme; Content.gd (autoload) is the content.

# Logical screen size: 720 x 1280 held upright, 1280 x 720 held sideways (see _apply_orientation).
var W := 720
var H := 1280
var landscape := false
const SAMURAI := "res://assets/characters/samurai.png"
const MONSTER := "res://assets/monster.png"
const SCENES := [[Color("0f1a3a"), Color("8fd3ff"), Color("5fc07a")], [Color("3b2a52"), Color("e8a0bf"), Color("c98a2e")], [Color("16324f"), Color("79c7c5"), Color("6b8e23")], [Color("141a33"), Color("9fb4e8"), Color("d9a07a")]]
const AREA_SCENE := {"boss": [Color("3a0f1e"), Color("8c2b3c"), Color("4a2a2a")], "bank": [Color("1f5d63"), Color("7fd0c8"), Color("3f8a6a")], "mistakes": [Color("b05a8a"), Color("ffd6e6"), Color("8fc27a")], "mock": [Color("141a33"), Color("3c4a7a"), Color("2f3f55")]}
const ACCA_EXAMS := [
	{"grp": "Applied Knowledge", "code": "BT", "name": "Business and Technology", "passed": true},
	{"grp": "Applied Knowledge", "code": "MA", "name": "Management Accounting", "passed": true},
	{"grp": "Applied Knowledge", "code": "FA", "name": "Financial Accounting", "content": "FFA"},
	{"grp": "Applied Skills", "code": "LW", "name": "Corporate and Business Law"},
	{"grp": "Applied Skills", "code": "FR", "name": "Financial Reporting"},
	{"grp": "Applied Skills", "code": "TX", "name": "Taxation"},
	{"grp": "Applied Skills", "code": "FM", "name": "Financial Management"},
	{"grp": "Applied Skills", "code": "PM", "name": "Performance Management"},
	{"grp": "Applied Skills", "code": "AA", "name": "Audit and Assurance"},
	{"grp": "Strategic Professional", "code": "SBL", "name": "Strategic Business Leader (compulsory)"},
	{"grp": "Strategic Professional", "code": "SBR", "name": "Strategic Business Reporting (compulsory)"},
	{"grp": "Strategic Professional", "code": "OPT 1", "name": "Option: AFM, APM, ATX, AAA or Data Science"},
	{"grp": "Strategic Professional", "code": "OPT 2", "name": "Option: AFM, APM, ATX, AAA or Data Science"},
]
const AREAS := [
	{"id": "book", "name": "Chapter Book", "sub": "Battle each topic monster", "box": "BGbox_03A", "icon": "Icon_14", "dark": true},
	{"id": "boss", "name": "Boss Arena", "sub": "Boss gauntlet - 32 bosses a lap", "box": "BGbox_07A", "icon": "Icon_06", "dark": false},
	{"id": "bank", "name": "Training Grounds", "sub": "Drill by topic or type", "box": "BGbox_02B", "icon": "Icon_03", "dark": false},
	{"id": "heal", "name": "Healer's Shrine", "sub": "Fix your mistakes", "box": "BGbox_01A", "icon": "Icon_09", "dark": true},
	{"id": "mock", "name": "Exam Hall", "sub": "Five timed mock exams", "box": "BGbox_01B", "icon": "Icon_12", "dark": false},
	{"id": "rec", "name": "Hall of Records", "sub": "Strengths & weak spots", "box": "BGbox_05A", "icon": "Icon_01", "dark": true},
]

var EXAM: Dictionary = {}
var exam_id: String = "FFA"
var SYL: Array = []
var stage: Control
var screens: Dictionary = {}
var cur_screen := ""
var top_bar: Control
var voice_btn: Button
var sfx_btn: Button
var snow: Node2D
var lights: TextureRect
var sfx_player: AudioStreamPlayer
var sfx_streams: Dictionary = {}
var study_sec := 0.0
var tts_voice := ""

var book: Node
var battle: Node
var mtq: Node
var exam: Node
var planner: Node
var calc: Node
var help: Node
var menu_title := ""   # which menu() screen is showing, so Help can explain it

# ---------------------------------------------------------------- setup
func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	_apply_orientation(false)
	get_tree().root.size_changed.connect(func(): _apply_orientation(true))
	exam_id = Game.exam_id
	_select_exam_data(exam_id)
	stage = Control.new()
	stage.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(stage)
	for n in ["title", "home", "menu", "book", "lesson", "battle", "mtq", "exam"]:
		var s := Control.new()
		s.set_anchors_preset(Control.PRESET_FULL_RECT)
		s.visible = false
		stage.add_child(s)
		screens[n] = s
	book = preload("res://scripts/Book.gd").new()
	battle = preload("res://scripts/Battle.gd").new()
	mtq = preload("res://scripts/Mtq.gd").new()
	exam = preload("res://scripts/Exam.gd").new()
	planner = preload("res://scripts/Planner.gd").new()
	calc = preload("res://scripts/Calc.gd").new()
	for m in [book, battle, mtq, exam, planner]:
		add_child(m)
		m.setup(self)
	_build_overlays()
	_build_top_bar()
	add_child(calc)
	calc.setup(self)
	help = preload("res://scripts/Help.gd").new()
	add_child(help)
	help.setup(self)
	_load_sfx()
	_init_tts()
	show_title()
	_check_for_update()

# ---------------------------------------------------------------- updates
# Once per launch: ask GitHub for the latest release. If its tag (v2.5) is newer than this build's
# application/config/version, title and home show a button that downloads the new APK. Offline: nothing.
const RELEASES_API := "https://api.github.com/repos/Zahra3789/ACCA-Study-Buddy/releases/latest"
var update_info: Dictionary = {}

func _check_for_update() -> void:
	var http := HTTPRequest.new()
	http.timeout = 15.0
	add_child(http)
	http.request_completed.connect(func(result: int, code: int, _headers, body: PackedByteArray):
		http.queue_free()
		if result != HTTPRequest.RESULT_SUCCESS or code != 200:
			return
		var rel = JSON.parse_string(body.get_string_from_utf8())
		if typeof(rel) != TYPE_DICTIONARY:
			return
		var tag := str(rel.get("tag_name", ""))
		if not _newer(tag.trim_prefix("v"), str(ProjectSettings.get_setting("application/config/version", "0"))):
			return
		var url := str(rel.get("html_url", ""))
		for a in rel.get("assets", []):
			if str(a.get("name", "")).ends_with(".apk"):
				url = str(a.get("browser_download_url", url))
		update_info = {"tag": tag, "url": url}
		if cur_screen == "title":
			show_title()
		elif cur_screen == "home":
			show_home())
	http.request(RELEASES_API, ["User-Agent: ACCA-Study-Buddy", "Accept: application/vnd.github+json"])

# "2.10" is newer than "2.9": compare each dotted part as a number.
func _newer(latest: String, current: String) -> bool:
	var a := latest.split(".")
	var b := current.split(".")
	for i in maxi(a.size(), b.size()):
		var x := int(a[i]) if i < a.size() else 0
		var y := int(b[i]) if i < b.size() else 0
		if x != y:
			return x > y
	return false

func _update_button(v: Control) -> void:
	if update_info.is_empty():
		return
	v.add_child(UI.button("⬇ Update %s ready - tap to download" % update_info["tag"], "03A", func():
		sfx("tap")
		OS.shell_open(update_info["url"]), false, 24))

# The phone decides: wider than tall -> 1280 x 720 landscape layouts, otherwise 720 x 1280 portrait.
func _apply_orientation(rebuild: bool) -> void:
	var win := DisplayServer.window_get_size()
	var wide := win.x > win.y
	if wide == landscape and rebuild:
		return
	landscape = wide
	W = 1280 if wide else 720
	H = 720 if wide else 1280
	UI.compact = wide
	get_tree().root.content_scale_size = Vector2i(W, H)
	if rebuild:
		relayout()

func relayout() -> void:
	top_bar.get_child(0).size = Vector2(W - 20, 44)
	lights.size = Vector2(W / 3.0, 8)
	battle.relayout()
	calc.relayout()
	help.relayout()
	match cur_screen:
		"title": show_title()
		"home": show_home()
		"book": book.show_book()
		"lesson": book.render_lesson()
		"mtq": mtq.render()
		"exam":
			if not exam.X.get("done", false):
				exam.render()

func _select_exam_data(id: String) -> void:
	var list: Array = Content.EXAMS
	EXAM = list[0]
	for e in list:
		if e.get("id", "") == id:
			EXAM = e
	exam_id = EXAM.get("id", "FFA")
	Game.exam_id = exam_id
	SYL = EXAM.get("syllabus", [])

func select_exam(id: String) -> void:
	_select_exam_data(id)
	Game.save_game()
	book.book_tab = 0
	book.book_sel = 1
	show_home()

func _build_top_bar() -> void:
	top_bar = Control.new()
	top_bar.set_anchors_preset(Control.PRESET_FULL_RECT)
	top_bar.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(top_bar)
	# six equal buttons with even gaps, like the HTML top bar
	var row := HBoxContainer.new()
	row.position = Vector2(10, 6)
	row.size = Vector2(W - 20, 44)
	row.add_theme_constant_override("separation", 10)
	top_bar.add_child(row)
	_top_button(row, "ESC", "04A", escape_screen)
	voice_btn = _top_button(row, "VOICE OFF", "05A", toggle_voice)
	sfx_btn = _top_button(row, "SFX ON", "02A", toggle_sfx)
	theme_btn = _top_button(row, "THEME OFF", "01A", toggle_theme)
	sensei_btn = _top_button(row, "E-LDN OFF", "04A", toggle_sensei)
	_top_button(row, "DATES", "03A", planner.show_key_dates)
	_top_button(row, "CALC", "06A", func(): calc.toggle(true))
	var hb := _top_button(row, "?", "03A", func(): sfx("tap"); help.open())
	hb.size_flags_horizontal = Control.SIZE_FILL
	hb.custom_minimum_size.x = 56
	hb.add_theme_font_size_override("font_size", 24)
	draw_toggles()

var theme_btn: Button
var sensei_btn: Button
func _top_button(row: HBoxContainer, text: String, code: String, fn: Callable) -> Button:
	var b := UI.button(text, code, fn, true, 17)
	b.custom_minimum_size = Vector2(0, 44)
	b.clip_text = true
	# seven buttons share 700 px, so the usual 28 px side padding leaves no room for a word
	for st in ["normal", "hover", "pressed", "disabled"]:
		var sb: StyleBox = b.get_theme_stylebox(st).duplicate()
		sb.content_margin_left = 6; sb.content_margin_right = 6; sb.content_margin_top = 6; sb.content_margin_bottom = 6
		b.add_theme_stylebox_override(st, sb)
	row.add_child(b)
	return b

func draw_toggles() -> void:
	voice_btn.text = "VOICE ON" if Game.settings.get("voice", false) else "VOICE OFF"
	sfx_btn.text = "SFX ON" if Game.settings.get("sfx", true) else "SFX OFF"
	var t := theme()   # icon when a theme is on (tree / pumpkin), the word THEME when off
	var ip := "res://assets/xmas/%s.png" % ("tree" if t == "xmas" else "pumpkin")
	if t != "" and ResourceLoader.exists(ip):
		theme_btn.text = ""
		theme_btn.icon = load(ip)
		theme_btn.expand_icon = true
		theme_btn.icon_alignment = HORIZONTAL_ALIGNMENT_CENTER
	else:
		theme_btn.text = "THEME"
		theme_btn.icon = null
	sensei_btn.text = "E-LDN ON" if east() else "E-LDN OFF"

# ---------------------------------------------------------------- Sensei's voice: proper, or East London (cheeky, a bit dark, never cruel)
# Only Sensei's chatter changes; lessons, questions and explanations stay as written. Mirrors SENSEI in preview/index.html.
const SENSEI := {
	"welcome_title": {"proper": "Welcome to the dojo, Zuru.", "east": "Wallahi, you're back. Welcome to the dojo, Zuru - wipe your feet, fam."},
	"welcome_home": {"proper": "Welcome back, Zuru!", "east": "Oi, Zuru! Back again, innit. Say less - let's go."},
	"appear": {"proper": "A wild [b]{foe}[/b] appeared! Topic: {topic}.", "east": "Oi oi - [b]{foe}[/b] has rolled up wanting beef about {topic}. Allow it? Nah. Clap it."},
	"correct": {"proper": ["[b]Correct![/b] Zuru used [b]{move}[/b]! It's super effective!"],
		"east": ["[b]Wallahi, that's it![/b] [b]{move}[/b] - clean.", "[b]Say less.[/b] {move}! The monster's got bare problems now.", "[b]Mashallah![/b] {move}! The auditor's shook.", "[b]Big up yourself.[/b] {move}. Debit the monster, credit your ego, styll.", "[b]That's calm.[/b] {move}! Nobody got hurt. Well - nobody important."]},
	"wrong": {"proper": ["[b]Wrong.[/b] {foe} blocked it and struck back! The answer was [b]{ans}[/b]."],
		"east": ["[b]Nah, bruv.[/b] {foe} saw that coming from Whitechapel. It was [b]{ans}[/b].", "[b]Peak.[/b] That answer's gone straight to irrecoverable debts. It was [b]{ans}[/b].", "[b]Wallahi, allow it.[/b] {foe} clapped you right back. It was [b]{ans}[/b].", "[b]That's long.[/b] Still, nobody died - the ledger just cried a bit. It was [b]{ans}[/b].", "[b]Suspense account, that answer.[/b] Unexplained, and about to be cleared: it was [b]{ans}[/b]."]},
	"won": {"proper": "{foe} fainted! You landed [b]{n} / {total}[/b] hits ([b]{pct}%[/b]).", "east": "Say less - {foe}'s gone home crying to its mum. [b]{n} / {total}[/b] hits ([b]{pct}%[/b])."},
	"lost": {"proper": "{foe} is still standing... [b]{n} / {total}[/b] hits ([b]{pct}%[/b]). Aim for 70% to defeat it.", "east": "{foe}'s still standing - wallahi, the cheek. [b]{n} / {total}[/b] hits ([b]{pct}%[/b]). 70% or it's back to the shoebox, fam."},
	"session_done": {"proper": "Session complete: [b]{n} / {total}[/b] right ([b]{pct}%[/b]).", "east": "Done, innit: [b]{n} / {total}[/b] right ([b]{pct}%[/b]). The dummy's seen worse. Barely."},
	"lesson_pass": {"proper": "[b]Lesson passed![/b] ", "east": "[b]Lesson done, you absolute don.[/b] "},
	"lesson_fail": {"proper": "Not passed yet. Have another look at the lesson, then try again - you need 70%.", "east": "Not yet, fam. Go back through the lesson and come back swinging - 70%, you get me."},
	"xp": {"proper": "+{xp} XP.  You are [b]Lv {lv}[/b].", "east": "+{xp} XP. [b]Lv {lv}[/b]. Mashallah."},
	"shrine_hint": {"proper": " Anything you missed is waiting at the Healer's Shrine.", "east": " Whatever you flopped is sulking at the Healer's Shrine."},
	"shrine_intro": {"proper": "Every question you missed is here. Get it right and the wound heals.", "east": "Every one you flopped is in here. Get it right and the wound heals - like the NHS, minus the eight-hour wait at the Royal London."},
	"training_intro": {"proper": "Training: [b]{topic}[/b]. Answer as many as you like, then choose Finish session.", "east": "Training on [b]{topic}[/b]. Go as long as you like, fam - the dummy doesn't feel pain. Wallahi, probably."},
	"practice_intro": {"proper": "Lesson {n} practice: [b]{title}[/b]. {q} exam-style questions - score 70% to pass!", "east": "Lesson {n} practice: [b]{title}[/b]. {q} questions, 70% to pass. No pressure. Bit of pressure, styll."},
	"boss_down": {"proper": "[b]{foe} fainted![/b] That's [b]{n}[/b] boss{es} down. Zuru recovers {heal} HP.", "east": "[b]{foe}'s done![/b] {n} boss{es} down. Zuru gets {heal} HP back and a cup of shaah."},
	"cleared": {"proper": "[b]DOJO CLEARED![/b] Every boss in the lineup is down - {bosses} in this run{laps}.", "east": "[b]DOJO CLEARED![/b] Whole lineup's on the floor - {bosses} this run{laps}. Wallahi, someone ring the undertaker."},
	"left": {"proper": "You leave the arena with {bosses} defeated.", "east": "Cool, cool. Off you go then - {bosses} down. Not bad for a Tuesday, innit."},
	"fell": {"proper": "[b]Zuru fell![/b] {foe} wins this time - but {bosses} went down first.", "east": "[b]Zuru's on the deck![/b] {foe} took this one - but {bosses} went down first, so who's the real loser? (Still you. A bit. Allow it.)"},
	"exam_hint": {"proper": "Pass mark 50%. {timeup}Every wrong answer is now waiting at the Healer's Shrine.", "east": "Pass mark 50%. {timeup}The examiner feeds on tears; the Shrine feeds on your wrong answers. Say less - off you go."},
	"reset_done": {"proper": "A fresh start, Zuru! All progress has been reset.", "east": "Wiped, wallahi. Like it never happened. Dark, but clean."},
	"lesson_open": {"proper": ["Let's take it from the top."], "east": ["Right, listen up, fam. From the top.", "Wallahi, this one matters - eyes open.", "Say less, let's get into it."]},
	"lesson_page": {"proper": ["", "", "Keep going."], "east": ["Still with me? Good.", "Keep going - you're doing bits.", "This bit comes up in the exam, styll.", "", "Allow the phone, this is the important part."]},
	"lesson_apply": {"proper": ["Now see it at the lemonade stand."], "east": ["Now watch Zuru do it with lemons, innit.", "Lemonade stand time. Real life, fam.", "Same thing, but with yuzu. You get me."]},
	"lesson_example": {"proper": ["Watch the numbers build up step by step."], "east": ["Numbers time. Follow the steps - no skipping.", "Watch this. Step by step, no long ting."]},
	"lesson_turn": {"proper": ["Your turn."], "east": ["Your turn, fam. Don't flop it.", "Right - prove it. Wallahi I believe in you. Mostly.", "Go on then. Make the monster regret turning up."]},
	"chapter_pick": {"proper": "{monster} guards this chapter. Pick a lesson.", "east": "{monster}'s guarding this one. Pick a lesson and let's clap it."},
	"mtq_intro": {"proper": "15 marks, part marks for every box. Take your time.", "east": "Section B, fam. 15 marks, part marks for every box. No pressure. Bit of pressure."},
}

func east() -> bool:
	return str(Game.settings.get("sensei", "proper")) == "east"

func S(key: String, vars: Dictionary = {}) -> String:
	var v = SENSEI[key]["east" if east() else "proper"]
	var t: String = v[randi() % v.size()] if v is Array else str(v)
	for k in vars.keys():
		t = t.replace("{" + k + "}", str(vars[k]))
	return t

func toggle_sensei() -> void:
	Game.settings["sensei"] = "proper" if east() else "east"
	Game.save_settings()
	draw_toggles()
	speak("Alright fam? Sensei's gone East London. Wallahi." if east() else "Sensei is back to proper.", true)
	if cur_screen == "home":
		show_home()
	elif cur_screen == "title":
		show_title()

func _build_overlays() -> void:
	# Christmas: string of lights under the top buttons + snow over everything (drawn in Snow.gd)
	lights = TextureRect.new()
	var lp := "res://assets/xmas/lights.png"
	if ResourceLoader.exists(lp):
		lights.texture = load(lp)
	lights.stretch_mode = TextureRect.STRETCH_TILE
	lights.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	lights.position = Vector2(0, 50); lights.size = Vector2(W, 24)
	lights.scale = Vector2(3, 3)
	lights.size = Vector2(W / 3.0, 8)
	lights.mouse_filter = Control.MOUSE_FILTER_IGNORE
	lights.visible = false
	add_child(lights)
	snow = preload("res://scripts/Snow.gd").new()
	snow.visible = false
	add_child(snow)

func _process(delta: float) -> void:
	if cur_screen in ["battle", "lesson", "mtq", "exam"]:
		study_sec += delta
		if study_sec >= 15.0:
			study_sec -= 15.0
			Game.note("sec", 15)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		escape_screen()

func escape_screen() -> void:
	if help.visible:
		help.close()
		return
	if calc.visible:
		calc.toggle(false)
		return
	if cur_screen == "home":
		show_title()
		return
	show_home()

# ---------------------------------------------------------------- screens
func show_screen(name: String) -> void:
	for k in screens.keys():
		screens[k].visible = (k == name)
	cur_screen = name
	if name != "battle":
		battle.abandon()
	if name != "exam":
		exam.stop_timer()
	apply_festive()

func screen(name: String) -> Control:
	var s: Control = screens[name]
	UI.clear(s)
	return s

# A full-screen column with the standard padding (58 top for the top bar).
func column(s: Control, top := 58, side := 26, bottom := 20, sep := 14, bg: Array = []) -> VBoxContainer:
	if landscape:
		side = maxi(side, 48)
		bottom = mini(bottom, 12)
		sep = mini(sep, 8)
	if bg.size() == 3:
		s.add_child(UI.gradient_bg(bg[0], bg[1], bg[2]))
	var m := MarginContainer.new()
	m.set_anchors_preset(Control.PRESET_FULL_RECT)
	m.add_theme_constant_override("margin_top", top)
	m.add_theme_constant_override("margin_left", side)
	m.add_theme_constant_override("margin_right", side)
	m.add_theme_constant_override("margin_bottom", bottom)
	s.add_child(m)
	var v := UI.vbox(sep)
	m.add_child(v)
	return v

# Menu screen: banner, framed scrolling panel, Home button. Returns the panel's content box.
func menu(title: String, box_name := "BGbox_01B", dark := false) -> VBoxContainer:
	menu_title = title
	var s := screen("menu")
	var v := column(s, 58, 26, 24, 16, [Color("24314f"), Color("283a5a"), Color("2a1e2e")])
	v.add_child(UI.banner(title))
	var pinned := UI.vbox(8)
	pinned.name = "pinned"
	v.add_child(pinned)
	var p := UI.box(box_name, dark, Vector4(46, 52, 46, 48))
	p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var inner := UI.vbox(12)
	var sc := UI.scroll(inner)
	UI.content(p).add_child(sc)
	v.add_child(p)
	v.add_child(UI.button("Home", "05A", show_home))
	show_screen("menu")
	inner.set_meta("dark", dark)
	return inner

func menu_pinned() -> VBoxContainer:
	return screens["menu"].find_child("pinned", true, false)

func text_for(v: Control, s: String, size := 28) -> RichTextLabel:
	var dark: bool = v.get_meta("dark", true)
	return UI.rich(s, size, dark)

# ---------------------------------------------------------------- title (exam picker)
func show_title() -> void:
	var s := screen("title")
	var v := column(s, 58, 26, 24, 14, [Color("141a33"), Color("3b2a52"), Color("2a1e2e")])
	v.alignment = BoxContainer.ALIGNMENT_BEGIN
	v.add_child(UI.banner("ACCA STUDY BUDDY"))
	_update_button(v)
	# held sideways: Zuru and Sensei on the left, the exam list on the right
	var left := v
	var right := v
	if landscape:
		var cols := UI.hbox(24)
		cols.size_flags_vertical = Control.SIZE_EXPAND_FILL
		v.add_child(cols)
		left = UI.vbox(10); left.custom_minimum_size.x = 520
		right = UI.vbox(8); right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cols.add_child(left); cols.add_child(right)
	var hero_row := CenterContainer.new()
	var hero := UI.sprite(zuru_src("normal"), 192, 208)
	hero.add_to_group("zuru")
	hero_row.add_child(hero)
	left.add_child(hero_row)
	var span := 616 if landscape else W   # width the decorations frame Zuru across
	var dy := (-50 if landscape else 0) + ((64 + (8 if landscape else 14)) if update_info else 0)   # below the update button when shown
	if festive():
		var tp := "res://assets/xmas/tree.png"
		var gp := "res://assets/xmas/present.png"
		for pos in [Vector2(60, 200 + dy), Vector2(span - 60 - 112, 200 + dy)]:
			var t := UI.sprite(tp, 112, 168)
			t.position = pos
			s.add_child(t)
		for pos in [Vector2(40, 330 + dy), Vector2(150, 338 + dy), Vector2(span - 46 - 44, 330 + dy)]:
			var g := UI.sprite(gp, 44, 44)
			g.position = pos
			s.add_child(g)
	elif spooky():
		var pp := "res://assets/xmas/pumpkin.png"
		for pos in [Vector2(56, 262 + dy), Vector2(span - 56 - 128, 262 + dy)]:
			var p := UI.sprite(pp, 128, 104)
			p.position = pos
			s.add_child(p)
		var small := UI.sprite(pp, 72, 58)
		small.position = Vector2(180, 318 + dy)
		s.add_child(small)
	var passed := 0
	var today = planner.today()
	var upcoming := []
	for x in ACCA_EXAMS:
		if x.get("passed", false):
			passed += 1
		elif planner.date_of(x) != "":
			var days = planner.days_between(today, planner.date_of(x))
			if days >= 0:
				upcoming.append([days, x])
	upcoming.sort_custom(func(a, b): return a[0] < b[0])
	var greet := ("Merry Christmas, Zuru! The dojo is snowed in - perfect studying weather." if festive() else ("Happy Halloween, Zuru! The dojo is haunted tonight - the monsters are extra spooky." if spooky() else S("welcome_title")))
	greet += " [b]%d of %d[/b] exams conquered." % [passed, ACCA_EXAMS.size()]
	if upcoming.size():
		var u = upcoming[0]
		greet += " Next up: [b]%s %s[/b] (%s)." % [u[1]["code"], ("today!" if u[0] == 0 else "in %d day%s" % [u[0], "" if u[0] == 1 else "s"]), planner.fmt_day(planner.date_of(u[1]))]
	else:
		greet += " Which one are we training for today?"
	var say := UI.box("BGbox_04A", true, Vector4(36, 30, 36, 26))
	UI.content(say).add_child(UI.rich("[b]Sensei Otter:[/b] " + greet, 24, true, true))
	left.add_child(say)
	var list := UI.vbox(8)
	list.add_child(UI.button("Exam dates - set your sitting dates", "03A", planner.show_dates))
	var grp := ""
	for x in ACCA_EXAMS:
		if x["grp"] != grp:
			grp = x["grp"]
			var gl := UI.label(grp, 30, UI.GOLD, true)
			gl.add_theme_font_override("font", UI.title_o_font)
			list.add_child(gl)
		list.add_child(_exam_row(x))
	var sc := UI.scroll(list)
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(sc)
	right.add_child(UI.label("Zuru's dojo - choose an exam to enter" + (" - happy holidays!" if festive() else (" - happy Halloween!" if spooky() else "")), 22, Color("fbe9d0"), true))
	show_screen("title")

func _exam_row(x: Dictionary) -> Control:
	var content_exam: Dictionary = {}
	for e in Content.EXAMS:
		if x.has("content") and e.get("id", "") == x["content"]:
			content_exam = e
	var passed: bool = x.get("passed", false)
	var style := "BGbox_01A" if passed else ("BGbox_03A" if content_exam.size() else "BGbox_05A")
	var p := UI.box(style, true, Vector4(48, 36, 36, 34))
	p.custom_minimum_size.y = 164
	var row := UI.hbox(16)
	var code := Label.new()
	code.text = x["code"]
	code.add_theme_font_size_override("font_size", 26)
	code.add_theme_color_override("font_color", UI.LIGHT)
	code.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	code.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	var cs := StyleBoxFlat.new(); cs.bg_color = UI.RED; cs.set_corner_radius_all(12); cs.content_margin_left = 6; cs.content_margin_right = 6
	var cp := PanelContainer.new(); cp.add_theme_stylebox_override("panel", cs); cp.custom_minimum_size = Vector2(92, 44); cp.add_child(code)
	cp.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(cp)
	var txt := UI.vbox(4)
	txt.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	txt.add_child(UI.label(x["name"], 27, UI.DARK))
	var sub := ""
	if content_exam.size():
		var prev_id := exam_id
		var prev_exam := EXAM
		EXAM = content_exam; exam_id = content_exam["id"]
		var chs: int = content_exam["chapters"].size()
		var done := 0
		for c in content_exam["chapters"]:
			if chapter_done(c):
				done += 1
		sub = "%d chapters · %d / %d stars%s" % [chs, total_stars(), chs * 3, (" · %d done" % done) if done else ""]
		EXAM = prev_exam; exam_id = prev_id
	var dt = planner.date_of(x)
	if dt != "" and not passed:
		var days = planner.days_between(planner.today(), dt)
		sub += ("\n" if sub else "") + "⏱ %s · %s" % [planner.fmt_day(dt), ("in %d day%s" % [days, "" if days == 1 else "s"]) if days > 0 else ("today!" if days == 0 else "sat %d days ago" % (-days))]
	if sub:
		txt.add_child(UI.label(sub, 21, UI.BROWN))
	row.add_child(txt)
	var chip := Label.new()
	chip.text = "✓ PASSED" if passed else ("▶ ENTER" if content_exam.size() else "TO TAKE")
	chip.add_theme_font_size_override("font_size", 22)
	chip.add_theme_color_override("font_color", UI.LIGHT if (passed or content_exam.size()) else UI.DARK)
	var chs2 := StyleBoxFlat.new(); chs2.bg_color = UI.GREEN if passed else (Color("c8414b") if content_exam.size() else Color(UI.DARK, 0.25)); chs2.set_corner_radius_all(14); chs2.content_margin_left = 14; chs2.content_margin_right = 14; chs2.content_margin_top = 8; chs2.content_margin_bottom = 8
	var chp := PanelContainer.new(); chp.add_theme_stylebox_override("panel", chs2); chp.add_child(chip); chp.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	row.add_child(chp)
	UI.content(p).add_child(row)
	var btn := Button.new()
	btn.flat = true
	btn.set_anchors_preset(Control.PRESET_FULL_RECT)
	btn.pressed.connect(func():
		if content_exam.size():
			sfx("page"); select_exam(content_exam["id"])
		elif passed:
			sfx("win")
		else:
			sfx("miss"))
	p.add_child(btn)
	return p

# ---------------------------------------------------------------- home
func show_home() -> void:
	var s := screen("home")
	var v := column(s, 58, 26, 14, 10, [Color("3b2a52"), Color("5a3a6e"), Color("2a1e2e")])
	var right := v
	if landscape:   # held sideways: banner, Zuru and Sensei on the left, the area cards on the right
		var cols := UI.hbox(20)
		cols.size_flags_vertical = Control.SIZE_EXPAND_FILL
		v.add_child(cols)
		var left := UI.vbox(10); left.custom_minimum_size.x = 540
		right = UI.vbox(0); right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cols.add_child(left); cols.add_child(right)
		v = left
	v.add_child(UI.banner("ACCA STUDY BUDDY"))
	_update_button(v)
	var hero: BoxContainer = UI.vbox(6) if landscape else UI.hbox(12)   # sideways: Zuru above Sensei, not beside
	var z := UI.sprite(zuru_src("normal"), 108 if landscape else 144, 117 if landscape else 156)
	z.add_to_group("zuru")
	z.size_flags_vertical = Control.SIZE_SHRINK_END
	if landscape:
		z.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	hero.add_child(z)
	var speech := UI.box("BGbox_04A", true, Vector4(36, 30, 36, 26))
	speech.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sv := UI.content(speech)
	var toprow := UI.hbox(8)
	toprow.add_child(UI.button("📅 Study plan", "03A", planner.show_plan, true, 24))
	toprow.add_child(UI.button("📓 Notebook", "06A", planner.show_notebook, true, 24))
	sv.add_child(toprow)
	var nm := by_keys(Game.mistakes.keys()).size()
	var say := UI.rich("[b]Sensei Otter:[/b] " + planner.plan_summary() + ((" %d wound%s to heal at the Shrine." % [nm, "" if nm == 1 else "s"]) if nm else ""), 24)
	say.name = "homeSay"
	sv.add_child(say)
	var lvl := UI.hbox(10)
	lvl.add_child(UI.title_label("Lv %d" % Game.level(), 26))
	var xb := UI.bar(Game.xp_in_level() / 100.0, 200, 26)
	xb.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	lvl.add_child(xb)
	lvl.add_child(UI.button("Reset", "04A", _ask_reset, false, 22))
	sv.add_child(lvl)
	var saverow := UI.hbox(8)
	saverow.add_child(UI.button("Backup", "05A", _ask_backup, true, 22))
	saverow.add_child(UI.button("Restore", "02A", _ask_restore, true, 22))
	sv.add_child(saverow)
	hero.add_child(speech)
	v.add_child(hero)
	var grid := GridContainer.new()
	grid.columns = 2
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid.name = "cards"
	for a in AREAS:
		grid.add_child(_card(a, nm))
	# the cards scroll, so the bottom row is never cut off when Sensei has a lot to say
	var gs := UI.scroll(grid)
	right.add_child(gs)
	show_screen("home")

func _card(a: Dictionary, nm: int) -> Control:
	var p := UI.box(a["box"], a["dark"], Vector4(38, 36, 38, 32))
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var dark: bool = a["dark"]
	var col := UI.LIGHT if not dark else UI.DARK
	var cv := UI.content(p)
	cv.alignment = BoxContainer.ALIGNMENT_BEGIN
	var ic := CenterContainer.new(); ic.add_child(UI.icon(a["icon"], 30)); cv.add_child(ic)
	var t := UI.label(a["name"], 26, col, true)
	t.add_theme_font_size_override("font_size", 26)
	cv.add_child(t)
	cv.add_child(UI.label(a["sub"], 24, col, true))
	var stat := ""
	match a["id"]:
		"book": stat = "%d / %d stars" % [total_stars(), EXAM["chapters"].size() * 3]
		"boss":
			var gb := Game.best(exam_id + "/gauntlet"); var gl := Game.last_run(exam_id + "/gauntlet")
			stat = ("Last run %d · Best %d bosses" % [gl, gb]) if (gb or gl) else "Not fought yet"
		"bank": stat = "%d questions" % questions().size()
		"heal": stat = ("%d to review" % nm) if nm else "All healed!"
		"mock":
			var fb := [Game.best(exam_id + "/full/1"), Game.best(exam_id + "/full/2"), Game.best(exam_id + "/full/3")]
			var b: int = fb.max(); var ps := fb.filter(func(x): return x >= 50).size()
			stat = ("Full mocks: %d / 3 passed - best %d%%" % [ps, b]) if b else "3 full mocks - pass mark 50%"
		"rec":
			var tried := 0
			for c in EXAM["chapters"]:
				if Game.accuracy("%s/%d" % [exam_id, int(c["id"])]) >= 0:
					tried += 1
			stat = "%d/%d topics tried\nSyllabus map" % [tried, EXAM["chapters"].size()]
	var st := UI.label(stat, 24, col, true)
	st.size_flags_vertical = Control.SIZE_EXPAND_FILL
	st.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	cv.add_child(st)
	var btn := Button.new(); btn.flat = true; btn.set_anchors_preset(Control.PRESET_FULL_RECT)
	btn.pressed.connect(func():
		sfx("tap")
		match a["id"]:
			"book": book.show_book()
			"boss": battle.show_boss_lobby()
			"bank": show_bank()
			"heal":
				if nm: battle.start_mistakes()
			"mock": exam.show_mock()
			"rec": show_records()
	)
	p.add_child(btn)
	return p

func home_say(text: String) -> void:
	var r: RichTextLabel = screens["home"].find_child("homeSay", true, false)
	if r:
		UI.set_rich(r, "[b]Sensei Otter:[/b] " + text, 24)

func _ask_reset() -> void:
	var cards: GridContainer = screens["home"].find_child("cards", true, false)
	if cards == null:
		return
	home_say("Reset ALL progress - stars, XP, lessons, wounds, mocks and the Notebook? (The study plan is kept.)")
	UI.clear(cards)
	var p := UI.box("BGbox_03A", true)
	var row := UI.hbox(8)
	row.add_child(UI.button("Yes, reset", "06A", func(): Game.reset_all(); show_home(); home_say(S("reset_done"))))
	row.add_child(UI.button("Keep it", "05A", show_home))
	UI.content(p).add_child(row)
	cards.columns = 1
	cards.add_child(p)

func _ask_backup() -> void:
	var cards: GridContainer = screens["home"].find_child("cards", true, false)
	if cards == null:
		return
	var code := Game.backup_code()
	home_say("Here is your progress code. Copy it and use Restore on your phone or in the browser version.")
	UI.clear(cards)
	cards.columns = 1
	var p := UI.box("BGbox_03A", true)
	var te := TextEdit.new()
	te.text = code
	te.editable = false
	te.custom_minimum_size.y = 220
	te.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	te.add_theme_font_size_override("font_size", 16)
	UI.content(p).add_child(te)
	var row := UI.hbox(8)
	row.add_child(UI.button("Copy code", "06A", func(): DisplayServer.clipboard_set(code); home_say("Copied! Paste it into Restore on your other device.")))
	row.add_child(UI.button("Done", "05A", show_home))
	UI.content(p).add_child(row)
	cards.add_child(p)

func _ask_restore() -> void:
	var cards: GridContainer = screens["home"].find_child("cards", true, false)
	if cards == null:
		return
	home_say("Paste your progress code below, then tap Load. This replaces the progress on this device.")
	UI.clear(cards)
	cards.columns = 1
	var p := UI.box("BGbox_03A", true)
	var te := TextEdit.new()
	te.placeholder_text = "Paste here..."
	te.custom_minimum_size.y = 220
	te.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	te.add_theme_font_size_override("font_size", 16)
	UI.content(p).add_child(te)
	var row := UI.hbox(8)
	row.add_child(UI.button("Paste", "03A", func(): te.text = DisplayServer.clipboard_get()))
	row.add_child(UI.button("Load", "06A", func():
		if Game.restore_code(te.text):
			show_home(); home_say("Progress restored, Zuru!")
		else:
			home_say("That code does not look right - check it was copied in full, then try again.")))
	row.add_child(UI.button("Cancel", "05A", show_home))
	UI.content(p).add_child(row)
	cards.add_child(p)

# ---------------------------------------------------------------- training grounds, records, syllabus
var bank_kind := ""
func show_bank() -> void:
	var v := menu("TRAINING GROUNDS", "BGbox_02B", false)
	var pin := menu_pinned()
	var row := UI.hbox(10)
	for pair in [["", "All"], ["choice", "Tap"], ["input", "Type-in"]]:
		var k: String = pair[0]
		row.add_child(UI.button(("> %s <" % pair[1]) if bank_kind == k else pair[1], "03A" if bank_kind == k else "04A", func(): bank_kind = k; show_bank()))
	pin.add_child(row)
	v.add_child(text_for(v, "Drill until it sticks. Pick a type above, then a topic."))
	v.add_child(UI.button("All topics (%d)" % questions(-1, bank_kind).size(), "06A", func(): battle.start_bank(-1)))
	var rot := ["02A", "05A", "03A", "06A", "01A", "04A"]
	var i := 0
	for c in EXAM["chapters"]:
		var cid := int(c["id"])
		var n := questions(cid, bank_kind).size()
		if n == 0:
			continue
		var acc := Game.accuracy("%s/%d" % [exam_id, cid])
		v.add_child(UI.button("Ch %d  %s  (%d)%s" % [cid, c["title"], n, ("  - %d%%" % acc) if acc >= 0 else ""], rot[i % rot.size()], func(): battle.start_bank(cid), true, 24))
		i += 1

func show_records() -> void:
	var v := menu("HALL OF RECORDS", "BGbox_05A", true)
	if SYL.size():
		var t := 0; var g := 0
		for o in SYL:
			var st := syl_status(o)
			if st == "taught": t += 1
			elif st == "gap": g += 1
		v.add_child(UI.button("Syllabus map: %d of %d outcomes taught, %d gaps" % [t, SYL.size(), g], "03A", func(): show_syllabus(""), true, 24))
	var rows := []
	for c in EXAM["chapters"]:
		rows.append({"c": c, "acc": Game.accuracy("%s/%d" % [exam_id, int(c["id"])])})
	rows.sort_custom(func(a, b): return (a["acc"] if a["acc"] >= 0 else 1000) < (b["acc"] if b["acc"] >= 0 else 1000))
	var tried := rows.filter(func(r): return r["acc"] >= 0)
	if tried.is_empty():
		v.add_child(text_for(v, "No answers yet. Every question you answer, in any area, is recorded here."))
	else:
		var w = tried[0]
		v.add_child(text_for(v, "Weakest topic: [b]Ch %d %s[/b] at %d%%." % [int(w["c"]["id"]), w["c"]["title"], w["acc"]]))
		v.add_child(UI.button("Drill my weakest topic", "06A", func(): bank_kind = ""; battle.start_bank(int(w["c"]["id"]))))
	for r in rows:
		v.add_child(text_for(v, "Ch %d %s%s" % [int(r["c"]["id"]), r["c"]["title"], (" - %d%%" % r["acc"]) if r["acc"] >= 0 else ""], 24))
		var b := UI.bar(0.0 if r["acc"] < 0 else r["acc"] / 100.0, 600, 26)
		v.add_child(b)

func syl_status(o: Dictionary) -> String:
	var cover: Array = o.get("cover", [])
	if cover.is_empty():
		return "gap"
	for c in cover:
		if str(c).contains("/L"):
			return "taught"
	return "quiz"

func show_syllabus(open_area: String) -> void:
	var v := menu("SYLLABUS MAP", "BGbox_03A", true)
	var counts := {"taught": 0, "quiz": 0, "gap": 0}
	for o in SYL:
		counts[syl_status(o)] += 1
	v.add_child(text_for(v, "[b]%d taught[/b] in lessons, %d quiz only, %d gaps - of %d ACCA FA outcomes. Tap an area." % [counts["taught"], counts["quiz"], counts["gap"], SYL.size()], 24))
	for a in EXAM.get("areas", []):
		var code: String = a["code"]
		var os := SYL.filter(func(o): return str(o["code"]).begins_with(code) and str(o["code"]).length() >= 2 and str(o["code"]).substr(1, 1).is_valid_int())
		var gaps := os.filter(func(o): return syl_status(o) == "gap").size()
		var taught := os.filter(func(o): return syl_status(o) == "taught").size()
		var head := UI.button("%s  %s  -  %d taught, %d gap%s (%d)" % [code, a["title"], taught, gaps, "" if gaps == 1 else "s", os.size()], "06A" if gaps == os.size() else ("03A" if gaps else "05A"), func(): show_syllabus("" if open_area == code else code), true, 22)
		head.alignment = HORIZONTAL_ALIGNMENT_LEFT
		v.add_child(head)
		if open_area != code:
			continue
		for o in os:
			var st := syl_status(o)
			var txt := "[b]%s[/b] %s [%s] %s" % [o["code"], {"taught": "TAUGHT", "quiz": "QUIZ", "gap": "GAP"}[st], o.get("k", ""), o.get("t", "")]
			if o.get("cover", []).size():
				txt += "\nCovered by: " + ", ".join(o["cover"].map(func(c): return str(c)))
			if o.get("note", ""):
				txt += "\nStill to do: " + str(o["note"])
			v.add_child(text_for(v, txt, 22))
	v.add_child(UI.button("Back to Hall of Records", "05A", show_records))

# ---------------------------------------------------------------- content helpers (mirror the HTML)
func get_ch(id: int) -> Dictionary:
	for c in EXAM["chapters"]:
		if int(c["id"]) == id:
			return c
	return {}

func is_q(b: Dictionary) -> bool:
	return b.get("type", "") in ["choice", "input", "multi", "picklist", "sort"]

func tag(c: Dictionary, i: int) -> Dictionary:
	var q: Dictionary = c["beats"][i].duplicate()
	q["_key"] = "%s/%d/%d" % [exam_id, int(c["id"]), i]
	q["_ch"] = "%s/%d" % [exam_id, int(c["id"])]
	q["_topic"] = c["title"]
	return q

func tag_lesson(c: Dictionary, l: Dictionary, i: int) -> Dictionary:
	var q: Dictionary = l["practice"][i].duplicate()
	q["_key"] = "%s/%d/%s/%d" % [exam_id, int(c["id"]), l["id"], i]
	q["_ch"] = "%s/%d" % [exam_id, int(c["id"])]
	q["_topic"] = "%s: %s" % [c["title"], l["title"]]
	return q

func questions(ch_id := -1, kind := "") -> Array:
	var out := []
	for c in EXAM["chapters"]:
		if ch_id != -1 and int(c["id"]) != ch_id:
			continue
		var beats: Array = c.get("beats", [])
		for i in beats.size():
			if is_q(beats[i]) and (kind == "" or beats[i]["type"] == kind):
				out.append(tag(c, i))
		for l in c.get("lessons", []):
			var pr: Array = l.get("practice", [])
			for i in pr.size():
				if kind == "" or pr[i]["type"] == kind:
					out.append(tag_lesson(c, l, i))
	return out

# A Section B blank she got wrong, replayed in the Shrine as a number-entry question.
func tag_mtq(c: Dictionary, ti: int, key: String):
	var m = c.get("mtq", null)
	if m == null or ti >= m["tasks"].size():
		return null
	var t: Dictionary = m["tasks"][ti]
	if not t["blanks"].has(key):
		return null
	var bl: Dictionary = t["blanks"][key]
	var label := key
	for r in t["rows"]:
		if r["c"].has("#" + key):
			label = str(r["c"][0])
	var scen := ""
	for p in m["scenario"]:
		if p.has("text"):
			scen += str(p["text"]) + "\n"
		if p.has("table"):
			for r in p["table"]["rows"]:
				scen += "  ".join(r["c"].filter(func(x): return str(x) != "" and not str(x).begins_with("#")).map(func(x): return str(x))) + "\n"
	var given := ""
	for r in t["rows"]:
		if not r["c"].any(func(x): return str(x).begins_with("#")):
			given += "  ".join(r["c"].filter(func(x): return str(x) != "").map(func(x): return str(x))) + "\n"
	return {"type": "input", "q": "[b]%s - %s[/b]\n%s%s\nWhat is the figure for [b]%s[/b]?" % [m["title"], t["title"], scen, ("\n[b]Figures so far:[/b]\n" + given) if given else "", label],
		"accept": bl["accept"], "display_answer": bl.get("show", ""), "ex": bl.get("ex", ""), "_key": "%s/%d/mtq/%d/%s" % [exam_id, int(c["id"]), ti, key], "_ch": "%s/%d" % [exam_id, int(c["id"])], "_topic": "%s: Section B" % c["title"]}

func by_keys(keys: Array) -> Array:
	var out := []
	for k in keys:
		var p: Array = str(k).split("/")
		if p.size() < 3 or p[0] != exam_id:
			continue
		var c := get_ch(int(p[1]))
		if c.is_empty():
			continue
		if p.size() == 5 and p[2] == "mtq":
			var q = tag_mtq(c, int(p[3]), p[4])
			if q != null:
				out.append(q)
		elif p.size() == 4:
			for l in c.get("lessons", []):
				if l["id"] == p[2] and int(p[3]) < l["practice"].size():
					out.append(tag_lesson(c, l, int(p[3])))
		elif p.size() == 3:
			var beats: Array = c.get("beats", [])
			if int(p[2]) < beats.size() and is_q(beats[int(p[2])]):
				out.append(tag(c, int(p[2])))
	return out

func shuffled(a: Array, rng: RandomNumberGenerator = null) -> Array:
	var out := a.duplicate()
	if rng == null:
		out.shuffle()
		return out
	for i in range(out.size() - 1, 0, -1):
		var j := rng.randi_range(0, i)
		var tmp = out[i]; out[i] = out[j]; out[j] = tmp
	return out

# Fixed papers: the same seed gives the same questions every time (numbered mocks); no seed = random.
func mixed_paper(n: int, seed_no := -1) -> Array:
	var rng: RandomNumberGenerator = null
	if seed_no >= 0:
		rng = RandomNumberGenerator.new()
		rng.seed = seed_no * 7919 + 17
	var by_ch := []
	for c in EXAM["chapters"]:
		var qs := questions(int(c["id"]))
		if qs.size():
			by_ch.append(shuffled(qs, rng))
	by_ch = shuffled(by_ch, rng)
	var out := []
	var r := 0
	while out.size() < n:
		var added := false
		for qs in by_ch:
			if r < qs.size() and out.size() < n:
				out.append(qs[r]); added = true
		if not added:
			break
		r += 1
	return shuffled(out, rng)

func stars(pct: int) -> int:
	return 3 if pct >= 90 else (2 if pct >= 70 else (1 if pct >= 50 else 0))

func total_stars() -> int:
	var t := 0
	for c in EXAM["chapters"]:
		t += stars(Game.best("%s/%d" % [exam_id, int(c["id"])]))
	return t

func chapter_done(c: Dictionary) -> bool:
	for l in c.get("lessons", []):
		if not Game.lesson_passed("%s/%d/%s" % [exam_id, int(c["id"]), l["id"]]):
			return false
	if c.has("mtq") and Game.best("%s/%d/mtq" % [exam_id, int(c["id"])]) == 0:
		return false
	return true

func chapter_minutes(c: Dictionary) -> int:
	var s := 0
	for l in c.get("lessons", []):
		s += l["learn"].size() * 45 + (60 + l["example"].get("steps", []).size() * 30 if l.has("example") else 0) + l["practice"].size() * 70
		if l.has("apply"):
			s += l["apply"]["pages"].size() * 40
	s += (15 if c.has("lessons") else c.get("beats", []).filter(is_q).size()) * 60 + (25 * 60 if c.has("mtq") else 0)
	return max(5, int(round(s / 300.0)) * 5)

func correct_text(b: Dictionary) -> String:
	match b["type"]:
		"choice": return str(b["opts"][int(b["a"])])
		"multi": return " + ".join(b["a"].map(func(i): return str(b["opts"][int(i)])))
		"picklist":
			var parts := []
			for i in b["a"].size():
				parts.append(str(b["lists"][i][int(b["a"][i])]))
			return " / ".join(parts)
		"sort": return ", ".join(b["items"].map(func(it): return "%s: %s" % [it[0], b["buckets"][int(it[1])]]))
	return str(b.get("display_answer", ""))

func norm(v) -> String:
	var s := str(v).strip_edges().to_lower()
	for ch in ["$", "£", ",", " ", "(", ")", "-"]:
		s = s.replace(ch, "")
	return s

func q_text(b: Dictionary) -> String:
	return "Complete the sentence below using the drop-down lists." if b["type"] == "picklist" else str(b["q"])

# ---------------------------------------------------------------- voice, sound, festive
func _init_tts() -> void:
	tts_voice = ""
	if DisplayServer.has_feature(DisplayServer.FEATURE_TEXT_TO_SPEECH):
		var vs := DisplayServer.tts_get_voices_for_language("en")
		if vs.size():
			tts_voice = vs[0]
			for vid in vs:
				var lower := str(vid).to_lower()
				if lower.contains("gb") or lower.contains("en-gb") or lower.contains("uk"):
					tts_voice = vid
					break

func speak(text: String, force := false) -> void:
	if not (Game.settings.get("voice", false) or force):
		return
	if tts_voice == "":
		return
	var t := UI.plain(text).strip_edges()
	if t == "":
		return
	DisplayServer.tts_stop()
	DisplayServer.tts_speak(t, tts_voice)

func toggle_voice() -> void:
	Game.settings["voice"] = not Game.settings.get("voice", false)
	Game.save_settings()
	draw_toggles()
	if Game.settings["voice"]:
		if tts_voice == "":
			voice_btn.text = "NO VOICE"
		else:
			speak("Voice on.", true)
	else:
		DisplayServer.tts_stop()

func _load_sfx() -> void:
	sfx_player = AudioStreamPlayer.new()
	sfx_player.max_polyphony = 4
	add_child(sfx_player)
	for k in ["hit", "miss", "win", "page", "bells", "tap"]:
		var p := "res://assets/sfx/%s.wav" % k
		if ResourceLoader.exists(p):
			sfx_streams[k] = load(p)

func sfx(kind: String) -> void:
	if not Game.settings.get("sfx", true):
		return
	if sfx_streams.has(kind):
		sfx_player.stream = sfx_streams[kind]
		sfx_player.play()
	if kind == "win" and festive() and sfx_streams.has("bells"):
		get_tree().create_timer(0.45).timeout.connect(func(): sfx("bells"))

func toggle_sfx() -> void:
	Game.settings["sfx"] = not Game.settings.get("sfx", true)
	Game.save_settings()
	draw_toggles()
	if Game.settings["sfx"]:
		sfx("hit")

# Themes: only when she picks one with the THEME button - "off" / "xmas" / "halloween". Saved with the settings.
func theme() -> String:
	var t := str(Game.settings.get("theme", "off"))
	return t if t in ["xmas", "halloween"] else ""

func festive() -> bool:
	return theme() == "xmas"

func spooky() -> bool:
	return theme() == "halloween"

func toggle_theme() -> void:
	var t := theme()
	Game.settings["theme"] = "halloween" if t == "xmas" else ("off" if t == "halloween" else "xmas")
	Game.save_settings()
	draw_toggles()
	apply_festive()
	if cur_screen == "title":
		show_title()

func zuru_src(mood: String) -> String:
	var base := "res://assets/characters/samurai"
	var suffix = {"normal": "", "happy": "_happy", "sad": "_sad"}[mood]
	return base + ("_x" if festive() else ("_h" if spooky() else "")) + suffix + ".png"

func apply_festive() -> void:
	var t := theme()
	var lp := "res://assets/xmas/%s.png" % ("lights" if t == "xmas" else "bunting")
	if ResourceLoader.exists(lp):
		lights.texture = load(lp)
	lights.visible = t != ""
	snow.visible = t != ""
	snow.mode = t
	snow.set_process(t != "")
	for im in get_tree().get_nodes_in_group("zuru"):
		if is_instance_valid(im) and im is TextureRect and ResourceLoader.exists(zuru_src("normal")):
			im.texture = load(zuru_src("normal"))

# ---------------------------------------------------------------- Zuru's face on any sprite marked zuru
func mood(tr: TextureRect, m: String, secs := 2.6) -> void:
	if tr == null:
		return
	var p := zuru_src(m)
	if ResourceLoader.exists(p):
		tr.texture = load(p)
	if m != "normal":
		var t := get_tree().create_timer(secs)
		t.timeout.connect(func():
			if is_instance_valid(tr):
				var n := zuru_src("normal")
				if ResourceLoader.exists(n):
					tr.texture = load(n))
