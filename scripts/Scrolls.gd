extends Node
# Sensei's Scrolls: flip-cards for formats, formulas, rules and double entries (Content.gd "cards").
# Each card is on the Daily Review schedule as "FFA/card/<index>": Got it pushes it further out (1, 3, 7, 14,
# 30, 60 days), Not yet brings it back tomorrow. Learn new = up to 10 cards not seen yet, in chapter order.

var main: Node
var S: Dictionary = {}   # session: {"list": [card indexes], "i": n, "shown": bool, "right": n}

func setup(m: Node) -> void:
	main = m

func cards() -> Array:
	return main.EXAM.get("cards", [])

func key(i: int) -> String:
	return "%s/card/%d" % [main.exam_id, i]

func due() -> Array:
	var out := []
	for i in cards().size():
		if Game.box(key(i)) >= 0 and key(i) in Game.due(main.exam_id + "/card/"):
			out.append(i)
	return out

func unseen() -> Array:
	var out := []
	for i in cards().size():
		if Game.box(key(i)) < 0:
			out.append(i)
	return out

func show_scrolls() -> void:
	var v = main.menu("SENSEI'S SCROLLS", "BGbox_01B", false)
	var d := due().size(); var u := unseen().size(); var n := cards().size()
	v.add_child(main.text_for(v, "The things the exam expects you to know cold: formats, formulas, rules and double entries.\n\nRead the front, say the answer to yourself, then [b]Reveal[/b]. [b]Got it[/b] sends a scroll further away; [b]Not yet[/b] brings it back tomorrow.", 24))
	v.add_child(UI.button("Review due scrolls (%d)" % d if d else "No scrolls due today ✓", "06A", func(): _start(due()), true, 26))
	v.get_child(v.get_child_count() - 1).disabled = d == 0
	v.add_child(UI.button("Learn new scrolls (%d left)" % u if u else "All %d scrolls learned ✓" % n, "03A", func(): _start(unseen().slice(0, 10)), true, 26))
	v.get_child(v.get_child_count() - 1).disabled = u == 0
	v.add_child(UI.button("Browse all %d scrolls" % n, "05A", show_all, true, 26))

func show_all() -> void:
	var v = main.menu("ALL SCROLLS", "BGbox_01B", false)
	var ch := -1
	for i in cards().size():
		var c: Dictionary = cards()[i]
		if int(c["ch"]) != ch:
			ch = int(c["ch"])
			v.add_child(main.text_for(v, "[b]Chapter %d: %s[/b]" % [ch, main.get_ch(ch).get("title", "")], 26))
		var b := Game.box(key(i))
		v.add_child(main.text_for(v, "[b]%s[/b]%s\n%s" % [c["f"], "" if b < 0 else "   (level %d)" % (b + 1), c["b"]], 22))
	v.add_child(UI.button("Back to the scrolls", "03A", show_scrolls, true, 24))

func _start(list: Array) -> void:
	if list.is_empty():
		return
	S = {"list": main.shuffled(list) if list == due() else list, "i": 0, "shown": false, "right": 0}
	_render()

func _render() -> void:
	var list: Array = S["list"]
	if S["i"] >= list.size():
		var v0 = main.menu("SCROLLS DONE", "BGbox_01B", false)
		v0.add_child(main.text_for(v0, "[b]%d / %d[/b] known. The ones you knew come back later; the rest return tomorrow." % [S["right"], list.size()], 26))
		v0.add_child(UI.button("Back to the scrolls", "03A", show_scrolls, true, 26))
		main.sfx("win")
		return
	var idx: int = list[S["i"]]
	var c: Dictionary = cards()[idx]
	var v = main.menu("SCROLL %d / %d" % [S["i"] + 1, list.size()], "BGbox_01B", false)
	v.add_child(main.text_for(v, "[i]Chapter %d: %s[/i]" % [int(c["ch"]), main.get_ch(int(c["ch"])).get("title", "")], 20))
	var front := UI.box("BGbox_04A", true, Vector4(36, 32, 36, 30))
	UI.content(front).add_child(UI.rich("[b]" + str(c["f"]) + "[/b]", 30, true, true))
	v.add_child(front)
	if not S["shown"]:
		v.add_child(UI.button("Reveal", "06A", func(): S["shown"] = true; main.sfx("page"); _render(), true, 28))
		main.speak(str(c["f"]))
		return
	var back := UI.box("BGbox_04A", true, Vector4(36, 32, 36, 30))   # same light card as the front, so the answer reads clearly
	UI.content(back).add_child(UI.typed(str(c["b"]), 26, true))
	v.add_child(back)
	var row := UI.hbox(10)
	row.add_child(UI.button("Not yet", "02A", func(): _mark(idx, false), true, 26))
	row.add_child(UI.button("Got it", "03A", func(): _mark(idx, true), false, 26))
	v.add_child(row)
	main.speak(str(c["b"]))

func _mark(idx: int, ok: bool) -> void:
	Game.review(key(idx), ok)
	Game.save_game()
	if ok:
		S["right"] += 1
		main.sfx("hit")
	S["i"] += 1
	S["shown"] = false
	_render()
