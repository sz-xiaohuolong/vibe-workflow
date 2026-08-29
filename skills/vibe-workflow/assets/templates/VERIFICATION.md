# Release Verification — <Release ID>

## Control

- Release: `<Release ID>`
- Effective SPEC: `<SPEC 路径>`
- Quality Profile: `Standard`
- Verification Status: `UNVERIFIED`
- Shipping Authorization: `NOT_REQUESTED`
- Verified At: `未验证`

## Requirement Evidence Matrix

| REQ | AC | Test/Flow | Command/Steps | Result | Evidence | Commit/Artifact | Notes |
|---|---|---|---|---|---|---|---|
| REQ-001 | AC-001 | `未关联` | `未运行` | `UNVERIFIED` | `无` | `无` | `待验证` |

## Automated Checks

| Check | Command | Time | Exit/Failures | Result | Evidence |
|---|---|---|---|---|---|
| Tests | `未确认` | `未运行` | `未知` | `UNVERIFIED` | `无` |
| Lint/Typecheck | `未确认` | `未运行` | `未知` | `UNVERIFIED` | `无` |
| Build | `未确认` | `未运行` | `未知` | `UNVERIFIED` | `无` |

## Critical User Flows

| Flow | Environment | Expected | Actual | Result | Evidence |
|---|---|---|---|---|---|
| `待定义` | `未确认` | `待确认` | `未运行` | `UNVERIFIED` | `无` |

## Risk-specific Checks

- Migration: `不适用/未验证`
- Security/Permissions: `不适用/未验证`
- Performance: `不适用/未验证`
- Observability/Recovery: `不适用/未验证`

## Traceability and Docs Consistency

- All REQ/AC covered: `No`
- TECH_DESIGN reflects current architecture: `未验证`
- PROGRESS reflects actual state: `未验证`
- Released artifacts remain sealed: `未验证`

## Unverified / Blocked Items

- 存在未验证内容；当前不能标记 `VERIFIED` 或 `READY_TO_SHIP`。

## Final Decision

- Ready To Ship: `No`
- Evidence-based Reason: `验证尚未完成`
- Human Shipping Decision: `PENDING/NOT_REQUESTED`

Shipping Authorization 不改变 Verification Status；风险接受不能把未知结果写成通过。
