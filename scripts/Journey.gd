extends Control
# The moving banner on the title and home screens: Zuru runs on while LyniaDesign's Tiny Pixel Japan scenery
# scrolls past in parallax layers (sky, clouds, Fuji, hills, blossoms, house, pagoda, trees, path, grass),
# tinted through dawn, day, sunset and night. Rocks come along the path and she takes each one with a move: a
# leaping jump, a double jump, or a quick-draw dash that slices through it. Every so often she stops: in the
# evening and at night she sets a log on a stump, chops it into a woodpile, lights a campfire with a spark from
# her hand and rests by it until it burns down; by day she practises quick-draw strikes. Every step plays out
# in order (dust and smoke puffs, things growing in) rather than popping in and out.
# Art: the Japan pack in assets/scenery, Zuru from MtPixls' Samurai Character Pack (re-cut by tools/make_zuru.gd
# with warm brown skin) - neither is in the public repo; Ninja Adventure stump / log / woodpile / rock / smoke /
# embers / wood chips / cut (CC0) and ArlanTR's campfire (CC0).
# The clock, the walk and the current activity are static, so they carry on between title and home.

const CYCLE := 120.0          # seconds for a whole day and night
const FW := 200              # frame size of the re-cut sheets (tools/make_zuru.gd)
const FH := 112
const FEET := 96.0           # her feet line in those frames
const SCENE_H := 180.0        # the scenery layers are 353 x 180
const PATH_Y := 158.0         # where feet go on the path, in scenery pixels
const SCALE := 1.35           # her size compared with the scenery (body ~55 px in the re-cut frames)
const STRIDE := 80.0          # path speed per unit of her scale, matched to her run so her feet don't slide
# [layer file, how fast it scrolls compared with the path, repeat every n tiles]: far away moves slowly, the path
# at walking pace; single landmarks (Fuji, the pagoda, the house) are spaced out so they don't line up in pairs
const LAYERS := [["Sky", 0.0, 1], ["Clouds", 0.04, 1], ["Fuji", 0.02, 4], ["Mountain_Back", 0.08, 1], ["Mountain_Middle", 0.15, 1],
	["Mountain_Front", 0.25, 1], ["BackgroundTrees", 0.35, 1], ["Shrine_Multiple", 0.45, 3], ["House", 0.55, 2], ["Trees", 0.7, 1], ["Ground", 1.0, 1]]
const FRONT := ["Gras", 1.25]   # drawn over Zuru's feet

# the campfire stop, in seconds from when he stops
const SET := 0.8              # stump and log appear (dust puff)
const CHOP := 4.2             # chopping until here: three strikes split the log onto the woodpile
const LIGHT := 4.9            # the fire catches (smoke puff)
const SIT_END := 15.0         # sitting by the fire until here; then it burns down and he stands
const CAMP := 16.5

static var clock := 0.3       # 0 dawn .. 0.5 sunset .. 1 next dawn
static var near := 0.0        # how far he has run
static var state := "walk"    # walk / camp / train
static var state_t := 0.0     # seconds left in the current state
static var camp_x := 0.0      # where the campsite is (path coordinates); it scrolls away once he runs on
static var camp_on := false
static var rock_x := -1.0     # the next rock on the path (path coordinates), -1 = none
static var next_rock := 6.0   # seconds of running before the next rock rolls in
static var rock_move := ""    # the move for the coming rock (never the same twice running)
static var bubble := ""
static var last_stop := ""  # the last daytime stop, so the next one is different

var speed := 0.0
var chops := 0
var move := ""               # the move she is doing over a rock: jump / double / dash
var move_t := -1.0           # seconds into it, -1 = running normally
var jumped_twice := false
var smash := []              # [path x, time] of the last rock he sliced, for the cut effect
var puffs := []               # [x, y, born] smoke puffs, path coordinates
var zuru: AnimatedSprite2D
var front: Node2D
var hat: Sprite2D
const ZL := preload("res://scripts/ZuruLive.gd")
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
	for f in ["stump", "log", "log_pile", "rock", "smoke", "embers", "wood_chips", "cutx", "campfire", "lantern"]:
		var p := "res://assets/fx/%s.png" % f
		if ResourceLoader.exists(p):
			tex[f] = load(p)
	for f in ["tree", "present", "pumpkin", "bat"]:   # the theme pieces along the path
		var p := "res://assets/xmas/%s.png" % f
		if ResourceLoader.exists(p):
			tex["x_" + f] = load(p)
	zuru = AnimatedSprite2D.new()
	zuru.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	zuru.offset = Vector2(0, FEET - FH / 2.0) * -1.0   # frames are re-cut with her feet at y = 96: the node sits on her feet
	var frames := SpriteFrames.new()
	frames.remove_animation("default")
	# [name, sheet, frames per second, loops]: run, quick-draw slash (training, dash), big slash (chopping),
	# use item (sparks that light the fire), relax (calm by the fire), jump (rocks)
	# + idle (standing in her stance, taking in the view) and walk (a slow stroll)
	for anim in [["run", "zuru_run", 16.0, true], ["quick", "zuru_quick", 18.0, false], ["slash", "zuru_slash", 32.0, false],
			["item", "zuru_item", 18.0, false], ["relax", "zuru_relax", 6.0, true], ["jump", "zuru_jump", 24.0, false],
			["idle", "zuru_idle", 8.0, true], ["walk", "zuru_walk", 10.0, true]]:
		var path := "res://assets/characters/%s.png" % anim[1]
		if not ResourceLoader.exists(path):
			continue
		var sheet: Texture2D = load(path)
		frames.add_animation(anim[0])
		frames.set_animation_speed(anim[0], anim[2])
		frames.set_animation_loop(anim[0], anim[3])
		for i in sheet.get_width() / FW:
			var at := AtlasTexture.new()
			at.atlas = sheet
			at.region = Rect2(i * FW, 0, FW, FH)
			frames.add_frame(anim[0], at)
	zuru.sprite_frames = frames
	add_child(zuru)
	hat = Sprite2D.new()   # Santa / witch hat when a theme is on (ZuruLive.place_hat keeps it on her head)
	hat.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	hat.visible = false
	zuru.add_child(hat)
	front = Node2D.new()   # grass, wood chips, embers, puffs and the bubble go over Zuru
	front.draw.connect(_draw_front)
	add_child(front)
	zuru.animation_finished.connect(_on_anim_done)
	var p := _camp_phase()
	_play("run" if state == "walk" else ("relax" if p == "sit" else ("slash" if p == "chop" else "quick")))

func _play(a: String) -> void:
	if zuru.sprite_frames.has_animation(a) and (zuru.animation != a or not zuru.is_playing()):
		zuru.play(a)

# Attacks don't loop: swing, a breath, swing again. Each finished slash while chopping splits the log further.
func _on_anim_done() -> void:
	if _camp_phase() == "chop" and zuru.animation == "slash":
		chops = mini(chops + 1, 3)
		if chops == 3:
			bubble = "That'll do."
	# drills mix quick-draws and big slashes; a trick is the item move again; chopping is slash after slash
	var again := ""
	match state:
		"train": again = "slash" if zuru.animation == "quick" else "quick"
		"trick": again = "item"
		"camp": again = "slash" if _camp_phase() == "chop" else ""
	if again != "":
		var was := state
		get_tree().create_timer(0.4 if state == "trick" else 0.2).timeout.connect(func():
			if is_instance_valid(zuru) and state == was and (state != "camp" or _camp_phase() == "chop"):
				zuru.play(again))

# ---------------------------------------------------------------- what Zuru is doing
func _night() -> bool:
	return clock > 0.5 and clock < 0.95

func _elapsed() -> float:
	return CAMP - state_t

func _camp_phase() -> String:
	if state != "camp":
		return ""
	var e := _elapsed()
	if e < SET: return "set"
	if e < CHOP: return "chop"
	if e < LIGHT: return "light"
	if e < SIT_END: return "sit"
	return "out"

func _next_state() -> void:
	if state != "walk":
		state = "walk"
		state_t = rng.randf_range(12.0, 20.0)
		bubble = ""
		_play("run")
		return
	if _night() or (clock > 0.45 and rng.randf() < 0.7):
		state = "camp"; state_t = CAMP; chops = 0
		var s := _k() * SCALE
		camp_x = near + _zx() + 40.0 * _k() + speed * speed / (2.0 * STRIDE * s * 2.5)   # right in front of where she stops
		camp_on = true
		_puff(camp_x + 4.0 * _k(), _ground())
		bubble = "Firewood!"
		_play("run")   # she slows to a stop, then starts chopping
	else:   # by day: a different stop from last time - sword drills, a pause to take in the view, an item trick, a stroll
		var opts := ["train", "pause", "trick", "stroll"].filter(func(o): return o != last_stop)
		state = opts[rng.randi() % opts.size()]
		last_stop = state
		match state:
			"train":
				state_t = 6.0
				bubble = ["Hyah!", "Again!", "Focus. Strike."][rng.randi() % 3]
				_play("quick")
			"pause":
				state_t = 4.5
				bubble = ["What a view.", "Breathe in...", "Hmm. Accruals.", "One more chapter."][rng.randi() % 4]
				_play("idle")
			"trick":
				state_t = 4.5
				bubble = ["Watch this!", "Ta-da!"][rng.randi() % 2]
				_play("item")
			"stroll":
				state_t = 7.0
				bubble = ""
				_play("walk")

func _zx() -> float:
	return size.x * 0.32

func _k() -> float:
	return size.y / SCENE_H

func _ground() -> float:
	return PATH_Y * _k()

func _puff(x: float, y: float) -> void:
	puffs.append([x, y, Time.get_ticks_msec() / 1000.0])

func _end_move() -> void:
	move = ""; move_t = -1.0; jumped_twice = false
	if state == "walk":
		_play("run")

func _process(delta: float) -> void:
	if not is_visible_in_tree():
		return
	clock = fmod(clock + delta / CYCLE, 1.0)
	var phase_before := _camp_phase()
	state_t -= delta
	var phase := _camp_phase()
	if phase != phase_before:
		match phase:
			"chop": _play("slash")
			"light":   # a spark from her hand lights it
				_play("item")
				_puff(camp_x + 42.0 * _k(), _ground())
				bubble = ""
			"sit":
				_play("relax")
				bubble = ["A fine night.", "Debits by the fire...", "The stars balance too.", "Rest, then one more chapter."][rng.randi() % 4]
			"out":
				_puff(camp_x + 42.0 * _k(), _ground())
				bubble = ""
	if state_t <= 0.0:
		_next_state()
	var s := _k() * SCALE   # big enough to stand out against the blossom trees
	var target := STRIDE * s if state == "walk" else (STRIDE * s * 0.45 if state == "stroll" else 0.0)   # a stroll is under half running pace
	speed = move_toward(speed, target, delta * STRIDE * s * 2.5)
	if state == "stroll" and zuru.animation != "walk":
		_play("walk")
	if state == "walk" and zuru.animation != "run":
		_play("run")
	near += speed * delta
	# rocks roll in from the right while she runs; for each one she does a move - never the same twice running
	if state == "walk":
		next_rock -= delta
		if rock_x < 0.0 and next_rock <= 0.0 and move_t < 0.0:
			rock_x = near + size.x + 20.0
			next_rock = rng.randf_range(9.0, 15.0)   # rocks now and then - not all jumping
			var moves := ["jump", "double", "dash"].filter(func(m): return m != rock_move)
			rock_move = moves[rng.randi() % moves.size()]
	var k := _k()
	if rock_x >= 0.0:
		var rx := rock_x - near
		var reach: float = {"jump": 60.0, "double": 50.0, "dash": 100.0}.get(rock_move, 50.0) * k
		if move_t < 0.0 and rx < _zx() + reach and rx > _zx() - 10.0 and state == "walk":
			move = rock_move; move_t = 0.0
			if move == "dash":
				zuru.play("quick")
				_puff(near + _zx() - 20.0 * k, _ground())
			else:
				zuru.play("jump")
				_puff(near + _zx(), _ground())
		if move == "dash" and move_t >= 0.0 and rx < _zx() + 16.0 * k:   # the blade goes through it: it shatters
			_puff(rock_x, _ground())
			smash = [rock_x, Time.get_ticks_msec() / 1000.0]
			rock_x = -1.0
		elif rx < -40.0:
			rock_x = -1.0
	var lift := 0.0
	if move_t >= 0.0:
		move_t += delta
		match move:
			"jump":   # her acrobatic spinning leap, carried in an arc over the rock
				var p := clampf(move_t / 0.95, 0.0, 1.0)
				lift = sin(p * PI) * 34.0 * k
				if p >= 1.0: _end_move()
			"double":   # a hop, then the spinning leap again off a puff of air, higher
				if move_t < 0.4:
					lift = sin(move_t / 0.55 * PI) * 22.0 * k
				else:
					var p := clampf((move_t - 0.4) / 0.95, 0.0, 1.0)
					var h0 := sin(0.4 / 0.55 * PI) * 22.0 * k
					if not jumped_twice:
						jumped_twice = true
						zuru.play("jump")
						_puff(near + _zx(), _ground() - h0)
					lift = h0 * (1.0 - p) + sin(p * PI) * 36.0 * k
					if p >= 1.0: _end_move()
			"dash":   # a burst of speed with after-images, the quick-draw slicing through the rock
				near += STRIDE * s * 2.4 * delta
				if move_t > 0.5: _end_move()
	zuru.scale = Vector2(s, s)
	zuru.position = Vector2(_zx(), _ground() - lift)   # the node sits on her feet
	zuru.modulate = _tint().lerp(Color.WHITE, 0.35)   # lit a little more than the scenery so he stays readable
	ZL.place_hat(hat, zuru, ZL.SHEET.get(str(zuru.animation), "zuru_run"), Vector2(-FW / 2.0, -FEET))
	if camp_on and camp_x - near < -200.0:
		camp_on = false   # the campsite has scrolled off the left edge
	queue_redraw()
	front.queue_redraw()

# ---------------------------------------------------------------- drawing
func _tint() -> Color:
	for i in TINT.size() - 1:
		var a: Array = TINT[i]; var b: Array = TINT[i + 1]
		if clock >= a[0] and clock <= b[0]:
			return a[1].lerp(b[1], (clock - a[0]) / (b[0] - a[0]))
	return TINT[0][1]

# one parallax layer, repeated across the width and scrolled by how far he has run
func _layer(canvas: CanvasItem, name: String, speed_k: float, extra := 0.0, rep := 1) -> void:
	if not tex.has(name):
		return
	var k := _k()
	var w := 353.0 * k
	var period := w * rep
	var off := fposmod(near * speed_k + extra, period)
	var x := -off
	var tint := _layer_tint(name)
	while x < size.x:
		canvas.draw_texture_rect(tex[name], Rect2(x, 0, w, size.y), false, tint)
		x += period

# ---------------------------------------------------------------- themes
# Christmas: the blossom trees, hills and path go snowy white, Christmas trees and presents stand along the path,
# and snow falls in front. Halloween: a purple dusk, jack-o'-lanterns and glowing red paper lanterns along the path,
# and bats flit across the sky. (The THEME button; off = the normal blossom walk.)
const SNOWY := ["Trees", "BackgroundTrees", "Ground", "Gras", "Mountain_Front", "Mountain_Middle", "Mountain_Back", "Fuji", "House", "Shrine_Multiple"]

func _theme() -> String:
	var t := str(Game.settings.get("theme", "off"))
	return t if t in ["xmas", "halloween"] else ""

func _layer_tint(name: String) -> Color:
	var t := _tint()
	match _theme():
		"xmas":
			if name in SNOWY:   # brightened past white: pink blossom and grass read as snow
				return t * Color(1.5, 1.85, 1.95)
		"halloween":
			return t * (Color(0.7, 0.5, 0.95) if name in ["Sky", "Clouds"] else Color(0.78, 0.62, 0.9))
	return t

# The theme's pieces, spaced along the path so they scroll past with it.
func _theme_props() -> void:
	var th := _theme()
	if th == "":
		return
	var k := _k()
	var period := (430.0 if th == "xmas" else 360.0) * k
	var first := int(floor((near - 120.0 * k) / period))
	var last := int(ceil((near + size.x + 120.0 * k) / period))
	for i in range(first, last + 1):
		var x := i * period + 150.0 * k - near
		if th == "xmas":
			_prop("x_tree", x, k * 2.2)
			if posmod(i, 2) == 0:
				_prop("x_present", x + 24.0 * k, k * 1.6)
				_prop("x_present", x - 22.0 * k, k * 1.3)
		else:
			_prop("x_pumpkin", x, k * 1.4)
			if posmod(i, 2) == 1 and tex.has("lantern"):   # a red paper lantern glowing on a pole
				var lx := x + 70.0 * k
				var top := _ground() - 46.0 * k
				draw_line(Vector2(lx, _ground()), Vector2(lx, top), Color("3b2a2a"), maxf(2.0, 2.0 * k))
				draw_circle(Vector2(lx, top - 6.0 * k), 16.0 * k, Color(1.0, 0.45, 0.2, 0.22 + 0.06 * sin(Time.get_ticks_msec() / 300.0 + i)))
				var ls := 16.0 * k * 1.2
				draw_texture_rect_region(tex["lantern"], Rect2(lx - ls / 2.0, top - ls + 4.0 * k, ls, ls), Rect2(0, (int(Time.get_ticks_msec() / 220.0) % 4) * 16, 16, 16))

# In front of everything: snowflakes at Christmas, bats at Halloween.
func _theme_front() -> void:
	var th := _theme()
	var now := Time.get_ticks_msec() / 1000.0
	if th == "xmas":
		for i in 40:
			var r1 := fposmod(sin(i * 12.9898) * 43758.5453, 1.0)
			var r2 := fposmod(sin(i * 78.233) * 12345.678, 1.0)
			var y := fposmod(r2 * size.y + now * (18.0 + r1 * 22.0), size.y)
			var x := fposmod(r1 * size.x * 1.3 + sin(now * 0.8 + i) * 10.0 - near * 0.15, size.x)
			var s: float = 2.0 + floor(r1 * 3.0)
			front.draw_rect(Rect2(floor(x), floor(y), s, s), Color(1, 1, 1, 0.85))
	elif th == "halloween" and tex.has("x_bat"):
		for i in 3:
			var r1 := fposmod(sin(i * 3.7 + 1.0) * 43758.5453, 1.0)
			var x := size.x - fposmod(now * (40.0 + r1 * 30.0) + r1 * size.x, size.x + 80.0)
			var y := size.y * (0.12 + 0.22 * r1) + sin(now * 5.0 + i) * 8.0
			var flap := absf(sin(now * 9.0 + i)) > 0.5
			front.draw_texture_rect(tex["x_bat"], Rect2(x, y, 16.0 * 2.4, (8.0 if flap else 5.0) * 2.4), false)

# a sprite standing on the path at screen x, its bottom on the ground, grown in by g (0..1)
func _prop(name: String, x: float, scale_k: float, grow := 1.0, lift := 0.0) -> void:
	if not tex.has(name) or grow <= 0.0:
		return
	var t: Texture2D = tex[name]
	var w := t.get_width() * scale_k * grow
	var h := t.get_height() * scale_k * grow
	draw_texture_rect(t, Rect2(x - w / 2.0, _ground() - h - lift, w, h), false, _tint())

# one frame of a strip of square frames
func _frame(canvas: CanvasItem, name: String, f: int, rect: Rect2, tint := Color.WHITE) -> void:
	if not tex.has(name):
		return
	var t: Texture2D = tex[name]
	var fh := float(t.get_height())
	var n := maxi(1, int(t.get_width() / fh))
	canvas.draw_texture_rect_region(t, rect, Rect2((f % n) * fh, 0, fh, fh), tint)

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
	_theme_props()
	if camp_on:
		_campsite(camp_x - near)
	if rock_x >= 0.0:
		_prop("rock", rock_x - near, _k() * 1.6)
	if move == "dash" and move_t >= 0.0 and zuru.sprite_frames:   # after-images trailing the dash
		var ft: Texture2D = zuru.sprite_frames.get_frame_texture(zuru.animation, zuru.frame)
		var fw := FW * zuru.scale.x
		var fh := FH * zuru.scale.y
		var cy := zuru.position.y + zuru.offset.y * zuru.scale.y   # the frame's centre
		for i in range(3, 0, -1):
			var gx := zuru.position.x - i * 26.0 * _k()
			draw_texture_rect(ft, Rect2(gx - fw / 2.0, cy - fh / 2.0, fw, fh), false, Color(0.6, 0.8, 1.0, 0.45 - i * 0.12))

# stump with a log on it, the woodpile filling up, and the fire - each grown in, in order
func _campsite(x: float) -> void:
	var k := _k()
	var e := _elapsed() if state == "camp" else CAMP
	var grow := clampf(e / SET, 0.0, 1.0)
	_prop("stump", x, k * 1.1, grow)
	var stump_h := 28.0 * k * 1.1
	if e < CHOP:   # the log on the stump: whole, then split apart a little more with every chop
		var gap := chops * 3.0 * k
		if chops == 0:
			_prop("log", x, k * 2.2, grow, stump_h - 4.0 * k)
		elif chops < 3:
			_prop("log", x - gap, k * 1.6, 1.0, stump_h - 4.0 * k)
			_prop("log", x + gap, k * 1.6, 1.0, stump_h - 4.0 * k)
	var pile := clampf(float(chops) / 3.0, 0.0, 1.0) if e < CHOP else 1.0
	_prop("log_pile", x + 88.0 * k, k * 1.3, pile)
	# the campfire: catches at LIGHT, burns while he sits, dies down after SIT_END
	var fire := 0.0
	if e >= CHOP:
		fire = clampf((e - CHOP) / (LIGHT - CHOP), 0.0, 1.0)
		if e > SIT_END:
			fire = clampf(1.0 - (e - SIT_END) / (CAMP - SIT_END), 0.0, 1.0)
	var fx := x + 46.0 * k
	if state == "camp" and fire > 0.0:
		draw_circle(Vector2(fx, _ground() - 10.0 * k), 36.0 * k * fire, Color(1.0, 0.6, 0.25, 0.18))
		var h := 32.0 * k * 1.3 * fire
		_frame(self, "campfire", int(Time.get_ticks_msec() / 125.0), Rect2(fx - h / 2.0, _ground() - h, h, h))
	elif e >= LIGHT:   # burnt out: the stone ring and logs stay where they were
		var h := 32.0 * k * 1.3
		_frame(self, "campfire", 0, Rect2(fx - h / 2.0, _ground() - h, h, h), Color(0.45, 0.42, 0.45, 1.0) * _tint())

# over Zuru: wood chips while chopping, sword trails while drilling, embers, smoke puffs, grass, the bubble
func _draw_front() -> void:
	if tex.is_empty():
		return
	var k := _k()
	var g := _ground()
	var now := Time.get_ticks_msec() / 1000.0
	var swinging := zuru.animation == "slash" and zuru.frame >= 9 and zuru.frame <= 20   # the blade biting the log
	if swinging and _camp_phase() == "chop":
		_frame(front, "wood_chips", (zuru.frame - 9) % 6, Rect2(camp_x - near - 6.0 * k, g - 46.0 * k, 24.0 * k, 24.0 * k), _tint())
	if _camp_phase() in ["light", "sit"]:   # embers drifting up from the fire
		var fx := camp_x - near + 46.0 * k
		for i in 3:
			var p := fposmod(now * 0.5 + i * 0.33, 1.0)
			_frame(front, "embers", int(now * 10.0) + i, Rect2(fx - 6.0 * k + sin(now * 2.0 + i) * 6.0 * k, g - 30.0 * k - p * 40.0 * k, 10.0 * k, 10.0 * k), Color(1, 1, 1, 1.0 - p))
	for pf in puffs.duplicate():   # dust / smoke puffs play once
		var age: float = now - pf[2]
		if age > 0.5:
			puffs.erase(pf)
			continue
		_frame(front, "smoke", int(age / 0.5 * 6.0), Rect2(pf[0] - near - 18.0 * k, pf[1] - 30.0 * k, 36.0 * k, 36.0 * k), _tint())
	if not smash.is_empty() and now - float(smash[1]) < 0.3:   # the cut flashing through the sliced rock
		_frame(front, "cutx", int((now - float(smash[1])) / 0.3 * 4.0), Rect2(float(smash[0]) - near - 22.0 * k, g - 40.0 * k, 44.0 * k, 44.0 * k))
	var gt: Texture2D = tex.get(FRONT[0])
	if gt:
		var w := 353.0 * k
		var x := -fposmod(near * FRONT[1], w)
		while x < size.x:
			front.draw_texture_rect(gt, Rect2(x, 0, w, size.y), false, _tint())
			x += w
	_theme_front()
	if bubble != "" and state != "walk":
		_bubble(bubble)

func _bubble(text: String) -> void:
	var font := UI.body_font if UI.body_font else ThemeDB.fallback_font
	var fs := 18
	var tw := font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs).x
	var bx := clampf(_zx() - tw / 2.0, 6.0, size.x - tw - 26.0)
	var by := maxf(4.0, _ground() - 55.0 * zuru.scale.y - 46.0)   # just above her head
	front.draw_rect(Rect2(bx - 4, by - 4, tw + 28, 34), Color("2b1d2a"))
	front.draw_rect(Rect2(bx - 2, by - 2, tw + 24, 30), Color("fff4d6"))
	front.draw_rect(Rect2(_zx() - 4, by + 28, 8, 8), Color("fff4d6"))
	front.draw_string(font, Vector2(bx + 10, by + 20), text, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, Color("3e2731"))
