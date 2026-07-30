# Upload this temp HTML project via FTP.
# 1. Copy ftp.config.example.json -> ftp.config.json and fill in credentials
# 2. From Git Bash:  powershell.exe -ExecutionPolicy Bypass -File ./upload.ps1
#    From PowerShell: powershell -ExecutionPolicy Bypass -File .\upload.ps1

$ErrorActionPreference = "Stop"
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
$ConfigPath = Join-Path $Root "ftp.config.json"

if (-not (Test-Path $ConfigPath)) {
  Write-Error "Missing ftp.config.json. Copy ftp.config.example.json and fill in your server details."
}

$config = Get-Content $ConfigPath -Raw | ConvertFrom-Json
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$usePassive = if ($null -ne $config.usePassive) { [bool]$config.usePassive } else { $true }
$port = if ($config.port) { [int]$config.port } else { 21 }
$remoteDir = ($config.remoteDir -replace '\\', '/').TrimEnd('/')

# Inject build stamp into a temp copy of app.js for verification
$jsSrc = Join-Path $Root "js\app.js"
$jsTemp = Join-Path $env:TEMP "ftp-test-app-$stamp.js"
$jsBody = Get-Content $jsSrc -Raw
$jsBody = "window.__FTP_BUILD__ = '$stamp';`r`n" + $jsBody
Set-Content -Path $jsTemp -Value $jsBody -NoNewline

$files = @(
  @{ Local = (Join-Path $Root "index.html"); Remote = "$remoteDir/index.html" },
  @{ Local = (Join-Path $Root "css\style.css"); Remote = "$remoteDir/css/style.css" },
  @{ Local = $jsTemp; Remote = "$remoteDir/js/app.js" }
)

function Get-FtpUri([string]$path) {
  $path = $path -replace '\\', '/'
  if (-not $path.StartsWith('/')) { $path = "/$path" }
  return "ftp://$($config.host):$port$path"
}

function Invoke-FtpCommand([string]$uri, [string]$method) {
  $req = [System.Net.FtpWebRequest]::Create($uri)
  $req.Credentials = New-Object System.Net.NetworkCredential($config.user, $config.password)
  $req.Method = $method
  $req.UsePassive = $usePassive
  $req.UseBinary = $true
  $req.KeepAlive = $false
  try {
    $resp = $req.GetResponse()
    $resp.Close()
    return $true
  } catch {
    return $false
  }
}

function Ensure-FtpDirectory([string]$dirPath) {
  $parts = ($dirPath.Trim('/') -split '/') | Where-Object { $_ }
  $built = ""
  foreach ($part in $parts) {
    $built += "/$part"
    $null = Invoke-FtpCommand (Get-FtpUri $built) ([System.Net.WebRequestMethods+Ftp]::MakeDirectory)
  }
}

function Upload-FtpFile([string]$localPath, [string]$remotePath) {
  $uri = Get-FtpUri $remotePath
  $req = [System.Net.FtpWebRequest]::Create($uri)
  $req.Credentials = New-Object System.Net.NetworkCredential($config.user, $config.password)
  $req.Method = [System.Net.WebRequestMethods+Ftp]::UploadFile
  $req.UsePassive = $usePassive
  $req.UseBinary = $true
  $req.KeepAlive = $false

  $bytes = [System.IO.File]::ReadAllBytes($localPath)
  $req.ContentLength = $bytes.Length
  $stream = $req.GetRequestStream()
  $stream.Write($bytes, 0, $bytes.Length)
  $stream.Close()

  $resp = $req.GetResponse()
  $status = $resp.StatusDescription.Trim()
  $resp.Close()
  return $status
}

Write-Host "Uploading to $($config.host)$remoteDir ..."
Write-Host "Build stamp: $stamp"
Write-Host ""

Ensure-FtpDirectory "$remoteDir/css"
Ensure-FtpDirectory "$remoteDir/js"

foreach ($f in $files) {
  Write-Host "  put $($f.Remote) ..."
  $status = Upload-FtpFile $f.Local $f.Remote
  Write-Host "    $status"
}

Remove-Item $jsTemp -ErrorAction SilentlyContinue

Write-Host ""
Write-Host "Done. Open the site and confirm build stamp = $stamp"
