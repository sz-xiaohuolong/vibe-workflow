# Quality、Risk、Verification、Review 与 Release

## 何时读取

选择 QA 强度、处理高风险模块、验证 Task/Release、准备评审、声明完成或执行 Shipping Gate 时读取本文件。

## Quality Profile

优先使用项目已声明的 profile；没有时：明确 throwaway prototype 可用 Prototype，普通项目默认 Standard，面向真实用户/生产或高风险系统使用 Production。profile 显著改变成本或交付承诺时向用户展示建议和影响。

| Profile | 最低检查 |
|---|---|
| Prototype | build/run、核心测试、关键人工流程、已知限制 |
| Standard | unit/integration、lint/typecheck、build、回归、基本安全、关键用户流程 |
| Production | Standard + 深入安全、迁移、性能（相关时）、observability、部署/恢复验证 |

不要用 Production 清单压在普通 UI Tiny Task 上；也不要以 Prototype 标签跳过当前核心行为验证。

## Risk Tags

出现以下标签时提高验证强度，并读取项目相应安全/领域规则：

```text
AUTH  PAYMENT  DATABASE  FILE_SYSTEM  USER_INPUT
NETWORK_API  SECRETS  PERMISSIONS  PUBLIC_ENDPOINT
MIGRATION  DESTRUCTIVE_OPERATION
```

至少关注 Secret handling、input validation、AuthN/AuthZ、injection、data exposure、sensitive logs、destructive target 和 recovery。

风险检查只覆盖实际受影响范围；不要求所有普通 Task 做完整安全审计。

## Task Verification

### Task Delivery Status

进度状态只描述当前 Task/功能的交付程度，独立于 Release 的 `Verification Status` 和 `Shipping Authorization`：

| 状态 | 可写入条件 | 不得推断 |
|---|---|---|
| `NOT_STARTED` / `IN_PROGRESS` / `BLOCKED` | 实际执行位置或阻塞证据 | 已实现或已验证 |
| `IMPLEMENTED_UNVERIFIED`（已实现待验证） | 代码或 artifact 已存在，但适用检查未运行、已过期或未覆盖 AC | `DONE`、`VERIFIED` |
| `POC_VALIDATED`（已通过 POC） | 有明确范围内的概念可行性演示或探针证据 | 正式功能已实现、Release AC 已通过 |
| `VERIFIED`（已验证） | 当前实现的适用 AC、自动化检查和受影响运行路径均有 fresh evidence；不适用项有理由 | Shipping Authorization 已获批 |

POC 是独立的局部证据；从 POC 转正式交付时，先确认正式需求、实现边界和 AC，再运行正式环境所需验证。仅有 POC 的 REQ/AC 仍为 `UNVERIFIED`。代码已写但 CI 将来才运行时保持 `IMPLEMENTED_UNVERIFIED`。一个 Release 的 Verification Status 由其全部适用 REQ/AC 和 Release 检查决定，不能由单个 Task 状态自动晋级。

根据项目运行能证明当前 Task 的最小充分检查：

- relevant tests；
- lint/typecheck/compile/build 中适用项；
- 受影响的用户行为或接口；
- migration/permission/security checks（适用时）；
- diff inspection；
- 关联 REQ/AC 的 evidence。

使用 fresh output。旧运行、CI 将来会跑、页面看起来正常、代码已存在或另一个 Agent 报告成功都不是当前证据。

Task evidence 记录命令/步骤、时间、结果、环境/版本、失败数、限制和 artifact path；不要写未运行的检查。

## Release Verification

Release 进入 REVIEWING 前逐项验证：

1. 所有适用 REQ/AC。
2. 完整 tests、build、lint/typecheck。
3. regression 和关键用户流程。
4. migration、security、performance、observability（适用时）。
5. docs consistency。
6. Requirement Traceability。
7. 未验证部分、环境限制和已知风险。

VERIFICATION 以 REQ/AC 为行，至少包含 evidence、result、commit/artifact 和 notes。测试全绿不代表未关联的 AC 已验证。

## Completion Claim Gate

任何 `DONE`、`FIXED`、`VERIFIED`、`READY_TO_SHIP`、`tests pass`、`build succeeds` 前：

1. 明确哪个命令或用户路径证明该声明。
2. 在当前工作状态运行完整检查。
3. 阅读输出、exit code 和失败数。
4. 检查 evidence 是否覆盖声明的范围和 REQ/AC。
5. 只有全部支持时才作声明，并附 evidence 摘要。

使用 `superpowers:verification-before-completion`。若能力缺失，仍执行同一 evidence gate，不假装调用。

## Verification 与 Authorization

分别记录：

```text
Verification Status: VERIFIED | PARTIAL | UNVERIFIED | FAILED
Shipping Authorization: NOT_REQUESTED | PENDING | APPROVED | DENIED
```

约束：

- `APPROVED` 不改变 Verification Status。
- 缺少适用 REQ/AC evidence 时不能标 `READY_TO_SHIP`。
- 风险接受记录可以说明人类决定，但不能把未知写成通过。
- Agent 不以不同措辞暗示未证明的成功。

## Review

重要 Task/Feature 和合并前使用 `superpowers:requesting-code-review` 或等价独立 Review。Reviewer 获得批准的 requirement/design、精确 diff 范围和 verification evidence，不获得整个聊天历史或预期结论。

Review 检查：

- spec/AC compliance；
- scope creep；
- correctness、security、compatibility；
- missing tests/evidence；
- unrelated changes；
- artifact consistency。

Critical/Important 问题解决并重新验证后才能推进。对错误 review 意见用技术证据回应，不盲从。

## READY_TO_SHIP Gate

必须同时满足：

- 当前 Release 的所有适用 REQ/AC 有结果。
- 必需 checks 有 fresh evidence。
- 无未解决的阻断 review finding。
- migration/recovery/security 证据符合 profile 和 risk。
- docs/traceability 一致。
- Verification Status 为 `VERIFIED`。

`READY_TO_SHIP` 仍不授权任何外部动作。

## Shipping Gate

Push、PR、publish、deploy、release 或不可逆外部副作用需要明确的人类授权。授权前可以准备命令、变更摘要、release notes 和 recovery plan，但不执行动作。

授权不是唯一前置条件：

- `publish/deploy/release` 仅可从 `READY_TO_SHIP` 执行；V0.2 不提供 emergency release 旁路。
- push/PR 可在明确授权后执行协作动作，但要保留真实 Verification Status，不得声称 Release 已验证或可发布。
- 若人类要求发布 `UNVERIFIED/PARTIAL/BLOCKED` 的 Release，拒绝该发布动作并记录缺口；风险接受不改变状态事实。

满足适用状态前置条件并获得授权后：

1. 再核验精确 target、branch/artifact/environment。
2. 执行获批动作，不扩大范围。
3. 记录实际 result、版本/tag/URL 和失败恢复信息。
4. 成功后进入 RELEASED；失败则保持真实状态并调查。

## Release 封存检查

进入 RELEASED 后确认：

- PROJECT_BRIEF/SPEC/PROPOSED_DESIGN/PLAN/VERIFICATION 被视为历史快照。
- Living PROJECT/TECH_DESIGN/PROGRESS 反映当前事实。
- 重大变化有 DEC。
- 后续维护创建新 Release，而不是追加旧 SPEC。
