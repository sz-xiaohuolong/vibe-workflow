# Progress

| 范围 | 当前事实 | 阻塞/未验证 | 下一步 |
|---|---|---|---|
| Release `<ID>` | `Workflow State: <值>；Operational Status: <值>` | `<最重要阻塞或无>` | `<下一 Gate>` |
| Slice `<ID>` / Task `<ID>` | `<已验证/已实现待验证/已通过 POC/进行中>` | `<当前缺口或无>` | `<一个动作>` |
| 验证 | `<本轮检查与结果；未运行则写未运行>` | `<未覆盖的 AC 或无>` | `<检查或复核入口>` |

## 定位信息

- Current Requirement Baseline: `<路径或未建立>`
- Last Stable Commit/Artifact: `未建立/待核验`
- Last Updated: `<日期>`

## 任务状态

| Task/REQ | Delivery Status | 实现或 POC 范围 | 当前证据 | 待验证动作 |
|---|---|---|---|---|
| `待核验` | `NOT_STARTED/IN_PROGRESS/IMPLEMENTED_UNVERIFIED/POC_VALIDATED/VERIFIED/BLOCKED` | `待核验` | `未记录` | `待核验` |

## Slice 进度

- [ ] `SLICE-01`：`待核验`；证据/阻塞：`未记录`；下一步：`待核验`。

## Verification Evidence

| Scope | Command/Flow | Result | Evidence | Time |
|---|---|---|---|---|
| `待核验` | `未运行/待核验` | `UNVERIFIED` | `未记录` | `未记录` |

## 风险、阻塞与待决定

| 类型 | 事实或链接 | 负责人/下一动作 |
|---|---|---|
| `Bug / 阻塞 / Decision` | `<仅填适用项，并链接 BUG/DEC 或证据>` | `<待确认>` |

## Debug Snapshot

- Triggered: `待核验`
- Symptom/Evidence/Attempts: `待核验`

<!-- 摘要是导航，不在后文重复写相同状态；详细 Task/证据以对应表格为唯一明细。风险/阻塞/待决定可有多条，摘要只摘最重要一条。POC_VALIDATED 与 IMPLEMENTED_UNVERIFIED 不能标完成；Task 状态不替代 Release Verification 或 Shipping Authorization。删除不适用的空章节。 -->

## Limitations & Disclaimers

- `<只写一次需要解释的适用范围/限制；没有则写“无”或删除本节>`
