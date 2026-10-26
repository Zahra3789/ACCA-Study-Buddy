extends Control
# The moving banner on the title and home screens: Zuru walks on while the world scrolls past in layers
# (mountains, trees and shrines, the path), through dawn, day, sunset and a starry night. Every so often he
# stops to do something active - chops firewood and drills by a campfire (mostly at night) or spars with a straw dummy - with a
# little speech bubble. Scenery is drawn in code as chunky pixels; Zuru uses the samurai pack's sheets
# (assets/characters/zuru_*.png, made by tools/make_zuru.gd). The clock and the walk are static, so they carry
# on when the screen is rebuilt or you move between title and home.

const P := 4.0                # one scenery "pixel"
const CYCLE := 120.0          # seconds for a whole day and night
const WALK_SPEED := 60.0      # px/s along the path
const FRAME := 96
const CAMP := 12.0            # seconds at a campfire: chop wood for the first 2.5, then the fire burns

static var clock := 0.3       # 0 dawn .. 0.5 sunset .. 1 next dawn
static var far := 0.0         # how far each layer has scrolled
static var mid := 0.0
static var near := 0.0
static var state := "walk"
static var state_t := 0.0     # seconds left in the current state
static var thing := ""        # "fire" or "dummy" left on the path; it scrolls away once he walks on
static var thing_x := 0.0     # where it stands (near-layer coordinates)
static var bubble := ""

var speed := WALK_SPEED
var zuru: AnimatedSprite2D
var rng := RandomNumberGenerator.new()

# sky colours through the day: [time, top, bottom]
const SKY := [
	[0.00, Color("6c5aa8"), Color("ffc8a0")], [0.10, Color("5fa8e8"), Color("d8f0ff")],
	[0.42, Color("4f9be0"), Color("cdeeff")], [0.52, Color("8a4f9e"), Color("ff9a5c")],
	[0.60, Color("1c1f4a"), Color("51406e")], [0.90, Color("0f1430"), Color("2a2a55")],
	[1.00, Color("6c5aa8"), Color("ffc8a0")]]

func _ready() -> void:
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if state_t <= 0.0:
		state_t = rng.randf_range(14.0, 20.0)
	zuru = AnimatedSprite2D.new()
	zuru.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var frames := SpriteFrames.new()
	frames.remove_animation("default")
	for anim in [["run", "zuru_run", 14.0], ["attack", "zuru_attack1", 13.0]]:
		var path := "res://assets/characters/%s.png" % anim[1]
		if not ResourceLoader.exists(path):
			continue
		var tex: Texture2D = load(path)
		frames.add_animation(anim[0])
		frames.set_animation_speed(anim[0], anim[2])
		frames.set_animation_loop(anim[0], anim[0] != "attack")
		for i in tex.get_width() / FRAME:
			var at := AtlasTexture.new()
			at.atlas = tex
			at.region = Rect2(i * FRAME, 0, FRAME, FRAME)
			frames.add_frame(anim[0], at)
	zuru.sprite_frames = frames
	add_child(zuru)
	zuru.animation_finished.connect(_on_anim_done)
	_play("run" if state == "walk" else "attack")

func _play(a: String) -> void:
	if zuru.sprite_frames.has_animation(a) and (zuru.animation != a or not zuru.is_playing()):
		zuru.play(a)

func _on_anim_done() -> void:
	if state in ["train", "camp"]:   # swing, a breath, swing again - never just standing
		get_tree().create_timer(0.35).timeout.connect(func():
			if is_instance_valid(zuru) and state in ["train", "camp"]:
				zuru.play("attack"))

# ---------------------------------------------------------------- what Zuru is doing
func _night() -> bool:
	return clock > 0.5 and clock < 0.95

func _next_state() -> void:
	if state != "walk":
		state = "walk"
		state_t = rng.randf_range(16.0, 26.0)
		bubble = ""
		_play("run")
		return
	# Every stop is something active (she doesn't like characters standing idle): evenings and nights he
	# chops firewood with his sword, lights a fire and drills beside it; by day he spars with a straw dummy.
	thing_x = near + _zx() + 120.0   # a little ahead of him, clear of his sword
	if _night() or (clock > 0.45 and rng.randf() < 0.7):
		state = "camp"; state_t = CAMP; thing = "logs"
		bubble = "Firewood!"
	else:
		state = "train"; state_t = 6.0; thing = "dummy"
		bubble = ["Hyah!", "Again!", "Focus. Strike."][rng.randi() % 3]
	_play("attack")

func _zx() -> float:
	return size.x * 0.32

func _process(delta: float) -> void:
	if not is_visible_in_tree():
		return
	clock = fmod(clock + delta / CYCLE, 1.0)
	state_t -= delta
	if state == "camp" and thing == "logs" and state_t < CAMP - 2.5:   # wood chopped: light the fire
		thing = "fire"
		bubble = ["Drills by the fire.", "Debits by the fire...", "The stars balance too.", "One more chapter!"][rng.randi() % 4]
	if state_t <= 0.0:
		_next_state()
	var target := WALK_SPEED if state == "walk" else 0.0
	speed = move_toward(speed, target, delta * 90.0)
	if state != "walk" and speed < 1.0 and zuru.animation == "run":
		_play("attack")
	far += speed * 0.12 * delta
	mid += speed * 0.45 * delta
	near += speed * delta
	var s := clampf(size.y / 230.0, 0.6, 1.4) * 2.6
	zuru.scale = Vector2(s, s)
	zuru.position = Vector2(_zx(), _ground() - 32.0 * s)
	queue_redraw()

func _ground() -> float:
	return size.y - 30.0

# ---------------------------------------------------------------- drawing
func _sky() -> Array:
	for i in SKY.size() - 1:
		var a: Array = SKY[i]; var b: Array = SKY[i + 1]
		if clock >= a[0] and clock <= b[0]:
			var k: float = (clock - a[0]) / (b[0] - a[0])
			return [a[1].lerp(b[1], k), a[2].lerp(b[2], k)]
	return [SKY[0][1], SKY[0][2]]

# 1 at midday, 0 in the dead of night - darkens the scenery
func _light() -> float:
	return clampf(sin(clock * TAU - PI * 0.1) * 1.4 + 0.45, 0.0, 1.0)

func _shade(c: Color) -> Color:
	return c.lerp(Color("141631"), (1.0 - _light()) * 0.6)

func _px(x: float, y: float, w: float, h: float, c: Color) -> void:
	draw_rect(Rect2(floor(x / P) * P, floor(y / P) * P, w * P, h * P), c)

func _hash(n: int) -> float:
	return fposmod(sin(n * 12.9898) * 43758.5453, 1.0)

func _draw() -> void:
	var w := size.x
	var h := size.y
	var g := _ground()
	var sky := _sky()
	var bands := 12
	for i in bands:   # stepped gradient, like old pixel skies
		draw_rect(Rect2(0, h * i / bands, w, h / bands + 1), sky[0].lerp(sky[1], float(i) / (bands - 1)))
	var light := _light()
	if light < 0.45:   # stars
		for i in 40:
			var sx := fposmod(_hash(i) * w * 1.3 - far * 0.2, w)
			var sy := _hash(i + 99) * (g - 70)
			var tw := 0.5 + 0.5 * sin(Time.get_ticks_msec() / 400.0 + i)
			draw_rect(Rect2(floor(sx), floor(sy), 3, 3), Color(1, 1, 0.9, (0.45 - light) * 2.0 * tw))
	# sun by day, moon by night, travelling across the sky
	var day := clock < 0.55
	var arc := (clock / 0.55) if day else ((clock - 0.55) / 0.45)
	var bx := lerpf(-30.0, w + 30.0, arc)
	var by := g - 60.0 - sin(arc * PI) * (g - 80.0)
	if day:
		_px(bx - 14, by - 14, 7, 7, Color("ffe39a")); _px(bx - 10, by - 18, 5, 9, Color("ffe39a")); _px(bx - 18, by - 10, 9, 5, Color("ffe39a"))
	else:
		_px(bx - 12, by - 12, 6, 6, Color("f2f4ff")); _px(bx - 4, by - 12, 3, 4, sky[0])
	# far mountains
	var mc := _shade(Color("6d7fb5").lerp(Color("4b5d8a"), 0.3))
	for x in range(0, int(w) + int(P), int(P)):
		var wx := (x + far) * 0.02
		var mh := 40.0 + 26.0 * sin(wx) + 14.0 * sin(wx * 2.3 + 1.0) + 8.0 * sin(wx * 5.1)
		draw_rect(Rect2(x, g - 18 - mh, P, mh + 18), mc)
		if mh > 62.0:   # snow caps
			draw_rect(Rect2(x, g - 18 - mh, P, 6), _shade(Color("eef3ff")))
	# middle layer: trees, cherry blossoms, torii gates, stone lanterns
	var step := 110.0
	var first := int(floor(mid / step)) - 1
	for n in range(first, first + int(w / step) + 3):
		var kind := int(_hash(n) * 5.0)
		var x := n * step - mid + _hash(n + 7) * 50.0
		match kind:
			0, 1: _pine(x, g)
			2: _cherry(x, g)
			3: _torii(x, g)
			4: _lantern(x, g)
	# the path
	draw_rect(Rect2(0, g, w, h - g), _shade(Color("6b8e3a")))
	draw_rect(Rect2(0, g + 8, w, h - g - 8), _shade(Color("b08a5a")))
	for n in range(int(floor(near / 37.0)) - 1, int(floor(near / 37.0)) + int(w / 37.0) + 2):
		var tx := n * 37.0 - near
		_px(tx, g - P, 1, 1, _shade(Color("8fc25b"))); _px(tx + P, g - 2 * P, 1, 2, _shade(Color("8fc25b")))
		if _hash(n) > 0.6:
			_px(tx + 12, g + 16, 2, 1, _shade(Color("8c6a44")))
	if thing != "":
		if thing_x - near < -140.0:
			thing = ""   # scrolled off the left edge
		else:
			_thing(thing_x - near, g)
	if bubble != "" and state != "walk":
		_bubble(bubble)

func _pine(x: float, g: float) -> void:
	var c := _shade(Color("2f6b4f")); var t := _shade(Color("5a3a2a"))
	_px(x + 8, g - 16, 2, 4, t)
	for i in 4:
		_px(x + 6 - i * 4 + 4, g - 20 - (3 - i) * 10 - 10, 2 + i * 2, 3, c)

func _cherry(x: float, g: float) -> void:
	var c := _shade(Color("f2a3c4")); var c2 := _shade(Color("e07aa5")); var t := _shade(Color("6b4232"))
	_px(x + 10, g - 22, 2, 6, t)
	_px(x, g - 40, 10, 5, c); _px(x + 4, g - 48, 7, 3, c); _px(x + 2, g - 30, 4, 2, c2); _px(x + 22, g - 36, 3, 2, c2)

func _torii(x: float, g: float) -> void:
	var r := _shade(Color("c8414b")); var d := _shade(Color("2b1d2a"))
	_px(x, g - 58, 16, 2, d); _px(x + 4, g - 50, 10, 1, r); _px(x + 2, g - 54, 13, 2, r)
	_px(x + 6, g - 48, 2, 12, r); _px(x + 26, g - 48, 2, 12, r)

func _lantern(x: float, g: float) -> void:
	# a stone toro, centred on cx: base, post, light box with a window, roof and cap
	var s := _shade(Color("8d8f9c")); var d := _shade(Color("6a6c78"))
	var cx := x + 12.0
	_px(cx - 12, g - 8, 6, 2, d); _px(cx - 4, g - 24, 2, 4, s); _px(cx - 8, g - 36, 4, 3, s)
	_px(cx - 12, g - 40, 6, 1, d); _px(cx - 4, g - 44, 2, 1, d)
	var glow := 1.0 - _light()
	_px(cx - 4, g - 32, 2, 1, Color(1.0, 0.8, 0.4, glow) if glow > 0.2 else _shade(Color("3a3a48")))
	if glow > 0.2:   # lit at night
		draw_circle(Vector2(cx, g - 30), 28.0, Color(1.0, 0.75, 0.35, glow * 0.15))

# the campfire or straw dummy he stops at
func _thing(x: float, g: float) -> void:
	var t := Time.get_ticks_msec() / 1000.0
	if thing == "dummy":   # straw training dummy; it wobbles when struck
		var st := _shade(Color("e2c46a")); var post := _shade(Color("6b4232"))
		var wob := sin(t * 18.0) * 3.0 if (state == "train" and zuru.animation == "attack" and zuru.frame >= 3) else 0.0
		_px(x + 8, g - 20, 2, 5, post); _px(x + wob, g - 44, 6, 6, st); _px(x - 4 + wob, g - 36, 10, 2, st)
		return
	if thing == "logs":   # chopping firewood on a stump; chips fly when the blade lands
		var bark := _shade(Color("6b4232")); var cut := _shade(Color("d8b07a"))
		_px(x, g - 8, 6, 2, bark); _px(x + 2, g - 16, 2, 2, bark); _px(x + 2, g - 12, 2, 1, cut)
		if zuru.animation == "attack" and zuru.frame >= 3:
			for i in 3:
				var k := fposmod(t * 2.5 + i * 0.3, 1.0)
				_px(x + 6 + i * 6 + k * 20.0, g - 20 - sin(k * PI) * 26.0, 1, 1, cut)
		return
	# campfire: logs stay behind; the flames grow as it is lit and die down before he leaves
	var size_k := clampf(minf(state_t / 1.5, (CAMP - 2.5 - state_t) / 1.0), 0.0, 1.0) if (state == "camp" and thing == "fire") else 0.0
	_px(x - 4, g - 4, 8, 1, _shade(Color("5a3a2a"))); _px(x - 2, g - 8, 2, 1, _shade(Color("6b4232"))); _px(x + 8, g - 8, 2, 1, _shade(Color("6b4232")))
	if size_k <= 0.0:
		return
	draw_circle(Vector2(x + 12, g - 16), 46.0 * size_k, Color(1.0, 0.6, 0.25, 0.18))
	for i in 5:   # flickering flames
		var fh := (5.0 + 3.0 * sin(t * 9.0 + i * 1.7)) * size_k
		var fx := x - 2 + i * 4.0
		_px(fx, g - 8 - fh * P, 1, fh, Color("ff8a2a"))
		_px(fx, g - 8 - fh * P * 0.6, 1, fh * 0.6, Color("ffd34e"))
	for i in 4:   # embers drifting up
		var k := fposmod(t * 0.6 + i * 0.25, 1.0)
		_px(x + 8 + sin(t * 3.0 + i) * 10.0, g - 30 - k * 60.0, 1, 1, Color(1, 0.7, 0.3, 1.0 - k))

func _bubble(text: String) -> void:
	var font := UI.body_font if UI.body_font else ThemeDB.fallback_font
	var fs := 18
	var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var bx := clampf(_zx() - tw / 2.0, 6.0, size.x - tw - 26.0)
	var by := _ground() - 32.0 * zuru.scale.y * 2.0 - 10.0
	draw_rect(Rect2(bx - 4, by - 4, tw + 28, 34), Color("2b1d2a"))
	draw_rect(Rect2(bx - 2, by - 2, tw + 24, 30), Color("fff4d6"))
	draw_rect(Rect2(_zx() - 4, by + 28, 8, 8), Color("fff4d6"))
	draw_string(font, Vector2(bx + 10, by + 20), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("3e2731"))
