# Codex 可迁移规则包

这个仓库保存可以安全同步的 Codex 全局规则和项目模板。它不保存登录凭据、会话历史、数据库、浏览器状态或机器专用项目路径。

## 包含内容

- `AGENTS.md`：全局协作规则的可同步源文件。
- `install.ps1`：安装到当前用户的 Codex 目录；覆盖前自动备份旧规则。
- `verify.ps1`：检查 UTF-8 编码和必要规则章节。
- `export-current.ps1`：把本机正在使用的全局规则导回仓库。
- `safe-config.example.toml`：可手工参考的最小安全配置，不自动覆盖本机配置。
- `project-templates/`：网站、桌面软件和浏览器插件的项目级规则模板。

## 新电脑安装

```powershell
git clone https://github.com/zhenxi2020/codex-.git
Set-Location .\codex-
powershell -ExecutionPolicy Bypass -File .\install.ps1
powershell -ExecutionPolicy Bypass -File .\verify.ps1
```

安装脚本默认写入 `%USERPROFILE%\.codex\AGENTS.md`。如果环境变量 `CODEX_HOME` 已配置，则使用它。已有规则会备份为同目录的 `AGENTS.md.backup-时间戳`。

项目自己的 `AGENTS.md` 应与项目代码一起提交到项目仓库。新电脑克隆项目后，Codex 会同时读取全局规则和项目规则。

## 同一台电脑更换账号

全局和项目 `AGENTS.md` 都是本地文件，不随 Codex 账号切换而消失，通常无需重新安装。新账号仍需重新登录或连接：

- GitHub、Google Drive 等插件；
- 浏览器网站登录；
- API Key 和 MCP 凭据；
- Codex/ChatGPT 账号授权。

## 新电脑同时更换账号

1. 安装 Codex 并登录新账号。
2. 克隆本仓库，运行 `install.ps1` 和 `verify.ps1`。
3. 重新连接插件、浏览器账号和外部服务。
4. 克隆各项目仓库；项目级 `AGENTS.md` 会随代码恢复。
5. 参考 `safe-config.example.toml` 手工合并模型设置，不直接覆盖新电脑的 `config.toml`。

## 日常同步

本机全局规则有更新时：

```powershell
Set-Location <本仓库目录>
powershell -ExecutionPolicy Bypass -File .\export-current.ps1
powershell -ExecutionPolicy Bypass -File .\verify.ps1 -CodexHome $env:CODEX_HOME
git diff --check
git diff -- AGENTS.md
git add AGENTS.md
git commit -m "Update Codex collaboration rules"
git push
```

另一台电脑更新：

```powershell
git pull --ff-only
powershell -ExecutionPolicy Bypass -File .\install.ps1
powershell -ExecutionPolicy Bypass -File .\verify.ps1
```

## 不得同步

不要把以下本机文件复制到本仓库、网盘或其他账号：

```text
~/.codex/auth.json
~/.codex/.cockpit_codex_auth.json
~/.codex/.sandbox-secrets/
~/.codex/sessions/
~/.codex/archived_sessions/
~/.codex/*.sqlite*
~/.codex/logs*
~/.codex/thread_history*
~/.codex/.codex-global-state.json*
```

不要完整同步 `config.toml`。其中可能包含旧电脑路径、信任目录、插件状态或服务配置。只手工迁移确认安全且在新电脑仍有效的字段。

## 规则加载关系

Codex 会读取用户级 `~/.codex/AGENTS.md`，并继续读取从项目根目录到当前工作目录沿途的项目 `AGENTS.md`。更接近当前目录的项目规则用于补充或覆盖全局规则。因此：

- 通用流程放在本仓库的全局 `AGENTS.md`；
- 技术栈、真实入口、测试命令和项目风险放在项目自己的 `AGENTS.md`；
- 不要在每个项目重复复制整份全局规则。
