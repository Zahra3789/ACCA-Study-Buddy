extends Node
# Chapter Book (the spellbook: 2 chapters a page, numbered tabs) and the lessons:
# Learn -> Apply it (Zuru's Lemonade Stand) -> Worked example -> Your turn (practice battle).

const PER_SPREAD := 4
var main: Node
var book_tab := 0
var book_sel := 1
var L: Dictionary = {}   # {chId, li, phase, i}

func setup(m: Node) -> void:
	main = m

# ---------------------------------------------------------------- the book
func show_book() -> void:
	main.sfx("page")
	var s: Control = main.screen("book")
	var v: VBoxContainer = main.column(s, 58, 26, 20, 10, [Color("2a1e2e"), Color("3b2a52"), Color("2a1e2e")])
	v.add_child(UI.banner("CHAPTER BOOK"))
	var chs: Array = main.EXAM["chapters"]
	var tabs_n := int(ceil(chs.size() / float(PER_SPREAD)))
	var stars := UI.rich("[b]%d / %d[/b] stars collected.  Tap a chapter." % [main.total_stars(), chs.size() * 3], 26, false, true)
	if not main.landscape:   # sideways it sits above the chapter detail instead, to leave the book its height
		v.add_child(stars)
	var wrap := Control.new()
	wrap.custom_minimum_size = Vector2(668, 450)
	var book_img := "res://assets/rpg/Spellbook.png"
	if ResourceLoader.exists(book_img):
		var bi := UI.sprite(book_img, 668, 450)
		wrap.add_child(bi)
	else:
		var pb := Panel.new(); var sb := StyleBoxFlat.new(); sb.bg_color = Color("c9a97a"); sb.set_corner_radius_all(16); pb.add_theme_stylebox_override("panel", sb); pb.size = Vector2(620, 420); pb.position = Vector2(0, 15); wrap.add_child(pb)
	var start := book_tab * PER_SPREAD
	var spread := chs.slice(start, min(start + PER_SPREAD, chs.size()))
	if not spread.any(func(c): return int(c["id"]) == book_sel):
		book_sel = int(spread[0]["id"])
	var page_l := UI.vbox(6); page_l.position = Vector2(84 - 26, 34); page_l.size = Vector2(236, 312)
	var page_r := UI.vbox(6); page_r.position = Vector2(400 - 26, 34); page_r.size = Vector2(236, 312)
	for i in spread.size():
		(page_l if i < 2 else page_r).add_child(_chap_entry(spread[i]))
	wrap.add_child(page_l); wrap.add_child(page_r)
	var tabs := UI.vbox(2)
	tabs.position = Vector2(668 - 30 - 60, 12)
	for t in tabs_n:
		var tt := t
		var tab := Button.new()
		tab.flat = true
		tab.custom_minimum_size = Vector2(60, 60)
		var im := UI.tex("Tab0%d_Right_%s" % [(t % 5) + 1, "Selected" if t == book_tab else "Normal"])
		if im:
			tab.icon = im
			tab.expand_icon = true
		tab.text = str(t * PER_SPREAD + 1)
		tab.add_theme_font_size_override("font_size", 20)
		tab.add_theme_color_override("font_color", UI.LIGHT)
		tab.pressed.connect(func():
			if tt != book_tab:
				book_tab = tt
				show_book())
		tabs.add_child(tab)
	wrap.add_child(tabs)
	var wc := CenterContainer.new(); wc.add_child(wrap)
	var side := v
	var home_at := v
	if main.landscape:   # held sideways: the book (Home under it) on the left, the chapter detail beside it
		var cols := UI.hbox(16)
		cols.size_flags_vertical = Control.SIZE_EXPAND_FILL
		v.add_child(cols)
		home_at = UI.vbox(6)
		home_at.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		home_at.add_child(wc)
		cols.add_child(home_at)
		side = UI.vbox(8)
		side.add_child(stars)
		cols.add_child(side)
	else:
		v.add_child(wc)
	var detail := UI.box("BGbox_03A", true, Vector4(44, 44, 44, 40))
	detail.name = "detail"
	detail.size_flags_vertical = Control.SIZE_EXPAND_FILL
	side.add_child(detail)
	home_at.add_child(UI.button("Home", "05A", main.show_home))
	main.show_screen("book")
	chapter_detail(book_sel)

func _chap_entry(c: Dictionary) -> Control:
	var id := int(c["id"])
	var key := "%s/%d" % [main.exam_id, id]
	var best := Game.best(key)
	var st = main.stars(best)
	var p := PanelContainer.new()
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(1, 0.957, 0.839, 0.75) if id == book_sel else Color(1, 1, 1, 0.0)
	sb.set_corner_radius_all(6)
	if id == book_sel:
		sb.set_border_width_all(3); sb.border_color = UI.GOLD
	sb.content_margin_left = 10; sb.content_margin_right = 10; sb.content_margin_top = 8; sb.content_margin_bottom = 8
	p.add_theme_stylebox_override("panel", sb)
	p.custom_minimum_size.y = 150
	var v := UI.vbox(4)
	var h := UI.hbox(8)
	h.add_child(UI.sprite(main.MONSTER, 40, 36, id * 47))
	h.add_child(UI.title_label("Ch %d" % id, 24, UI.RED))
	var sr := UI.hbox(2)
	for i in 3:
		sr.add_child(UI.icon("Icon_01" if i < st else "Icon_02", 26))
	h.add_child(sr)
	v.add_child(h)
	var t := UI.label(c["title"], 22, UI.BROWN)
	t.max_lines_visible = 2
	t.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	v.add_child(t)
	var les: Array = c.get("lessons", [])
	var done := 0
	for l in les:
		if Game.lesson_passed("%s/%d/%s" % [main.exam_id, id, l["id"]]):
			done += 1
	v.add_child(UI.label(("Lessons %d/%d" % [done, les.size()]) if les.size() else "Quiz only", 18, UI.BLUE))
	v.add_child(UI.bar(float(done) / float(les.size()) if les.size() else 0.0, 200, 10))
	p.add_child(v)
	var btn := Button.new(); btn.flat = true; btn.set_anchors_preset(Control.PRESET_FULL_RECT)
	btn.pressed.connect(func():
		book_sel = id
		show_book())
	p.add_child(btn)
	return p

func open_chapter(id: int) -> void:
	book_tab = int((id - 1) / PER_SPREAD)
	book_sel = id
	show_book()

func chapter_detail(id: int) -> void:
	var detail: PanelContainer = main.screens["book"].find_child("detail", true, false)
	if detail == null:
		return
	var dv := UI.content(detail)
	UI.clear(dv)
	var c = main.get_ch(id)
	var key := "%s/%d" % [main.exam_id, id]
	var best := Game.best(key)
	var st = main.stars(best)
	var head := UI.hbox(14)
	head.add_child(UI.sprite(main.MONSTER, 120, 107, id * 47))
	var info := UI.vbox(6)
	info.add_child(UI.title_label(c["monster"], 28, UI.RED))
	info.add_child(UI.label("Chapter %d: %s" % [id, c["title"]], 24, UI.DARK))
	var les: Array = c.get("lessons", [])
	info.add_child(UI.label("⏱ about %d min%s%s" % [main.chapter_minutes(c), (" · %d lesson%s" % [les.size(), "" if les.size() == 1 else "s"]) if les.size() else "", " · Section B boss" if c.has("mtq") else ""], 22, UI.BLUE))
	var sr := UI.hbox(4)
	for i in 3:
		sr.add_child(UI.icon("Icon_01" if i < st else "Icon_02", 40))
	info.add_child(sr)
	head.add_child(info)
	dv.add_child(head)
	dv.add_child(UI.rich("[b]Sensei:[/b] " + main.S("chapter_pick", {"monster": c["monster"]}), 22))
	var path := UI.vbox(8)
	for i in les.size():
		var l: Dictionary = les[i]
		var done := Game.lesson_passed("%s/%s" % [key, l["id"]])
		var open: bool = i == 0 or Game.lesson_passed("%s/%s" % [key, les[i - 1]["id"]])
		var li := i
		var b := UI.button("%sLesson %d: %s" % ["✓ " if done else ("▶ " if open else "🔒 "), i + 1, l["title"]], "03A" if done else ("05A" if open else "04A"), func(): show_lesson(id, li), true, 24)
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.disabled = not open
		path.add_child(b)
	if c.has("mtq"):
		var mb := Game.best(key + "/mtq")
		path.add_child(UI.button("Section B boss - %d marks%s" % [int(c["mtq"]["marks"]), (" (best %d%%)" % mb) if mb else ""], "06A", func(): main.mtq.show_mtq(id), true, 24))
	path.add_child(UI.button("Quick battle - chapter questions%s" % ((" (best %d%%)" % best) if best else ""), "02A", func(): main.battle.start_chapter(id), true, 24))
	var sc := UI.scroll(path)
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	dv.add_child(sc)

# ---------------------------------------------------------------- lessons
func show_lesson(ch_id: int, li: int) -> void:
	L = {"chId": ch_id, "li": li, "phase": "learn", "i": 0}
	render_lesson()

func _phases(l: Dictionary) -> Array:
	var ph := [["learn", "Learn"]]
	if l.has("apply"):
		ph.append(["apply", "Apply it"])
	if l.has("example"):
		ph.append(["example", "Worked example"])
	ph.append(["turn", "Your turn"])
	return ph

func render_lesson() -> void:
	var c = main.get_ch(int(L["chId"]))
	var l: Dictionary = c["lessons"][int(L["li"])]
	var phases := _phases(l)
	var s: Control = main.screen("lesson")
	var v: VBoxContainer = main.column(s, 58, 26, 24, 12, [Color("1f5d63"), Color("2a3f55"), Color("2a1e2e")])
	v.add_child(UI.banner("LESSON %d" % (int(L["li"]) + 1)))
	var steps := UI.hbox(8)
	steps.alignment = BoxContainer.ALIGNMENT_CENTER
	for ph in phases:
		var pill := PanelContainer.new()
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color("ffe39a") if ph[0] == L["phase"] else Color(1, 1, 1, 0.15)
		sb.set_corner_radius_all(14); sb.content_margin_left = 14; sb.content_margin_right = 14; sb.content_margin_top = 4; sb.content_margin_bottom = 4
		pill.add_theme_stylebox_override("panel", sb)
		pill.add_child(UI.label(ph[1], 22, UI.DARK if ph[0] == L["phase"] else Color("fbe9d0")))
		steps.add_child(pill)
	v.add_child(steps)
	var sp := UI.banner("SENSEI OTTER", "BannerSmall_02C", 24)
	sp.custom_minimum_size = Vector2(280, 48)
	sp.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	v.add_child(sp)
	var frame := UI.box("BGbox_04A", true, Vector4(40, 44, 40, 36))
	frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var box := UI.vbox(10)
	var sc := UI.scroll(box)
	UI.content(frame).add_child(sc)
	v.add_child(frame)
	var zuru := UI.sprite(main.zuru_src("normal"), 84, 91)
	zuru.position = Vector2(main.W - 48 - 44 - 84, 198) if main.landscape else Vector2(720 - 26 - 44 - 84, 232)
	s.add_child(zuru)
	var nav := UI.hbox(12)
	v.add_child(nav)
	var tl := UI.title_label(l["title"], 30, UI.RED)
	box.add_child(tl)
	box.add_child(UI.label("Syllabus: " + str(l.get("outcome", c["title"])), 20, UI.BROWN))
	var phase: String = L["phase"]
	var i := int(L["i"])
	# Sensei's aside for this page (random; sometimes none mid-lesson). The lesson text itself never changes.
	var aside_key := "lesson_turn"
	match phase:
		"learn": aside_key = "lesson_open" if i == 0 else "lesson_page"
		"apply": aside_key = "lesson_apply"
		"example": aside_key = "lesson_example"
	var aside = main.S(aside_key)
	if aside != "":
		var al := UI.rich("[b]Sensei:[/b] " + aside, 22)
		al.add_theme_color_override("default_color", UI.BROWN)
		box.add_child(al)
	var pi := 0
	for k in phases.size():
		if phases[k][0] == phase:
			pi = k
	var go := func(ph: String, idx: int):
		L["phase"] = ph
		L["i"] = idx
		render_lesson()
	var next := func():
		go.call(phases[pi + 1][0], 0)
	var prev := func():
		if pi == 0:
			open_chapter(int(L["chId"]))
			return
		var pp: String = phases[pi - 1][0]
		var last := 0
		match pp:
			"learn": last = l["learn"].size() - 1
			"apply": last = l["apply"]["pages"].size() - 1
			"example": last = l["example"]["steps"].size() - 1
		go.call(pp, last)
	match phase:
		"learn":
			var p: Dictionary = l["learn"][i]
			box.add_child(UI.rich(str(p.get("text", "")), 26))
			if p.has("table"):
				box.add_child(UI.table(p["table"]))
			box.add_child(UI.label("Page %d of %d" % [i + 1, l["learn"].size()], 20, UI.BROWN))
			var n_learn: int = l["learn"].size()
			nav.add_child(UI.button("Back", "04A", func():
				if i > 0:
					go.call("learn", i - 1)
				else:
					prev.call()))
			nav.add_child(UI.button("Next", "03A", func():
				if i + 1 < n_learn:
					go.call("learn", i + 1)
				else:
					next.call()))
			main.speak(str(p.get("text", "")))
		"apply":
			var a: Dictionary = l["apply"]
			var p: Dictionary = a["pages"][i]
			var head := PanelContainer.new()
			var hs := StyleBoxFlat.new(); hs.bg_color = Color(0.1, 0.5, 0.3, 0.12); hs.border_width_left = 6; hs.border_color = UI.GREEN; hs.set_corner_radius_all(4); hs.content_margin_left = 12; hs.content_margin_right = 12; hs.content_margin_top = 6; hs.content_margin_bottom = 6
			head.add_theme_stylebox_override("panel", hs)
			head.add_child(UI.label("🍋 " + str(a.get("title", "Zuru's Lemonade Stand")), 26, UI.GREEN))
			box.add_child(head)
			box.add_child(UI.rich(str(p.get("text", "")), 26))
			if p.has("table"):
				box.add_child(UI.table(p["table"]))
			box.add_child(UI.label("Scene %d of %d" % [i + 1, a["pages"].size()], 20, UI.BROWN))
			var n_pages: int = a["pages"].size()
			nav.add_child(UI.button("Back", "04A", func():
				if i > 0:
					go.call("apply", i - 1)
				else:
					prev.call()))
			nav.add_child(UI.button("Next", "03A", func():
				if i + 1 < n_pages:
					go.call("apply", i + 1)
				else:
					next.call()))
			main.speak(str(p.get("text", "")))
		"example":
			var ex: Dictionary = l["example"]
			box.add_child(UI.rich("[b]%s[/b] - step %d of %d" % [ex["title"], i + 1, ex["steps"].size()], 26))
			box.add_child(UI.rich(str(ex["steps"][i]), 26))
			box.add_child(UI.table(ex["table"], i + 1))
			var n_steps: int = ex["steps"].size()
			nav.add_child(UI.button("Back", "04A", func():
				if i > 0:
					go.call("example", i - 1)
				else:
					prev.call()))
			nav.add_child(UI.button("Next step" if i + 1 < n_steps else "Next", "03A", func():
				if i + 1 < n_steps:
					go.call("example", i + 1)
				else:
					next.call()))
			main.speak(str(ex["steps"][i]))
		_:
			var kinds := []
			for q in l["practice"]:
				var hint: String = {"multi": "Multiple response", "picklist": "Pick list", "sort": "Sort", "input": "Number entry", "choice": "Multiple choice"}[q["type"]]
				if not kinds.has(hint):
					kinds.append(hint)
			var tail := (" and unlock Lesson %d." % (int(L["li"]) + 2)) if int(L["li"]) + 1 < c["lessons"].size() else (" and face the Section B boss." if c.has("mtq") else " and finish the chapter.")
			box.add_child(UI.rich("Time to test it! [b]%d exam-style questions[/b] (%s).\n\nScore [b]70%% or more[/b] to pass%s\n\nYou get Sensei's explanation after every answer." % [l["practice"].size(), ", ".join(kinds), tail], 26))
			nav.add_child(UI.button("Read again", "04A", func(): go.call("learn", 0)))
			var ch := int(L["chId"]); var li := int(L["li"])
			nav.add_child(UI.button("Start battle!", "06A", func(): main.battle.start_lesson_practice(ch, li)))
	main.show_screen("lesson")
