$ErrorActionPreference = 'Stop'

$dir = 'E:\demo\demo\vendor'
New-Item -ItemType Directory -Force -Path $dir | Out-Null

$out = Join-Path $dir 'tesseract.min.js'
$urls = @(
  'https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js',
  'https://unpkg.com/tesseract.js@5/dist/tesseract.min.js',
  'https://fastly.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js'
)

foreach ($u in $urls) {
  try {
    Write-Host ("Downloading $u")
    Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile $out
    if ((Get-Item $out).Length -gt 100000) {
      Write-Host 'OK'
      exit 0
    }
  } catch {
    Write-Host ("FAIL $u -> " + $_.Exception.Message)
  }
}

throw 'All download URLs failed'

