# Credits & Asset Licences

| Asset in game | Source | Licence |
|---|---|---|
| Body font `assets/fonts/PixelifySans.ttf` | Pixelify Sans — Stefie Justprince (Google Fonts) | SIL OFL 1.1 (`assets/fonts/PixelifySans-OFL.txt`) |
| Digit font `assets/fonts/VT323.ttf` | VT323 — Peter Hull (Google Fonts) | SIL OFL 1.1 (`assets/fonts/OFL-vt323.txt`) |
| `assets/fonts/Silkscreen.ttf` (kept, unused) | Silkscreen — Jason Kottke (Google Fonts) | SIL OFL 1.1 (`assets/fonts/OFL-silkscreen.txt`) |
| Monster sprite `assets/monster.png`, `assets/font.ttf` | **Ninja Adventure Asset Pack** — Pixel-boy | CC0 1.0 |
| Battle effects `assets/fx/*`, sword / impact / explosion / alert sounds `assets/sfx/slash*, sword, impact*, boom, alert, powerup`, fight music `assets/music/*` | **Ninja Adventure Asset Pack** — Pixel-boy | CC0 1.0 |
| Zuru's voice `assets/voice/*` (attack, crit, finish, hurt, boss, win, lose - picked and renamed from the pack) | **Warrior Voice Pack** — John Carroll (johncarroll.itch.io) | CC0 1.0 |
| Dialogue panel / buttons `assets/ui/*` (fallback UI) | **Kenney UI Pack 2.0** — kenney.nl | CC0 1.0 |
| Zuru the samurai (`assets/characters/*`, **not in this repository**) | **Samurai Character Pack V5** — MtPixls (mtpixls.itch.io), re-cut and recoloured to warm brown skin by `tools/make_zuru.gd` | Use in personal or commercial projects, modifying allowed; not to be resold or redistributed, even modified |
| Moving banner scenery (`assets/scenery/*`, **not in this repository**) | **Tiny Pixel Japan Parallax Background** — LyniaDesign (lyniadesign.itch.io) | Free for any game, commercial or not; may not be resold or redistributed, even modified |
| Banner props: branches and wood chips (`assets/fx/branch.png`, `wood_chips.png`) | **Ninja Adventure Asset Pack** — Pixel-boy | CC0 1.0 |
| Banner campfire (`assets/fx/campfire.png`) | **Campfire pixel art animated** — ArlanTR (opengameart.org) | CC0 1.0 |
| App icon - the open study book (`assets/icon*.png`) | drawn for this project by `tools/make_zuru.gd` | CC0 (original) |
| Christmas trees, presents, lights (`assets/xmas/*`) | drawn for this project by `tools/make_xmas.ps1` | CC0 (original) |
| Sound effects `assets/sfx/*.wav` | synthesised for this project by `tools/make_sfx.ps1` | CC0 (original) |

**Not in this repository:** the Franuka RPG UI pack (`assets/rpg/`) — its licence allows use inside a game
but not redistribution of the raw files, so it is git-ignored. Copy it into `assets/rpg/` locally; without it
the game falls back to plain coloured frames and the Kenney UI pieces.
Likewise the banner scenery (`assets/scenery/`, from LyniaDesign on itch.io) and Zuru's sprites (`assets/characters/`): both packs may be used in a game but not handed out as
an asset, so they ship inside the APK and update packs only. Rebuild them with `tools/make_zuru.gd` from the
pack (by default it reads the pack unzipped in Downloads).

- Ninja Adventure: https://pixel-boy.itch.io/ninja-adventure-asset-pack
- Kenney UI Pack: https://kenney.nl/assets/ui-pack
- Google Fonts: https://fonts.google.com

All questions, lessons, the Zuru's Lemonade Stand scenarios and the mocks are **original** material written for
this project — they are NOT ACCA papers. The ACCA syllabus and study guide were used as the backbone for coverage.
