# Context Governor & Attention Shield

> How Vibe Workflow eliminates hallucination, prevents token bloat, and guarantees cross-session continuity.

---

## 1. Minimal Sufficient Context

The Context Governor enforces the principle that **more context does not equal better results**. Injecting outdated decisions, dead branches, or verbose historical releases degrades LLM reasoning.

### The Three Context Packs

1. **Bootstrap Pack (Initial Repo Takeover)**:
   - 读取：按[统一入口定位](../../skills/vibe-workflow/references/init.md#规则入口定位)找到的 `AGENT.md` 或 `AGENTS.md`、宿主适用规则、README、构建/测试入口与已有唯一文档地图。文件名兼容不保证宿主自动加载，必要时显式读取。
   - Purpose: Maps the engineering landscape without reading full source code into memory.

2. **Resume Pack (Cross-Session Rehydration)**:
   - 读取：同一实际规则入口、唯一文档地图、真实进度路径与当前任务相关范围、设计、代码和证据；Tiny 与普通 Git 不遍历全部 Release 文档。
   - Action: Audits git log and test suite to verify whether repository facts match the last logged state in `PROGRESS.md`. Discrepancies are reported before work begins.

3. **Task Context Pack (Single Task Execution)**:
   - Reads strictly:
     - Target REQ / AC clauses from `SPEC.md`
     - Relevant section of approved `PROPOSED_DESIGN.md` (if applicable)
     - Assigned task block from `IMPLEMENTATION_PLAN.md`
     - Directly affected source files and unit tests
   - **Explicitly Excluded**: Full git log history, previous release directories, unrelated module tests, and dependency folders.
