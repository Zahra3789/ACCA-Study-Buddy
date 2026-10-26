extends Control
# Samurai Ledger (formerly ACCA Study Buddy) - Godot 4 port of the HTML prototype (preview/index.html).
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
	{"id": "review", "name": "Daily Review", "sub": "10 minutes a day keeps it stuck", "box": "BGbox_02B", "icon": "Icon_15", "dark": false},
	{"id": "scrolls", "name": "Sensei's Scrolls", "sub": "Formulas, formats & rules", "box": "BGbox_03A", "icon": "Icon_16", "dark": true},
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
var sfx_btn: Button
var snow: Node2D
var deco: Node2D
var lights: TextureRect
var sfx_player: AudioStreamPlayer
var sfx_streams: Dictionary = {}
var study_sec := 0.0

var book: Node
var battle: Node
var mtq: Node
var exam: Node
var planner: Node
var calc: Node
var scrolls: Node
var help: Node
var menu_title := ""   # which menu() screen is showing, so Help can explain it

# ---------------------------------------------------------------- setup
func _ready() -> void:
	Engine.set_meta("sl_game_ran", true)   # Boot reads this to know an update is being applied mid-session
	set_anchors_preset(Control.PRESET_FULL_RECT)
	get_tree().quit_on_go_back = false   # Android back / edge swipe steps back instead of closing (_on_back)
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
	scrolls = preload("res://scripts/Scrolls.gd").new()
	calc = preload("res://scripts/Calc.gd").new()
	for m in [book, battle, mtq, exam, planner, scrolls]:
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
	bank_kind = str(Game.settings.get("bank_kind", ""))
	if Game.settings.get("entered", false):   # been in before: straight to that exam's home (ESC goes to the list)
		show_home()
	else:
		show_title()
	help.guide_on_start()   # the walk-through, unless it's been switched off

# ---------------------------------------------------------------- updates
# Content updates arrive by themselves: Boot.gd fetches them at start-up, and while the app is open the live
# updater below fetches and applies them (no buttons, nothing to download by hand).
const BuildInfo = preload("res://scripts/build_info.gd")

# The moving banner: Zuru journeying on through day and night (Journey.gd), h px tall and full width.
func journey(h: int) -> Control:
	var j: Control = preload("res://scripts/Journey.gd").new()
	j.custom_minimum_size = Vector2(0, h)
	j.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return j

# The banner edge to edge across the top of screen s (under the top buttons), before the page column is added
# so it sits behind it. Returns its height: taller on tall phones, slimmer when held sideways.
func journey_top(s: Control) -> int:
	var h := 230 if landscape else int(clampf(H * 0.26, 300.0, 440.0))
	var j := journey(h)
	j.set_anchors_preset(Control.PRESET_TOP_WIDE)
	j.offset_bottom = h
	s.add_child(j)
	return h

# "App v2.5 · update 3": the APK's version, then the content update it is running - worked out like
# Boot.installed_version(), because Boot cached the APK's build_info.gd before any pack was loaded.
func version_text() -> String:
	var n := BuildInfo.BUILD
	if FileAccess.file_exists("user://update/content.pck") and FileAccess.file_exists("user://update/version.txt"):
		n = maxi(n, int(FileAccess.get_file_as_string("user://update/version.txt").strip_edges()))
	return "App v%s · update %d" % [ProjectSettings.get_setting("application/config/version", "?"), n]

# The phone decides: wider than tall -> landscape layouts on a 1280 x 720 base, otherwise portrait on 720 x 1280.
# The stretch aspect is "expand", so the base only sets the scale: the screen's extra length or width is
# added on (a Flip 7 upright is about 720 x 1680, an iPhone about 720 x 1560), and W x H is the real size.
func _apply_orientation(rebuild: bool) -> void:
	var win := DisplayServer.window_get_size()
	if win.x <= 0 or win.y <= 0:
		return
	var wide := win.x > win.y
	var base := Vector2i(1280, 720) if wide else Vector2i(720, 1280)
	var k := minf(float(win.x) / base.x, float(win.y) / base.y)
	var w := int(round(win.x / k))
	var h := int(round(win.y / k))
	if rebuild and wide == landscape and w == W and h == H:
		return
	landscape = wide
	W = w
	H = h
	UI.compact = wide
	get_tree().root.content_scale_size = base
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
	var switching := id != exam_id
	_select_exam_data(id)
	Game.remember("entered", true)   # next launch opens straight on this exam's home
	Game.save_game()
	if switching:   # a different exam starts at its first chapter; the same one keeps your place
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
	# greetings: plain English when proper; the Somali ones (Salaam / Asalaamu calaykum, Iska warran, Sidee tahay, Soo dhowow) only with E-LDN on
	"welcome_title": {"proper": ["Welcome to the dojo, Zuru.", "Welcome back to the dojo, Zuru.", "Good to see you, Zuru. Welcome to the dojo.", "Zuru! The dojo has been waiting for you."],
		"east": ["Salaam, Zuru! Wallahi, you're back. Soo dhowow - wipe your feet, walaal.", "Asalaamu calaykum, walaal. Sidee tahay? The dojo missed you, innit.", "Iska warran, Zuru! Back at the dojo, say less.", "Salaam, walaal. Soo dhowow, Zuru - kettle's on, shaah's brewing."]},
	"welcome_home": {"proper": ["Welcome back, Zuru!", "Good to see you, Zuru - ready to study?", "Hello again, Zuru. Let's get to work.", "Welcome back, Zuru. One chapter at a time."],
		"east": ["Haye, Zuru! Back again, innit. Say less - let's go.", "Salaam, walaal! Sidee tahay? Let's get these marks.", "Iska warran, Zuru! Ready? Say less.", "Asalaamu calaykum, walaal. Sidee tahay? Let's study."]},
	"appear": {"proper": "A wild [b]{foe}[/b] appeared! Topic: {topic}.", "east": "Oi oi - [b]{foe}[/b] has rolled up wanting beef about {topic}. Allow it? Nah. Clap it."},
	"correct": {"proper": ["[b]Correct![/b] Zuru used [b]{move}[/b]! It's super effective!"],
		"east": ["[b]Wallahi, Ilaahay loves you[/b] and He is PROUD of you, walaal. {move}! Even hooyo smiled.", "[b]MASHALLAH![/b] {move}! Somebody ring Ayeeyo - the family finally has an accountant.", "[b]You ATE that.[/b] {move}! No crumbs. Not even canjeero crumbs.", "[b]Subhanallah, who taught you?![/b] {move}! The examiner is crying in the car park.", "[b]Haye haye HAYE![/b] {move}! Aabo is telling the whole masjid about you after Jummah.", "[b]On my mum, that was cold.[/b] {move}! The monster has asked to be sent on dhaqan celis.", "[b]Big brain behaviour.[/b] {move}! Your cousins who did medicine are shaking, walaal.", "[b]Alhamdulillah - not a nacas after all.[/b] {move}! I genuinely had my doubts.", "[b]You are gassed and you are allowed to be.[/b] {move}! Debit the monster, credit your ego.", "[b]WALLAHI that is mad.[/b] {move}! Even the wedding-hall aunties went quiet.", "[b]Peng answer, no cap.[/b] {move}! Get the xalwo out, we are celebrating.", "[b]Hambalyo, superstar![/b] {move}! Book the wedding hall, we are throwing you a party.", "[b]Bro thinks she is already qualified.[/b] {move}! ...and honestly? Allow it. You might be.", "[b]That was so clean the monster's mum felt it.[/b] {move}! Send it to the family group chat."]},
	"wrong": {"proper": ["[b]Wrong.[/b] {foe} blocked it and struck back! The answer was [b]{ans}[/b]."],
		"east": ["[b]Ceeb![/b] The ceeb, wallahi. {foe} just violated you. It was [b]{ans}[/b].", "[b]Waryaa, nacas![/b] What was THAT? It was [b]{ans}[/b]. Hooyo is reaching for the dacas.", "[b]Astaghfirullah.[/b] I am making dua for you, genuinely. It was [b]{ans}[/b].", "[b]Nah, you are moving mad.[/b] {foe} is laughing at you in Somali. It was [b]{ans}[/b].", "[b]That is it - dhaqan celis.[/b] Pack your bags, you are going back home. It was [b]{ans}[/b].", "[b]Bruv. BRUV.[/b] Ayeeyo's goat knows this one. It was [b]{ans}[/b].", "[b]That is long, walaal.[/b] Ayeeyo felt that all the way from back home. It was [b]{ans}[/b].", "[b]Who raised you?[/b] Do not answer that, hooyo is listening. It was [b]{ans}[/b].", "[b]Ukun behaviour.[/b] Even {foe} feels bad for you now. It was [b]{ans}[/b].", "[b]You fumbled that worse than the Wi-Fi back home.[/b] It was [b]{ans}[/b].", "[b]Allow it, that answer is on bail.[/b] It was [b]{ans}[/b]. Come back with your chest.", "[b]The aunties will hear about this at the next wedding.[/b] It was [b]{ans}[/b].", "[b]Bare violation.[/b] {foe} cooked you like baasto on a Friday. It was [b]{ans}[/b].", "[b]Peak, walaal. Peak.[/b] Your teacher just felt a disturbance. It was [b]{ans}[/b]."]},
	"won": {"proper": "{foe} fainted! You landed [b]{n} / {total}[/b] hits ([b]{pct}%[/b]).", "east": "Hambalyo! {foe}'s gone home crying to its hooyo. [b]{n} / {total}[/b] hits ([b]{pct}%[/b])."},
	"lost": {"proper": "{foe} is still standing... [b]{n} / {total}[/b] hits ([b]{pct}%[/b]). Aim for 70% to defeat it.", "east": "{foe}'s still standing - wallahi, the cheek. [b]{n} / {total}[/b] hits ([b]{pct}%[/b]). 70% or it's back to the shoebox, fam."},
	"session_done": {"proper": "Session complete: [b]{n} / {total}[/b] right ([b]{pct}%[/b]).", "east": "Done, innit: [b]{n} / {total}[/b] right ([b]{pct}%[/b]). The dummy's seen worse. Barely."},
	"lesson_pass": {"proper": "[b]Lesson passed![/b] ", "east": "[b]Hambalyo - lesson done, you absolute don.[/b] "},
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
	"lesson_open": {"proper": ["Let's take it from the top."], "east": ["Right, listen up, fam. From the top.", "Wallahi, this one matters - eyes open.", "Say less, let's get into it.", "Haye walaal - from the top."]},
	"lesson_page": {"proper": ["", "", "Keep going."], "east": ["Still with me? Good.", "Keep going - you're doing bits.", "This bit comes up in the exam, styll.", "", "Allow the phone, this is the important part."]},
	"lesson_apply": {"proper": ["Now see it at the lemonade stand."], "east": ["Now watch Zuru do it with lemons, innit.", "Lemonade stand time. Real life, fam.", "Same thing, but with yuzu. You get me."]},
	"lesson_example": {"proper": ["Watch the numbers build up step by step."], "east": ["Numbers time. Follow the steps - no skipping.", "Watch this. Step by step, no long ting."]},
	"lesson_turn": {"proper": ["Your turn."], "east": ["Your turn, fam. Don't flop it.", "Right - prove it. Wallahi I believe in you. Mostly.", "Go on then, walaal. Make the monster regret turning up."]},
	"chapter_pick": {"proper": "{monster} guards this chapter. Pick a lesson.", "east": "{monster}'s guarding this one. Pick a lesson and let's clap it."},
	"mtq_intro": {"proper": "15 marks, part marks for every box. Take your time.", "east": "Section B, fam. 15 marks, part marks for every box. No pressure. Bit of pressure."},
	# battle banter in speech bubbles (Battle._quip): Zuru after a hit, the monster hurt, taunting, and begging when it's down
	"quip_win": {"proper": ["Too easy!", "Balanced, as all things should be.", "Debit: you. Credit: the floor.", "Next!", "Read the standard, monster.", "That one's going in my notebook.", "Learn your accruals!"],
		"east": ["Light work, wallahi.", "Sit DOWN, walaal.", "Debit you, credit the floor, innit.", "You're not ready, sxb.", "Mashallah to ME, honestly.", "Bring your cousin next time.", "Easy. Hooyo could do that one.", "Haye! Who's next?"]},
	"quip_hurt": {"proper": ["Ouch! My margins!", "Not the depreciation!", "That really accrued!", "My reserves!"],
		"east": ["Ay! HOOYOOO!", "Wallahi that hurt!", "Ow, ow, OW, walaal!", "I'm telling my aabo!", "Waa maxay?! That's not fair!"]},
	"quip_taunt": {"proper": ["Is that all?", "Your trial balance doesn't balance!", "Wrong side of the ledger!", "Ha! Back to the textbook!", "I've seen better from an intern.", "Suspense account for you!"],
		"east": ["Ceeb! Your hooyo saw that.", "Nacas! Who taught you, YouTube?", "That was embarrassing, wallahi.", "Allow it, you're getting cooked.", "Even my ayeeyo knows that one!", "Ha! Back to dugsi with you!", "Ukun! Sit down.", "Ash and Bri argue better than you answer, walaal."]},
	# Boss 1 in East London mode is "Ash Trevino Vs Bri (Round 47)" - only that fight uses these (Battle._q)
	"ab_win": {"proper": ["Round 47 to me."], "east": ["Round 47 to ME, wallahi. Ring Santos.", "Get the menudo on, you're COOKED.", "Knocked out quicker than Santos at the boxing, sxb.",
			"Sit down and eat your brisket, walaal.", "That's going on Bri's live, mashallah.", "Ask Santos, he saw that one!"]},
	"ab_hurt": {"proper": ["Santos!"], "east": ["SANTOS! Grab the brisket, we're leaving!", "Bri, stop going live on my pain!", "Not in front of the menudo, wallahi!",
			"Worse than Round 46, HOOYOOO!", "Santos, whose side are you ON?!", "Ash, you burnt the brisket AND this?!"]},
	"ab_taunt": {"proper": ["Ask Santos."], "east": ["Ask Santos, he knows it smells well!", "Drier than Santos' brisket, ceeb!", "Even Santos picks a side faster than that, nacas.",
			"Go stir the menudo, ukun, you're not ready.", "The beef's fake but that answer's REALLY wrong.", "Bri's doing a 40-minute live on that answer, wallahi.",
			"My tia cooks better answers than you, walaal."]},
	"ab_low": {"proper": ["Truce!"], "east": ["Okay okay, the beef was fake for views! Spare us!", "SANTOS! Bring the car round, walaal!", "Truce! We'll share the brisket, I swear!",
			"Round 48 tomorrow, same time, on live!", "Waan ka xumahay! Have the menudo, just go!"]},
	# Boss Arena names (Battle.make_lineup): daft ones with a few Somali names mixed in; E-LDN = Somali characters
	"boss_names": {"proper": ["Karen", "Karen's Sister-in-Law's Boyfriend", "Phil Mitchell", "Gemma Collins' Accountant", "Your Ex's New Situationship", "Gary From Finance",
			"The Man Who Replies-All", "Peggy Mitchell's Ghost", "Deliveroo Driver Who Ate Your Chips", "Hun From Facebook Selling Leggings", "Landlord Who Won't Fix The Boiler",
			"Dodgy Mechanic Dave", "Shoreditch Crypto Bro", "LinkedIn Influencer Chad", "Uncle Abdi (Unpaid Invoice)", "Auntie Hodan", "Faduma's Fiance (Allegedly)",
			"Ibrahim With The Mixtape", "Cousin Mo", "Dot Cotton's Lawyer"],
		"east": ["Abdi From The Corner Shop", "Auntie Hodan With The Dacas", "Uncle Farah, Phone-Case King", "Cousin Mo Who Owes You 20 Quid", "Ayeeyo's 9-Minute Voice Note",
			"Deeqa From The Wedding Committee", "Hooyo's Friend Who Asks When You're Getting Married", "Abshir The Uber Driver", "Warsame Who Does 'Business'", "Xaliimo The Gossip",
			"Macalin From Dugsi", "The Uncle Who Calls Everyone Doctor", "Guled The Unemployed Philosopher", "Your Cousin From Minnesota", "Auntie Fowsiya's Biryani",
			"Ali Who's 'Basically A Lawyer'", "Sahra And Her Five Sisters", "The Shaah That's Far Too Sweet", "Cousin Who Snitched To Hooyo", "Uncle Who Says 'Back In Somalia...'",
			"Abdifatah 'Ambuulo' Mohamed Abdullahi Farah", "Xaliimo Cabdiraxmaan Cali Faarax 'Dheere'", "Mohamed Mohamed Mohamed Mohamed (The Fourth)",
			"Cabdiqaadir 'Shaah Badan' Xirsi Jaamac Guuleed", "Abdirahman Abdirashid Abdirizak Abdiwali", "Hodan Hibaaq Hamdi Haweeya Hassan",
			"Ugaaso 'Bariis Iyo Moos' Cumar Warsame", "Ahmed 'Muufo' Cawil Diiriye Yuusuf", "Uncle Abdiwahab Abdikarim 'Two Phones' Abdillahi",
			"Ayaan Asha Amina Aisha Abdi (The Whole Family)", "Faadumo 'Sambuus Queen' Maxamed Cismaan", "Sheikh Abdullahi 'Anjeero' Nuur Aadan"]},
	"boss_final": {"proper": "Karen's Final Form", "east": "Hooyo, Final Boss"},
	# Running Man (her favourite): half of every lineup (Battle.make_lineup), and their own banter when one of them is up
	"boss_rm": {"proper": ["Kim Jong-kook, The Commander", "Sparta-kooks (Here For Your Name Tag)", "Lee Kwang-soo, Icon Of Betrayal",
			"Kwang-soo The Giraffe (Betraying Again)", "Yoo Jae-suk, The Grasshopper", "Yoo-Mes Is Watching You", "Ji Suk-jin, Big Nose Hyung",
			"Ji Suk-jin, Asleep In The Van", "Haha, The Haroro", "Mong Ji-hyo (Ace Mode: ON)", "Gary And Ji-hyo, The Monday Couple",
			"Jeon So-min, Chaos Queen", "Yang Se-chan's Wild Card", "The PD Who Hid The Mission Card", "Water Bomb Penalty",
			"The Flour Bomb Penalty", "Name Tag Elimination Round", "Capable Kim (Lifts You AND The Ledger)", "The Betrayers' Alliance",
			"The Hint Envelope You'll Never Get", "Final Mission: Ring The Bell", "Kim Jong-kook's Protein Shake", "The 5 AM Wake-Up Mission"],
		"east": ["Kim Jong-kook, The Commander (From Mogadishu)", "Lee Kwang-soo, Betrayer Of The Whole Qabiil", "Yoo Jae-suk, The Grasshopper, Wallahi",
			"Sparta-kooks (Wants Your Name Tag, Walaal)", "Ji Suk-jin, Asleep In The Uber", "Mong Ji-hyo (Ace Mode: ON)", "Haha, The Haroro",
			"Water Bomb Penalty", "Name Tag Elimination Round", "Gary And Ji-hyo, The Monday Couple", "The PD Who Hid The Mission Card",
			"Jeon So-min, Chaos Queen", "Kwang-soo The Giraffe (Betraying Again)", "Final Mission: Ring The Bell", "The 5 AM Wake-Up Mission"]},
	"rm_win": {"proper": ["Name tag RIPPED! You're out!", "Kim Jong-kook would be proud.", "Ring the bell, that's a win!", "Commander-level answer."],
		"east": ["Name tag RIPPED, walaal! You're out!", "Kim Jong-kook would be proud, wallahi.", "Ring the bell, mashallah!", "Sparta-kooks couldn't stop that one, sxb."]},
	"rm_hurt": {"proper": ["Not my name tag!", "Kwang-soo, you BETRAYED me!", "Water bomb, NOOO!", "That's a flour bomb to the face!"],
		"east": ["Not my name tag, HOOYOOO!", "Kwang-soo betrayed me, wallahi!", "Water bomb, waa maxay?!", "Flour bomb in my FACE!"]},
	"rm_taunt": {"proper": ["Kwang-soo-level betrayal of that answer.", "Even Ji Suk-jin got that, and he was asleep.", "Your name tag's hanging by a thread!", "Water bomb penalty for you!", "Yoo-Mes saw that. Everyone saw that."],
		"east": ["Kwang-soo-level betrayal, ceeb!", "Ji Suk-jin got that one asleep, nacas.", "Name tag's hanging by a thread, ukun!", "Water bomb penalty, walaal!"]},
	"rm_low": {"proper": ["I'll give you the hint envelope, I swear!", "Don't rip my name tag! Please!", "I'll be on your team next round!"],
		"east": ["Have the hint envelope, just go, walaal!", "Not the name tag, I've got kids!", "I'll join your team, wallahi!"]},
	# the big pop-up and name tag after an answer (green = right, red = wrong, so the words can just be silly)
	"shout_right": {"proper": ["NICE!", "ATE THAT!", "BIG BRAIN!", "SHEESH!", "CLEAN!", "BOOM!", "HAYE!"],
		"east": ["WALLAHI!", "MASHALLAH!", "HAYE!", "LIGHT WORK!", "PENG!", "SAY LESS!", "HAMBALYO!", "SUBHANALLAH!"]},
	"shout_wrong": {"proper": ["OOF!", "NOPE!", "FLOP!", "YIKES!", "NOT IT!", "AWKWARD...", "CEEB!"],
		"east": ["CEEB!", "NACAS!", "WARYAA!", "ALLOW IT!", "PEAK!", "UKUN!", "BRUV..."]},
	"quip_low": {"proper": ["Wait! Can we talk about this?", "I yield! Partially!", "Please... not the audit!"],
		"east": ["Wait wait, walaal, we're cousins!", "Allow it! I've got kids!", "I'll pay you in xalwo, I swear!", "Waan ka xumahay! I'm sorry!"]},
}

func east() -> bool:
	return str(Game.settings.get("sensei", "proper")) == "east"

func S(key: String, vars: Dictionary = {}) -> String:
	var v = SENSEI[key]["east" if east() else "proper"]
	var t: String = v[randi() % v.size()] if v is Array else str(v)
	for k in vars.keys():
		t = t.replace("{" + k + "}", str(vars[k]))
	return t

# The same line, worked out only when it is shown - so lines already queued in a battle follow the E-LDN
# button even if it is switched halfway through. tail is plain text added on; tail_key is another Sensei line.
func SL(key: String, vars: Dictionary = {}, tail := "", tail_key := "") -> Callable:
	return func() -> String:
		return S(key, vars) + tail + (S(tail_key) if tail_key != "" else "")

func toggle_sensei() -> void:
	Game.settings["sensei"] = "proper" if east() else "east"
	Game.save_settings()
	draw_toggles()
	match cur_screen:   # whatever Sensei is saying right now switches too
		"home": show_home()
		"title": show_title()
		"mtq": mtq.render()
		"battle": battle.retranslate()

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
	deco = preload("res://scripts/ThemeDeco.gd").new()   # cobwebs, icicles, holly round the edges
	add_child(deco)

func _process(delta: float) -> void:
	_glide(delta)
	_live_update_tick(delta)
	if not is_inside_tree():   # an update just took over: this screen is on its way out
		return
	_keyboard_lift(delta)
	if cur_screen in ["battle", "lesson", "mtq", "exam"]:
		study_sec += delta
		if study_sec >= 15.0:
			study_sec -= 15.0
			Game.note("sec", 15)

# ---------------------------------------------------------------- swipe to scroll
# On a phone a swipe that starts on a button or card never reached the list behind it, so lists wouldn't
# scroll. This catches the press first: once the finger moves 14 px it scrolls the list under it (and keeps
# gliding a little after letting go), and the button it started on is released off-screen so it doesn't fire.
var _drag_sc: ScrollContainer = null
var _drag_start := Vector2.ZERO
var _drag_from := 0
var _dragging := false
var _fling := 0.0

func _input(e: InputEvent) -> void:
	if e.has_meta("synthetic"):
		return
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		if e.pressed:
			_fling = 0.0
			_dragging = false
			_drag_sc = _scroll_at(e.position)
			_drag_start = e.position
		elif _dragging:
			_dragging = false
			get_viewport().set_input_as_handled()
	elif e is InputEventMouseMotion and _drag_sc != null and (e.button_mask & MOUSE_BUTTON_MASK_LEFT) and is_instance_valid(_drag_sc):
		if not _dragging and absf(e.position.y - _drag_start.y) > 14.0:
			_dragging = true
			_drag_start = e.position
			_drag_from = _drag_sc.scroll_vertical
			# slide the finger off the button, then let go there: a button fires on release only if the
			# last move left the finger inside it
			var away := InputEventMouseMotion.new()
			away.position = Vector2(-9999, -9999)
			away.global_position = away.position
			away.button_mask = MOUSE_BUTTON_MASK_LEFT
			away.set_meta("synthetic", true)
			get_viewport().push_input(away, true)
			var up := InputEventMouseButton.new()
			up.button_index = MOUSE_BUTTON_LEFT
			up.position = away.position
			up.global_position = up.position
			up.set_meta("synthetic", true)
			get_viewport().push_input(up, true)
		if _dragging:
			_drag_sc.scroll_vertical = _drag_from - int(e.position.y - _drag_start.y)
			_fling = clampf(e.velocity.y, -5000.0, 5000.0)
			get_viewport().set_input_as_handled()

# The innermost visible list under the finger that has something to scroll (Help first while it is open).
func _scroll_at(pos: Vector2) -> ScrollContainer:
	var found: ScrollContainer = null
	for sc in (help if help.visible else self).find_children("*", "ScrollContainer", true, false):
		if sc.is_visible_in_tree() and sc.get_global_rect().has_point(pos) and sc.get_v_scroll_bar().max_value > sc.size.y + 1:
			found = sc
	return found

# ---------------------------------------------------------------- on-screen keyboard
# Android's keyboard slides up over the bottom of the game rather than shrinking it, which hid the answer
# box. While it is up, slide the whole screen up just enough that the box being typed in sits above it.
func _keyboard_lift(delta: float) -> void:
	var lift := 0.0
	var kb := DisplayServer.virtual_keyboard_get_height()
	var f := get_viewport().gui_get_focus_owner()
	if kb > 0 and f is LineEdit and f.is_visible_in_tree() and stage.is_ancestor_of(f):
		var kb_h := kb * float(H) / DisplayServer.window_get_size().y
		var bottom := f.get_global_rect().end.y - stage.position.y + 24.0
		lift = maxf(0.0, bottom - (H - kb_h))
	stage.position.y = lerpf(stage.position.y, -lift, minf(1.0, delta * 14.0))
	if absf(stage.position.y + lift) < 0.5:
		stage.position.y = -lift

func _glide(delta: float) -> void:
	if _dragging or _drag_sc == null or not is_instance_valid(_drag_sc) or absf(_fling) < 30.0:
		return
	_drag_sc.scroll_vertical -= int(_fling * delta)
	_fling *= pow(0.04, delta)   # slows to a stop in about a second

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_ESCAPE:
		escape_screen()

# ---------------------------------------------------------------- Android back (Samsung edge swipe)
# Godot's default closes the app on "back"; instead it steps back like ESC. Mid-battle, lesson or case it asks
# for a second swipe so a stray edge swipe never throws you out; a running mock ignores it (use End exam);
# on the exam list a second swipe closes the app.
var _back_ms := -100000

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		_on_back()
	elif what == NOTIFICATION_APPLICATION_RESUMED or what == NOTIFICATION_APPLICATION_FOCUS_IN:
		_live_t = minf(_live_t, 2.0)   # back in the app: look for an update straight away

# ---------------------------------------------------------------- updates while the app is open
# Boot.gd fetches content updates when the app starts. While it stays open, this looks again every few minutes
# (and whenever she comes back to it) and downloads a newer pack quietly in the background. Then, as soon as she is
# on a calm screen (never mid-battle, lesson, case or mock), it saves her progress and reloads through Boot with the
# new version by itself - no buttons, no closing the app.
const LIVE_EVERY := 300.0
const LIVE_SAFE := ["title", "home", "book", "menu"]
var _live_t := 30.0
var _live_http: HTTPRequest
var _live_ver := 0
var _live_ready := false

func _live_update_tick(delta: float) -> void:
	if _live_ready:
		if cur_screen in LIVE_SAFE and not help.visible and not calc.visible:
			_live_ready = false
			_live_apply()
		return
	if BuildInfo.UPDATE_URL == "" or DisplayServer.get_name() == "headless" or OS.has_feature("editor") or _live_http != null:
		return
	_live_t -= delta
	if _live_t > 0.0:
		return
	_live_t = LIVE_EVERY
	_live_http = HTTPRequest.new()
	_live_http.timeout = 10.0
	add_child(_live_http)
	_live_http.request_completed.connect(_live_on_version)
	if _live_http.request(BuildInfo.UPDATE_URL + "/version.txt?t=%d" % Time.get_unix_time_from_system()) != OK:
		_live_done()

func _live_done() -> void:
	if _live_http:
		_live_http.queue_free()
	_live_http = null

func _live_on_version(result: int, code: int, _h: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		_live_done()
		return
	_live_ver = int(body.get_string_from_utf8().strip_edges())
	if _live_ver <= BuildInfo.BUILD:   # BuildInfo is the running version (Boot loaded the newest pack before this scene)
		_live_done()
		return
	_live_http.request_completed.disconnect(_live_on_version)
	_live_http.request_completed.connect(_live_on_pack)
	_live_http.timeout = 0.0
	_live_http.download_file = "user://update/download.tmp"
	if _live_http.request(BuildInfo.UPDATE_URL + "/content.pck?v=%d" % _live_ver) != OK:
		_live_done()

func _live_on_pack(result: int, code: int, _h: PackedStringArray, _b: PackedByteArray) -> void:
	_live_done()
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		return
	DirAccess.remove_absolute("user://update/content.pck")
	DirAccess.rename_absolute("user://update/download.tmp", "user://update/content.pck")
	var f := FileAccess.open("user://update/version.txt", FileAccess.WRITE)
	if f:
		f.store_string(str(_live_ver))
		f.close()
	_live_ready = true   # applied by _live_update_tick on the next calm screen

func _live_apply() -> void:
	Game.save_game()
	# Boot loads the new pack and opens the game again. Read afresh, so it is this version's Boot (which knows how to
	# swap code mid-session), not the copy cached from when the app first started.
	var boot = ResourceLoader.load("res://Boot.tscn", "", ResourceLoader.CACHE_MODE_IGNORE_DEEP)
	if boot is PackedScene:
		get_tree().change_scene_to_packed(boot)
	else:
		get_tree().change_scene_to_file("res://Boot.tscn")

func _on_back() -> void:
	if help.visible or calc.visible:
		escape_screen()
		return
	if cur_screen == "exam" and not exam.X.get("done", true):
		toast("Mock in progress - use End exam when you're finished.")
		return
	var twice := cur_screen in ["battle", "lesson", "mtq", "title"]
	if twice and Time.get_ticks_msec() - _back_ms > 2000:
		_back_ms = Time.get_ticks_msec()
		toast("Swipe back again to close the app" if cur_screen == "title" else "Swipe back again to leave")
		return
	_back_ms = -100000
	if cur_screen == "title":
		get_tree().quit()
	else:
		escape_screen()

# A short message that fades out near the bottom of the screen.
func toast(text: String) -> void:
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new(); sb.bg_color = Color(0.17, 0.11, 0.16, 0.92); sb.set_corner_radius_all(14)
	sb.content_margin_left = 22; sb.content_margin_right = 22; sb.content_margin_top = 12; sb.content_margin_bottom = 12
	p.add_theme_stylebox_override("panel", sb)
	p.add_child(UI.label(text, 22, UI.LIGHT, true))
	p.z_index = 50
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(p)
	p.reset_size()
	p.size.x = minf(W - 60.0, maxf(p.size.x, 300.0))
	p.position = Vector2((W - p.size.x) / 2.0, H - 150.0)
	var tw := create_tween()
	tw.tween_interval(1.6)
	tw.tween_property(p, "modulate:a", 0.0, 0.4)
	tw.tween_callback(p.queue_free)

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
	if help:
		help.maybe_intro()   # the first visit to each part explains it

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
	var jh := journey_top(s)   # the moving banner runs edge to edge across the top; the title sits on its lower edge
	var v := column(s, jh - 46, 26, 24, 14, [Color("141a33"), Color("3b2a52"), Color("2a1e2e")])
	v.alignment = BoxContainer.ALIGNMENT_BEGIN
	v.add_child(UI.banner("SAMURAI LEDGER"))
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
	var span := 616 if landscape else W   # width the decorations frame Zuru across
	var dy := -50 if landscape else 0
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
	UI.content(say).add_child(UI.typed("[b]Sensei Otter:[/b] " + greet, 24, true, true))
	left.add_child(say)
	var list := UI.vbox(8)
	list.add_child(UI.button("Exam dates - set your sitting dates", "03A", planner.show_dates))
	var grp := ""
	for x in ACCA_EXAMS:
		if x["grp"] != grp:
			grp = x["grp"]
			var gl := UI.label(grp, 30, UI.GOLD, true)
			gl.add_theme_color_override("font_outline_color", Color("2b1d2a"))
			gl.add_theme_constant_override("outline_size", 6)
			list.add_child(gl)
		list.add_child(_exam_row(x))
	var sc := UI.scroll(list)
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	right.add_child(sc)
	right.add_child(UI.label("Zuru's dojo - choose an exam to enter" + (" - happy holidays!" if festive() else (" - happy Halloween!" if spooky() else "")), 22, Color("fbe9d0"), true))
	right.add_child(UI.label(version_text() + "  ·  not affiliated with ACCA  ·  study aid only (see ? > Credits)", 18, Color(1, 1, 1, 0.55), true))
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
	var jh := journey_top(s)   # the moving banner runs edge to edge across the top; the title sits on its lower edge
	var v := column(s, jh - 46, 26, 14, 10, [Color("3b2a52"), Color("5a3a6e"), Color("2a1e2e")])
	var right := v
	if landscape:   # held sideways: banner, Zuru and Sensei on the left, the area cards on the right
		var cols := UI.hbox(20)
		cols.size_flags_vertical = Control.SIZE_EXPAND_FILL
		v.add_child(cols)
		var left := UI.vbox(10)
		var ls := UI.scroll(left)   # Sensei's side scrolls on its own, so the page fits the screen and the cards fit beside it
		ls.custom_minimum_size.x = 540
		ls.size_flags_horizontal = Control.SIZE_FILL
		right = UI.vbox(0); right.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		cols.add_child(ls); cols.add_child(right)
		v = left
	v.add_child(UI.banner("SAMURAI LEDGER"))
	var hero := UI.vbox(6)
	var speech := UI.box("BGbox_04A", true, Vector4(36, 30, 36, 26))
	speech.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var sv := UI.content(speech)
	var toprow := UI.hbox(8)
	toprow.add_child(UI.button("📅 Study plan", "03A", planner.show_plan, true, 24))
	toprow.add_child(UI.button("📓 Notebook", "06A", planner.show_notebook, true, 24))
	sv.add_child(toprow)
	var nm := by_keys(Game.mistakes.keys()).size()
	var say := UI.typed("[b]Sensei Otter:[/b] " + S("welcome_home") + " " + planner.plan_summary() + ((" %d wound%s to heal at the Shrine." % [nm, "" if nm == 1 else "s"]) if nm else ""), 24)
	say.name = "homeSay"
	sv.add_child(say)
	var rd := readiness()
	if rd["areas"].size():
		var weakest: Dictionary = rd["areas"][0]
		for a in rd["areas"]:
			if a["pct"] < weakest["pct"]:
				weakest = a
		var dq := Game.due(exam_id + "/").filter(func(k): return not "/card/" in str(k)).size()
		sv.add_child(UI.rich("[b]Exam-ready: %d%%[/b]  ·  weakest: %s %s%s" % [rd["overall"], weakest["code"], weakest["title"], ("  ·  [b]%d[/b] to review today" % dq) if dq else ""], 22))
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
	help.add_corner(speech, "SENSEI & YOUR PROGRESS", ["Study plan", "Notebook", "Exam-ready", "Lv / XP bar", "Reset", "Backup / Restore"])
	v.add_child(hero)
	var grid := GridContainer.new()
	grid.columns = 2   # small cards, so all eight fit on the screen upright and sideways
	grid.add_theme_constant_override("h_separation", 12)
	grid.add_theme_constant_override("v_separation", 12)
	grid.size_flags_vertical = Control.SIZE_EXPAND_FILL
	grid.name = "cards"
	for a in AREAS:
		var card := _card(a, nm)
		help.add_corner(card, str(a["name"]).to_upper(), [a["name"]])   # a small ? explains just this card
		grid.add_child(card)
	# the cards share the space left and fit without scrolling; they only scroll if a very small screen can't hold them
	var gs := UI.scroll(grid)
	right.add_child(gs)
	show_screen("home")

func _card(a: Dictionary, nm: int) -> Control:
	# Compact so all eight fit on one screen: icon beside the name, then the status.
	var p := UI.small_box(a["box"], a["dark"], Vector4(22, 18, 22, 16))
	p.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	p.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var dark: bool = a["dark"]
	var col := UI.LIGHT if not dark else UI.DARK
	var cv := UI.content(p)
	cv.alignment = BoxContainer.ALIGNMENT_CENTER
	cv.add_theme_constant_override("separation", 4)
	var tr := UI.hbox(8)
	tr.alignment = BoxContainer.ALIGNMENT_CENTER
	tr.add_child(UI.icon(a["icon"], 28))
	var t := UI.label(a["name"], 26, col, true)
	t.add_theme_font_size_override("font_size", 26)
	t.autowrap_mode = TextServer.AUTOWRAP_OFF   # beside the icon a wrapping label would squeeze to one letter wide
	tr.add_child(t)
	cv.add_child(tr)
	var stat := ""
	match a["id"]:
		"review":
			var dq := Game.due(exam_id + "/").filter(func(k): return not "/card/" in str(k)).size()
			stat = ("%d due today" % dq) if dq else ("All done today ✓" if Game.srs.size() else "Fills up as you answer questions")
		"scrolls":
			var ds: int = scrolls.due().size(); var us: int = scrolls.unseen().size()
			stat = "%d due · %d to learn" % [ds, us] if (ds or us) else "All learned ✓"
		"book": stat ="%d / %d stars" % [total_stars(), EXAM["chapters"].size() * 3]
		"boss":
			var gb := Game.best(exam_id + "/gauntlet"); var gl := Game.last_run(exam_id + "/gauntlet")
			stat = ("Last run %d · Best %d bosses" % [gl, gb]) if (gb or gl) else "Not fought yet"
		"bank": stat = "%d questions" % questions().size()
		"heal": stat = ("%d to review" % nm) if nm else "All healed!"
		"mock":
			var fb := [Game.best(exam_id + "/full/1"), Game.best(exam_id + "/full/2"), Game.best(exam_id + "/full/3")]
			var b: int = fb.max(); var ps := fb.filter(func(x): return x >= 50).size()
			stat = ("%d / 3 mocks passed · best %d%%" % [ps, b]) if b else "3 mocks · pass mark 50%"
		"rec":
			var tried := 0
			for c in EXAM["chapters"]:
				if Game.accuracy("%s/%d" % [exam_id, int(c["id"])]) >= 0:
					tried += 1
			stat = "%d / %d topics tried" % [tried, EXAM["chapters"].size()]
	cv.add_child(UI.label(stat, 22, col, true))
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
			"review":
				if Game.due(exam_id + "/").filter(func(k): return not "/card/" in str(k)).size():
					battle.start_review()
			"scrolls": scrolls.show_scrolls()
	)
	p.add_child(btn)
	return p

func home_say(text: String) -> void:
	var r: RichTextLabel = screens["home"].find_child("homeSay", true, false)
	if r:
		UI.set_rich(r, "[b]Sensei Otter:[/b] " + text, 24)
		UI.type_in(r)

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
	# The phone also keeps a copy of your progress for each of the last two weeks - tap a day to go back to it.
	var days: Array = Game.snapshots()
	if days.is_empty():
		return
	var q := UI.box("BGbox_03A", true)
	UI.content(q).add_child(UI.label("Or go back to an auto-save from this phone:", 18))
	var grid := GridContainer.new()
	grid.columns = 2
	for day in days:
		grid.add_child(UI.button(_nice_day(day), "02A", func():
			if Game.restore_snapshot(day):
				show_home(); home_say("Back to your progress from %s." % _nice_day(day))
			else:
				home_say("That auto-save could not be read - try another day."), true, 18))
	UI.content(q).add_child(grid)
	cards.add_child(q)

func _nice_day(day: String) -> String:
	if day == Game.today_key():
		return "Today"
	if day == Game.day_after(-1):
		return "Yesterday"
	var p := day.split("-")
	var months := ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
	return "%d %s" % [int(p[2]), months[int(p[1]) - 1]] if p.size() == 3 else day

# ---------------------------------------------------------------- training grounds, records, syllabus
var bank_kind := "":   # the Training Grounds question-type filter, remembered between launches
	set(v):
		bank_kind = v
		Game.remember("bank_kind", v)
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
	var ready := readiness()
	if ready["areas"].size():
		v.add_child(text_for(v, "[b]Exam-ready: %d%%[/b]\nBuilt from your accuracy in each area plus how much has stuck in Daily Review. Aim to get every area into the green." % ready["overall"], 26))
		for a in ready["areas"]:
			v.add_child(text_for(v, "%s  %s - %d%%" % [a["code"], a["title"], a["pct"]], 22))
			v.add_child(UI.bar(a["pct"] / 100.0, 600, 22))
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

# ---------------------------------------------------------------- Exam-ready meter
# Per chapter: 60% from accuracy so far, 40% from how much has STUCK (questions answered right again on a
# later Daily Review, i.e. review box 2+). Chapters never tried count 0. Each syllabus area averages the
# chapters that teach it; overall weights the areas by how many outcomes they hold.
func chapter_ready(ch_id: int) -> float:
	var acc := Game.accuracy("%s/%d" % [exam_id, ch_id])
	if acc < 0:
		return 0.0
	var qs := questions(ch_id)
	var stuck := qs.filter(func(q): return Game.box(str(q.get("_key", ""))) >= 2).size()
	return 0.6 * acc + 0.4 * (100.0 * stuck / maxi(1, qs.size()))

func readiness() -> Dictionary:
	var areas := []
	var total := 0.0; var weight := 0
	for a in EXAM.get("areas", []):
		var chs := {}; var n := 0
		for o in SYL:
			if str(o["code"]).begins_with(a["code"]):
				n += 1
				for c in o.get("ch", []).filter(func(x): return typeof(x) in [TYPE_INT, TYPE_FLOAT]):
					chs[int(c)] = true
		if n == 0:
			continue
		var sum := 0.0
		for c in chs.keys():
			sum += chapter_ready(c)
		var pct := int(round(sum / maxi(1, chs.size())))
		areas.append({"code": a["code"], "title": a["title"], "pct": pct})
		total += pct * n; weight += n
	return {"overall": int(round(total / maxi(1, weight))), "areas": areas}

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
		if cur_screen == "battle" and battle.s.get("gauntlet", false):
			battle.fx.music_start("boss")
	else:
		battle.fx.music_stop()   # the boss fight music goes quiet with the other sounds

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
	deco.mode = t
	for h in get_tree().get_nodes_in_group("theme_hat"):
		_set_hat(h)
	for im in get_tree().get_nodes_in_group("zuru"):
		if is_instance_valid(im) and im is TextureRect and ResourceLoader.exists(zuru_src("normal")):
			im.texture = load(zuru_src("normal"))

# The chapter monster (one image, recoloured by hue) - wearing the theme's hat, like Zuru.
const ZuruLive = preload("res://scripts/ZuruLive.gd")
func monster(w: float, h: float, hue := 0.0) -> TextureRect:
	var tr := UI.sprite(MONSTER, w, h, hue)
	var hat := TextureRect.new()
	hat.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	hat.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	hat.stretch_mode = TextureRect.STRETCH_SCALE
	hat.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var hw := w * 0.5
	hat.size = Vector2(hw, hw * 13.0 / 18.0)
	hat.position = Vector2((w - hw) / 2.0, h * 0.22 - hat.size.y)   # between its horns
	hat.add_to_group("theme_hat")
	tr.add_child(hat)
	_set_hat(hat)
	return tr

func _set_hat(h: TextureRect) -> void:
	var t: Texture2D = ZuruLive.hat_tex()
	h.texture = t
	h.visible = t != null

# ---------------------------------------------------------------- Zuru's face on any sprite marked zuru
func mood(who: Control, m: String, secs := 2.6) -> void:
	if who == null:
		return
	if who.has_method("act"):   # animated Zuru reacts with a move instead of a face swap
		who.call("act", m)
		return
	var tr := who as TextureRect
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
