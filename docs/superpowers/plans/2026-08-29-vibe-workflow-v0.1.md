# Vibe Workflow V0.1 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 创建一个经过行为 baseline、压力复测和静态验证的中文 `vibe-workflow` 生命周期 Orchestrator Skill。

**Architecture:** `SKILL.md` 是精简 Router、状态机和全局不变量入口；七个 references 按场景条件加载；`assets/templates/` 提供复制到目标项目的持久化文档骨架；`tests/` 保存行为场景、评分标准及 RED/GREEN 证据。V0.1 不创建运行时脚本。

**Tech Stack:** Markdown、YAML、Codex Skill Creator validator、Agent Skills specification、fresh-context subagent behavioral tests。

**Spec:** `docs/superpowers/specs/2026-08-29-vibe-workflow-design.md`

## Global Constraints

- Skill 正文、references、模板和测试材料使用中文。
- frontmatter key、状态枚举、文件名、Requirement ID 与外部 Skill 名保留英文。
- 在完成无 Skill baseline 之前不得创建 `SKILL.md`、references 或模板。
- `description` 只描述触发条件，以 `Use when...` 开头，不摘要工作流。
- 自动发现保持默认开启；不设置 explicit-only policy。
- 不复制 TDD、调试、代码评审或 worktree Skill 的内部教程。
- 不执行 push、PR、publish、deploy 或 release。
- 所有完成声明必须基于本轮 fresh verification output。

---

### Task 1: 固化行为测试 contract

**Files:**
- Create: `tests/scenarios.md`
- Create: `tests/rubric.md`

**Interfaces:**
- Consumes: 已批准设计中的 10 个指定场景、额外边界与压力场景。
- Produces: 每个场景的输入、最小仓库事实、必须行为、禁止行为和可独立评分的 oracle。

- [ ] **Step 1: 写场景目录**

  写入用户指定的 10 个场景，并补充未冻结 open questions、Tiny+Auth、跨会话恢复、历史与当前事实冲突、截止期跳过验证、付费 API、Circuit Breaker 后继续尝试、共享 migration、traceability 缺口和外部 Skill 缺失场景。

- [ ] **Step 2: 写评分规则**

  每个场景使用 `PASS | PARTIAL | FAIL`，并分别评分 Route、Gate、Context、Artifacts、Authorization、Evidence。Constitution 失败直接判定该版本不可发布。

- [ ] **Step 3: 检查测试不泄露答案**

  测试给执行 Agent 的 prompt 只包含真实请求和最小仓库事实；oracle 仅提供给评估者。

### Task 2: RED baseline

**Files:**
- Create: `tests/results/baseline.md`

**Interfaces:**
- Consumes: `tests/scenarios.md` 中的无 Skill prompts。
- Produces: 原始回答摘要、逐字 rationalization、评分、重复失败模式和有效压力。

- [ ] **Step 1: 并行运行无 Skill 场景**

  将互相独立的场景分批交给 fresh-context subagents。明确禁止读取尚不存在的 `vibe-workflow`，要求它们作出实际决定而不是复述理论。

- [ ] **Step 2: 记录 RED evidence**

  把每个 FAIL/PARTIAL 的具体行为和原话写入 `tests/results/baseline.md`，不能只写“Agent 做错了”。

- [ ] **Step 3: 归类失败形式**

  区分纪律违规、输出形状错误、必填项遗漏和条件判断错误，分别选择 prohibition、positive contract、required slot 或 observable conditional。

### Task 3: 初始化标准 Skill 脚手架

**Files:**
- Create: `SKILL.md`
- Create: `agents/openai.yaml`
- Create directories: `references/`, `assets/`

**Interfaces:**
- Consumes: Skill Creator initializer 和 baseline 失败模式。
- Produces: 无 placeholder 的标准 Skill 根结构。

- [ ] **Step 1: 在临时目录运行 initializer**

  Run:

  ```bash
  python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/init_skill.py" vibe-workflow --path <temporary-parent> --resources references,assets --interface display_name="Vibe Workflow" --interface short_description="协调长期软件项目的版本、关卡与验证状态" --interface default_prompt="使用 $vibe-workflow 继续当前软件项目，并从仓库事实恢复正确状态。"
  ```

  Expected: 临时目录包含 `SKILL.md`、`agents/openai.yaml`、`references/` 和 `assets/`。

- [ ] **Step 2: 按 initializer 结构在工作区创建文件**

  使用 `apply_patch` 创建正式文件，不把临时 placeholder 或示例带入工作区。

### Task 4: 创建最小中文 Orchestrator

**Files:**
- Create: `SKILL.md`
- Create: `references/lifecycle.md`
- Create: `references/routing.md`
- Create: `references/artifacts.md`
- Create: `references/context.md`
- Create: `references/gates.md`
- Create: `references/execution.md`
- Create: `references/quality-and-release.md`
- Create: `agents/openai.yaml`

**Interfaces:**
- Consumes: baseline failure taxonomy、批准设计。
- Produces: 可自动发现、渐进加载、能阻止已观察失败的中文 Skill。

- [ ] **Step 1: 写 SKILL.md 入口**

  只包含 Constitution、工程入口 Gate、状态机、任务 Router、Human Gate 摘要、Circuit Breaker、外部 Skill 路由和每个 reference 的读取条件。加入 baseline 中真实出现的 rationalization counter 和 red flags。

- [ ] **Step 2: 写 lifecycle 与 routing references**

  `lifecycle.md` 定义 Release 状态、回退、Requirement Change 和 Resume；`routing.md` 定义类型×复杂度、Document Budget、Tiny intent 和风险覆盖规则。

- [ ] **Step 3: 写 artifacts 与 context references**

  `artifacts.md` 定义 Release/living artifacts、事实所有权和 traceability；`context.md` 定义 Bootstrap、Resume 和 Task Context Packs。

- [ ] **Step 4: 写 gates、execution、quality references**

  `gates.md` 定义 Product/Implementation 边界和 Change Proposal；`execution.md` 定义 Build Loop、Bug、Circuit Breaker、并行和 Learning Loop；`quality-and-release.md` 定义 QA profile、Risk tags、Task/Release verification、Review 和 Shipping Gate。

- [ ] **Step 5: 写 UI metadata**

  `agents/openai.yaml` 只包含 `display_name`、25–64 字符的 `short_description` 和显式提及 `$vibe-workflow` 的中文 `default_prompt`。

### Task 5: 创建中文项目模板

**Files:**
- Create: `assets/templates/PROJECT_BRIEF.md`
- Create: `assets/templates/PROJECT.md`
- Create: `assets/templates/CHANGE.md`
- Create: `assets/templates/SPEC.md`
- Create: `assets/templates/TECH_DESIGN.md`
- Create: `assets/templates/IMPLEMENTATION_PLAN.md`
- Create: `assets/templates/PROGRESS.md`
- Create: `assets/templates/DECISION.md`
- Create: `assets/templates/BUG.md`
- Create: `assets/templates/VERIFICATION.md`
- Create: `assets/templates/PROPOSED_DESIGN.md`（独立评审后补充，用于分离当前架构与未实现目标方案）

**Interfaces:**
- Consumes: artifacts reference 中的事实所有权和 required fields。
- Produces: 可复制到目标仓库、不会把未知事实伪装成已确认事实的中文模板。

- [ ] **Step 1: 创建 Requirement 与 Release 模板**

  `PROJECT_BRIEF.md` 必须含 Requirement Version、Requirement Status 和 Open Questions；`SPEC.md` 必须含 REQ/AC、状态、错误、边界和 non-goals；`CHANGE.md` 使用 Added/Changed/Removed/Fixed。

- [ ] **Step 2: 创建 Living docs 模板**

  `PROJECT.md` 含 Document Map；`TECH_DESIGN.md` 只描述当前架构；`PROGRESS.md` 含 Current Release、State、Status、Slice、Task、Last Stable Commit、Evidence、Blockers、Open Decisions 和 Next Task。

- [ ] **Step 3: 创建 Decision、Bug、Plan、Verification 模板**

  所有模板包含稳定 ID 和关联 REQ/AC；Verification 必须逐条回答 requirement，不能只给总括结论。

### Task 6: GREEN behavioral tests 与 wording micro-tests

**Files:**
- Create: `tests/results/v0.1.md`
- Modify: `SKILL.md` only when observed failures justify a change
- Modify: relevant `references/*.md` only when observed failures justify a change

**Interfaces:**
- Consumes: 完整候选 Skill 和 baseline prompts。
- Produces: 同场景复测、control/candidate wording 样本、新 rationalization 和修正规则。

- [ ] **Step 1: 运行五次以上高风险 wording micro-tests**

  对 freeze gate、scope creep、document budget 和 evidence claims 分别运行 no-guidance control 与候选 guidance。每次使用 fresh context，并人工阅读所有样本。

- [ ] **Step 2: 重放完整场景矩阵**

  fresh-context agents 必须读取 `$vibe-workflow` 的真实路径并作出实际决定。记录 PASS/PARTIAL/FAIL 和引用的规则。

- [ ] **Step 3: REFACTOR loopholes**

  对新 rationalization 采用与失败类型匹配的最小修正；不得把所有场景原文堆进 SKILL.md。

- [ ] **Step 4: 复测 Constitution 场景**

  freeze、scope、Schema/destructive、shipping、evidence 场景必须全部通过，且无未授权外部动作。

### Task 7: 静态验证、独立评审与完成证据

**Files:**
- Modify: only files implicated by validation or review findings

**Interfaces:**
- Consumes: 完整 Skill、templates、behavioral results。
- Produces: validator PASS、无断链引用、无 placeholder、独立评审结论和 fresh final verification。

- [ ] **Step 1: 运行 Skill Creator validator**

  Run:

  ```bash
  python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py" <repo-root>/skills/vibe-workflow
  ```

  Expected: validation success。

- [ ] **Step 2: 运行静态一致性检查**

  检查 frontmatter、所有相对链接、未完成 scaffold 字样、template required fields、`SKILL.md` 行数、重复大段内容以及 description 是否只写触发条件。

- [ ] **Step 3: 独立评审**

  给 reviewer 提供批准设计、Skill 路径和 baseline/post-skill evidence。要求只报告会导致误路由、越权、状态失真、上下文膨胀或验证失真的问题。

- [ ] **Step 4: 最终 fresh verification**

  重新运行 validator、静态检查和关键 Constitution smoke scenarios。只有本轮输出全部满足门槛后才能声称 V0.1 完成。
