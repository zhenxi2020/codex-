# Chrome / Edge 扩展项目规则

本项目继承用户级 `~/.codex/AGENTS.md`。本文件只补充项目事实。

## 项目入口

- 权限和入口：`manifest.json`。
- 后台与持久化：填写 background/service worker 路径。
- 页面交互：填写 content script 路径。
- 用户界面：填写 sidepanel、dashboard 或 popup 路径。

## 边界

- 不绕过登录、验证码、限流或浏览器安全机制。
- 权限和 host 权限变化必须说明必要性和升级影响。
- storage、队列和历史结构变化必须兼容旧数据。
- 发布目录和 ZIP 不是源码，未明确要求发布时不修改。

## 验证

- 先运行状态机、数据和共享逻辑的自动测试。
- DOM 适配在目标网站真实页面验证；共享逻辑变化才扩大平台回归。
- Service Worker 修改验证休眠或重启后的恢复。
- 自动测试、扩展加载、真实网页流程和发布包分别报告状态。
