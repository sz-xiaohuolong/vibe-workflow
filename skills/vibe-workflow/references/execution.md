# Build、Bug、Circuit Breaker 与 Learning Loop

## 何时读取

执行普通 Git 操作、进入 BUILDING、选择下一个 Task、处理 Bug/测试失败、连续修复失败、调度并行工作或沉淀项目经验时读取本文件。

## Lightweight Git Workflow

这是各阶段均可使用的保存/协作流程，不是新增生命周期阶段。仅要求 Git 操作时执行本节，不套用下方 Task 完成、TDD、Review 或 Release 契约。

| 操作 | 授权范围与结果 |
|---|---|
| `COMMIT` | 将本次授权 diff 提交到当前明确分支；不隐含 push |
| `PUSH_BRANCH` | 将已确定的本地分支/提交推到明确 remote/branch；不顺带提交工作树 |
| `COMMIT_AND_PUSH` | 提交本次授权 diff 并推到已确定 remote/branch；同一次请求覆盖两步 |
| `OPEN_PR` | 为明确 head/base 创建 PR；不隐含 merge 或发布。需要先推送 head 时，只执行已在用户授权范围内的推送 |

必要检查与执行顺序：

1. `git status`；确定当前分支、upstream、remote 和目标 branch；PR 另确定 head/base。可用当前仓库 upstream 与会话明确目标消除歧义；仍有多个合理目标、detached HEAD 或目标不明时先确认，不猜测。
2. 核对实际操作范围：Commit 检查 staged/unstaged diff 与拟加入的 untracked 文件，按范围显式暂存；Push 检查将发送的提交及相对目标的 diff，不混入无关本地提交；PR 检查 head 相对 base 的 diff。必要时只刷新目标远程引用。识别未授权修改、Secret、危险操作及已知自动部署副作用，不为普通推送扩展成完整文档/安全审计。
3. 必要时对拟提交 diff 执行 `git diff --check` 或 `git diff --cached --check`。发现危险或越界内容时排除，无法安全隔离才停止并说明具体问题。
4. 核对已有验证证据对应的 commit/tree、改动范围、命令和环境是否仍适用。同一被测代码及相关环境未变时复用证据，不因 Commit / Push 重跑测试。缺失、过期、失败或仅覆盖部分功能时如实报告并保留验证状态；普通开发分支仍可授权推送。仅用户另要求验证、改动使相关证据失效且本次需作验证声明，或仓库强制检查要求时，运行最小相关检查；不自动补齐完整 Release Verification 或全量测试。
5. 用户明确要求 Commit / Push / PR 且目标、范围和影响确定时直接执行，不再询问相同授权。force push（含 `--force-with-lease`）、amend/rebase 后覆盖远程历史或其他高风险操作必须获得针对该动作与目标的单独明确授权。non-fast-forward 或保护分支拒绝时停止并报告，不自动改为 force push。
6. 用 Git 返回结果及必要的提交/远程引用核对报告 commit、branch、remote 或 PR 链接；Git 操作失败只报告实际结果。保留 Current Stage、Workflow State、Task/Release Verification Status 和 Shipping Authorization；若按仓库约定记录 checkpoint，不把未验证 commit 写成 Last Known Good/已验证稳定点。

普通 Git 操作不自动触发完整 Release Verification、全量 Code Review、`gstack:ship`、版本 Bump、Release Tag、完整 Documentation Audit、Release Archive 或 Reflecting。代码未改、证据仍适用时也不重复验证；创建 PR 本身不启动 Stage 4 全量 Review。Git 成功只能支持“已提交/已推送/已创建 PR”，不能支持 `VERIFIED`、`READY_TO_SHIP` 或 `RELEASED` 声明。

用户明确要求正式 Publish / Deploy / Release，或已知目标 push/PR 会直接触发这些动作时，执行 [quality-and-release.md](quality-and-release.md) 的完整 Shipping Gate。普通分支同步授权不包含生产部署或发布授权。

## Vertical Slice

优先围绕完整业务闭环拆分：

```text
Slice 1: 开始录音完整闭环
Slice 2: 停止、预览、保存完整闭环
Slice 3: 历史列表和删除完整闭环
```

不要默认按“数据库全部完成 → 后端全部完成 → 前端全部完成”横向拆分。每个 Slice 尽量可运行、可验证、可提交、可回退。

只有复杂 Release 才增加 Phase；不要为了流程制造层级。

## Task Handoff Contract (统一任务派发契约)

每个 Task 向执行 Agent 派发时，必须封装为标准的 Task Handoff Contract：

```text
- Task ID: <TASK-ID>
- Slice: <SLICE-ID>
- Goal: <明确单一的可验证目标>
- Related REQ/AC: <关联 SPEC 中的 REQ 与 AC>
- Test Seam: <SEAM-ID 外部可观察接缝>
- Dependencies: <前置任务依赖，必须在 Ready Frontier 状态下派发>
- Allowed Modification Scope: <精确限定允许修改的文件或目录列表>
- Explicit Out of Scope: <明确禁止改动的文件或外部模块>
- Relevant Context: <Minimal Context Pack: 接口契约、类型定义或现有测试>
- Risk Tags: <None / Auth / Security / Schema / Breaking>
- Required Verification: <运行命令、预期输出或测试文件>
- Expected Outputs: <实现代码、测试用例、新鲜运行证据>
- Recovery Point: <稳定的 Git Commit 或恢复标记>
```

## Task Loop 与 TDD 显式调用

```text
Select Next Task (from Ready Frontier)
→ Assemble Task Handoff Contract
→ Confirm frozen scope and applicable Gates
→ Inspect existing code/tests
→ [显式调用 superpowers:test-driven-development / 内置TDD] failing test
→ minimal implementation
→ task verification (all green)
→ inspect diff (no out-of-scope changes)
→ review when required
→ 按更新矩阵同步受影响文档
→ checkpoint/commit when available
→ Next Task
```

Task Loop 中的 checkpoint/commit 使用上述 Lightweight Git Workflow。任务实现与完成声明所需验证仍按 Task contract 执行，但已经完成且仍适用的检查不因 Git 操作重复运行。

**【显式 TDD 注入】**：派发任何 Feature、Bug、Refactor 任务时，必须在提示语中显式注入 **`**REQUIRED SUB-SKILL:** Use superpowers:test-driven-development`**。若环境未安装该外部技能，则严格执行内置原生 TDD 协议（编写失败用例 ➔ 最小实现 ➔ 验证全绿 ➔ 重构），严禁跳过红绿循环直接写业务代码。

Task 完成前至少确认：

- 改动严格在 Allowed Modification Scope 内，无越界代码。
- 对应 Test Seam 产生新鲜的成功输出（fresh output）。
- diff 不包含无关重构或用户现有改动。
- PROGRESS 记录 evidence、稳定点和 Next Task。
- 已按 [文档同步检查点](artifacts.md#文档同步检查点) 同步受影响文档，避免只更新 PROGRESS 而遗漏已有计划、验证记录或当前架构。

## Bug Workflow 与根因排查

```text
BUG REPORT
→ reproduce
→ gather evidence
→ root cause investigation (gstack:investigate / superpowers:systematic-debugging)
→ regression test
→ fix
→ verify
→ update BUG/related docs
→ checkpoint/commit
```

**【显式排障调用】**：使用 `gstack:investigate` 或 `superpowers:systematic-debugging`（遵循调试铁律：不定位根因绝不盲目改代码，深入追踪调用链与数据流）。复杂 Bug 可从 `assets/templates/BUG.md` 建立记录；简单 Bug 沿用现有 tracker，不强制新文件。

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
6. 路由到 systematic debugging 或 `gstack:investigate`；必要时回到 DESIGN 或 PLAN。

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

Task 开始、完成、阻塞或触发 Gate/Circuit Breaker 时，同一轮更新 PROGRESS；摘要只提最重要的事实，明细在任务、证据或适用时的风险表中维护：

- Current Release/State/Status。
- Current Slice/Task。
- Last Stable Commit/artifact。
- Completed/In Progress。
- 新 evidence、known bugs、blockers、open decisions。
- Next Task。

PROGRESS 不复制 SPEC、TECH_DESIGN 或完整日志，只链接 owner。

任务状态或证据变化时，同一轮按 [更新矩阵](artifacts.md#更新矩阵) 同步相关事实源；需要保存本轮改动时，将这些必要同步纳入本次范围。仅执行普通 Git 请求仍走 Lightweight Git Workflow，不额外补齐文档。

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
