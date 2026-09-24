# Release 生命周期

## 何时读取

开始新项目、新 Release、恢复状态、处理 Requirement Change、决定状态回退或封存 Release 时读取本文件。

## Project 与 Release

Project 是长期维护对象；Release 是一次完整的需求冻结、SPEC、设计、计划、实现、验证和发布周期。不要把 v0.2 的需求继续追加到 v0.1 的已发布 SPEC。

```text
Project
├── v0.1  RELEASED
├── v0.2  RELEASED
└── v0.3  BUILDING
```

对已发布产品的 Bug 修复也创建新的 patch Release 或后续 Release；旧 Release 只保存当时事实。

Release 是对外有意义的范围/验收/发布边界；Slice 是同一 Release 中可运行、可验证的执行切片，Task 是更小的工作项。`R1-S1`、`R1-S2` 这样的短周期切片编号不能仅因完成一天工作就被视为新 Release。新 Release 需有独立的范围基线或真实发布/版本边界；在当前已冻结范围内推进 S1→S2，只更新当前 Release 的计划/进度/验证记录，不创建 `releases/R1-S2/`。若切片引入新的产品范围，先过 Requirement Change Gate；若当前 Release 已封存，按下述新 Release 流程处理。

## Workflow State Contract

| State | 进入条件 | 主要证据 | 允许的下一状态 |
|---|---|---|---|
| `REQUIREMENTS_FROZEN` | Requirement Gate 全部满足 | PROJECT_BRIEF、明确验收 | `SPECIFIED` |
| `SPECIFIED` | SPEC 只展开冻结需求且可执行 | REQ/AC、行为、边界、错误 | `DESIGNED` |
| `DESIGNED` | 目标技术方案支持 SPEC，必要决策获批 | release-scoped PROPOSED_DESIGN、DEC | `PLANNED` |
| `PLANNED` | Slice/Task/依赖/验证映射完整 | IMPLEMENTATION_PLAN | `BUILDING` |
| `BUILDING` | 在已批准范围内逐 Task 实现 | 代码、测试、PROGRESS | `VERIFYING` |
| `VERIFYING` | Task 完成，开始 Release 级证据检查 | tests/build/flows/traceability | `REVIEWING` 或回退 |
| `REVIEWING` | 验证证据可供独立检查 | review findings、修正记录 | `READY_TO_SHIP` 或回退 |
| `READY_TO_SHIP` | 所有适用 REQ/AC 有证据且无阻断问题 | VERIFICATION、review result | `RELEASED`，须 Shipping Gate |
| `RELEASED` | 人类授权发布动作且结果已记录 | tag/artifact/deployment result | 新 Release |

状态不能仅凭一句“阶段完成”推进。先检查进入条件和证据，再更新 PROGRESS。

`TECH_DESIGN.md` 是由实现证据核验的当前架构，不是未实现目标方案。新 Release 在 `DESIGNED` 阶段使用 release-scoped `PROPOSED_DESIGN.md`；实现并验证后才把成立部分合并进 living TECH_DESIGN。

## Operational Status

Workflow State 之外单独记录：

- `ACTIVE`：可以在当前 State 内继续。
- `WAITING_HUMAN`：正在等待 Human Gate 决定。
- `BLOCKED`：缺少权限、环境、输入或外部条件。
- `REPLAN_REQUIRED`：现有方案/计划不再可信，禁止继续局部 patch。

Operational Status 不会自动改变 Workflow State。例如 BUILDING 中发生 Requirement Change，可以保持 State 记录为 BUILDING，同时 Status 为 WAITING_HUMAN；获批后根据影响回退到 SPECIFIED、DESIGNED 或 PLANNED。

## Requirement Change 回退

获批变更后回退到最早被失效的状态：

| 影响 | 回退点 |
|---|---|
| 只改变任务顺序或内部实现 | `PLANNED` |
| 改变模块边界、公开接口或数据模型 | `DESIGNED` |
| 改变产品行为、范围、用户流程或验收 | `SPECIFIED`，先更新 baseline/effective SPEC |
| Requirement Gate 不再成立 | Requirement Clarification，重新达到 `REQUIREMENTS_FROZEN` |

不要机械重走未受影响阶段，但必须做 impact analysis 并更新所有失效链接。

## 新 Release

1. 选择新的 Release ID。
2. 以当前产品事实和本次新增/修改范围形成新的 PROJECT_BRIEF。
3. Requirement Gate 通过后创建该 Release 的完整 Effective SPEC。
4. 有目标架构变化时创建该 Release 的 PROPOSED_DESIGN；必要 Decision 获批后才能进入 DESIGNED。
5. `CHANGE.md` 只表达相对上一 Release 的差异；Agent 默认不靠叠加多个 delta 推导当前需求。
6. 更新 PROGRESS 的 Current Release、State、Status 和 Next Task。

## 封存

`RELEASED` 后：

- 不静默修改 PROJECT_BRIEF、SPEC、PROPOSED_DESIGN、PLAN 或 VERIFICATION。
- 措辞歧义使用有日期、有理由、有链接的勘误记录。
- 当前行为改变时写入新 Release 的 Effective SPEC。
- 当前架构写入 Living TECH_DESIGN；历史原因写入 DEC。

封存不是禁止纠错，而是禁止把今天的事实追溯覆盖为过去的事实。

## 恢复会话

新会话从 PROGRESS 开始，但不盲信它：

1. 读取 Current Release、State、Status、Slice、Task 和 Last Stable Commit。
2. 用 Git、代码、测试和关联 artifacts 核验。
3. 若状态过期，记录证据并修正 PROGRESS。
4. 若聊天口述冲突，向用户指出；不静默回退或前进。

恢复完成后只组装当前 Task Context Pack。
