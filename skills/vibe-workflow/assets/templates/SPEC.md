# Effective SPEC — <Release ID>

| 范围 | 冻结的产品事实 | 待澄清/边界 | 验收入口 |
|---|---|---|---|
| Release `<ID>` | `<目标用户与核心行为>` | `<范围外事项或待澄清>` | `<REQ/AC 链接>` |
| 核心能力 | `<用户可观察的结果>` | `<关键条件或无>` | `<对应 AC>` |
| 异常与边界 | `<失败时的可见行为>` | `<尚未确认的条件或无>` | `<对应 ERR/BND>` |

## Control

- Release: `<Release ID>`
- Requirement Version: `<版本>`
- Requirement Baseline: `<PROJECT_BRIEF 路径>`
- Status: `DRAFT`

## Product Behaviors

### REQ-001 — <行为名称>

- Source: `<PROJECT_BRIEF 章节>`
- Actors: `待澄清`
- Preconditions: `待澄清`
- Trigger: `待澄清`
- Expected Behavior: `待澄清`
- Resulting State: `待澄清`
- Explicit Non-goals: `待澄清`

#### Acceptance Criteria

- AC-001: 待澄清为可观察、可判定的结果。

#### Error Scenarios

- ERR-001: 待澄清触发条件、用户可见结果和恢复方式。

#### Boundary Conditions

- BND-001: 待澄清输入、容量、权限、平台或状态边界。

## User Flows

```text
待澄清入口 → 状态 → 操作 → 结果/错误恢复
```

## State Transitions

| Current State | Event | Guard | Next State | User-visible Result |
|---|---|---|---|---|
| `待澄清` | `待澄清` | `待澄清` | `待澄清` | `待澄清` |

## Requirement Matrix

| REQ | AC | Source | Design | Task | Test | Status |
|---|---|---|---|---|---|---|
| REQ-001 | AC-001 | `<Brief section>` | `未关联` | `未关联` | `未关联` | `UNVERIFIED` |

## Limitations & Disclaimers

- `<仅解释一次适用范围和已知限制；没有则写“无”或删除本节>`

SPEC 可以工程化表达冻结需求，但不得创造 PROJECT_BRIEF 中没有的新产品能力；测试执行结果与切片进度只记录在 PROGRESS/VERIFICATION，不在本表同步。
