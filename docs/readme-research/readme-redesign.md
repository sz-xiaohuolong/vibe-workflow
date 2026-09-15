# Vibe Workflow: README 重塑与信息架构设计方案 (README Redesign Plan)

> 设计日期：2026-09-15  
> 设计目标：建立国际一流开源 AI 基础设施与开发者工具水准的 GitHub 门面，完成中英文双语、多 Agent 兼容、Docs 下沉与信息层级重构。

---

## 1. 核心定位与品牌语言 (Positioning & Tagline)

### 核心定位
> **Vibe Workflow is a lifecycle orchestrator for reliable AI-assisted software engineering.**  
> It governs the end-to-end software evolution across sessions and releases—enforcing requirement freezes, explicit human decision gates, minimal context, circuit breakers, and fresh verification evidence.

### Tagline 候选与甄选
- *Candidate 1*: Turn coding agents into disciplined engineering workflows.
- *Candidate 2*: From vibe coding to engineered delivery.
- *Candidate 3*: A lifecycle orchestrator for reliable AI-assisted software engineering.
- *Candidate 4*: Keep requirements frozen. Keep agents aligned. Ship only with evidence.

**最终采纳方案**：
- **主标题**: `Vibe Workflow`
- **主 Tagline**: `A lifecycle orchestrator for reliable AI-assisted software engineering.`
- **副 Slogan**: `From vibe coding to engineered delivery.`

### 核心品牌记忆点 (Brand Mnemonics)
- *Repository is memory. Chat is conversation.*
- *What to build is frozen. How to build it is delegated.*
- *Code lines ≠ Risk level.*
- *Stop patching. Replan.*
- *No fresh verification, no completion claim.*

---

## 2. README 信息架构 (IA Structure)

新版 README 遵循 **Progressive Disclosure（渐进式信息披露）**，控制主页长度在 150~180 行以内，结构编排如下：

```text
1. Hero Section (居中标题、Tagline、精选真实 Badges、中英文语言切换)
2. Hero Architecture / Visual (极简流向图：Freeze → Spec → Design → Plan → Build → Verify → Ship)
3. The Problem & Paradigm Shift (Before vs After 对比剧场)
4. Ecosystem Role Matrix (Vibe Workflow vs Grill Me vs Superpowers vs Coding Agent)
5. Five Core Engineering Pillars (5大核心工程机制提炼)
6. High-Level Lifecycle (10 秒看懂的高层 Mermaid 流转图)
7. Quick Start (1分钟极速上手：从零开始、跨会话恢复、熔断处理)
8. Multi-Agent Compatibility Matrix & Installation (多平台安装指南)
9. When to Use vs When NOT to Use (明确工具边界，Tiny 任务不官僚)
10. Trust & Verification (25/25 Skill TDD 测试证据与可信度)
11. Documentation & Deep Dive (链接至 docs 体系)
12. Contributing & License
```

---

## 3. Hero Visual 设计规划 (Hero Visual & Assets)

### 评估与决策
- **不采用** 花哨复杂的渐变海报或劣质 AI 机器人配图。
- **采用** 极简、现代、GitHub Dark/Light 模式自适应的 **SVG 架构概览图** (`assets/vibe-workflow-hero.svg`) 或精美原生 Mermaid 渲染。
- **视觉风格**：Deep Navy / Charcoal 背景，Electric Blue / Violet 强调色，体现工业级软件工程的严谨度。
- **展示核心**：
  $$\text{Requirements Freeze} \longrightarrow \text{Design \& Plan} \longrightarrow \text{Execution (TDD)} \longrightarrow \text{Verification Evidence} \longrightarrow \text{Human Ship Gate}$$

---

## 4. Docs 分层与下沉计划 (Docs Decoupling Plan)

为了彻底根除原 README 的“规范倾倒”（Specification Dump），将深度技术规范迁移下沉至 `docs/`：

| 深度主题 | 原 README 现状 | 新下沉文件路径 | README 中的呈现方式 |
|---|---|---|---|
| **十大工程宪法法典** | 全部 10 条法条全文铺在首页 | `docs/CONSTITUTION.md` | 首页提炼 5 条核心记忆点，文末链接完整法典 |
| **详细生命周期状态机** | 包含 20+ 节点、回退矩阵的长图与表格 | `docs/concepts/lifecycle.md` | 首页提供 8 阶段高层漏斗 Mermaid，保留完整链接 |
| **决策关卡与 Schema 规范** | 5 步详细 Schema 检查清单 | `docs/concepts/decision-gates.md` | 首页提炼权责归属表格，链接深度文档 |
| **上下文治理规范** | 三级 Pack 详细白名单 | `docs/concepts/context-governor.md` | 首页强调“80% 上下文降噪与防幻觉” |
| **熔断与快照规范** | Debug Snapshot 字段与恢复步骤 | `docs/concepts/circuit-breaker.md` | 首页保留醒目的代码流程块 |
| **产物模型与所有权** | 完整目录树与追踪矩阵 | `docs/concepts/artifacts.md` | 首页保留精简结构概览 |
| **各平台手动配置** | 缺少非 Codex 指南 | `docs/installation/` | 首页提供通用安装矩阵，深度文档提供各平台步骤 |

---

## 5. 多 Agent 兼容性矩阵与安装设计 (Multi-Agent Strategy)

### 兼容性分类标准 (Strict Verification Levels)
- **Native Skill**：宿主环境原生支持 `SKILL.md` 开放标准或内置技能协议。
- **Rule Adapter**：通过宿主规则文件（如 `.cursorrules`, `.clinerules`）挂载技能核心指令。
- **Manual Integration**：将核心指令作为 System Prompt 或 Project Instructions 引入。
- **Not Supported**：无长上下文或无指令扩展机制。

### 兼容性矩阵设计

| Agent / Environment | Support Level | Installation Method | Verified Status |
|---|---|---|---|
| **OpenAI Codex** | Native Skill | `$skill-installer` / `install.sh` | ✅ Verified (Local) |
| **Claude Code** | Native Skill | `npx skills add` / `install.sh` | ✅ Verified (Local) |
| **Antigravity / Gemini** | Native Skill | `~/.gemini/config/skills/` / `install.sh` | ✅ Verified (Local) |
| **OpenCode** | Native Skill | Plugin / Skill Directory | 📝 Documented |
| **Cursor** | Rule Adapter | `.cursorrules` / `.cursor/rules/` | 📝 Documented |
| **Windsurf** | Rule Adapter | `.windsurfrules` | 📝 Documented |
| **Cline / Roo Code** | Rule Adapter | `.clinerules` / `.roomodes` | 📝 Documented |
| **GitHub Copilot** | Instruction | `.github/copilot-instructions.md` | 📝 Documented |

### 统一极简安装脚本 (`install.sh` / `scripts/install.py`)
设计一个轻量自包含安装器，支持：
```bash
# 通用一键安装（自动检测当前可用 Agent 并安全软链/复制）
./install.sh

# 指定 Agent 安装
./install.sh --agent codex
./install.sh --agent claude
./install.sh --agent gemini
./install.sh --agent cursor
```
并且在 README 首屏突出最受欢迎的标准命令：
```bash
npx skills add sz-xiaohuolong/vibe-workflow
```

---

## 6. 中英文 README 组织策略 (Bilingual Strategy)

1. **根目录 `README.md`**：
   - 纯正地道的英文开源门面，遵循 GitHub 国际开源基础设施标准。
   - 顶部第一行放置居中语言切换：`[ English | 简体中文 ]`。
2. **`README.zh-CN.md`**：
   - 结构与英文版 100% 对齐。
   - 语言表达符合中文开发者习惯（专业、精炼、工程感强，拒绝营销吹捧和机翻味）。
