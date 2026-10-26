# Draws Zuru, the player's samurai (original pixel art for this project, free to share).
#   assets/characters/samurai.png        24x26 at 1x - display at 6x with nearest filtering
#   assets/characters/samurai_happy.png  same pose, happy face (right answer)
#   assets/characters/samurai_sad.png    same pose, distressed face (wrong answer)
#   powershell -ExecutionPolicy Bypass -File tools\make_samurai.ps1
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.Drawing
$root = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '..'))
$outDir = Join-Path $root 'assets\characters'
New-Item -ItemType Directory -Force $outDir | Out-Null

# Case-sensitive keys ('Y' gold vs 'y' gold shade etc.)
$pal = New-Object System.Collections.Hashtable ([System.StringComparer]::Ordinal)
$pal['O'] = '#2b1d2a'  # outline
$pal['Y'] = '#f2c14e'  # gold crest / trim
$pal['y'] = '#c98a2e'  # gold shade
$pal['K'] = '#33497a'  # helmet
$pal['k'] = '#5a7fc0'  # helmet shine
$pal['S'] = '#f2c9a0'  # skin
$pal['s'] = '#d9a07a'  # skin shade
$pal['R'] = '#c8414b'  # armour
$pal['r'] = '#8c2b3c'  # armour shade
$pal['L'] = '#e86a5f'  # armour light
$pal['W'] = '#f6f1e7'  # sash
$pal['N'] = '#3b3550'  # hakama
$pal['n'] = '#5b5478'  # hakama fold
$pal['H'] = '#6e3f33'  # sandals / sword grip
$pal['G'] = '#dfe4f0'  # blade
$pal['g'] = '#9aa3bd'  # blade edge
$pal['B'] = '#e86a5f'  # blush
$pal['T'] = '#7fd0ff'  # sweat drop
$rows = @(
  '.......Y.......Y........',
  '........Y.....Y.........',
  '.........YyyyY..........',
  '......OOOOOOOOOOOO......',
  '.....OKKkkkKKKKKKKO.....',
  '....OKkkKKKKKKKKKKKO....',
  '....OKKKKKKKKKKKKKKO....',
  '...OKKOOOOOOOOOOOOKKO...',
  '...OKOSSSSSSSSSSSSOKO...',
  '...OKOSSSOSSSSOSSSOKO...',
  '...OKOSSSOSSSSOSSSOKO...',
  '....OOsSSSSSSSSSSsOO....',
  '.....OOsssSSSSsssOO.....',
  '......OOOOOOOOOOOO......',
  '.....ORRLLRRRRLLRRO.....',
  '....ORRLRRRYYRRRLRRO....',
  '....ORrRRRRWWRRRRrRO....',
  '....OOrRRRRWWRRRRrOO....',
  '.....OSOrRRYYRRrOSO.....',
  '.....OOONNNNNNNNOOO.....',
  '......ONNnNNNNnNNO......',
  '......ONNnNNNNnNNO......',
  '......ONNNNOONNNNO......',
  '......ONNNO..ONNNO......',
  '.....OHHHHO..OHHHHO.....',
  '.....OOOOOO..OOOOOO.....'
)
# Face variants: the face occupies rows 8-12, x 6-17; two eyes at x=9 and x=14 (rows 9-10).
$faces = @{
  'samurai' = @{}
  'samurai_happy' = @{
    9  = '...OKOSSSOSSSSOSSSOKO...'   # closed happy eyes ^ ^
    10 = '...OKOSSOSOSSOSOSSOKO...'
    11 = '....OOsBBSOOOOSBBsOO....'   # blush + smile
    12 = '.....OOsssSSSSsssOO.....'
  }
  'samurai_sad' = @{
    8  = '...OKOSSOOSSSSOOSSOKO...'   # worried brows
    9  = '...OKOSSSOWSSWOSTSOKO...'   # wide eyes + sweat drop
    10 = '...OKOSSSOWSSWOSTSOKO...'
    11 = '....OOsSSSOSSOSSSsOO....'   # frown
    12 = '.....OOsssSOOSsssOO.....'
  }
}
# Christmas: a Santa hat over the helmet (rows 0-6) - written as samurai_x*.png
$hat = @{
  0 = '.................OWWO...'
  1 = '............ORRRRRROWO..'
  2 = '.........ORRRRRRRRRRO...'
  3 = '......ORRRRRRRRRRRRRO...'
  4 = '.....ORRRRRRRRRRRRRrO...'
  5 = '....ORRRRRRRRRRRRRRrO...'
  6 = '....OWWWWWWWWWWWWWWWO...'
}
# Halloween: a witch's hat (rows 0-6) - written as samurai_h*.png
$pal['V'] = '#4b2a6e'  # witch hat violet
$hatH = @{
  0 = '............OO..........'
  1 = '...........OVVO.........'
  2 = '..........OVVVVO........'
  3 = '.........OVVVVVVO.......'
  4 = '........OVVVVVVVVO......'
  5 = '...OOOOOOVVVVVVVVOOOOOO.'
  6 = '....OYYYYYYYYYYYYYYYO...'
}
$w = 24; $h = $rows.Count
$variants = @()
foreach ($name in $faces.Keys) {
  $variants += @{ name = $name; face = $faces[$name]; hat = $false; hatH = $false }
  $variants += @{ name = ($name -replace '^samurai', 'samurai_x'); face = $faces[$name]; hat = $true; hatH = $false }
  $variants += @{ name = ($name -replace '^samurai', 'samurai_h'); face = $faces[$name]; hat = $false; hatH = $true }
}
foreach ($v in $variants) { $name = $v.name
  $b = New-Object System.Drawing.Bitmap $w, $h
  for ($y = 0; $y -lt $h; $y++) {
    $line = $rows[$y]; if ($v.face.ContainsKey($y)) { $line = $v.face[$y] }; if ($v.hat -and $hat.ContainsKey($y)) { $line = $hat[$y] }; if ($v.hatH -and $hatH.ContainsKey($y)) { $line = $hatH[$y] }
    $line = $line.PadRight($w, '.')
    for ($x = 0; $x -lt $w; $x++) {
      $ch = [string]$line[$x]
      if ($pal.ContainsKey($ch)) { $b.SetPixel($x, $y, [System.Drawing.ColorTranslator]::FromHtml($pal[$ch])) }
    }
  }
  # Katana held in the right hand, pointing up and forward.
  function P($x, $y, $k) { if ($x -lt $w -and $y -ge 0) { $b.SetPixel($x, $y, [System.Drawing.ColorTranslator]::FromHtml($pal[$k])) } }
  P 18 17 'H'; P 19 16 'H'; P 19 15 'Y'; P 20 16 'Y'
  for ($i = 0; $i -lt 6; $i++) { P (20 + [int][math]::Floor($i * 0.6)) (14 - $i * 2) 'G'; P (20 + [int][math]::Floor($i * 0.6)) (15 - $i * 2) 'g' }
  if ($v.hat) { P 18 0 'W'; P 19 0 'W'; P 20 1 'W' }   # pom-pom on top of the blade
  $b.Save((Join-Path $outDir "$name.png"), [System.Drawing.Imaging.ImageFormat]::Png)
  $b.Dispose()
  "Wrote assets/characters/$name.png (${w}x$h)"
}
