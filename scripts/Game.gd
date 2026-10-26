extends Node
# Autoload "Game" - everything that persists, saved to the device as JSON.
# Mirrors the HTML prototype's save (same keys), so a Backup code from the browser restores here.
#   progress  "FFA/3" / "FFA/mock/1" / "FFA/full/1" / "FFA/gauntlet" -> { best, cleared, last }
#   stats     "FFA/3" -> { seen, right }           every answer, every mode
#   mistakes  "FFA/3/4", "FFA/3/L1/2", "FFA/6/mtq/0/cos" -> true   (Healer's Shrine)
#   lessons   "FFA/3/L1" -> true                   lesson passed
#   log       "2026-10-27" -> { q, right, lessons[], mocks[], bosses, mtq[], sec }   (Notebook)
#   plan      { start, exam, wd, we, mocks }       study plan
#   dates     "FR" -> "2027-03-05"                 sitting dates
#   settings  { voice, sfx, xmas }                 (xmas: "auto" / true / false)

const SAVE_PATH := "user://acca_study_buddy_save.json"
const SAVED := ["progress", "stats", "mistakes", "xp", "lessons", "plan", "log", "dates"]

var progress: Dictionary = {}
var stats: Dictionary = {}
var mistakes: Dictionary = {}
var xp: int = 0
var lessons: Dictionary = {}
var plan = null
var log: Dictionary = {}
var dates: Dictionary = {}
var settings: Dictionary = {"voice": false, "sfx": true, "theme": "off", "sensei": "proper"}   # theme: off/xmas/halloween; sensei: proper / east (East London)
var exam_id: String = "FFA"

func _ready() -> void:
	load_game()

# ---------------------------------------------------------------- progress
func best(key: String) -> int:
	var d = progress.get(key, {})
	return int(d.get("best", 0)) if typeof(d) == TYPE_DICTIONARY else 0

func last_run(key: String) -> int:
	var d = progress.get(key, {})
	return int(d.get("last", 0)) if typeof(d) == TYPE_DICTIONARY else 0

func record(key: String, pct: int) -> void:
	var cur: Dictionary = progress.get(key, {"best": 0, "cleared": false})
	cur["best"] = max(int(cur.get("best", 0)), pct)
	if pct >= 70:
		cur["cleared"] = true
	progress[key] = cur
	save_game()

func record_last(key: String, n: int) -> void:
	var cur: Dictionary = progress.get(key, {"best": 0, "cleared": false})
	cur["last"] = n
	progress[key] = cur
	save_game()

# Every answered question in every mode: accuracy stats, XP, and the Shrine list.
func answer(q_key: String, chapter_key: String, ok: bool) -> void:
	var s: Dictionary = stats.get(chapter_key, {"seen": 0, "right": 0})
	s["seen"] = int(s.get("seen", 0)) + 1
	if ok:
		s["right"] = int(s.get("right", 0)) + 1
		mistakes.erase(q_key)
		xp += 10
	else:
		mistakes[q_key] = true
	stats[chapter_key] = s
	note("q", ok)

func accuracy(chapter_key: String) -> int:
	var s = stats.get(chapter_key, {})
	if typeof(s) != TYPE_DICTIONARY or int(s.get("seen", 0)) == 0:
		return -1
	return int(round(float(s.get("right", 0)) / float(s.get("seen", 1)) * 100.0))

func pass_lesson(key: String) -> void:
	lessons[key] = true
	note("lesson", key)

func lesson_passed(key: String) -> bool:
	return bool(lessons.get(key, false))

func level() -> int:
	return 1 + int(xp / 100)

func xp_in_level() -> int:
	return xp % 100

# ---------------------------------------------------------------- notebook
func today_key() -> String:
	var d := Time.get_date_dict_from_system()
	return "%04d-%02d-%02d" % [d.year, d.month, d.day]

func note(kind: String, v = null) -> void:
	var k := today_key()
	var e: Dictionary = log.get(k, {"q": 0, "right": 0, "lessons": [], "mocks": [], "bosses": 0, "mtq": [], "sec": 0})
	match kind:
		"q":
			e["q"] = int(e.get("q", 0)) + 1
			if v:
				e["right"] = int(e.get("right", 0)) + 1
		"lesson":
			var ls: Array = e.get("lessons", [])
			if not ls.has(v):
				ls.append(v)
			e["lessons"] = ls
		"mock":
			var ms: Array = e.get("mocks", [])
			ms.append(v)
			e["mocks"] = ms
		"bosses":
			e["bosses"] = int(e.get("bosses", 0)) + int(v)
		"mtq":
			var mt: Array = e.get("mtq", [])
			mt.append(v)
			e["mtq"] = mt
		"sec":
			e["sec"] = int(e.get("sec", 0)) + int(v)
	log[k] = e
	save_game()

# ---------------------------------------------------------------- settings / reset / backup
func save_settings() -> void:
	save_game()

func reset_all() -> void:
	progress = {}
	stats = {}
	mistakes = {}
	xp = 0
	lessons = {}
	log = {}
	save_game()   # the study plan, dates and settings survive a reset

func backup_code() -> String:
	var d := {}
	for f in SAVED:
		d[f] = get(f)
	return Marshalls.utf8_to_base64(JSON.stringify(d))

# Accepts the base64 code from Backup (here or in the HTML prototype) or the raw JSON.
func restore_code(code: String) -> bool:
	var raw := code.strip_edges()
	if not raw.begins_with("{"):
		raw = Marshalls.base64_to_utf8(raw)
	var data = JSON.parse_string(raw)
	if typeof(data) != TYPE_DICTIONARY:
		return false
	for f in SAVED:
		if data.has(f) and data[f] != null:
			set(f, data[f])
	xp = int(xp)
	save_game()
	return true

func save_game() -> void:
	var d := {"version": 3, "settings": settings, "exam": exam_id}
	for f in SAVED:
		d[f] = get(f)
	var fh := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if fh:
		fh.store_string(JSON.stringify(d))
		fh.close()

func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var fh := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if not fh:
		return
	var data = JSON.parse_string(fh.get_as_text())
	fh.close()
	if typeof(data) != TYPE_DICTIONARY:
		return
	if not data.has("version"):
		progress = data   # the very first save format held only progress
		return
	for f in SAVED:
		if data.has(f) and data[f] != null:
			set(f, data[f])
	if typeof(data.get("settings")) == TYPE_DICTIONARY:
		for k in data["settings"].keys():
			settings[k] = data["settings"][k]
	xp = int(xp)
	if typeof(data.get("exam")) == TYPE_STRING:
		exam_id = data["exam"]
