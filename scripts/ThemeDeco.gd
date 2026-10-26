extends Node2D
# Theme trimmings round the edges of every screen, over everything but kept to the corners and the top strip so
# no text is covered:
#   "xmas"      - icicles hanging under the string of lights, holly in the top corners, snow drifts in the bottom ones
#   "halloween" - cobwebs in all four corners and a little spider bobbing on its thread
# Spider: Ninja Adventure (CC0). Holly: tools/make_festive.gd.

var mode := ""
var holly: Texture2D
var spider: Texture2D
const TOP := 74.0   # just under the top buttons and the lights / bunting

func _ready() -> void:
	z_index = 39   # above the screens, below the calculator and help
	if ResourceLoader.exists("res://assets/xmas/holly.png"):
		holly = load("res://assets/xmas/holly.png")
	if ResourceLoader.exists("res://assets/fx/spider.png"):
		spider = load("res://assets/fx/spider.png")

func _process(_delta: float) -> void:
	visible = mode != ""
	if visible:
		queue_redraw()

func _draw() -> void:
	var vs := get_viewport_rect().size
	var now := Time.get_ticks_msec() / 1000.0
	if mode == "xmas":
		_icicles(vs)
		if holly:
			var hs := holly.get_size() * 3.0
			draw_texture_rect(holly, Rect2(Vector2(4, TOP + 2), hs), false)
			draw_texture_rect(holly, Rect2(Vector2(vs.x - 4 - hs.x, TOP + 2), hs), false)
		for side in [0.0, 1.0]:   # snow drifting into the bottom corners
			var cx: float = lerpf(-6.0, vs.x + 6.0, side)
			draw_circle(Vector2(cx, vs.y + 14.0), 52.0, Color(0.96, 0.98, 1.0, 0.92))
			draw_circle(Vector2(cx + (40.0 if side == 0.0 else -40.0), vs.y + 22.0), 34.0, Color(0.96, 0.98, 1.0, 0.92))
	elif mode == "halloween":
		_web(Vector2(0, TOP), Vector2(1, 1), 120.0)
		_web(Vector2(vs.x, TOP), Vector2(-1, 1), 120.0)
		_web(Vector2(0, vs.y), Vector2(1, -1), 110.0)
		_web(Vector2(vs.x, vs.y), Vector2(-1, -1), 110.0)
		if spider:   # dangling a little way from the top-left web, clear of the battle monster
			var x := 56.0
			var y := TOP + 70.0 + sin(now * 1.3) * 12.0
			draw_line(Vector2(x, TOP + 30.0), Vector2(x, y - 18.0), Color(0.92, 0.92, 0.95, 0.7), 2.0)
			var f := int(now * 4.0) % 4
			draw_texture_rect_region(spider, Rect2(x - 24.0, y - 24.0, 48.0, 48.0), Rect2(0, f * 16, 16, 16))

func _icicles(vs: Vector2) -> void:
	var x := 6.0
	var i := 0
	while x < vs.x:
		var r := fposmod(sin(i * 12.9898) * 43758.5453, 1.0)
		var w := 8.0 + r * 6.0
		var h := 10.0 + r * 22.0
		draw_colored_polygon(PackedVector2Array([Vector2(x, TOP), Vector2(x + w, TOP), Vector2(x + w * 0.5, TOP + h)]), Color(0.88, 0.95, 1.0, 0.85))
		draw_line(Vector2(x + w * 0.3, TOP + 1), Vector2(x + w * 0.45, TOP + h * 0.7), Color(1, 1, 1, 0.9), 2.0)
		x += w + 10.0 + r * 18.0
		i += 1

# A corner cobweb: spokes fanning out from the corner, joined by sagging threads.
func _web(corner: Vector2, dir: Vector2, r: float) -> void:
	var col := Color(0.93, 0.93, 0.97, 0.55)
	var spokes := 6
	var ends := []
	for s in spokes:
		var a := (PI / 2.0) * s / float(spokes - 1)
		var d := Vector2(cos(a) * dir.x, sin(a) * dir.y)
		ends.append(d)
		draw_line(corner, corner + d * r, col, 2.0)
	for ring in [0.3, 0.52, 0.74, 0.95]:
		for s in spokes - 1:
			var p1: Vector2 = corner + ends[s] * r * ring
			var p2: Vector2 = corner + ends[s + 1] * r * ring
			var mid := (p1 + p2) / 2.0
			var sag := mid + (corner - mid) * 0.12   # threads droop toward the corner
			draw_polyline(PackedVector2Array([p1, sag, p2]), col, 2.0)
