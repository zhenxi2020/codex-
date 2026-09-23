[CmdletBinding()]
param(
    [string]$CodexHome,
    [switch]$SkipBackup
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if ([string]::IsNullOrWhiteSpace($CodexHome)) {
    if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) {
        $CodexHome = $env:CODEX_HOME
    } else {
        $CodexHome = Join-Path $env:USERPROFILE '.codex'
    }
}

$sourcePath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot 'AGENTS.md'))
$targetRoot = [System.IO.Path]::GetFullPath($CodexHome)
$targetPath = Join-Path $targetRoot 'AGENTS.md'

if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
    throw "规则源文件不存在：$sourcePath"
}

$sourceHash = (Get-FileHash -LiteralPath $sourcePath -Algorithm SHA256).Hash

if ((Test-Path -LiteralPath $targetPath -PathType Leaf)) {
    $targetHash = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash
    if ($sourceHash -eq $targetHash) {
        Write-Output "规则已经是最新版本：$targetPath"
        exit 0
    }
}

New-Item -ItemType Directory -Path $targetRoot -Force | Out-Null

if ((Test-Path -LiteralPath $targetPath -PathType Leaf) -and -not $SkipBackup) {
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    $backupPath = Join-Path $targetRoot "AGENTS.md.backup-$stamp"
    Copy-Item -LiteralPath $targetPath -Destination $backupPath
    Write-Output "已备份原规则：$backupPath"
}

Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
$installedHash = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash
if ($installedHash -ne $sourceHash) {
    throw "安装后哈希不一致：$targetPath"
}

Write-Output "已安装全局规则：$targetPath"
Write-Output "SHA256：$installedHash"
