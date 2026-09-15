# Context Governor & Attention Shield

> How Vibe Workflow eliminates hallucination, prevents token bloat, and guarantees cross-session continuity.

---

## 1. Minimal Sufficient Context

The Context Governor enforces the principle that **more context does not equal better results**. Injecting outdated decisions, dead branches, or verbose historical releases degrades LLM reasoning.

### The Three Context Packs

1. **Bootstrap Pack (Initial Repo Takeover)**:
   - Reads: Root `AGENTS.md`, `README.md`, package manifests, build/test scripts, and `docs/vibe/PROJECT.md`.
   - Purpose: Maps the engineering landscape without reading full source code into memory.

2. **Resume Pack (Cross-Session Rehydration)**:
   - Reads: `AGENTS.md`, `PROJECT.md`, `PROGRESS.md`, current release's `PROJECT_BRIEF.md`, and current `SPEC.md`.
   - Action: Audits git log and test suite to verify whether repository facts match the last logged state in `PROGRESS.md`. Discrepancies are reported before work begins.

3. **Task Context Pack (Single Task Execution)**:
   - Reads strictly:
     - Target REQ / AC clauses from `SPEC.md`
     - Relevant section of approved `PROPOSED_DESIGN.md` (if applicable)
     - Assigned task block from `IMPLEMENTATION_PLAN.md`
     - Directly affected source files and unit tests
   - **Explicitly Excluded**: Full git log history, previous release directories, unrelated module tests, and dependency folders.
