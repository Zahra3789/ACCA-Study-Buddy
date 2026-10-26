# Builds ONE self-contained HTML file of the preview (questions, fonts and art all
# embedded) so it opens straight from disk in Firefox - no server needed.
#   powershell -ExecutionPolicy Bypass -File preview\build-standalone.ps1
param([string]$Out = "")   # default: build\Samurai Ledger.html in this project (build\ is git-ignored)
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = [System.IO.Path]::GetFullPath((Join-Path $here '..'))
if (-not $Out) { New-Item -ItemType Directory -Force (Join-Path $root 'build') | Out-Null; $Out = Join-Path $root 'build\Samurai Ledger.html' }

# Questions: Content.gd's EXAMS constant is JSON apart from full-line # comments.
$lines = Get-Content (Join-Path $root 'scripts\Content.gd') -Encoding UTF8
$start = ($lines | Select-String -Pattern '^const EXAMS := \[' | Select-Object -First 1).LineNumber
$end = ($lines | Select-String -Pattern '^func ' | Where-Object { $_.LineNumber -gt $start } | Select-Object -First 1).LineNumber
$json = (($lines[($start - 1)..($end - 2)] | Where-Object { $_.Trim() -notlike '#*' }) -join "`n") -replace '^const EXAMS := ', ''
$null = $json | ConvertFrom-Json   # stop here if Content.gd has a syntax slip

# Every image/font the preview can ask for, keyed by the same '../assets/...' path index.html uses.
$mime = @{ '.png' = 'image/png'; '.ttf' = 'font/ttf'; '.wav' = 'audio/wav' }
$assets = [ordered]@{}
foreach ($dir in 'assets\rpg', 'assets\rpg\fonts', 'assets\fonts', 'assets\characters', 'assets\xmas', 'assets\sfx') {
  Get-ChildItem -LiteralPath (Join-Path $root $dir) -File | Where-Object { $mime.ContainsKey($_.Extension.ToLower()) } | ForEach-Object {
    $key = '../' + ($dir -replace '\\', '/') + '/' + $_.Name
    $assets[$key] = "data:$($mime[$_.Extension.ToLower()]);base64," + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes($_.FullName))
  }
}
$assets['../assets/monster.png'] = 'data:image/png;base64,' + [Convert]::ToBase64String([System.IO.File]::ReadAllBytes((Join-Path $root 'assets\monster.png')))
$assetsJs = ($assets.GetEnumerator() | ForEach-Object { "'$($_.Key)':'$($_.Value)'" }) -join ",`n"

$html = [System.IO.File]::ReadAllText((Join-Path $here 'index.html'), [System.Text.Encoding]::UTF8)
$html = $html.Replace('<script src="data.js"></script>', "<script>const EXAMS = $json;`nconst ASSETS = {`n$assetsJs`n};</script>")
$html = $html.Replace('Prototype preview of the Godot app', 'Samurai Ledger prototype - built ' + (Get-Date -Format 'dd-MMM-yyyy HH:mm') + ' - progress is saved in this browser')

[System.IO.File]::WriteAllText($Out, $html, (New-Object System.Text.UTF8Encoding($false)))
"Wrote $Out ($([math]::Round((Get-Item -LiteralPath $Out).Length / 1KB)) KB, $($assets.Count) assets)"
