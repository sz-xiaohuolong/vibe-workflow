# Vibe Workflow Lifecycle & State Machine

> Detailed specification of the Release-centric state machine, operational statuses, and invalidation rewind contracts.

---

## 1. Dual-State Architecture

Vibe Workflow decouples high-level engineering evolution from real-time execution health:

1. **Workflow State**: Represents progressive advancement across engineering phases.
2. **Operational Status**: Represents immediate working status within any given Workflow State.

### Workflow State Contracts

```text
REQUIREMENTS_FROZEN
  └──> SPECIFIED
        └──> DESIGNED
              └──> PLANNED
                    └──> BUILDING
                          └──> VERIFYING
                                └──> REVIEWING
                                      └──> READY_TO_SHIP
                                            └──> RELEASED
```

| State | Entry Condition | Primary Evidence | Permitted Next States |
|---|---|---|---|
| `REQUIREMENTS_FROZEN` | Entry Gate fully satisfied (Frozen, Zero open Qs, Testable ACs) | `PROJECT_BRIEF.md` | `SPECIFIED` |
| `SPECIFIED` | Requirements formalized into unambiguous REQ/AC and error states | `SPEC.md` (Effective SPEC) | `DESIGNED` |
| `DESIGNED` | Technical architecture defined, critical decisions approved | `PROPOSED_DESIGN.md`, `DEC-xxx.md` | `PLANNED` |
| `PLANNED` | Vertical slices, tasks, dependencies, and test mappings established | `IMPLEMENTATION_PLAN.md` | `BUILDING` |
| `BUILDING` | Tasks implemented iteratively within approved boundaries | Code commits, tests, `PROGRESS.md` | `VERIFYING` |
| `VERIFYING` | Release-level end-to-end verification executed | Test suite, lint/build logs, traceability table | `REVIEWING`, or rewind |
| `REVIEWING` | Verification evidence submitted for peer or automated review | Code review findings, audit log | `READY_TO_SHIP`, or rewind |
| `READY_TO_SHIP` | All applicable REQ/AC proven by fresh evidence; zero blockers | `VERIFICATION.md` | `RELEASED` (Requires Shipping Gate) |
| `RELEASED` | Human explicitly authorizes external publish/deploy action | Tag, deployment URL, release notes | Next Release |

---

## 2. Operational Statuses

- **`ACTIVE`**: Work is progressing normally within the current Workflow State.
- **`WAITING_HUMAN`**: Execution paused at a Human Decision Gate (e.g. Scope change, Schema migration, API break).
- **`BLOCKED`**: Progress prevented by external dependencies, environment issues, or missing credentials.
- **`REPLAN_REQUIRED`**: Circuit Breaker triggered. Current assumptions or plan are discredited. Local patching is forbidden.

---

## 3. Requirement Change Rewind Protocol

When an approved requirement change alters established facts, the workflow rewinds to the earliest invalidated state:

```text
Requirement Change Approved
  ├── Changes only task order or private code ──> Rewind to PLANNED
  ├── Changes module boundaries or data model  ──> Rewind to DESIGNED
  └── Changes product behaviors or user flows  ──> Rewind to SPECIFIED
```
