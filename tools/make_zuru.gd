extends SceneTree
# Makes Zuru's sprites from the DojoChef samurai (FREE_Samurai 2D Pixel Art v1.2 - free for use in any game,
# not for resale as an asset; see CREDITS.md; the raw sheets are not in this repo), and draws the app icon.
#   Godot --headless --path . -s tools/make_zuru.gd -- [folder with samurai/idle.png, attack1.png, hurt.png]
# Every mood is cut from the same 32x35 box so swapping faces never makes Zuru jump. The festive (_x) and
# spooky (_h) variants are the same art for now.

const DEFAULT_SRC := "%USERPROFILE%/GameDev/DojoChef/art"
const FRAME := 96
const BOX := Rect2i(32, 46, 32, 35)
const MOODS := {"": ["idle", 0], "_happy": ["attack1", 3], "_sad": ["hurt", 1]}

func _init() -> void:
	var args := OS.get_cmdline_user_args()
	var src: String = args[0] if args.size() > 0 else DEFAULT_SRC
	var out := ProjectSettings.globalize_path("res://assets/characters/")
	for suffix in MOODS:
		var sheet := Image.load_from_file("%s/samurai/%s.png" % [src, MOODS[suffix][0]])
		var img := sheet.get_region(Rect2i(BOX.position + Vector2i(int(MOODS[suffix][1]) * FRAME, 0), BOX.size))
		for variant in ["", "_x", "_h"]:
			img.save_png(out + "samurai%s%s.png" % [variant, suffix])
	# Whole animation sheets (96 px frames) for the walking banner on the title and home screens (Journey.gd).
	for sheet in ["idle", "run", "attack1"]:
		Image.load_from_file("%s/samurai/%s.png" % [src, sheet]).save_png(out + "zuru_%s.png" % sheet)
	# App icon: an open pixel study book on teal (not the samurai, so it can't be mistaken for DojoChef).
	# icon.png is the whole icon; the Android adaptive layers put the book inside the launcher's safe
	# middle 264 px of 432 on a transparent foreground over a plain teal background.
	var book := _book()
	_layer(book, 12, 512, ICON_BG).save_png(ProjectSettings.globalize_path("res://assets/icon.png"))
	_layer(book, 7, 432, Color(0, 0, 0, 0)).save_png(ProjectSettings.globalize_path("res://assets/icon_foreground.png"))
	_layer(book, 0, 432, ICON_BG).save_png(ProjectSettings.globalize_path("res://assets/icon_background.png"))
	print("Zuru sprites and icon written")
	quit()

const ICON_BG := Color("1f5d63")
const INK := Color("2b1d2a")
const PAGE := Color("fff4d6")
const PAGE_SHADE := Color("e9d8b4")
const LINE := Color("b9a27a")
const COVER := Color("c8414b")
const COVER_DARK := Color("8c2b3c")
const GOLD := Color("f2c14e")
const RIBBON := Color("5a7fc0")
const W := 34
const SPINE := 17   # columns 16 and 17 are the gutter between the two pages

# Height of a page's top edge at column x: low at the gutter, rising towards the outer edges.
func _top(x: int) -> int:
	var t := absf(x + 0.5 - SPINE) / SPINE
	return 2 + int(round(4.0 * (1.0 - sqrt(t))))

func _book() -> Image:
	var img := Image.create(W, 32, false, Image.FORMAT_RGBA8)
	var page_h := 17
	# cover: the page shape shifted down 3 px, so it shows as a red rim under the pages
	for x in W:
		for y in range(_top(x) + 2, _top(x) + page_h + 4):
			img.set_pixel(x, y, COVER if y < _top(x) + page_h + 3 else COVER_DARK)
	# pages, with a soft shade next to the gutter and gold-edged bottoms
	for x in range(1, W - 1):
		var gutter := absi(x - SPINE) <= 1 or x == SPINE - 1
		for y in range(_top(x), _top(x) + page_h):
			img.set_pixel(x, y, PAGE_SHADE if (gutter or absf(x + 0.5 - SPINE) < 3.0) else PAGE)
		img.set_pixel(x, _top(x) + page_h, GOLD)
	# straight lines of text on the flatter outer part of each page; each "paragraph" ends on a short line
	for y in [7, 9, 11, 14, 16, 18]:
		var short: bool = y in [11, 18]
		for x in range(4, 13 if not short else 9):
			img.set_pixel(x, y, LINE)
		for x in range(22, 31 if not short else 27):
			img.set_pixel(x, y, LINE)
	# outline every filled pixel that touches empty space, and draw the gutter line
	var filled := img.duplicate()
	for x in W:
		for y in img.get_height():
			if filled.get_pixel(x, y).a == 0.0:
				continue
			for d in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var p: Vector2i = Vector2i(x, y) + d
				if p.x < 0 or p.y < 0 or p.x >= W or p.y >= img.get_height() or filled.get_pixel(p.x, p.y).a == 0.0:
					img.set_pixel(x, y, INK)
					break
	for y in range(_top(SPINE), _top(SPINE) + page_h + 3):
		img.set_pixel(SPINE, y, INK)
	# ribbon bookmark hanging out of the gutter, with a forked tail
	var by := _top(SPINE) + page_h + 3
	for y in range(by, by + 4):
		img.set_pixel(SPINE + 1, y, RIBBON)
	img.set_pixel(SPINE, by + 4, RIBBON); img.set_pixel(SPINE + 2, by + 4, RIBBON)
	# a gold sparkle over the top right page
	for p in [Vector2i(29, 0), Vector2i(29, 2), Vector2i(28, 1), Vector2i(30, 1)]:
		img.set_pixel(p.x, p.y, GOLD)
	return img

# A size x size square filled with bg, with the book scaled by k (0 = no book) in the middle.
func _layer(book: Image, k: int, size: int, bg: Color) -> Image:
	var out := Image.create(size, size, false, Image.FORMAT_RGBA8)
	out.fill(bg)
	if k > 0:
		var big := book.duplicate()
		big.resize(book.get_width() * k, book.get_height() * k, Image.INTERPOLATE_NEAREST)
		out.blend_rect(big, Rect2i(Vector2i.ZERO, big.get_size()), (Vector2i(size, size) - big.get_size()) / 2)
	return out
