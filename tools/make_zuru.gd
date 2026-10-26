extends SceneTree
# Makes Zuru's sprites and the app icon from the DojoChef samurai (FREE_Samurai 2D Pixel Art v1.2 - free
# for use in any game, not for resale as an asset; see CREDITS.md). The raw sheets are not in this repo.
#   Godot --headless --path . -s tools/make_zuru.gd -- [folder with idle.png, attack1.png, hurt.png, icon.png]
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
	var icon := Image.load_from_file(src + "/icon.png")
	icon.resize(512, 512, Image.INTERPOLATE_NEAREST)
	icon.save_png(ProjectSettings.globalize_path("res://assets/icon.png"))
	# Android adaptive icon: the launcher masks to roughly the middle 264 px of 432, so the samurai sits
	# inside that on a transparent foreground, over a background of the icon's own colour.
	var bg := Image.load_from_file(src + "/icon.png").get_pixel(0, 0)
	var idle := Image.load_from_file(src + "/samurai/idle.png").get_region(Rect2i(0, 0, FRAME, FRAME))
	var used := idle.get_used_rect()
	var fig := idle.get_region(used)
	var k := maxi(1, 240 / maxi(used.size.x, used.size.y))
	fig.resize(used.size.x * k, used.size.y * k, Image.INTERPOLATE_NEAREST)
	var fg := Image.create(432, 432, false, Image.FORMAT_RGBA8)
	fg.blit_rect(fig, Rect2i(Vector2i.ZERO, fig.get_size()), (Vector2i(432, 432) - fig.get_size()) / 2)
	fg.save_png(ProjectSettings.globalize_path("res://assets/icon_foreground.png"))
	var back := Image.create(432, 432, false, Image.FORMAT_RGBA8)
	back.fill(bg)
	back.save_png(ProjectSettings.globalize_path("res://assets/icon_background.png"))
	print("Zuru sprites and icon written")
	quit()
