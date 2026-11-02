$ErrorActionPreference = 'Stop'

# Replace this with your public GitHub repo before publishing.
$Repository = 'Seidkhan-Yusupov/ahk-shortcuts'
$Branch = 'main'
$ExpectedZipSha256 = '6F3663F7CDD25063C8C8728F5D9B07813CED8780522FD1F124BA539E2854215F'
if ($Repository -match '^USERNAME/') { throw 'Set $Repository to your GitHub user/repository first.' }

$SessionDir = Join-Path $env:TEMP ('khan-ahk-' + [guid]::NewGuid().ToString('N'))
$ZipPath = Join-Path $SessionDir 'autohotkey.zip'
$ScriptPath = Join-Path $SessionDir 'khan_sudo_keys.ahk'
$RuntimeDir = Join-Path $SessionDir 'runtime'
$RuntimeUrl = 'https://github.com/AutoHotkey/AutoHotkey/releases/download/v1.1.37.02/AutoHotkey_1.1.37.02.zip'
$ScriptUrl = "https://raw.githubusercontent.com/$Repository/$Branch/khan_sudo_keys.ahk"

New-Item -ItemType Directory -Path $SessionDir -Force | Out-Null
try {
    Write-Host 'Downloading official portable AutoHotkey v1...'
    Invoke-WebRequest -Uri $RuntimeUrl -OutFile $ZipPath -UseBasicParsing
    $ActualHash = (Get-FileHash -Path $ZipPath -Algorithm SHA256).Hash
    if ($ActualHash -ne $ExpectedZipSha256) { throw "AutoHotkey checksum mismatch: $ActualHash" }
    Expand-Archive -LiteralPath $ZipPath -DestinationPath $RuntimeDir
    $Runtime = Join-Path $RuntimeDir 'AutoHotkeyU64.exe'
    if (-not (Test-Path -LiteralPath $Runtime)) { throw 'Portable 64-bit executable missing in ZIP.' }

    Write-Host 'Downloading your latest shortcuts...'
    Invoke-WebRequest -Uri $ScriptUrl -OutFile $ScriptPath -UseBasicParsing
    Write-Host 'Shortcuts active! To finish, right-click the green H tray icon and choose Exit.'
    Write-Host 'Keep this PowerShell window open until you exit AutoHotkey.'
    $Process = Start-Process -FilePath $Runtime -ArgumentList ('"' + $ScriptPath + '"') -PassThru
    $Process.WaitForExit()
}
finally {
    Remove-Item -LiteralPath $SessionDir -Recurse -Force -ErrorAction SilentlyContinue
    Write-Host 'Session ended; temporary files removed.'
}
