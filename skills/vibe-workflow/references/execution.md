# Build、Bug、Circuit Breaker 与 Learning Loop

## 何时读取

进入 BUILDING、选择下一个 Task、处理 Bug/测试失败、连续修复失败、调度并行工作或沉淀项目经验时读取本文件。

## Vertical Slice

优先围绕完整业务闭环拆分：

```text
Slice 1: 开始录音完整闭环
Slice 2: 停止、预览、保存完整闭环
Slice 3: 历史列表和删除完整闭环
```

不要默认按“数据库全部完成 → 后端全部完成 → 前端全部完成”横向拆分。每个 Slice 尽量可运行、可验证、可提交、可回退。

只有复杂 Release 才增加 Phase；不要为了流程制造层级。

## Task Loop

```text
Select Next Task
→ Assemble Task Context
→ Confirm frozen scope and applicable Gates
→ Inspect existing code/tests
→ failing test / observable check
→ minimal implementation
→ task verification
→ inspect diff
→ review when required
→ checkpoint/commit when available
→ update PROGRESS
→ Next Task
```

实现 Feature、Bug、Refactor 时使用 `superpowers:test-driven-development` 或等价能力。这里不复制 TDD 步骤。

Task 完成前至少确认：

- 改动仍在 REQ/AC 和当前 Task 范围内。
- 相关测试/检查有 fresh output。
- diff 不包含无关重构或用户现有改动。
- PROGRESS 记录 evidence、稳定点和 Next Task。

## Bug Workflow

```text
BUG REPORT
→ reproduce
→ gather evidence
→ root cause investigation
→ regression test
→ fix
→ verify
→ update BUG/related docs
→ checkpoint/commit
```

使用 `superpowers:systematic-debugging`。复杂 Bug 可从 `assets/templates/BUG.md` 建立记录；简单 Bug 沿用现有 tracker，不强制新文件。

分支判断：

- 实现偏离 Effective SPEC：Bug fix。
- 实现符合 SPEC，但期望应改变：Requirement Change。
- SPEC 与运行事实冲突且意图不明：停止并调查事实所有权，不能静默选一个。

## Retry 与 Replan

Retry 只适用于有新证据支持的 transient failure、明确 typo、环境波动或单一错误修正。

满足任一项触发 Circuit Breaker：

- 同类失败连续三次。
- 每次修复都产生新的回归。
- 原架构假设被证据否定。
- 修改范围持续扩大。
- 修 A 导致 B/C/D 失效。

触发后：

1. `STOP PATCHING`。
2. 保留或恢复 Last Known Good State；不破坏用户未提交改动。
3. 记录 Debug Snapshot：symptom、reproduction、evidence、attempts、diff、当前假设。
4. `Operational Status = REPLAN_REQUIRED`。
5. 建立 fresh context。
6. 路由到 systematic debugging；必要时回到 DESIGN 或 PLAN。

用户说“再试一次”“只改一个参数”不能解除熔断。只有新证据把问题重新分类为合法 Retry，或新的计划经过必要 Gate 后，才恢复执行。

## Last Known Good State

优先使用可恢复方式：独立 worktree/branch、明确 commit、patch、备份或已验证 artifact。不要使用会丢失用户工作的 destructive reset。

没有 Git 时，在 PROGRESS 中写明可复现的稳定 artifact、测试结果和恢复步骤；不要伪造 commit ID。

## Parallel Rules

### Exploration Race

多个 Agent 可独立调查或提出方案；输出进入比较/Decision Gate。决定前不并行实现互斥方案。

### Execution Parallel

仅用于已过 Gate、无强依赖、无共享写状态、Context/Acceptance 独立的 Task。每个 Agent 有明确文件范围和 evidence contract；合并后必须运行集成验证和 review。

禁止未经协调同时修改：同一核心文件、同一 Schema/migration、共享状态机、同一公共 contract 的互相依赖两端。

使用 `superpowers:dispatching-parallel-agents` 时只传精确 Context Pack，不传整个会话历史。

## Progress 更新

Task 开始、完成、阻塞或触发 Gate/Circuit Breaker 时，同一轮更新 PROGRESS：

- Current Release/State/Status。
- Current Slice/Task。
- Last Stable Commit/artifact。
- Completed/In Progress。
- 新 evidence、known bugs、blockers、open decisions。
- Next Task。

PROGRESS 不复制 SPEC、TECH_DESIGN 或完整日志，只链接 owner。

## Learning Loop

按知识类型沉淀：

| 发现 | 写入 |
|---|---|
| 一次性 Bug 事实 | BUG record |
| 重大架构选择 | DEC |
| Agent 反复犯同类仓库特定错误 | AGENTS.md |
| 当前产品行为 | Effective SPEC |
| 当前架构 | TECH_DESIGN |
| 当前执行状态 | PROGRESS |
| 通用 Skill 的真实行为漏洞 | Skill 测试与最小规则修正 |

不要建立无人维护的巨大 LEARNINGS.md，也不要因单次特殊失败增加普遍规则。
