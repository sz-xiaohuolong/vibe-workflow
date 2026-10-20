# Release Verification — <Release ID>

## Control

- Release: `<Release ID>`
- Effective PRD: `<PRD 路径>`
- Quality Profile: `Standard`
- Verification Status: `UNVERIFIED`
- Shipping Authorization: `NOT_REQUESTED`
- Verified At: `未验证`

## Test Matrix (测试策略与环境配置)

- Project Type: `<Web / API / CLI / Desktop / Mobile>`
- Primary Verification Harness: `<gstack:qa-only / gstack:browse / Playwright / 原生测试套件>`
- Evidence Policy: `summary；必要时 targeted，按实际项目规则覆盖`
- Evidence Location: `<CI 运行/既有记录；确需原始文件时 .evidence/<Release ID>/>`
- Verification Budget: `<本次声明、最小检查集合、升级条件>`
- Reused Evidence: `<运行 ID、输入/环境一致性依据；无则填无>`

## Requirement Evidence Matrix

| REQ | AC | Test Seam | Task Delivery Status | Test/Flow | Command/Steps | Result | Evidence（摘要/CI/.evidence） | Commit/Artifact | Notes |
|---|---|---|---|---|---|---|---|---|---|
| REQ-001 | AC-001 | `SEAM-001` | `NOT_STARTED/IMPLEMENTED_UNVERIFIED/POC_VALIDATED/VERIFIED` | `未关联` | `未运行` | `UNVERIFIED` | `无` | `无` | `待验证` |

删除不适用的占位行；同一份证据可支持多项 AC，不按行重复执行。原始大文件不内嵌，保留策略见实际项目规则入口。

## Automated Checks

| Check | Command | Time | Exit/Failures | Result | Evidence |
|---|---|---|---|---|---|
| Tests | `未确认` | `未运行` | `未知` | `UNVERIFIED` | `无` |
| Lint/Typecheck | `未确认` | `未运行` | `未知` | `UNVERIFIED` | `无` |
| Build | `未确认` | `未运行` | `未知` | `UNVERIFIED` | `无` |

## Real Environment Evidence & Critical User Flows

| Flow / Test Seam | Environment | Expected | Actual | Result | Evidence (Console/Network/Screenshot) |
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
POC 证据和已写代码可记录在矩阵中，但不能代替正式 AC 的通过证据。
