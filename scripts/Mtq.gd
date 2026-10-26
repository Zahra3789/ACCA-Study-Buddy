extends Node
# Section B boss: a 15-mark multi-task case. Scenario tab + one tab per task; the task table has answer boxes
# (cells starting with # in Content.gd). Each box is marked on its own with part marks, like the real exam.
# Wrong boxes go to the Healer's Shrine as number-entry questions.

var main: Node
var M: Dictionary = {}

func setup(m: Node) -> void:
	main = m

func task_marks(t: Dictionary) -> int:
	var s := 0
	for k in t["blanks"].keys():
		s += int(t["blanks"][k]["marks"])
	return s

func show_mtq(ch_id: int) -> void:
	var c = main.get_ch(ch_id)
	M = {"chId": ch_id, "m": c["mtq"], "tab": 0, "done": {}, "got": 0, "ans": {}}
	render()

func render() -> void:
	var m: Dictionary = M["m"]
	var s: Control = main.screen("mtq")
	var v: VBoxContainer = main.column(s, 58, 26, 20, 12, [Color("3a0f1e"), Color("5a2a3a"), Color("2a1e2e")])
	var head := UI.hbox(14)
	head.add_child(UI.sprite(main.MONSTER, 111, 99, int(M["chId"]) * 47))
	var info := UI.vbox(6)
	info.add_child(UI.label(m["title"], 26, Color("fbe9d0")))
	info.add_child(UI.bar(1.0 - float(M["got"]) / float(m["marks"]), 300, 26))
	info.add_child(UI.label("%s  -  your marks %d / %d" % [m["monster"], M["got"], int(m["marks"])] + (("  ·  " + main.S("mtq_intro")) if (int(M["tab"]) == 0 and int(M["got"]) == 0) else ""), 22, Color("fbe9d0")))
	head.add_child(info)
	var zuru = load("res://scripts/ZuruLive.gd").make(130, 116, true)
	zuru.name = "mtqYou"
	head.add_child(zuru)
	v.add_child(head)
	var tabs := UI.hbox(6)
	var labels := ["Scenario"]
	for i in m["tasks"].size():
		labels.append("Task %d (%d)%s" % [i + 1, task_marks(m["tasks"][i]), " ✓" if M["done"].has(i) else ""])
	for i in labels.size():
		var ti := i
		var b := UI.button(labels[i], "03A" if i == int(M["tab"]) else "05A", Callable(), true, 22)
		b.pressed.connect(func():
			M["tab"] = ti
			render())
		tabs.add_child(b)
	v.add_child(tabs)
	var frame := UI.box("BGbox_04A", true, Vector4(40, 44, 40, 36))
	frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := UI.vbox(10)
	UI.content(frame).add_child(UI.scroll(box))
	v.add_child(frame)
	var nav := UI.hbox(10)
	v.add_child(nav)
	var all_done := true
	for i in m["tasks"].size():
		if not M["done"].has(i):
			all_done = false
	if int(M["tab"]) == 0:
		for p in m["scenario"]:
			if p.has("text"):
				box.add_child(UI.rich(str(p["text"]), 26))
			if p.has("table"):
				box.add_child(UI.table(p["table"]))
		nav.add_child(UI.button("Start Task 1", "06A", func():
			M["tab"] = 1
			render()))
	else:
		var ti := int(M["tab"]) - 1
		var t: Dictionary = m["tasks"][ti]
		var done = M["done"].has(ti)
		box.add_child(UI.title_label(t["title"], 28, UI.RED))
		box.add_child(UI.rich("[i]%s[/i]" % t["intro"], 24))
		var rows := []
		for r in t["rows"]:
			var rr: Dictionary = r.duplicate()
			var cells := []
			for x in r["c"]:
				cells.append(M["ans"]["profit"] if (str(x) == "(from Task 1)" and M["ans"].has("profit")) else x)
			rr["c"] = cells
			rows.append(rr)
		box.add_child(UI.table({"cols": ["", "$"], "rows": rows}, -1, func(key: String) -> Control:
			var inp := UI.line_edit("?", true, 24)
			inp.custom_minimum_size.x = 150
			inp.text = str(M["ans"].get(key, ""))
			inp.alignment = HORIZONTAL_ALIGNMENT_RIGHT
			inp.text_changed.connect(func(txt): M["ans"][key] = txt)
			inp.focus_entered.connect(func(): main.calc.target = inp)
			if done:
				inp.editable = false
				var ok := _ok(t, key)
				var sb := StyleBoxFlat.new()
				sb.bg_color = Color("d9f5df") if ok else Color("ffe0e0")
				sb.set_border_width_all(3); sb.border_color = Color("2e8b57") if ok else Color("c8414b"); sb.set_corner_radius_all(6)
				inp.add_theme_stylebox_override("normal", sb)
				inp.add_theme_stylebox_override("read_only", sb)
			return inp))
		if done:
			box.add_child(UI.rich("[b]Task %d: %d / %d marks[/b]" % [ti + 1, int(M["done"][ti]), task_marks(t)], 24))
			for r in t["rows"]:
				for cell in r["c"]:
					if str(cell).begins_with("#"):
						var key := str(cell).substr(1)
						var bl: Dictionary = t["blanks"][key]
						var ok := _ok(t, key)
						box.add_child(UI.rich("%s [b]%s: %s[/b] (%d/%d)%s. %s" % ["✓" if ok else "✗", r["c"][0], bl.get("show", ""), bl["marks"] if ok else 0, bl["marks"], "" if ok else (" - you put %s" % (str(M["ans"].get(key, "")) if str(M["ans"].get(key, "")) != "" else "nothing")), bl.get("ex", "")], 22))
		if not done:
			nav.add_child(UI.button("Submit task", "06A", func(): mark_task(ti)))
		elif ti + 1 < m["tasks"].size():
			nav.add_child(UI.button("Go to Task %d" % (ti + 2), "06A", func():
				M["tab"] = ti + 2
				render()))
	if all_done:
		var pct := int(round(float(M["got"]) / float(m["marks"]) * 100.0))
		var msg := "Strong - that is pass territory." if int(M["got"]) >= 10 else ("Over halfway - check the ✗ lines." if int(M["got"]) >= 8 else "Keep going - redo the lessons for the lines you missed.")
		box.add_child(UI.rich("[b]Section B result: %d / %d marks (%d%%)[/b]. %s" % [int(M["got"]), int(m["marks"]), pct, msg], 26))
		box.move_child(box.get_child(box.get_child_count() - 1), 0)
		UI.clear(nav)
		nav.add_child(UI.button("Try again", "06A", func(): show_mtq(int(M["chId"]))))
		nav.add_child(UI.button("Chapter Book", "03A", func(): main.book.open_chapter(int(M["chId"]))))
	else:
		nav.add_child(UI.button("Chapter Book", "04A", func(): main.book.open_chapter(int(M["chId"]))))
	main.show_screen("mtq")

func _ok(t: Dictionary, key: String) -> bool:
	var given = main.norm(M["ans"].get(key, ""))
	for a in t["blanks"][key]["accept"]:
		if main.norm(a) == given:
			return true
	return false

func mark_task(ti: int) -> void:
	var m: Dictionary = M["m"]
	var t: Dictionary = m["tasks"][ti]
	var got := 0
	for key in t["blanks"].keys():
		var ok := _ok(t, key)
		if ok:
			got += int(t["blanks"][key]["marks"])
		Game.answer("%s/%d/mtq/%d/%s" % [main.exam_id, int(M["chId"]), ti, key], "%s/%d" % [main.exam_id, int(M["chId"])], ok)
	M["done"][ti] = got
	M["got"] = int(M["got"]) + got
	var half := got >= task_marks(t) / 2.0
	main.sfx("hit" if half else "miss")
	var zuru: Control = main.screens["mtq"].find_child("mtqYou", true, false)
	main.mood(zuru, "happy" if half else "sad", 4.0)
	var all_done := true
	for i in m["tasks"].size():
		if not M["done"].has(i):
			all_done = false
	if all_done:
		var pct := int(round(float(M["got"]) / float(m["marks"]) * 100.0))
		Game.record("%s/%d/mtq" % [main.exam_id, int(M["chId"])], pct)
		Game.note("mtq", {"ch": int(M["chId"]), "pct": pct})
	render()
