# Her file as the other chat made it is the input (not kept in the repo: it carries the licensed art).
param([string]$Src = "$env:USERPROFILE\GameDev\SM Study Buddy - original (rebuild input).html", [string]$Out = "$env:USERPROFILE\Downloads\SM Study Buddy.html")
# Builds the sister's CIMA HTML with the Samurai Ledger art: same content, Zuru renamed Sisi, plain-English greetings
# when E-LDN is off, the real Japan scenery banner, animated Sisi, theme hats and trimmings, readable titles.
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$proj = Split-Path -Parent (Split-Path -Parent $here)   # the project folder (this is tools\sister_html)
$utf8 = New-Object Text.UTF8Encoding $false
$lines = [IO.File]::ReadAllLines($Src, $utf8)

function Section($a, $b) { return ($lines[$a..$b] -join "`n") }
$assetsStart = [Array]::IndexOf($lines, 'const ASSETS = {')
$appStart = $assetsStart; while ($lines[$appStart] -ne '<script>') { $appStart++ }
$examsStart = 0; while (-not $lines[$examsStart].StartsWith('<script>const EXAMS')) { $examsStart++ }
$head = Section 0 ($examsStart - 1)
$exams = Section $examsStart ($assetsStart - 1)
$assets = Section $assetsStart ($appStart - 1)
$app = Section $appStart ($lines.Length - 1)

function Must([string]$text, [string]$old, [string]$new, [string]$what) {
  if (-not $text.Contains($old)) { throw "Not found: $what" }
  return $text.Replace($old, $new)
}
# --- Sisi on canvases, a taller banner
$head = Must $head '<img id="you" data-src="../assets/characters/samurai.png" data-zuru alt="">' '<canvas id="you" width="336" height="364"></canvas>' 'battle Zuru'
$head = Must $head '<img id="lessonYou" data-src="../assets/characters/samurai.png" data-zuru alt="" title="Zuru">' '<canvas id="lessonYou" width="288" height="252"></canvas>' 'lesson Zuru'
$head = Must $head '<img id="mtqYou" data-src="../assets/characters/samurai.png" data-zuru alt="" title="Zuru">' '<canvas id="mtqYou" width="260" height="232"></canvas>' 'mtq Zuru'
$head = Must $head '<canvas id="journey" width="720" height="150"' '<canvas id="journey" width="720" height="200"' 'banner canvas'
# --- greetings: plain English when Sensei is proper; the Somali ones only with E-LDN on
$app = [regex]::Replace($app, "welcome_title: \{ proper: \[[^\]]*\]", "welcome_title: { proper: ['Welcome to the dojo, Zuru.', 'Welcome back to the dojo, Zuru.', 'Good to see you, Zuru. Welcome to the dojo.', 'Zuru! The dojo has been waiting for you.']")
$app = [regex]::Replace($app, "welcome_home: \{ proper: \[[^\]]*\]", "welcome_home: { proper: ['Welcome back, Zuru!', 'Good to see you, Zuru - ready to study?', `"Hello again, Zuru. Let's get to work.`", 'Welcome back, Zuru. One chapter at a time.']")
if (-not $app.Contains("Hello again, Zuru")) { throw "greetings not replaced" }
# --- East London Sensei on right and wrong answers: the same lines as the app (sensei_east.txt: old, new, old, new)
$east = [IO.File]::ReadAllLines((Join-Path $here 'sensei_east.txt'), $utf8)
$app = Must $app $east[0] $east[1] 'East London right-answer lines'
$app = Must $app $east[2] $east[3] 'East London wrong-answer lines'
# --- no Sensei line on the chapter page (as in the app): it took a row of the panel and pushed the lessons over it
$before = $app.Length
$app = [regex]::Replace($app, '(<div class="stars">\$\{st\}</div></div>`)\s*\+ `<div class="senseiLine"[^\n]*', '$1;')
if ($app.Length -eq $before) { throw "chapter Sensei line not removed" }
# --- the character is Sisi in this version (names only; asset file names are lower case and untouched)
$head = $head -creplace 'Zuru', 'Sisi' -creplace 'ZURU', 'SISI'
$exams = $exams -creplace 'Zuru', 'Sisi' -creplace 'ZURU', 'SISI'
$app = $app -creplace 'Zuru', 'Sisi' -creplace 'ZURU', 'SISI'
$app = Must $app 'Sisi, the journey scenery, the Christmas and Halloween art and the other sounds: made for this game.' ("Sisi the samurai: <b>MtPixls</b>, Samurai Character Pack - <a href=`"https://mtpixls.itch.io/samurai-character-pack`" target=`"_blank`">mtpixls.itch.io</a><br>`n" + "&#8226; The moving Japan scenery: <b>LyniaDesign</b>, Tiny Pixel Japan Parallax Background - <a href=`"https://lyniadesign.itch.io/tiny-pixel-japan-parallax-background`" target=`"_blank`">lyniadesign.itch.io</a><br>`n" + "&#8226; Paper lantern and spider: <b>Pixel-boy</b>, Ninja Adventure (CC0)<br>`n" + "&#8226; The hats, holly, Christmas and Halloween art and the other sounds: made for this game.") 'credits line'
# --- styles
$css = [IO.File]::ReadAllText((Join-Path $here 'patch.css'), $utf8)
$i = $head.IndexOf('</style>'); if ($i -lt 0) { throw "no </style>" }
$head = $head.Substring(0, $i) + $css + $head.Substring($i)
# --- the new art, embedded (added to ASSETS before the app runs)
$files = @()
foreach ($n in 'Sky','Clouds','Fuji','Mountain_Back','Mountain_Middle','Mountain_Front','BackgroundTrees','Shrine_Multiple','House','Trees','Ground','Gras') { $files += "scenery/$n.png" }
foreach ($n in 'idle','run','quick','slash','item','relax','jump','hurt','walk') { $files += "characters/zuru_$n.png" }
$files += 'fx/lantern.png', 'fx/spider.png', 'xmas/hat_santa.png', 'xmas/hat_witch.png', 'xmas/holly.png'
$add = New-Object Text.StringBuilder
[void]$add.Append("<script>Object.assign(ASSETS, {`n")
foreach ($f in $files) {
  $p = Join-Path $proj ("assets\" + $f.Replace('/', '\'))
  if (-not (Test-Path $p)) { throw "missing $p" }
  [void]$add.Append("'../assets/$f':'data:image/png;base64," + [Convert]::ToBase64String([IO.File]::ReadAllBytes($p)) + "',`n")
}
[void]$add.Append("});</script>")
# --- the art code, before </body>
$patch = [IO.File]::ReadAllText((Join-Path $here 'patch.js'), $utf8)
$app = Must $app '</body>' ($patch + "`n</body>") 'body end'

$html = $head + "`n" + $exams + "`n" + $assets + "`n" + $add.ToString() + "`n" + $app
[IO.File]::WriteAllText($Out, $html, $utf8)
"Wrote $Out  ({0:N1} MB)" -f ((Get-Item $Out).Length / 1MB)
"Zuru left: " + ([regex]::Matches($head + $exams + $app, 'Zuru').Count)
