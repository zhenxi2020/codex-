[CmdletBinding()]
param(
    [string]$CodexHome
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

$sourcePath = Join-Path ([System.IO.Path]::GetFullPath($CodexHome)) 'AGENTS.md'
$targetPath = [System.IO.Path]::GetFullPath((Join-Path $PSScriptRoot 'AGENTS.md'))
if (-not (Test-Path -LiteralPath $sourcePath -PathType Leaf)) {
    throw "未找到本机全局规则：$sourcePath"
}

$strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
$text = $strictUtf8.GetString([System.IO.File]::ReadAllBytes($sourcePath))
foreach ($required in @('# Codex 长期协作规则', '思考模型路由', '修改前确认门禁')) {
    if (-not $text.Contains($required)) {
        throw "本机规则缺少必要内容：$required"
    }
}

Copy-Item -LiteralPath $sourcePath -Destination $targetPath -Force
Write-Output "已把本机规则导出到仓库：$targetPath"
Write-Output "请先运行 verify.ps1、检查 git diff，再提交和推送。"
