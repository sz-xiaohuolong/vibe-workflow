# Vibe Workflow: 当前仓库与 README 现状审计报告 (Current State Audit)

> 审计日期：2026-09-15  
> 审计目标：基于真实代码、Skill 实现、测试结果及现有文档，全面诊断当前项目的开源门面、产品定位、信息架构与分发机制。

---

## 1. 当前项目定位 (Current Positioning)

### 真实实现中的定位
- **本质**：纯指令型、零运行时依赖的 **Agent Lifecycle Orchestrator Skill**。
- **职责边界**：
  - 它不是通用 Coding Agent runtime，不是 IDE 插件，不是 CLI 工具，也不是多 Agent 协作框架。
  - 它专注于在**跨任务、跨会话、跨 Release** 的真实软件工程中，通过**可观察的 Gate 门禁**、**状态机**、**事实源所有权（Repository is memory）**、**最小充分上下文治理（Context Governor）**、**连续 3 次失败熔断（Circuit Breaker）**与**证据/发布两权分立**，确保 Agent 严格受控，杜绝需求漂移与盲目瞎改。
  - **核心定位公式**：*Grill Me 负责确认做什么 (What to build)；Vibe Workflow 负责可靠地做出来 (How to execute and verify)。*

---

## 2. 当前 README 的优点 (Strengths)

1. **痛点切入精准**：
   - 抓住了当前 AI 辅助编程（Vibe Coding）在“跨会话、跨步骤复杂工程”中普遍翻车（需求漂移、上下文丢失、无脑重试修 A 坏 B、虚假完成声明）的真实痛点。
2. **核心宪法有记忆点**：
   - `Repository is memory. Chat is conversation.`
   - `What to build is frozen. How to build it is delegated.`
   - `代码行数 ≠ 风险等级`
   - `Verification 与 Shipping 是两个 Gate`
3. **架构流程图清晰**：
   - 包含完整的 Mermaid 状态机图，将需求冻结、SPEC、PROPOSED_DESIGN、PLAN、BUILD、VERIFY、REVIEW、READY、SHIP 串联起来，且标出了 Circuit Breaker 和 Requirement Change 回退旁路。
4. **有扎实的测试证据支撑**：
   - 链接了 `tests/scenarios.md` 与 `tests/results/v0.1.md`（25 个对抗测试场景，Control vs Candidate 微测，全部 PASS），具有极强的真实可信度。

---

## 3. 当前 README 的核心问题 (Weaknesses & Friction Points)

### 3.1 信息层级混乱与“规范倾倒” (Specification Dump)
- 当前 README 单一页面长达 220+ 行，把所有规范细节（全套十大宪法、每个 Gate 的四行表格、三级 Context Pack、Artifact 详细目录树、所有 Superpowers 外部 Skill 映射表）全部塞在首页。
- **问题**：新用户访问时产生“认知过载”（Cognitive Overload），感觉像在读一份几十页的内部技术规范（Spec），而不是一个可以快速上手、解决痛点的开源工具。

### 3.2 首屏（Hero Section）吸引力与转化率不足
- 缺少清晰的视觉锚点（Hero Visual / 架构示意）。
- 没有直观的 **Before vs After** 剧场对比，用户不能在 10 秒内感知“用了和不用到底差在哪”。
- 缺少清晰的价值阶梯递进（Progressive Disclosure）。

### 3.3 安装体验狭窄且单一 (Installation Bottleneck)
- **仅提供了 OpenAI Codex 的私有安装方式**：
  - 指令依赖 `$skill-installer`
  - 脚本依赖 `${CODEX_HOME:-$HOME/.codex}/skills/.../install-skill-from-github.py`
- **对现代主流 Agent 生态严重缺失**：
  - 未说明 Claude Code（当前 Agent Skills 规范发源地，`~/.claude/skills/` 或 `.claude/`）的安装支持；
  - 未说明 Gemini CLI、Antigravity（`~/.gemini/config/skills/`）的安装支持；
  - 未说明 Cursor、Windsurf、Cline、Roo Code、OpenCode 等主流 IDE/Agent 的适配方案；
  - 缺乏多 Agent 兼容性矩阵（Compatibility Matrix），导致非 Codex 用户误以为无法使用。

### 3.4 纯中文表达导致国际化严重受阻 (Internationalization)
- 当前仓库仅有单一中文 `README.md`，GitHub 国际社区、英文开发者完全无法阅读和检索。
- 根目录 `README.md` 应当为规范的英文，同时提供高质量中文版本 `README.zh-CN.md`。

### 3.5 Quick Start 过于抽象
- 现有的 Quick Start 只列出了几句空泛的 prompt（如 `$vibe-workflow 继续当前软件项目...`），用户无法在 1 分钟内跑通“从零开始的一个真实小例子”。
- 缺乏明确的生命周期最小闭环示例（Minimal Walkthrough）。

---

## 4. 新用户首次访问时可能产生的疑问 (First-time Visitor Questions)

1. **Q1: 这是一个可执行的 CLI 工具、一个 NPM 包，还是一个给 AI 读的 Prompt / Skill？**
   - *当前现状*：用户看到 GitHub 仓库很容易误以为这是一个 Rust/Go/Python 写的 CLI 工具，找了半天没看到 `pip install` 或 `npm install`。必须在首屏 5 秒内明确定位：这是一个遵循 Agent Skills 开放标准的 **指令型技能包（Skill Package）**。
2. **Q2: 我用的是 Cursor / Claude Code / Cline / Gemini，我能用吗？怎么装？**
   - *当前现状*：README 通篇只提 Codex，其他平台用户直接右上角关闭离开。
3. **Q3: 它跟 Claude Code 的 Superpowers 有什么区别？是竞争对手吗？**
   - *当前现状*：README 表格中大量出现 `superpowers:test-driven-development` 等子项，容易让用户困惑两者的关系。必须明确说明生态互补：Superpowers 是具体执行技能，Vibe Workflow 是全局生命周期调度器。
4. **Q4: 它会强迫我写几千字文档吗？我只想改个小 Bug 会不会被流程卡死？**
   - *当前现状*：文档列出了大量的 SPEC、BRIEF、PROPOSED_DESIGN，容易让敏捷开发者产生“官僚流程恐惧”。必须把 **Tiny 任务零文档预算** 的理念提炼到首屏。

---

## 5. 内容分层策略 (Content Hierarchy Strategy)

### 5.1 值得保留在 README 首页的内容
- 精炼的 Hero 与一句话定位（Value Proposition）。
- 直观生动的 **Before vs After 对比**。
- 简化的生命周期 Mermaid 流程图（10 秒看懂流转）。
- 5 大核心工程机制（需求冻结、双状态机、双 Gate、熔断、上下文治理）。
- **多 Agent 兼容性矩阵与一键安装指引（Quick Start）**。
- 精选核心场景示例（新项目启动、中途需求变更、跨会话恢复、熔断恢复）。
- 与 Superpowers / Grill Me 的职责对照表。
- 真实严苛的 Skill TDD 验证结果（25/25 PASS）。

### 5.2 应该下沉到 `docs/` 深度文档的内容
- **十大宪法完整法条** $\rightarrow$ 下沉至 `docs/CONSTITUTION.md`。
- **复杂的 Schema Gate 5步长文与表结构审查细节** $\rightarrow$ 下沉至 `docs/concepts/decision-gates.md`（保留链接）。
- **Release 产物完整字段定义与数据所有权模型** $\rightarrow$ 下沉至 `docs/concepts/artifacts.md`。
- **Context Governor 三级 Pack 详细过滤白名单** $\rightarrow$ 下沉至 `docs/concepts/context-governor.md`。
- **各平台详细安装与手动配置指南** $\rightarrow$ 下沉至 `docs/installation/`。

### 5.3 绝对不能夸大或过度宣传的能力 (Boundaries & Anti-Hype)
- ❌ **不能宣称具有自动执行 push/deploy/release 的 CI/CD 能力**（Skill 宪法明确声明：V0.1 严格拒绝无证据紧急发布，且所有外部动作必须依赖人类明确授权）。
- ❌ **不能宣称为独立的 IDE / Desktop App / CLI 软件**（它是标准化 Agent Skill）。
- ❌ **不能宣称未做真实端到端验证的平台为“Stable / Verified”**（严格区分 Native Skill / Rule Adapter / Documented / Experimental）。
- ❌ **不能声称有复杂的运行时状态解析守护进程**（V0.1 是纯文本提示与模板驱动，保持零依赖）。
