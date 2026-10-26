extends Node
# Battle action on top of Battle.gd: slashes, impacts, screen shake and flashes, combos and critical hits,
# the knocked-down state, finishing blows, boss entrances, the danger pulse when Zuru is low, fight music,
# and Zuru's voice. Art, sounds and music: Ninja Adventure (CC0). Voices: any files in assets/voice/.

const FX := "res://assets/fx/"
const VOICE_DIR := "res://assets/voice/"
const SOUNDS := ["slash1", "slash2", "slash3", "sword", "impact1", "impact2", "boom", "alert", "powerup", "win", "miss"]

var battle: Node
var main: Node
var players: Array = []          # a few players so a slash, an impact and a shout can overlap
var streams: Dictionary = {}
var voices: Dictionary = {}      # "attack" -> [AudioStream, ...]
var music: AudioStreamPlayer
var flash: ColorRect             # full-screen white / red flash
var danger: ColorRect            # red pulse round the edges while Zuru is low
var dizzy: Node2D                # stars circling a knocked-down enemy
var knocked := false
var _danger_tw: Tween
var _knock_tw: Tween

func setup(b: Node) -> void:
	battle = b
	main = b.main
	for i in 4:
		var p := AudioStreamPlayer.new()
		add_child(p)
		players.append(p)
	for k in SOUNDS:
		var path := "res://assets/sfx/%s.wav" % k
		if ResourceLoader.exists(path):
			streams[k] = load(path)
	_load_voices()
	music = AudioStreamPlayer.new()
	music.volume_db = -12.0
	add_child(music)
	var scr: Control = main.screens["battle"]
	flash = ColorRect.new()
	flash.set_anchors_preset(Control.PRESET_FULL_RECT)
	flash.mouse_filter = Control.MOUSE_FILTER_IGNORE
	flash.color = Color(1, 1, 1, 0)
	flash.z_index = 30
	scr.add_child(flash)
	danger = ColorRect.new()
	danger.mouse_filter = Control.MOUSE_FILTER_IGNORE
	danger.color = Color(0.8, 0.05, 0.1, 0)
	danger.z_index = 29
	battle.field.add_child(danger)
	danger.position = Vector2.ZERO
	danger.size = Vector2(720, 600)
	dizzy = preload("res://scripts/Dizzy.gd").new()
	dizzy.visible = false
	battle.foe.add_child(dizzy)
	dizzy.position = Vector2(120, -18)   # just above the monster's head

func _load_voices() -> void:
	var names: PackedStringArray = ResourceLoader.list_directory(VOICE_DIR) if ResourceLoader.has_method("list_directory") else DirAccess.get_files_at(VOICE_DIR)
	for f in names:
		f = f.trim_suffix(".import").trim_suffix(".remap")
		if not (f.ends_with(".wav") or f.ends_with(".ogg")):
			continue
		var stream = load(VOICE_DIR + f)
		if stream == null:
			continue
		var kind := f.get_slice("_", 0).get_slice(".", 0).to_lower()
		if not voices.has(kind):
			voices[kind] = []
		voices[kind].append(stream)

# ---------------------------------------------------------------- sound
func _on() -> bool:
	return Game.settings.get("sfx", true)

func play(kind: String, pitch := 1.0) -> void:
	if not _on() or not streams.has(kind):
		return
	for p in players:
		if not p.playing:
			p.stream = streams[kind]
			p.pitch_scale = pitch
			p.play()
			return

func voice(kind: String) -> void:
	if not _on() or not voices.has(kind):
		return
	var list: Array = voices[kind]
	play_stream(list[randi() % list.size()])

func play_stream(s: AudioStream) -> void:
	for p in players:
		if not p.playing:
			p.stream = s
			p.pitch_scale = 1.0
			p.play()
			return

func music_start(track: String) -> void:
	var path := "res://assets/music/%s.ogg" % track
	if not _on() or not ResourceLoader.exists(path):
		return
	var st = load(path)
	if st is AudioStreamOggVorbis:
		st.loop = true
	if music.stream != st or not music.playing:
		music.stream = st
		music.play()

func music_stop() -> void:
	music.stop()

# ---------------------------------------------------------------- visuals
# A Ninja Adventure effect sheet (frames side by side) played once at pos (field coordinates), scale k.
func effect(sheet: String, frames: int, pos: Vector2, k := 6.0, secs := 0.3, rot := 0.0) -> void:
	var path := FX + sheet + ".png"
	if not ResourceLoader.exists(path):
		return
	var sp := Sprite2D.new()
	sp.texture = load(path)
	sp.hframes = frames
	sp.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sp.scale = Vector2(k, k)
	sp.position = pos
	sp.rotation_degrees = rot
	sp.z_index = 20
	battle.field.add_child(sp)
	var tw := create_tween()
	tw.tween_property(sp, "frame", frames - 1, secs).from(0)
	tw.tween_callback(sp.queue_free)

func shake(strength: float, secs := 0.25) -> void:
	var base: Vector2 = battle.field.position
	var tw := create_tween()
	var steps := int(secs / 0.04)
	for i in steps:
		var fade := 1.0 - float(i) / steps
		tw.tween_property(battle.field, "position", base + Vector2(randf_range(-1, 1), randf_range(-1, 1)) * strength * fade, 0.04)
	tw.tween_property(battle.field, "position", base, 0.04)

func screen_flash(c: Color, peak := 0.6, secs := 0.25) -> void:
	flash.color = Color(c, peak)
	var tw := create_tween()
	tw.tween_property(flash, "color:a", 0.0, secs)

func white_flash(tr: CanvasItem) -> void:
	tr.modulate = Color(3, 3, 3)
	var tw := create_tween()
	tw.tween_property(tr, "modulate", Color.WHITE if not knocked else Color(1, 0.7, 0.7), 0.18)

# Big text that slams into the field at height y, then fades. One banner per height: a new one replaces
# whatever is still showing there, so "BOSS DEFEATED!" never sits on top of "BOSS 2".
var _banners: Dictionary = {}

func clear_banners() -> void:
	for l in _banners.values():
		if is_instance_valid(l):
			l.queue_free()
	_banners.clear()

func banner(text: String, color: Color, size := 64, secs := 1.1, y := 230.0) -> void:
	if is_instance_valid(_banners.get(y)):
		_banners[y].queue_free()
	var l := Label.new()
	_banners[y] = l
	l.text = text
	l.add_theme_font_override("font", UI.title_o_font)
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.add_theme_color_override("font_outline_color", Color("2b1d2a"))
	l.add_theme_constant_override("outline_size", 10)
	l.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	l.size = Vector2(720, size * 1.4)
	l.position = Vector2(0, y - size * 0.7)
	l.pivot_offset = l.size / 2
	l.z_index = 25
	l.scale = Vector2(2.4, 2.4)
	l.modulate.a = 0.0
	battle.field.add_child(l)
	var tw := create_tween()
	tw.tween_property(l, "scale", Vector2.ONE, 0.16).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(l, "modulate:a", 1.0, 0.1)
	tw.tween_interval(secs)
	tw.tween_property(l, "modulate:a", 0.0, 0.3)
	tw.tween_callback(l.queue_free)

func _foe_centre() -> Vector2:
	return battle.foe.position + battle.foe.size / 2

func _you_centre() -> Vector2:
	return battle.you.position + battle.you.size / 2

# ---------------------------------------------------------------- moments
# A right answer. combo = right answers in a row; 3+ is a critical.
func hit(combo: int) -> void:
	var crit := combo >= 3
	voice("crit" if crit and voices.has("crit") else "attack")
	play("slash%d" % (randi() % 3 + 1))
	var c := _foe_centre()
	if crit:
		effect("cutx", 4, c, 8.0, 0.32)
		effect("smoke", 6, c + Vector2(0, 40), 5.0, 0.4)
		play("impact2", 0.9)
		shake(16.0, 0.35)
		screen_flash(Color.WHITE, 0.45, 0.2)
		banner("CRITICAL!  x%d" % combo, Color("ffe39a"), 48, 0.6, 150.0)
	else:
		effect(["cut", "slash_curved"][randi() % 2], 4, c, 6.0, 0.25, randf_range(-25, 25))
		play("impact1")
		shake(7.0, 0.2)
	white_flash(battle.foe)

# A wrong answer: the enemy strikes Zuru.
func hurt(low: bool) -> void:
	voice("hurt")
	play("impact2", 0.8)
	effect("claw", 4, _you_centre(), 5.0, 0.25)
	shake(11.0, 0.3)
	screen_flash(Color(0.85, 0.1, 0.15), 0.35, 0.3)
	set_danger(low)

func set_danger(on: bool) -> void:
	if _danger_tw:
		_danger_tw.kill()
	danger.color.a = 0.0
	if on:
		_danger_tw = create_tween().set_loops()
		_danger_tw.tween_property(danger, "color:a", 0.22, 0.45)
		_danger_tw.tween_property(danger, "color:a", 0.0, 0.45)

# The enemy is one good hit from defeat: it drops, flashes red and sees stars.
func knockdown() -> void:
	if knocked:
		return
	knocked = true
	play("alert")
	banner("KNOCKED DOWN!", Color("ff8a5c"), 54, 0.9, 300.0)
	var f: TextureRect = battle.foe
	f.pivot_offset = f.size / 2
	var tw := create_tween()
	tw.tween_property(f, "rotation_degrees", 14.0, 0.2).set_trans(Tween.TRANS_BACK)
	tw.parallel().tween_property(f, "scale", Vector2(1.06, 0.88), 0.2)
	dizzy.visible = true
	_knock_tw = create_tween().set_loops()
	_knock_tw.tween_property(f, "modulate", Color(1, 0.55, 0.55), 0.35)
	_knock_tw.tween_property(f, "modulate", Color.WHITE, 0.35)

func clear_knockdown() -> void:
	knocked = false
	if _knock_tw:
		_knock_tw.kill()
	dizzy.visible = false
	var f: TextureRect = battle.foe
	f.rotation_degrees = 0.0
	f.scale = Vector2.ONE
	f.modulate = Color.WHITE

# The defeating blow: slow motion, a big cut, a flash and an explosion, and the enemy is sent flying.
func finisher(boss: bool) -> void:
	clear_knockdown()
	clear_banners()
	voice("finish" if voices.has("finish") else "crit")
	var c := _foe_centre()
	Engine.time_scale = 0.35
	get_tree().create_timer(0.55, true, false, true).timeout.connect(func(): Engine.time_scale = 1.0)
	play("sword")
	effect("circular", 4, c, 10.0, 0.3)
	await get_tree().create_timer(0.12).timeout
	play("boom")
	effect("explosion", 9, c, 7.0, 0.45)
	screen_flash(Color.WHITE, 0.85, 0.5)
	shake(24.0, 0.5)
	banner("BOSS DEFEATED!" if boss else "FINISHING BLOW!", Color("ffe39a"), 58, 1.0)
	var f: TextureRect = battle.foe
	f.pivot_offset = f.size / 2
	var tw := create_tween()
	tw.tween_property(f, "position", f.position + Vector2(160, -140), 0.6).set_ease(Tween.EASE_OUT)
	tw.parallel().tween_property(f, "rotation_degrees", 220.0, 0.6)
	tw.parallel().tween_property(f, "modulate:a", 0.0, 0.6)
	await tw.finished
	f.rotation_degrees = 0.0

# A boss walks in: flash, shake, "BOSS n" and a war cry.
func boss_intro(n: int) -> void:
	clear_knockdown()
	clear_banners()
	play("alert", 0.8)
	voice("boss")
	var f: TextureRect = battle.foe
	f.modulate.a = 1.0
	f.scale = Vector2(1.6, 1.6)
	f.pivot_offset = f.size / 2
	var tw := create_tween()
	tw.tween_property(f, "scale", Vector2.ONE, 0.3).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	screen_flash(Color(0.9, 0.1, 0.2), 0.5, 0.4)
	shake(14.0, 0.35)
	banner("BOSS %d" % n, Color("ff5c6a"), 72, 0.9)

# Session over (won, lost or left): put everything back.
func reset() -> void:
	clear_knockdown()
	set_danger(false)
	music_stop()
	Engine.time_scale = 1.0
	flash.color.a = 0.0
