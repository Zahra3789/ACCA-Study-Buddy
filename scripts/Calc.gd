extends Control
# The in-game calculator: live result as you type, a history tape, memory, and 'Use' to drop the answer into
# whichever answer box was last focused. Movable by its title bar; position and size are remembered.
# Typed text is evaluated with Godot's Expression class after a whitelist filter - never run as code.

var main: Node
var expr_edit: LineEdit
var result_label: Label
var tape: RichTextLabel
var tape_lines: Array = []
var last_answer := 0.0
var memory := 0.0
var target: LineEdit = null
var dragging := false
var drag_off := Vector2.ZERO
var resizing := false
var panel: PanelContainer
var body: BoxContainer
var grip: Label
var title_label: Label
var mini_btn: Button
var mini := false        # shrunk to a small bar (title, answer, buttons) so the question shows
var full_size := Vector2(660, 720)
var keys_grid: GridContainer

func setup(m: Node) -> void:
	main = m
	visible = false
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = 41
	panel = UI.box("BGbox_05A", true, Vector4(40, 40, 40, 36))
	panel.position = Vector2(30, 58)
	panel.size = Vector2(660, 720)
	add_child(panel)
	var v := UI.content(panel)
	var title := UI.hbox(8)
	title_label = UI.title_label("CALCULATOR  (drag me)", 26, UI.RED)
	title_label.mouse_filter = Control.MOUSE_FILTER_STOP
	title_label.autowrap_mode = TextServer.AUTOWRAP_OFF   # one line, even in the small bar
	title_label.clip_text = true
	title_label.gui_input.connect(_title_input)
	title.add_child(title_label)
	mini_btn = UI.button("_", "03A", func(): set_mini(not mini), false, 24)
	mini_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	mini_btn.custom_minimum_size = Vector2(64, 56)
	title.add_child(mini_btn)
	var close := UI.button("Close", "04A", func(): toggle(false), true, 22)
	close.size_flags_horizontal = Control.SIZE_SHRINK_END
	close.custom_minimum_size = Vector2(110, 56)
	title.add_child(close)
	v.add_child(title)
	# sum, result and tape stacked above the keys upright; side by side when the phone is sideways
	body = BoxContainer.new()
	body.add_theme_constant_override("separation", 12)
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(body)
	var info := UI.vbox(10)
	info.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body.add_child(info)
	expr_edit = UI.line_edit("Type a sum, e.g. (120000-20000)/5", false, 30)
	expr_edit.text_changed.connect(func(_t): _live())
	expr_edit.text_submitted.connect(func(_t): _equals())
	info.add_child(expr_edit)
	result_label = UI.label("= 0", 36, UI.DARK)
	result_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	info.add_child(result_label)
	tape = UI.rich("", 22, true)
	tape.fit_content = false
	tape.scroll_active = true
	tape.get_v_scroll_bar().modulate.a = 0.0   # scrolls, but no bar
	tape.custom_minimum_size.y = 120
	tape.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var tp := PanelContainer.new()
	var sb := StyleBoxFlat.new(); sb.bg_color = Color(0, 0, 0, 0.12); sb.set_corner_radius_all(6); sb.content_margin_left = 10; sb.content_margin_right = 10
	tp.add_theme_stylebox_override("panel", sb)
	tp.size_flags_vertical = Control.SIZE_EXPAND_FILL
	tp.add_child(tape)
	info.add_child(tp)
	var keys := GridContainer.new()
	keys.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	keys.columns = 5
	keys.add_theme_constant_override("h_separation", 6)
	keys.add_theme_constant_override("v_separation", 6)
	for k in ["7", "8", "9", "/", "C", "4", "5", "6", "*", "←", "1", "2", "3", "-", "(", "0", ".", "%", "+", ")", "√", "x²", "1/x", "Ans", "=", "M+", "M-", "MR", "Use", "Copy"]:
		var kk: String = k
		var code := "03A" if kk == "=" else ("06A" if kk in ["C", "←"] else ("02A" if kk in ["Use", "Copy"] else "05A"))
		var b := UI.button(kk, code, func(): _key(kk), true, 24)
		b.custom_minimum_size = Vector2(0, 46)   # small enough that the whole calculator can be sized down
		keys.add_child(b)
	body.add_child(keys)
	grip = UI.label("◢", 40, UI.GOLD)
	grip.size_flags_horizontal = Control.SIZE_SHRINK_END
	grip.mouse_filter = Control.MOUSE_FILTER_STOP
	grip.gui_input.connect(_grip_input)
	v.add_child(grip)
	_load_layout()
	relayout()

func toggle(open: bool) -> void:
	visible = open
	mouse_filter = Control.MOUSE_FILTER_IGNORE if not open else Control.MOUSE_FILTER_PASS
	if open:
		# remember the answer box that was focused, so Use can fill it
		var f := get_viewport().gui_get_focus_owner()
		if f is LineEdit and f != expr_edit:
			target = f
		if not mini:
			expr_edit.grab_focus()
	else:
		_save_layout()

func _title_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		dragging = e.pressed
		drag_off = get_global_mouse_position() - panel.global_position
		if not dragging:
			_save_layout()
	elif e is InputEventMouseMotion and dragging:
		var p := get_global_mouse_position() - drag_off
		panel.position = Vector2(clamp(p.x, 0, main.W - panel.size.x), clamp(p.y, 0, main.H - panel.size.y))

func _grip_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		resizing = e.pressed
		if not resizing:
			_save_layout()
	elif e is InputEventMouseMotion and resizing:
		var m := get_global_mouse_position()
		panel.size = Vector2(clamp(m.x - panel.position.x + 20, 400, main.W - panel.position.x), clamp(m.y - panel.position.y + 20, 480, main.H - panel.position.y))

# _ shrinks the calculator to a small bar showing the answer, so the question underneath can be read;
# ▢ opens it full again. The bar can still be dragged out of the way by its title.
func set_mini(on: bool) -> void:
	if on and not mini and not main.landscape:
		full_size = panel.size
	mini = on
	mini_btn.text = "▢" if mini else "_"
	_title_text()
	relayout()
	_save_layout()

func _title_text() -> void:
	title_label.text = ("CALC  " + result_label.text) if mini else "CALCULATOR  (drag me)"

# After the phone rotates: keys beside the tape when sideways, and keep the panel on screen.
func relayout() -> void:
	body.vertical = not main.landscape
	body.visible = not mini
	_title_text()
	grip.visible = not main.landscape and not mini   # sideways the panel is sized to fit; no room or need to resize it
	if mini:
		panel.size = Vector2(minf(main.W - 20, 480), 1)   # as short as its contents allow
	elif main.landscape:
		panel.size = Vector2(1000, 640)
		panel.position = Vector2((main.W - 1000) / 2.0, 64)
	else:
		if full_size.x > main.W - 20:
			full_size = Vector2(660, 720)
			panel.position = Vector2(30, 58)
		panel.size = full_size
	panel.size = Vector2(minf(panel.size.x, main.W - 20), minf(panel.size.y, main.H - 64))
	panel.position = Vector2(clampf(panel.position.x, 0, main.W - panel.size.x), clampf(panel.position.y, 58, maxf(58, main.H - panel.size.y)))

func _save_layout() -> void:
	if not mini and not main.landscape:
		full_size = panel.size
	var f := FileAccess.open("user://calc_layout.json", FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify({"x": panel.position.x, "y": panel.position.y, "w": full_size.x, "h": full_size.y, "mini": mini}))
		f.close()

func _load_layout() -> void:
	if not FileAccess.file_exists("user://calc_layout.json"):
		return
	var f := FileAccess.open("user://calc_layout.json", FileAccess.READ)
	if f:
		var d = JSON.parse_string(f.get_as_text())
		f.close()
		if typeof(d) == TYPE_DICTIONARY:
			panel.position = Vector2(float(d.get("x", 30)), float(d.get("y", 58)))
			full_size = Vector2(float(d.get("w", 660)), float(d.get("h", 720)))
			panel.size = full_size
			mini = bool(d.get("mini", false))
			mini_btn.text = "▢" if mini else "_"

func _key(k: String) -> void:
	match k:
		"C": expr_edit.text = ""; _live()
		"←": expr_edit.text = expr_edit.text.substr(0, max(0, expr_edit.text.length() - 1)); _live()
		"=": _equals()
		"√": _insert("sqrt(")
		"x²": _insert("^2")
		"1/x": expr_edit.text = "1/(%s)" % expr_edit.text; _live()
		"Ans": _insert(_fmt(last_answer))
		"M+": memory += _value(); _tape_add("M+ -> " + _fmt(memory))
		"M-": memory -= _value(); _tape_add("M- -> " + _fmt(memory))
		"MR": _insert(_fmt(memory))
		"Use": _use()
		"Copy": DisplayServer.clipboard_set(_fmt(_value()))
		_: _insert(k)
	expr_edit.grab_focus()
	expr_edit.caret_column = expr_edit.text.length()

func _insert(s: String) -> void:
	expr_edit.text += s
	_live()

func _value() -> float:
	var v = evaluate(expr_edit.text)
	return float(v) if v != null else 0.0

func _live() -> void:
	var v = evaluate(expr_edit.text)
	result_label.text = ("= " + _fmt(v)) if v != null else ("= ?" if expr_edit.text.strip_edges() != "" else "= 0")
	if mini:
		_title_text()

func _equals() -> void:
	var v = evaluate(expr_edit.text)
	if v == null:
		return
	last_answer = v
	_tape_add("%s = %s" % [expr_edit.text, _fmt(v)])
	expr_edit.text = _fmt(v)
	_live()

func _tape_add(line: String) -> void:
	tape_lines.append(line)
	if tape_lines.size() > 40:
		tape_lines.pop_front()
	UI.set_rich(tape, "\n".join(tape_lines), 22)

func _use() -> void:
	var v := _value()
	if target != null and is_instance_valid(target) and target.is_visible_in_tree():
		target.text = _fmt(v)
		target.text_changed.emit(target.text)
		toggle(false)
	else:
		DisplayServer.clipboard_set(_fmt(v))

func _fmt(v: float) -> String:
	if abs(v - round(v)) < 1e-9:
		return str(int(round(v)))
	return ("%.4f" % v).rstrip("0").rstrip(".")

# Whitelisted arithmetic only: digits, operators, brackets, %, ^, sqrt. Anything else is rejected.
func evaluate(text: String):
	var s := text.strip_edges().replace(",", "").replace("x", "*").replace("X", "*").replace("÷", "/")
	if s == "":
		return null
	var re := RegEx.new()
	re.compile("^[0-9+\\-*/().%^ sqrt]*$")
	if re.search(s) == null:
		return null
	s = s.replace("^", "**")
	var pre := RegEx.new()
	pre.compile("([0-9.]+)%")
	s = pre.sub(s, "($1/100.0)", true)
	var ex := Expression.new()
	if ex.parse(s) != OK:
		return null
	var r = ex.execute([], null, false)
	if ex.has_execute_failed() or (typeof(r) != TYPE_FLOAT and typeof(r) != TYPE_INT):
		return null
	return float(r)
