extends Control
# The moving banner on the title and home screens: Zuru walks on while LyniaDesign's Tiny Pixel Japan scenery
# scrolls past in parallax layers (sky, clouds, Fuji, hills, blossoms, house, pagoda, trees, path, grass),
# tinted through dawn, day, sunset and night. Every so often he stops to do something active - chops a pile of
# branches, lights a campfire and drills beside it (mostly at night), or practises sword strikes - with a little
# speech bubble. Art: the Japan pack in assets/scenery (not in the public repo), Ninja Adventure props and
# effects (CC0), Zuru from the samurai pack sheets. The clock and the walk are static, so they carry on when
# the screen is rebuilt or you move between title and home.

const CYCLE := 120.0          # seconds for a whole day and night
const WALK_SPEED := 60.0      # px/s along the path
const FRAME := 96
const CAMP := 12.0            # seconds at a campfire: chop wood for the first 2.5, then the fire burns
const SCENE_H := 180.0        # the scenery layers are 353 x 180
const PATH_Y := 158.0         # where feet go on the path, in scenery pixels
# [layer file, how fast it scrolls compared with the path, repeat every n tiles]: far away moves slowly, the path
# at walking pace; single landmarks (Fuji, the pagoda, the house) are spaced out so they don't line up in pairs
const LAYERS := [["Sky", 0.0, 1], ["Clouds", 0.04, 1], ["Fuji", 0.02, 4], ["Mountain_Back", 0.08, 1], ["Mountain_Middle", 0.15, 1],
	["Mountain_Front", 0.25, 1], ["BackgroundTrees", 0.35, 1], ["Shrine_Multiple", 0.45, 3], ["House", 0.55, 2], ["Trees", 0.7, 1], ["Ground", 1.0, 1]]
const FRONT := ["Gras", 1.25]   # drawn over Zuru's feet

static var clock := 0.3       # 0 dawn .. 0.5 sunset .. 1 next dawn
static var near := 0.0        # how far he has walked
static var state := "walk"
static var state_t := 0.0     # seconds left in the current state
static var thing := ""        # "logs" or "fire" left on the path; it scrolls away once he walks on
static var thing_x := 0.0     # where it stands (path coordinates)
static var bubble := ""

var speed := WALK_SPEED
var zuru: AnimatedSprite2D
var front: Node2D
var tex := {}
var rng := RandomNumberGenerator.new()

# colour the whole scene is tinted with through the day: [time, tint]
const TINT := [[0.00, Color(1.0, 0.82, 0.8)], [0.10, Color(1, 1, 1)], [0.42, Color(1, 1, 1)], [0.52, Color(1.0, 0.72, 0.55)],
	[0.60, Color(0.42, 0.42, 0.7)], [0.90, Color(0.32, 0.36, 0.62)], [1.00, Color(1.0, 0.82, 0.8)]]

func _ready() -> void:
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	if state_t <= 0.0:
		state_t = rng.randf_range(14.0, 20.0)
	for l in LAYERS + [FRONT]:
		var p := "res://assets/scenery/%s.png" % l[0]
		if ResourceLoader.exists(p):
			tex[l[0]] = load(p)
	for f in ["branch", "wood_chips", "slash_curved", "campfire"]:
		var p := "res://assets/fx/%s.png" % f
		if ResourceLoader.exists(p):
			tex[f] = load(p)
	zuru = AnimatedSprite2D.new()
	zuru.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	var frames := SpriteFrames.new()
	frames.remove_animation("default")
	for anim in [["run", "zuru_run", 14.0], ["attack", "zuru_attack1", 13.0]]:
		var path := "res://assets/characters/%s.png" % anim[1]
		if not ResourceLoader.exists(path):
			continue
		var sheet: Texture2D = load(path)
		frames.add_animation(anim[0])
		frames.set_animation_speed(anim[0], anim[2])
		frames.set_animation_loop(anim[0], anim[0] != "attack")
		for i in sheet.get_width() / FRAME:
			var at := AtlasTexture.new()
			at.atlas = sheet
			at.region = Rect2(i * FRAME, 0, FRAME, FRAME)
			frames.add_frame(anim[0], at)
	zuru.sprite_frames = frames
	add_child(zuru)
	front = Node2D.new()   # grass, wood chips, sword trails and the bubble go over Zuru
	front.draw.connect(_draw_front)
	add_child(front)
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
	# chops firewood with his sword, lights a fire and drills beside it; by day he practises his strikes.
	thing_x = near + _zx() + 120.0   # a little ahead of him, clear of his sword
	if _night() or (clock > 0.45 and rng.randf() < 0.7):
		state = "camp"; state_t = CAMP; thing = "logs"
		bubble = "Firewood!"
	else:
		state = "train"; state_t = 6.0; thing = ""
		bubble = ["Hyah!", "Again!", "Focus. Strike."][rng.randi() % 3]
	_play("attack")

func _zx() -> float:
	return size.x * 0.32

func _k() -> float:
	return size.y / SCENE_H

func _ground() -> float:
	return PATH_Y * _k()

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
	speed = move_toward(speed, WALK_SPEED if state == "walk" else 0.0, delta * 90.0)
	if state != "walk" and speed < 1.0 and zuru.animation == "run":
		_play("attack")
	near += speed * delta
	var s := _k() * 2.15   # big enough to stand out against the blossom trees
	zuru.scale = Vector2(s, s)
	zuru.position = Vector2(_zx(), _ground() - 32.0 * s)
	zuru.modulate = _tint().lerp(Color.WHITE, 0.35)   # lit a little more than the scenery so he stays readable
	queue_redraw()
	front.queue_redraw()

# ---------------------------------------------------------------- drawing
func _tint() -> Color:
	for i in TINT.size() - 1:
		var a: Array = TINT[i]; var b: Array = TINT[i + 1]
		if clock >= a[0] and clock <= b[0]:
			return a[1].lerp(b[1], (clock - a[0]) / (b[0] - a[0]))
	return TINT[0][1]

# one parallax layer, repeated across the width and scrolled by how far he has walked
func _layer(canvas: CanvasItem, name: String, speed_k: float, extra := 0.0, rep := 1) -> void:
	if not tex.has(name):
		return
	var k := _k()
	var w := 353.0 * k
	var period := w * rep
	var off := fposmod(near * speed_k + extra, period)
	var x := -off
	while x < size.x:
		canvas.draw_texture_rect(tex[name], Rect2(x, 0, w, size.y), false, _tint())
		x += period

func _draw() -> void:
	if tex.is_empty():
		draw_rect(Rect2(Vector2.ZERO, size), Color("2a1e2e"))
		return
	for l in LAYERS:
		_layer(self, l[0], l[1], Time.get_ticks_msec() / 1000.0 * 4.0 if l[0] == "Clouds" else 0.0, l[2])
		if l[0] == "Sky" and _night():   # a few stars on the night sky
			var a := clampf(1.0 - absf(clock - 0.75) / 0.2, 0.0, 1.0)
			for i in 30:
				var sx := fposmod(fposmod(sin(i * 12.9898) * 43758.5453, 1.0) * size.x * 1.2 - near * 0.01, size.x)
				var sy := fposmod(sin(i * 78.233) * 12345.678, 1.0) * size.y * 0.45
				draw_rect(Rect2(floor(sx), floor(sy), 2, 2), Color(1, 1, 0.9, a * (0.5 + 0.5 * sin(Time.get_ticks_msec() / 400.0 + i))))
	if thing != "":
		if thing_x - near < -160.0:
			thing = ""   # scrolled off the left edge
		else:
			_thing(thing_x - near)

# things on the path: a pile of branches being chopped, then the campfire
func _thing(x: float) -> void:
	var k := _k()
	var g := _ground()
	var t := Time.get_ticks_msec() / 1000.0
	if tex.has("branch"):
		for i in 3:   # a small pile of the Ninja Adventure branches
			draw_texture_rect(tex["branch"], Rect2(x + i * 9.0 * k - 6.0 * k, g - (10.0 + (i % 2) * 5.0) * k, 16.0 * k, 16.0 * k), false, _tint())
	if thing != "fire":
		return
	var size_k := clampf(minf(state_t / 1.5, (CAMP - 2.5 - state_t) / 1.0), 0.0, 1.0) if state == "camp" else 0.0
	if size_k <= 0.0:
		return
	draw_circle(Vector2(x + 10.0 * k, g - 10.0 * k), 34.0 * k * size_k, Color(1.0, 0.6, 0.25, 0.18))
	if tex.has("campfire"):
		var ct: Texture2D = tex["campfire"]
		var n := maxi(1, ct.get_width() / ct.get_height())
		var fw := float(ct.get_width()) / n
		var f := int(t * 8.0) % n
		var h := ct.get_height() * k * 1.4 * size_k
		draw_texture_rect_region(ct, Rect2(x - 2.0 * k, g - h, fw / ct.get_height() * h, h), Rect2(f * fw, 0, fw, ct.get_height()))
	else:   # no campfire sprite yet: simple flames
		for i in 5:
			var fh := (5.0 + 3.0 * sin(t * 9.0 + i * 1.7)) * size_k * k * 3.0
			draw_rect(Rect2(x + i * 4.0 * k, g - 6.0 * k - fh, 4.0 * k, fh), Color("ff8a2a"))
			draw_rect(Rect2(x + i * 4.0 * k, g - 6.0 * k - fh * 0.6, 4.0 * k, fh * 0.6), Color("ffd34e"))

# over Zuru: foreground grass, flying wood chips while chopping, sword trails while drilling, the bubble
func _draw_front() -> void:
	if tex.is_empty():
		return
	var k := _k()
	var g := _ground()
	var swinging := zuru.animation == "attack" and zuru.frame >= 3
	if swinging and state == "camp" and thing == "logs" and tex.has("wood_chips"):
		var wt: Texture2D = tex["wood_chips"]
		var n := maxi(1, wt.get_width() / wt.get_height())
		var fw := float(wt.get_width()) / n
		var f := clampi(zuru.frame - 3, 0, n - 1)
		var x := thing_x - near
		front.draw_texture_rect_region(wt, Rect2(x, g - 26.0 * k, 22.0 * k, 22.0 * k), Rect2(f * fw, 0, fw, wt.get_height()), _tint())
	if swinging and state == "train" and tex.has("slash_curved"):
		var st: Texture2D = tex["slash_curved"]
		var f := clampi(zuru.frame - 3, 0, 3)
		front.draw_texture_rect_region(st, Rect2(_zx() + 14.0 * k, g - 46.0 * k, 40.0 * k, 40.0 * k), Rect2(f * 32, 0, 32, 32))
	var gt: Texture2D = tex.get(FRONT[0])
	if gt:
		var w := 353.0 * k
		var x := -fposmod(near * FRONT[1], w)
		while x < size.x:
			front.draw_texture_rect(gt, Rect2(x, 0, w, size.y), false, _tint())
			x += w
	if bubble != "" and state != "walk":
		_bubble(bubble)

func _bubble(text: String) -> void:
	var font := UI.body_font if UI.body_font else ThemeDB.fallback_font
	var fs := 18
	var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var bx := clampf(_zx() - tw / 2.0, 6.0, size.x - tw - 26.0)
	var by := maxf(4.0, _ground() - 33.0 * zuru.scale.y - 46.0)   # just above his head
	front.draw_rect(Rect2(bx - 4, by - 4, tw + 28, 34), Color("2b1d2a"))
	front.draw_rect(Rect2(bx - 2, by - 2, tw + 24, 30), Color("fff4d6"))
	front.draw_rect(Rect2(_zx() - 4, by + 28, 8, 8), Color("fff4d6"))
	front.draw_string(font, Vector2(bx + 10, by + 20), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("3e2731"))
