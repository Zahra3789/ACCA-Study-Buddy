extends Node2D
# Little stars circling a knocked-down enemy's head (BattleFX.knockdown). Outlined so they show on any monster.

var t := 0.0

func _process(delta: float) -> void:
	if visible:
		t += delta
		queue_redraw()

func _draw() -> void:
	for i in 3:
		var a := t * 4.0 + i * TAU / 3.0
		var p := Vector2(cos(a) * 60.0, sin(a) * 16.0)
		var s := 11.0 + 3.0 * sin(t * 8.0 + i)
		var c := Color("fff3b0") if sin(a) > 0.0 else Color("f2c14e")
		for r in [[s + 3.0, 5.0, Color("2b1d2a")], [s, 3.0, c]]:   # dark outline, then the star
			draw_rect(Rect2(p - Vector2(r[0], r[1]), Vector2(r[0] * 2, r[1] * 2)), r[2])
			draw_rect(Rect2(p - Vector2(r[1], r[0]), Vector2(r[1] * 2, r[0] * 2)), r[2])
