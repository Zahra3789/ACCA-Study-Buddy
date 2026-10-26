extends Node
# Study plan (chapters packed into the days she has, re-planned from today), week-grid calendar,
# Notebook (what happened each day), exam sitting dates and the Key Dates guide.
# Dates are "YYYY-MM-DD" strings; arithmetic uses unix days so clock changes can't drift it.

const MOCK_MIN := 115
const PLAN_DEFAULT := {"start": "2026-10-27", "exam": "2026-11-07", "wd": 3.0, "we": 6.0, "mocks": 2}
const MONTHS := ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
const WEEKDAYS := ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]

var main: Node

func setup(m: Node) -> void:
	main = m

# ---------------------------------------------------------------- dates
func today() -> String:
	return Game.today_key()

func unix(d: String) -> int:
	return int(Time.get_unix_time_from_datetime_string(d + "T00:00:00"))

func valid_date(d: String) -> bool:
	var re := RegEx.new()
	re.compile("^\\d{4}-\\d{2}-\\d{2}$")
	return re.search(d) != null

func days_between(a: String, b: String) -> int:
	return int(round((unix(b) - unix(a)) / 86400.0))

func add_days(d: String, n: int) -> String:
	var t := Time.get_datetime_dict_from_unix_time(unix(d) + n * 86400)
	return "%04d-%02d-%02d" % [t.year, t.month, t.day]

func weekday(d: String) -> int:
	return int(Time.get_datetime_dict_from_unix_time(unix(d)).weekday)   # 0 = Sunday

func fmt_day(d: String) -> String:
	if not valid_date(d):
		return d
	var t := Time.get_datetime_dict_from_unix_time(unix(d))
	return "%s %d %s" % [WEEKDAYS[int(t.weekday)], int(t.day), MONTHS[int(t.month) - 1]]

func date_of(x: Dictionary) -> String:
	if x["code"] == "FA" and Game.plan != null:
		return str(Game.plan.get("exam", ""))
	return str(Game.dates.get(x["code"], ""))

func mock_name(k) -> String:
	if typeof(k) == TYPE_STRING:
		return "Full Mock " + str(k).substr(1)
	return ("Mock %d" % int(k)) if int(k) else "Mini mock"

# ---------------------------------------------------------------- the plan
func build_plan():
	var P = Game.plan
	if P == null or typeof(P) != TYPE_DICTIONARY:
		return null
	var start := str(P["start"]); var exam_day := str(P["exam"]); var td := today()
	var first := td if unix(td) > unix(start) else start
	var days := []
	var d := first
	while unix(d) < unix(exam_day):
		var we := weekday(d) in [0, 6]
		days.append({"date": d, "cap": int(float(P["we"] if we else P["wd"]) * 60), "items": [], "used": 0})
		d = add_days(d, 1)
	var items := []
	for c in main.EXAM["chapters"]:
		items.append({"kind": "ch", "id": int(c["id"]), "label": "Ch %d %s" % [int(c["id"]), c["title"]], "short": "Ch %d" % int(c["id"]), "min": main.chapter_minutes(c), "done": main.chapter_done(c), "optional": false})
	for k in range(1, 4):
		items.append({"kind": "full", "id": k, "label": "Full Mock %d (100 marks, 2 hours + review)" % k, "short": "Full %d" % k, "min": 150, "done": Game.best("%s/full/%d" % [main.exam_id, k]) > 0, "optional": k > int(P["mocks"])})
	for k in range(1, 6):
		items.append({"kind": "mock", "id": k, "label": "Mock %d (Section A only, 35 questions)" % k, "short": "Mock %d" % k, "min": MOCK_MIN, "done": Game.best("%s/mock/%d" % [main.exam_id, k]) > 0, "optional": true})
	var todo := items.filter(func(i): return not i["done"])
	var left := []
	var di := 0
	for it in todo:
		while di < days.size() and (days[di]["used"] >= days[di]["cap"] * 0.9 or (days[di]["used"] > 0 and days[di]["used"] + it["min"] > days[di]["cap"] * 1.15)):
			di += 1
		if di >= days.size():
			left.append(it)
			continue
		days[di]["items"].append(it)
		days[di]["used"] += it["min"]
	var need := 0
	for i in todo:
		if not i["optional"]:
			need += int(i["min"])
	var cap := 0
	for dd in days:
		cap += int(dd["cap"])
	var total_days: int = max(1, days_between(start, exam_day))
	var days_left := days_between(td, exam_day)
	return {"P": P, "start": start, "exam": exam_day, "today": td, "days": days, "items": items, "left": left, "need": need, "cap": cap, "totalDays": total_days, "daysLeft": days_left,
		"dayNo": min(total_days, days_between(start, td) + 1), "behindMin": max(0, need - cap), "started": unix(td) >= unix(start), "over": days_left <= 0,
		"todayItems": days[0]["items"] if (days.size() and days[0]["date"] == td) else []}

func plan_summary() -> String:
	var B = build_plan()
	if B == null:
		return main.S("welcome_home") + " No study plan yet - tap [b]Study plan[/b] to set your start and exam dates."
	if B["over"]:
		return "Exam day - go and get it, Zuru!"
	if not B["started"]:
		return "Your plan starts [b]%s[/b]: %d study days to the exam on %s." % [fmt_day(B["start"]), B["totalDays"], fmt_day(B["exam"])] + ((" Heads up - it needs %s more than your hours allow." % UI.hm(B["behindMin"])) if B["behindMin"] else " It fits your hours.")
	var t: Array = B["todayItems"]
	var tm := 0
	for i in t:
		tm += int(i["min"])
	var s := "Day [b]%d of %d[/b] - %d day%s to the exam." % [B["dayNo"], B["totalDays"], B["daysLeft"], "" if B["daysLeft"] == 1 else "s"]
	s += (" Today: [b]%s[/b] (%s)." % [", ".join(t.map(func(i): return i["short"])), UI.hm(tm)]) if t.size() else " Nothing scheduled today - rest or heal wounds."
	s += (" [b]Behind by %s[/b] - blitz: add %d min a day." % [UI.hm(B["behindMin"]), int(ceil(float(B["behindMin"]) / max(B["daysLeft"], 1)))]) if B["behindMin"] else " On track."
	return s

func show_plan() -> void:
	var v = main.menu("STUDY PLAN", "BGbox_03A", true)
	var B = build_plan()
	if B == null:
		v.add_child(main.text_for(v, "Set your start date, exam date and the hours you can study. Sensei Otter will split the 26 chapters and the mocks across the days and show today's targets on the home screen."))
		plan_form(v)
		return
	v.add_child(UI.title_label("Exam %s - %s" % [fmt_day(B["exam"]), "today!" if B["over"] else ("%d days left" % B["daysLeft"])], 28))
	v.add_child(UI.button("Notebook - what I did each day", "04A", show_notebook, true, 24))
	v.add_child(main.text_for(v, plan_summary(), 24))
	var go := func(it: Dictionary):
		match it["kind"]:
			"ch": main.book.open_chapter(int(it["id"]))
			"full": main.exam.start_full_mock(int(it["id"]))
			_: main.exam.start_mock(35, int(it["id"]))
	if B["started"] and not B["over"]:
		v.add_child(UI.title_label("Today's targets", 26))
		if B["todayItems"].is_empty():
			v.add_child(main.text_for(v, "Nothing left for today. Heal wounds at the Shrine or get ahead with tomorrow's chapter.", 24))
		for it in B["todayItems"]:
			var item: Dictionary = it
			v.add_child(UI.button("%s  (%s)%s" % [it["label"], UI.hm(int(it["min"])), " - if time" if it["optional"] else ""], "01A" if it["kind"] != "ch" else "05A", func(): go.call(item), true, 22))
	v.add_child(UI.title_label("Calendar", 26))
	v.add_child(calendar(B))
	v.add_child(UI.label("Re-planned from today: whatever is not finished moves forward into the days you have left. Past days show what the Notebook recorded.", 20, UI.BROWN))
	v.add_child(UI.title_label("The schedule", 26))
	var done = B["items"].filter(func(i): return i["done"])
	if done.size():
		v.add_child(main.text_for(v, "✓ Done: " + ", ".join(done.map(func(i): return i["short"])), 22))
	for d in B["days"]:
		var txt := "[b]%s[/b] %s\n%s" % [fmt_day(d["date"]), UI.hm(int(d["cap"])), (", ".join(d["items"].map(func(i): return i["short"] + ("*" if i["optional"] else ""))) + " (%s)" % UI.hm(int(d["used"]))) if d["items"].size() else "-"]
		var r = main.text_for(v, txt, 22)
		if d["date"] == B["today"]:
			var p := PanelContainer.new()
			var sb := StyleBoxFlat.new(); sb.bg_color = Color(1, 0.89, 0.6, 0.55); sb.set_corner_radius_all(6); sb.content_margin_left = 6; sb.content_margin_right = 6
			p.add_theme_stylebox_override("panel", sb)
			p.add_child(r)
			v.add_child(p)
		else:
			v.add_child(r)
	var must_left = B["left"].filter(func(i): return not i["optional"])
	var opt_left = B["left"].filter(func(i): return i["optional"])
	if must_left.size():
		v.add_child(main.text_for(v, "[b]Does not fit:[/b] %s - %s over. Add hours, or blitz: lessons only and skip the quick battles." % [", ".join(must_left.map(func(i): return i["short"])), UI.hm(B["behindMin"])], 22))
	if opt_left.size():
		v.add_child(main.text_for(v, "* if time: " + ", ".join(opt_left.map(func(i): return i["short"])), 22))
	v.add_child(UI.title_label("Settings", 26))
	plan_form(v)

func calendar(B: Dictionary) -> Control:
	var g := GridContainer.new()
	g.columns = 7
	g.add_theme_constant_override("h_separation", 4); g.add_theme_constant_override("v_separation", 4)
	g.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for dn in ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]:
		g.add_child(UI.label(dn, 18, UI.BROWN, true))
	var monday := func(d: String) -> String:
		return add_days(d, -((weekday(d) + 6) % 7))
	var first: String = monday.call(B["start"])
	var last: String = add_days(monday.call(B["exam"]), 6)
	var by_day := {}
	for d in B["days"]:
		by_day[d["date"]] = d
	var d := first
	while unix(d) <= unix(last):
		var in_plan := unix(d) >= unix(B["start"]) and unix(d) < unix(B["exam"])
		var is_exam = d == B["exam"]
		var past := unix(d) < unix(B["today"])
		var cell := PanelContainer.new()
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color("8c2b3c") if is_exam else (Color(1, 0.89, 0.6, 0.5) if d == B["today"] else (Color(1, 1, 1, 0.22) if past else Color(1, 1, 1, 0.45)))
		if not in_plan and not is_exam:
			sb.bg_color.a = 0.12
		sb.set_corner_radius_all(6); sb.set_border_width_all(2); sb.border_color = UI.GOLD if d == B["today"] else Color(0.43, 0.25, 0.2, 0.3)
		sb.content_margin_left = 4; sb.content_margin_right = 4; sb.content_margin_top = 4; sb.content_margin_bottom = 4
		cell.add_theme_stylebox_override("panel", sb)
		cell.custom_minimum_size = Vector2(0, 104)
		cell.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var cv := UI.vbox(2)
		var t := Time.get_datetime_dict_from_unix_time(unix(d))
		var cap := ("%dh" % int(float(B["P"]["we"] if weekday(d) in [0, 6] else B["P"]["wd"]))) if in_plan else ""
		var nl := UI.label("%d%s  %s" % [int(t.day), (" " + MONTHS[int(t.month) - 1]) if (int(t.day) == 1 or d == first) else "", "EXAM" if is_exam else cap], 16, UI.LIGHT if is_exam else UI.DARK)
		cv.add_child(nl)
		if is_exam:
			cv.add_child(_chip("FA exam", Color("c8414b")))
		elif past:
			var e = Game.log.get(d, null)
			if e != null:
				var by_ch := {}
				for lk in e.get("lessons", []):
					var ps: PackedStringArray = str(lk).split("/")
					if ps.size() >= 3:
						by_ch[ps[1]] = int(by_ch.get(ps[1], 0)) + 1
				for ch in by_ch.keys():
					var cc = main.get_ch(int(ch))
					cv.add_child(_chip("Ch %s %dL" % [ch, by_ch[ch]], UI.GREEN if (cc.size() and main.chapter_done(cc)) else Color("c98a2e")))
				for mk in e.get("mocks", []):
					cv.add_child(_chip("%s %d%%" % [mock_name(mk["k"]), int(mk["pct"])], Color("c8414b")))
				if int(e.get("sec", 0)):
					cv.add_child(UI.label(UI.hm(int(round(int(e["sec"]) / 60.0))), 14, UI.BROWN))
			elif in_plan:
				cv.add_child(UI.label("-", 14, UI.BROWN))
		elif by_day.has(d):
			for it in by_day[d]["items"]:
				cv.add_child(_chip(it["short"] + ("*" if it["optional"] else ""), Color("c8414b") if it["kind"] != "ch" else (Color(0.24, 0.15, 0.19, 0.35) if it["optional"] else UI.BLUE)))
		cell.add_child(cv)
		g.add_child(cell)
		d = add_days(d, 1)
	return g

func _chip(text: String, color: Color) -> Control:
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new(); sb.bg_color = color; sb.set_corner_radius_all(5); sb.content_margin_left = 4; sb.content_margin_right = 4; sb.content_margin_top = 1; sb.content_margin_bottom = 1
	p.add_theme_stylebox_override("panel", sb)
	var l := UI.label(text, 14, UI.LIGHT)
	l.autowrap_mode = TextServer.AUTOWRAP_OFF
	l.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	p.add_child(l)
	return p

func plan_form(v: VBoxContainer) -> void:
	var P: Dictionary = PLAN_DEFAULT.duplicate()
	if Game.plan != null and typeof(Game.plan) == TYPE_DICTIONARY:
		for k in Game.plan.keys():
			P[k] = Game.plan[k]
	var inputs := {}
	for row_def in [["Start date (YYYY-MM-DD)", "start", false], ["Exam date (YYYY-MM-DD)", "exam", false], ["Weekday hours", "wd", true], ["Weekend hours", "we", true], ["Full mocks (minimum, 0-3)", "mocks", true]]:
		var r := UI.hbox(10)
		r.add_child(UI.label(row_def[0], 22, UI.DARK))
		var e := UI.line_edit("", row_def[2], 24)
		e.text = str(P[row_def[1]])
		e.custom_minimum_size.x = 230
		e.size_flags_horizontal = Control.SIZE_SHRINK_END
		inputs[row_def[1]] = e
		r.add_child(e)
		v.add_child(r)
	v.add_child(UI.button("Save plan", "06A", func():
		var st: String = inputs["start"].text.strip_edges(); var ex: String = inputs["exam"].text.strip_edges()
		if not valid_date(st) or not valid_date(ex) or unix(ex) <= unix(st):
			main.toast("The exam date must be after the start date (YYYY-MM-DD).")
			return
		Game.plan = {"start": st, "exam": ex, "wd": max(0.5, float(inputs["wd"].text)), "we": max(0.5, float(inputs["we"].text)), "mocks": clamp(int(inputs["mocks"].text), 0, 3)}
		Game.save_game()
		show_plan()))
	if Game.plan != null:
		v.add_child(UI.button("Clear plan", "04A", func():
			Game.plan = null
			Game.save_game()
			show_plan()))

# ---------------------------------------------------------------- notebook
func show_notebook() -> void:
	var v = main.menu("NOTEBOOK", "BGbox_04A", true)
	v.add_child(UI.button("Study plan", "03A", show_plan, true, 24))
	var days: Array = Game.log.keys()
	days.sort()
	days.reverse()
	if days.is_empty():
		v.add_child(main.text_for(v, "Nothing written yet. Every lesson, battle, boss and mock you do gets a line here, day by day."))
		return
	var q := 0; var r := 0; var sec := 0
	for k in days:
		var e: Dictionary = Game.log[k]
		q += int(e.get("q", 0)); r += int(e.get("right", 0)); sec += int(e.get("sec", 0))
	v.add_child(main.text_for(v, "[b]%d study day%s[/b] - %s in total, %d questions answered%s." % [days.size(), "" if days.size() == 1 else "s", UI.hm(int(round(sec / 60.0))), q, (" (%d%% right)" % int(round(float(r) / q * 100.0))) if q else ""]))
	for k in days:
		var e: Dictionary = Game.log[k]
		var lines := []
		var by_ch := {}
		for lk in e.get("lessons", []):
			var ps: PackedStringArray = str(lk).split("/")
			if ps.size() >= 3:
				var arr: Array = by_ch.get(ps[1], [])
				arr.append(ps[2])
				by_ch[ps[1]] = arr
		if by_ch.size():
			lines.append("Lessons: " + "; ".join(by_ch.keys().map(func(ch): return "Ch %s %s" % [ch, ", ".join(by_ch[ch])])))
		var finished := []
		for ch in by_ch.keys():
			var cc = main.get_ch(int(ch))
			if cc.size() and main.chapter_done(cc) and cc.get("lessons", []).size() and by_ch[ch].has(cc["lessons"][cc["lessons"].size() - 1]["id"]):
				finished.append(ch)
		if finished.size():
			lines.append("✓ Chapter%s %s finished" % ["s" if finished.size() > 1 else "", ", ".join(finished)])
		if e.get("mtq", []).size():
			lines.append("Section B: " + ", ".join(e["mtq"].map(func(m): return "Ch %d %d%%" % [int(m["ch"]), int(m["pct"])])))
		if int(e.get("q", 0)):
			lines.append("%d questions, %d right (%d%%)" % [int(e["q"]), int(e.get("right", 0)), int(round(float(e.get("right", 0)) / int(e["q"]) * 100.0))])
		if e.get("mocks", []).size():
			lines.append("Mocks: " + ", ".join(e["mocks"].map(func(m): return "%s %d%%" % [mock_name(m["k"]), int(m["pct"])])))
		if int(e.get("bosses", 0)):
			lines.append("Boss Arena: %d boss%s defeated" % [int(e["bosses"]), "" if int(e["bosses"]) == 1 else "es"])
		v.add_child(main.text_for(v, "[b]%s[/b] %s\n%s" % [fmt_day(k), UI.hm(int(round(int(e.get("sec", 0)) / 60.0))), "\n".join(lines) if lines.size() else "Looked around, no battles."], 22))

# ---------------------------------------------------------------- exam dates + key dates
func show_dates() -> void:
	var v = main.menu("EXAM DATES", "BGbox_03A", true)
	v.add_child(main.text_for(v, "Set the date you plan to sit each exam (YYYY-MM-DD). The title screen counts down to the next one. [b]FA[/b] follows your study plan."))
	var inputs := {}
	for x in main.ACCA_EXAMS:
		if x.get("passed", false):
			continue
		var r := UI.hbox(10)
		r.add_child(UI.label("%s - %s" % [x["code"], str(x["name"]).replace(" (compulsory)", "").replace(" or Data Science", "")], 22, UI.DARK))
		var e := UI.line_edit("YYYY-MM-DD", false, 22)
		e.text = date_of(x)
		e.custom_minimum_size.x = 200
		e.size_flags_horizontal = Control.SIZE_SHRINK_END
		inputs[x["code"]] = e
		r.add_child(e)
		v.add_child(r)
	v.add_child(UI.button("Save dates", "06A", func():
		for code in inputs.keys():
			var t: String = inputs[code].text.strip_edges()
			if valid_date(t):
				Game.dates[code] = t
			else:
				Game.dates.erase(code)
		if Game.plan != null and inputs.has("FA") and valid_date(inputs["FA"].text.strip_edges()):
			Game.plan["exam"] = inputs["FA"].text.strip_edges()
		Game.save_game()
		main.show_title()))
	v.add_child(UI.button("Back to the dojo", "05A", main.show_title))

func show_key_dates() -> void:
	var v = main.menu("KEY DATES", "BGbox_03A", true)
	var td := today()
	var sec := func(title: String) -> VBoxContainer:
		var p := PanelContainer.new()
		var sb := StyleBoxFlat.new(); sb.bg_color = Color(1, 1, 1, 0.42); sb.set_border_width_all(3); sb.border_color = Color(0.43, 0.25, 0.2, 0.4); sb.set_corner_radius_all(10)
		sb.content_margin_left = 16; sb.content_margin_right = 16; sb.content_margin_top = 12; sb.content_margin_bottom = 14
		p.add_theme_stylebox_override("panel", sb)
		var inner := UI.vbox(10)
		inner.add_child(UI.label(title, 27, UI.RED))
		p.add_child(inner)
		v.add_child(p)
		return inner
	var mine = sec.call("My exams")
	var any := false
	for x in main.ACCA_EXAMS:
		if x.get("passed", false) or date_of(x) == "":
			continue
		any = true
		var days := days_between(td, date_of(x))
		mine.add_child(UI.rich("[b]%s[/b] %s\n%s %s" % [x["code"], x["name"], fmt_day(date_of(x)), ("in %d days" % days) if days > 0 else ("today!" if days == 0 else "done")], 22))
	if not any:
		mine.add_child(UI.label("No sitting dates set yet.", 22, UI.DARK))
	mine.add_child(UI.button("Exam dates - set / change", "03A", show_dates, true, 24))
	var od = sec.call("On-demand exams - BT, MA, FA, LW")
	od.add_child(UI.rich("Book [b]any day[/b] at an ACCA centre (or remote), usually a week or two ahead.\n\nResult shows [b]on screen at the end[/b].\n\nNo sessions, no entry deadline - pick a date in myACCA and book.", 24))
	var se = sec.call("Session exams - FR, TX, FM, PM, AA, SBL, SBR, options")
	se.add_child(UI.rich("Four sessions a year. Exams run in the [b]first full week[/b] of the month.\n\nStandard entry closes about [b]5 weeks before[/b]; late entry (higher fee) about [b]4 weeks before[/b]; results about [b]4 weeks after[/b].", 24))
	se.add_child(UI.table({"cols": ["Session", "Exam week", "Standard entry", "Late entry", "Results"], "rows": [{"c": ["March", "early Mar", "late Jan", "early Feb", "mid Apr"]}, {"c": ["June", "early Jun", "late Apr", "early May", "mid Jul"]}, {"c": ["September", "early Sep", "late Jul", "early Aug", "mid Oct"]}, {"c": ["December", "early Dec", "late Oct", "early Nov", "mid Jan"]}]}))
	var rt = sec.call("Rules of thumb")
	rt.add_child(UI.rich("- Book the session [b]before[/b] you start studying - it fixes the deadline.\n- Diary the [b]standard entry[/b] date, not the late one.\n- Up to 4 exams a session; [b]1-2[/b] is realistic alongside work.\n- Results day comes while the next session's entry is still open - you can roll straight on.", 24))
	v.add_child(UI.button("Open ACCA exam dates and entry deadlines (official)", "04A", func(): OS.shell_open("https://www.accaglobal.com/gb/en/student/exam-entry-and-administration.html"), true, 22))
