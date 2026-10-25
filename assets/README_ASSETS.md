# Art, fonts & UI — free sources, and where to put files 🎨

The game runs **without any of this** (cute blob monster, plain background, in-engine T-accounts). Add real assets to make it yours. The game picks them up **automatically** by filename.

## Drop files in this `assets/` folder with these exact names
| Filename | What it is | Notes |
|---|---|---|
| `monster.png` | Monster sprite | Transparent PNG ~400–600 px. Replaces the blob. |
| `background.png` | Dojo backdrop | Portrait, ~720×1280, fills the screen. |
| `font.ttf` | Game font | A `.ttf` (rename `.otf` to `.ttf` if needed). Used for all text. |

(Missing files just use the placeholder — add them one at a time.)

## Where to get FREE assets (all legit)
- **Kenney.nl** — the best starting point. Everything is **CC0** (free, no credit required, commercial OK). Great for **UI / dialogue boxes**, fonts, icons, and simple sprites. Look for "UI Pack", "RPG UI", "Fantasy UI", "Pixel UI".
- **itch.io** (itch.io/game-assets) — huge library. Filter **"Free"** and sort by the tags below. Check each pack's license (see below).
- **OpenGameArt.org** — older but big; lots of **CC0 / CC-BY** sprites, backgrounds, UI.
- **Google Fonts** (fonts.google.com) — free fonts (OFL licence). Download, unzip, use the `.ttf`. Good for readable dialogue.

## What to search for
- **Monster sprite:** "monster sprite pack", "cute monsters pixel art", "slime / oni / yokai sprites", "RPG enemy pack". A pack with several monsters is ideal — we'll use one per chapter later.
- **Dojo background:** "dojo background", "japanese interior / tatami room", "temple background", add "portrait" or "vertical" if you can.
- **Dialogue / text box (the "text prompt"):** "dialogue box", "RPG text box", "9-slice UI panel", "visual novel UI", "message box". **Kenney's UI packs are perfect here.** Once you have one, I'll wire it into the game's theme so the text panels and buttons use it (that's code on my side, not art).
- **Font:** "pixel font", "japanese style font", "RPG dialogue font" (itch), or any readable face on Google Fonts.
- **Optional sound later:** "RPG SFX", "UI click", "8-bit hit sound" (Kenney has these too).

## Licences — quick guide
- **CC0 / Public Domain** → use freely, no credit, even to publish. Easiest. (Kenney is all CC0.)
- **CC-BY** → free, but you must **credit** the author. Keep a note of the name/link.
- **"Free for personal use"** → fine for your own studying; don't publish it.
For just studying on your own phone, almost anything free is fine. If you ever put it on a store, stick to CC0 or packs that say commercial use is allowed, and keep a credits list.

## Handing art to me
You don't need to "make" anything — just download a pack, drop `monster.png` / `background.png` / `font.ttf` in here, and (for a dialogue-box/UI pack) tell me the folder; I'll hook it into the game.
