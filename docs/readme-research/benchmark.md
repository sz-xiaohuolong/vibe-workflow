# AI Coding Agent / Workflow 竞品 README 深度调研与基准报告 (Benchmark)

> 调研日期：2026-09-15  
> 调研对象：精选 7 个高 Star、高影响力的 AI Agent 技能与工程工作流开源项目。  
> 调研目标：解构其 README 架构、Hero 呈现、价值主张、多 Agent 安装体验与技术图表达，为 `vibe-workflow` 的开源门面重塑提供依据。

---

## 1. 深度竞品画像与分析

### 1. `github/spec-kit` (GitHub 官方出品)
- **Positioning**: Spec-Driven Development (SDD) toolkit for AI coding agents.
- **Hero Section**: 
  - 极简居中标题 + 精炼的一句话：“Turn ideas into structured software specifications that AI agents can reliably implement.”
  - 仅保留 3 个高价值 Badge（Release, License, Spec-Driven）。无过度装饰。
- **Quick Start**:
  - 30 秒上手：直接给出 5 步阶段命令（`/speckit.constitution` → `/speckit.specify` → `/speckit.plan` → `/speckit.tasks` → `/speckit.implement`）。
- **Install UX**:
  - Agent-agnostic 安装说明，支持 GitHub Copilot、Claude、Gemini 等平台一键加载 prompt/extension。
- **Architecture**:
  - 采用清晰的泳道式流转图，强调“先定义 What，再规划 How，最后执行 Code”。
- **值得借鉴**:
  - **规范阶段化命令**：清晰的五阶段漏斗让用户一眼明白全流程。
  - **Markdown Artifacts 即持久记忆**：将规范落盘为文件，而非留在聊天上下文中。

---

### 2. `obra/superpowers` (社区明星技能库)
- **Positioning**: An agentic skills framework and software development methodology for coding agents (TDD, systematic debugging, planning).
- **Hero Section**:
  - 强调方法论：“Software engineering discipline for AI agents.”
  - 突出解决“AI 盲目写代码、写 Bug、跳过测试”的痛点。
- **Quick Start & Install UX**:
  - 采用 **Harness-agnostic** 分发体系，针对不同 Agent 提供专门的适配文档（`README.claude.md`, `README.opencode.md`, `README.codex.md` 等）。
  - 支持 `npx skills add obra/superpowers` 与各 Agent 插件机制。
- **Architecture**:
  - 模块化技能矩阵：Brainstorming → Writing Plans → Executing Plans → TDD → Systematic Debugging → Verification Before Completion → Code Review。
- **值得借鉴**:
  - **工程严谨性表达**：强调规则、纪律与可验证性，树立专业开发者心智。
  - **生态协作定位**：明确区分自身与其他工具的职责边界。

---

### 3. `anthropics/skills` (Anthropic 官方 Skills 标准与库)
- **Positioning**: Official repository and standard reference for Claude & Agent Skills (agentskills.io).
- **Hero Section**:
  - 权威且极简，直接阐明 SKILL.md 规范与标准目录结构。
- **Quick Start & Install UX**:
  - 标准化安装：直接推行 `npx skills add <owner/repo>` 跨 Agent 安装标准。
  - 明确规范约束：YAML frontmatter（`name` + `description` ≤ 1024 字符），正文包含指令。
- **值得借鉴**:
  - **遵循开放标准**：完全兼容 `agentskills.io` 规范，利用跨 Agent 通用的 `npx skills` 工具链，降低所有 Agent 用户的安装门槛。

---

### 4. `NVIDIA/skills` (NVIDIA 官方 Agent 技能体系)
- **Positioning**: Official agent skills for Physical AI, Robotics, and CUDA development.
- **Hero Section**:
  - 企业级工程风，主打 **"Verified Skills"** 概念。
- **Architecture & Trust**:
  - 引入 `SKILLCARD.yaml`，清晰声明依赖、权限、安全边界与适用模型，给用户确定性安全感。
- **值得借鉴**:
  - **信任与安全背书**：明确声明权限、外部副作用与不可逆操作边界，这对涉及数据变更和部署的 `vibe-workflow` 极具参考价值。

---

### 5. `Fission-AI/OpenSpec` (开放规范驱动工作流)
- **Positioning**: Open Specification-Driven Development standard and tooling for coding agents.
- **Hero Section & Value Proposition**:
  - 核心口号：“Enablers, not gates. Structure, not bureaucracy.”
  - 强调解决 AI 无法理解长篇 PRD 的问题，将规格结构化为增量 Delta（ADDED / MODIFIED / REMOVED）。
- **值得借鉴**:
  - **Delta 增量变更概念**：与 `vibe-workflow` 的 `CHANGE.md` 设计不谋而合，适合敏捷小步迭代。

---

### 6. `claude-task-master` (轻量结构化任务编排)
- **Positioning**: Structured task management and token governor for Claude agents.
- **Hero Section**:
  - 极简、开发者原生。直接用 ASCII / 简单表格展示内存与 Token 消耗对比。
- **Architecture**:
  - 核心设计：分层加载（Core 7 个工具仅约 5k tokens，其余按需挂载）。
- **值得借鉴**:
  - **Token 节流表达**：用数据量化 Context Governor 的价值（“节省 80% 历史上下文干扰”）。

---

### 7. `OpenHands` (原 OpenDevin，多智能体软件开发平台)
- **Positioning**: AI-driven software development agent with plan/execution separation.
- **Architecture**:
  - **Plan Mode vs Execution Mode 物理分离**：规划阶段只读，不修改代码；进入执行阶段才分配写权限。
- **值得借鉴**:
  - **只读规划与写执行严格分离**：与 `vibe-workflow` 的“工程入口 Gate 满足前严禁写脚手架或改代码”高度契合。

---

## 2. Top 10 README Best Practices (优秀 README 十大最佳实践)

1. **5 秒一句话定位 (The 5-Second Rule)**：第一屏清晰回答“这是什么工具、装在什么环境、解决什么核心痛点”，绝不玩抽象概念。
2. **极简且真实的 Badges**：只展示 License、Version、Verified Tests、Agent Support 4~5 个真实 Badge，杜绝虚假与过度堆砌。
3. **直观的 Before vs After 对比**：通过并排剧场或对比表格，让开发者立刻看到“不用”与“用了”在错误率、失控率上的巨大差距。
4. **低摩擦的 Quick Start**：安装到首次使用的耗时必须在 1 分钟以内，直接给出可复制的真实命令。
5. **清晰的架构与流转图 (Mermaid-first)**：首屏使用 10 秒看懂的高层流程图，复杂的分支状态机下沉到深度文档。
6. **诚实客观的 Compatibility Matrix**：详细列出各主流 Agent 的支持级别（Native / Adapter / Manual），不夸大、不造假。
7. **渐进式信息披露 (Progressive Disclosure)**：首页负责引导与价值呈现，深层技术规范、全套字段定义、宪法细则链接到 `docs/`。
8. **边界意识与反营销感 (When NOT to use)**：明确告知在单行 CSS 调整、一次性脚本等场景无需启动大流程，体现成熟工具的克制。
9. **可验证的技术证据 (Trust through Proof)**：用自动化测试脚本输出、场景复测记录替代自夸式的形容词。
10. **双语自然原生 (Native English & Idiomatic Chinese)**：英文 README 遵循国际开源规范，中文 README 符合中文开发者技术习惯，杜绝机翻感。

---

## 3. Vibe Workflow 应该学习什么？

1. **统一跨 Agent 安装入口**：
   - 学习 Anthropic 与现代生态的最佳实践：支持标准的 `npx skills add sz-xiaohuolong/vibe-workflow`，同时兼顾 Codex 的 `$skill-installer` 和一键本地安装脚本 `install.sh`。
2. **直观的 Before/After 剧场对比**：
   - 将“连续瞎改 5 次把项目改崩” vs “3 次失败触发 Circuit Breaker 优雅熔断”直观展现。
3. **首屏生命周期图极简化**：
   - 将现有 20+ 节点的复杂状态机精简为 8 阶段高层漏斗，复杂版本放入 `docs/`。
4. **生态定位解惑表 (Ecosystem Role Matrix)**：
   - 一张表格说清 Vibe Workflow、Grill Me、Superpowers 和 Coding Agent 各自的不可替代分工，打消用户“是否冲突”的疑虑。
5. **精炼工程宪法**：
   - 首页提炼 5 句极具穿透力的核心法则，完整 10 条法典沉淀为独立的 `docs/CONSTITUTION.md`。

---

## 4. Vibe Workflow 不应该模仿什么？

1. ❌ **不要模仿重型平台自造运行时/CLI/看板**：保持纯 Skill、零运行时依赖的纯粹定位。
2. ❌ **不要模仿营销号堆砌满屏 Emoji 和花哨动图**：采用 Deep Navy / Minimalist Engineering 视觉风格，传达大厂基础设施级的严谨可信。
3. ❌ **不要夸大全自动能力**：明确保留 Human Decision Gates 和两权分立，不搞“一键全自动从 0 到发布”的虚假噱头。
4. ❌ **不要虚构未验证平台的“完美支持”**：未跑通端到端验证的 Agent 平台，诚实标注为 Manual 或 Experimental。
