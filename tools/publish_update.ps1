# publish_update.ps1 -- ship a Samurai Ledger update to phones (same idea as DojoChef's).
#
# Normal run (content update - scripts, questions, screens, art; no reinstall):
#   1. bumps BUILD in scripts/build_info.gd (N -> N+1) and writes it to build/update/version.txt
#   2. exports a fresh content pack, build/update/content.pck, with the Android preset
#   3. uploads version.txt + content.pck to the rolling "live" GitHub release (--clobber)
#   Phones download it the next time the app opens.
#
# With -Apk (only when the app itself must change: icon, app name, permissions, a new Godot engine):
#   also bumps the app version (project.godot config/version + export_presets.cfg version/name and code),
#   builds the APK and uploads it with apk.txt. Phones then show "Update ready - tap to download".
#
#   powershell -ExecutionPolicy Bypass -File tools\publish_update.ps1
#   powershell -ExecutionPolicy Bypass -File tools\publish_update.ps1 -Apk
param([switch]$Apk)
$ErrorActionPreference = "Stop"

$Proj  = Split-Path -Parent $PSScriptRoot          # the project folder (this script lives in its tools folder)
$Dev   = Join-Path $env:USERPROFILE "GameDev"      # Godot and the Android tools live under GameDev in your user folder
$Godot = Join-Path $Dev "Godot\Godot_v4.7.2-stable_win64_console.exe"
$Gh    = "C:\Program Files\GitHub CLI\gh.exe"
$Repo  = "Zahra3789/ACCA-Study-Buddy"
$Tag   = "live"
$env:JAVA_HOME    = Join-Path $Dev "Tools\jdk17"
$env:ANDROID_HOME = Join-Path $Dev "Tools\android-sdk"
$utf8 = New-Object Text.UTF8Encoding $false

$updateDir = Join-Path $Proj "build\update"
New-Item -ItemType Directory -Force -Path $updateDir | Out-Null
$pck     = Join-Path $updateDir "content.pck"
$verFile = Join-Path $updateDir "version.txt"
$apkFile = Join-Path $Proj "build\android\ACCA_Study_Buddy.apk"
$apkTxt  = Join-Path $updateDir "apk.txt"

# --- 1. bump BUILD --------------------------------------------------------------
$buildInfo = Join-Path $Proj "scripts\build_info.gd"
$text = [IO.File]::ReadAllText($buildInfo)
$m = [regex]::Match($text, 'const BUILD := (\d+)')
if (-not $m.Success) { throw "Could not find 'const BUILD := N' in build_info.gd" }
$new = [int]$m.Groups[1].Value + 1
[IO.File]::WriteAllText($buildInfo, [regex]::Replace($text, 'const BUILD := \d+', "const BUILD := $new"), $utf8)
[IO.File]::WriteAllText($verFile, "$new", $utf8)
Write-Host "Content version -> $new"

# --- 2. optional: bump the app version ---------------------------------------------
if ($Apk) {
  $pg = Join-Path $Proj "project.godot"
  $ep = Join-Path $Proj "export_presets.cfg"
  $pgText = [IO.File]::ReadAllText($pg)
  $cur = [regex]::Match($pgText, 'config/version="(\d+)\.(\d+)"')
  $ver = "$($cur.Groups[1].Value).$([int]$cur.Groups[2].Value + 1)"
  [IO.File]::WriteAllText($pg, [regex]::Replace($pgText, 'config/version="[\d.]+"', "config/version=`"$ver`""), $utf8)
  $epText = [IO.File]::ReadAllText($ep)
  $code = [int]([regex]::Match($epText, 'version/code=(\d+)').Groups[1].Value) + 1
  $epText = [regex]::Replace($epText, 'version/code=\d+', "version/code=$code")
  $epText = [regex]::Replace($epText, 'version/name="[\d.]+"', "version/name=`"$ver`"")
  [IO.File]::WriteAllText($ep, $epText, $utf8)
  [IO.File]::WriteAllText($apkTxt, $ver, $utf8)
  Write-Host "App version -> $ver (code $code)"
}

# --- 3. import + export -------------------------------------------------------------
Write-Host "Importing..."
& $Godot --headless --path $Proj --import | Out-Null
Write-Host "Exporting content pack..."
& $Godot --headless --path $Proj --export-pack "Android" $pck | Out-Null
if (-not (Test-Path $pck)) { throw "Pack was not created: $pck" }
Write-Host ("Pack built: {0} MB" -f [math]::Round((Get-Item $pck).Length / 1MB, 1))
if ($Apk) {
  Write-Host "Building APK..."
  & $Godot --headless --path $Proj --export-debug "Android" $apkFile | Out-Null
  if (-not (Test-Path $apkFile)) { throw "APK was not created: $apkFile" }
}

# --- 4. upload to the rolling "live" release ------------------------------------------
$files = @($verFile, $pck)
if ($Apk) { $files += @($apkTxt, $apkFile) }
Write-Host "Uploading to the '$Tag' release..."
& $Gh release upload $Tag @files --clobber --repo $Repo
Write-Host "Done. Phones pick up content version $new next time the app opens."
