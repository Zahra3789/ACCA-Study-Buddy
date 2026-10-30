extends Control
# The notepad (web / laptop only - her phone has no NOTES button): a sheet down the right-hand side to write
# notes on while she reads (laid over the page), as she has no pen and paper to hand. It stays open across screens, saves as she
# types (Game.notes, so Backup / Restore carry it too). She types a line, then "Heading" turns it into a heading
# (a gold band); tapping it again turns it back into plain text. Like the calculator it can be dragged by its title,
# resized from the ◢ corner and shrunk to a bar with _, and it remembers where she left it.

var main: Node
var panel: PanelContainer
var edit: TextEdit
var status: Label
var _save_in := -1.0   # seconds until the typing is saved, -1 = nothing waiting
var title: Label
var mini_btn: Button
var bottom: HBoxContainer
var mini := false      # shrunk to just its title bar
var dragging := false
var resizing := false
var drag_off := Vector2.ZERO

const PAPER := Color("fff6dc")
const INK := Color("2b1d2a")

func setup(m: Node) -> void:
	main = m
	visible = false
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE   # the page beside it stays usable
	z_index = 40   # above the screens and theme trimmings, below the calculator and help
	panel = PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = PAPER
	sb.border_color = Color("8a4b22")   # a warm brown frame all round, like the game's wooden frames
	sb.set_border_width_all(7)
	sb.set_corner_radius_all(16)
	sb.shadow_color = Color(0.1, 0.05, 0.02, 0.35)   # a soft brown shadow so it lifts off the page
	sb.shadow_size = 10
	sb.shadow_offset = Vector2(-3, 4)
	sb.content_margin_left = 22; sb.content_margin_right = 22; sb.content_margin_top = 18; sb.content_margin_bottom = 18
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)
	var v := UI.vbox(10)
	panel.add_child(v)
	var top := UI.hbox(8)
	title = UI.title_label("NOTEPAD  (drag me)", 26, Color("6b3fa0"))   # like the calculator: drag it by its title
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title.mouse_filter = Control.MOUSE_FILTER_STOP
	title.autowrap_mode = TextServer.AUTOWRAP_OFF
	title.clip_text = true
	title.gui_input.connect(_title_input)
	top.add_child(title)
	mini_btn = UI.button("_", "03A", func(): set_mini(not mini), false, 22)   # shrink to a bar / open full again
	mini_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	mini_btn.custom_minimum_size = Vector2(56, 52)
	top.add_child(mini_btn)
	var mk := UI.button("Heading", "03A", _make_heading, false, 20)   # this line <-> a heading
	mk.size_flags_horizontal = Control.SIZE_SHRINK_END
	mk.custom_minimum_size = Vector2(130, 52)
	top.add_child(mk)
	var close := UI.button("Close", "04A", func(): toggle(false), false, 20)
	close.size_flags_horizontal = Control.SIZE_SHRINK_END
	close.custom_minimum_size = Vector2(110, 52)
	top.add_child(close)
	v.add_child(top)
	edit = TextEdit.new()
	edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	edit.placeholder_text = "Write anything here while you study - it saves as you type.\n\nType a heading, then tap 'Heading' to turn that line gold."
	edit.size_flags_vertical = Control.SIZE_EXPAND_FILL
	edit.add_theme_font_override("font", UI.body_font)
	edit.add_theme_font_size_override("font_size", 24)
	edit.add_theme_color_override("font_color", INK)
	edit.add_theme_color_override("font_placeholder_color", Color(INK, 0.45))
	edit.add_theme_color_override("caret_color", INK)
	edit.add_theme_color_override("selection_color", Color(0.42, 0.25, 0.63, 0.35))
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color("fffdf4")
	bg.border_color = Color("e2d3b0")
	bg.set_border_width_all(2)
	bg.set_corner_radius_all(8)
	bg.content_margin_left = 12; bg.content_margin_right = 12; bg.content_margin_top = 10; bg.content_margin_bottom = 10
	edit.add_theme_stylebox_override("normal", bg)
	edit.add_theme_stylebox_override("focus", bg)
	# headings ("== ... ==") in dark red on a gold band, so they stand out as headings
	var hl := CodeHighlighter.new()
	hl.add_color_region("==", "==", HEAD_INK, true)
	hl.number_color = INK; hl.symbol_color = INK; hl.function_color = INK; hl.member_variable_color = INK
	edit.syntax_highlighter = hl
	edit.text = str(Game.notes)
	edit.text_changed.connect(_on_typed)
	v.add_child(edit)
	_paint_headings()
	bottom = UI.hbox(8)
	status = UI.label("Saved", 18, Color(INK, 0.6))
	status.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	bottom.add_child(status)
	var grip := UI.label("◢", 40, Color("8a4b22"))   # drag the corner to make it bigger or smaller
	grip.size_flags_horizontal = Control.SIZE_SHRINK_END
	grip.mouse_filter = Control.MOUSE_FILTER_STOP
	grip.mouse_default_cursor_shape = Control.CURSOR_FDIAGSIZE
	grip.gui_input.connect(_grip_input)
	bottom.add_child(grip)
	v.add_child(bottom)
	mini = bool(_layout().get("mini", false))
	relayout()

# Over the page (an overlay: nothing else moves or shrinks). At first down the right-hand side under the top
# buttons; once she drags or resizes it, it stays where she put it (Game.settings.notes_layout), kept on screen.
func relayout() -> void:
	var w := clampf(main.W * 0.36, 420.0, 640.0)
	var r := Rect2(main.W - w - 14, 60, w, main.H - 74)
	var d := _layout()
	if d.has("w"):
		r = Rect2(float(d["x"]), float(d["y"]), float(d["w"]), float(d["h"]))
	r.size = Vector2(clampf(r.size.x, MIN_SIZE.x, main.W - 20), clampf(r.size.y, MIN_SIZE.y, main.H - 64))
	edit.visible = not mini
	bottom.visible = not mini
	mini_btn.text = "▢" if mini else "_"
	panel.size = Vector2(r.size.x, 1) if mini else r.size   # shrunk: as short as the title bar allows
	panel.position = Vector2(clampf(r.position.x, 0, main.W - panel.size.x), clampf(r.position.y, 58, maxf(58, main.H - panel.size.y)))

const MIN_SIZE := Vector2(460, 300)

func _layout() -> Dictionary:
	var d = Game.settings.get("notes_layout", {})
	return d if typeof(d) == TYPE_DICTIONARY else {}

func _save_layout() -> void:
	var h := panel.size.y if not mini else float(_layout().get("h", main.H - 74))
	Game.remember("notes_layout", {"x": panel.position.x, "y": panel.position.y, "w": panel.size.x, "h": h, "mini": mini})

func _title_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		dragging = e.pressed
		drag_off = get_global_mouse_position() - panel.global_position
		if not dragging:
			_save_layout()
	elif e is InputEventMouseMotion and dragging:
		var p := get_global_mouse_position() - drag_off
		panel.position = Vector2(clampf(p.x, 0, main.W - panel.size.x), clampf(p.y, 58, maxf(58, main.H - panel.size.y)))

func _grip_input(e: InputEvent) -> void:
	if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
		resizing = e.pressed
		if not resizing:
			_save_layout()
	elif e is InputEventMouseMotion and resizing:
		var m := get_global_mouse_position()
		panel.size = Vector2(clampf(m.x - panel.position.x + 20, MIN_SIZE.x, main.W - panel.position.x), clampf(m.y - panel.position.y + 20, MIN_SIZE.y, main.H - panel.position.y))

# _ shrinks the notepad to a small bar so the page underneath can be read; ▢ opens it full again.
func set_mini(on: bool) -> void:
	main.sfx("tap")
	if on and not mini:
		_save_layout()   # keep the full size to come back to
	mini = on
	var d := _layout().duplicate()   # only the flag changes: the full size she had is kept for when it opens again
	d["mini"] = mini
	Game.remember("notes_layout", d)
	relayout()
	if not mini:
		edit.grab_focus()

var _anim: Tween

# It pops out of the NOTES button (top right) with a little bounce, and shrinks back into it when closed.
func toggle(open: bool) -> void:
	if _anim and _anim.is_valid():
		_anim.kill()
	if open:
		visible = true
		edit.text = str(Game.notes)   # a Restore may have brought in other notes
		_paint_headings()
		relayout()
		panel.pivot_offset = Vector2(panel.size.x * 0.5, 0.0)   # from its top edge, wherever she has put it
		panel.scale = Vector2(0.2, 0.2)
		panel.modulate.a = 0.0
		_anim = create_tween().set_parallel(true)
		_anim.tween_property(panel, "scale", Vector2.ONE, 0.32).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		_anim.tween_property(panel, "modulate:a", 1.0, 0.18)
		edit.grab_focus()
		edit.set_caret_line(edit.get_line_count() - 1)
		edit.set_caret_column(edit.get_line(edit.get_line_count() - 1).length())
	else:
		_save_now()
		if not visible:
			return
		_anim = create_tween().set_parallel(true)
		_anim.tween_property(panel, "scale", Vector2(0.2, 0.2), 0.2).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		_anim.tween_property(panel, "modulate:a", 0.0, 0.2)
		_anim.chain().tween_callback(_closed)

func _closed() -> void:
	visible = false
	panel.scale = Vector2.ONE
	panel.modulate.a = 1.0

func _on_typed() -> void:
	_save_in = 0.8   # saved a moment after she stops typing
	status.text = "Saving..."
	_paint_headings()

const HEAD_BAND := Color("f2c14e")   # the gold of the game's buttons
const HEAD_INK := Color("8c2b3c")

# Every heading line gets the gold band (a line typed as "== something ==" counts too).
func _paint_headings() -> void:
	for i in edit.get_line_count():
		var t := edit.get_line(i).strip_edges()
		var head := t.begins_with("==") and t.ends_with("==") and t.length() > 4
		edit.set_line_background_color(i, HEAD_BAND if head else Color(0, 0, 0, 0))

func _process(delta: float) -> void:
	if _save_in < 0.0:
		return
	_save_in -= delta
	if _save_in <= 0.0:
		_save_now()

func _save_now() -> void:
	_save_in = -1.0
	if Game.notes != edit.text:
		Game.notes = edit.text
		Game.save_game()
	status.text = "Saved"

# 'Heading': the line she is on becomes a heading (gold band, dark red), or back to plain text if it already is one.
func _make_heading() -> void:
	main.sfx("tap")
	var i := edit.get_caret_line()
	var t := edit.get_line(i).strip_edges()
	if t.begins_with("==") and t.ends_with("==") and t.length() > 4:
		t = t.trim_prefix("==").trim_suffix("==").strip_edges()
	elif t == "":   # nothing typed yet: she types the heading first, then taps Heading
		status.text = "Type your heading first, then tap Heading."
		edit.grab_focus()
		return
	else:
		t = "== " + t + " =="
	edit.set_line(i, t)
	edit.set_caret_line(i)
	edit.set_caret_column(t.length())
	edit.grab_focus()
	_on_typed()
