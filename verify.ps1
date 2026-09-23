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

$targetRoot = [System.IO.Path]::GetFullPath($CodexHome)
$targetPath = Join-Path $targetRoot 'AGENTS.md'
if (-not (Test-Path -LiteralPath $targetPath -PathType Leaf)) {
    throw "未找到全局规则：$targetPath"
}

$strictUtf8 = [System.Text.UTF8Encoding]::new($false, $true)
$bytes = [System.IO.File]::ReadAllBytes($targetPath)
$text = $strictUtf8.GetString($bytes)

$requiredSections = @(
    '# Codex 长期协作规则',
    '## 1. 每次任务先给模型建议',
    '## 2. 思考模型路由',
    '## 3. 修改前确认门禁',
    'Agent Team 与子代理',
    'Token 与时间控制',
    '测试临时文件清理'
)

$missing = @($requiredSections | Where-Object { -not $text.Contains($_) })
if ($missing.Count -gt 0) {
    throw "规则缺少必要章节：$($missing -join '；')"
}

$hash = (Get-FileHash -LiteralPath $targetPath -Algorithm SHA256).Hash
Write-Output "验证通过：$targetPath"
Write-Output "必要章节：$($requiredSections.Count)/$($requiredSections.Count)"
Write-Output "SHA256：$hash"
