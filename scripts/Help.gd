extends Control
# The "?" button: a panel saying what the current screen is for and what each of its buttons does.
# Picks its page from main.cur_screen, plus the menu title, battle mode, lesson step or mock state.

var main: Node
var title_label: Label
var body: RichTextLabel
var panel: PanelContainer

const TOP_BAR := "\n\n[b]The buttons along the top[/b] (on every screen)\n• [b]ESC[/b] - go back one step (to Home, or from Home to the exam list).\n• [b]VOICE[/b] - your phone reads questions and Sensei's lines aloud.\n• [b]SFX[/b] - sound effects, music and Zuru's battle shouts on or off.\n• [b]THEME[/b] - Christmas, then Halloween, then off.\n• [b]E-LDN[/b] - Sensei talks proper, or East London.\n• [b]DATES[/b] - ACCA exam sessions, entry deadlines and results dates.\n• [b]CALC[/b] - a calculator. [b]Use[/b] puts its answer into the answer box you last tapped.\n• [b]?[/b] - this help.\n\n[b]Swiping back[/b] (from the edge of the screen) steps back like ESC. In a battle, lesson or Section B case, swipe twice to leave. A mock ignores it - use End exam. On the exam list, swipe twice to close the app."

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
	add_child(panel)
	var v := UI.content(panel)
	title_label = UI.title_label("HELP", 30, UI.RED)
	v.add_child(title_label)
	body = UI.rich("", 24, true)
	var sc := UI.scroll(body)
	sc.size_flags_vertical = Control.SIZE_EXPAND_FILL
	v.add_child(sc)
	body.meta_clicked.connect(func(url): OS.shell_open(str(url)))
	var row := UI.hbox(10)
	row.add_child(UI.button("Credits & disclaimer", "05A", open_credits, true, 22))
	row.add_child(UI.button("Got it", "03A", close, false, 26))
	v.add_child(row)
	relayout()

func relayout() -> void:
	panel.position = Vector2(20, 64)
	panel.size = Vector2(main.W - 40, main.H - 84)

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
	UI.set_rich(body, p[1] + TOP_BAR, 24)
	relayout()
	visible = true

# Credits (Franuka's licence asks for a link back; the others are thanked too) and the disclaimer.
# Set as raw BBCode rather than through UI.bb, which escapes [url] tags, so the links can be tapped.
const CREDITS := "[b]Not affiliated with ACCA.[/b] This is a free, personal study aid. It is not affiliated with, endorsed or sponsored by ACCA or by any tuition provider or publisher.\n\n[b]Study aid only.[/b] The questions, lessons and mocks are original and may contain mistakes. Always check the official ACCA syllabus and study guide.\n\n[b]Art, sound and voice[/b] (tap a link to visit)\n• Menus, frames and buttons: [b]Franuka[/b], RPG UI pack - [url=https://franuka.itch.io]franuka.itch.io[/url]\n• Monster, battle effects, sounds and fight music: [b]Pixel-boy[/b], Ninja Adventure (CC0) - [url=https://pixel-boy.itch.io/ninja-adventure-asset-pack]pixel-boy.itch.io[/url]\n• Zuru the samurai: [b]MtPixls[/b], Samurai Character Pack - [url=https://mtpixls.itch.io/samurai-character-pack]mtpixls.itch.io[/url]\n• The moving Japan scenery on the title and home screens: [b]LyniaDesign[/b], Tiny Pixel Japan Parallax Background - [url=https://lyniadesign.itch.io/tiny-pixel-japan-parallax-background]lyniadesign.itch.io[/url]\n• The campfire: [b]ArlanTR[/b] (CC0) - [url=https://opengameart.org/content/campfire-pixel-art-animated]opengameart.org[/url]\n• Zuru's voice: [b]John Carroll[/b], Warrior Voice Pack (CC0) - [url=https://johncarroll.itch.io/warrior-voice-pack]johncarroll.itch.io[/url]\n• Spare UI pieces: [b]Kenney[/b] (CC0) - [url=https://kenney.nl]kenney.nl[/url]\n• Fonts: Pixelify Sans (Stefie Justprince), VT323 (Peter Hull), Silkscreen (Jason Kottke), SIL Open Font License - [url=https://fonts.google.com]fonts.google.com[/url]\n• App icon, Christmas and Halloween art and the other sounds: made for this game."

func open_credits() -> void:
	title_label.text = "CREDITS & DISCLAIMER"
	body.text = "[font_size=24]" + CREDITS + "[/font_size]"
	relayout()
	visible = true

func close() -> void:
	visible = false
