extends Node
# Autoload "UI" - the look of the game: fonts, the Franuka 9-slice frames and buttons, text helpers,
# tables. Every screen builds its controls through these so the whole app matches the HTML prototype.
# If the Franuka pack is missing (it is not in the public repo), plain coloured StyleBoxFlat frames are used.

const RPG := "res://assets/rpg/"
const BODY_FONT := "res://assets/fonts/PixelifySans.ttf"
const DIGIT_FONT := "res://assets/fonts/VT323.ttf"      # Pixelify's 5 reads as S - digits come from VT323
const TITLE_FONT := "res://assets/rpg/fonts/rpg_title.ttf"
const TITLE_O_FONT := "res://assets/rpg/fonts/rpg_title_outline.ttf"

const DARK := Color("3e2731")
const LIGHT := Color("fff6e6")
const RED := Color("8c2b3c")
const BLUE := Color("33497a")
const BROWN := Color("6e3f33")
const GOLD := Color("f2c14e")
const GREEN := Color("1a804d")
const PAPER := Color("fff4d6")

var body_font: Font
var digit_font: Font
var title_font: Font
var title_o_font: Font
var has_pack := false
var compact := false   # set by Main when the phone is held sideways: slimmer banners
var _tex_cache: Dictionary = {}

func _ready() -> void:
	body_font = _load_font(BODY_FONT, "res://assets/font.ttf")
	digit_font = _load_font(DIGIT_FONT, BODY_FONT)
	title_font = body_font   # the RPG title font read badly; headings and name tags use the body font (title_o_font stays for battle shouts)
	title_o_font = _load_font(TITLE_O_FONT, TITLE_FONT)
	# Symbols the pixel fonts don't have (▶ ✓ ★ arrows, 📅 🔒 🍋): a phone fills them in from its own fonts, a browser
	# can't, so the game carries two free fonts for them - DejaVu Sans (its licence allows this) and Noto Emoji (OFL)
	var fb := []
	for p in ["res://assets/fonts/DejaVuSans.ttf", "res://assets/fonts/NotoEmoji.ttf"]:
		if ResourceLoader.exists(p):
			fb.append(load(p))
	for f in [body_font, digit_font, title_o_font]:
		if f is Font and fb.size():
			f.fallbacks = fb
	has_pack = ResourceLoader.exists(RPG + "BGbox_01A.png")
	var th := Theme.new()
	th.default_font = body_font
	th.default_font_size = 28
	get_tree().root.theme = th

func _load_font(path: String, fallback: String) -> Font:
	if ResourceLoader.exists(path):
		return load(path)
	if ResourceLoader.exists(fallback):
		return load(fallback)
	return ThemeDB.fallback_font

func tex(name: String) -> Texture2D:
	if _tex_cache.has(name):
		return _tex_cache[name]
	var p := RPG + name + ".png"
	var t: Texture2D = load(p) if ResourceLoader.exists(p) else null
	_tex_cache[name] = t
	return t

# ---------------------------------------------------------------- styleboxes
# 9-slice frame: slice 48 px all round (the pack's BGbox art), content inset so text never touches the frame.
func box_style(name: String, inset := Vector4(36, 40, 36, 36)) -> StyleBox:
	var t := tex(name)
	if t == null:
		var f := StyleBoxFlat.new()
		f.bg_color = Color("c9a97a") if name.begins_with("BGbox_0") else Color("3b3550")
		f.set_corner_radius_all(10)
		f.set_border_width_all(4)
		f.border_color = Color("2b1d2a")
		f.content_margin_left = inset.x; f.content_margin_top = inset.y; f.content_margin_right = inset.z; f.content_margin_bottom = inset.w
		return f
	var s := StyleBoxTexture.new()
	s.texture = t
	s.texture_margin_left = 48; s.texture_margin_top = 48; s.texture_margin_right = 48; s.texture_margin_bottom = 48
	s.content_margin_left = inset.x; s.content_margin_top = inset.y; s.content_margin_right = inset.z; s.content_margin_bottom = inset.w
	s.draw_center = true
	if name == "BGbox_01B":   # the pale lavender box read badly under light text: tinted a bold royal purple (her favourite)
		s.modulate_color = PURPLE_TINT
	return s

const PURPLE_TINT := Color(0.72, 0.45, 1.0)

# The same framed box drawn at half size (crisp pixel art, half as thick), for small cards that must fit many to a screen.
var _half := {}
func small_box(style_name: String, dark := true, inset := Vector4(20, 18, 20, 16)) -> PanelContainer:
	var p := box(style_name, dark, inset)
	var t := tex(style_name)
	if t != null:
		if not _half.has(style_name):
			var img := t.get_image()
			if img.is_compressed():
				img.decompress()
			img.resize(img.get_width() / 2, img.get_height() / 2, Image.INTERPOLATE_NEAREST)
			_half[style_name] = ImageTexture.create_from_image(img)
		var s := StyleBoxTexture.new()
		s.texture = _half[style_name]
		s.texture_margin_left = 24; s.texture_margin_top = 24; s.texture_margin_right = 24; s.texture_margin_bottom = 24
		s.content_margin_left = inset.x; s.content_margin_top = inset.y; s.content_margin_right = inset.z; s.content_margin_bottom = inset.w
		s.draw_center = true
		if style_name == "BGbox_01B":
			s.modulate_color = PURPLE_TINT
		p.add_theme_stylebox_override("panel", s)
	return p

# Buttons: slice 15 (top/bottom) and 24 (sides)
func button_style(code: String, state: String) -> StyleBox:
	var t := tex("Button_%s_%s" % [code, state])
	if t == null:
		var f := StyleBoxFlat.new()
		var colours := {"01A": Color("4f74b3"), "02A": Color("c8414b"), "03A": Color("f2c14e"), "04A": Color("8a8a8a"), "05A": Color("5a7fc0"), "06A": Color("c8414b")}
		f.bg_color = colours.get(code, Color("5a7fc0"))
		if state == "Pressed":
			f.bg_color = f.bg_color.darkened(0.2)
		elif state == "Selected":
			f.bg_color = f.bg_color.lightened(0.15)
		f.set_corner_radius_all(8)
		f.set_border_width_all(4)
		f.border_color = Color("2b1d2a")
		f.content_margin_left = 28; f.content_margin_right = 28; f.content_margin_top = 14; f.content_margin_bottom = 14
		return f
	var s := StyleBoxTexture.new()
	s.texture = t
	s.texture_margin_left = 24; s.texture_margin_right = 24; s.texture_margin_top = 15; s.texture_margin_bottom = 15
	s.content_margin_left = 28; s.content_margin_right = 28; s.content_margin_top = 14; s.content_margin_bottom = 14
	return s

func banner_style(name: String) -> StyleBox:
	var t := tex(name)
	if t == null:
		var f := StyleBoxFlat.new()
		f.bg_color = Color("f2c14e")
		f.set_corner_radius_all(12)
		f.set_border_width_all(4)
		f.border_color = Color("6e3f33")
		return f
	var s := StyleBoxTexture.new()
	s.texture = t
	s.texture_margin_left = 48; s.texture_margin_right = 48; s.texture_margin_top = 40; s.texture_margin_bottom = 40
	if name.begins_with("BannerMedium"):   # the yellow face sits above a shaded lower edge: lift the title onto the face (same overall size)
		s.content_margin_top = 28
		s.content_margin_bottom = 52
	elif name.begins_with("BannerSmall"):   # the name tags are only 48 px tall (yellow face on rows 9-29): slice to fit, name on the face
		s.texture_margin_left = 24; s.texture_margin_right = 24; s.texture_margin_top = 16; s.texture_margin_bottom = 24
		s.content_margin_left = 30; s.content_margin_right = 30; s.content_margin_top = 4; s.content_margin_bottom = 16
	return s

# ---------------------------------------------------------------- controls
# A framed panel with a vertical content box inside.
func box(style_name: String, dark := true, inset := Vector4(36, 40, 36, 36)) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", box_style(style_name, inset))
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", 10)
	v.set_meta("dark", dark)
	p.add_child(v)
	p.set_meta("content", v)
	return p

func content(p: PanelContainer) -> VBoxContainer:
	return p.get_meta("content")

func button(text: String, code := "05A", on_pressed: Callable = Callable(), light := true, size := 28) -> Button:
	var b := Button.new()
	b.text = text
	if code in ["03A", "04A"]:   # the gold and the pale grey buttons: dark text, light text barely showed on them
		light = false
	b.add_theme_stylebox_override("normal", button_style(code, "Normal"))
	b.add_theme_stylebox_override("hover", button_style(code, "Selected"))
	b.add_theme_stylebox_override("pressed", button_style(code, "Pressed"))
	b.add_theme_stylebox_override("focus", StyleBoxEmpty.new())
	b.add_theme_stylebox_override("disabled", button_style(code, "Normal"))
	b.add_theme_font_size_override("font_size", size)
	b.add_theme_color_override("font_color", LIGHT if light else DARK)
	b.add_theme_color_override("font_hover_color", LIGHT if light else DARK)
	b.add_theme_color_override("font_pressed_color", LIGHT if light else DARK)
	b.add_theme_color_override("font_disabled_color", Color(LIGHT, 0.5) if light else Color(DARK, 0.5))
	if light:
		b.add_theme_color_override("font_outline_color", Color("2b1d2a"))
		b.add_theme_constant_override("outline_size", 3)
	b.custom_minimum_size.y = 64
	b.autowrap_mode = TextServer.AUTOWRAP_OFF if text.length() <= 14 else TextServer.AUTOWRAP_WORD_SMART
	b.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if on_pressed.is_valid():
		b.pressed.connect(on_pressed)
	return b

func banner(text: String, name := "BannerMedium_02C", size := 40) -> PanelContainer:
	var p := PanelContainer.new()
	p.add_theme_stylebox_override("panel", banner_style(name))
	p.custom_minimum_size = Vector2(480, 80) if compact else Vector2(660, 96)
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	if name.begins_with("BannerSmall"):   # name tags (SENSEI OTTER, ZURU, monsters): dark text reads on the yellow
		l.add_theme_font_size_override("font_size", maxi(size, 28))
		l.add_theme_font_override("font", title_font)
		l.add_theme_color_override("font_color", DARK)
	else:   # big title banners: white with a thick dark outline so it stands off the yellow
		l.add_theme_font_override("font", body_font)   # clear letters; the thick outline below keeps it standing off the yellow
		l.add_theme_color_override("font_color", LIGHT)
		l.add_theme_color_override("font_outline_color", Color("2b1d2a"))
		l.add_theme_constant_override("outline_size", 8)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	p.add_child(l)
	p.set_meta("label", l)
	return p

# Rich text with the prototype's [b] markup and VT323 digits.
func rich(text: String, size := 28, dark := true, center := false) -> RichTextLabel:
	var r := RichTextLabel.new()
	r.bbcode_enabled = true
	r.fit_content = true
	r.scroll_active = false
	r.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.add_theme_font_size_override("normal_font_size", size)
	r.add_theme_font_size_override("bold_font_size", size)
	r.add_theme_font_size_override("italics_font_size", size)
	r.add_theme_font_override("normal_font", body_font)
	r.add_theme_font_override("bold_font", body_font)
	r.add_theme_font_override("italics_font", body_font)
	r.add_theme_color_override("default_color", DARK if dark else LIGHT)
	if not dark:
		r.add_theme_color_override("font_outline_color", Color("2b1d2a"))
		r.add_theme_constant_override("outline_size", 3)
	r.text = ("[center]" if center else "") + bb(text, size) + ("[/center]" if center else "")
	r.set_meta("base", text)
	return r

# Text that types itself out, like the battle dialogue (Sensei's messages, lesson pages, scroll answers).
# The label keeps its full size from the start, so nothing jumps. About 23 letters a second (3 times slower than
# it was - her reading pace), long pages finishing within 8.5 s.
func typed(text: String, size := 28, dark := true, center := false) -> RichTextLabel:
	return type_in(rich(text, size, dark, center))

func type_in(r: RichTextLabel) -> RichTextLabel:
	var n := plain(str(r.get_meta("base", r.text))).length()
	r.visible_ratio = 0.0
	var tw := create_tween()
	tw.tween_property(r, "visible_ratio", 1.0, clampf(n / 70.0 * 3.0, 0.9, 8.5))
	r.set_meta("typing", tw)
	return r

# Shows in full any text under root that is still typing. Returns true if there was some (so a tap only skips).
func finish_typing(root: Node) -> bool:
	var skipped := false
	for n in root.find_children("*", "RichTextLabel", true, false):
		if n.visible_ratio < 1.0:
			var tw = n.get_meta("typing", null)
			if tw is Tween and tw.is_valid():
				tw.kill()
			n.visible_ratio = 1.0
			skipped = true
	return skipped

# Calls on_tap when root is tapped (not swiped), so a page can be tapped through while it still scrolls.
func on_tap(root: Control, on_tap: Callable) -> void:
	for n in [root] + root.find_children("*", "Control", true, false):
		if not (n is BaseButton) and n.mouse_filter == Control.MOUSE_FILTER_STOP:
			n.mouse_filter = Control.MOUSE_FILTER_PASS
	root.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.button_index == MOUSE_BUTTON_LEFT:
			if e.pressed:
				root.set_meta("tap_at", e.global_position)
			elif root.has_meta("tap_at") and e.global_position.distance_to(root.get_meta("tap_at")) < 24:
				root.remove_meta("tap_at")
				on_tap.call())

func set_rich(r: RichTextLabel, text: String, size := 28, center := false) -> void:
	r.text = ("[center]" if center else "") + bb(text, size) + ("[/center]" if center else "")

# [b]/[i] markup -> BBCode; newlines kept; digit runs in VT323 at 125 % so 5 never looks like S.
func bb(text: String, size := 28) -> String:
	var s := text.replace("[b]", "[B]").replace("[/b]", "[/B]").replace("[i]", "[I]").replace("[/i]", "[/I]")
	s = s.replace("[", "\u0001").replace("]", "\u0002")   # hide any other brackets from the parser
	s = s.replace("\u0001B\u0002", "[b]").replace("\u0001/B\u0002", "[/b]").replace("\u0001I\u0002", "[i]").replace("\u0001/I\u0002", "[/i]")
	s = s.replace("\u0001", "[lb]").replace("\u0002", "[rb]")
	return nums(s, size)

func nums(s: String, size: int) -> String:
	if digit_font == body_font:
		return s
	var re := RegEx.new()
	re.compile("[0-9][0-9,.]*")
	var out := ""
	var last := 0
	var dsize := int(round(size * 1.25))
	for m in re.search_all(s):
		out += s.substr(last, m.get_start() - last)
		out += "[font=%s][font_size=%d]%s[/font_size][/font]" % [DIGIT_FONT, dsize, m.get_string()]
		last = m.get_end()
	out += s.substr(last)
	return out

func plain(text: String) -> String:
	return text.replace("[b]", "").replace("[/b]", "").replace("[i]", "").replace("[/i]", "")

func label(text: String, size := 24, color := DARK, center := false) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	# short words never wrap: in a tight row WORD_SMART would otherwise split "Lv 21" or "Learn" letter by letter
	l.autowrap_mode = TextServer.AUTOWRAP_OFF if (text != "" and text.length() <= 14) else TextServer.AUTOWRAP_WORD_SMART
	l.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	if center:
		l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	return l

func title_label(text: String, size := 30, color := RED) -> Label:
	var l := label(text, size, color)
	l.add_theme_font_override("font", title_font)
	return l

func scroll(child: Control) -> ScrollContainer:
	var sc := ScrollContainer.new()
	sc.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	sc.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER   # still scrolls by swiping; no bar
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	sc.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	child.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	sc.add_child(child)
	return sc

func vbox(sep := 10) -> VBoxContainer:
	var v := VBoxContainer.new()
	v.add_theme_constant_override("separation", sep)
	v.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return v

func hbox(sep := 8) -> HBoxContainer:
	var h := HBoxContainer.new()
	h.add_theme_constant_override("separation", sep)
	h.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return h

func spacer(h := 10) -> Control:
	var c := Control.new()
	c.custom_minimum_size.y = h
	return c

func line_edit(placeholder := "", numeric := true, size := 28) -> LineEdit:
	var e := LineEdit.new()
	e.placeholder_text = placeholder
	e.add_theme_font_size_override("font_size", size)
	e.add_theme_color_override("font_color", DARK)
	e.add_theme_color_override("font_placeholder_color", BROWN)
	var sb := StyleBoxFlat.new()
	sb.bg_color = PAPER
	sb.set_border_width_all(3)
	sb.border_color = BROWN
	sb.set_corner_radius_all(6)
	sb.content_margin_left = 10; sb.content_margin_right = 10; sb.content_margin_top = 6; sb.content_margin_bottom = 6
	e.add_theme_stylebox_override("normal", sb)
	e.add_theme_stylebox_override("focus", sb)
	if numeric:
		e.virtual_keyboard_type = LineEdit.KEYBOARD_TYPE_NUMBER_DECIMAL
	e.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return e

func option(items: Array, placeholder := "Select...") -> OptionButton:
	var o := OptionButton.new()
	o.add_item(placeholder, -1)
	for i in items.size():
		o.add_item(str(items[i]), i)
	o.add_theme_font_size_override("font_size", 24)
	o.add_theme_color_override("font_color", DARK)
	var sb := StyleBoxFlat.new()
	sb.bg_color = PAPER
	sb.set_border_width_all(3)
	sb.border_color = BROWN
	sb.set_corner_radius_all(6)
	sb.content_margin_left = 8; sb.content_margin_right = 8
	o.add_theme_stylebox_override("normal", sb)
	o.add_theme_stylebox_override("hover", sb)
	o.add_theme_stylebox_override("pressed", sb)
	o.add_theme_stylebox_override("focus", sb)
	return o

# Progress bar in the pack's slider art (or a flat one).
func bar(fraction: float, w := 300.0, h := 30.0) -> ProgressBar:
	var p := ProgressBar.new()
	p.min_value = 0; p.max_value = 1; p.value = clamp(fraction, 0.0, 1.0)
	p.show_percentage = false
	p.custom_minimum_size = Vector2(w, h)
	var bg := StyleBoxFlat.new()
	bg.bg_color = Color("3b3550")
	bg.set_corner_radius_all(8)
	bg.set_border_width_all(3)
	bg.border_color = Color("2b1d2a")
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("5fc07a") if fraction > 0.5 else (Color("f2c14e") if fraction > 0.25 else Color("c8414b"))
	fill.set_corner_radius_all(8)
	p.add_theme_stylebox_override("background", bg)
	p.add_theme_stylebox_override("fill", fill)
	return p

func set_bar(p: ProgressBar, fraction: float) -> void:
	p.value = clamp(fraction, 0.0, 1.0)
	var fill := StyleBoxFlat.new()
	fill.bg_color = Color("5fc07a") if fraction > 0.5 else (Color("f2c14e") if fraction > 0.25 else Color("c8414b"))
	fill.set_corner_radius_all(8)
	p.add_theme_stylebox_override("fill", fill)

# Lesson / Section B table: {cols: [...], rows: [{c: [...], s: step, b: bold}]}.
# step: only rows with s <= step are shown (worked examples). blanks: Callable(key) -> Control for "#key" cells.
func table(t: Dictionary, step := -1, blanks: Callable = Callable()) -> Control:
	var cols: Array = t.get("cols", [])
	var grid := GridContainer.new()
	grid.columns = cols.size()
	grid.add_theme_constant_override("h_separation", 0)
	grid.add_theme_constant_override("v_separation", 0)
	grid.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var num_col := []
	for ci in cols.size():
		var all_num := ci > 0
		for r in t.get("rows", []):
			var c: Array = r.get("c", [])
			var v := str(c[ci]) if ci < c.size() else ""
			if not (_is_num(v) or v.begins_with("#")):
				all_num = false
		num_col.append(all_num)
	for ci in cols.size():
		grid.add_child(_cell(str(cols[ci]), true, num_col[ci], false, false))
	for r in t.get("rows", []):
		if step >= 0 and r.has("s") and int(r["s"]) > step:
			continue
		var bold: bool = bool(r.get("b", false))
		var fresh: bool = step >= 0 and r.has("s") and int(r["s"]) == step
		var c: Array = r.get("c", [])
		for ci in cols.size():
			var v := str(c[ci]) if ci < c.size() else ""
			if blanks.is_valid() and v.begins_with("#"):
				var cell := PanelContainer.new()
				cell.add_theme_stylebox_override("panel", _cell_style(false, fresh))
				cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				var ctrl: Control = blanks.call(v.substr(1))
				cell.add_child(ctrl)
				grid.add_child(cell)
			else:
				grid.add_child(_cell(v, false, _is_num(v), bold, fresh))
	return grid

func _is_num(v: String) -> bool:
	if v.is_empty():
		return true
	var re := RegEx.new()
	re.compile("^[0-9,.()%\\s-]*$")
	return re.search(v) != null

func _cell_style(header: bool, fresh: bool) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = BROWN if header else (Color("ffe39a") if fresh else PAPER)
	s.border_color = Color("e2c49a")
	s.border_width_top = 0 if header else 2
	s.content_margin_left = 8; s.content_margin_right = 8; s.content_margin_top = 5; s.content_margin_bottom = 5
	return s

func _cell(text: String, header: bool, num: bool, bold: bool, fresh: bool) -> Control:
	var cell := PanelContainer.new()
	cell.add_theme_stylebox_override("panel", _cell_style(header, fresh))
	cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	var r := RichTextLabel.new()
	r.bbcode_enabled = true
	r.fit_content = true
	r.scroll_active = false
	r.autowrap_mode = TextServer.AUTOWRAP_OFF if num else TextServer.AUTOWRAP_WORD_SMART
	r.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	r.add_theme_font_size_override("normal_font_size", 24)
	r.add_theme_font_size_override("bold_font_size", 24)
	r.add_theme_color_override("default_color", PAPER if header else DARK)
	var body := bb(text, 24)
	if bold or header:
		body = "[b]" + body + "[/b]"
	if num:
		body = "[right]" + body + "[/right]"
	r.text = body
	cell.add_child(r)
	return cell

# Sprite with optional hue rotation (the one monster image, recoloured per chapter).
func sprite(path: String, w: float, h: float, hue_deg := 0.0) -> TextureRect:
	var tr := TextureRect.new()
	if ResourceLoader.exists(path):
		tr.texture = load(path)
	tr.custom_minimum_size = Vector2(w, h)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_SCALE
	tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	if hue_deg != 0.0:
		var sh := ShaderMaterial.new()
		sh.shader = _hue_shader()
		sh.set_shader_parameter("shift", fmod(hue_deg, 360.0) / 360.0)
		tr.material = sh
	return tr

var _hue: Shader = null
func _hue_shader() -> Shader:
	if _hue == null:
		_hue = Shader.new()
		_hue.code = """
shader_type canvas_item;
uniform float shift = 0.0;
vec3 hsv2rgb(vec3 c) { vec4 K = vec4(1.0, 2.0/3.0, 1.0/3.0, 3.0); vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www); return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y); }
vec3 rgb2hsv(vec3 c) { vec4 K = vec4(0.0, -1.0/3.0, 2.0/3.0, -1.0); vec4 p = c.g < c.b ? vec4(c.bg, K.wz) : vec4(c.gb, K.xy); vec4 q = c.r < p.x ? vec4(p.xyw, c.r) : vec4(c.r, p.yzx); float d = q.x - min(q.w, q.y); float e = 1.0e-10; return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x); }
void fragment() { vec4 c = texture(TEXTURE, UV); vec3 h = rgb2hsv(c.rgb); h.x = fract(h.x + shift); COLOR = vec4(hsv2rgb(h), c.a); }
"""
	return _hue

# Gradient background for a screen.
func gradient_bg(top: Color, mid: Color, bottom: Color) -> TextureRect:
	var g := Gradient.new()
	g.offsets = PackedFloat32Array([0.0, 0.5, 1.0])
	g.colors = PackedColorArray([top, mid, bottom])
	var gt := GradientTexture2D.new()
	gt.gradient = g
	gt.fill_from = Vector2(0, 0)
	gt.fill_to = Vector2(0, 1)
	gt.width = 8
	gt.height = 256
	var tr := TextureRect.new()
	tr.texture = gt
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_SCALE
	tr.set_anchors_preset(Control.PRESET_FULL_RECT)
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	tr.z_index = -2   # backgrounds sit behind the theme snow/leaves (z -1); boxes and text stay above both
	return tr

func icon(name: String, size := 30.0) -> TextureRect:
	var tr := TextureRect.new()
	var t := tex(name)
	if t:
		tr.texture = t
	tr.custom_minimum_size = Vector2(size, size)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	tr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	return tr

func clear(n: Node) -> void:
	for c in n.get_children():
		n.remove_child(c)
		c.queue_free()

func hm(minutes: int) -> String:
	if minutes >= 60:
		return "%dh%s" % [minutes / 60, (" %dm" % (minutes % 60)) if minutes % 60 else ""]
	return "%d min" % minutes

func hhmmss(sec: float) -> String:
	var s := int(max(0.0, round(sec)))
	return "%02d:%02d:%02d" % [s / 3600, (s / 60) % 60, s % 60]
