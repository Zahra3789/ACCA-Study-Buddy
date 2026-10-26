extends Control
# The "?" button: a panel saying what the current screen is for and what each of its buttons does.
# Picks its page from main.cur_screen, plus the menu title, battle mode, lesson step or mock state.

var main: Node
var title_label: Label
var body: RichTextLabel
var panel: PanelContainer

const TOP_BAR := "\n\n[b]The buttons along the top[/b] (on every screen)\n• [b]ESC[/b] - go back one step (to Home, or from Home to the exam list).\n• [b]SFX[/b] - sound effects, music and Zuru's battle shouts on or off.\n• [b]THEME[/b] - Christmas, then Halloween, then off.\n• [b]E-LDN[/b] - Sensei talks proper, or East London.\n• [b]DATES[/b] - ACCA exam sessions, entry deadlines and results dates.\n• [b]CALC[/b] - a calculator. [b]Use[/b] puts its answer into the answer box you last tapped. [b]_[/b] shrinks it to a small bar showing the answer, so you can read the question; [b]▢[/b] opens it again.\n• [b]?[/b] - this help.\n\n[b]Swiping back[/b] (from the edge of the screen) steps back like ESC. In a battle, lesson or Section B case, swipe twice to leave. A mock ignores it - use End exam. On the exam list, swipe twice to close the app."

const PAGES := {
	"title": ["EXAM LIST", "This is the dojo gate. Each card is one ACCA exam.\n\n• Tap [b]Financial Accounting[/b] (▶ ENTER) to study FA.\n• [b]PASSED[/b] exams are done; [b]TO TAKE[/b] exams have no content yet.\n• [b]Exam dates[/b] - set when you sit each exam. The countdown then shows on its card, and the study plan uses it."],
	"home": ["HOME", "Your base for this exam. Sensei Otter tells you today's targets from your study plan.\n\n• [b]Study plan[/b] - enter your exam date and hours; Sensei splits the chapters across the days.\n• [b]Notebook[/b] - what you did each day.\n• [b]Lv / XP bar[/b] - every right answer is +10 XP.\n• [b]Reset[/b] - wipes ALL progress (asks first).\n• [b]Backup / Restore[/b] - a code that copies your progress to another phone or browser.\n\n[b]The cards[/b]\n• [b]Daily Review[/b] - questions you have answered before, brought back just as you are about to forget them. 10 minutes a day.\n• [b]Sensei's Scrolls[/b] - flip-cards for formulas, formats, rules and double entries.\n• [b]Chapter Book[/b] - learn each chapter, lesson by lesson. Start here.\n• [b]Boss Arena[/b] - an endless run of chapter bosses. Tests everything.\n• [b]Training Grounds[/b] - practise questions by chapter or question type.\n• [b]Healer's Shrine[/b] - every question you got wrong, until you get it right.\n• [b]Exam Hall[/b] - timed mocks laid out like the real exam.\n• [b]Hall of Records[/b] - your strongest and weakest topics, and the syllabus map."],
	"book": ["CHAPTER BOOK", "Every chapter of the FA syllabus, guarded by a monster.\n\n• Tap a [b]chapter[/b] on the book's pages to see it on the right.\n• The [b]coloured tabs[/b] on the book's edge turn to more chapters.\n• Tap a [b]Lesson[/b] to study it. Pass a lesson's practice battle (70%) to unlock the next one. A 🔒 lesson is still locked.\n• [b]Stars[/b]: 50% = ★, 70% = ★★, 90% = ★★★.\n• After the last lesson, some chapters have a [b]Section B[/b] 15-mark case."],
	"lesson_learn": ["LESSON - LEARN", "Read the topic. It comes in short pages that type themselves out.\n\n• [b]Tap the page[/b] - shows the rest of the text at once; tap again to move on.\n• [b]Next[/b] - next page, then on to the next step.\n• [b]Back[/b] - previous page or step.\n• The pills at the top show the steps: [b]Learn → Apply it → Worked example → Your turn[/b]."],
	"lesson_apply": ["LESSON - APPLY IT", "The same idea at Zuru's Lemonade Stand: one story that grows from a shoebox of receipts to a group, using the same numbers through the chapters.\n\n• [b]Next[/b] / [b]Back[/b] move through it - or tap the page."],
	"lesson_example": ["LESSON - WORKED EXAMPLE", "Watch the numbers built up step by step, like an exam answer.\n\n• [b]Next[/b] / [b]Back[/b] move through it - or tap the page."],
	"lesson_turn": ["LESSON - YOUR TURN", "Time to prove it: a short practice battle on this lesson.\n\n• Start the battle and score [b]70%[/b] to pass the lesson and unlock the next one.\n• Anything you get wrong goes to the Healer's Shrine."],
	"battle": ["BATTLE", "Each right answer hits the monster; each wrong one hits Zuru.\n\n• Tap the [b]dialogue box[/b] (or ▼) to move the story on.\n• [b]A / B / C / D[/b] - tap your answer.\n• [b]Multiple response[/b] - tap every answer you think is right, then [b]Confirm[/b].\n• [b]Number entry[/b] - type the number, then [b]Strike![/b].\n• [b]Pick list[/b] - choose from each drop-down, then [b]Strike![/b].\n• [b]Sort[/b] - put every item in a column, then confirm.\n• [b]Run away[/b] - leave the battle (no score).\n\nScore [b]70%[/b] to defeat the monster. Wrong answers wait at the Healer's Shrine."],
	"battle_boss": ["BOSS ARENA", "One boss after another, from every chapter.\n\n• Each boss has a few HP; each right answer is a hit.\n• Zuru loses 1 HP per wrong answer and heals a little when a boss falls.\n• Beat the whole lap of bosses to start another lap. How far can you get?\n• [b]Run away[/b] ends the run and records how many bosses you beat."],
	"battle_review": ["DAILY REVIEW", "Spaced review: questions you have answered before come back just as you are about to forget them.\n\n• Answer each one as normal.\n• Right: it waits longer before coming back (1, 3, 7, 14, 30, then 60 days).\n• Wrong: it comes back tomorrow (and goes to the Healer's Shrine).\n• [b]I guessed this one[/b] (after a right answer): be honest - it comes back tomorrow, so a lucky guess never hides a gap.\n• [b]Finish session[/b] - stop whenever you like.\n\nA few minutes every day beats hours the night before."],
	"scrolls": ["SENSEI'S SCROLLS", "Flip-cards for the things the exam expects you to know cold.\n\n• [b]Review due scrolls[/b] - the ones scheduled for today.\n• [b]Learn new scrolls[/b] - up to 10 you have not seen, in chapter order.\n• [b]Browse all[/b] - every scroll, by chapter, with its answer.\n\nOn a card: read the front, say the answer to yourself, then [b]Reveal[/b]. [b]Got it[/b] sends it further away; [b]Not yet[/b] brings it back tomorrow."],
	"battle_drill": ["TRAINING", "Practice with no pressure: answer as many as you like.\n\n• Answer each question the same way as in battles.\n• [b]Finish session[/b] - stop whenever you want and see your score.\n• In the Healer's Shrine, each question you now get right is healed (removed from your list)."],
	"mtq": ["SECTION B CASE", "A 15-mark case like Section B of the real exam: a scenario, then tasks with part marks for every box.\n\n• [b]Scenario[/b] tab - the story and figures. Read it first.\n• [b]Task[/b] tabs - each task's questions. Fill in every box, then mark it.\n• [b]Start Task[/b] - go to the first task.\n• [b]Chapter Book[/b] - back to the chapters."],
	"exam": ["MOCK EXAM", "A timed mock laid out like the real ACCA computer exam. No feedback until the end, just like the real thing.\n\n• Answer, then [b]Next ▶[/b]. [b]◀ Prev[/b] goes back.\n• [b]⚐ Flag[/b] - mark a question to come back to.\n• [b]Navigator[/b] - see every question (answered, flagged, empty) and jump to any of them.\n• [b]End exam[/b] - finish and get your mark (asks first). When the clock hits zero it ends by itself.\n• Pass mark is [b]50%[/b]. Wrong answers go to the Healer's Shrine."],
	"exam_done": ["MOCK RESULT", "Your mark, by section, with every question reviewed: what you gave and the right answer.\n\n• Scroll down to review each question.\n• Wrong answers are now waiting at the Healer's Shrine."],
	"EXAM HALL": ["EXAM HALL", "Mocks in the real exam format. Original questions, not ACCA papers.\n\n• [b]Full Mock 1-3[/b] - the real thing: 35 Section A questions + two 15-mark Section B cases, 100 marks, 2 hours.\n• [b]Mock 1-5[/b] - Section A only: 35 questions in 84 minutes.\n• [b]Mini mock[/b] - a 15-question warm-up.\n• Your best score shows on each button. Pass mark is 50%."],
	"TRAINING GROUNDS": ["TRAINING GROUNDS", "Drill questions until they stick.\n\n• The buttons at the top pick a [b]question type[/b] (All, Tap answers, Type-in numbers...).\n• Then tap [b]All topics[/b] or one [b]chapter[/b]. The % is how often you've been right on it."],
	"HALL OF RECORDS": ["HALL OF RECORDS", "How you're doing, topic by topic.\n\n• [b]Syllabus map[/b] - every ACCA FA learning outcome and whether you've covered it.\n• [b]Drill my weakest topic[/b] - straight into practice on your lowest-scoring chapter.\n• The bars show your accuracy per chapter, weakest first."],
	"SYLLABUS MAP": ["SYLLABUS MAP", "Every learning outcome in the ACCA FA syllabus, grouped by area (A, B, C...).\n\n• Tap an area to open it.\n• Each outcome shows which chapter teaches it and whether you've studied it yet."],
	"BOSS ARENA": ["BOSS ARENA", "An endless gauntlet of chapter bosses, mixing every topic so you can't coast.\n\n• [b]Fight![/b] - start a run.\n• Each boss takes a few hits; you have 10 HP and heal a little after each boss.\n• Clear the whole lineup to start another lap."],
	"STUDY PLAN": ["STUDY PLAN", "Tell Sensei your dates and hours, and he plans every day up to the exam.\n\n• Fill in [b]start date[/b], [b]exam date[/b] (YYYY-MM-DD), and how many [b]hours[/b] you can study on weekdays and weekends.\n• Save it: Home then shows today's targets, and the calendar shows the whole plan.\n• It re-plans from today if you fall behind or get ahead."],
	"NOTEBOOK": ["NOTEBOOK", "A diary of what you did each day: lessons, battles, mocks and time studied. Filled in automatically."],
	"EXAM DATES": ["EXAM DATES", "Set the date you'll sit each exam (YYYY-MM-DD).\n\n• The countdown appears on the exam list and Home.\n• The study plan uses your FA date."],
	"KEY DATES": ["KEY DATES", "How booking works: on-demand exams (BT, MA, FA, LW) can be booked any day; session exams run four times a year, with entry deadlines and results dates shown here."],
}

func setup(m: Node) -> void:
	main = m
	visible = false
	set_anchors_preset(Control.PRESET_FULL_RECT)
	z_index = 42
	var dim := ColorRect.new()
	dim.color = Color(0, 0, 0, 0.55)
	dim.set_anchors_preset(Control.PRESET_FULL_RECT)
	dim.gui_input.connect(func(e: InputEvent):
		if e is InputEventMouseButton and e.pressed:
			close())
	add_child(dim)
	panel = UI.box("BGbox_04A", true, Vector4(40, 40, 40, 36))
	# Help and every pop-up in its own colours (forest green, gold frame) so it never blends into the orange boxes behind it
	var hs := StyleBoxFlat.new()
	hs.bg_color = Color("24533a")
	hs.border_color = Color("f2c14e")
	hs.set_border_width_all(6)
	hs.set_corner_radius_all(18)
	hs.shadow_color = Color(0, 0, 0, 0.45)
	hs.shadow_size = 14
	hs.content_margin_left = 34; hs.content_margin_right = 34; hs.content_margin_top = 30; hs.content_margin_bottom = 28
	panel.add_theme_stylebox_override("panel", hs)
	add_child(panel)
	var v := UI.content(panel)
	title_label = UI.title_label("HELP", 30, Color("f2c14e"))
	v.add_child(title_label)
	body = UI.rich("", 24, false)
	list = UI.vbox(18)
	var holder := UI.vbox(0)
	holder.add_child(list)
	holder.add_child(body)
	sc = UI.scroll(holder)
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(sc)
	body.meta_clicked.connect(func(url): OS.shell_open(str(url)))
	help_row = UI.hbox(10)
	guide_btn = UI.button("Guide", "06A", func(): open_guide(0), true, 22)
	help_row.add_child(guide_btn)
	credits_btn = UI.button("Credits", "05A", open_credits, true, 22)
	help_row.add_child(credits_btn)
	help_row.add_child(UI.button("Got it", "03A", close, false, 26))
	v.add_child(help_row)
	# the guide's own row: Back, the show-on-open switch, Next
	guide_row = UI.vbox(10)
	g_toggle = UI.button("", "05A", _toggle_guide_on_open, true, 20)
	guide_row.add_child(g_toggle)
	var gr := UI.hbox(10)
	g_back = UI.button("◀ Back", "04A", func(): _guide_step(-1), true, 24)
	g_next = UI.button("Next ▶", "03A", func(): _guide_step(1), false, 26)
	gr.add_child(g_back); gr.add_child(g_next)
	guide_row.add_child(gr)
	guide_row.visible = false
	v.add_child(guide_row)
	relayout()

var help_row: HBoxContainer
var guide_row: VBoxContainer
var guide_btn: Button
var g_toggle: Button
var g_back: Button
var g_next: Button
var g_step := 0
var list: VBoxContainer
var sc: ScrollContainer
var credits_btn: Button

# ---------------------------------------------------------------- the page as rows: a picture, a name, one short line
# The pages above are written as an intro, then "• [b]Name[/b] - what it does" lines. Each line becomes a row with the
# same picture the game uses for that thing (the Home card icons), with a gap between rows so it never reads as a wall.
const KEY_CARD := [["fight", "boss"], ["boss", "boss"], ["mock", "mock"], ["exam hall", "mock"], ["drill", "bank"], ["training", "bank"],
		["scroll", "scrolls"], ["review", "review"], ["heal", "heal"], ["shrine", "heal"], ["mistake", "heal"], ["record", "rec"],
		["syllabus", "rec"], ["weak", "rec"], ["exam-ready", "rec"], ["chapter", "book"], ["lesson", "book"]]
const KEY_ICON := [["plan", "Icon_11"], ["date", "Icon_11"], ["notebook", "Icon_12"], ["backup", "Icon_10"], ["restore", "Icon_10"],
		["reset", "Icon_10"], ["flag", "Icon_10"], ["xp", "Icon_05"], ["lv", "Icon_05"], ["star", "Icon_05"], ["mark", "Icon_05"],
		["hp", "Icon_17"], ["next", "Icon_02"], ["back", "Icon_02"], ["prev", "Icon_02"], ["page", "Icon_02"], ["tab", "Icon_02"],
		["answer", "Icon_09"], ["a / b", "Icon_09"], ["tap", "Icon_09"], ["type", "Icon_09"], ["box", "Icon_09"], ["start", "Icon_09"]]

# The top-bar buttons, drawn as the real buttons in miniature: [label, button art, what it does]
const TOP_KEYS := [["ESC", "04A", "Back one step"], ["SFX", "02A", "Sounds and music on / off"], ["THEME", "01A", "Christmas, Halloween or off"],
		["E-LDN", "04A", "Sensei in East London or proper"], ["DATES", "03A", "Exam sessions and deadlines"],
		["CALC", "06A", "Calculator (it can shrink to a bar)"], ["?", "03A", "This help"]]

func _icon_for(name: String) -> String:
	var n := name.to_lower()
	for k in KEY_CARD:
		if k[0] in n:
			for a in main.AREAS:
				if a["id"] == k[1]:
					return a["icon"]
	for k in KEY_ICON:
		if k[0] in n:
			return k[1]
	return "Icon_07"

func _parse(text: String) -> Dictionary:
	var paras := text.split("\n\n")
	var out := {"intro": paras[0], "items": []}
	for i in range(1, paras.size()):
		for line in paras[i].split("\n"):
			if line.begins_with("• "):
				var l := line.substr(2)
				var cut := l.find(" - ")
				var left := l.substr(0, cut) if cut > 0 else ""
				if cut > 0 and left.begins_with("[b]") and left.ends_with("[/b]") and left.count("[b]") == 1:
					out["items"].append([left.substr(3, left.length() - 7), l.substr(cut + 3)])
				else:
					out["items"].append(["", l])
			elif line.strip_edges() != "":
				out["items"].append([null, line])   # a plain line (a little heading or a note) stays where it was written
	return out

func _row(name: String, desc: String, icon := "") -> Control:
	var r := UI.hbox(16)
	var ic := UI.icon(icon if icon != "" else _icon_for(name + " " + desc.substr(0, 30)), 48.0)
	ic.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
	r.add_child(ic)
	var col := UI.vbox(2)
	if name != "":
		col.add_child(UI.label(name, 26, Color("f2c14e")))
	col.add_child(UI.rich(desc.substr(0, 1).to_upper() + desc.substr(1) if not desc.begins_with("[") else desc, 23, false))
	r.add_child(col)
	return r

func _fill(p: Array, first_time: bool) -> void:
	UI.clear(list)
	body.visible = false
	list.visible = true
	var d := _parse(p[1])
	list.add_child(UI.rich(d["intro"], 25, false))
	for it in d["items"]:
		list.add_child(UI.rich(it[1], 23, false) if it[0] == null else _row(it[0], it[1]))
	if first_time:
		list.add_child(UI.rich("[i]Tap [b]?[/b] at the top right any time to see this again.[/i]", 21, false))
		return
	list.add_child(UI.spacer(6))
	list.add_child(UI.label("The buttons along the top", 26, Color("f2c14e")))
	var g := GridContainer.new()
	g.columns = 2
	g.add_theme_constant_override("h_separation", 14)
	g.add_theme_constant_override("v_separation", 12)
	for k in TOP_KEYS:
		var b := UI.button(k[0], k[1], Callable(), true, 17)
		b.custom_minimum_size = Vector2(120, 44)
		b.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		b.mouse_filter = Control.MOUSE_FILTER_IGNORE
		b.focus_mode = Control.FOCUS_NONE
		g.add_child(b)
		g.add_child(UI.rich(k[2], 22, false))
	list.add_child(g)
	list.add_child(UI.rich("Swipe back from the screen's edge to go back, like [b]ESC[/b].", 22, false))

# ---------------------------------------------------------------- first time on a screen: a short "what is this?" card
# Shown once per page for everyone (we can't assume anyone knows how a part works), then only from the ? button.
func maybe_intro() -> void:
	await get_tree().create_timer(0.45).timeout   # let the screen set its mode (battle type, lesson step) first
	while Engine.has_meta("sl_splashing"):   # not under the opening splash
		await get_tree().create_timer(0.3).timeout
	if visible or not is_inside_tree() or main.calc.visible or not Game.settings.get("guide_on_open", true):   # switched off with the guide's button
		return
	var p := _page()
	var seen: Array = Game.settings.get("seen_help", [])
	var key := "%s:%d" % [p[0], str(p[1]).hash()]   # pages can share a title (the Boss Arena lobby and its battles)
	if key in seen or p[0] == "HELP":
		return
	seen.append(key)
	Game.settings["seen_help"] = seen
	Game.save_settings()
	title_label.text = "FIRST TIME HERE?  " + p[0]
	_compact = true
	_fill(p, true)
	_mode("first")
	relayout()
	visible = true
	sc.scroll_vertical = 0
	for i in 2:   # wrapped text only knows its height after a frame
		await get_tree().process_frame
		relayout()

var _compact := false   # the first-time card: only as tall as what it says, in the middle of the screen

func relayout() -> void:
	var full: float = main.H - 84.0
	var h: float = full
	if _compact:
		h = minf(full, list.get_combined_minimum_size().y + (330.0 if guide_row.visible else 230.0))
	panel.size = Vector2(main.W - 40, h)
	panel.position = Vector2(20, 64 + (full - h) / 2.0)

func _page() -> Array:
	match main.cur_screen:
		"menu":
			if "SCROLL" in main.menu_title:
				return PAGES["scrolls"]
			return PAGES.get(main.menu_title, ["HELP", "Scroll the panel to see everything here. [b]Home[/b] takes you back."])
		"lesson":
			return PAGES.get("lesson_" + str(main.book.L.get("phase", "learn")), PAGES["lesson_learn"])
		"battle":
			var mode := str(main.battle.s.get("mode", ""))
			if mode == "boss":
				return PAGES["battle_boss"]
			if mode == "review":
				return PAGES["battle_review"]
			return PAGES["battle_drill"] if mode in ["bank", "mistakes"] else PAGES["battle"]
		"exam":
			return PAGES["exam_done"] if main.exam.X.get("done", false) else PAGES["exam"]
	return PAGES.get(main.cur_screen, PAGES["home"])

func open() -> void:
	var p := _page()
	title_label.text = "HELP - " + p[0]
	_compact = false
	_fill(p, false)
	_mode("help")
	relayout()
	visible = true
	sc.scroll_vertical = 0

# Credits (Franuka's licence asks for a link back; the others are thanked too) and the disclaimer.
# Set as raw BBCode rather than through UI.bb, which escapes [url] tags, so the links can be tapped.
const CREDITS := "[b]Not affiliated with ACCA.[/b] This is a free, personal study aid. It is not affiliated with, endorsed or sponsored by ACCA or by any tuition provider or publisher.\n\n[b]Study aid only.[/b] The questions, lessons and mocks are original and may contain mistakes. Always check the official ACCA syllabus and study guide.\n\n[b]Art, sound and voice[/b] (tap a link to visit)\n• Menus, frames and buttons: [b]Franuka[/b], RPG UI pack - [url=https://franuka.itch.io]franuka.itch.io[/url]\n• Monster, battle effects, sounds and fight music: [b]Pixel-boy[/b], Ninja Adventure (CC0) - [url=https://pixel-boy.itch.io/ninja-adventure-asset-pack]pixel-boy.itch.io[/url]\n• Zuru the samurai: [b]MtPixls[/b], Samurai Character Pack - [url=https://mtpixls.itch.io/samurai-character-pack]mtpixls.itch.io[/url]\n• The moving Japan scenery on the title and home screens: [b]LyniaDesign[/b], Tiny Pixel Japan Parallax Background - [url=https://lyniadesign.itch.io/tiny-pixel-japan-parallax-background]lyniadesign.itch.io[/url]\n• The campfire: [b]ArlanTR[/b] (CC0) - [url=https://opengameart.org/content/campfire-pixel-art-animated]opengameart.org[/url]\n• Zuru's voice: [b]John Carroll[/b], Warrior Voice Pack (CC0) - [url=https://johncarroll.itch.io/warrior-voice-pack]johncarroll.itch.io[/url]\n• Spare UI pieces: [b]Kenney[/b] (CC0) - [url=https://kenney.nl]kenney.nl[/url]\n• Fonts: Pixelify Sans (Stefie Justprince), VT323 (Peter Hull), Silkscreen (Jason Kottke), SIL Open Font License - [url=https://fonts.google.com]fonts.google.com[/url]\n• App icon, Christmas and Halloween art and the other sounds: made for this game."

func open_credits() -> void:
	title_label.text = "CREDITS & DISCLAIMER"
	_compact = false
	_mode("help")
	list.visible = false
	body.visible = true
	body.text = "[font_size=24]" + CREDITS + "[/font_size]"
	relayout()
	visible = true

func close() -> void:
	visible = false

# Which buttons sit under the panel: help (Guide, Credits, Got it), first (just Got it), guide (show-on-open, Back, Next)
func _mode(m: String) -> void:
	help_row.visible = m != "guide"
	guide_row.visible = m == "guide"
	guide_btn.visible = m == "help"
	credits_btn.visible = m == "help"

# ---------------------------------------------------------------- the guide: a walk-through before you start
# Opens by itself when the app starts (unless switched off with its own button) and again from Help > Guide.
# Each step: [title, a line saying what it's about, rows of [icon, name, one short line]].
const GUIDE := [
	["WELCOME TO THE DOJO", "Samurai Ledger turns ACCA Financial Accounting (FA) into a game. Here's how it works - it takes a minute.", [
		["Icon_01", "The aim", "Learn every chapter, practise until it sticks, and walk into the exam ready."],
		["Icon_05", "Stars and XP", "Passing a lesson earns stars; every right answer gives XP and levels Zuru up."],
		["Icon_10", "Always saved", "Progress saves by itself. [b]Backup[/b] on Home copies it to another phone."]]],
	["STEP 1 - MAKE A PLAN", "Tell Sensei when your exam is, and he'll plan the days for you.", [
		["Icon_11", "Exam dates", "On the exam list, tap [b]Exam dates[/b] and enter the day you sit FA. A countdown appears."],
		["Icon_11", "Study plan", "On Home, tap [b]Study plan[/b], add your hours, and Sensei spreads the chapters over the days."],
		["Icon_12", "Notebook", "Fills itself in: what you did each day."]]],
	["STEP 2 - LEARN", "Work through the Chapter Book in order. Each chapter is guarded by a monster.", [
		["book", "Chapter Book", "Every chapter of the syllabus. Start with chapter 1."],
		["Icon_02", "Each lesson", "[b]Learn[/b], then [b]Apply it[/b], then a [b]Worked example[/b], then [b]Your turn[/b]."],
		["Icon_09", "Your turn", "A short battle: score 70% to pass the lesson and unlock the next one."]]],
	["STEP 3 - PRACTISE", "A little every day keeps it stuck.", [
		["review", "Daily Review", "Old questions come back just before you'd forget them. 10 minutes a day."],
		["scrolls", "Sensei's Scrolls", "Flip-cards for formats, rules and double entries."],
		["bank", "Training Grounds", "Drill any chapter or question type, no pressure."],
		["heal", "Healer's Shrine", "Everything you got wrong waits here until you get it right."]]],
	["STEP 4 - TEST YOURSELF", "When the chapters are done, check you're ready.", [
		["boss", "Boss Arena", "Bosses from every chapter, back to back. How far can you get?"],
		["mock", "Exam Hall", "Mocks laid out like the real computer exam, with a timer."],
		["rec", "Hall of Records", "Your strongest and weakest topics, so you know what to fix."]]],
	["IF YOU'RE EVER STUCK", "Help is always one tap away.", [
		["Icon_08", "? at the top right", "Explains the page you're on."],
		["Icon_08", "Small ? on a box", "Explains just that box."],
		["Icon_02", "ESC or swipe back", "Goes back one step."],
		["Icon_07", "This guide", "Open it again any time: [b]?[/b] then [b]Guide[/b]."]]],
]

func _area_icon(id: String) -> String:
	for a in main.AREAS:
		if a["id"] == id:
			return a["icon"]
	return id

func open_guide(step := 0) -> void:
	g_step = clampi(step, 0, GUIDE.size() - 1)
	_compact = true
	_mode("guide")
	var st: Array = GUIDE[g_step]
	title_label.text = "%s  (%d/%d)" % [st[0], g_step + 1, GUIDE.size()]
	UI.clear(list)
	body.visible = false
	list.visible = true
	list.add_child(UI.rich(st[1], 25, false))
	for r in st[2]:
		list.add_child(_row(r[1], r[2], _area_icon(r[0])))
	g_back.disabled = g_step == 0
	g_next.text = "Let's go!" if g_step == GUIDE.size() - 1 else "Next ▶"
	_draw_toggle()
	relayout()
	visible = true
	sc.scroll_vertical = 0
	for i in 2:
		await get_tree().process_frame
		relayout()

func _guide_step(d: int) -> void:
	main.sfx("tap")
	if g_step + d >= GUIDE.size():
		close()
		return
	open_guide(g_step + d)

func _draw_toggle() -> void:
	g_toggle.text = "Guide and first-time tips: " + ("ON" if Game.settings.get("guide_on_open", true) else "OFF")

func _toggle_guide_on_open() -> void:
	Game.settings["guide_on_open"] = not Game.settings.get("guide_on_open", true)
	Game.save_settings()
	_draw_toggle()

# Once per app start (not again after a live update reloads the screens), if it's switched on.
func guide_on_start() -> void:
	if Engine.has_meta("sl_guide_shown") or not Game.settings.get("guide_on_open", true):
		return
	Engine.set_meta("sl_guide_shown", true)
	open_guide(0)

# ---------------------------------------------------------------- a small ? in the corner of a box
# Explains just that box (the big ? at the top explains the whole page): the matching lines from the page's help.
func add_corner(box: Control, title: String, names: Array, page := "home") -> void:
	var layer := Control.new()   # a plain layer over the box, so the ? keeps its corner inside the box's container
	layer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	box.add_child(layer)
	var q := Button.new()   # a round gold "?" badge, clear at any size (the framed button art is too big for a corner)
	q.text = "?"
	q.focus_mode = Control.FOCUS_NONE
	q.add_theme_font_override("font", UI.body_font)
	q.add_theme_font_size_override("font_size", 18)
	for st in ["normal", "hover", "pressed"]:
		var sb := StyleBoxFlat.new()
		sb.bg_color = Color("f2c14e") if st != "pressed" else Color("d9a632")
		sb.border_color = Color("2b1d2a")
		sb.set_border_width_all(3)
		sb.set_corner_radius_all(13)
		sb.content_margin_bottom = 2
		q.add_theme_stylebox_override(st, sb)
		q.add_theme_color_override("font_color" if st == "normal" else "font_%s_color" % st, Color("2b1d2a"))
	q.pressed.connect(func(): main.sfx("tap"); open_box(title, names, page))
	layer.add_child(q)
	q.anchor_left = 1.0; q.anchor_right = 1.0; q.anchor_top = 0.0; q.anchor_bottom = 0.0
	q.offset_left = -24; q.offset_right = 6; q.offset_top = -8; q.offset_bottom = 22   # on the corner, as in the HTML

func open_box(title: String, names: Array, page := "home") -> void:
	var d := _parse(PAGES[page][1])
	_compact = true
	_mode("first")
	title_label.text = title
	UI.clear(list)
	body.visible = false
	list.visible = true
	for it in d["items"]:
		if it[0] != null and it[0] in names:
			list.add_child(_row(it[0], it[1]))
	relayout()
	visible = true
	sc.scroll_vertical = 0
	for i in 2:
		await get_tree().process_frame
		relayout()
