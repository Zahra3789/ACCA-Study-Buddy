# Sound effects, synthesised and written as 16-bit mono WAV files (original to this project, free to share).
#   assets/sfx/hit.wav   - sword strike (right answer)
#   assets/sfx/miss.wav  - the monster hits back (wrong answer)
#   assets/sfx/win.wav   - fanfare (lesson passed / mock passed / boss down)
#   assets/sfx/page.wav  - page turn
#   assets/sfx/bells.wav - sleigh bells (festive win)
#   assets/sfx/tap.wav   - soft click for menus
#   powershell -ExecutionPolicy Bypass -File tools\make_sfx.ps1
$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '..'))
$outDir = Join-Path $root 'assets\sfx'
New-Item -ItemType Directory -Force $outDir | Out-Null
$rate = 22050
$rnd = New-Object System.Random 7

function Save-Wav([string]$name, [double[]]$samples) {
  $n = $samples.Count
  $peak = 0.0; foreach ($s in $samples) { $a = [math]::Abs($s); if ($a -gt $peak) { $peak = $a } }
  if ($peak -lt 1e-6) { $peak = 1.0 }
  $bytes = New-Object byte[] (44 + $n * 2)
  $ms = New-Object System.IO.MemoryStream
  $w = New-Object System.IO.BinaryWriter $ms
  $w.Write([System.Text.Encoding]::ASCII.GetBytes('RIFF')); $w.Write([int32](36 + $n * 2)); $w.Write([System.Text.Encoding]::ASCII.GetBytes('WAVE'))
  $w.Write([System.Text.Encoding]::ASCII.GetBytes('fmt ')); $w.Write([int32]16); $w.Write([int16]1); $w.Write([int16]1); $w.Write([int32]$rate); $w.Write([int32]($rate * 2)); $w.Write([int16]2); $w.Write([int16]16)
  $w.Write([System.Text.Encoding]::ASCII.GetBytes('data')); $w.Write([int32]($n * 2))
  foreach ($s in $samples) { $v = [int16]([math]::Round(($s / $peak) * 0.85 * 32767)); $w.Write($v) }
  $w.Flush(); [System.IO.File]::WriteAllBytes((Join-Path $outDir "$name.wav"), $ms.ToArray()); $w.Close()
  "Wrote assets/sfx/$name.wav ($([math]::Round($n / $rate, 2)) s)"
}
function Env([double]$t, [double]$dur, [double]$attack = 0.005, [double]$decay = 4.0) {
  if ($t -lt $attack) { return $t / $attack }
  return [math]::Exp(-$decay * ($t - $attack) / $dur) * (1.0 - ($t / $dur) * 0.2)
}
function Tone([double]$dur, [double]$f0, [double]$f1, [string]$wave = 'sine', [double]$gain = 1.0, [double]$decay = 4.0) {
  $n = [int]($dur * $rate); $out = New-Object double[] $n; $phase = 0.0
  for ($i = 0; $i -lt $n; $i++) { $t = $i / $rate; $f = $f0 + ($f1 - $f0) * ($t / $dur); $phase += 2 * [math]::PI * $f / $rate
    $v = switch ($wave) { 'square' { if ([math]::Sin($phase) -ge 0) { 1.0 } else { -1.0 } } 'saw' { 2.0 * (($phase / (2 * [math]::PI)) % 1.0) - 1.0 } 'tri' { 2.0 * [math]::Abs(2.0 * (($phase / (2 * [math]::PI)) % 1.0) - 1.0) - 1.0 } default { [math]::Sin($phase) } }
    $out[$i] = $v * $gain * (Env $t $dur 0.005 $decay) }
  return $out
}
function Noise([double]$dur, [double]$gain = 1.0, [double]$decay = 6.0, [double]$lowpass = 0.3) {
  $n = [int]($dur * $rate); $out = New-Object double[] $n; $prev = 0.0
  for ($i = 0; $i -lt $n; $i++) { $t = $i / $rate; $x = $rnd.NextDouble() * 2.0 - 1.0; $prev = $prev + $lowpass * ($x - $prev); $out[$i] = $prev * $gain * (Env $t $dur 0.002 $decay) }
  return $out
}
function Mix([double[][]]$parts, [double[]]$offsets, [double]$totalDur) {
  $n = [int]($totalDur * $rate); $out = New-Object double[] $n
  for ($p = 0; $p -lt $parts.Count; $p++) { $o = [int]($offsets[$p] * $rate); $src = $parts[$p]
    for ($i = 0; $i -lt $src.Count; $i++) { $j = $o + $i; if ($j -lt $n) { $out[$j] += $src[$i] } } }
  return $out
}

# hit: a quick metallic "shing" + a thump
Save-Wav 'hit' (Mix @((Noise 0.18 0.9 7.0 0.9), (Tone 0.12 1800 600 'tri' 0.5 5.0), (Tone 0.22 140 50 'sine' 0.9 4.0)) @(0.0, 0.0, 0.03) 0.3)
# miss: a dull descending thud with a growl
Save-Wav 'miss' (Mix @((Tone 0.4 260 70 'saw' 0.7 3.0), (Noise 0.25 0.5 5.0 0.15), (Tone 0.3 90 40 'sine' 0.8 3.0)) @(0.0, 0.0, 0.02) 0.45)
# win: four-note fanfare
Save-Wav 'win' (Mix @((Tone 0.22 523 523 'square' 0.4 2.5), (Tone 0.22 659 659 'square' 0.4 2.5), (Tone 0.22 784 784 'square' 0.4 2.5), (Tone 0.5 1047 1047 'square' 0.45 2.0), (Tone 0.5 523 523 'tri' 0.3 2.0)) @(0.0, 0.15, 0.30, 0.45, 0.45) 1.0)
# page: a soft swoosh
Save-Wav 'page' (Mix @((Noise 0.22 0.8 4.0 0.08), (Tone 0.2 900 300 'tri' 0.25 3.0)) @(0.0, 0.0) 0.25)
# bells: sleigh bells - a shimmer of high sines
$bells = @(); $offs = @()
for ($k = 0; $k -lt 8; $k++) { $f = 1760 + ($k % 3) * 440 + $rnd.NextDouble() * 60; $bells += ,(Tone 0.35 $f ($f * 0.995) 'sine' 0.35 5.0); $offs += ($k * 0.12) }
Save-Wav 'bells' (Mix $bells $offs 1.3)
# tap: a short click for menu buttons
Save-Wav 'tap' (Mix @((Tone 0.06 700 500 'tri' 0.6 6.0), (Noise 0.04 0.4 8.0 0.5)) @(0.0, 0.0) 0.08)
