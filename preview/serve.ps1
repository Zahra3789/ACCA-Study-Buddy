param([int]$Port = 8125)
# Local server for the HTML preview (prototype sandbox for the Godot app).
# Serves the project folder read-only; /preview/data.js is generated on every
# request from scripts/Content.gd, so the preview always shows the current questions.
$ErrorActionPreference = 'Stop'
$root = [System.IO.Path]::GetFullPath((Join-Path (Split-Path -Parent $MyInvocation.MyCommand.Path) '..'))
$types = @{ '.html'='text/html; charset=utf-8'; '.js'='application/javascript; charset=utf-8'; '.css'='text/css'; '.png'='image/png'; '.ttf'='font/ttf' }

# Content.gd's EXAMS constant is JSON apart from full-line # comments.
function Get-ExamsJs {
  $lines = Get-Content (Join-Path $root 'scripts\Content.gd') -Encoding UTF8
  $start = ($lines | Select-String -Pattern '^const EXAMS := \[' | Select-Object -First 1).LineNumber
  $end = ($lines | Select-String -Pattern '^func ' | Where-Object { $_.LineNumber -gt $start } | Select-Object -First 1).LineNumber
  $body = $lines[($start - 1)..($end - 2)] | Where-Object { $_.Trim() -notlike '#*' }
  $json = ($body -join "`n") -replace '^const EXAMS := ', ''
  $null = $json | ConvertFrom-Json   # throws if Content.gd has a syntax slip
  return "const EXAMS = $json;"
}

function Send($ctx, [byte[]]$bytes, $ct, $status = 200) {
  $ctx.Response.StatusCode = $status
  $ctx.Response.ContentType = $ct
  $ctx.Response.Headers.Add('Cache-Control', 'no-store')
  $ctx.Response.ContentLength64 = $bytes.Length
  $ctx.Response.OutputStream.Write($bytes, 0, $bytes.Length)
}

$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add("http://localhost:$Port/")
$listener.Start()
Write-Host "ACCA preview on http://localhost:$Port/ serving $root"

while ($listener.IsListening) {
  try {
    $ctx = $listener.GetContext()
    $path = [System.Uri]::UnescapeDataString($ctx.Request.Url.AbsolutePath).TrimStart('/')
    if ($path -eq '' ) { $ctx.Response.Redirect('/preview/'); $ctx.Response.Close(); continue }
    if ($path -eq 'preview/') { $path = 'preview/index.html' }
    if ($path -eq 'preview/data.js') {
      try { $js = Get-ExamsJs } catch { $js = "document.body.innerHTML = 'Content.gd could not be read: ' + " + (ConvertTo-Json "$_") + ";" }
      Send $ctx ([System.Text.Encoding]::UTF8.GetBytes($js)) $types['.js']
    } else {
      $file = [System.IO.Path]::GetFullPath((Join-Path $root $path))
      if ($file.StartsWith($root) -and (Test-Path $file -PathType Leaf)) {
        $ct = $types[[System.IO.Path]::GetExtension($file).ToLower()]; if (-not $ct) { $ct = 'application/octet-stream' }
        Send $ctx ([System.IO.File]::ReadAllBytes($file)) $ct
      } else {
        Send $ctx ([System.Text.Encoding]::UTF8.GetBytes("Not found: $path")) 'text/plain' 404
      }
    }
    $ctx.Response.OutputStream.Close()
  } catch { }
}
