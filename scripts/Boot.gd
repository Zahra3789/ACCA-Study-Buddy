extends Control
# The first scene: keeps Samurai Ledger up to date by itself (same idea as DojoChef's boot.gd).
# On start it asks the "live" release which content version is newest (giving up after a few seconds
# when offline). If that's newer than what's on the phone, it downloads the new content pack and saves it.
# Then it loads the newest pack it has, swaps the always-loaded scripts (Game, Content, UI) for the pack's
# versions, and opens the game. Offline it plays the last version it got. Scripts, questions, art and
# screens update this way; the icon, app name, permissions or a new Godot engine still need a new APK.

const BuildInfo = preload("res://scripts/build_info.gd")
const DIR := "user://update/"
const PACK := DIR + "content.pck"
const VERSION_FILE := DIR + "version.txt"
const CHECK_TIMEOUT := 5.0
const MAIN_SCENE := "res://Main.tscn"
const AUTOLOADS := {"Game": "res://scripts/Game.gd", "Content": "res://scripts/Content.gd", "UI": "res://scripts/UI.gd"}

var status := "Starting..."
var progress := -1.0
var http: HTTPRequest
var remote_version := 0

func _ready() -> void:
	set_anchors_preset(Control.PRESET_FULL_RECT)
	DirAccess.make_dir_recursive_absolute(DIR)
	# while it checks and downloads, Zuru runs on through the moving banner, the status and progress bar under it
	if ResourceLoader.exists("res://scripts/Journey.gd"):
		var sz := get_viewport_rect().size
		var j: Control = load("res://scripts/Journey.gd").new()
		var hj := clampf(sz.y * 0.26, 300.0, 440.0)   # the same place and size as the opening splash in Main.gd, so they read as one screen
		j.position = Vector2(0, sz.y / 2.0 - 80.0 - hj)
		j.size = Vector2(sz.x, hj)
		add_child(j)
	if BuildInfo.UPDATE_URL == "" or DisplayServer.get_name() == "headless" or OS.has_feature("editor"):
		_start()   # no update server, or running from source / in tests: just play
		return
	status = "Checking for updates..."
	http = HTTPRequest.new()
	http.timeout = CHECK_TIMEOUT
	add_child(http)
	http.request_completed.connect(_on_version)
	if http.request(BuildInfo.UPDATE_URL + "/version.txt?t=%d" % Time.get_unix_time_from_system()) != OK:
		_start()

func installed_version() -> int:
	var v := BuildInfo.BUILD
	if FileAccess.file_exists(PACK) and FileAccess.file_exists(VERSION_FILE):
		v = maxi(v, int(FileAccess.get_file_as_string(VERSION_FILE).strip_edges()))
	return v

func _on_version(result: int, code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS or code != 200:
		_start()   # offline, or the server's unreachable
		return
	remote_version = int(body.get_string_from_utf8().strip_edges())
	if remote_version <= installed_version():
		_start()
		return
	# a newer version: download it to a temporary file first, so a dropped connection can't break the game
	status = "Downloading update (version %d)..." % remote_version
	progress = 0.0
	http.request_completed.disconnect(_on_version)
	http.request_completed.connect(_on_pack)
	http.timeout = 0.0
	http.download_file = DIR + "download.tmp"
	if http.request(BuildInfo.UPDATE_URL + "/content.pck?v=%d" % remote_version) != OK:
		_start()

func _on_pack(result: int, code: int, _headers: PackedStringArray, _body: PackedByteArray) -> void:
	if result == HTTPRequest.RESULT_SUCCESS and code == 200:
		DirAccess.remove_absolute(PACK)
		DirAccess.rename_absolute(DIR + "download.tmp", PACK)
		var f := FileAccess.open(VERSION_FILE, FileAccess.WRITE)
		f.store_string(str(remote_version))
		f.close()
		status = "Updated to version %d!" % remote_version
	_start()

# Load the newest pack we have (if it's newer than the APK's own content) and play.
func _start() -> void:
	var again := Engine.has_meta("sl_game_ran")   # set by Main: we are back here from its "Update ready" bar
	if FileAccess.file_exists(PACK) and installed_version() > BuildInfo.BUILD:
		if ProjectSettings.load_resource_pack(PACK, true):
			_swap_autoloads()
	if again:
		_refresh_scripts()
		var scene = ResourceLoader.load(MAIN_SCENE, "", ResourceLoader.CACHE_MODE_IGNORE)
		if scene is PackedScene:
			get_tree().change_scene_to_packed.call_deferred(scene)
			return
	get_tree().change_scene_to_file.call_deferred(MAIN_SCENE)

# Mid-session the game's scripts are already cached from the old version, and preload() / load() would hand those
# back. Read each one afresh from the new pack and let it take over its path, so everything loaded from now on is
# the new code. Twice, so scripts that preload others pick up the new versions of those too.
func _refresh_scripts() -> void:
	var names: PackedStringArray = ResourceLoader.list_directory("res://scripts") if ResourceLoader.has_method("list_directory") else DirAccess.get_files_at("res://scripts")
	for pass_no in 2:
		for f in names:
			f = f.trim_suffix(".remap").trim_suffix(".import")
			if not f.ends_with(".gd") or f == "Boot.gd":   # not this script: it is the one running
				continue
			var path := "res://scripts/" + f
			var s = ResourceLoader.load(path, "", ResourceLoader.CACHE_MODE_IGNORE)
			if s is Script:
				s.take_over_path(path)

# Game, Content and UI started before this scene, from the APK's copies. A CACHE_MODE_IGNORE load re-reads
# the pack's code into the same Script object (REPLACE keeps the old code - tested on an export), but the
# running node keeps its old layout until the script is detached and attached again; then _ready runs again.
func _swap_autoloads() -> void:
	for n in AUTOLOADS:
		var node := get_tree().root.get_node_or_null(n)
		var scr = ResourceLoader.load(AUTOLOADS[n], "", ResourceLoader.CACHE_MODE_IGNORE)
		if node != null and scr is Script:
			node.set_script(null)
			node.set_script(scr)
			if node.has_method("_ready"):
				node._ready()

func _process(_delta: float) -> void:
	if http != null and http.get_body_size() > 0:
		progress = float(http.get_downloaded_bytes()) / http.get_body_size()
	queue_redraw()

func _draw() -> void:
	var sz := get_viewport_rect().size
	draw_rect(Rect2(Vector2.ZERO, sz), Color("2a1e2e"))
	var font: Font = UI.body_font if UI.body_font else ThemeDB.fallback_font
	var y := sz.y / 2.0
	draw_string(font, Vector2(0, y - 10), "SAMURAI LEDGER", HORIZONTAL_ALIGNMENT_CENTER, sz.x, 48, Color("f2c14e"))
	draw_string(font, Vector2(0, y + 20), status, HORIZONTAL_ALIGNMENT_CENTER, sz.x, 24, Color(1, 1, 1, 0.8))
	if progress >= 0.0:
		var w := minf(400.0, sz.x - 80.0)
		draw_rect(Rect2((sz.x - w) / 2.0, y + 50, w, 14), Color(1, 1, 1, 0.15))
		draw_rect(Rect2((sz.x - w) / 2.0, y + 50, w * clampf(progress, 0.0, 1.0), 14), Color("f2c14e"))
	draw_string(font, Vector2(0, sz.y - 30), "content version %d" % installed_version(), HORIZONTAL_ALIGNMENT_CENTER, sz.x, 14, Color(1, 1, 1, 0.4))
