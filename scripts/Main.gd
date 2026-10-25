extends Control
# ACCA Study Buddy — vertical slice. The whole UI is built in code so the scene
# stays tiny and robust. Drop art/font into res://assets/ (see assets/README_ASSETS.md)
# and it is used automatically; without it, cute placeholders are drawn instead.

const MONSTER_IMG := "res://assets/monster.png"
const BG_IMG := "res://assets/background.png"
const FONT_FILE := "res://assets/font.ttf"
const UI_DIR := "res://assets/ui/"

var exam_id := ""
var chapter: Dictionary = {}
var beats: Array = []
var beat_index: int = 0
var question_total: int = 0
var correct_count: int = 0
var answered: bool = false

var ui_font: Font = null
var ui_enabled := false
var sb_btn_normal: StyleBoxTexture
var sb_btn_hover: StyleBoxTexture
var sb_btn_pressed: StyleBoxTexture
var sb_panel: StyleBoxTexture
var sb_input: StyleBoxTexture

# persistent nodes
var monster_name_label: Label
var monster_center: CenterContainer
var hp_bar: ProgressBar
var content_box: VBoxContainer
var answer_box: VBoxContainer

# ---------------------------------------------------------------- setup
func _ready() -> void:
	_load_font()
	_load_ui()
	_build_base_ui()
	show_menu()

func _load_font() -> void:
	if ResourceLoader.exists(FONT_FILE):
		var f = load(FONT_FILE)
		if f is Font:
			ui_font = f

func _apply_font(ctrl: Control, size: int) -> void:
	if ctrl is RichTextLabel:
		if ui_font:
			ctrl.add_theme_font_override("normal_font", ui_font)
			ctrl.add_theme_font_override("bold_font", ui_font)
		ctrl.add_theme_font_size_override("normal_font_size", size)
		ctrl.add_theme_font_size_override("bold_font_size", size)
	else:
		if ui_font:
			ctrl.add_theme_font_override("font", ui_font)
		ctrl.add_theme_font_size_override("font_size", size)

func _sbt(path: String, m: int) -> StyleBoxTexture:
	var sb := StyleBoxTexture.new()
	sb.texture = load(path)
	sb.texture_margin_left = m
	sb.texture_margin_right = m
	sb.texture_margin_top = m
	sb.texture_margin_bottom = m
	return sb

func _load_ui() -> void:
	if not ResourceLoader.exists(UI_DIR + "button_normal.png"):
		return
	ui_enabled = true
	sb_btn_normal = _sbt(UI_DIR + "button_normal.png", 24)
	sb_btn_hover = _sbt(UI_DIR + "button_hover.png", 24)
	sb_btn_pressed = _sbt(UI_DIR + "button_pressed.png", 24)
	for sb in [sb_btn_normal, sb_btn_hover, sb_btn_pressed]:
		sb.content_margin_left = 20
		sb.content_margin_right = 20
		sb.content_margin_top = 10
		sb.content_margin_bottom = 10
	if ResourceLoader.exists(UI_DIR + "panel.png"):
		sb_panel = _sbt(UI_DIR + "panel.png", 20)
		sb_panel.content_margin_left = 18
		sb_panel.content_margin_right = 18
		sb_panel.content_margin_top = 16
		sb_panel.content_margin_bottom = 16
	if ResourceLoader.exists(UI_DIR + "input.png"):
		sb_input = _sbt(UI_DIR + "input.png", 22)
		sb_input.content_margin_left = 14
		sb_input.content_margin_right = 14
		sb_input.content_margin_top = 8
		sb_input.content_margin_bottom = 8

func _build_base_ui() -> void:
	var bg := ColorRect.new()
	bg.color = Color(0.09, 0.08, 0.14)
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	if ResourceLoader.exists(BG_IMG):
		var bgt := TextureRect.new()
		bgt.texture = load(BG_IMG)
		bgt.set_anchors_preset(Control.PRESET_FULL_RECT)
		bgt.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
		add_child(bgt)

	var margin := MarginContainer.new()
	margin.set_anchors_preset(Control.PRESET_FULL_RECT)
	margin.add_theme_constant_override("margin_left", 24)
	margin.add_theme_constant_override("margin_right", 24)
	margin.add_theme_constant_override("margin_top", 36)
	margin.add_theme_constant_override("margin_bottom", 28)
	add_child(margin)

	var root_v := VBoxContainer.new()
	root_v.add_theme_constant_override("separation", 14)
	margin.add_child(root_v)

	monster_name_label = Label.new()
	monster_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	monster_name_label.add_theme_color_override("font_color", Color(0.85, 0.8, 1))
	_apply_font(monster_name_label, 24)
	root_v.add_child(monster_name_label)

	monster_center = CenterContainer.new()
	monster_center.custom_minimum_size = Vector2(0, 180)
	root_v.add_child(monster_center)
	if ResourceLoader.exists(MONSTER_IMG):
		var tex := TextureRect.new()
		tex.texture = load(MONSTER_IMG)
		tex.custom_minimum_size = Vector2(200, 200)
		tex.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tex.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		tex.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		monster_center.add_child(tex)
	else:
		monster_center.add_child(_make_blob(Color(0.55, 0.45, 0.85)))

	hp_bar = ProgressBar.new()
	hp_bar.max_value = 100
	hp_bar.value = 100
	hp_bar.show_percentage = false
	hp_bar.custom_minimum_size = Vector2(0, 16)
	root_v.add_child(hp_bar)

	var panel := PanelContainer.new()
	panel.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root_v.add_child(panel)
	if sb_panel:
		panel.add_theme_stylebox_override("panel", sb_panel)
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	panel.add_child(scroll)
	content_box = VBoxContainer.new()
	content_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	content_box.add_theme_constant_override("separation", 12)
	scroll.add_child(content_box)

	answer_box = VBoxContainer.new()
	answer_box.add_theme_constant_override("separation", 10)
	root_v.add_child(answer_box)

# ---------------------------------------------------------------- helpers
func _key(ex: String, ch: int) -> String:
	return ex + "/" + str(ch)

func _clear(box: Node) -> void:
	for c in box.get_children():
		box.remove_child(c)
		c.queue_free()

func _make_text(txt: String, size := 22) -> RichTextLabel:
	var rt := RichTextLabel.new()
	rt.bbcode_enabled = true
	rt.fit_content = true
	rt.scroll_active = false
	rt.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	rt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	rt.add_theme_color_override("default_color", Color(0.16, 0.14, 0.22) if ui_enabled else Color(0.93, 0.93, 0.97))
	_apply_font(rt, size)
	rt.text = txt
	return rt

func _make_button(txt: String) -> Button:
	var b := Button.new()
	b.text = txt
	b.custom_minimum_size = Vector2(0, 56)
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	b.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_apply_font(b, 20)
	if ui_enabled:
		b.add_theme_stylebox_override("normal", sb_btn_normal)
		b.add_theme_stylebox_override("hover", sb_btn_hover)
		b.add_theme_stylebox_override("pressed", sb_btn_pressed)
		b.add_theme_stylebox_override("focus", sb_btn_normal)
		b.add_theme_stylebox_override("disabled", sb_btn_normal)
		b.add_theme_color_override("font_color", Color(0.16, 0.14, 0.22))
		b.add_theme_color_override("font_hover_color", Color(0.08, 0.07, 0.12))
		b.add_theme_color_override("font_pressed_color", Color(0.08, 0.07, 0.12))
		b.add_theme_color_override("font_focus_color", Color(0.16, 0.14, 0.22))
	return b

func _make_blob(col: Color) -> Control:
	var holder := Control.new()
	holder.custom_minimum_size = Vector2(170, 170)
	var body := Panel.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = col
	sb.set_corner_radius_all(85)
	body.add_theme_stylebox_override("panel", sb)
	body.size = Vector2(170, 170)
	holder.add_child(body)
	for eye_x in [55, 105]:
		var eye := Panel.new()
		var es := StyleBoxFlat.new()
		es.bg_color = Color(1, 1, 1)
		es.set_corner_radius_all(12)
		eye.add_theme_stylebox_override("panel", es)
		eye.size = Vector2(26, 26)
		eye.position = Vector2(eye_x - 13, 66)
		holder.add_child(eye)
		var pupil := Panel.new()
		var ps := StyleBoxFlat.new()
		ps.bg_color = Color(0.1, 0.1, 0.15)
		ps.set_corner_radius_all(6)
		pupil.add_theme_stylebox_override("panel", ps)
		pupil.size = Vector2(11, 11)
		pupil.position = Vector2(eye_x - 5, 74)
		holder.add_child(pupil)
	return holder

func _make_taccount(b: Dictionary) -> Control:
	var panel := PanelContainer.new()
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 4)
	panel.add_child(v)
	var title := Label.new()
	title.text = str(b.get("name", ""))
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_apply_font(title, 20)
	v.add_child(title)
	var cols := HBoxContainer.new()
	v.add_child(cols)
	var dr_col := _ta_column("Dr", b.get("dr", []), str(b.get("dr_total", "")))
	dr_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cols.add_child(dr_col)
	cols.add_child(VSeparator.new())
	var cr_col := _ta_column("Cr", b.get("cr", []), str(b.get("cr_total", "")))
	cr_col.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cols.add_child(cr_col)
	return panel

func _ta_column(header: String, rows: Array, total: String) -> VBoxContainer:
	var col := VBoxContainer.new()
	var h := Label.new()
	h.text = header
	h.add_theme_color_override("font_color", Color(0.8, 0.75, 1))
	_apply_font(h, 16)
	col.add_child(h)
	for r in rows:
		var rl := Label.new()
		rl.text = str(r)
		rl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		_apply_font(rl, 16)
		col.add_child(rl)
	if total != "":
		var tl := Label.new()
		tl.text = "------\n" + total
		_apply_font(tl, 16)
		col.add_child(tl)
	return col

# ---------------------------------------------------------------- screens
func show_menu() -> void:
	_clear(content_box)
	_clear(answer_box)
	hp_bar.visible = false
	monster_name_label.text = "ACCA STUDY BUDDY"
	var exam := Content.first_exam()
	if exam.is_empty():
		content_box.add_child(_make_text("No exams loaded."))
		return
	exam_id = str(exam["id"])
	content_box.add_child(_make_text("[b]Welcome, apprentice.[/b]\n\nEach monster is a topic. Defeat it by answering its challenges, and the topic is yours."))
	content_box.add_child(_make_text("Exam: [b]" + str(exam["name"]) + "[/b]"))
	for c in exam.get("chapters", []):
		var best := Game.get_best(_key(exam_id, int(c["id"])))
		var label := str(c["monster"]) + "   (Ch " + str(c["id"]) + ")"
		if best > 0:
			label += "   - best " + str(best) + "%"
		var btn := _make_button(label)
		btn.pressed.connect(start_chapter.bind(int(c["id"])))
		answer_box.add_child(btn)

func start_chapter(ch_id: int) -> void:
	chapter = Content.get_chapter(exam_id, ch_id)
	beats = chapter.get("beats", [])
	beat_index = 0
	correct_count = 0
	question_total = 0
	for b in beats:
		var t := str(b.get("type", ""))
		if t == "choice" or t == "input":
			question_total += 1
	monster_name_label.text = str(chapter.get("monster", ""))
	hp_bar.visible = true
	hp_bar.max_value = max(question_total, 1)
	hp_bar.value = question_total
	show_beat()

func show_beat() -> void:
	_clear(content_box)
	_clear(answer_box)
	answered = false
	if beat_index >= beats.size():
		show_result()
		return
	var b = beats[beat_index]
	var t := str(b.get("type", "story"))
	if b.has("speaker"):
		var sp := _make_text("[b]" + str(b["speaker"]) + ":[/b]", 18)
		sp.add_theme_color_override("default_color", Color(0.2, 0.42, 0.34) if ui_enabled else Color(0.65, 0.9, 0.8))
		content_box.add_child(sp)

	if t == "story" or t == "taccount":
		if b.has("text"):
			content_box.add_child(_make_text(str(b["text"])))
		if t == "taccount":
			content_box.add_child(_make_taccount(b))
		var cont := _make_button("Continue")
		cont.pressed.connect(_next_beat)
		answer_box.add_child(cont)
	elif t == "choice":
		content_box.add_child(_make_text(str(b["q"]), 23))
		var opts: Array = b["opts"]
		for i in range(opts.size()):
			var ob := _make_button(str(opts[i]))
			ob.pressed.connect(_answer_choice.bind(i))
			answer_box.add_child(ob)
	elif t == "input":
		content_box.add_child(_make_text(str(b["q"]), 23))
		var le := LineEdit.new()
		le.placeholder_text = "Type your answer..."
		le.custom_minimum_size = Vector2(0, 50)
		_apply_font(le, 22)
		if ui_enabled and sb_input:
			le.add_theme_stylebox_override("normal", sb_input)
			le.add_theme_stylebox_override("focus", sb_input)
			le.add_theme_color_override("font_color", Color(0.16, 0.14, 0.22))
			le.add_theme_color_override("font_placeholder_color", Color(0.5, 0.48, 0.55))
			le.add_theme_color_override("caret_color", Color(0.16, 0.14, 0.22))
		answer_box.add_child(le)
		var sub := _make_button("Strike!")
		sub.pressed.connect(func(): _answer_input(le.text))
		le.text_submitted.connect(func(_s): _answer_input(le.text))
		answer_box.add_child(sub)

func _answer_choice(i: int) -> void:
	if answered:
		return
	answered = true
	var b = beats[beat_index]
	_show_feedback(i == int(b["a"]), str(b.get("ex", "")))

func _answer_input(text: String) -> void:
	if answered:
		return
	var norm := _normalize(text)
	if norm == "":
		return
	answered = true
	var b = beats[beat_index]
	var correct := false
	for a in b.get("accept", []):
		if _normalize(str(a)) == norm:
			correct = true
			break
	var ex := str(b.get("ex", ""))
	if not correct and b.has("display_answer"):
		ex = "The answer is [b]" + str(b["display_answer"]) + "[/b].  " + ex
	_show_feedback(correct, ex)

func _normalize(s: String) -> String:
	s = s.strip_edges().to_lower()
	s = s.replace("$", "").replace("£", "").replace(",", "").replace(" ", "")
	return s

func _show_feedback(correct: bool, ex: String) -> void:
	_clear(answer_box)
	if correct:
		correct_count += 1
		hp_bar.value = max(0, question_total - correct_count)
	var head := "[b]Hit! +1[/b]  " if correct else "[b]Blocked.[/b]  "
	var fb := _make_text(head + ex)
	var good_col := Color(0.1, 0.5, 0.3) if ui_enabled else Color(0.8, 1, 0.85)
	var bad_col := Color(0.7, 0.12, 0.25) if ui_enabled else Color(1, 0.85, 0.88)
	fb.add_theme_color_override("default_color", good_col if correct else bad_col)
	content_box.add_child(fb)
	var cont := _make_button("Continue")
	cont.pressed.connect(_next_beat)
	answer_box.add_child(cont)

func _next_beat() -> void:
	beat_index += 1
	show_beat()

func show_result() -> void:
	_clear(content_box)
	_clear(answer_box)
	var pct := 0
	if question_total > 0:
		pct = int(round(float(correct_count) / float(question_total) * 100.0))
	Game.record_result(_key(exam_id, int(chapter["id"])), pct)
	var defeated := question_total > 0 and correct_count == question_total
	var head := "[b]" + str(chapter.get("monster", "")) + " defeated![/b]" if defeated else "[b]Trial complete[/b]"
	content_box.add_child(_make_text(head, 26))
	content_box.add_child(_make_text("You landed [b]" + str(correct_count) + " / " + str(question_total) + "[/b] clean hits  ([b]" + str(pct) + "%[/b])."))
	if pct >= 70:
		content_box.add_child(_make_text("Topic mastered - the examiner would be proud. The real FFA pass mark is 50%, so you are ahead."))
	else:
		content_box.add_child(_make_text("Not cleared yet (aim for 70%+). Re-enter and try again - repetition is how it sticks."))
	var again := _make_button("Re-enter the trial")
	again.pressed.connect(start_chapter.bind(int(chapter["id"])))
	answer_box.add_child(again)
	var back := _make_button("Back to the dojo")
	back.pressed.connect(show_menu)
	answer_box.add_child(back)
