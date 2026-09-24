# Progress

| 范围 | 当前事实 | 阻塞/未验证 | 下一步 |
|---|---|---|---|
| Release `<ID>` | `<State / Operational Status>` | `<最重要阻塞或无>` | `<下一 Gate>` |
| Slice `<ID>` / Task `<ID>` | `<已验证/已实现待验证/已通过 POC/进行中>` | `<当前缺口或无>` | `<一个动作>` |
| 验证 | `<本轮检查与结果；未运行则写未运行>` | `<未覆盖的 AC 或无>` | `<检查或复核入口>` |

## Current Position

- Current Release: `<Release ID 或未建立>`
- Current Requirement Baseline: `<路径或未建立>`
- Current Workflow State: `未建立/待核验`
- Operational Status: `待核验`
- Current Phase: `None/待核验`
- Current Slice: `None/待核验`
- Current Task: `None/待核验`
- Last Stable Commit/Artifact: `未建立/待核验`
- Last Updated: `<日期>`

## Completed Tasks

- 仅列 Task Delivery Status 为 `VERIFIED` 且有 fresh evidence 的任务；当前无。

## In Progress

| Task/REQ | Delivery Status | 实现或 POC 范围 | 当前证据 | 待验证/下一步 |
|---|---|---|---|---|
| `待核验` | `NOT_STARTED/IN_PROGRESS/IMPLEMENTED_UNVERIFIED/POC_VALIDATED/BLOCKED` | `待核验` | `未记录` | `待核验` |

## Slice 进度

| Slice | 状态 | 证据/阻塞 | 下一步 |
|---|---|---|---|
| `SLICE-01` | `待核验` | `未记录` | `待核验` |

## Verification Evidence

| Scope | Command/Flow | Result | Evidence | Time |
|---|---|---|---|---|
| `待核验` | `未运行/待核验` | `UNVERIFIED` | `未记录` | `未记录` |

## Known Bugs

- 待核验

## Blockers

- Requirement/执行状态待核验。

## Open Decisions

- 待核验

## Debug Snapshot

- Triggered: `待核验`
- Symptom/Evidence/Attempts: `待核验`

## Next Task

- 核验 Requirement Gate 和仓库当前事实。

## Limitations & Disclaimers

- `<只写一次需要解释的适用范围/限制；没有则写“无”或删除本节>`

PROGRESS 只记录当前执行状态并链接事实 owner；不复制 SPEC、TECH_DESIGN 或完整日志。阻塞/未验证事实仍须出现在摘要表和对应状态行，不得只放在本节。

`POC_VALIDATED` 与 `IMPLEMENTED_UNVERIFIED` 均不能进入 Completed；Task 进度不替代 Release Verification Status 或 Shipping Authorization。
