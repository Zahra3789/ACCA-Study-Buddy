extends Node
# Pokémon-style battle: Zuru bottom-left, the topic monster top-right, dialogue box, answer "moves".
# Modes: trial (chapter quick battle), lesson (practice after a lesson), bank (Training Grounds),
# mistakes (Healer's Shrine), boss (the endless-lap gauntlet). Mocks live in Exam.gd.
# The flow is a coroutine: say() awaits a tap, ask() awaits an answer. Leaving the screen calls abandon(),
# which bumps session_id so the coroutine notices and stops.

signal tapped
signal answered

const MOVES := ["Debit Strike", "Credit Slash", "Accrual Cut", "Ledger Lunge", "Balance Blade", "Prudence Parry", "Matching Thrust", "Audit Arc"]
const BOSS_HP := 5
const RM_SHARE := 0.5      # how much of a Boss Arena lineup is Running Man (her favourite)
const SHOGUN_HP := 8
const HERO_HP := 10
const HEAL := 3

var main: Node
var s: Dictionary = {}
var session_id := 0
var fx: Node                 # BattleFX: slashes, shakes, knockdowns, finishers, boss music and voices
var combo := 0               # right answers in a row; 3+ is a critical (double damage on bosses)
var guess_btn: Button
var _guess_key := ""
var typing := false
var skip := false
var _answer: Dictionary = {}

var field: Control
var sky: TextureRect
var ground: ColorRect
var foe: TextureRect
var you: Control
var foe_name: Label
var foe_lv: Label
var foe_hp: ProgressBar
var you_lv: Label
var you_hp: ProgressBar
var you_hp_txt: Label
var hud: Label
var verdict: PanelContainer
var verdict_label: Label
var speaker: PanelContainer
var dlg: PanelContainer
var dlg_text: RichTextLabel
var dlg_extra: VBoxContainer
var more: Label
var cmds: VBoxContainer
var cmds_scroll: ScrollContainer
var sky_fill: ColorRect      # sky and ground colour round the field when the screen is a different shape
var ground_fill: ColorRect
var lower: Control
var lower_margin: MarginContainer

func setup(m: Node) -> void:
	main = m
	_build()
	relayout()
	fx = preload("res://scripts/BattleFX.gd").new()
	add_child(fx)
	fx.setup(self)

# The field (designed 720 x 600) is scaled to fit its area and sits on the area's bottom edge, centred; sky
# and ground colour fill whatever is left round it. Upright: field across the top, dialogue and moves below
# (they keep at least 640 px). Sideways: field in the left half, dialogue and moves in the right half.
func relayout() -> void:
	var area := Vector2(main.W / 2.0, main.H) if main.landscape else Vector2(main.W, minf(main.W * 600.0 / 720.0, main.H - 640.0))
	var k := minf(area.x / 720.0, area.y / 600.0)
	field.scale = Vector2(k, k)
	field.position = Vector2((area.x - 720.0 * k) / 2.0, area.y - 600.0 * k)
	var horizon := field.position.y + 372.0 * k
	sky_fill.position = Vector2.ZERO
	sky_fill.size = Vector2(area.x, horizon + 1)
	ground_fill.position = Vector2(0, horizon)
	ground_fill.size = Vector2(area.x, area.y - horizon)
	lower.position = Vector2(area.x, 0) if main.landscape else Vector2(0, area.y)
	lower.size = Vector2(main.W - area.x, main.H) if main.landscape else Vector2(main.W, main.H - area.y)
	lower_margin.add_theme_constant_override("margin_top", 60 if main.landscape else 8)

func _build() -> void:
	var scr: Control = main.screens["battle"]
	sky_fill = ColorRect.new()
	sky_fill.z_index = -2
	sky_fill.color = Color("0f1a3a")
	scr.add_child(sky_fill)
	ground_fill = ColorRect.new()
	ground_fill.z_index = -2
	ground_fill.color = Color("5fc07a")
	scr.add_child(ground_fill)
	field = Control.new()
	field.position = Vector2(0, 0)
	field.size = Vector2(720, 600)
	field.clip_contents = true
	scr.add_child(field)
	sky = UI.gradient_bg(Color("0f1a3a"), Color("8fd3ff"), Color("8fd3ff"))
	sky.set_anchors_preset(Control.PRESET_TOP_WIDE)
	sky.position = Vector2(0, 0); sky.size = Vector2(720, 372)
	field.add_child(sky)
	ground = ColorRect.new()
	ground.z_index = -2   # like the sky: theme snow falls in front of the scenery, behind the plates
	ground.position = Vector2(0, 372); ground.size = Vector2(720, 228)
	ground.color = Color("5fc07a")
	field.add_child(ground)
	field.add_child(_platform(Vector2(400, 300), Vector2(320, 80)))
	field.add_child(_platform(Vector2(30, 520), Vector2(360, 70)))
	foe = main.monster(240, 214)
	foe.position = Vector2(470, 90)
	field.add_child(foe)
	you = load("res://scripts/ZuruLive.gd").make(168, 182)
	you.position = Vector2(100, 352)
	field.add_child(you)
	# plates
	var fp := UI.box("BGbox_01A", true, Vector4(50, 40, 50, 34))   # text clear of the frame
	fp.position = Vector2(22, 60); fp.size = Vector2(420, 120)
	var fpv := UI.content(fp)
	var fr := UI.hbox(10)
	foe_name = UI.label("", 26, UI.RED); foe_name.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART; foe_name.size_flags_horizontal = Control.SIZE_EXPAND_FILL   # a long name wraps inside the plate
	foe_lv = UI.label("", 24, UI.DARK); foe_lv.size_flags_horizontal = Control.SIZE_SHRINK_END; foe_lv.autowrap_mode = TextServer.AUTOWRAP_OFF
	fr.add_child(foe_name); fr.add_child(foe_lv)
	fpv.add_child(fr)
	foe_hp = UI.bar(1.0, 320, 26)
	fpv.add_child(foe_hp)
	field.add_child(fp)
	var yp := UI.box("BGbox_01A", true, Vector4(50, 40, 50, 34))   # text clear of the frame
	yp.position = Vector2(338, 380); yp.size = Vector2(360, 150)
	var ypv := UI.content(yp)
	var yr := UI.hbox(10)
	yr.add_child(UI.label("ZURU", 26, UI.RED))
	you_lv = UI.label("", 24, UI.DARK); you_lv.size_flags_horizontal = Control.SIZE_SHRINK_END; you_lv.autowrap_mode = TextServer.AUTOWRAP_OFF
	yr.add_child(you_lv)
	ypv.add_child(yr)
	you_hp = UI.bar(1.0, 260, 26)
	ypv.add_child(you_hp)
	you_hp_txt = UI.label("", 24, UI.DARK); you_hp_txt.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	ypv.add_child(you_hp_txt)
	field.add_child(yp)
	hud = UI.label("", 28, UI.GOLD, true)
	hud.add_theme_color_override("font_outline_color", Color("2b1d2a"))   # the clear body font, outlined, so it reads over the field
	hud.add_theme_constant_override("outline_size", 6)
	hud.position = Vector2(0, 556); hud.size = Vector2(720, 40)
	hud.visible = false
	field.add_child(hud)
	verdict = PanelContainer.new()
	verdict_label = Label.new()
	verdict_label.add_theme_font_override("font", UI.title_o_font)
	verdict_label.add_theme_font_size_override("font_size", 72)
	verdict_label.add_theme_color_override("font_color", Color("e8ffe8"))
	verdict.add_child(verdict_label)
	verdict.visible = false
	verdict.rotation_degrees = -6
	field.add_child(verdict)
	# lower half: speaker, dialogue, commands
	lower = Control.new()
	lower.position = Vector2(0, 600); lower.size = Vector2(720, 680)
	var lbg := ColorRect.new(); lbg.color = Color("2a1e2e"); lbg.set_anchors_preset(Control.PRESET_FULL_RECT); lower.add_child(lbg)
	lower_margin = MarginContainer.new()
	var m := lower_margin
	m.set_anchors_preset(Control.PRESET_FULL_RECT)
	m.add_theme_constant_override("margin_left", 16); m.add_theme_constant_override("margin_right", 16); m.add_theme_constant_override("margin_top", 8); m.add_theme_constant_override("margin_bottom", 16)
	lower.add_child(m)
	var v := UI.vbox(8)
	m.add_child(v)
	speaker = UI.banner("", "BannerSmall_02C", 30)
	speaker.custom_minimum_size = Vector2(360, 72)   # one ribbon, big enough for the name to sit on its yellow face
	speaker.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(speaker)
	dlg = UI.box("BGbox_04A", true, Vector4(48, 44, 48, 40))   # text clear of the frame
	dlg.custom_minimum_size.y = 200
	var dv := UI.content(dlg)
	var inner := UI.vbox(8)
	dlg_text = UI.rich("", 26, true)
	inner.add_child(dlg_text)
	dlg_extra = UI.vbox(6)
	inner.add_child(dlg_extra)
	var dsc := UI.scroll(inner)
	dsc.custom_minimum_size.y = 140
	dv.add_child(dsc)
	more = UI.label("▼", 24, UI.BROWN); more.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT; more.visible = false
	dv.add_child(more)
	dlg.gui_input.connect(_dlg_input)
	dlg.mouse_filter = Control.MOUSE_FILTER_STOP
	v.add_child(dlg)
	# After a right answer: "I guessed it" sends the question back to tomorrow's Daily Review (only shown then)
	guess_btn = UI.button("I guessed this one", "04A", _guessed, true, 22)
	guess_btn.visible = false
	v.add_child(guess_btn)
	cmds = UI.vbox(10)
	cmds_scroll = UI.scroll(cmds)
	cmds_scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(cmds_scroll)
	scr.add_child(lower)

func _platform(pos: Vector2, size: Vector2) -> Panel:
	var p := Panel.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0, 0, 0, 0.22)
	sb.set_corner_radius_all(int(size.y))
	p.add_theme_stylebox_override("panel", sb)
	p.position = pos; p.size = size
	return p

func _dlg_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.pressed and e.button_index == MOUSE_BUTTON_LEFT:
		_tap()

func _unhandled_input(e: InputEvent) -> void:
	if main.cur_screen != "battle":
		return
	if e is InputEventKey and e.pressed and not e.echo and (e.keycode == KEY_ENTER or e.keycode == KEY_SPACE):
		var f := get_viewport().gui_get_focus_owner()
		if f is LineEdit:
			return
		_tap()

func _tap() -> void:
	if typing:
		skip = true
	else:
		tapped.emit()

func valid(sess: Dictionary) -> bool:
	return int(sess.get("id", -1)) == session_id

func abandon() -> void:
	if fx:
		fx.reset()
	if guess_btn:
		guess_btn.visible = false
	session_id += 1
	skip = true
	tapped.emit()
	answered.emit()

func stop_timer() -> void:
	pass

# ---------------------------------------------------------------- sessions
func start_session(o: Dictionary) -> void:
	session_id += 1
	_clear_quip()
	s = o.duplicate()
	s["id"] = session_id
	s["idx"] = 0
	s["correct"] = 0
	var qn := 0
	for b in s["beats"]:
		if main.is_q(b):
			qn += 1
	s["qTotal"] = qn
	s["youMax"] = int(o.get("youMax", max(qn, 1)))
	s["you"] = s["youMax"]
	main.show_screen("battle")
	var c: Array = o["scene"]
	_scene(c)
	foe.modulate = Color.WHITE
	foe.position = Vector2(470, 90)
	_set_hue(foe, float(o.get("hue", 0)))
	foe_name.text = o["foe"]
	foe_lv.text = str(o.get("foeLv", ""))
	you_lv.text = "Lv %d" % Game.level()
	main.mood(you, "normal")
	hud.visible = bool(o.get("gauntlet", false))
	if hud.visible:
		_hud()
	update_bars()
	combo = 0
	fx.reset()
	if o.get("gauntlet", false):
		fx.music_start("boss")
		fx.boss_intro(int(o.get("bossesDown", 0)) + 1)
	run_battle(s)

func _scene(c: Array) -> void:
	# themes: a snowy night field with Christmas trees, or a dusky Halloween one with pumpkins
	match main.theme():
		"xmas": c = [Color("0f1a3a"), Color("6f8fc8"), Color("eef4ff")]
		"halloween": c = [Color("1a0f2e"), Color("c0602a"), Color("2e2236")]
	_theme_props(main.theme())
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 1.0])
	g.colors = PackedColorArray([c[0], c[1]])
	var gt := GradientTexture2D.new()
	gt.gradient = g; gt.fill_from = Vector2(0, 0); gt.fill_to = Vector2(0, 1); gt.width = 8; gt.height = 128
	sky.texture = gt
	ground.color = c[2]
	sky_fill.color = c[0]
	ground_fill.color = c[2]

var _props: Array = []
func _theme_props(t: String) -> void:
	for p in _props:
		p.queue_free()
	_props.clear()
	if t == "":
		return
	# [image, x, width, height] standing on the horizon (y 372), behind the plates and fighters
	var list := [["tree", 24, 64, 96], ["tree", 300, 48, 72], ["present", 92, 36, 36]] if t == "xmas" else [["pumpkin", 30, 72, 58], ["pumpkin", 310, 52, 42]]
	for it in list:
		var sp := UI.sprite("res://assets/xmas/%s.png" % it[0], it[2], it[3])
		sp.position = Vector2(it[1], 372 - it[3])
		sp.z_index = -1
		field.add_child(sp)
		field.move_child(sp, 2)   # just after the sky and ground
		_props.append(sp)

func _set_hue(tr: TextureRect, deg: float) -> void:
	if deg == 0.0:
		tr.material = null
		return
	var sh := ShaderMaterial.new()
	sh.shader = UI._hue_shader()
	sh.set_shader_parameter("shift", fmod(deg, 360.0) / 360.0)
	tr.material = sh

func update_bars() -> void:
	var ff: float = (float(s["bossHp"]) / float(s["bossMax"])) if s.get("gauntlet", false) else (float(s["qTotal"] - s["correct"]) / float(s["qTotal"]) if s["qTotal"] else 1.0)
	UI.set_bar(foe_hp, ff)
	UI.set_bar(you_hp, float(s["you"]) / float(s["youMax"]))
	you_hp_txt.text = "HP %d / %d" % [s["you"], s["youMax"]]

func _speaker(name: String) -> void:
	var l: Label = speaker.get_meta("label")
	l.text = _shout if (name in ["CORRECT", "WRONG"] and _shout != "") else name   # the same daft word as the pop-up
	var style := "BannerSmall_02C"
	speaker.add_theme_stylebox_override("panel", UI.banner_style(style))
	l.add_theme_color_override("font_color", UI.GREEN if name == "CORRECT" else (UI.RED if name == "WRONG" else UI.DARK))
	# a long name (Ash Trevino Vs Bri (Round 47)) stays on one line and shrinks to fit
	var f: Font = l.get_theme_font("font")
	var fs := 30
	while fs > 18 and f.get_string_size(l.text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x > 540:
		fs -= 2
	l.add_theme_font_size_override("font_size", fs)
	speaker.reset_size()

var _shout := ""   # the word on the last verdict pop-up, repeated on the name tag

func _verdict(ok: bool) -> void:
	# not "CORRECT"/"WRONG" (the green or red says that): a quick daft word instead
	_shout = main.S("shout_right" if ok else "shout_wrong")
	_clear_quip()
	verdict_label.text = _shout
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.1, 0.5, 0.3, 0.92) if ok else Color(0.7, 0.12, 0.25, 0.92)
	sb.set_corner_radius_all(12); sb.set_border_width_all(6); sb.border_color = Color("2b1d2a")
	sb.content_margin_left = 30; sb.content_margin_right = 30; sb.content_margin_top = 10; sb.content_margin_bottom = 10
	verdict.add_theme_stylebox_override("panel", sb)
	verdict.visible = true
	verdict.reset_size()
	await get_tree().process_frame
	verdict.position = Vector2(360 - verdict.size.x / 2, 250)
	verdict.pivot_offset = verdict.size / 2
	verdict.scale = Vector2(0.3, 0.3)
	var tw := create_tween()
	tw.tween_property(verdict, "scale", Vector2.ONE, 0.25).set_trans(Tween.TRANS_BACK)
	get_tree().create_timer(1.6).timeout.connect(func(): verdict.visible = false)

func _anim(tr: Control, kind: String) -> void:
	var tw := create_tween()
	var p := tr.position
	match kind:
		"lungeR":
			tw.tween_property(tr, "position:x", p.x + 60, 0.12)
			tw.tween_property(tr, "position:x", p.x, 0.18)
		"lungeL":
			tw.tween_property(tr, "position:x", p.x - 60, 0.12)
			tw.tween_property(tr, "position:x", p.x, 0.18)
		"hit":
			for i in 3:
				tw.tween_property(tr, "position:x", p.x + (8 if i % 2 == 0 else -8), 0.05)
			tw.tween_property(tr, "position:x", p.x, 0.05)
			tw.parallel().tween_property(tr, "modulate", Color(1, 0.6, 0.6), 0.1)
			tw.tween_property(tr, "modulate", Color.WHITE, 0.25)
		"faint":
			tw.tween_property(tr, "modulate", Color(1, 1, 1, 0.3), 0.6)
			tw.parallel().tween_property(tr, "position:y", p.y + 30, 0.6)
		"dash":   # a right answer: she darts across the field, cuts, and springs back to her spot
			tw.tween_property(tr, "position", YOU_AT + Vector2(230, -120), 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
			tw.tween_interval(0.24)
			tw.tween_property(tr, "position", YOU_AT, 0.26).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		"pounce":   # a wrong answer: the monster leaps at her, then hops back to its platform
			tw.tween_property(tr, "position", FOE_AT + Vector2(-230, 170), 0.14).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
			tw.tween_interval(0.14)
			tw.tween_property(tr, "position", FOE_AT, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

# ---------------------------------------------------------------- banter
# Now and then a one-liner pops up over the fighters: Zuru bragging after a hit, the monster whimpering when it's
# hurt, taunting after a wrong answer, begging when it's down. A short laugh between questions (Sensei's lines in
# Main.SENSEI: quip_win, quip_hurt, quip_taunt, quip_low - proper or East London).
const YOU_AT := Vector2(100, 352)
const FOE_AT := Vector2(470, 90)
var _bubble: PanelContainer

func _quip(from_you: bool, text: String) -> void:
	if _bubble and is_instance_valid(_bubble):
		_bubble.queue_free()
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color("fff4d6"); sb.set_border_width_all(4); sb.border_color = Color("2b1d2a"); sb.set_corner_radius_all(14)
	sb.content_margin_left = 16; sb.content_margin_right = 16; sb.content_margin_top = 8; sb.content_margin_bottom = 10
	p.add_theme_stylebox_override("panel", sb)
	var l := UI.label(text, 24, UI.DARK if from_you else UI.RED, true)
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.custom_minimum_size.x = 260
	p.add_child(l)
	p.z_index = 24
	p.mouse_filter = Control.MOUSE_FILTER_IGNORE
	field.add_child(p)
	_bubble = p
	p.reset_size()
	p.position = Vector2(24, 300) if from_you else Vector2(720 - p.size.x - 24, 300)   # beside Zuru / under the monster (clear of the top buttons)
	p.pivot_offset = p.size / 2
	p.scale = Vector2(0.4, 0.4)
	var tw := create_tween()
	tw.tween_property(p, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	# it stays up (time to read it and the question) until the next answer or the next bubble

func _clear_quip() -> void:
	if _bubble and is_instance_valid(_bubble):
		_bubble.queue_free()
	_bubble = null

# A banter line - the Ash Trevino Vs Bri fight has its own lore lines (Main.SENSEI ab_*), every other boss the usual ones.
func _q(key: String) -> String:
	var foe := str(s.get("foe", ""))
	if main.east() and foe.begins_with("Ash Trevino"):
		return main.S(key.replace("quip_", "ab_"))
	# a Running Man boss mostly talks Running Man (name tags, betrayals, water bombs); now and then anyone does
	var rm_boss: bool = foe in main.SENSEI["boss_rm"]["east" if main.east() else "proper"]
	if randf() < (0.7 if rm_boss else 0.15):
		return main.S(key.replace("quip_", "rm_"))
	return main.S(key)

# After a hit: the monster begs when it's down; otherwise sometimes Zuru brags or the monster yelps.
func _banter_hit() -> void:
	if fx.knocked:
		_quip(false, _q("quip_low"))
	elif randf() < 0.45:
		_quip(true, _q("quip_win"))
	elif randf() < 0.5:
		_quip(false, _q("quip_hurt"))

func _dmg(text: String, pos: Vector2) -> void:
	var l := UI.label(text, 40, UI.GOLD)
	l.add_theme_font_override("font", UI.title_o_font)
	l.position = pos
	l.size = Vector2(120, 50)
	field.add_child(l)
	var tw := create_tween()
	tw.tween_property(l, "position:y", pos.y - 60, 0.9)
	tw.parallel().tween_property(l, "modulate:a", 0.0, 0.9)
	tw.tween_callback(l.queue_free)

# ---------------------------------------------------------------- dialogue
func type_text(text: String) -> void:
	UI.set_rich(dlg_text, text, 26)
	typing = true
	skip = false
	dlg_text.visible_characters = 0
	var total := dlg_text.get_total_character_count()
	while dlg_text.visible_characters < total and not skip:
		dlg_text.visible_characters += 2
		await get_tree().process_frame
	dlg_text.visible_characters = -1
	typing = false

# Short dialogue pages: split on blank lines, then sentences, about 150 characters a page.
func pages(text: String) -> Array:
	var out := []
	if text.strip_edges() == "":
		return out
	for para in text.split("\n\n"):
		var sentences: PackedStringArray = para.split(". ")
		var cur := ""
		for si in sentences.size():
			var piece: String = sentences[si]
			if si < sentences.size() - 1 and not piece.ends_with("."):
				piece += "."
			if cur.length() + piece.length() > 150 and cur != "":
				out.append(cur.strip_edges())
				cur = ""
			cur += (" " if cur != "" else "") + piece
		if cur.strip_edges() != "":
			out.append(cur.strip_edges())
	return out

# Lines are text, or a Sensei line (main.SL) worked out as it is shown, so it follows the E-LDN button.
var _line = null   # the line on screen now

func say(list: Array, who: String, sess: Dictionary, extra: Control = null) -> void:
	for i in list.size():
		if not valid(sess):
			return
		_speaker(who)
		UI.clear(cmds)
		UI.clear(dlg_extra)
		more.visible = false
		_line = list[i]
		await type_text(_line.call() if _line is Callable else str(_line))
		if not valid(sess):
			return
		if extra != null and i == list.size() - 1:
			dlg_extra.add_child(extra)
		more.visible = true
		await tapped
	_line = null
	more.visible = false
	UI.clear(dlg_extra)

# E-LDN switched mid-battle: Sensei's line on screen is said again the new way.
func retranslate() -> void:
	if not (_line is Callable):
		return
	skip = true
	await get_tree().process_frame
	if _line is Callable:
		UI.set_rich(dlg_text, _line.call(), 26)
		dlg_text.visible_characters = -1

func drcr(text: String) -> String:
	var re := RegEx.new()
	re.compile("^(Dr [^,]+), (Cr .+)$")
	var m := re.search(text)
	return (m.get_string(1) + "\n" + m.get_string(2)) if m else text

# Renders the question's answer widgets and waits for the answer: {ok, given} or {quit}.
func ask(b: Dictionary, sess: Dictionary) -> Dictionary:
	_speaker(str(sess["foe"]).to_upper())
	more.visible = false
	UI.clear(dlg_extra)
	UI.clear(cmds)
	var head := ("[i]%s[/i]\n" % b["_topic"]) if (sess["mode"] not in ["trial", "lesson"] and b.has("_topic")) else ""
	var hint = {"multi": "Multiple response", "picklist": "Pick list", "sort": "Sort", "input": "Number entry", "choice": "Multiple choice"}[b["type"]]
	await type_text(head + main.q_text(b) + "\n[i]%s - 2 marks[/i]" % hint)
	if not valid(sess):
		return {"quit": true}
	_answer = {}
	var styles := ["02A", "05A", "03A", "06A"]
	var drill: bool = sess["mode"] in ["bank", "mistakes", "review"]
	match b["type"]:
		"choice":
			var order = main.shuffled(range(b["opts"].size()))
			var grid := _grid()
			for j in order.size():
				var i: int = order[j]
				var btn := UI.button("%s   %s" % ["ABCD"[j], drcr(str(b["opts"][i]))], styles[j % 4], Callable(), true, 24 if str(b["opts"][i]).length() > 40 else 26)
				btn.pressed.connect(func():
					_answer = {"ok": i == int(b["a"]), "given": str(b["opts"][i])}
					answered.emit())
				btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.custom_minimum_size.y = 96
				grid.add_child(btn)
			cmds.add_child(grid)
		"multi":
			var picked := {}
			var order = main.shuffled(range(b["opts"].size()))
			var grid := _grid()
			var conf := UI.button("Confirm (0 selected)", "03A", Callable(), true, 26)
			conf.disabled = true
			conf.pressed.connect(func():
				var ok = picked.size() == b["a"].size()
				for i in b["a"]:
					if not picked.has(int(i)):
						ok = false
				_answer = {"ok": ok, "given": " + ".join(picked.keys().map(func(i): return str(b["opts"][i])))}
				answered.emit())
			for j in order.size():
				var i: int = order[j]
				var label := "%s   %s" % ["ABCD"[j], drcr(str(b["opts"][i]))]
				var btn := UI.button(label, styles[j % 4], Callable(), true, 24 if str(b["opts"][i]).length() > 40 else 26)
				btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.custom_minimum_size.y = 96
				btn.pressed.connect(func():
					if picked.has(i):
						picked.erase(i)
						btn.text = label
					else:
						picked[i] = true
						btn.text = "✓ " + label
					conf.text = "Confirm (%d selected)" % picked.size()
					conf.disabled = picked.is_empty())
				grid.add_child(btn)
			cmds.add_child(grid)
			cmds.add_child(conf)
		"input":
			var inp := UI.line_edit("Type your answer...", true, 30)
			inp.custom_minimum_size.y = 70
			var go := func():
				var n = main.norm(inp.text)
				if n == "":
					return
				var ok := false
				for a in b.get("accept", []):
					if main.norm(a) == n:
						ok = true
				_answer = {"ok": ok, "given": inp.text.strip_edges()}
				answered.emit()
			inp.text_submitted.connect(func(_t): go.call())
			cmds.add_child(inp)
			cmds.add_child(UI.button("Strike!", "03A", go))
			inp.grab_focus()
			main.calc.target = inp
		"picklist":
			var parts: PackedStringArray = str(b["q"]).split("{")
			var sentence := ""
			var sels := []
			for k in parts.size():
				if k == 0:
					sentence += parts[k]
					continue
				var close := parts[k].find("}")
				sentence += "[b]( %d )[/b]" % (int(parts[k].substr(0, close)) + 1) + parts[k].substr(close + 1)
			var box := UI.box("BGbox_04A", true)
			UI.content(box).add_child(UI.rich(sentence, 26))
			for li in b["lists"].size():
				var row := UI.hbox(8)
				row.add_child(UI.label("( %d )" % (li + 1), 24, UI.DARK))
				var o := UI.option(b["lists"][li])
				o.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				sels.append(o)
				row.add_child(o)
				UI.content(box).add_child(row)
			cmds.add_child(box)
			cmds.add_child(UI.button("Strike!", "03A", func():
				for o in sels:
					if o.selected <= 0:
						return
				var ok := true
				var given := []
				for i in sels.size():
					var v: int = sels[i].get_item_id(sels[i].selected)
					if v != int(b["a"][i]):
						ok = false
					given.append(str(b["lists"][i][v]))
				_answer = {"ok": ok, "given": " / ".join(given)}
				answered.emit()))
		"sort":
			var choice := {}
			var order = main.shuffled(range(b["items"].size()))
			var sub := UI.button("Strike!", "03A", Callable(), true, 26)
			sub.disabled = true
			sub.pressed.connect(func():
				var ok := true
				var given := []
				for i in b["items"].size():
					if int(choice.get(i, -1)) != int(b["items"][i][1]):
						ok = false
					given.append("%s: %s" % [b["items"][i][0], b["buckets"][int(choice.get(i, 0))]])
				_answer = {"ok": ok, "given": ", ".join(given)}
				answered.emit())
			for i in order:
				var row := UI.vbox(4)
				row.add_child(UI.label(str(b["items"][i][0]), 24, UI.LIGHT))
				var br := UI.hbox(6)
				var bs := []
				for bi in b["buckets"].size():
					var bb := UI.button(str(b["buckets"][bi]), ["05A", "02A", "03A", "06A"][bi % 4], Callable(), true, 20 if b["buckets"].size() > 2 else 24)
					bb.custom_minimum_size.y = 52
					bb.pressed.connect(func():
						choice[i] = bi
						for yi in bs.size():
							bs[yi].text = ("✓ " if yi == bi else "") + str(b["buckets"][yi])
						sub.disabled = choice.size() < b["items"].size())
					bs.append(bb)
					br.add_child(bb)
				row.add_child(br)
				cmds.add_child(row)
			cmds.add_child(sub)
	cmds.add_child(UI.button("Finish session" if drill else "Run away", "04A", func():
		_answer = {"quit": true}
		answered.emit()))
	await answered
	if not valid(sess):
		return {"quit": true}
	return _answer

func _grid() -> GridContainer:
	var g := GridContainer.new()
	g.columns = 2
	g.add_theme_constant_override("h_separation", 10)
	g.add_theme_constant_override("v_separation", 10)
	g.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return g

# ---------------------------------------------------------------- the battle loop
func run_battle(sess: Dictionary) -> void:
	if sess.get("intro") is Callable or str(sess.get("intro", "")) != "":
		await say([sess["intro"]], "BATTLE", sess)
	while valid(sess) and (sess.get("gauntlet", false) or sess["idx"] < sess["beats"].size()):
		if sess.get("gauntlet", false):
			_gauntlet_feed(sess)
		var b: Dictionary = sess["beats"][sess["idx"]]
		if not main.is_q(b):
			var extra: Control = _taccount(b) if b.get("type", "") == "taccount" else null
			await say(pages(str(b.get("text", ""))), str(b.get("speaker", "Sensei")).to_upper(), sess, extra)
			sess["idx"] += 1
			continue
		var r := await ask(b, sess)
		if not valid(sess):
			return
		if r.get("quit", false):
			if sess["mode"] in ["bank", "mistakes", "review"]:
				break
			if sess.get("gauntlet", false):
				await finish_gauntlet(sess, "left")
				return
			main.show_home()
			return
		if b.has("_key"):
			Game.answer(b["_key"], b["_ch"], r["ok"])
		if r["ok"]:
			sess["correct"] += 1
		UI.clear(cmds)
		if r["ok"]:
			combo += 1
			var dmg := 2 if (combo >= 3 and sess.get("gauntlet", false)) else 1
			_verdict(true); you.act("slash" if combo >= 3 else "happy"); _anim(you, "dash")   # a big slash on a combo
			await get_tree().create_timer(0.18).timeout
			fx.hit(combo)
			if not fx.knocked:
				_anim(foe, "hit")
			_dmg(("CRIT -%d" if combo >= 3 else "-%d") % dmg, Vector2(540, 100))
			if sess.get("gauntlet", false):
				sess["bossHp"] = max(0, int(sess["bossHp"]) - dmg)
			update_bars()
			# one good hit from defeat: knocked down (the defeating blow itself is the finisher)
			if sess.get("gauntlet", false):
				if int(sess["bossHp"]) <= 0:   # the defeating blow lands now, before Sensei explains the answer
					await fx.finisher(true)
					if not valid(sess):
						return
				elif int(sess["bossHp"]) == 1 and int(sess["bossMax"]) > 1:
					fx.knockdown()
			elif sess["mode"] in ["trial", "lesson"] and sess["qTotal"] and float(sess["qTotal"] - sess["correct"]) / sess["qTotal"] <= 0.25:
				fx.knockdown()
			if sess.get("bossHp", 1) > 0:   # (a defeated boss has already been sent flying)
				_banter_hit()
			_offer_guess(str(b.get("_key", "")))
			await say([main.SL("correct", {"move": MOVES[randi() % MOVES.size()].to_upper()})] + pages(str(b.get("ex", ""))), "CORRECT", sess)
			guess_btn.visible = false
			if sess.get("gauntlet", false) and sess["bossHp"] <= 0:
				sess["idx"] += 1
				if await next_boss(sess):
					return
				continue
		else:
			combo = 0
			main.sfx("miss"); _verdict(false); main.mood(you, "sad")
			sess["you"] = max(0, sess["you"] - 1)
			_anim(foe, "pounce")
			await get_tree().create_timer(0.18).timeout
			fx.hurt(sess["you"] > 0 and sess["you"] <= maxi(2, int(sess["youMax"] * 0.3)))
			_anim(you, "hit"); _dmg("-1", Vector2(200, 330))
			if randf() < 0.65:
				_quip(false, _q("quip_taunt"))
			update_bars()
			await say([main.SL("wrong", {"foe": sess["foe"], "ans": main.correct_text(b)})] + pages(str(b.get("ex", ""))), "WRONG", sess)
			if sess.get("gauntlet", false) and sess["you"] <= 0:
				sess["idx"] += 1
				await finish_gauntlet(sess, "fell")
				return
		sess["idx"] += 1
	if valid(sess):
		await finish(sess)

func _taccount(b: Dictionary) -> Control:
	var t := {"cols": [str(b.get("name", "")), "Dr", "Cr"], "rows": []}
	var dr: Array = b.get("dr", []); var cr: Array = b.get("cr", [])
	for i in max(dr.size(), cr.size()):
		t["rows"].append({"c": ["", str(dr[i]) if i < dr.size() else "", str(cr[i]) if i < cr.size() else ""]})
	if b.has("dr_total") or b.has("cr_total"):
		t["rows"].append({"c": ["Total", str(b.get("dr_total", "")), str(b.get("cr_total", ""))], "b": true})
	return UI.table(t)

func finish(sess: Dictionary) -> void:
	var drill: bool = sess["mode"] in ["bank", "mistakes", "review"]
	var total: int = sess["beats"].slice(0, sess["idx"]).filter(main.is_q).size() if drill else sess["qTotal"]
	var pct := int(round(float(sess["correct"]) / float(total) * 100.0)) if total else 0
	var key: String = sess.get("key", "")
	var before = main.stars(Game.best(key)) if key != "" else 0
	if key != "":
		Game.record(key, pct)
	var won := pct >= 70
	fx.set_danger(false)
	if won:
		if not drill:
			await fx.finisher(false)
			if not valid(sess):
				return
		main.sfx("win")
		fx.voice("win")
	elif not drill:
		fx.voice("lose")
	var lines := []
	var vars := {"foe": sess["foe"], "n": sess["correct"], "total": total, "pct": pct}
	lines.append(main.SL(("won" if won else "lost") if not drill else "session_done", vars))
	if sess["mode"] == "trial":
		var now = main.stars(pct)
		if now > before:
			lines.append("New record! [b]%d star%s[/b] for this chapter in your Chapter Book." % [now, "" if now == 1 else "s"])
	var c: Dictionary = main.get_ch(int(sess.get("chId", 0))) if sess.has("chId") else {}
	var lessons: Array = c.get("lessons", []) if sess["mode"] == "lesson" else []
	var has_next: bool = sess["mode"] == "lesson" and int(sess["li"]) + 1 < lessons.size()
	if sess["mode"] == "lesson":
		if won:
			Game.pass_lesson(key)
			lines.append(main.SL("lesson_pass", {}, ("Lesson %d is unlocked." % (int(sess["li"]) + 2)) if has_next else ("All lessons done - the Section B boss awaits!" if c.has("mtq") else "All lessons in this chapter done!")))
		else:
			lines.append(main.SL("lesson_fail"))
	lines.append(main.SL("xp", {"xp": sess["correct"] * 10, "lv": Game.level()}, "", "shrine_hint" if (pct < 70 and total) else ""))
	await say(lines, "SENSEI OTTER", sess)
	if not valid(sess):
		return
	UI.clear(cmds)
	var ch_id := int(sess.get("chId", 0))
	if sess["mode"] == "lesson":
		var li := int(sess["li"])
		if won:
			if has_next:
				cmds.add_child(UI.button("Next lesson", "06A", func(): main.book.show_lesson(ch_id, li + 1)))
			elif c.has("mtq"):
				cmds.add_child(UI.button("Section B boss", "06A", func(): main.mtq.show_mtq(ch_id)))
			else:
				cmds.add_child(UI.button("Quick battle", "06A", func(): start_chapter(ch_id)))
		else:
			cmds.add_child(UI.button("Read the lesson again", "06A", func(): main.book.show_lesson(ch_id, li)))
		cmds.add_child(UI.button("Chapter Book", "03A", func(): main.book.open_chapter(ch_id)))
	elif sess["mode"] == "trial":
		cmds.add_child(UI.button("Rematch", "06A", func(): start_chapter(ch_id)))
		cmds.add_child(UI.button("Chapter Book", "03A", func(): main.book.open_chapter(ch_id)))
	cmds.add_child(UI.button("Home", "05A", main.show_home))

# ---------------------------------------------------------------- starters
func start_chapter(id: int) -> void:
	var c = main.get_ch(id)
	var beats: Array = main.shuffled(main.questions(id)).slice(0, 15)
	start_session({"mode": "trial", "chId": id, "beats": beats, "key": "%s/%d" % [main.exam_id, id], "foe": c["monster"], "foeLv": "Ch %d" % id, "hue": id * 47, "scene": main.SCENES[id % main.SCENES.size()], "intro": main.SL("appear", {"foe": c["monster"], "topic": c["title"]})})

func start_lesson_practice(ch_id: int, li: int) -> void:
	var c = main.get_ch(ch_id)
	var l: Dictionary = c["lessons"][li]
	var beats := []
	for i in l["practice"].size():
		beats.append(main.tag_lesson(c, l, i))
	start_session({"mode": "lesson", "chId": ch_id, "li": li, "beats": beats, "key": "%s/%d/%s" % [main.exam_id, ch_id, l["id"]], "foe": c["monster"], "foeLv": "L%d" % (li + 1), "hue": ch_id * 47, "scene": main.SCENES[(ch_id + li) % main.SCENES.size()], "intro": main.SL("practice_intro", {"n": li + 1, "title": l["title"], "q": l["practice"].size()})})

func start_bank(id: int) -> void:
	start_session({"mode": "bank", "beats": main.shuffled(main.questions(id, main.bank_kind)), "key": "", "foe": "Training Dummy", "foeLv": "All" if id == -1 else "Ch %d" % id, "hue": 160, "scene": main.AREA_SCENE["bank"], "intro": main.SL("training_intro", {"topic": "all topics" if id == -1 else main.get_ch(id)["title"]})})

# Daily Review: everything due today (questions only - Sensei's Scrolls have their own screen), up to 25.
func start_review() -> void:
	var due: Array = main.shuffled(main.by_keys(Game.due(main.exam_id + "/")))
	start_session({"mode": "review", "beats": due.slice(0, 25), "key": "", "foe": "Memory Spirit", "foeLv": "Review", "hue": 180, "scene": main.AREA_SCENE["bank"], "intro": "Daily Review: [b]%d[/b] question%s due today. The ones you know come back less often; anything you miss or guess comes back tomorrow." % [mini(due.size(), 25), "" if due.size() == 1 else "s"]})

func _offer_guess(key: String) -> void:
	_guess_key = key
	guess_btn.text = "I guessed this one"
	guess_btn.disabled = false
	guess_btn.visible = key != ""

func _guessed() -> void:
	if _guess_key == "":
		return
	Game.mark_guessed(_guess_key)
	guess_btn.text = "Got it - it comes back in tomorrow's review"
	guess_btn.disabled = true

func start_mistakes() -> void:
	start_session({"mode": "mistakes", "beats": main.shuffled(main.by_keys(Game.mistakes.keys())), "key": "", "foe": "Wound Spirit", "foeLv": "Heal", "hue": 260, "scene": main.AREA_SCENE["mistakes"], "intro": main.SL("shrine_intro")})

# ---------------------------------------------------------------- Boss Arena: laps of 32 bosses
func make_lineup() -> Array:
	var out := []
	var chs: Array = main.EXAM["chapters"].filter(func(c): return main.questions(int(c["id"])).size() > 0)
	chs = main.shuffled(chs)
	# the bosses get silly names (Somali characters with E-LDN on); the chapter is still on the plate and in the topic
	# Half of them are Running Man (RM_SHARE), the rest the usual daft names, all shuffled together.
	var mode := "east" if main.east() else "proper"
	var base: Array = main.shuffled(main.SENSEI["boss_names"][mode])
	var rm: Array = main.shuffled(main.SENSEI["boss_rm"][mode])
	var k := roundi(chs.size() * RM_SHARE)
	var names := []
	for i in chs.size():
		names.append(rm[i % rm.size()] if i < k else base[(i - k) % base.size()])
	names = main.shuffled(names)
	for i in chs.size():
		var c: Dictionary = chs[i]
		out.append({"name": names[i % names.size()], "chId": int(c["id"]), "topic": c["title"], "hue": int(c["id"]) * 47, "lv": "Ch %d" % int(c["id"]), "hp": BOSS_HP})
		if i % 4 == 3:
			out.append({"name": main.S("boss_final"), "chId": -1, "topic": "every chapter", "hue": 300, "lv": "SHOGUN", "hp": SHOGUN_HP})
	if main.east() and out.size():   # East London mode always opens with the main event
		out[0]["name"] = "Ash Trevino Vs Bri (Round 47)"
	return out

func show_boss_lobby() -> void:
	var lineup := make_lineup()
	var v = main.menu("BOSS ARENA", "BGbox_07A", false)
	v.add_child(main.text_for(v, "[b]%d bosses a lap.[/b] Every boss has %d HP and each right answer is a hit. You have %d HP, lose 1 for a wrong answer and heal %d every time a boss falls. Clear the whole lap and you can start another - how far can you go?" % [lineup.size(), BOSS_HP, HERO_HP, HEAL]))
	var gb := Game.best(main.exam_id + "/gauntlet"); var gl := Game.last_run(main.exam_id + "/gauntlet")
	if gb or gl:
		v.add_child(main.text_for(v, "Last run: [b]%d[/b] bosses  ·  Best: [b]%d[/b] bosses." % [gl, gb]))
	v.add_child(main.text_for(v, "[b]Tonight's lineup[/b]", 26))
	for i in min(6, lineup.size()):
		var b: Dictionary = lineup[i]
		var row := UI.hbox(8)
		row.add_child(main.monster(40, 40, b["hue"]))
		row.add_child(main.text_for(v, "%d. %s  -  %s" % [i + 1, b["name"], ("mixed questions, %d HP" % SHOGUN_HP) if b["lv"] == "SHOGUN" else b["topic"]], 24))
		v.add_child(row)
	v.add_child(main.text_for(v, "... and the other %d to finish the lap." % (lineup.size() - 6), 24))
	v.add_child(UI.button("Fight!", "06A", func(): start_gauntlet(lineup, {})))

func start_gauntlet(lineup: Array, carry: Dictionary) -> void:
	var b0: Dictionary = lineup[0]
	var down := int(carry.get("bossesDown", 0)); var lap := int(carry.get("lap", 1))
	start_session({"mode": "boss", "gauntlet": true, "lineup": lineup, "lap": lap, "bossNo": 0, "bossesDown": down, "bossHp": b0["hp"], "bossMax": b0["hp"], "youMax": HERO_HP, "beats": [], "key": main.exam_id + "/gauntlet",
		"foe": b0["name"], "foeLv": b0["lv"], "hue": b0["hue"], "scene": main.AREA_SCENE["boss"], "intro": "%sBoss %d: a wild [b]%s[/b] appeared! Topic: %s." % [("[b]Lap %d![/b] " % lap) if lap > 1 else "", down + 1, b0["name"], b0["topic"]]})
	if carry.has("you"):
		s["you"] = int(carry["you"])
		update_bars()

func _hud() -> void:
	hud.text = "%sBoss %d/%d · Run %d · Best %d" % [("Lap %d · " % int(s["lap"])) if int(s["lap"]) > 1 else "", int(s["bossNo"]) + 1, s["lineup"].size(), int(s["bossesDown"]), max(Game.best(s["key"]), int(s["bossesDown"]))]

func _gauntlet_feed(sess: Dictionary) -> void:
	while sess["beats"].size() <= sess["idx"]:
		var b: Dictionary = sess["lineup"][sess["bossNo"]]
		sess["beats"].append_array(main.shuffled(main.questions(int(b["chId"]))))

func _set_foe(sess: Dictionary, b: Dictionary) -> void:
	sess["foe"] = b["name"]
	sess["bossMax"] = b["hp"]; sess["bossHp"] = b["hp"]
	foe.modulate = Color.WHITE
	foe.position = Vector2(470, 90)
	_set_hue(foe, float(b["hue"]))
	foe_name.text = b["name"]; foe_lv.text = str(b["lv"])
	update_bars()
	_hud()

func next_boss(sess: Dictionary) -> bool:
	var beaten: Dictionary = sess["lineup"][sess["bossNo"]]
	sess["bossesDown"] += 1
	main.sfx("win")
	sess["you"] = min(int(sess["youMax"]), int(sess["you"]) + HEAL)
	update_bars(); _hud()
	fx.set_danger(int(sess["you"]) <= maxi(2, int(sess["youMax"] * 0.3)))
	await say([main.SL("boss_down", {"foe": beaten["name"], "n": sess["bossesDown"], "es": "" if sess["bossesDown"] == 1 else "es", "heal": HEAL})], "VICTORY", sess)
	if not valid(sess):
		return true
	sess["bossNo"] += 1
	if sess["bossNo"] >= sess["lineup"].size():
		await finish_gauntlet(sess, "cleared")
		return true
	var nb: Dictionary = sess["lineup"][sess["bossNo"]]
	_set_foe(sess, nb)
	fx.boss_intro(int(sess["bossesDown"]) + 1)
	sess["beats"] = sess["beats"].slice(0, sess["idx"])
	await say(["Boss %d: a wild [b]%s[/b] appeared! Topic: %s." % [sess["bossesDown"] + 1, nb["name"], nb["topic"]]], "BATTLE", sess)
	return false

func finish_gauntlet(sess: Dictionary, how: String) -> void:
	fx.reset()
	fx.voice("win" if how == "cleared" else ("lose" if how == "fell" else ""))
	var n := int(sess["bossesDown"])
	var asked = sess["beats"].slice(0, sess["idx"]).filter(main.is_q).size()
	var before := Game.best(sess["key"])
	Game.record(sess["key"], n)
	Game.record_last(sess["key"], n)
	Game.note("bosses", n)
	var bosses := "[b]%d[/b] boss%s" % [n, "" if n == 1 else "es"]
	var lines := []
	lines.append(main.SL("cleared" if how == "cleared" else ("left" if how == "left" else "fell"), {"bosses": bosses, "laps": (" over %d laps" % int(sess["lap"])) if int(sess["lap"]) > 1 else "", "foe": sess["foe"]}))
	lines.append("Answers: [b]%d / %d[/b] right." % [sess["correct"], asked] + ("  [b]New record![/b]" if n > before else (("  Best run: %d." % before) if before else "")))
	lines.append(main.SL("xp", {"xp": sess["correct"] * 10, "lv": Game.level()}, "", "shrine_hint" if sess["correct"] < asked else ""))
	await say(lines, "VICTORY" if how == "cleared" else "SENSEI OTTER", sess)
	if not valid(sess):
		return
	UI.clear(cmds)
	if how == "cleared":
		var you_left := int(sess["you"]); var lap := int(sess["lap"])
		cmds.add_child(UI.button("Next lap - keep the run going", "06A", func(): start_gauntlet(make_lineup(), {"bossesDown": n, "you": you_left, "lap": lap + 1})))
	else:
		cmds.add_child(UI.button("Fight again", "06A", show_boss_lobby))
	cmds.add_child(UI.button("Hall of Records", "03A", main.show_records))
	cmds.add_child(UI.button("Home", "05A", main.show_home))
