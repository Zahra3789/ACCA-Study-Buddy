# Exports the Web build and publishes it to her GitHub Pages site (~/GameDev/samurai-ledger-web).
# The game data is loaded as index.pck?v=<BUILD>, so a browser fetches each new update instead of reusing an
# old cached copy (GitHub Pages lets browsers keep files for 10 minutes, and Edge kept the old one even longer).
#   powershell -ExecutionPolicy Bypass -File tools\publish_web.ps1
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$site = Join-Path $env:USERPROFILE 'GameDev\samurai-ledger-web'
$utf8 = New-Object Text.UTF8Encoding $false
$godot = (Get-ChildItem $env:USERPROFILE -Recurse -Filter 'Godot*console*.exe' -ErrorAction SilentlyContinue -Depth 4 | Select-Object -First 1).FullName
$build = [regex]::Match([IO.File]::ReadAllText((Join-Path $root 'scripts\build_info.gd')), 'const BUILD := (\d+)').Groups[1].Value
Push-Location $root
& $godot --headless --path . --export-release 'Web' build/web/index.html 2>&1 | Select-String 'SCRIPT ERROR' | Select-Object -First 3
Pop-Location
$html = Join-Path $root 'build\web\index.html'
$t = [IO.File]::ReadAllText($html, $utf8)
if (-not $t.Contains('"executable":"index",')) { throw 'GODOT_CONFIG not found in index.html' }
$t = $t.Replace('"executable":"index",', '"executable":"index","mainPack":"index.pck?v=' + $build + '",')
[IO.File]::WriteAllText($html, $t, $utf8)
Copy-Item (Join-Path $root 'build\web\*') $site -Force
Push-Location $site
git add -A
git commit -q -m "Update $build"
git push -q origin main 2>&1 | Out-Null
Pop-Location
"Published update $build (game data loads as index.pck?v=$build)"
