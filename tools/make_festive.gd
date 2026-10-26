extends SceneTree
# Draws the small theme pieces made for this game into assets/xmas: a Santa hat and a witch's hat (worn by Zuru
# and the monsters) and a sprig of holly (screen corners). Each is a pixel map below, outlined automatically.
#   Godot --headless --path . -s tools/make_festive.gd

const OUTLINE := Color("2b1d2a")
const PAL := {
	"R": Color("c8202e"), "r": Color("8e1420"), "W": Color("f6f4ee"), "w": Color("c9d2dc"),   # Santa
	"P": Color("3b2550"), "p": Color("5a3a78"), "O": Color("e8812b"), "o": Color("f2c14e"),   # witch
	"G": Color("2e8b3e"), "g": Color("1d5c2a"), "B": Color("d9283a"), "b": Color("ff6b6b"),   # holly
}

const SANTA := [
	"............WW..",
	"...........WWWW.",
	".......RRR.WwWW.",
	".....RRRRRRRWW..",
	"....RRRRRRRRr...",
	"...RRRRRRRRRr...",
	"..RRRRRRRRRRr...",
	"..RRRRRRRRRRRr..",
	".WWWWWWWWWWWWWW.",
	".WWWWWWWWWWWWWW.",
	".wwwwwwwwwwwwww.",
]

const WITCH := [
	"..........pP....",
	".........pPP....",
	"........pPPP....",
	"........PPPP....",
	".......pPPPP....",
	".......PPPPPP...",
	"......pPPPPPP...",
	"......OOoOOOO...",
	"......PPPPPPP...",
	"PPPPPPPPPPPPPPPP",
	".pPPPPPPPPPPPPP.",
]

const HOLLY := [
	"..GG.......GG...",
	".GGGG.....GGGG..",
	"GGgGGG...GGGgGG.",
	".GGgGGG.GGGgGG..",
	"..GGgGGBGGgGG...",
	"...GGGBbBGGG....",
	"....GBBBBBG.....",
	".....BbBBb......",
	"......BBB.......",
]

func _init() -> void:
	_save(SANTA, "res://assets/xmas/hat_santa.png")
	_save(WITCH, "res://assets/xmas/hat_witch.png")
	_save(HOLLY, "res://assets/xmas/holly.png")
	print("festive pieces written")
	quit()

# The pixel map with a 1 px dark outline round every filled pixel (so it reads on any background).
func _save(rows: Array, path: String) -> void:
	var w: int = rows[0].length() + 2
	var h: int = rows.size() + 2
	var im := Image.create(w, h, false, Image.FORMAT_RGBA8)
	for y in rows.size():
		for x in rows[y].length():
			var ch: String = rows[y][x]
			if PAL.has(ch):
				for d in [Vector2i(-1, 0), Vector2i(1, 0), Vector2i(0, -1), Vector2i(0, 1)]:
					var p: Vector2i = Vector2i(x + 1, y + 1) + d
					if im.get_pixelv(p).a == 0.0:
						im.set_pixelv(p, OUTLINE)
	for y in rows.size():
		for x in rows[y].length():
			var ch: String = rows[y][x]
			if PAL.has(ch):
				im.set_pixel(x + 1, y + 1, PAL[ch])
	im.save_png(ProjectSettings.globalize_path(path))
