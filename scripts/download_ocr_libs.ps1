$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$proj = Split-Path -Parent $root
$libs = Join-Path $proj 'libs'
New-Item -ItemType Directory -Force -Path $libs | Out-Null

function Download-FirstOk($urls, $outFile, $minBytes) {
  foreach ($u in $urls) {
    try {
      Write-Host ("Downloading: " + $u)
      Invoke-WebRequest -UseBasicParsing -Uri $u -OutFile $outFile -TimeoutSec 60
      $len = (Get-Item $outFile).Length
      if ($len -ge $minBytes) {
        Write-Host ("OK: " + $outFile + " (" + $len + " bytes)")
        return
      } else {
        Write-Host ("Too small: " + $len + " bytes, retry next url")
      }
    } catch {
      Write-Host ("FAIL: " + $u + " -> " + $_.Exception.Message)
    }
  }
  throw ("All URLs failed for " + (Split-Path -Leaf $outFile))
}

# 1) tesseract.min.js
Download-FirstOk @(
  'https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js',
  'https://unpkg.com/tesseract.js@5/dist/tesseract.min.js',
  'https://fastly.jsdelivr.net/npm/tesseract.js@5/dist/tesseract.min.js'
) (Join-Path $libs 'tesseract.min.js') 50000

# 2) worker.min.js
Download-FirstOk @(
  'https://cdn.jsdelivr.net/npm/tesseract.js@5/dist/worker.min.js',
  'https://unpkg.com/tesseract.js@5/dist/worker.min.js',
  'https://fastly.jsdelivr.net/npm/tesseract.js@5/dist/worker.min.js'
) (Join-Path $libs 'worker.min.js') 50000

# 3) tesseract-core.wasm.js (来自 tesseract.js-core 包)
Download-FirstOk @(
  'https://cdn.jsdelivr.net/npm/tesseract.js-core@5/tesseract-core.wasm.js',
  'https://unpkg.com/tesseract.js-core@5/tesseract-core.wasm.js',
  'https://fastly.jsdelivr.net/npm/tesseract.js-core@5/tesseract-core.wasm.js'
) (Join-Path $libs 'tesseract-core.wasm.js') 50000

# 4) eng.traineddata.gz (语言包)
Download-FirstOk @(
  'https://cdn.jsdelivr.net/npm/tesseract.js@5/lang-data/eng.traineddata.gz',
  'https://unpkg.com/tesseract.js@5/lang-data/eng.traineddata.gz',
  'https://tessdata.projectnaptha.com/4.0.0/eng.traineddata.gz'
) (Join-Path $libs 'eng.traineddata.gz') 1000000

Write-Host 'DONE'

