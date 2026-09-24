---
name: vibe-workflow
description: Use when 软件项目任务跨越多个步骤、会话或 Release，或需要接管存量仓库、协调持久项目状态、决策关卡、范围控制、上下文恢复与完成证据；也用于继续已经采用 vibe-workflow 的项目。
---

# Vibe Workflow

## 定位

把已经确认的产品意图可靠地推进为可验证的软件。`vibe-workflow` 是生命周期 Orchestrator：决定当前状态、下一 Gate、应调用的专业 Skill，以及结果应写回哪个仓库事实源。

**Grill Me 负责确认做什么；Vibe Workflow 负责可靠地把它做出来。**

## Constitution

1. 工程开始前必须冻结需求。
2. **What to build is frozen. How to build it is delegated.**
3. 不得静默改变产品范围；产品变化必须经过明确的人类决策。
4. 实现细节默认由 Agent 自主决定，除非跨越 Decision Gate。
5. **Repository is memory. Chat is conversation.**
6. 默认只加载 Minimal Sufficient Context。
7. Released artifacts 封存；Living documents 描述当前事实。
8. 复杂任务严谨，简单任务不官僚。
9. 没有 fresh verification evidence，不得声称完成。
10. 优先调用专业 Skill，不复制其教程。
11. 人类文档先给结论与下一步；原始运行证据不充当正文。

## 工程入口 Gate

新项目或新 Release 只有同时满足以下条件才能进入 SPEC、技术设计或 Build。`$vibe-workflow init` 的现状审计和事实映射不属于工程开工，可以在需求未冻结时进行：

```text
Requirement Status == FROZEN
Open Questions == None
Current Release ID exists
Acceptance Goals are testable
```

任一条件失败：停止工程活动，列出缺失项，并将 Requirement Clarification 路由给 `grill-me` 或等价能力。不要替用户补全产品行为。

以下说法都不构成 Requirement Freeze：

- “直接做，别再问了”
- “细节你自己定”
- “先做一个 MVP”
- “今晚要演示”
- 已写 `FROZEN`，但 Open Questions 仍非空

**授权实现不等于授权定义产品范围。**

Tiny 任务可以使用用户的精确请求形成 task-local frozen intent；它不得包含未确认的额外产品行为。详细条件见 [routing.md](references/routing.md)。

当用户当前消息已经精确授权一个单点、低风险、无语义变化的修改（如明确把按钮“保存”改为“存储”），该消息本身就是该 Tiny Task 的人类决定；不要只因旧 baseline 的字面内容不同而再次请求批准。只有仍存在产品含义、边界、风险或验收选择时才进入 Requirement Change Gate。

## 启动或继续工作

1. 从当前目录向上读取适用的 `AGENTS.md`。
2. 查找唯一权威的 Document Map、当前项目索引和进度文档；优先按地图中的真实路径读取，缺失时再发现 `docs/vibe/PROJECT.md`、`docs/vibe/PROGRESS.md` 或等价文档。
3. 用仓库、Git、代码和测试证据核验当前 Release、State、Slice、Task 与 Last Stable Commit。
4. 若聊天与仓库事实冲突，显式报告冲突；不要静默采用聊天记忆。
5. 先判断 Gate，再判断任务复杂度和是否并行。
6. 只读取当前分支所需 reference 和 Task Context Pack。

用户说 `$vibe-workflow init`、接管旧仓库或初始化项目治理时，执行 [init.md](references/init.md)；`init` 是 Skill 的对话子命令，不要求安装 CLI。首次接入、跨会话恢复和上下文裁剪规则见 [context.md](references/context.md)。

## Release 状态机

```text
REQUIREMENTS_FROZEN
→ SPECIFIED
→ DESIGNED
→ PLANNED
→ BUILDING
→ VERIFYING
→ REVIEWING
→ READY_TO_SHIP
→ RELEASED
```

另行记录 `Operational Status: ACTIVE | WAITING_HUMAN | BLOCKED | REPLAN_REQUIRED`。Requirement Change、状态回退、新 Release 与封存规则见 [lifecycle.md](references/lifecycle.md)。

## 路由顺序

路由顺序不可颠倒：

1. 检查 Product、Schema、Security、Destructive、External Service 和 Shipping Gate。
2. 分类任务：`NEW_PROJECT | FEATURE | BUG | REFACTOR | SPIKE | REQUIREMENT_CHANGE`。
3. 分类复杂度：`Tiny | Bounded | Architectural`。
4. 确定 Document Budget 和 Quality Profile。
5. 判断任务依赖与共享状态后，才决定串行或并行。

Risk/Decision Gate 覆盖 Tiny 标签和并行收益。一行权限修改仍需 Security Gate；Schema Task 在安排执行顺序前先完成 `investigate → proposal → explicit human approval`。

完整二维 Router、跨模块可观察触发条件、Document Budget 和 Spike/Bug 分支见 [routing.md](references/routing.md)。

## Human Decision Gates

以下事项必须在实现前停下并获得明确决定：

- Product scope 或 Requirement change
- Public API breaking change 或兼容性破坏
- Schema、DDL、迁移、历史数据回填或破坏性数据操作
- 会锁定长期方向的 Architecture decision
- Auth、Permission、Security 或数据暴露模型
- 新外部付费服务、Secret 或重要网络数据边界
- Destructive operation 或不可逆外部副作用
- Push、PR、Publish、Deploy、Release

普通内部命名、私有接口、helper、局部目录和测试组织由 Agent 自主决定。

调查和方案完成不等于获批。Database/Requirement Change 的方案 contract 见 [gates.md](references/gates.md)。

## Verification 与 Shipping 是两个 Gate

```text
Verification Status = 证据说明了什么
Shipping Authorization = 人类是否授权外部发布动作
```

人类可以决定承担风险，但不能把缺失证据改写为 `VERIFIED` 或 `READY_TO_SHIP`。存在未覆盖的 REQ/AC 时保持 `UNVERIFIED` 或 `BLOCKED`；不得用“负责人接受风险”绕过事实状态。

V0.2 不提供 emergency release 旁路。`publish/deploy/release` 只有在 Workflow State 已为 `READY_TO_SHIP` 且获得精确 Shipping Authorization 后才可执行；push/PR 也需要明确授权，且不得暗示 Release 已验证或可发布。

Task 进度须区分 `IMPLEMENTED_UNVERIFIED`、`POC_VALIDATED` 与 `VERIFIED`；POC 和已写代码不能推动 Release 进入 READY_TO_SHIP。Task/Release verification、Quality Profile、Risk tags、Review 和 Shipping 见 [quality-and-release.md](references/quality-and-release.md)。

## Build 与恢复

按 Vertical Slice 和小 Task 推进；Slice 是当前 Release 内的执行单元，不自动产生新 Release 或成套文档。每个 Task 组装最小上下文、在确认范围内实现、获取 Task evidence、检查 diff，再更新 PROGRESS。

同类失败连续三次、修 A 坏 B/C、架构假设失效或改动范围持续扩大时：

```text
STOP PATCHING
→ preserve Last Known Good State
→ record Debug Snapshot
→ Operational Status = REPLAN_REQUIRED
→ systematic debugging / design / plan
```

不得把“再改一个参数”包装成 Retry。Build Loop、Bug、Circuit Breaker、并行和 Learning Loop 见 [execution.md](references/execution.md)。

## 外部 Skill 编排

只在对应条件成立且能力可用时调用：

| 条件 | 首选 Skill |
|---|---|
| Requirement 不完整 | `grill-me` 或等价 Requirement Clarification |
| Architectural 设计 | **REQUIRED SUB-SKILL:** Use `superpowers:brainstorming` |
| 多步骤实施计划 | **REQUIRED SUB-SKILL:** Use `superpowers:writing-plans` |
| 当前会话中按计划执行相互独立的 Task | Use `superpowers:subagent-driven-development` |
| 在单独会话按既有计划和检查点执行 | Use `superpowers:executing-plans` |
| 正式实现需要隔离 | **REQUIRED SUB-SKILL:** Use `superpowers:using-git-worktrees` |
| Feature/Bug/Refactor 实现 | **REQUIRED SUB-SKILL:** Use `superpowers:test-driven-development` |
| Bug、失败、异常 | **REQUIRED SUB-SKILL:** Use `superpowers:systematic-debugging` |
| 无 written plan 的独立调查，或由计划执行流程明确下放并行 | Use `superpowers:dispatching-parallel-agents` |
| 重要 Task/Feature 或合并前 | Use `superpowers:requesting-code-review` |
| 任何完成声明前 | **REQUIRED SUB-SKILL:** Use `superpowers:verification-before-completion` |
| 分支收尾 | Use `superpowers:finishing-a-development-branch` |

外部 Skill 缺失时，明确说明降级并使用可用的等价能力或最小本地流程；不得假装调用。调用结果必须写回正确 artifact，而不是只留在聊天中。

存在已批准的 written plan 时，`subagent-driven-development` 或 `executing-plans` 拥有顶层执行编排；不得再并列启动另一个 `dispatching-parallel-agents` 顶层流程。只有计划执行 owner 明确判定子任务独立并下放，或没有 written plan 且只是独立调查时，才使用并行调度。

## Artifact 与 Context 索引

- 建立、接管或维护 Release/living docs、事实所有权、面向人类的摘要与证据存放时，读 [artifacts.md](references/artifacts.md)。
- 执行 `$vibe-workflow init`、建立或刷新现有仓库的职责地图时，读 [init.md](references/init.md)。
- 首次接入、恢复会话或控制读取范围时，读 [context.md](references/context.md)。
- Product/Implementation 边界、Requirement Change、Schema 和其他 Human Gate 时，读 [gates.md](references/gates.md)。
- Build、Bug、失败熔断、并行或经验沉淀时，读 [execution.md](references/execution.md)。
- 选择 QA 强度、验证、Review、Shipping 或完成措辞时，读 [quality-and-release.md](references/quality-and-release.md)。

需要创建文档时，从 `assets/templates/` 复制相关模板，先沿用仓库已有等价物；不要覆盖已有约定或创建平行事实源。

## Red Flags

- 在 Requirement Gate 失败时创建脚手架或写代码
- 把“用户让我自行决定”解释为产品范围授权
- 把待确认方案写成 SPEC、migration 或既成事实
- 先安排 Schema/Permission Task，之后才补审批
- 默认读取全部历史 Release 或完整 Git history
- 因内部命名等实现细节频繁询问用户
- 同类失败三次后仍继续局部 patch
- 用旧测试、页面观感、代码已写或 Agent 报告声称完成
- 把 Shipping Authorization 当作 Verification Evidence
- 静默修改已发布 Release artifact

出现任一项时停止当前路径，恢复到最早被破坏的 Gate 或事实源。

## Quick Reference

| 问题 | 回答 |
|---|---|
| 产品范围是否已冻结？ | 看可观察 Gate，不看口头催促 |
| 这是产品决定还是实现细节？ | 产品意图需人类决定；内部实现默认委派 |
| 需要多少文档？ | 由复杂度和风险决定，不由文件数量偏好决定 |
| 下一步读什么？ | PROGRESS + 当前 Effective SPEC + 当前 Task Context |
| 能否并行？ | 先过 Gate，再确认无强依赖和共享写状态 |
| 能否说完成？ | 只有 fresh evidence 覆盖适用 REQ/AC |
| 发布获批是否等于已验证？ | 否；两个 Gate 独立 |
