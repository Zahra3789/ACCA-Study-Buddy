extends Control
# Zuru, animated, for anywhere she appears outside the home banner (lessons, battles, the Section B boss).
# She is never idle: a breath in her stance, then every few seconds a quick-draw, a slash or a trick with an item.
# act("happy") / act("sad") play a reaction at once. With boxed = true she stands in her own little framed window.
#   var z = ZuruLive.make(150, 120, true)

const FW := 200          # frames are re-cut by tools/make_zuru.gd: 200 x 112, facing right,
const FH := 112          # her body centred at x = 100 and her feet at y = 96
const FEET := 96
const BODY := 66.0       # roughly head-to-feet in a frame, in pixels
const ANIMS := [["idle", "zuru_idle", 8.0, true], ["quick", "zuru_quick", 18.0, false], ["slash", "zuru_slash", 26.0, false],
		["item", "zuru_item", 16.0, false], ["hurt", "zuru_hurt", 14.0, false]]
const MOVES := ["quick", "slash", "item"]
const SHEET := {"idle": "zuru_idle", "quick": "zuru_quick", "slash": "zuru_slash", "item": "zuru_item", "hurt": "zuru_hurt",
		"run": "zuru_run", "relax": "zuru_relax", "jump": "zuru_jump", "walk": "zuru_walk", "roll": "zuru_roll"}

static var _frames: SpriteFrames

var boxed := false
var spr: AnimatedSprite2D
var hat: Sprite2D
var _wait := 0.0

static func make(w: float, h: float, in_box := false) -> Control:
	var z = load("res://scripts/ZuruLive.gd").new()
	z.custom_minimum_size = Vector2(w, h)
	z.size = Vector2(w, h)
	z.boxed = in_box
	return z

static func frames() -> SpriteFrames:
	if _frames == null:
		_frames = SpriteFrames.new()
		_frames.remove_animation("default")
		for a in ANIMS:
			var path := "res://assets/characters/%s.png" % a[1]
			if not ResourceLoader.exists(path):
				continue
			var sheet: Texture2D = load(path)
			_frames.add_animation(a[0])
			_frames.set_animation_speed(a[0], a[2])
			_frames.set_animation_loop(a[0], a[3])
			for i in sheet.get_width() / FW:
				var at := AtlasTexture.new()
				at.atlas = sheet
				at.region = Rect2(i * FW, 0, FW, FH)
				_frames.add_frame(a[0], at)
	return _frames

# ---------------------------------------------------------------- theme hats
# Where her head is in each frame of a sheet: the top of her dark hair near the middle of the frame. A theme
# hat (Santa at Christmas, a witch's hat at Halloween) sits there, so it stays on through every move.
static var _heads := {}

static func head(sheet: String, f: int) -> Vector2:
	if not _heads.has(sheet):
		var found := []
		var p := "res://assets/characters/%s.png" % sheet
		if ResourceLoader.exists(p):
			var im: Image = load(p).get_image()
			if im.is_compressed():
				im.decompress()
			im.convert(Image.FORMAT_RGBA8)
			for fr in im.get_width() / FW:
				var at := Vector2(101, 43)
				var done := false
				for y in FH:
					for x in range(fr * FW + 70, fr * FW + 130):
						var c := im.get_pixel(x, y)
						if c.a > 0.5 and c.get_luminance() < 0.3:
							at = Vector2(x - fr * FW, y)
							done = true
							break
					if done:
						break
				found.append(at)
		_heads[sheet] = found
	var list: Array = _heads[sheet]
	return list[f] if f < list.size() else Vector2(101, 43)

# The hat for the theme that is on, or null.
static func hat_tex() -> Texture2D:
	var t := str(Game.settings.get("theme", "off"))
	var p := "res://assets/xmas/hat_santa.png" if t == "xmas" else ("res://assets/xmas/hat_witch.png" if t == "halloween" else "")
	return load(p) if p != "" and ResourceLoader.exists(p) else null

# Put hat (a Sprite2D child of the animated sprite) on her head for the frame showing. origin = where the frame's
# top-left corner is in the sprite's own coordinates.
static func place_hat(hat: Sprite2D, s: AnimatedSprite2D, sheet: String, origin: Vector2) -> void:
	var t := hat_tex()
	hat.visible = t != null
	if t == null:
		return
	hat.texture = t
	var h := head(sheet, s.frame)
	hat.position = origin + h + Vector2(1, 5 - t.get_height() / 2.0)   # brim just above her eyes

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	clip_contents = boxed
	spr = AnimatedSprite2D.new()
	spr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	spr.sprite_frames = frames()
	spr.centered = false
	add_child(spr)
	hat = Sprite2D.new()
	hat.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	hat.visible = false
	spr.add_child(hat)
	spr.animation_finished.connect(_idle)
	resized.connect(_place)
	_place()
	_idle()

# Feet on the floor of the control, body centred, filling her box (a long slash may run past its edge).
func _place() -> void:
	if spr == null:
		return
	var s := (size.y - 12.0) * 1.08 / BODY if boxed else size.y * 0.9 / BODY   # room above her head for a theme hat
	spr.scale = Vector2(s, s)
	spr.position = Vector2(size.x / 2.0 - FW / 2.0 * s, size.y - (8.0 if boxed else 0.0) - FEET * s)
	queue_redraw()

func _draw() -> void:
	if not boxed:
		return
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.1, 0.07, 0.12, 0.55)
	sb.border_color = Color("f2c14e")
	sb.set_border_width_all(3)
	sb.set_corner_radius_all(12)
	draw_style_box(sb, Rect2(Vector2.ZERO, size))

func _idle() -> void:
	_wait = randf_range(1.8, 3.6)
	_play("idle")

func _process(delta: float) -> void:
	if spr == null:
		return
	place_hat(hat, spr, SHEET.get(str(spr.animation), "zuru_idle"), Vector2.ZERO)
	if spr.animation != "idle":
		return
	_wait -= delta
	if _wait <= 0.0:
		_play(MOVES[randi() % MOVES.size()])

func _play(a: String) -> void:
	if spr and spr.sprite_frames.has_animation(a):
		spr.play(a)

# A reaction from the game: a right answer gets a quick-draw, a wrong one a flinch.
func act(mood: String) -> void:
	match mood:
		"happy": _play("quick")
		"sad": _play("hurt")
		_: _idle()
