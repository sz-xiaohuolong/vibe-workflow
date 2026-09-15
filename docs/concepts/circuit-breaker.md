# Circuit Breaker & Recovery Protocol

> How Vibe Workflow prevents catastrophic agent retry loops, cascading regressions, and code degradation.

---

## 1. When Does the Circuit Breaker Trip?

An agent must immediately halt implementation and trip the Circuit Breaker if ANY of the following conditions occur:

1. **3 Consecutive Failures**: The same bug, test failure, or build error fails across 3 consecutive attempts.
2. **Cascading Regressions**: Fixing error A breaks previously passing test B or C.
3. **Falsified Architectural Assumptions**: Hard runtime evidence disproves a foundational design assumption.
4. **Uncontrolled Blast Radius**: What began as a 10-line bugfix begins sprawling across unrelated subsystems.

---

## 2. The Circuit Breaker Protocol

When tripped, the agent must execute the following sequence:

```text
STOP PATCHING
  ├── 1. Preserve or restore Last Known Good State (safe commit / stash / worktree)
  ├── 2. Record a Debug Snapshot in PROGRESS.md:
  │       - Observed symptom and reproducible command
  │       - Root cause hypotheses explored and failed attempts
  │       - Clean diff of attempted changes
  ├── 3. Set Operational Status = REPLAN_REQUIRED
  ├── 4. Flush conversation context (spawn clean context window)
  └── 5. Route to systematic debugging or architectural redesign
```

> **Zero Tolerance**: Prompts like "try one more parameter" or "tweak this timeout" are forbidden once the circuit breaker has tripped. Only fresh diagnostic evidence or a newly approved design plan may reset execution status to `ACTIVE`.
