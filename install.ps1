<#
  Jeffrey0117 . toolbox - install my own apps on any Windows machine.

  New machine, just want the tools (not a dev setup)?  Run:
    irm https://raw.githubusercontent.com/Jeffrey0117/toolbox/main/install.ps1 | iex

  As a local file you also get:
    .\install.ps1 -List                       # show the catalog, install nothing
    .\install.ps1 -Only lanpai-overlay,RePic  # only these
    .\install.ps1 -Silent                     # silent installs where supported

  Sibling project: DevFault rebuilds a DEV environment. This one installs
  finished apps to USE. See README.
#>
param(
  [switch]$List,
  [switch]$Silent,
  [string[]]$Only
)

$ErrorActionPreference = 'Stop'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$ProgressPreference = 'SilentlyContinue'

$Owner = 'Jeffrey0117'
$Root  = 'C:\Tools'

# The catalog. Add a line here when you ship a new app.
$Apps = @(
  [pscustomobject]@{ Repo = 'lanpai-overlay'; Name = 'Lanpai Overlay'; Desc = 'On-screen overlay for text and images' }
  [pscustomobject]@{ Repo = 'DuckShot';       Name = 'DuckShot';       Desc = 'Lightweight screenshot tool' }
  [pscustomobject]@{ Repo = 'RePic';          Name = 'RePic';          Desc = 'Batch image resizer' }
  [pscustomobject]@{ Repo = 'Screenshot-OCR'; Name = 'Screenshot OCR'; Desc = 'Screenshot to text (OCR)' }
  [pscustomobject]@{ Repo = 'PyClick';        Name = 'PyClick';        Desc = 'Image-recognition auto clicker' }
  [pscustomobject]@{ Repo = 'MemoryGuy';      Name = 'MemoryGuy';      Desc = 'RAM monitor / one-click optimize' }
  [pscustomobject]@{ Repo = 'ReVid';          Name = 'ReVid';          Desc = 'Local video viewer / cropper' }
  [pscustomobject]@{ Repo = 'ClaudeBot';      Name = 'ClaudeBot';      Desc = 'Control Claude Code via Telegram' }
)

function Resolve-Asset($repo) {
  $api = "https://api.github.com/repos/$Owner/$repo/releases/latest"
  $rel = Invoke-RestMethod -Uri $api -Headers @{ 'User-Agent' = 'toolbox-installer' }
  $exes = @($rel.assets | Where-Object { $_.name -like '*.exe' })
  if ($exes.Count -eq 0) { return $null }

  $portable = $exes | Where-Object { $_.name -match 'portable' } | Select-Object -First 1
  $setup    = $exes | Where-Object { $_.name -match 'setup|install' } | Select-Object -First 1
  if     ($portable) { $pick = $portable; $kind = 'portable' }
  elseif ($setup)    { $pick = $setup;    $kind = 'installer' }
  else               { $pick = $exes[0];  $kind = 'portable' }

  [pscustomobject]@{
    Version = $rel.tag_name
    File    = $pick.name
    Url     = $pick.browser_download_url
    Kind    = $kind
  }
}

function New-StartMenuShortcut($target, $name) {
  $programs = [Environment]::GetFolderPath('Programs')
  $shell = New-Object -ComObject WScript.Shell
  $lnk = $shell.CreateShortcut((Join-Path $programs "$name.lnk"))
  $lnk.TargetPath = $target
  $lnk.WorkingDirectory = (Split-Path $target)
  $lnk.Save()
}

$targets = if ($Only) { $Apps | Where-Object { $Only -contains $_.Repo } } else { $Apps }

if ($List) {
  Write-Host ""
  Write-Host "  toolbox - Jeffrey0117's apps" -ForegroundColor Cyan
  Write-Host ""
  $targets | ForEach-Object { "    {0,-16} {1}" -f $_.Repo, $_.Desc }
  Write-Host ""
  return
}

New-Item -ItemType Directory -Force -Path $Root | Out-Null
$ok = 0
$fail = 0

foreach ($app in $targets) {
  Write-Host ""
  Write-Host "-> $($app.Name)  ($($app.Repo))" -ForegroundColor Cyan
  try {
    $a = Resolve-Asset $app.Repo
    if (-not $a) {
      Write-Host "   no .exe release asset, skipped" -ForegroundColor Yellow
      continue
    }
    $dir = Join-Path $Root $app.Repo
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $out = Join-Path $dir $a.File

    Write-Host "   downloading $($a.File)  [$($a.Version)]"
    Invoke-WebRequest -Uri $a.Url -OutFile $out

    if ($a.Kind -eq 'installer') {
      Write-Host "   running installer..."
      if ($Silent) { Start-Process -FilePath $out -ArgumentList '/S' -Wait }
      else         { Start-Process -FilePath $out -Wait }
    } else {
      New-StartMenuShortcut -target $out -name $app.Name
      Write-Host "   portable -> Start Menu shortcut created"
    }
    Write-Host "   done" -ForegroundColor Green
    $ok++
  } catch {
    Write-Host "   failed: $($_.Exception.Message)" -ForegroundColor Red
    $fail++
  }
}

Write-Host ""
Write-Host "Done: $ok ok / $fail failed. Files in $Root" -ForegroundColor Green
Write-Host ""
