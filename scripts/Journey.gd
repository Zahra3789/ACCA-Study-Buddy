extends Control
# The moving banner on the title and home screens: Zuru runs on while LyniaDesign's Tiny Pixel Japan scenery
# scrolls past in parallax layers (sky, clouds, Fuji, hills, blossoms, house, pagoda, trees, path, grass),
# tinted through dawn, day, sunset and night. Rocks come along the path and he takes each one with a move: a
# double jump with a spin, a dash that slices through it, or a front flip. Every so often he
# stops: in the evening and at night he sets a log on a stump, chops it into a woodpile, lights a campfire and
# sits by it until it burns down; by day he practises sword strikes. Every step plays out in order (dust and
# smoke puffs, things growing in) rather than popping in and out.
# Art: the Japan pack in assets/scenery (not in the public repo), Ninja Adventure stump / log / woodpile /
# rock / smoke / embers / wood chips / slash (CC0), ArlanTR's campfire (CC0), Zuru from the samurai pack.
# The clock, the walk and the current activity are static, so they carry on between title and home.

const CYCLE := 120.0          # seconds for a whole day and night
const FRAME := 96
const SCENE_H := 180.0        # the scenery layers are 353 x 180
const PATH_Y := 158.0         # where feet go on the path, in scenery pixels
const STRIDE := 46.0          # path speed per unit of Zuru's scale, matched to his run so his feet don't slide
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

var speed := 0.0
var chops := 0
var move := ""               # the move he is doing over a rock: double / dash / flip
var move_t := -1.0           # seconds into it, -1 = running normally
var jumped_twice := false
var smash := []              # [path x, time] of the last rock he sliced, for the cut effect
var puffs := []               # [x, y, born] smoke puffs, path coordinates
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
	for f in ["stump", "log", "log_pile", "rock", "smoke", "embers", "wood_chips", "slash_curved", "cutx", "campfire"]:
		var p := "res://assets/fx/%s.png" % f
		if ResourceLoader.exists(p):
			tex[f] = load(p)
	zuru = AnimatedSprite2D.new()
	zuru.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	zuru.offset = Vector2(0, -16)   # the frame is centred on his head; pivot spins and flips round his middle instead
	var frames := SpriteFrames.new()
	frames.remove_animation("default")
	for anim in [["run", "zuru_run", 16.0], ["attack", "zuru_attack1", 13.0], ["sit", "zuru_idle", 6.0]]:
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
	front = Node2D.new()   # grass, wood chips, sword trails, embers, puffs and the bubble go over Zuru
	front.draw.connect(_draw_front)
	add_child(front)
	zuru.animation_finished.connect(_on_anim_done)
	zuru.frame_changed.connect(_on_frame)
	_play("run" if state == "walk" else ("sit" if _camp_phase() == "sit" else "attack"))

func _play(a: String) -> void:
	if zuru.sprite_frames.has_animation(a) and (zuru.animation != a or not zuru.is_playing()):
		zuru.play(a)

func _on_anim_done() -> void:
	if state == "train" or _camp_phase() == "chop":   # swing, a breath, swing again
		get_tree().create_timer(0.3).timeout.connect(func():
			if is_instance_valid(zuru) and (state == "train" or _camp_phase() == "chop"):
				zuru.play("attack"))

# the blade lands on frame 3: count the chops that split the log
func _on_frame() -> void:
	if zuru.animation == "attack" and zuru.frame == 3 and _camp_phase() == "chop":
		chops = mini(chops + 1, 3)
		if chops == 3:
			bubble = "That'll do."

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
		state_t = rng.randf_range(18.0, 28.0)
		bubble = ""
		_play("run")
		return
	if _night() or (clock > 0.45 and rng.randf() < 0.7):
		state = "camp"; state_t = CAMP; chops = 0
		var s := _k() * 2.15
		camp_x = near + _zx() + 40.0 * _k() + speed * speed / (2.0 * STRIDE * s * 2.5)   # right in front of where he stops
		camp_on = true
		_puff(camp_x + 4.0 * _k(), _ground())
		bubble = "Firewood!"
		_play("run")   # he slows to a stop, then starts chopping
	else:
		state = "train"; state_t = 6.0
		bubble = ["Hyah!", "Again!", "Focus. Strike."][rng.randi() % 3]
		_play("attack")

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
	zuru.rotation = 0.0
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
			"chop": _play("attack")
			"light":
				_puff(camp_x + 42.0 * _k(), _ground())
				bubble = ""
			"sit":
				_play("sit")
				bubble = ["A fine night.", "Debits by the fire...", "The stars balance too.", "Rest, then one more chapter."][rng.randi() % 4]
			"out":
				_puff(camp_x + 42.0 * _k(), _ground())
				bubble = ""
	if state_t <= 0.0:
		_next_state()
	var s := _k() * 2.15   # big enough to stand out against the blossom trees
	var target := STRIDE * s if state == "walk" else 0.0
	speed = move_toward(speed, target, delta * STRIDE * s * 2.5)
	if state == "walk" and zuru.animation != "run":
		_play("run")
	near += speed * delta
	# rocks roll in from the right while he runs; for each one he does a move - never the same twice running
	if state == "walk":
		next_rock -= delta
		if rock_x < 0.0 and next_rock <= 0.0 and move_t < 0.0:
			rock_x = near + size.x + 20.0
			next_rock = rng.randf_range(6.0, 11.0)
			var moves := ["double", "dash", "flip"].filter(func(m): return m != rock_move)
			rock_move = moves[rng.randi() % moves.size()]
	var k := _k()
	if rock_x >= 0.0:
		var rx := rock_x - near
		var reach: float = {"double": 44.0, "flip": 40.0, "dash": 100.0}.get(rock_move, 40.0) * k
		if move_t < 0.0 and rx < _zx() + reach and rx > _zx() - 10.0 and state == "walk":
			move = rock_move; move_t = 0.0
			if move == "dash":
				_play("attack")
				_puff(near + _zx() - 20.0 * k, _ground())
		if move == "dash" and move_t >= 0.0 and rx < _zx() + 16.0 * k:   # the blade goes through it: it shatters
			_puff(rock_x, _ground())
			smash = [rock_x, Time.get_ticks_msec() / 1000.0]
			rock_x = -1.0
		elif rx < -40.0:
			rock_x = -1.0
	var lift := 0.0
	var spin := 0.0
	if move_t >= 0.0:
		move_t += delta
		match move:
			"double":   # a hop, then a higher second jump off the air with a spin
				if move_t < 0.3:
					lift = sin(move_t / 0.4 * PI) * 20.0 * k
				else:
					var p := clampf((move_t - 0.3) / 0.6, 0.0, 1.0)
					if not jumped_twice:
						jumped_twice = true
						_puff(near + _zx(), _ground() - sin(0.75 * PI) * 20.0 * k)
					lift = sin(0.75 * PI) * 20.0 * k * (1.0 - p) + sin(p * PI) * 30.0 * k
					spin = p * TAU
					if p >= 1.0: _end_move()
			"flip":   # one big leap with a full somersault
				var p := clampf(move_t / 0.7, 0.0, 1.0)
				lift = sin(p * PI) * 32.0 * k
				spin = p * TAU
				if p >= 1.0: _end_move()
			"dash":   # a burst of speed with after-images, slicing through the rock
				near += STRIDE * s * 2.4 * delta
				if move_t > 0.45: _end_move()
	var seated := 13.0 * _k() if (phase == "sit") else 0.0   # no sitting frames in the pack: he kneels low, legs behind the grass
	zuru.scale = Vector2(s, s)
	zuru.rotation = spin
	zuru.position = Vector2(_zx(), _ground() - 16.0 * s - lift + seated)   # feet on the path (the pivot is his middle)
	zuru.modulate = _tint().lerp(Color.WHITE, 0.35)   # lit a little more than the scenery so he stays readable
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
	while x < size.x:
		canvas.draw_texture_rect(tex[name], Rect2(x, 0, w, size.y), false, _tint())
		x += period

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
	if camp_on:
		_campsite(camp_x - near)
	if rock_x >= 0.0:
		_prop("rock", rock_x - near, _k() * 1.6)
	if move == "dash" and move_t >= 0.0 and zuru.sprite_frames:   # after-images trailing the dash
		var ft: Texture2D = zuru.sprite_frames.get_frame_texture(zuru.animation, zuru.frame)
		var fs := FRAME * zuru.scale.x
		for i in range(3, 0, -1):
			var gx := zuru.position.x - i * 26.0 * _k()
			draw_texture_rect(ft, Rect2(gx - fs / 2.0, zuru.position.y + zuru.offset.y * zuru.scale.y - fs / 2.0, fs, fs), false, Color(0.6, 0.8, 1.0, 0.45 - i * 0.12))

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
	var swinging := zuru.animation == "attack" and zuru.frame >= 3
	if swinging and _camp_phase() == "chop":
		_frame(front, "wood_chips", zuru.frame - 3, Rect2(camp_x - near - 6.0 * k, g - 46.0 * k, 24.0 * k, 24.0 * k), _tint())
	if swinging and state == "train":
		_frame(front, "slash_curved", zuru.frame - 3, Rect2(_zx() + 14.0 * k, g - 46.0 * k, 40.0 * k, 40.0 * k))
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
