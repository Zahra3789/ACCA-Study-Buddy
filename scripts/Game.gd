extends Node
# Autoload singleton "Game" — holds progress and saves it to the device.
# Progress is keyed per exam+chapter, e.g. "FFA/2", so different exams never clash.

const SAVE_PATH := "user://acca_study_buddy_save.json"

var progress: Dictionary = {}  # "FFA/2" -> { "best": int, "cleared": bool }

func _ready() -> void:
	load_game()

func get_best(key: String) -> int:
	var d = progress.get(key, {})
	return int(d.get("best", 0)) if typeof(d) == TYPE_DICTIONARY else 0

func is_cleared(key: String) -> bool:
	var d = progress.get(key, {})
	return bool(d.get("cleared", false)) if typeof(d) == TYPE_DICTIONARY else false

func record_result(key: String, pct: int) -> void:
	var cur: Dictionary = progress.get(key, {"best": 0, "cleared": false})
	cur["best"] = max(int(cur.get("best", 0)), pct)
	if pct >= 70:
		cur["cleared"] = true
	progress[key] = cur
	save_game()

func save_game() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f:
		f.store_string(JSON.stringify(progress))
		f.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if f:
		var txt := f.get_as_text()
		f.close()
		var data = JSON.parse_string(txt)
		if typeof(data) == TYPE_DICTIONARY:
			progress = data
