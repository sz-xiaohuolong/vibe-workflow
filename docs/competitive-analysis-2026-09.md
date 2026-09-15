# vibe-workflow 竞品调研报告：技能型 / 指令型 Agent 工作流框架

> 调研时间：2026-09-12（所有 star 数为该时点抓取值，标注为「约」）
> 调研工具说明：会话中 `web_search` 工具不可用（API 404），全部网络检索改用 firecrawl（search/scrape）；GitHub REST API 被共享 IP 限流，star 数取自仓库页面抓取。
> 口径：本项目（vibe-workflow，sz-xiaohuolong/vibe-workflow，v0.1）为「纯指令型生命周期 Orchestrator Skill」——无运行时、无脚本、无 hooks，只做编排。下文所有「vibe 有 / vibe 没有」均对照其 `SKILL.md` + `references/*` + 设计文档。

---

## 一、逐个竞品分析

### 1. obra/superpowers —— 主要灵感来源，方法论 + 技能框架的标杆

- **仓库**：<https://github.com/obra/superpowers>（v6.3.0，2026-08 发布；约 286k stars / 25.5k forks，MIT，Jesse Vincent / Prime Radiant）
- **定位**：`A complete software development methodology for your coding agents`——不是一个状态机，而是一条**由技能自动触发、不可跳过的工程流水线**。安装后 agent 从第一句话起就按方法论工作（`The agent checks for relevant skills before any task. Mandatory workflows, not suggestions.`）。
- **核心机制**：
  - **技能流水线**：`brainstorming`（苏格拉底式提问收敛设计、**分块呈现给人类逐段签核**）→ `using-git-worktrees`（隔离工作区 + 干净测试基线）→ `writing-plans`（2–5 分钟粒度的 bite-sized 任务，每个任务含精确文件路径、完整代码、验证步骤）→ `subagent-driven-development`（每任务一个 fresh subagent + **两阶段审查：先 spec compliance、再 code quality**）或 `executing-plans`（批量执行 + 人类检查点）→ `test-driven-development`（RED-GREEN-REFACTOR）→ `requesting-code-review`（按严重度分级，critical 阻断）→ `finishing-a-development-branch`（merge/PR/discard 决策菜单）。另有 `systematic-debugging`（4 阶段根因法）、`verification-before-completion`（**运行命令、读输出、再声称完成**）、`dispatching-parallel-agents`。
  - **人类关卡**：不是「分类 Gate」，而是「签核点」——设计逐段批准、计划批准、「you say go」后才启动 SDD。
  - **最新的状态/文档机制**（2026 年重构）：**plan-scoped workspace**——`.superpowers/sdd` 下每个计划独立子目录、`ledger` 记账计划身份、终审干净后删除工作区，解决「跨计划进度污染」。brainstorming 会保存设计文档。
  - **行为级测试基建**：`superpowers-evals`（drill eval harness）用 fresh subagent 对 skill 行为打分；技能修改是 **eval-gated**（如 TDD 抗压场景 control 8/10 → treatment 5/10 就回滚）。这与 vibe 的 Skill TDD 同构，但已脚本化、CI 化。
  - **跨 harness**：Claude Code、Codex App/CLI、Cursor、Gemini CLI、GitHub Copilot CLI、Devin CLI、Antigravity、Pi、Hermes、OpenCode、Kimi、Grok、Factory Droid 等 14 个，均有官方安装路径。
- **对比 vibe**：
  - superpowers 有而 vibe 没有：①两阶段（spec→quality）独立审查；②plan-scoped workspace + ledger；③脚本化的行为 eval（drill）；④14 harness 适配矩阵；⑤「分块签核」的交互范式。
  - vibe 有而 superpowers 没有：①显式 **Release 状态机**（REQUIREMENTS_FROZEN→…→RELEASED + Operational Status 双轨）；②**分类 Human Decision Gates**（Product/Schema/DDL/Security/Destructive/External/Shipping，含 Schema 五步闭环与「代码行数≠风险等级」）；③**Verification 与 Shipping 两权分立**（证据状态 ≠ 人类授权，无 emergency bypass）；④**Circuit Breaker**（连续 3 次同类失败→STOP PATCHING→回退重设计）；⑤**Repository is memory** 分层事实源（docs/vibe/ + releases/<id>/ 封存）；⑥**Requirement Traceability**（REQ→AC→设计→任务→测试→证据）；⑦**Context Governor** 三级按需加载（Bootstrap/Resume/Task Pack）。→ 二者是互补关系：vibe 补 superpowers 缺的「生命周期治理」，superpowers 补 vibe 缺的「实现期纪律」。

### 2. superpowers-mcp —— 原仓库已下线，生态位被官方吸收

- **现状核实**：原仓库 `workshop/superpowers-mcp` 已 **404**（改名或下架，无法找到重定向目标）。存续的是社区维护版 **erophames/superpowers-mcp**（<https://github.com/erophames/superpowers-mcp>）：TypeScript 实现的 MCP server，把 superpowers 的 skills 以 MCP tool 形式暴露给任意支持 MCP 的 LLM（brainstorming、writing-plans、executing-plans、SDD、TDD、systematic-debugging、verification-before-completion、code review 等）。
- **定位与机制**：纯「桥接层」——skills as MCP tools。无状态机、无文档模型、无关卡；价值在于让非 Claude Code 的宿主也能调用 superpowers。
- **对比 vibe**：vibe 不需要 MCP 桥接（它是通用 SKILL.md 指令）；但 superpowers-mcp 的存在提示一个方向：**把「生命周期状态」暴露为可编程接口**（见建议 7）。

### 3. anthropics/skills 与 OpenAI 的 skills —— 标准层，不是工作流层

- **anthropics/skills**：<https://github.com/anthropics/skills>（约 176k stars / 20.8k forks）。定位：**Agent Skills 标准的官方实现与示例库**，不是工作流框架。核心内容：
  - `spec/` 目录承载 **Agent Skills 规范**（网站 [agentskills.io](https://agentskills.io/)）；SKILL.md 只需 `name` + `description` 两个 frontmatter 字段，正文为指令。
  - 上传/打包约束（实测对 vibe 有直接约束）：description ≤ **1024 字符**；技能名不得含保留字 `claude`/`anthropic`；可注册为 Claude Code plugin marketplace（`.claude-plugin/marketplace.json`）。
  - 示例技能涵盖 docx/pdf/pptx/xlsx 文档技能（source-available）与各类示例；`template/` 提供最小模板。
- **OpenAI 侧**：用户提到的 `openai/agents-skills` **不存在（404）**。OpenAI 的 skills 能力实际落在：①**Codex**（项目级 `.agents/skills/`、全局 `~/.agents/skills/`，官方文档 [developers.openai.com/codex/skills](https://developers.openai.com/codex/skills)；`openai/codex` issue #5291 记录过 SKILL.md 支持诉求）；②**Agents SDK / API**（[Skills in OpenAI API cookbook](https://developers.openai.com/cookbook/examples/skills_in_api)）。Codex 也上了官方插件市场（superpowers 在 [openai/plugins](https://github.com/openai/plugins) 有收录）。
- **生态结论**：SKILL.md 已是**跨厂商事实标准**（Claude Code / Codex / Cursor / OpenClaw / Gemini CLI 等互认）；标准技能目录 `.agents/skills/` 的共识在 [agentskills/agentskills#15](https://github.com/agentskills/agentskills/issues/15) 讨论中。vibe 的 SKILL.md 结构完全符合该标准，只需注意上传约束与目录约定（见建议 6）。

### 4. "grind"（Grind Mode）—— 不是单一仓库，而是一种「无人值守清空队列」的社区模式

- **定位核实**：多次检索未发现名为 grind 的权威独立仓库（`SawyerHood/grind` 404）。「Grind Mode」在 Claude Code / Cursor 社区是**通用模式**，典型载体：
  - 传播最广的成品是社区 gist「**GRIND - Autonomous Issue Processor**」（<https://gist.github.com/e51c7be727851a669f9ffac71d87d4e3>）：安装 **Stop hook**（agent 每次收尾时 echo `GRIND MODE: N ready issues remain. Run /grind to continue.`），配合 issue 队列（如 beads）形成循环。
  - 同类实现：SLATE 的「Grind Mode」（<https://github.com/CaryWang1234/SLATE>）、Russell Jurney 给 Cursor 配的 Grind Mode、`claude-task-master` 的 `loop` 命令、以及 Ralph Wiggum 循环（见第 6 节）。
- **核心机制**：`claim issue → fresh context 实现（TDD）→ 验证 → 原子 commit → close issue → 循环直到队列为空`；**无需求冻结、无人类关卡、无状态机、无文档模型**，纯粹「把队列清空」的无人值守打磨循环；Stop hook 是它防止「会话结束即丢失」的关键装置。
- **对比 vibe**：grind 是 vibe 的 BUILDING 循环的「无治理」极端版。vibe 有 grind 没有的：需求冻结、Gate、熔断、证据门槛；grind 有 vibe 没有的：**Stop/SessionEnd hook 的跨会话续跑提醒**（见建议 4）。

### 5. AGENTS.md 规范生态

- **标准仓库**：<https://github.com/agentsmd/agents.md>（约 24.3k stars；发起方含 Google、OpenAI、Factory、Sourcegraph、Cursor，contributors 含 `dkundel-openai`）。定位：**AGENTS.md = README for agents**——给 coding agent 的开放、可预测的上下文与指令格式；正文无强制结构（任意标题组织）；官方站点 <https://agents.md/>。已获 **2 万+ 仓库**采纳。
  - **v1.1 提案**（issue #135）：把隐式语义显式化（文件名规范、alias 兼容、格式约定），方向是「可机器校验」。
- **用户提到的 eugeneyan/openai-agents-md**：**404（已改名或删除）**，已无法访问；AGENTS.md 生态的实际标准仓库是上面的 `agentsmd/agents.md`。
- **对比 vibe**：vibe 已把「从当前目录向上读取 AGENTS.md」写进 SKILL.md 并维护根 AGENTS.md 作为 Agent 行为规则入口——方向正确；可借鉴 v1.1 的「隐式语义显式化」与互操作要求（不要发明平行格式，见建议 6）。

### 6. 其他高度相关项目（按定位分层）

**A. 执行层 / Meta-harness（vibe 明确不做，但可借鉴其机制）**

- **claude-flow → ruflo**：<https://github.com/ruvnet/ruflo>（约 72.2k stars / 8.5k forks，7.4k commits，日更活跃；`ruvnet/claude-flow` 重命名而来）。定位：`An agent meta-harness for Claude Code and Codex`——真正的执行层（CLI/daemon + MCP server + 27 hooks + 100+ agents + swarm 协调 + AgentDB/HNSW 记忆 + SONA 自学习 + 跨机 federation + 密码学字节验证 `ruflo verify`）。值得注意的机制：**GOAP A\* 目标规划器**（goal.ruv.io：自然语言目标 → 状态空间搜索 → 前置条件/动作/效果 → 失败即从当前状态重跑 A\* 而非重头再来——这与 vibe 的「Requirement Change 回退到最早失效状态」异曲同工，但 vibe 是表格规则、ruflo 是可执行规划）；SPARC 方法论（Specification→Pseudocode→Architecture→…）内置。→ vibe 是「纯指令」，ruflo 是「有执行层的全家桶」；vibe 的克制（不建运行时）是对的，但 ruflo 证明「把状态机变成可执行、可重放」是可行方向（见建议 7）。
- **Anthropic Claude Code Dynamic Workflows（官方，research preview 2026-06）**：<https://claude.com/blog/introducing-dynamic-workflows-in-claude-code>、文档 <https://code.claude.com/docs/en/workflows>。Claude **动态编写编排脚本**，在一个会话内并行驱动数十至数百个 subagent，交付前自查验证。→ 生态正从「提示词编排」走向「代码化编排」（`agent()/parallel()/pipeline()/phase()` 风格的 DSL 已成为事实语法，见下）。
- **omegacode**（SawyerHood，<https://github.com/SawyerHood/omegacode>，约 138 stars；由 agent-workflows 更名）：「agent-agnostic implementation of Claude Code's Workflows」——JS workflow 文件 DSL 驱动 Claude Code / Codex / OpenCode / pi 混合集群；**journal + chained-key 可恢复**（`--resume` 只重跑变更后缀）、预算控制、SSE 实时 viewer。→ 可恢复性（resume 语义）正是 vibe 跨会话恢复想解决的事，但 vibe 用「仓库文档」、omegacode 用「journal」（见建议 7）。

**B. 任务/计划管理（状态模型的直接对照）**

- **claude-task-master**：<https://github.com/eyaltoledano/claude-task-master>（约 28.1k stars，92 releases，现归 Hamster 运营）。定位：AI 开发的任务管理系统（CLI/TUI/MCP，可嵌入 Cursor/Lovable/Windsurf/Roo/Claude Code）。核心机制：①**tasks.json 作为单一事实源**（结构化、机器可校验的任务状态，而非 prose）；②`parse-prd` 把 PRD 解析成带依赖/tag/复杂度分析的任务；③`next_task`/`set_task_status`/`expand_task`/subtasks；④**36 个 MCP 工具的按需分级加载**（`TASK_MASTER_TOOLS=all/standard/core` ≈ 21k/10k/5k tokens）——这是「上下文治理」在工具层的落地，与 vibe 的 Context Governor 同思想不同载体；⑤许可证 MIT + **Commons Clause**（不可转售/托管/竞品）。→ vibe 的 PROGRESS/IMPLEMENTATION_PLAN 是 prose，缺机器可校验性（见建议 1）。
- **GSD（Get Shit Done）**：<https://github.com/gsd-build/get-shit-done>（约 23k stars（2026-03 时点）；**现已归档 Public archive**）。定位：spec-driven development 的 slash-command 链（`/gsd-*`，约 29 skills / 12 agents / PROJECT.md）。机制：**每个 plan 用 fresh context 窗口执行 + 每任务原子 git commit**（「atomic git commits per task so you can bisect your way out of agent chaos」）；引导式需求收集生成可跟踪需求与 roadmap。→ 归档本身是重要教训（见建议 8）。「每任务原子提交」值得 vibe 强化为硬契约（见建议 3）。

**C. 自学习型工作流（vibe 完全没有的能力）**

- **pro-workflow**：<https://github.com/rohitg00/pro-workflow>（约 2.9k stars，v3.3.0，2026-07 仍在更新）。定位：`Claude Code learns from your corrections`——**自校正记忆**工作流。结构：41 skills / 23 commands / 8 agents / **37 个 hook 脚本覆盖 24 个事件** / SQLite（learnings、sessions、wiki 知识面）+ embeddings。高价值机制：①**纠错学习回路**：`/learn-rule` 把用户纠正提取为规则，`Stop` hook 自动捕获 `[LEARN]` 块，`/replay` 在相关任务时回放既往 learnings，跨 50+ 会话复利；②**skill-optimizer**：借鉴 Microsoft SkillOpt 的 ReflACT 管线，**离线优化自己的 SKILL.md**（rollout→reflect→aggregate→clip→apply，预算门控 + held-out 验证集 + 阈值门）；③**skill-router**（41 个 skill 的人机调用标签索引）；④`contexts/` 模式切换（dev/review/research）；⑤`plan-interrogate`（沿决策树压力测试计划）、`module-map`、`compact-guard`（受保护压缩：压缩前存状态、压缩后回注）、`permission-analyst`/`cost-analyst`、`llm-council`（高利害决策的三方多模型审议）、LLM Gates（破坏性操作前 AI 验证）。→ 其哲学「Orchestrate, don't micromanage」「Persistent over ephemeral」与 vibe 完全一致，但「从人类纠错自动学习」是 vibe 的 Learning Loop 缺失的闭环（vibe 现有 Learning Loop 是 agent 自己按知识类型沉淀，不消费人类纠错信号）（见建议 5）。

**D. 循环模式与规则生态（背景层）**

- **Ralph Wiggum**（<https://github.com/ghuntley/how-to-ralph-wiggum>，Geoffrey Huntley）：bash while 循环把「研究→实现→测试→更新 IMPLEMENTATION_PLAN.md→commit→push→git tag」循环到无错为止；**IMPLEMENTATION_PLAN.md 是唯一状态**、**AGENTS.md 只放操作信息**（「A bloated AGENTS.md pollutes every future loop's context」）——与 vibe 的 PROGRESS/Context Governor 呼应，且其「AGENTS.md 瘦身」教训对 vibe 的 AGENTS.md 设计有直接价值。
- **Cursor Rules**（`.cursor/rules/`，聚合站 cursor.directory）：按 glob 匹配、可 `alwaysApply` 的规则文件——与 AGENTS.md/SKILL.md 并存的第三套「指令载体」，生态碎片化的另一极；vibe 作为跨 agent 编排器应保持 SKILL.md/AGENTS.md 中立（见建议 6）。

---

## 二、横向对比表

| 维度 | vibe-workflow | superpowers | ruflo (claude-flow) | task-master | GSD | pro-workflow | grind 模式 |
|---|---|---|---|---|---|---|---|
| 形态 | 纯指令 Skill | 技能库插件 | 执行层 meta-harness | CLI/MCP 工具 | 命令链插件 | 插件+hooks+SQLite | 社区 skill+gist |
| 星数(约) | — | 286k | 72.2k | 28.1k | 23k(已归档) | 2.9k | — |
| 状态机 | **Release 单向状态机+Operational Status** | 无（线性流水线） | GOAP A* 规划+swarm | 任务状态字段 | 命令阶段 | 阶段 gate | 无 |
| 人类关卡 | **分类 Gate（Product/Schema/Security/Shipping…）** | 签核点（设计/计划/出发） | 弱 | 弱 | 弱 | safe-mode/LLM gate | 无 |
| 持久文档模型 | **docs/vibe 分层+Release 封存+追踪链** | 设计文档+plan workspace/ledger | AgentDB/记忆 | tasks.json | PROJECT.md | SQLite+wiki | 无 |
| 验证机制 | **Verification/Shipping 两权分立** | verification-before-completion | 密码学字节验证 | 任务证据 | 每任务验证 | LLM gate | 每任务验证 |
| 上下文治理 | **Context Governor 三级 Pack** | 靠 subagent 转移上下文 | 记忆检索 | 工具分级加载(21k/10k/5k) | fresh context/plan | context-engineering+compact-guard | fresh context/任务 |
| 熔断 | **Circuit Breaker（3 次同类失败）** | 无 | 有（federation 层） | 无 | 无 | 无 | 无 |
| 自学习 | 知识类型沉淀（被动） | eval-gated 改 skill | SONA 自学习 | 无 | 无 | **纠错学习回路+skill-optimizer** | 无 |
| 可执行/可恢复 | 无（仓库文档即状态） | 无 | journal/可恢复 | MCP 状态 | 无 | hooks | Stop hook 续跑 |

---

## 三、针对 vibe-workflow 的优化建议（8 条）

1. **借鉴 claude-task-master 的 tasks.json：给 PROGRESS/IMPLEMENTATION_PLAN 增加「机器可校验」状态块**。
   vibe 的状态、Task 完成度、evidence 锚点目前都是 prose。建议：在 `PROGRESS.md` 顶部固定一个字段化状态块（`Current Release / State / Status / Slice / Task / Last Stable Commit / Next Gate`），并在 `IMPLEMENTATION_PLAN.md` 每行 Task 后追加 `[status: pending|in_progress|done|blocked] + evidence commit` 标记；配套一个约 30 行的 `tests/validate_state.sh`（lint-only，零运行时依赖，延续 V0.1「不建运行时」边界），让「状态机一致性」可以被静态校验（State 顺序、REQ/AC 覆盖、Last Stable Commit 可定位）。这同时是 AGENTS.md v1.1「隐式语义显式化」的落地。

2. **借鉴 superpowers SDD 的两阶段审查：把 REVIEWING 升级为「spec-compliance → code-quality」双通道独立审查，并强制 fresh subagent 执行**。
   vibe 的 REVIEWING 是单通道。建议：在 `quality-and-release.md` 中规定——进入 REVIEWING 后先由 fresh subagent A 按 Effective SPEC 逐 REQ/AC 核对（spec compliance，产出缺口清单），再由 fresh subagent B 做代码质量/安全审查（产出按严重度分级的 finding，critical 阻断）；两个审查结论 + 修正记录 + 复验结果共同构成 READY_TO_SHIP 的硬性证据项。同时借鉴 SDD 的 **plan-scoped workspace**：每个计划（或每个 Release 的 PLAN 执行期）在 `docs/vibe/releases/<id>/` 下维护独立 ledger（计划身份、进度、终审结论），避免跨计划/跨会话污染。

3. **借鉴 GSD 的「每任务原子提交」：把 BUILDING 循环的 `checkpoint/commit when available` 提升为 Bounded/Architectural 任务的硬契约**。
   vibe 的 Task Loop 里 commit 是「when available」（软性）。建议：对 Bounded/Architectural 任务强制「每个 Task 一个可回滚原子 commit，commit hash 记入 PROGRESS 作为该 Task 的 evidence 锚点」，使任意时刻可 bisect 出问题引入点（GSD 原话：`atomic git commits per task so you can bisect your way out of agent chaos`）；Tiny 任务与无 Git 场景保留现有降级（不伪造 commit ID）。这与 vibe 的 Last Known Good State / Circuit Breaker 直接咬合——熔断恢复的「稳定点」从此有精确 commit 可回退。

4. **借鉴 Grind Mode 的 Stop/SessionEnd hook：为「跨会话续跑」加一个主动提醒装置**。
   vibe 是纯指令 Skill，会话一断全靠下一会话的 Resume Pack 自觉恢复。建议：发布一个可选的**配套钩子清单**（Claude Code `Stop`/`SessionEnd` hook、Codex 等价机制），在每次 agent 收尾时打印 `vibe-workflow: 当前 Release/State/Status，Next Gate/Task 未完成，下次运行 "$vibe-workflow 继续"`；hook 只读 PROGRESS，无副作用，不改变 vibe「仓库即记忆」的定位——它只是把「恢复入口」从用户记忆搬到了会话尾部。若不想引入 hooks，最低成本版本是在 SKILL.md 增加「收尾仪式」：任何自然结束点必须输出一行标准续跑指令。

5. **借鉴 pro-workflow 的纠错学习回路（Markdown 轻量版）：让「人类纠错」进入 vibe 的 Learning Loop**。
   vibe 现有 Learning Loop 是 agent 按知识类型沉淀（BUG/DEC/AGENTS.md…），但**不消费人类的纠正信号**——用户纠正 Gate 判定、文档归属或措辞后，下次会话仍可能重犯。建议：新增 `docs/vibe/decisions/CORRECTION-xxx.md`（或独立 `docs/vibe/learnings/`）记录「用户的纠正 → 违反的规则 → 修正后的判定标准」，并把它纳入 Resume Pack 的默认加载清单（最近 N 条）；同时把「同一纠正重复出现 ≥2 次」定义为应当升级为 AGENTS.md 规则或 SKILL.md 规则修正的信号（参考 superpowers eval-gated 修改，见建议 8）。不需要 SQLite/embeddings——vibe 的「仓库即记忆」用 Markdown 即可，避免引入 pro-workflow 的运行时负担。

6. **对齐 AGENTS.md 与 agentskills.io 标准，避免发明平行格式**。
   三个具体动作：①SKILL.md 遵守上传约束——description ≤ 1024 字符、技能名避开 `claude/anthropic` 保留字、支持 `.agents/skills/` 与 `~/.claude/skills/` 双布局（安装文档已用 Codex skill-installer，方向对，补齐 Claude Code 路径）；②在 AGENTS.md 生成规则中显式声明对 agentsmd/agents.md 格式的兼容（沿用其「无强制结构、任意标题」约定，不引入私有 frontmatter 语义）；③在 README 的文档模型中把 AGENTS.md 标注为「遵循 agents.md 开放标准」，为 v1.1 的可校验语义预留空间（如 `Requirement Status == FROZEN` 这类状态可考虑写成 v1.1 讨论中的可解析标记）。

7. **把状态机「可执行化」列入 v0.2 路线图：借鉴 Anthropic Dynamic Workflows / omegacode 的 journal + resume**。
   vibe 的状态机目前只存在于指令中，靠 agent 自觉推进。生态（Claude Code Dynamic Workflows、omegacode、ruflo）已经证明「编排脚本 + journal 可恢复」是下一步。建议 v0.2 提供**可选**的轻量执行层：一个纯 Node/Shell 脚本（约 200 行）实现「读 PROGRESS 状态块 → 校验 Gate 前置条件（REQ/AC 覆盖、evidence 锚点、Shipping 授权标记）→ 输出下一步指令 + 写 journal」，支持 `--resume` 只重放未完成 Gate；不接管实现、不做 agent 调度（守住「只做编排」宪法第 10 条）。v0.1 的「不建运行时」决定在当下依然正确，但应在设计文档中显式写出这条演进路径，避免未来被生态甩开。

8. **把 tests/scenarios.md 升级为「CI 化 + eval-gated」的行为基线，并记录 GSD 归档教训**。
   vibe 已有 25 场景、6 维评分、Constitution Gate——这是相对多数竞品的优势，但当前是手动/半自动流程。建议：①写一个 `tests/run_eval.sh`（复用现有 `validate_skill.sh` 思路）：对每个场景启动 fresh subagent 跑 Participant Prompt、按 rubric 自动打分、产出 control/candidate 对比报告——把 superpowers-evals（drill）的模式落地为脚本；②在 CONTRIBUTING/README 规定 **任何 SKILL.md/references 修改必须全场景复测通过才能合入**（eval-gated，参考 superpowers「TDD 抗压回归」案例）；③在 docs 里补一段「GSD 归档教训」：GSD 曾 23k stars 后归档，原因包括维护者倦怠与「命令链 + 文档」架构漂移——vibe 应把「最小维护面」（单 Skill + 7 references + 模板）作为长期约束写进治理规则。

---

## 四、参考 URL 汇总

**核心竞品**
- obra/superpowers：<https://github.com/obra/superpowers>；发布博客 <https://blog.fsck.com/2025/10/09/superpowers/>；文档 <https://obra-superpowers.mintlify.app/introduction>；evals <https://github.com/prime-radiant-inc/superpowers-evals/>
- superpowers-mcp 原仓库（已 404）：<https://github.com/workshop/superpowers-mcp>；社区维护版 <https://github.com/erophames/superpowers-mcp>
- anthropics/skills：<https://github.com/anthropics/skills>；Agent Skills 标准 <https://agentskills.io/>
- openai/agents-skills（404，不存在）：<https://github.com/openai/agents-skills>；OpenAI 实际能力：Codex skills <https://developers.openai.com/codex/skills>、openai/codex SKILL.md issue <https://github.com/openai/codex/issues/5291>、Skills in OpenAI API <https://developers.openai.com/cookbook/examples/skills_in_api>、openai/plugins <https://github.com/openai/plugins>
- grind：社区 gist「GRIND - Autonomous Issue Processor」<https://gist.github.com/e51c7be727851a669f9ffac71d87d4e3>；SLATE（含 Grind Mode）<https://github.com/CaryWang1234/SLATE>
- AGENTS.md 标准：<https://github.com/agentsmd/agents.md>、<https://agents.md/>；v1.1 提案 <https://github.com/agentsmd/agents.md/issues/135>；eugeneyan/openai-agents-md（404）：<https://github.com/eugeneyan/openai-agents-md>

**其他高相关**
- ruflo（claude-flow 更名）：<https://github.com/ruvnet/ruflo>；V3 重构说明 <https://github.com/ruvnet/ruflo/issues/945>；SPARC skill <https://github.com/ruvnet/agentic-flow/blob/main/.claude/skills/sparc-methodology/SKILL.md>
- Anthropic Claude Code Dynamic Workflows：<https://claude.com/blog/introducing-dynamic-workflows-in-claude-code>、<https://code.claude.com/docs/en/workflows>、InfoQ 报道 <https://www.infoq.com/news/2026/06/dynamic-workflows-claude-code/>
- omegacode：<https://github.com/SawyerHood/omegacode>
- claude-task-master：<https://github.com/eyaltoledano/claude-task-master>
- GSD：<https://github.com/gsd-build/get-shit-done>；深度解析 <https://www.codecentric.de/en/knowledge-hub/blog/the-anatomy-of-claude-code-workflows-turning-slash-commands-into-an-ai-development-system>
- pro-workflow：<https://github.com/rohitg00/pro-workflow>
- Ralph Wiggum：<https://github.com/ghuntley/how-to-ralph-wiggum>、<https://ghuntley.com/loop/>
- 三方对比文章：Superpowers vs GSD vs Compound Engineering <https://theaiengineer.substack.com/p/superpowers-vs-gsd-vs-compound-engineering>
- 社区综述：awesome-agent-skills <https://github.com/VoltAgent/awesome-agent-skills>、composio awesome-codex-skills <https://github.com/composio-community/awesome-codex-skills>
