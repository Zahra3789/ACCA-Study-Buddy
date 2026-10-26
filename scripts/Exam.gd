extends Node
# Exam Hall. CBE structure in the game's own art: time remaining, Question n of N, Flag for review,
# Previous / Next / Navigator / End exam, no feedback until the results page.
#   Mock 1-5     fixed Section A papers (35 OT), mini mock (15, random)
#   Full Mock 1-3  the real format: 35 OT (70 marks) + two Section B cases (30 marks), 2 hours, pass 50

const FULL_MOCKS := [{"seed": 11, "mtq": [18, 24]}, {"seed": 12, "mtq": [20, 25]}, {"seed": 13, "mtq": [6, 24]}]
const SEC_PER_Q := 144.0

var main: Node
var X: Dictionary = {}
var running := false
var qno_label: Label
var time_label: Label
var flag_btn: Button
var body: VBoxContainer
var body_scroll: ScrollContainer
var nav: HBoxContainer
var prev_btn: Button
var next_btn: Button
var head_box: PanelContainer

func setup(m: Node) -> void:
	main = m

func stop_timer() -> void:
	running = false

func _process(_delta: float) -> void:
	if not running or X.is_empty() or X.get("done", false):
		return
	var left: float = float(X["total"]) - (Time.get_ticks_msec() - int(X["t0"])) / 1000.0
	time_label.text = "Time remaining " + UI.hhmmss(left)
	time_label.add_theme_color_override("font_color", Color("c8414b") if left < 300 else UI.BLUE)
	if left <= 0:
		end_exam(true, true)

# ---------------------------------------------------------------- Exam Hall menu
func show_mock() -> void:
	var v = main.menu("EXAM HALL", "BGbox_01B", false)
	v.add_child(main.text_for(v, "The real FA exam is [b]2 hours, 100 marks[/b]: Section A = 35 objective-test questions x 2 marks, Section B = 2 multi-task questions x 15 marks. Pass mark [b]50%[/b].\n\n[b]These mocks are NOT real ACCA papers.[/b] They are original questions in the ACCA CBE format (same question types, marks and pace). No feedback until the end, just like the real thing.", 24))
	v.add_child(main.text_for(v, "[b]Full mocks - the real format[/b]", 26))
	for k in range(1, 4):
		var kk := k
		var best := Game.best("%s/full/%d" % [main.exam_id, k])
		var f: Dictionary = FULL_MOCKS[k - 1]
		var t1: String = main.get_ch(int(f["mtq"][0]))["mtq"]["title"].replace("Section B: ", "")
		var t2: String = main.get_ch(int(f["mtq"][1]))["mtq"]["title"].replace("Section B: ", "")
		v.add_child(UI.button("Full Mock %d - 100 marks, 2 hours (35 OT + %s + %s)%s" % [k, t1, t2, ("  - best %d%%%s" % [best, " (pass)" if best >= 50 else ""]) if best else ""], ["06A", "02A", "01A"][k - 1], func(): start_full_mock(kk), true, 22))
	v.add_child(main.text_for(v, "[b]Section A practice[/b]", 26))
	for k in range(1, 6):
		var kk := k
		var best := Game.best("%s/mock/%d" % [main.exam_id, k])
		v.add_child(UI.button("Mock %d - 35 questions, 84 min%s" % [k, ("  - best %d%%%s" % [best, " (pass)" if best >= 50 else ""]) if best else ""], ["06A", "02A", "03A", "01A", "05A"][k - 1], func(): start_mock(35, kk), true, 24))
	var mini := Game.best("%s/mock15" % main.exam_id)
	v.add_child(UI.button("Mini mock (warm-up) - 15 questions, 36 min, random paper%s" % (("  - best %d%%" % mini) if mini else ""), "04A", func(): start_mock(15, 0), true, 24))

# ---------------------------------------------------------------- screen
func _build_screen(title: String) -> void:
	var s: Control = main.screen("exam")
	var v: VBoxContainer = main.column(s, 58, 26, 20, 12, [Color("141a33"), Color("3c4a7a"), Color("2a1e2e")])
	v.add_child(UI.banner(title))
	head_box = UI.box("BGbox_01A", true, Vector4(36, 36, 36, 38))
	var hr := UI.hbox(12)
	var hv := UI.vbox(4)
	qno_label = UI.label("", 26, UI.RED)
	time_label = UI.label("", 24, UI.BLUE)
	hv.add_child(qno_label); hv.add_child(time_label)
	hr.add_child(hv)
	flag_btn = UI.button("⚐ Flag", "03A", toggle_flag, true, 24)
	flag_btn.size_flags_horizontal = Control.SIZE_SHRINK_END
	flag_btn.custom_minimum_size = Vector2(150, 58)
	hr.add_child(flag_btn)
	UI.content(head_box).add_child(hr)
	v.add_child(head_box)
	var frame := UI.box("BGbox_04A", true, Vector4(40, 52, 40, 40))
	frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	body = UI.vbox(10)
	body_scroll = UI.scroll(body)
	UI.content(frame).add_child(body_scroll)
	v.add_child(frame)
	nav = UI.hbox(8)
	prev_btn = UI.button("◀ Prev", "05A", func(): go(-1), true, 24)
	next_btn = UI.button("Next ▶", "05A", func(): go(1), true, 24)
	nav.add_child(prev_btn); nav.add_child(next_btn)
	nav.add_child(UI.button("Navigator", "04A", grid_view, true, 24))
	nav.add_child(UI.button("End exam", "06A", func(): end_exam(false, false), true, 24))
	v.add_child(nav)
	main.show_screen("exam")

func start_mock(n: int, k := 0) -> void:
	var beats = main.mixed_paper(n, k if k > 0 else -1)
	X = {"n": beats.size(), "k": k, "beats": beats, "i": 0, "ans": {}, "flag": {}, "total": beats.size() * SEC_PER_Q, "t0": Time.get_ticks_msec(), "done": false, "confirm": false, "full": false,
		"key": ("%s/mock/%d" % [main.exam_id, k]) if k else ("%s/mock%d" % [main.exam_id, n])}
	_build_screen(("MOCK %d - FA" % k) if k else "MINI MOCK - FA")
	running = true
	render()

func start_full_mock(k: int) -> void:
	var f: Dictionary = FULL_MOCKS[k - 1]
	var beats = main.mixed_paper(35, int(f["seed"]))
	var mtqs := []
	for ch in f["mtq"]:
		mtqs.append({"chId": int(ch), "m": main.get_ch(int(ch))["mtq"], "tab": 0})
	var mtq_ans := []
	for i in mtqs.size():
		mtq_ans.append({})
	X = {"n": beats.size() + mtqs.size(), "k": "F%d" % k, "fk": k, "full": true, "beats": beats, "mtqs": mtqs, "mtqAns": mtq_ans, "i": 0, "ans": {}, "flag": {}, "total": 120 * 60.0, "t0": Time.get_ticks_msec(), "done": false, "confirm": false, "key": "%s/full/%d" % [main.exam_id, k]}
	_build_screen("FULL MOCK %d - FA" % k)
	running = true
	render()

func go(d: int) -> void:
	X["i"] = clamp(int(X["i"]) + d, 0, int(X["n"]) - 1)
	X["confirm"] = false
	render()

func toggle_flag() -> void:
	if X.get("done", false):
		return
	X["flag"][int(X["i"])] = not bool(X["flag"].get(int(X["i"]), false))
	render()

func answered(i: int) -> bool:
	if X.get("full", false) and i >= X["beats"].size():
		var ans: Dictionary = X["mtqAns"][i - X["beats"].size()]
		for k in ans.keys():
			if str(ans[k]).strip_edges() != "":
				return true
		return false
	return X["ans"].has(i)

func answered_count() -> int:
	var n := 0
	for i in int(X["n"]):
		if answered(i):
			n += 1
	return n

func ex_label(i: int) -> String:
	return ("B%d" % (i - X["beats"].size() + 1)) if (X.get("full", false) and i >= X["beats"].size()) else str(i + 1)

func _flag_text() -> void:
	var flagged := bool(X["flag"].get(int(X["i"]), false))
	flag_btn.text = "⚑ Flagged" if flagged else "⚐ Flag"
	for st in ["normal", "hover", "pressed"]:
		flag_btn.add_theme_stylebox_override(st, UI.button_style("06A" if flagged else "03A", "Normal" if st == "normal" else ("Selected" if st == "hover" else "Pressed")))

func render() -> void:
	var i := int(X["i"])
	if X.get("full", false) and i >= X["beats"].size():
		render_mtq(i - X["beats"].size())
		return
	var b: Dictionary = X["beats"][i]
	var a = X["ans"].get(i, null)
	qno_label.text = "%sQuestion %d of %d  -  2 marks" % ["Section A  -  " if X.get("full", false) else "", i + 1, X["beats"].size() if X.get("full", false) else int(X["n"])]
	_flag_text()
	prev_btn.disabled = i == 0
	next_btn.disabled = i == int(X["n"]) - 1
	UI.clear(body)
	if b.has("_topic"):
		body.add_child(UI.label(str(b["_topic"]), 20, UI.BROWN))
	body.add_child(UI.rich(main.q_text(b), 26))
	var styles := ["04A", "04A", "04A", "04A"]
	match b["type"]:
		"choice":
			for oi in b["opts"].size():
				var idx = oi
				var sel: bool = a != null and int(a) == oi
				var btn := UI.button("%s   %s" % ["ABCD"[oi], main.battle.drcr(str(b["opts"][oi]))], "03A" if sel else "04A", Callable(), true, 25)
				btn.pressed.connect(func():
					if sel:
						X["ans"].erase(i)
					else:
						X["ans"][i] = idx
					render())
				btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.custom_minimum_size.y = 84
				body.add_child(btn)
		"multi":
			var picked: Array = a if a != null else []
			body.add_child(UI.label("Select %s option%s" % [["", "ONE", "TWO", "THREE", "FOUR"][min(4, b["a"].size())], "s" if b["a"].size() > 1 else ""], 21, UI.BROWN))
			for oi in b["opts"].size():
				var idx = oi
				var sel: bool = picked.has(oi)
				var btn := UI.button("%s   %s" % ["ABCD"[oi], main.battle.drcr(str(b["opts"][oi]))], "03A" if sel else "04A", Callable(), true, 25)
				btn.pressed.connect(func():
					var p: Array = (X["ans"].get(i, []) as Array).duplicate()
					if p.has(idx):
						p.erase(idx)
					else:
						p.append(idx)
					if p.is_empty():
						X["ans"].erase(i)
					else:
						X["ans"][i] = p
					render())
				btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
				btn.custom_minimum_size.y = 84
				body.add_child(btn)
		"input":
			body.add_child(UI.label("Type your answer as a number (no units)", 21, UI.BROWN))
			var inp := UI.line_edit("Type your answer...", true, 30)
			inp.text = str(a) if a != null else ""
			inp.custom_minimum_size.y = 70
			inp.text_changed.connect(func(txt: String):
				if txt.strip_edges() != "":
					X["ans"][i] = txt.strip_edges()
				else:
					X["ans"].erase(i))
			body.add_child(inp)
			main.calc.target = inp
		"picklist":
			var parts: PackedStringArray = str(b["q"]).split("{")
			var sentence := ""
			for k in parts.size():
				if k == 0:
					sentence += parts[k]
					continue
				var close := parts[k].find("}")
				sentence += "[b]( %d )[/b]" % (int(parts[k].substr(0, close)) + 1) + parts[k].substr(close + 1)
			body.add_child(UI.rich(sentence, 26))
			var vals: Array = (a as Array).duplicate() if a != null else []
			while vals.size() < b["lists"].size():
				vals.append(-1)
			for li in b["lists"].size():
				var row := UI.hbox(8)
				row.add_child(UI.label("( %d )" % (li + 1), 24, UI.DARK))
				var o := UI.option(b["lists"][li])
				o.size_flags_horizontal = Control.SIZE_EXPAND_FILL
				if int(vals[li]) >= 0:
					o.select(int(vals[li]) + 1)
				var lii = li
				o.item_selected.connect(func(index: int):
					vals[lii] = o.get_item_id(index)
					var any := false
					for vv in vals:
						if int(vv) >= 0:
							any = true
					if any:
						X["ans"][i] = vals.duplicate()
					else:
						X["ans"].erase(i))
				row.add_child(o)
				body.add_child(row)
		"sort":
			var vals: Array = (a as Array).duplicate() if a != null else []
			while vals.size() < b["items"].size():
				vals.append(-1)
			for ii in b["items"].size():
				var row := UI.vbox(4)
				row.add_child(UI.label(str(b["items"][ii][0]), 24, UI.DARK))
				var br := UI.hbox(6)
				for bi in b["buckets"].size():
					var iii = ii; var bii = bi
					var bb := UI.button(str(b["buckets"][bi]), "03A" if int(vals[ii]) == bi else ["05A", "02A", "01A", "04A"][bi % 4], Callable(), true, 22)
					bb.pressed.connect(func():
						vals[iii] = bii
						X["ans"][i] = vals.duplicate()
						render())
					bb.custom_minimum_size.y = 52
					br.add_child(bb)
				row.add_child(br)
				body.add_child(row)
	body_scroll.scroll_vertical = 0

func render_mtq(mi: int) -> void:
	var S: Dictionary = X["mtqs"][mi]
	var m: Dictionary = S["m"]
	var ans: Dictionary = X["mtqAns"][mi]
	qno_label.text = "Section B  -  Question %s  -  15 marks" % ex_label(int(X["i"]))
	_flag_text()
	prev_btn.disabled = int(X["i"]) == 0
	next_btn.disabled = int(X["i"]) == int(X["n"]) - 1
	UI.clear(body)
	body.add_child(UI.label(str(m["title"]), 20, UI.BROWN))
	var tabs := UI.hbox(6)
	var labels := ["Scenario"]
	for i in m["tasks"].size():
		labels.append("Task %d (%d)" % [i + 1, main.mtq.task_marks(m["tasks"][i])])
	for i in labels.size():
		var ti := i
		var tb := UI.button(labels[i], "03A" if i == int(S["tab"]) else "05A", Callable(), true, 21)
		tb.pressed.connect(func():
			S["tab"] = ti
			render())
		tabs.add_child(tb)
	body.add_child(tabs)
	if int(S["tab"]) == 0:
		for p in m["scenario"]:
			if p.has("text"):
				body.add_child(UI.rich(str(p["text"]), 26))
			if p.has("table"):
				body.add_child(UI.table(p["table"]))
		body.add_child(UI.label("Read the scenario, then open the tasks above. Type amounts as positive numbers.", 21, UI.BROWN))
	else:
		var t: Dictionary = m["tasks"][int(S["tab"]) - 1]
		body.add_child(UI.title_label(t["title"], 28, UI.RED))
		body.add_child(UI.rich("[i]%s[/i]" % t["intro"], 24))
		var rows := []
		for r in t["rows"]:
			var rr: Dictionary = r.duplicate()
			var cells := []
			for x in r["c"]:
				cells.append(ans["profit"] if (str(x) == "(from Task 1)" and ans.has("profit")) else x)
			rr["c"] = cells
			rows.append(rr)
		body.add_child(UI.table({"cols": ["", "$"], "rows": rows}, -1, func(key: String) -> Control:
			var inp := UI.line_edit("?", true, 24)
			inp.custom_minimum_size.x = 140
			inp.text = str(ans.get(key, ""))
			inp.alignment = HORIZONTAL_ALIGNMENT_RIGHT
			inp.text_changed.connect(func(txt): ans[key] = txt)
			inp.focus_entered.connect(func(): main.calc.target = inp)
			return inp))
	body_scroll.scroll_vertical = 0

func grid_view() -> void:
	if X.get("done", false):
		return
	UI.clear(body)
	body.add_child(UI.rich("[b]Navigator[/b] - tap a question. Filled = answered, orange = flagged.", 24))
	var g := GridContainer.new()
	g.columns = 7
	g.add_theme_constant_override("h_separation", 8); g.add_theme_constant_override("v_separation", 8)
	for i in int(X["n"]):
		var ii := i
		var done := answered(i)
		var flagged := bool(X["flag"].get(i, false))
		var c := UI.button(ex_label(i), "01A" if done else ("03A" if flagged else "04A"), Callable(), true, 22)
		c.pressed.connect(func():
			X["i"] = ii
			render())
		c.custom_minimum_size = Vector2(80, 56)
		if i == int(X["i"]):
			c.add_theme_color_override("font_color", UI.GOLD)
		g.add_child(c)
	body.add_child(g)
	body.add_child(UI.label("%d of %d answered  -  %d flagged%s" % [answered_count(), int(X["n"]), X["flag"].values().filter(func(f): return f).size(), "  -  B1, B2 = Section B cases" if X.get("full", false) else ""], 21, UI.BROWN))

func grade(b: Dictionary, a) -> bool:
	if a == null:
		return false
	match b["type"]:
		"choice": return int(a) == int(b["a"])
		"multi":
			if (a as Array).size() != b["a"].size():
				return false
			for i in b["a"]:
				if not (a as Array).has(int(i)):
					return false
			return true
		"picklist":
			for i in b["a"].size():
				if i >= (a as Array).size() or int(a[i]) != int(b["a"][i]):
					return false
			return true
		"sort":
			for i in b["items"].size():
				if i >= (a as Array).size() or int(a[i]) != int(b["items"][i][1]):
					return false
			return true
	var n = main.norm(a)
	for x in b.get("accept", []):
		if main.norm(x) == n:
			return true
	return false

func given(b: Dictionary, a) -> String:
	if a == null:
		return "(not answered)"
	match b["type"]:
		"choice": return str(b["opts"][int(a)])
		"multi": return " + ".join((a as Array).map(func(i): return str(b["opts"][int(i)])))
		"picklist":
			var parts := []
			for i in (a as Array).size():
				parts.append("?" if int(a[i]) < 0 else str(b["lists"][i][int(a[i])]))
			return " / ".join(parts)
		"sort":
			var parts := []
			for i in b["items"].size():
				parts.append("%s: %s" % [b["items"][i][0], "?" if (i >= (a as Array).size() or int(a[i]) < 0) else str(b["buckets"][int(a[i])])])
			return ", ".join(parts)
	return str(a)

func end_exam(force: bool, time_up: bool) -> void:
	if X.is_empty() or X.get("done", false):
		return
	if not force and not bool(X["confirm"]):
		X["confirm"] = true
		var un := int(X["n"]) - answered_count()
		UI.clear(body)
		body.add_child(UI.rich("[b]End the exam?[/b]\n%sYou will not be able to return to it." % (("You have %d unanswered question%s. " % [un, "" if un == 1 else "s"]) if un else ""), 26))
		var row := UI.hbox(8)
		row.add_child(UI.button("No, go back", "05A", func():
			X["confirm"] = false
			render()))
		row.add_child(UI.button("Yes, end the exam", "06A", func(): end_exam(true, false)))
		body.add_child(row)
		return
	X["done"] = true
	running = false
	var used: float = min(float(X["total"]), (Time.get_ticks_msec() - int(X["t0"])) / 1000.0)
	var unanswered := int(X["n"]) - answered_count()
	var right := 0
	var rows := []
	for i in X["beats"].size():
		var b: Dictionary = X["beats"][i]
		var ok := grade(b, X["ans"].get(i, null))
		if ok:
			right += 1
		if b.has("_key"):
			Game.answer(b["_key"], b["_ch"], ok)
		rows.append({"b": b, "ok": ok, "given": given(b, X["ans"].get(i, null))})
	var sec_b := 0
	var mtq_rev := []
	if X.get("full", false):
		for mi in X["mtqs"].size():
			var S: Dictionary = X["mtqs"][mi]
			var ans: Dictionary = X["mtqAns"][mi]
			var lines := []
			for ti in S["m"]["tasks"].size():
				var t: Dictionary = S["m"]["tasks"][ti]
				for r in t["rows"]:
					for cell in r["c"]:
						if str(cell).begins_with("#"):
							var key := str(cell).substr(1)
							var bl: Dictionary = t["blanks"][key]
							var gv = main.norm(ans.get(key, ""))
							var ok := false
							for a in bl["accept"]:
								if main.norm(a) == gv:
									ok = true
							if ok:
								sec_b += int(bl["marks"])
							Game.answer("%s/%d/mtq/%d/%s" % [main.exam_id, int(S["chId"]), ti, key], "%s/%d" % [main.exam_id, int(S["chId"])], ok)
							lines.append({"ti": ti, "label": str(r["c"][0]), "ok": ok, "bl": bl, "given": str(ans.get(key, ""))})
			mtq_rev.append({"S": S, "lines": lines})
	var sec_a := right * 2
	var total: int = (sec_a + sec_b) if X.get("full", false) else right
	var maxm: int = 100 if X.get("full", false) else int(X["n"])
	var pct := int(round(float(total) / float(maxm) * 100.0))
	var passed := pct >= 50
	Game.record(X["key"], pct)
	Game.note("mock", {"k": X["k"], "pct": pct})
	main.sfx("win" if passed else "miss")
	var name: String = ("Full Mock %d" % int(X["fk"])) if X.get("full", false) else (("Mock %d" % int(X["k"])) if int(X["k"]) else "Mini mock")
	qno_label.text = "Results - " + name
	time_label.text = "Time used " + UI.hhmmss(used)
	time_label.add_theme_color_override("font_color", UI.BLUE)
	flag_btn.visible = false
	nav.visible = false
	UI.clear(body)
	var res := PanelContainer.new()
	var rs := StyleBoxFlat.new(); rs.bg_color = UI.GREEN if passed else Color("b3243b"); rs.set_corner_radius_all(10); rs.content_margin_left = 18; rs.content_margin_right = 18; rs.content_margin_top = 14; rs.content_margin_bottom = 14
	res.add_theme_stylebox_override("panel", rs)
	var rl := UI.label("%s  -  %s  (%d%%)" % ["PASS" if passed else "NOT YET", ("%d / 100 marks" % total) if X.get("full", false) else ("%d / %d correct" % [right, int(X["n"])]), pct], 32, UI.LIGHT, true)
	rl.add_theme_font_override("font", UI.title_o_font)
	res.add_child(rl)
	body.add_child(res)
	if X.get("full", false):
		body.add_child(UI.rich("[b]Section A[/b] %d / 70 (%d of 35 right)  -  [b]Section B[/b] %d / 30" % [sec_a, right, sec_b], 22))
	# Time, calmly and after the fact - no per-question clock, just whether the whole paper fitted.
	var mins_used := int(used / 60.0)
	var allowed := int(float(X["total"]) / 60.0)
	var fit := "comfortably inside the time." if mins_used <= allowed * 0.9 else ("right on the time - nicely paced." if not time_up else "the full time. In the real exam, flag the slow ones and come back to them.")
	body.add_child(UI.rich("[b]Time used:[/b] %s of %s - %s" % [UI.hm(maxi(1, mins_used)), UI.hm(allowed), fit], 22))
	body.add_child(UI.label("Pass mark 50%%. %sEvery wrong answer is now waiting at the Healer's Shrine." % (("Time ran out - %d unanswered. " % unanswered) if (time_up and unanswered) else ""), 21, UI.BROWN))
	var row := UI.hbox(8)
	if X.get("full", false):
		var fk := int(X["fk"])
		row.add_child(UI.button("Retake Full Mock %d" % fk, "03A", func(): start_full_mock(fk), true, 21))
	else:
		var n := int(X["n"]); var k := int(X["k"])
		row.add_child(UI.button(("Retake Mock %d" % k) if k else "Another mini mock", "03A", func(): start_mock(n, k), true, 21))
	row.add_child(UI.button("Exam Hall", "05A", show_mock, true, 21))
	row.add_child(UI.button("Home", "04A", main.show_home, true, 21))
	body.add_child(row)
	if X.get("full", false):
		body.add_child(UI.title_label("Section A", 26))
	for i in rows.size():
		var r: Dictionary = rows[i]
		var txt := "[b]Q%d %s[/b] %s\n[i]Your answer: %s[/i]" % [i + 1, "✓" if r["ok"] else "✗", r["b"]["q"], r["given"]]
		if not r["ok"]:
			txt += "\n[i]Correct: %s[/i]" % main.correct_text(r["b"])
		if r["b"].get("ex", "") != "":
			txt += "\n" + str(r["b"]["ex"])
		body.add_child(_review(txt, r["ok"]))
	for mr in mtq_rev:
		var got := 0
		for l in mr["lines"]:
			if l["ok"]:
				got += int(l["bl"]["marks"])
		body.add_child(UI.title_label("Section B - %s  (%d / 15)" % [str(mr["S"]["m"]["title"]).replace("Section B: ", ""), got], 26))
		for l in mr["lines"]:
			var txt := "[b]Task %d - %s %s[/b] (%d/%d)\n[i]Your answer: %s%s[/i]" % [int(l["ti"]) + 1, l["label"], "✓" if l["ok"] else "✗", int(l["bl"]["marks"]) if l["ok"] else 0, int(l["bl"]["marks"]), l["given"] if l["given"] != "" else "nothing", "" if l["ok"] else ("  -  correct: %s" % l["bl"].get("show", ""))]
			if l["bl"].get("ex", "") != "":
				txt += "\n" + str(l["bl"]["ex"])
			body.add_child(_review(txt, l["ok"]))
	body_scroll.scroll_vertical = 0

func _review(txt: String, ok: bool) -> Control:
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(1, 1, 1, 0.35)
	sb.border_width_left = 6
	sb.border_color = UI.GREEN if ok else Color("b3243b")
	sb.set_corner_radius_all(4)
	sb.content_margin_left = 12; sb.content_margin_right = 12; sb.content_margin_top = 10; sb.content_margin_bottom = 10
	p.add_theme_stylebox_override("panel", sb)
	p.add_child(UI.rich(txt, 22))
	return p
