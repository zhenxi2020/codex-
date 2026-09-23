# 本地工作台项目规则

本项目继承 `C:\Users\Administrator\.codex\AGENTS.md`。本文件只补充项目事实、模块边界和命令。

## 项目结构

- 这是 Windows 局域网多人任务工作台，根目录使用 npm workspaces。
- `apps/client/`：Electron + React + Vite 客户端；正式 Electron 入口是 `apps/client/electron/main.cjs`。
- `apps/server/`：TypeScript + Express + WebSocket + SQLite 服务端。
- `packages/contracts/`：客户端与服务端共享的 Zod 类型和协议。
- 根目录 `electron/`、`server.cjs` 与 `legacy:*` 脚本是旧链路；除非任务明确针对旧版，不以它们作为正式实现入口。
- `node_modules/`、各包 `dist/`、安装包和测试输出是生成内容，不直接修改。

## 模块边界

- 修改客户端与服务端交互前，先检查 `packages/contracts/`；协议变化必须同时验证两端兼容。
- 数据库、认证、更新、上传、网络发现和局域网监听属于高影响范围，确认单必须写明数据迁移、失败回滚和兼容策略。
- 不擅自升级 Electron、React、数据库或安全依赖，不混用 npm 与 pnpm 更新锁文件。
- 保留用户已有数据和配置；测试使用隔离目录，不连接正式工作台数据。

## 针对性命令

- 客户端类型检查：`npm run typecheck --workspace @team-workbench/client`
- 客户端渲染测试：`npm run test:renderer --workspace @team-workbench/client`
- Electron 主进程测试：`npm run test:electron --workspace @team-workbench/client`
- 服务端类型检查：`npm run typecheck --workspace @team-workbench/server`
- 服务端测试：`npm run test --workspace @team-workbench/server`
- 协议测试：`npm run test --workspace @team-workbench/contracts`
- 全仓检查只在跨模块或发布任务执行：`npm run typecheck`、`npm test`。

## 发布边界

- 用户未明确要求发布时，不执行 `package:win*`、不生成安装包、不升级版本。
- 构建通过不等于安装版通过；源码、构建、目录包和安装包分别报告验证状态。

## 文档路由

- 当前计划与 Review：`tasks/todo.md`。
- 只按当前问题关键词读取 `tasks/lessons.md` 和 `docs/`，不在每次任务中加载全部历史。
