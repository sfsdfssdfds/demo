$ErrorActionPreference = 'Stop'

$libs = 'E:\demo\demo\libs'
New-Item -ItemType Directory -Force -Path $libs | Out-Null

$items = @(
  @{ url = 'https://unpkg.com/tesseract.js@5/dist/tesseract.min.js'; out = 'tesseract.min.js' },
  @{ url = 'https://unpkg.com/tesseract.js@5/dist/worker.min.js'; out = 'worker.min.js' },
  @{ url = 'https://unpkg.com/tesseract.js-core@5/tesseract-core.wasm.js'; out = 'tesseract-core.wasm.js' },
  @{ url = 'https://tessdata.projectnaptha.com/4.0.0/eng.traineddata.gz'; out = 'eng.traineddata.gz' }
)

foreach ($it in $items) {
  $dst = Join-Path $libs $it.out
  Write-Host ("Downloading " + $it.url)
  curl.exe -L --fail --retry 3 --retry-delay 1 -o $dst $it.url
  $len = (Get-Item $dst).Length
  Write-Host ("Saved " + $it.out + " (" + $len + " bytes)")
  if ($len -lt 1024) { throw ("Downloaded file too small: " + $it.out) }
}

Write-Host "ALL_OK"

