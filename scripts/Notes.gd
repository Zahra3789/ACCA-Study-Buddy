extends Control
# The notepad (web / laptop only - her phone has no NOTES button): a sheet down the right-hand side to write
# notes on while she reads (laid over the page), as she has no pen and paper to hand. It stays open across screens, saves as she
# types (Game.notes, so Backup / Restore carry it too). "Heading" turns the line she is on into a heading (a gold
# band) and "+ Lesson" drops in where she is (chapter and lesson), so the notes follow the book.

var main: Node
var panel: PanelContainer
var edit: TextEdit
var status: Label
var _save_in := -1.0   # seconds until the typing is saved, -1 = nothing waiting

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
	sb.border_color = Color("6b3fa0")   # her favourite purple
	sb.border_width_left = 5   # a single purple edge against the page; no dark shadow or gap round it
	sb.corner_radius_top_left = 14; sb.corner_radius_bottom_left = 14
	sb.content_margin_left = 22; sb.content_margin_right = 22; sb.content_margin_top = 18; sb.content_margin_bottom = 18
	panel.add_theme_stylebox_override("panel", sb)
	add_child(panel)
	var v := UI.vbox(10)
	panel.add_child(v)
	var top := UI.hbox(8)
	var t := UI.title_label("NOTEPAD", 28, Color("6b3fa0"))
	t.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	top.add_child(t)
	var mk := UI.button("Heading", "03A", _make_heading, false, 20)   # this line <-> a heading
	mk.size_flags_horizontal = Control.SIZE_SHRINK_END
	mk.custom_minimum_size = Vector2(130, 52)
	top.add_child(mk)
	var head := UI.button("+ Lesson", "05A", _add_heading, true, 20)   # a heading for where she is
	head.size_flags_horizontal = Control.SIZE_SHRINK_END
	head.custom_minimum_size = Vector2(130, 52)
	top.add_child(head)
	var close := UI.button("Close", "04A", func(): toggle(false), false, 20)
	close.size_flags_horizontal = Control.SIZE_SHRINK_END
	close.custom_minimum_size = Vector2(110, 52)
	top.add_child(close)
	v.add_child(top)
	edit = TextEdit.new()
	edit.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	edit.placeholder_text = "Write anything here while you study - it saves as you type.\n\n'Heading' turns the line you are on into a heading.\n'+ Lesson' adds the chapter and lesson you are on."
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
	status = UI.label("Saved", 18, Color(INK, 0.6))
	v.add_child(status)
	relayout()

# Over the right-hand side of the page (an overlay: nothing else moves or shrinks), under the top buttons.
func relayout() -> void:
	var w := clampf(main.W * 0.36, 420.0, 640.0)
	panel.position = Vector2(main.W - w, 52)   # flush to the right edge, just under the top buttons
	panel.size = Vector2(w, main.H - 52)

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
		panel.pivot_offset = Vector2(panel.size.x - 90.0, 0.0)   # under the NOTES button
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

# A heading for where she is: the chapter and lesson when reading one, otherwise the screen.
func _add_heading() -> void:
	main.sfx("tap")
	var h := "Notes"
	if main.cur_screen == "lesson":
		var c = main.get_ch(int(main.book.L["chId"]))
		var l: Dictionary = c["lessons"][int(main.book.L["li"])]
		h = "Ch %d %s - Lesson %d: %s" % [int(main.book.L["chId"]), c["title"], int(main.book.L["li"]) + 1, l["title"]]
	elif main.cur_screen == "book":
		var c = main.get_ch(int(main.book.book_sel))
		h = "Ch %d %s" % [int(main.book.book_sel), c["title"]]
	elif main.cur_screen == "battle":
		h = "Battle notes"
	var add := ("" if edit.text.strip_edges() == "" else "\n\n") + "== " + h + " ==\n"
	edit.text = edit.text.rstrip("\n ") + add if edit.text.strip_edges() != "" else add
	_paint_headings()
	edit.grab_focus()
	edit.set_caret_line(edit.get_line_count() - 1)
	edit.set_caret_column(0)
	_save_in = 0.3

# 'Heading': the line she is on becomes a heading (gold band, dark red), or back to plain text if it already is one.
func _make_heading() -> void:
	main.sfx("tap")
	var i := edit.get_caret_line()
	var t := edit.get_line(i).strip_edges()
	if t.begins_with("==") and t.ends_with("==") and t.length() > 4:
		t = t.trim_prefix("==").trim_suffix("==").strip_edges()
	elif t == "":
		t = "== New heading =="
	else:
		t = "== " + t + " =="
	edit.set_line(i, t)
	edit.set_caret_line(i)
	edit.set_caret_column(t.length())
	edit.grab_focus()
	_on_typed()
