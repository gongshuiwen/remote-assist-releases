# Temporary interactive launcher; compatible with Windows PowerShell 5.1 and PowerShell 7+.
[CmdletBinding()]
param(
    [string]$Tag = 'v0.2.1-m1',
    [string]$BaseUrl = 'https://github.com/gongshuiwen/remote-assist-releases/releases/download',
    [string]$Invite = ''
)
$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest
if ($Tag -notmatch '^v[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.-]+)?$') {
    throw 'Specify an existing release version with -Tag vX.Y.Z.'
}
try { $base = [uri]::new($BaseUrl) } catch { throw 'Invalid download base URL.' }
if (-not $base.IsAbsoluteUri -or $base.Scheme -ne 'https' -or
    $base.UserInfo -or $base.Query -or $base.Fragment -or
    $BaseUrl -match '@') {
    throw 'Download base must be a trusted HTTPS URL without credentials, query, or fragment.'
}
$arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture.ToString().ToLowerInvariant()
switch ($arch) {
    'x64' { $targetArch = 'amd64' }
    'arm64' { $targetArch = 'arm64' }
    default { throw "Unsupported OS architecture: $arch" }
}
$asset = "assist-agent_${Tag}_windows_${targetArch}.exe"
$downloadUrl = $BaseUrl.TrimEnd('/') + '/' + $Tag
$workDir = Join-Path ([System.IO.Path]::GetTempPath()) ('remote-assist-' + [guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $workDir | Out-Null
try {
    $binary = Join-Path $workDir $asset
    $sums = Join-Path $workDir 'SHA256SUMS'
    Invoke-WebRequest -Uri "$downloadUrl/SHA256SUMS" -OutFile $sums -UseBasicParsing
    Invoke-WebRequest -Uri "$downloadUrl/$asset" -OutFile $binary -UseBasicParsing
    $pattern = '^([0-9a-f]{64})  ' + [regex]::Escape($asset) + '$'
    $hashes = @(Get-Content -LiteralPath $sums | ForEach-Object {
        if ($_ -cmatch $pattern) { $Matches[1] }
    })
    if ($hashes.Count -ne 1) { throw 'Expected exactly one valid SHA-256 entry.' }
    $actual = (Get-FileHash -LiteralPath $binary -Algorithm SHA256).Hash.ToLowerInvariant()
    if ($actual -cne $hashes[0]) { throw 'SHA-256 mismatch: refusing to execute.' }
    Write-Host 'Checksum verified. Please review the local authorization window.'
    if ($Invite) { & $binary --invite $Invite } else { & $binary }
    if ($LASTEXITCODE -ne 0) { throw "Agent exited with code: $LASTEXITCODE" }
} finally {
    Remove-Item -LiteralPath $workDir -Recurse -Force -ErrorAction SilentlyContinue
}
