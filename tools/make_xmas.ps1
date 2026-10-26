# Christmas decorations (original pixel art, free to share): assets/xmas/tree.png, present.png, lights.png
#   powershell -ExecutionPolicy Bypass -File tools\make_xmas.ps1
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '..'))
$outDir = Join-Path $root 'assets\xmas'
New-Item -ItemType Directory -Force $outDir | Out-Null

$pal = New-Object System.Collections.Hashtable ([System.StringComparer]::Ordinal)
$pal['O'] = '#2b1d2a'; $pal['G'] = '#2e8b57'; $pal['g'] = '#1a5c3a'; $pal['L'] = '#5fc07a'
$pal['H'] = '#6e3f33'; $pal['Y'] = '#f2c14e'; $pal['R'] = '#c8414b'; $pal['B'] = '#4f74b3'; $pal['W'] = '#f6f1e7'; $pal['P'] = '#b05a8a'; $pal['K'] = '#3b3550'

function Draw($rows, $name) {
  [int]$w = ($rows | ForEach-Object { $_.Length } | Measure-Object -Maximum).Maximum; [int]$h = $rows.Count
  $b = New-Object System.Drawing.Bitmap -ArgumentList $w, $h
  for ($y = 0; $y -lt $h; $y++) { $line = $rows[$y].PadRight($w, '.')
    for ($x = 0; $x -lt $w; $x++) { $ch = [string]$line[$x]; if ($pal.ContainsKey($ch)) { $b.SetPixel($x, $y, [System.Drawing.ColorTranslator]::FromHtml($pal[$ch])) } } }
  $b.Save((Join-Path $outDir "$name.png"), [System.Drawing.Imaging.ImageFormat]::Png); $b.Dispose(); "Wrote assets/xmas/$name.png (${w}x$h)"
}

# Tree 16x24: star, three tiers with snow and baubles, trunk
Draw @(
  '.......YY.......',
  '......YYYY......',
  '.......YY.......',
  '......OGGO......',
  '.....OGLGGO.....',
  '....OGGGRGGO....',
  '...OGWWGGGBGO...',
  '..OGGGGLGGGGGO..',
  '.....OGGGGO.....',
  '....OGBGGLGO....',
  '...OGGGGGGRGO...',
  '..OGWWGGGGGGGO..',
  '.OGGGGGRGGLGGGO.',
  'OOOOOOOOOOOOOOOO',
  '...OGGGGLGGGO...',
  '..OGGRGGGGGGBO..',
  '.OGWWGGGGGGGGGO.',
  'OGGGGGGLGGRGGGGO',
  'OggggggggggggggO',
  'OOOOOOOOOOOOOOOO',
  '......OHHHO.....',
  '......OHHHO.....',
  '......OHHHO.....',
  '.....OOOOOOO....'
) 'tree'

# Present 10x10: red box, gold ribbon and bow
Draw @(
  '...YY.YY..',
  '..Y..Y..Y.',
  'OOOOYYOOOO',
  'ORRRYYRRRO',
  'OYYYYYYYYO',
  'ORRRYYRRRO',
  'ORRRYYRRRO',
  'ORRRYYRRRO',
  'ORRRYYRRRO',
  'OOOOOOOOOO'
) 'present'

# ---- Halloween ----
$pal['A'] = '#e8812b'; $pal['a'] = '#b85e1c'   # pumpkin orange + shade
# Pumpkin 16x14: stem, ribbed body, glowing face
Draw @(
  '.......OHHO.....',
  '.......OHHO.....',
  '...OOOOOOOOOOO..',
  '..OAAaAAAAaAAAO.',
  '.OAAaAAAAAAaAAAO',
  'OAAaAAYAAAYAAaAO',
  'OAAaAAAAAAAAAaAO',
  'OAAaAAAAYAAAAaAO',
  'OAAaAYAYAYAYAAaO',
  'OAAaAAYYYYYAAaAO',
  '.OAAaAAAAAAAaAO.',
  '..OAAaAAAAaAAO..',
  '...OOOOOOOOOO...'
) 'pumpkin'

# Bat 16x8
Draw @(
  'O......OO......O',
  'OO....OOOO....OO',
  'OOO..OOOOOO..OOO',
  'OOOOOOOOOOOOOOOO',
  '.OOOOOOOOOOOOOO.',
  '..OOO.OOOO.OOO..',
  '...O...OO...O...',
  '........O.......'
) 'bat'

# Pumpkin bunting 24x8, tiles horizontally
Draw @(
  'OO....................OO',
  '..OO................OO..',
  '....OOOOOOOOOOOOOOOO....',
  '.....O....O....O....O...',
  '....AAA..AAA..AAA..AAA..',
  '....AYA..AYA..AYA..AYA..',
  '....AAA..AAA..AAA..AAA..',
  '........................'
) 'bunting'

# String of lights 24x8, tiles horizontally: a drooping wire with four coloured bulbs
Draw @(
  'OO....................OO',
  '..OO................OO..',
  '....OOOOOOOOOOOOOOOO....',
  '.....O....O....O....O...',
  '....RR...YY...BB...GG...',
  '....RR...YY...BB...GG...',
  '.....R....Y....B....G...',
  '........................'
) 'lights'
