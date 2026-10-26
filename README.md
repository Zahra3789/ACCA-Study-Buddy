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
  (device text-to-speech), sound effects, backup/restore codes, and Christmas / Halloween themes.
- **Help** (the ? button) explains the screen you are on and what its buttons do; works upright or sideways.
- **Updates itself** (like DojoChef): `Boot.tscn` checks the rolling `live` release for a newer content pack and
  downloads it on start - no reinstall. Only app-level changes (icon, name, permissions, engine) need a new APK;
  then the app shows "Update ready - tap to download". See "Publishing updates" below.
- **Fits any phone**: the layout stretches to the real screen shape (tall phones, foldable cover screens),
  switches to wide layouts when held sideways, and lists scroll by swiping anywhere, even over buttons.

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
- `tools/` — `make_zuru.gd` (Zuru from the samurai pixel pack, and draws the study-book app icon), generators for the Christmas art and sound
  effects. `make_samurai.ps1` drew the original Zuru and is kept for reference.

## Growing it
Everything lives in `scripts/Content.gd`: Exams → Chapters → `beats` (quiz questions), `lessons` (with `learn`,
`apply`, `example`, `practice`) and `mtq`. Add an exam block with a new `id` and it appears on the title screen
once linked in `ACCA_EXAMS` (Main.gd / preview). Keep questions original.

## Export to Android (APK)
See `EXPORT_APK.md`.

## Publishing updates
- **Content update** (scripts, questions, screens, art): bump nothing by hand, just run
  `powershell -ExecutionPolicy Bypass -File tools/publish_update.ps1`. It bumps `BUILD` in
  `scripts/build_info.gd`, exports `build/update/content.pck` and uploads it with `version.txt` to the `live`
  release. Phones pick it up the next time the app opens.
- **New APK needed** (icon, app name, permissions, Godot version, or `Boot.gd` itself): add `-Apk`. It also bumps
  the app version in project.godot and export_presets.cfg, builds the APK and uploads it with `apk.txt`.
- `Boot.gd` swaps the always-loaded scripts (Game, Content, UI) for the pack versions after loading a pack.
  Tested on a Windows export (`Windows Desktop` preset) - the source run skips updates.
