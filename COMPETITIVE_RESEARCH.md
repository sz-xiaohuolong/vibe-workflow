# vibe-workflow 竞品调研报告

> 调研对象：`sz-xiaohuolong/vibe-workflow`（Coding Agent 生命周期编排 Skill）
> 调研范围：规格驱动开发 / 任务计划管理 / 看板式任务跟踪类开源项目
> 调研时间：2026-09（star 数取自当日 GitHub 页面，均为近似值）

---

## 0. 一句话结论

vibe-workflow 在**工程治理密度**（决策门禁、状态机、两权分立、熔断、追踪链）上明显强于所有竞品；而竞品在**工具化**（CLI/MCP/校验）、**增量表达**（delta specs）、**可视化**（看板）、**生态可扩展**（presets/extensions）与**失败记忆**（drift/快照）上有 vibe-workflow 尚未具备的能力。最值得借鉴的三件事：OpenSpec 的 change 命名与 delta 语法、spec-kit 的 `converge` 一致性审计、task-master 的复杂度分级 + MCP 工具分层。

---

## 1. 目标项目速览（对比基线）

vibe-workflow 是一份**纯 Markdown Skill**（零运行时依赖、Agent 无关），核心能力：

- **Release 级单向状态机**：REQUIREMENTS_FROZEN → SPECIFIED → DESIGNED → PLANNED → BUILDING → VERIFYING → REVIEWING → READY_TO_SHIP → RELEASED
- **Human Decision Gates**：Product 范围 / Schema / Security / Shipping 四类必须人类批准
- **Verification 与 Shipping 两权分立**：`VERIFIED|PARTIAL|UNVERIFIED|FAILED` × `NOT_REQUESTED|PENDING|APPROVED|DENIED`
- **Context Governor**：Bootstrap / Resume / Task Context 三级按需加载
- **Circuit Breaker**：连续 3 次失败 / 修 A 坏 B → STOP PATCHING → 回退 Last Known Good → REPLAN_REQUIRED
- **仓库即记忆**：`docs/vibe/`（PROJECT/TECH_DESIGN/PROGRESS + decisions/ + bugs/）+ `releases/<id>/`（PROJECT_BRIEF/SPEC/PROPOSED_DESIGN/IMPLEMENTATION_PLAN/CHANGE/VERIFICATION）
- **Requirement Traceability**：REQ → AC → 设计 → 任务 → 测试 → 证据
- **任务路由**：Tiny / Bounded / Architectural 分级 + Document Budget
- **生态编排**：阶段 → 专业 skill 映射（grill-me、superpowers 系列），缺失即降级
- **Skill TDD**：25 个对抗性行为测试场景自证

**结构性前提**：vibe-workflow 是"指令即产品"，而几乎所有竞品都是"代码产品"（CLI / npm / Python / MCP / 桌面应用）。这是差异分析的总背景。

---

## 2. 逐个项目调研

### 2.1 Fission-AI/OpenSpec — 最接近的同类（规格驱动开发）

- **仓库**：https://github.com/Fission-AI/OpenSpec ｜ **star ≈ 68k**（4.7k forks，MIT）
- **定位**：Spec-Driven Development (SDD) for AI coding assistants。"agree first, then build confidently"——给 AI 编码助手加一层轻量规格层，支持 30+ 工具（Claude Code / Cursor / Codex / Copilot…）的 slash command。

**核心机制**：

- **目录结构**（`openspec init` 生成）：
  ```
  openspec/
  ├── specs/<domain>/spec.md      # 当前系统行为真相（按 domain 组织，如 auth/、payments/）
  └── changes/<kebab-change-name>/  # 一个 change = 一个功能单元
      ├── .openspec.yaml          # 元数据（schema、创建日期）
      ├── proposal.md             # 为什么做（why）
      ├── specs/<domain>/spec.md  # Delta 规格（ADDED/MODIFIED/REMOVED 段）
      ├── design.md               # 怎么做（how）
      └── tasks.md                # 勾选式实现清单（- [ ] 1.1 / 1.2）
  ```
- **状态表示**：不是显式状态机，而是 **artifact 依赖图**（proposal → specs → design → tasks → implement），每个 artifact 有 done / ready / blocked 状态，靠 `/opsx:continue` 逐个生成、`/opsx:ff` 一键生成。
- **Delta 规格**：change 内不重写整个 spec，只写 `ADDED this requirement / MODIFIED that one / REMOVED this one`，归档时合并回主 specs——这是它对 brownfield 项目友好的关键设计。
- **流程**：`/opsx:explore`（无风险思考伙伴）→ `/opsx:propose add-dark-mode`（生成 proposal+specs+design+tasks）→ `/opsx:apply`（按 tasks.md 打勾实现）→ `/opsx:verify`（Completeness / Correctness / Coherence 三维校验，输出 CRITICAL/WARNING/SUGGESTION）→ `/opsx:archive`（sync delta → 移入 `changes/archive/YYYY-MM-DD-<name>/`）。
- **命名规范**：kebab-case 且语义化（`add-feature` / `fix-bug` / `refactor-module`），明确禁止 `update`、`changes`、`wip` 这类泛化名；归档带日期前缀。
- **哲学**："enablers, not gates"——artifact 顺序只是"让什么成为可能"，不是"必须做什么"，随时可回改任意 artifact，**没有刚性阶段门禁**（这是它和 vibe-workflow 最大的哲学分歧，README 里还专门对标 Spec Kit "rigid phase gates" 自诩更轻）。
- **Stores（beta）**：规划可以放在独立仓库，跨多代码库共享 specs/changes。
- **CLI**：`@fission-ai/openspec` npm 包，`openspec init/update/status/list/schemas`，有 schema 校验。

**vs vibe-workflow 差异**：

| 维度 | vibe-workflow 有而 OpenSpec 没有 | OpenSpec 有而 vibe-workflow 没有 |
|---|---|---|
| 门禁 | 产品范围/Schema/安全/发布的**强制人类 Gate**；两权分立 | 无硬门禁，"流体"迭代，靠人自觉 |
| 状态机 | 显式单向 Release 状态机 + 熔断 | 无（artifact 依赖图替代） |
| 追踪链 | REQ→AC→任务→测试→证据全链 | 仅 requirement+scenario，无证据链 |
| 上下文 | Context Governor 三级 Pack | 只有一句"context hygiene"建议，无机制 |
| 增量表达 | CHANGE.md 是自然语言 diff | **结构化 delta specs（ADDED/MODIFIED/REMOVED）+ 归档合并** |
| 工具化 | 无（纯 skill） | **npm CLI + 30+ 工具 slash command 分发 + schema 校验 + Stores** |
| 验证 | 人类审查 VERIFICATION 证据 | **/opsx:verify 三维自动校验 + 不阻断归档的 issue 报告** |

### 2.2 eyaltoledano/claude-task-master — 任务计划管理

- **仓库**：https://github.com/eyaltoledano/claude-task-master ｜ **star ≈ 28.1k**（2.6k forks，MIT + Commons Clause）
- **定位**：AI 驱动的任务管理系统，可注入 Cursor / Lovable / Windsurf / Roo 等。目前已并入商业化产品 **Hamster**（tryhamster.com，TaskMaster）。README 曾用 TASK.md 约定，当前实现为 `.taskmaster/` + `tasks.json`。

**核心机制**：

- **目录**：`.taskmaster/`（含 `docs/prd.txt` 作为需求输入、`templates/example_prd.txt`）、`tasks.json`（单一任务文件）。
- **任务模型**：任务带 **依赖（dependencies）**、**subtasks**、**tags 队列**（backlog → in-progress → done，可跨 tag 移动且校验依赖）、状态、元数据；ID 编号可被 `show 1,3,5` 批量引用。
- **PRD → 任务**：`parse-prd` 把 PRD 拆成结构化任务；`expand` / `expand-all` 把粗任务细化成带依赖的子任务；`next` 给出下一个该做的任务。
- **复杂度分析**：`analyze-project-complexity` + `complexity_report`，按项目规模/技术栈给 Tiny / Medium / Complex 分级（与 vibe-workflow 的 Tiny/Bounded/Architectural 路由同思路），并据此调整任务粒度。
- **Research 工具**：`research "..."` 带项目上下文检索最新外部信息后并入任务。
- **Context Governor 的具象化**：MCP server 提供 **36 个工具但可分层加载**——`core`（7 个工具 ≈5k tokens）/ `standard`（15 个 ≈10k）/ `all`（36 个 ≈21k）/ custom 白名单，用环境变量 `TASK_MASTER_TOOLS` 控制，宣称 core 模式省 ~70% token。
- **形态**：npm 包 + MCP server（stdio），Claude Code 插件、Gemini CLI 等；另有 loop 命令让 agent 自主循环执行。

**vs vibe-workflow 差异**：

| 维度 | vibe-workflow 有而 task-master 没有 | task-master 有而 vibe-workflow 没有 |
|---|---|---|
| 门禁/状态机 | 决策 Gate、Release 状态机、两权分立 | 无产品级门禁（纯任务队列） |
| 记忆模型 | docs/vibe/ 事实源 + 封存 Release | 单一 tasks.json，无 living docs |
| 追踪链 | REQ/AC→证据 | 无规格层（PRD 是自由文本） |
| 复杂度路由 | Tiny/Bounded/Architectural 规则 | **复杂度分析 + 任务粒度自动调整** |
| 任务操作 | 计划文件静态拆解 | **expand/expand-all、dependencies、next、跨 tag 移动、research** |
| 上下文治理 | 三级 Pack（读哪些文件） | **MCP 工具分层加载（暴露哪些能力）** |
| 可执行性 | 纯 skill | CLI + MCP + 自主 loop |

### 2.3 BloopAI/vibe-kanban — 看板式任务跟踪

- **仓库**：https://github.com/BloopAI/vibe-kanban ｜ **star ≈ 28.1k**（3.0k forks，Apache-2.0）
- **⚠️ 重要状态**：README 头条即 **"Vibe Kanban is sunsetting"**（已宣布停运，见 vibekanban.com/blog/shutdown），但机制仍值得借鉴。
- **定位**：给 vibe coding 的可视化工程管理——"工程师大部分时间在计划与审查 agent，看板就是为此而生"。`npx vibe-kanban` 一条命令启动本地服务（Rust 后端 + Web 前端）。

**核心机制**：

- **看板计划**：kanban issues（创建/优先级/指派/拖拽列），列即工作流状态。
- **Workspace 执行**：每个 issue 可 spin up 一个 workspace，给 coding agent 一个 **分支 + 终端 + dev server** 的隔离执行环境；支持 10+ 编码 agent（Claude Code、Codex、Gemini CLI、Copilot、Amp、Cursor、OpenCode、Droid、CCR、Qwen Code）。
- **Review 闭环**：查看 diff、行内评论、反馈**直接回传 agent**；内置浏览器 + devtools + 设备模拟预览 app；一键开 PR（AI 生成描述）并 merge。
- **Skill/命令发现机制**（用户关心的点）：VK 的 `discover_custom_command_descriptions()` 会扫描项目级 `<workspace>/.claude/commands/*.md`、`~/.claude/` 及插件目录，读取 frontmatter `description:` 填充 UI；同时 VK 以子进程方式在工作区 spawn 官方 Claude Code CLI，因此 `.claude/skills/*/SKILL.md`、CLAUDE.md 等**原生被 agent 继承**——skill 机制 = "扫描 `.claude/skills/*/SKILL.md` 并在 UI 里按 description 展示 + 原样透传给 agent 执行"。
- **社区 skill**：MCP Market 上有 **Vibe Kanban Orchestrator** skill——监听看板高优先级 To-do、校验依赖、自动开 workspace、监控 workspace 健康与并发上限、对打开的 PR 自动触发 AI code review，即"看板驱动无人流水线"。

**vs vibe-workflow 差异**：

| 维度 | vibe-workflow 有而 vibe-kanban 没有 | vibe-kanban 有而 vibe-workflow 没有 |
|---|---|---|
| 治理 | 决策 Gate、状态机、两权分立、追踪链 | 无规格/门禁/证据概念（issue 即全部） |
| 记忆 | docs/vibe/ 事实源 | 存于自带数据库，非仓库即记忆 |
| 上下文 | Context Governor | 无 |
| **可视化** | 无（纯 Markdown） | **看板 UI + 列↔workspace 一一对应 + 行内 diff 评论回传** |
| **执行环境** | 在宿主 agent 会话内推进 | **每任务独立分支/终端/dev server 的 workspace 隔离 + 并行多 agent** |
| 生态 | 编排外部 skill | 自带 10+ agent 切换 + MCP |

### 2.4 claude-flow — PatrickJS/CLAUDE-FLOW 不存在，真身是 ruvnet/claude-flow → ruflo

- **PatrickJS/CLAUDE-FLOW**：**404，仓库不存在**（已核实）。
- **真身**：`ruvnet/claude-flow`（历史名）已更名 **`ruvnet/ruflo`**：https://github.com/ruvnet/ruflo ｜ **star ≈ 72.2k**（8.5k forks，MIT）。README 原话 "Claude Flow is now Ruflo"。
- **定位**：多 agent 编排的"agent meta-harness"（Agent = Model + Harness），给 Claude Code / Codex 加 98 个专职 agent、swarm 协同（Queen/Topology/Consensus）、自适应记忆（AgentDB + HNSW + SONA）、27 hooks、跨机 federation、约 314 个 MCP 工具、Web UI。
- **对 vibe-workflow 最有参考价值的机制**：**Goal Planner（goal.ruv.io，GOAP A\* 规划）**——用自然语言目标 → 提取成功标准/约束/前置条件 → 在状态空间做 A\* 搜索生成"动作树"计划 → 每个动作节点映射到 MCP 工具 → 失败/状态变化时**从当前状态重规划而非从头再来**，计划树可折叠展示进度、阻塞分支与回滚。
- 也有 `ruflo-goals` 插件（"Break big goals into plans and track progress"）与 `ruflo-workflows`（可复用多步任务模板）。
- 附带说明：另有一个 `kodflow/claude-flow`（同名山寨，规模小），非主流。

**vs vibe-workflow 差异**：ruflo 是重型 swarm 运行时（记忆/共识/联邦），几乎不含产品门禁与规格治理；其 GOAP"失败即从当前状态重规划"与 vibe-workflow 的 Circuit Breaker 互补（见建议 7）。

### 2.5 flow-eng/flow — 不存在；实际对应 Rene-Kuhm/flow-engineering

- **`flow-eng/flow`**：**404，不存在**（已核实）。
- **概念来源**：Flow Engineering 是方法论概念（AlphaCodium 论文 "From Prompt Engineering to Flow Engineering"：把 LLM 流程拆成多步骤编排与验证）。
- **现存最接近的仓库**：**Rene-Kuhm/flow-engineering**：https://github.com/Rene-Kuhm/flow-engineering ｜ 新项目（v0.1→v1.3，star 少、未核实具体数），Python CLI（`flow`，pip 包 `flow-engineering`），MIT。
- **核心机制**：闭环 **INTENT → CONTEXT → SPEC → APPLY → VERIFY → ARCHIVE**；显式状态机 `NEW → EXPLORED → PROPOSED → DESIGNED → SPECIFIED → TASKED → APPLYING → VERIFYING → ARCHIVING → DONE`（与 vibe-workflow 状态机同构！）；命令 `flow new/propose/design/spec/tasks/apply/verify/archive`；**drift detector**（对比 spec ↔ tasks ↔ apply-progress ↔ code，规格漂移标 CRITICAL）；**snapshot manager**（字节级确定性图快照，sha256 锁定，可 rollback）；严格 TDD（每次提交后跑测试，红构建不提交）；基于 SpecKit 的 constitution 治理（8 条宪法，sub-agent 动工前必读）；可选 MCP server + skill；OpenCode 插件在检测到 change 目录时给 agent 注入"先跑 flow status"的一次性提醒。
- **vs vibe-workflow 差异**：它同样重视"验证 + 归档 + 漂移检测"，但缺 Human Gates 与上下文治理；vibe-workflow 缺它的 **drift detector 与快照回滚**（见建议 3、7）。

### 2.6 github/spec-kit — 追加发现的最重量级同类（官方背书）

- **仓库**：https://github.com/spec-kit（github org）｜ **star ≈ 135.8k**（12.2k forks，301+ 贡献者，MIT）——所有同类中体量最大，GitHub 官方维护。
- **定位**：SDD 工具包，"Define what to build before building it — with any AI coding agent"，Python CLI `specify`（`uv tool install specify-cli`）。
- **核心机制**：
  - 工作区 `.specify/`（templates 优先级栈：project override > preset > extension > core）+ 产物 `spec.md`（user stories + FR + success criteria）、`plan.md`、`research.md`、`data-model.md`、`contracts/`、`tasks.md`（**T001-T0NN 依赖排序任务**）、constitution（治理原则）。
  - Slash 命令/技能：`/speckit.constitution`（治理原则）、`/speckit.specify`（需求）、`/speckit.plan`（技术方案）、`/speckit.tasks`（任务）、`/speckit.taskstoissues`（任务转 GitHub issues）、`/speckit.implement`、**`/speckit.converge`（对照 spec/plan/tasks 扫描代码库，把缺口追加为新任务）**、`/speckit.clarify`、`/speckit.analyze`（跨产物一致性）、`/speckit.checklist`。
  - **扩展体系**：extensions（加能力）/ presets（改格式）/ bundles（按角色一键装整套：product-manager、developer、security-researcher…），社区目录 + 优先级解析。
  - OpenSpec 对标它"thorough but heavyweight, rigid phase gates"；社区也有批评声音（"illusion of work"——生成大量无法被 LLM 遵守的 MD）。
- **vs vibe-workflow 差异**：spec-kit 强在**生态可扩展 + converge 自动化审计 + 任务转 issue**；vibe-workflow 强在门禁/上下文/证据链。两者理念相反：spec-kit 是"多而全的 phase 产物"，vibe-workflow 是"少而严的 gate"。

### 2.7 其他规格 / 计划 / 任务类项目

| 项目 | 仓库 | 定位与机制 | 对 vibe-workflow 的参考点 |
|---|---|---|---|
| **roadmap-skill** | https://github.com/shiquda/roadmap-skill | "Shared roadmap for humans and AI"：MCP server 让 agent 在对话中创建/更新/查询任务；配套 Roadmap Planning skill 生成 `ROADMAP.md` | 把 PROGRESS.md 变成 agent 可读写的 roadmap 数据源（MCP 化） |
| **mcp-github-project-manager** | https://github.com/kunwarVivek/mcp-github-project-manager | 把 GitHub Projects v2 变成 agent 自主项目管理：自指派任务、跟踪进度、互相 review | vibe-workflow 的 REVIEWING 阶段可对接 GitHub Projects 做外部看板镜像 |
| **codefluent（PM agent）** | https://github.com/frederick-douglas-pearce/codefluent | PM agent 拥有 milestone 生命周期（create/list/update/close），milestone 是 PM 产物而非静态文件 | Release 概念 ↔ GitHub milestone 双向同步（见建议 8） |
| **AutomationPanda/gherkin-guidelines-for-ai** | https://github.com/AutomationPanda/gherkin-guidelines-for-ai | 给 AI 的 Gherkin 场景书写规范（Given/When/Then 可读性规则），可挂进 rules/skills | 作为 vibe-workflow SPEC 模板里 Scenario 书写的质量标准 |
| **BDD Test Spec Generator**（skill） | https://mcpmarket.com/tools/skills/bdd-test-specification-generator | 用 case → Gherkin Feature 文件映射，自动生成**traceability matrix**（场景 ↔ 需求） | 与 vibe-workflow 的 REQ→AC→测试→证据链互补：可自动产出追踪矩阵 |
| **oh-my-openagent（OmO）** | https://github.com/code-yeongyu/oh-my-openagent | OpenCode 编排 harness：IntentGate 注入模式、Sisyphus 总编排 + 分类子 agent、plan/execute 分离（Prometheus 计划 → Atlas 执行） | "plan 与 execute 用不同 agent 会话"的分权思路 |
| **AGENTS.md 约定** | openagents（多家生态） | 仓库级 agent 指令文件标准，多工具自动读取 | vibe-workflow 已有 AGENTS.md 索引，可对齐标准命名 |
| **todo.txt** | https://github.com/todotxt/todo.txt | 经典纯文本任务文件约定（优先级、上下文、项目标签） | 轻量任务文件的跨工具可移植性 |
| **Kiro（AWS）/ BMAD** | kiro.dev（闭源 IDE） | AWS 的 agentic IDE，内建 spec/plan 循环，锁定 Claude 模型（OpenSpec README 对标对象） | 反面教材：绑定 IDE/模型 = 生态封闭 |

---

## 3. 能力矩阵（横向对比）

| 能力 | vibe-workflow | OpenSpec | task-master | spec-kit | vibe-kanban | ruflo | flow-engineering |
|---|---|---|---|---|---|---|---|
| 形态 | 纯 Skill | npm CLI+skills | npm+MCP | Python CLI+skills | 桌面 Web 应用 | CLI+MCP+Web | Python CLI+MCP |
| star（约） | 新项目 | 68k | 28.1k | 135.8k | 28.1k（停运） | 72.2k | 少 |
| 显式状态机 | ✅ Release 9 态 | ❌ artifact 图 | ❌ tag 队列 | ❌ 阶段产物 | ✅ 看板列 | ⚠️ GOAP 计划树 | ✅ 10 态 |
| 人类决策 Gate | ✅ 4 类硬门禁 | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| 验证/发布分权 | ✅ 两权分立 | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| 上下文治理 | ✅ 三级 Pack | ⚠️ 建议性 | ✅ MCP 工具分层 | ❌ | ❌ | ⚠️ 记忆系统 | ❌ |
| 需求追踪链 | ✅ REQ→证据 | ⚠️ req+scenario | ❌ | ⚠️ FR→tasks | ❌ | ❌ | ⚠️ drift |
| 增量表达（delta） | ⚠️ CHANGE.md 文本 | ✅ 结构化 delta | ❌ | ⚠️ 多产物 | ❌ | ❌ | ⚠️ |
| 一致性审计 | ⚠️ 人工 VERIFICATION | ✅ /opsx:verify | ❌ | ✅ converge/analyze | ❌ | ⚠️ | ✅ drift detector |
| 快照/回滚 | ⚠️ Last Known Good | ❌ | ❌ | ❌ | ⚠️ git worktree | ⚠️ | ✅ snapshot sha256 |
| 可视化 | ❌ | ❌（dashboard 存在） | ❌ | ❌ | ✅ 看板+diff 评论 | ✅ Web UI | ❌ |
| 任务复杂度路由 | ✅ Tiny/Bounded/Arch | ❌ | ✅ Tiny/Med/Complex | ❌ | ❌ | ⚠️ | ❌ |
| 生态扩展 | ⚠️ skill 编排 | ⚠️ community schemas | ⚠️ 插件 | ✅ presets/ext/bundles | ✅ 多 agent | ✅ 35 插件 | ❌ |

---

## 4. 对 vibe-workflow 的优化建议（可操作）

### 建议 1：采纳 OpenSpec 的 change 命名规范 + 结构化 delta（改 CHANGE.md）
把 Release 目录从 `releases/<id>/` 改为 **`releases/<YYYY-MM-DD>-<kebab-id>/`**（OpenSpec 归档命名），并在 `CHANGE.md` 中引入**结构化 delta 段**：`## ADDED` / `## MODIFIED` / `## REMOVED`，每条 REQ 配 `### Scenario: xxx`（WHEN/THEN）。收益：归档可排序可检索、Spec 与 CHANGE 的 diff 可机器解析（为建议 3 的自动化审计铺路）。同时在 SPEC.md 模板写入 OpenSpec 式命名禁令：禁止 `update`/`changes`/`wip` 这类无信息量 ID。

### 建议 2：把 PLANNED 阶段改成"artifact 依赖图"驱动的增量生成（借鉴 OpenSpec continue/ff）
vibe-workflow 现在倾向一次性产出 PROJECT_BRIEF→SPEC→DESIGN→PLAN。改为维护一个**轻量状态表**（`docs/vibe/RELEASE_STATE.md` 或并入 PROJECT.md）：每个 artifact 标注 `done / ready / blocked`（blocked 原因=缺哪个上游 artifact），并给出两种推进模式——`incremental`（一次只生成一个，人工审完再继续，对应 Architectural 任务）与 `fast-forward`（一次全生成，对应 Tiny/Bounded）。这让"计划中断后恢复"有明确断点，且与 Context Governor 的 Resume Pack 天然衔接。

### 建议 3：新增"Convergence Check"作为 VERIFYING 的自动化前置步骤（借鉴 spec-kit converge + flow-engineering drift）
VERIFYING 阶段先跑一个结构化检查，输出 **CRITICAL / WARNING / SUGGESTION 三级报告**（不阻断，供 REVIEWING 人类审查）：
- 逐条 REQ/AC 在代码库中搜索实现证据（grep 测试、符号、文档锚点），标出无证据项（Completeness）；
- 对照 PROPOSED_DESIGN 检查实现是否偏离既定决策（Coherence，如"设计用 CSS variables 实现用了 Tailwind"这类漂移）；
- 把缺口**追加**为新任务（spec-kit converge 的做法：append-only，不改已完成任务）。
这份报告直接作为 VERIFICATION.md 的第一节，让"证据核验"从纯人工变成"人工审机器报告"。

### 建议 4：补齐任务级操作原语：expand + 依赖图 + 机器可解析任务 ID（借鉴 task-master）
Architectural 任务强制走 **expand**：把粗任务递归细化为子任务，每子任务带 `depends_on` 与验收点；所有任务用稳定 ID（`T001`…，spec-kit 同款）写入 IMPLEMENTATION_PLAN.md，REQ/AC 引用 ID 而非自由文本。收益：REQ→AC→任务→测试→证据链首次获得**机器可解析的引用面**（建议 3 的检查器直接消费它），也为未来的外部看板/issue 同步（建议 8）提供键。

### 建议 5：把 Context Governor 从"读哪些文件"扩展到"暴露哪些能力"——命令白名单分层（借鉴 task-master MCP 工具分层）
task-master 用 `core(7 工具/5k tokens) / standard(15/10k) / all(36/21k)` 显式分层。vibe-workflow 可定义 **Governance Level**：Tiny 任务只允许单点命令集（推进/记录证据/熔断上报），Bounded 追加计划/验证命令，Architectural 才暴露完整编排命令（含 Gate 流程、变更回退链）。配合现有三级 Pack：**Pack 决定注入哪些文件，Level 决定允许哪些动作**，两者正交。文档里给出每 Level 的命令白名单表格，并说明降级规则（外部 skill 缺失时的最小等价命令）。

### 建议 6：产出可渲染的看板文件，复用现有生态的可视化（借鉴 vibe-kanban，但明确不造 GUI）
vibe-workflow 不应重造 vibe-kanban 式桌面应用（对方已停运、工程量巨大），但可以**生成并维护 `docs/vibe/BOARD.md`**：列 = 状态机 9 态，卡片 = 任务（含 ID、依赖、阻塞标记、所属 REQ），由 PROGRESS/PLAN 自动派生、每次状态迁移时刷新。任何 Markdown 看板渲染器（VS Code Markdown 插件、GitHub Projects 导入、obsidian 看板）可直接消费。同时把 REVIEWING 阶段升级为"diff review 模板"：给出行内评论锚点格式与反馈回传协议（评论 → 转为任务 → 回到 BUILDING），模拟 vibe-kanban 的 review 闭环，但留在仓库内。

### 建议 7：让 Circuit Breaker 从"回退重试"升级为"以快照为新基线重规划"（借鉴 ruflo GOAP + flow-engineering snapshot）
当前熔断动作是"回退 Last Known Good + REPLAN_REQUIRED"。升级为三步：
1. 熔断时强制生成**Debug Snapshot**（结构化：symptom / repro / attempts / diff 摘要，落盘 `docs/vibe/bugs/BUG-xxx.md`，并登记进追踪链让后续 Task Context Pack 可检索——实现"失败记忆"，而非一次性的聊天记录）；
2. 以 Last Known Good State 为新基线**重写** IMPLEMENTATION_PLAN（不是重跑旧计划），只保留未完成且仍成立的 REQ/AC；
3. 记录"此路径为何失败"到 decisions/，防止同一错误换参数重试被包装成合法 Retry（现有宪法已禁止，但缺少归档载体）。
对应 flow-engineering 的 sha256 快照回滚：至少为 `docs/vibe/releases/` 关键产物提供 git tag 级别的确定性回滚点说明。

### 建议 8：定义"阶段 → 工具/模板"的 preset 覆盖层，并对接 GitHub issue/milestone（借鉴 spec-kit presets + codefluent PM）
- 引入 `docs/vibe/presets/<name>/` 覆盖层：项目可覆盖某阶段模板（合规团队的 VERIFICATION 模板、金融团队的安全 Gate checklist、BDD 团队把 SPEC 场景换成 Gherkin 语法——直接引用 AutomationPanda 的 gherkin-guidelines-for-ai 作为书写规范），核心 skill 不变，按"项目 override > 内置"解析（spec-kit 的优先级栈思想，但保持纯 Markdown）。
- 把"外部 skill 调用表"（grill-me / superpowers 系列）变成**可配置映射**（`docs/vibe/presets/ecosystem.json`），团队可替换首选 skill，缺失时仍走现有降级路径。
- 可选增强：定义 Release ↔ GitHub milestone 的双向映射约定（RELEASED 时关闭 milestone，REQUIREMENTS_FROZEN 时创建），REVIEWING 完成的 PR 列表作为 VERIFICATION 证据附件——让仓库事实与外部协作系统对齐，但保持"仓库是唯一事实源"。

### 附：不建议做的事
- 不要给 vibe-workflow 引入运行时依赖来模拟 OpenSpec/spec-kit 的 CLI——"纯 skill、零安装"是它相对所有竞品的核心差异化优势（对标 spec-kit 社区"illusion of work"批评：产物越多、被 LLM 遵守的概率越低）。工具化可以做成**可选的、无依赖的**（如 validate_skill.sh 这类已存在的本地脚本），而不是必需项。
- 不要模仿 OpenSpec"enablers, not gates"取消门禁——那正是 vibe-workflow 的护城河，竞品都缺。

---

## 5. 参考 URL 汇总

**主目标**
- OpenSpec：https://github.com/Fission-AI/OpenSpec ｜ overview: https://github.com/Fission-AI/OpenSpec/blob/main/docs/overview.md ｜ commands: https://github.com/Fission-AI/OpenSpec/blob/main/docs/commands.md
- claude-task-master：https://github.com/eyaltoledano/claude-task-master ｜ 产品页: https://tryhamster.com/product/taskmaster
- vibe-kanban：https://github.com/BloopAI/vibe-kanban ｜ 停运公告: https://www.vibekanban.com/blog/shutdown ｜ 技能机制讨论: https://github.com/BloopAI/vibe-kanban/discussions/2389 ｜ Orchestrator skill: https://mcpmarket.com/tools/skills/vibe-kanban-orchestrator
- claude-flow 真身（ruflo）：https://github.com/ruvnet/ruflo （原 https://github.com/ruvnet/claude-flow）｜ GOAP 规划: https://goal.ruv.io/ ；PatrickJS/CLAUDE-FLOW 与 flow-eng/flow 均为 404，不存在
- flow-engineering（Rene-Kuhm）：https://github.com/Rene-Kuhm/flow-engineering
- github/spec-kit：https://github.com/github/spec-kit ｜ 文档: https://github.github.com/spec-kit/

**其他**
- roadmap-skill：https://github.com/shiquda/roadmap-skill
- mcp-github-project-manager：https://github.com/kunwarVivek/mcp-github-project-manager
- codefluent（PM milestone）：https://github.com/frederick-douglas-pearce/codefluent
- Gherkin Guidelines for AI：https://github.com/AutomationPanda/gherkin-guidelines-for-ai ｜ 配套文章: https://automationpanda.com/2026/04/27/bdd-gherkin-guidelines-for-ai-coding-and-testing/
- BDD Test Spec Generator：https://mcpmarket.com/tools/skills/bdd-test-specification-generator
- oh-my-openagent：https://github.com/code-yeongyu/oh-my-openagent
- Kiro（AWS）：https://kiro.dev/ ｜ Flow Engineering 概念（AlphaCodium）：https://arxiv.org/abs/2311.01505（"From Prompt Engineering to Flow Engineering"）
