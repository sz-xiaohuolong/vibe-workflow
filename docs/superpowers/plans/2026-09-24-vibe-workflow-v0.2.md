# Vibe Workflow V0.2 实施计划

> 本计划执行用户批准的四项增量：存量 `init`、文档地图、跨模块触发和证据等级。保留 v0.1 的熔断、Human Gates、Verification/Shipping 分离。

**目标：** 让旧仓库可重复接管，并让复杂度与交付状态有可核验的判定。

**设计：** 在 `SKILL.md` 加简短路由，详细接管契约放 `references/init.md`；现有 `artifacts.md` 保持事实所有权，增加可选 `DOCUMENT_MAP` 模板。跨模块规则放 `routing.md`，进度等级放 `quality-and-release.md` 与模板。测试使用真实场景判定和静态结构校验。

**技术栈：** Markdown Skill、Bash 静态校验、Git。

**需求来源：** 用户在当前任务提出的四项 v0.2 优化。

## 全局约束

- 不创建可执行 `init` CLI；`$vibe-workflow init` 是自然语言子命令。
- 沿用仓库已有事实源；只在职责缺失时创建模板。
- `init` 审计不要求冻结需求；进入 SPEC/Build 仍需入口 Gate。
- 任一跨模块触发至少 Bounded，风险 Gate 优先；仅满足长期方向等已有条件才升级 Architectural。
- POC、代码已写、正式验证和发布授权保持独立。
- 不暂存或提交用户现有的 `writing/` 目录。

## 风险关注

1. 老仓库已有 `PROJECT.md` 地图时，不能再建根地图形成竞争索引。
2. 第二次 `init` 不应重置人工维护的路径和状态。
3. Agent/MCP 关键词不能把无关单文件改动自动升级为 Architectural。
4. POC 的局部成功不能覆盖正式 Release 的 REQ/AC。
5. `IMPLEMENTED_UNVERIFIED` 不能被 Completed 栏标题误导为 Done。

## 任务 1：存量接管与地图

- [x] 先记录 V26–V27 的 v0.1 基线失败/缺口。
- [x] 修改 `SKILL.md`、`references/context.md`、`references/artifacts.md`，新增 `references/init.md` 和缺失职责时使用的地图模板。
- [x] 更新 `PROJECT.md` 模板，避免新项目产生第二张默认地图。
- [x] 用 V26–V27 重放检查审计、幂等和未知事实处理。

## 任务 2：跨模块判定

- [x] 先记录 V28–V29 的 v0.1 缺口。
- [x] 在 `references/routing.md` 加六类可观察触发与 Bounded/Architectural 升级条件。
- [x] 在实施计划模板补跨模块影响与验证映射。
- [x] 用 V28–V29 检查风险 Gate、范围分析与纯函数反例。

## 任务 3：证据等级

- [x] 先记录 V30–V32 的 v0.1 缺口。
- [x] 在 `references/quality-and-release.md` 规定 Task Delivery Status 与 Release Verification Status 的关系。
- [x] 在 `PROGRESS.md`、`VERIFICATION.md` 模板放状态与证据栏。
- [x] 用 V30–V32 检查 POC、已实现待验证、正式完成和 Shipping 分离。

## 任务 4：发布与验证

- [x] 更新中英文 README 的 v0.2 用法与真实测试表述。
- [x] 更新静态校验并运行 Skill Creator validator、仓库校验、回归场景。
- [x] 检查 diff 和 `git status`，只提交本任务文件。
- [x] 核对远端 `origin/main` 与已有标签，准备发布 `v0.2.0`。
