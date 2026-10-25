# ACCA Study Buddy 🏯

A monster-battling study game for **ACCA / FIA exams**, built in **Godot 4.x**. You enter a dojo, a monster appears for each topic, and you defeat it by answering questions — exam-style tap questions plus type-the-number/term "strikes" for real recall. Topics are replayable any time.

> The app and APK are named **"ACCA Study Buddy"** (set in `project.godot` → `config/name`), so it's labelled clearly on your phone and easy to update later.

This is a **vertical slice**: one fully playable room — the **Double-Entry Oni** (FFA, Chapter 2). It has been run headless and plays through cleanly (8/8). Once you're happy with the feel, we add the other topics and the extra modes.

## Run it
1. Open **Godot 4.x** (you have 4.7.2).
2. Import / Open the project: point it at this folder (it finds `project.godot`).
3. Press **F5** (Run). It runs with cute placeholder art straight away — no downloads needed to test.

## Files
- `project.godot` — settings, app name, portrait + mobile renderer, autoloads.
- `Main.tscn` — a near-empty scene; everything is built in code.
- `scripts/Game.gd` — saves your best score per exam+chapter (e.g. `FFA/2`).
- `scripts/Content.gd` — **all words, questions and answers**. This is the file to edit to grow the game.
- `scripts/Main.gd` — the engine (menu → battle → feedback → result → replay), drawn T-accounts, placeholder monster.
- `assets/` — drop art & font here (`assets/README_ASSETS.md`).

## Growing it (this is the important part for you)
Everything lives in `scripts/Content.gd`, organised as **Exams → Chapters → Beats**:
- **Add questions** → add more `choice` / `input` beats to a chapter.
- **Add a chapter (new monster)** → copy a chapter block; change `id`, `title`, `monster`, `beats`.
- **Add a whole new exam** (e.g. a different ACCA paper) → copy the `EXAMS` block with a new `id`/`name`.
The menu lists whatever is in there, so new content shows up automatically.

## Planned modes (next build)
The content model is ready for these; right now it plays the **chapter trials**:
1. **Chapter trials** — one monster per topic ✅
2. **General-knowledge boss** — a mixed-topic battle so you can't breeze through.
3. **Question bank** — practise by topic or by type (tap vs type-in).
4. **Timed exam mock** — a 2-hour countdown boss in exam format, feedback at the end.

## A note on the Exam Kit
The questions here are **original**, written to match the exam style. Please don't paste Exam Kit questions in wholesale — that's their copyright. Individual questions you own can be added one at a time for personal study.

## Export to Android (APK)
See `EXPORT_APK.md`.
