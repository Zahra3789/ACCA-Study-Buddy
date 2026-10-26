# ACCA Study Buddy 🏯🍋

A monster-battling study game for **ACCA FA (FFA)**, built in **Godot 4.x** for Android, with an HTML prototype
of the same game in `preview/`. You are **Zuru**, a samurai at the dojo gate; each chapter is a monster, each
lesson ends in a practice battle, and the mocks are laid out like the real ACCA CBE.

## What's in it
- **26 chapters** following the FA/FFA study text, 88 lessons (Learn → Apply it → Worked example → Your turn),
  535 exam-style questions (multiple choice, multiple response, number entry, pick lists, sort), 5 Section B
  15-mark cases, and a syllabus map covering all 154 ACCA FA outcomes.
- **Apply it**: every lesson has a scene from *Zuru's Lemonade Stand* — one story that grows from a shoebox of
  receipts to a group with a subsidiary, using the same numbers chapter after chapter.
- **Exam Hall**: five fixed Section A mocks, a mini mock, and three **full 100-mark mocks** (35 OT + two Section B
  cases, 2-hour clock, marks by section). Original questions — not ACCA papers.
- **Boss Arena** (endless gauntlet in laps of 32 bosses), **Training Grounds**, **Healer's Shrine** (everything you
  get wrong, anywhere, until you clear it), **Hall of Records**.
- **Study Planner** (daily targets packed into the hours you have, re-planned from today, calendar), **Notebook**
  (what you did each day), exam sitting dates with countdowns, a key-dates guide, an in-game calculator, voice
  (device text-to-speech), sound effects, backup/restore codes, and a festive mode (snow, lights, Santa-hat Zuru).

## Run it
1. Open **Godot 4.x** (4.3 or later; 4.7 works).
2. Open this folder (it finds `project.godot`) and press **F5**.
3. Optional: copy the Franuka RPG UI pack into `assets/rpg/` for the full look (see `CREDITS.md`).

> **Status:** the Godot port in `scripts/` runs cleanly in Godot 4.7.2 and is the v2.0 Android build. It was
> checked headless by playing every chapter battle, lesson, Section B case, mock and planner screen with no
> script errors. Its screen logic matches `preview/index.html`.

## Files
- `project.godot` — settings, autoloads (`Game` save data, `Content` questions, `UI` theme), TTS enabled.
- `Main.tscn` — a single Control; everything is built in code.
- `scripts/Content.gd` — **all lessons, questions, Section B cases and the syllabus map** (JSON-compatible).
- `scripts/Main.gd` — top bar, title (exam picker), home, menus, records, syllabus, helpers.
- `scripts/Book.gd` lessons · `Battle.gd` battles and the Boss Arena · `Mtq.gd` Section B · `Exam.gd` mocks ·
  `Planner.gd` plan / calendar / notebook / dates · `Calc.gd` calculator · `Snow.gd` festive snow.
- `preview/` — the HTML prototype (`serve.ps1` to run locally on port 8126; `build-standalone.ps1` builds a
  single-file version). `preview/update_syllabus_map.ps1` refreshes the syllabus map from the lessons.
- `tools/` — generators for the samurai sprites, Christmas art and sound effects.

## Growing it
Everything lives in `scripts/Content.gd`: Exams → Chapters → `beats` (quiz questions), `lessons` (with `learn`,
`apply`, `example`, `practice`) and `mtq`. Add an exam block with a new `id` and it appears on the title screen
once linked in `ACCA_EXAMS` (Main.gd / preview). Keep questions original.

## Export to Android (APK)
See `EXPORT_APK.md`.
