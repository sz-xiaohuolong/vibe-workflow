# Implementation Plan — <Release ID>

## Control

- Requirement Baseline: `<PROJECT_BRIEF 路径>`
- Effective SPEC: `<SPEC 路径>`
- Current Architecture: `<TECH_DESIGN 路径>`
- Proposed Design: `<当前 Release PROPOSED_DESIGN 路径或不适用>`
- Status: `DRAFT`

## Global Constraints

- 只实现当前 Requirement Version 的冻结范围。
- 不跨越未完成的 Human Gate。
- 每个 Task 必须有验证和可恢复稳定点。

## Slice Map

| Slice | Business Loop | REQ/AC | Dependencies | Exit Evidence | Status |
|---|---|---|---|---|---|
| SLICE-01 | `待定义` | `未关联` | `无/待确认` | `待定义` | `NOT_STARTED` |

## Task Dependency Graph & Ready Frontier

```text
[TASK-001] (Ready Frontier: 无依赖可立即就绪)
    ↓ (完成交付)
[TASK-002] (Blocked: 依赖 TASK-001)
```

- **Ready Frontier (当前可并行调度任务)**: `TASK-001`
- **Blocked Tasks (等待前置依赖任务)**: `待定义`

## Tasks (Task Handoff Contracts)

### TASK-001 — <任务名称>

- Slice: `SLICE-01`
- Goal: `待定义一个可验证交付`
- REQ/AC: `未关联`
- Test Seam: `未关联 / 待定义 SEAM ID`
- Dependencies: `无/待确认`
- Ready Status: `READY`
- Allowed Modification Scope: `待定义文件/模块`
- Explicit Out of Scope: `待定义`
- Relevant Context: `待补充核心上下文与设计契约`
- Risk Tags: `None/待确认`
- Planned Test/Evidence: `待定义失败用例与验证命令`
- Cross-module Impact: `不适用/写入入口、读取方、传播、刷新/恢复与失败路径待确认`
- Checked Unaffected Modules: `不适用/待确认`
- Expected Outputs: `代码实现、测试用例、测试证据`
- Recovery Point: `待定义`
- Status: `NOT_STARTED`

## Integration and Review Gates

- Integration Order: `待定义`
- Independent Review: `待定义`
- Release Verification Handoff: `待定义`

详细执行计划可由 `superpowers:writing-plans` 生成，但必须保留上述 REQ/AC、Gate、evidence 和 recovery 映射。
