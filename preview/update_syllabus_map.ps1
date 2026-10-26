# Keeps the syllabus map in Content.gd in step with the content:
#  - "ch":    list of chapters that teach each outcome (from chapter_objectives.txt)
#  - "cover": adds "ch/Lx" for every lesson whose "outcome" label names the code; keeps "chN" quiz refs
# Only the one-line syllabus entries are rewritten; everything else in Content.gd is untouched.
#   powershell -ExecutionPolicy Bypass -File preview\update_syllabus_map.ps1
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$contentPath = [System.IO.Path]::GetFullPath((Join-Path $here '..\scripts\Content.gd'))

# Expand references like A1(a), D3(a)-(g), D1(a)(b), G3(b)(i)-(iv), H1(c)(i)-(v) into codes A1a, D3a..D3g, ...
function Expand-Codes([string]$text) {
  $out = New-Object System.Collections.Generic.List[string]
  foreach ($m in [regex]::Matches($text, '([A-I]\d{1,2})((?:\([a-k]\))+)(?:\((?:i|ii|iii|iv|v|vi)\))*(?:-\(([a-k])\))?')) {
    $base = $m.Groups[1].Value
    $letters = [regex]::Matches($m.Groups[2].Value, '[a-k]') | ForEach-Object { $_.Value }
    foreach ($l in $letters) { $out.Add("$base$l") }
    if ($m.Groups[3].Success) { $from = [int][char]$letters[-1]; $to = [int][char]$m.Groups[3].Value; for ($c = $from + 1; $c -le $to; $c++) { $out.Add("$base$([char]$c)") } }
  }
  return $out | Select-Object -Unique
}

$chOf = @{}
foreach ($line in Get-Content -LiteralPath (Join-Path $here 'chapter_objectives.txt')) {
  if ($line -notmatch '^\s*(\d{1,2})\s+[A-Za-z].*?\.{2,}\s*(.*)$') { continue }
  $ch = [int]$Matches[1]; $refs = ($Matches[2] -split '\[')[0]
  foreach ($code in Expand-Codes $refs) { if (-not $chOf.ContainsKey($code)) { $chOf[$code] = @() }; if ($chOf[$code] -notcontains $ch) { $chOf[$code] += $ch } }
}

$lines = [System.Collections.Generic.List[string]](Get-Content -LiteralPath $contentPath -Encoding UTF8)
$start = ($lines | Select-String -Pattern '^const EXAMS := \[' | Select-Object -First 1).LineNumber
$end = ($lines | Select-String -Pattern '^func ' | Where-Object { $_.LineNumber -gt $start } | Select-Object -First 1).LineNumber
$d = ((($lines[($start - 1)..($end - 2)] | Where-Object { $_.Trim() -notlike '#*' }) -join "`n") -replace '^const EXAMS := ', '') | ConvertFrom-Json
if ($d -is [array]) { $d = $d[0] }

$lessonRefs = @{}
foreach ($c in $d.chapters) { foreach ($l in @($c.lessons)) { if (-not $l) { continue }
  foreach ($code in Expand-Codes $l.outcome) { if (-not $lessonRefs.ContainsKey($code)) { $lessonRefs[$code] = @() }; $lessonRefs[$code] += "$($c.id)/$($l.id)" } } }

function J($x) { ($x | ConvertTo-Json -Depth 10 -Compress) -replace '\\u0027', "'" -replace '\\u0026', '&' -replace '\\u003c', '<' -replace '\\u003e', '>' }
$changed = 0; $noCh = @()
for ($i = 0; $i -lt $lines.Count; $i++) {
  if ($lines[$i] -notmatch '^(\s*)(\{"code":"[A-I]\d+[a-k]".*\})(,?)\s*$') { continue }
  $indent = $Matches[1]; $comma = $Matches[3]; $o = $Matches[2] | ConvertFrom-Json
  $quiz = @($o.cover | Where-Object { $_ -like 'ch*' })
  $cover = @(@($lessonRefs[$o.code]) + $quiz | Where-Object { $_ } | Select-Object -Unique)
  $chs = @($chOf[$o.code]); if (-not $chs.Count) { $noCh += $o.code; $chs = @($o.ch) }
  $new = [ordered]@{ code = $o.code; k = $o.k; t = $o.t; cover = $cover; ch = $chs }
  if ($o.note) { $new.note = $o.note }
  $txt = $indent + (J $new) + $comma
  if ($txt -ne $lines[$i]) { $lines[$i] = $txt; $changed++ }
}
[System.IO.File]::WriteAllText($contentPath, ($lines -join "`n") + "`n", (New-Object System.Text.UTF8Encoding($false)))
"Updated $changed syllabus entries. Outcomes with no chapter in the notes: $(if ($noCh) { $noCh -join ', ' } else { 'none' })"
