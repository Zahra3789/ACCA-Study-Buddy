extends Node2D
# Theme effects over the whole stage (above every screen, below the top bar):
#   mode "xmas"      - falling snow
#   mode "halloween" - falling autumn leaves and a few bats flapping across

var mode := ""
var flakes: Array = []
var bats: Array = []
var bat_tex: Texture2D = null

func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 42
	for i in 70:
		flakes.append({"x": rng.randf() * 720.0, "y": rng.randf() * 1280.0, "r": 2.0 + rng.randf() * 3.0, "v": 36.0 + rng.randf() * 72.0, "w": rng.randf() * TAU, "c": rng.randf()})
	for i in 5:
		bats.append({"x": rng.randf() * 720.0, "y": 100.0 + rng.randf() * 700.0, "v": 60.0 + rng.randf() * 90.0, "w": rng.randf() * TAU})
	if ResourceLoader.exists("res://assets/xmas/bat.png"):
		bat_tex = load("res://assets/xmas/bat.png")
	z_index = 36

func _process(delta: float) -> void:
	for f in flakes:
		f["y"] += f["v"] * delta * (1.0 if mode == "xmas" else 0.8)
		f["w"] += 1.2 * delta
		f["x"] += sin(f["w"]) * (24.0 if mode == "xmas" else 70.0) * delta
		if f["y"] > 1290.0:
			f["y"] = -10.0
			f["x"] = randf() * 720.0
	if mode == "halloween":
		for b in bats:
			b["x"] -= b["v"] * delta
			b["w"] += 9.0 * delta
			b["y"] += sin(b["w"]) * 70.0 * delta
			if b["x"] < -60.0:
				b["x"] = 780.0
				b["y"] = 100.0 + randf() * 700.0
	queue_redraw()

func _draw() -> void:
	for f in flakes:
		if mode == "xmas":
			draw_rect(Rect2(round(f["x"]), round(f["y"]), f["r"], f["r"]), Color(1, 1, 1, 0.85))
		else:
			var c := Color("e8812b") if f["c"] < 0.5 else (Color("b85e1c") if f["c"] < 0.8 else Color("c98a2e"))
			draw_rect(Rect2(round(f["x"]), round(f["y"]), f["r"] + 2.0, f["r"]), c)
	if mode == "halloween" and bat_tex != null:
		for b in bats:
			var h := 24.0 if abs(sin(b["w"])) > 0.5 else 16.0
			draw_texture_rect(bat_tex, Rect2(round(b["x"]), round(b["y"]), 48.0, h), false)
