# vibe-workflow 竞品调研（二）：Agent 记忆 / 上下文管理 / 验证与质量保障

> 调研时间：2026-09-12（star 数为该时点抓取值，标注「约」；部分数值与《docs/competitive-analysis-2026-09.md》交叉验证一致）
> 工具说明：会话中 `web_search` 工具不可用（API 404），全部检索改用 firecrawl（search/scrape + developer search）；GitHub REST API 被共享 IP 限流，star 数取自仓库页面抓取。
> 口径：本报告聚焦 **「记忆组织 / 上下文最小化 / 完成前验证 / 跨会话状态恢复 / 证据持久化」** 这一条生态线，与既有报告（技能型/指令型工作流框架：superpowers、grind、AGENTS.md、ruflo 等）互补，不重复。
> 对照基准：vibe-workflow（sz-xiaohuolong/vibe-workflow，v0.1）——纯指令型 Skill，核心概念 = Context Governor、Repository is memory、Verification 门禁、Circuit Breaker、Release 封存、Skill TDD、Requirement Traceability。

---

## 一、跨会话记忆：仓库 / 文件即记忆（与 vibe「Repository is memory」最直接对照）

### 1. basic-memory —— Markdown 知识库即记忆
- **仓库**：<https://github.com/basicmachines-co/basic-memory>（约 3.9k★，日更活跃）
- **定位**：「AI conversations that actually remember」——把本地 Markdown 文件当作 agent 的长期记忆，反对中心化记忆库。
- **核心机制**：纯 Markdown 文件 + **frontmatter 元数据** + **wiki 风格双链**构成可导航的知识图谱；通过 **MCP 工具**（建笔记、语义搜索、读图）按需读写；本地嵌入模型做语义检索，无中心 DB——**文件本身就是真相源**。
- **对照 vibe**：与「仓库即记忆」理念完全同构，但面向「知识条目」而非「工作流状态」。它证明：不用引入数据库，用「frontmatter + 双链 + 语义检索」就能让文件成为可检索的记忆。

### 2. Cline Memory Bank（官方模式，生态标杆）
- **仓库**：<https://github.com/cline/cline>（约 67.9k★）；规范文档 <https://docs.cline.bot/best-practices/memory-bank>
- **定位**：用一组固定命名的 markdown 文件，让 agent 跨会话保持项目记忆。
- **核心机制**：六份文件分工——`projectbrief.md`（目标/范围）、`productContext.md`（为什么做）、`activeContext.md`（当前焦点/最近变更/下一步，**更新最频繁**）、`systemPatterns.md`（架构/设计模式）、`techContext.md`（技术栈/约束）、`progress.md`（已完成/未完成/已知问题），入口 `CLAUDE.md` 引用。更新触发时机：发现新模式、发生重大变更、用户要求 "update memory bank"、上下文需要澄清。
- **生态延伸**：
  - **Roo Code**（<https://github.com/RooCodeInc/Roo-Code>，约 24.3k★）内置同样 Memory Bank + **Checkpoints**（git 时间线回滚）。
  - **directed-memory-bank**（<https://github.com/pmikutel/directed-memory-bank>，新项目）：把 Memory Bank 泛化成**工具无关**的 `memory-bank/` 目录（`knowledge/project/` + `knowledge/technical/` + `tasks/work/` + `tasks/log/` + `_index.md` 清单），Claude Code / Cursor / Codex 各自用入口文件（CLAUDE.md / .cursor/rules / AGENTS.md）引用同一份记忆——口号「**Sessions resume, they don't restart**」。

### 3. claude-flow（git 即记忆层）→ 现 ruflo
- **仓库**：原 `sleepycatcoding/claude-flow` 已迁移/下线（404）；社区维护分支 **ruvnet/ruflo**（<https://github.com/ruvnet/ruflo>，约 72k★，见既有报告）与 rsham004/claude-flow。
- **定位**：把 **git 当作记忆层** 的 meta-harness（Claude Code + Codex 双宿主）。
- **核心机制**：markdown **记忆库 + 会话日志（session logs）+ flow/TODO 状态**，跨会话通过 **git 提交/恢复**同步——与 vibe 的「Repository is memory, chat is conversation」几乎逐字对应；ruflo 分支新增：**Context Autopilot**（上下文占用 70% 告警 / 85% 剪枝、压缩恢复预算）、CLAUDE.md 规则门禁（gates）、防篡改证明链（proof chain）、HNSW 语义记忆库。
- **对照 vibe**：vibe 的 Resume Pack 就是 claude-flow「会话日志 + git 恢复」的指令化版本，但 claude-flow 把「收尾写日志、启动读日志」做成了强制流程。

### 4. claude-mem（现名 Grok Mem）—— 捕获 → 压缩 → 注入
- **仓库**：<https://github.com/thedotmack/claude-mem>（约 94k★，已更名 Grok Mem）
- **定位**：跨会话持久上下文注入器，适配 Claude Code / Codex / Gemini / Copilot / OpenCode 等。
- **核心机制**：**捕获**会话中 agent 的一切行为 → **AI 压缩**成记忆 → 存 SQLite（+ Chroma 向量库混合检索）→ 未来会话启动时**注入**相关上下文；worker 服务后台同步。
- **对照 vibe**：与 Resume Pack 目标相同，但走「全量捕获 + 自动压缩」路线（机器生成），而 vibe 走「主动维护文档」路线（人/agent 共识）。两者可互补：自动捕获做素材，主动文档做裁决。

### 5. 记忆读写指令协议：memory-graph / agentmemory
- **memory-graph**（<https://github.com/memory-graph/memory-graph>）：图库 MCP memory server，给 coding agent 一份**显式协议**——工作前 `recall`/`briefing`；决策/修复/错误时 `store`（类型：solution/problem/fix/error/workflow/command + tags）；**会话结束强制存 conversation 摘要**。附带的 AGENTS.md 指令片段就是「何时写记忆、何时读记忆」的可执行规范。
- **agentmemory**（<https://github.com/rohitg00/agentmemory>）：面向 coding agent 的持久记忆，知识图谱 + 实体抽取 + BFS 遍历，54 个 MCP 工具。

## 二、Agent 记忆框架（运行时记忆，非仓库文件）

### 6. Letta（原 MemGPT）—— 核心/归档记忆分层
- **仓库**：<https://github.com/letta-ai/letta>（约 24.7k★）；理论基础：MemGPT 论文 *Packing Virtual Context into Limited Space*（<https://arxiv.org/abs/2410.17276>）
- **定位**：状态化 agent 平台，agent 能自我学习与改进。
- **核心机制**：**核心记忆块（core memory blocks：persona / human / archival）常驻**，agent 用 memory-edit 工具**自我编辑**核心记忆；**archival memory** 超出窗口后按需检索召回；**心跳 + 上下文压缩（context compaction）**；**sleep-time agents** 在空闲时后台整理记忆。MemGPT 的「packing」思想 = 把大段虚拟上下文压缩打包进有限窗口。
- **对照 vibe**：为 Context Governor 提供理论框架——**常驻最小集（core）vs 归档按需检索（archival）**，以及「压缩恢复预算」概念。

### 7. mem0 —— 生产级记忆层
- **仓库**：<https://github.com/mem0ai/mem0>（约 65.2k★）
- **定位**：「The Memory Layer for AI Agents」——drop-in 记忆基础设施。
- **核心机制**：显式 **ADD / UPDATE / DELETE / GET** 操作；**User / Session / Agent 三种作用域**；**历史跟踪**（同一事实反复出现时合并更新、保留历史，而非无脑覆盖）；向量存储（Qdrant 等）+ **图记忆**（实体链接）；自托管或云。
- **对照 vibe**：记忆条目应带作用域与历史版本——对应 vibe 的「决策记录不应被覆盖，而应追加修订」。

### 8. Zep / Graphiti —— 双时态知识图谱
- **仓库**：<https://github.com/getzep/graphiti>（约 30.8k★）；Zep 本体 <https://github.com/getzep/zep>（约 4.9k★）
- **定位**：为 agent 构建实时、随时间演进的知识图谱。
- **核心机制**：**双时态模型（bi-temporal）**——事实带「有效时间窗（valid/expiry）」+「事件发生时间」；**episodes**（事件流）→ 抽取 facts；**实体消歧**；**混合语义检索**。事实过期自动失效，图谱反映「当时」而非「现在」。
- **对照 vibe**：直接支撑「Release 封存 vs living docs 描述当前」——**封存产物 = 有效时间永不失效的只读事实；living docs = 当前有效时间窗内的事实**。

### 9. LangMem（LangChain）
- **仓库**：<https://github.com/langchain-ai/langmem>（约 1.7k★）
- **定位**：LangChain 生态的长期记忆 SDK。
- **核心机制**：`create_manage_memory_tool` / `create_search_memory_tool` 让 agent 在会话中主动读写记忆；**后台 memory manager** 自动提取与整合；接入 LangGraph Long-term Memory Store。
- **对照 vibe**：启示「**agent 主动写 + 后台自动整理**」双通道——vibe 目前只有「agent 主动写」。

## 三、验证与质量保障（Verification / CI for agents）

### 10. SWE-bench / SWE-bench Verified —— 完成判定的行业标准
- **仓库**：<https://github.com/SWE-bench/SWE-bench>（约 5.8k★）；持续更新版 <https://github.com/microsoft/swe-bench-live>
- **定位**：真实 GitHub issue 的 coding agent 基准与评估规范。
- **核心机制**：任务 = **问题陈述 + base commit + gold patch + test patch**；评估在 Docker 隔离环境跑 **FAIL_TO_PASS + PASS_TO_PASS**——修复必须让原本失败的测试变绿，且不破坏其他测试；**SWE-bench Verified** = 500 个人类确认可解的子集。
- **对照 vibe**：Verification 门禁可形式化为 **FAIL_TO_PASS 判定**：不是「测试全绿」或「agent 说完成了」，而是「新增/指定的验证用例从失败→通过」。

### 11. SWE-agent
- **仓库**：<https://github.com/SWE-agent/SWE-agent>（约 20.3k★，NeurIPS 2024）
- **核心机制**：**Agent-Computer Interface（ACI）**（为 agent 定制受控命令集）+ **Docker 沙箱** + 测试评估。证明「给 agent 一个可复现的执行/验证环境」是可靠完成判定的前提。

### 12. OpenHands
- **仓库**：<https://github.com/OpenHands/OpenHands>（原 All-Hands-AI/OpenHands，约 87.4k★）
- **定位**：自托管 agent 开发控制中心（Agent Canvas + Agent Server REST API + **Automation Server 定时/事件驱动** + 沙箱，ACP 兼容）。
- **对照 vibe**：启示「**事件驱动自动化**」——Release 后自动触发回归验证，而不是等人/agent 想起。

### 13. AutoPR —— 验证作为显式工作流阶段
- **仓库**：<https://github.com/irgolic/AutoPR>（2023 年项目，已停更/归档，star 未核实）
- **定位**：最早的 issue→PR 自动化 agent（「AutoPR autonomously wrote pull requests in response to issues」）。
- **核心机制**：多步 agent 工作流中把 **lint / build / test 作为显式验证阶段，验证通过才开 PR**——验证是流程中的一等公民 stage，而非事后口头承诺。
- **备注**：同类当前主流为 PR 评审方向（如 <https://github.com/qodo-ai/pr-agent>、GitHub Copilot code review）。

### 14. Aider —— 每步验证 + 每步提交
- **仓库**：<https://github.com/Aider-AI/aider>（约 48.9k★）；验证文档 <https://aider.chat/docs/usage/tests.html>
- **核心机制**：`--test` / `--lint` / `--auto-test` 在每次编辑后自动运行验证，失败自动进入修复循环；**每次变更自动 git commit**——git 历史即证据链；architect/editor 双角色分工。
- **对照 vibe**：正是「Verification 门禁 + Circuit Breaker」的宿主侧落地形态：**改一步、验一步、提交一步**，回退点永远存在。

### 15. Plandex —— plan/apply/verify 循环
- **仓库**：<https://github.com/plandex-ai/plandex>（约 15.6k★）
- **核心机制**：先出计划文件 → apply 变更 → 跑 **test command** 验证 → 失败回退；git 记录状态支持 **rollback**。验证显式成为完成条件。

### 16. Wolverine —— 最早的 verify-loop（已归档）
- **仓库**：<https://github.com/biobootloader/wolverine>（约 5.1k★，已归档并推荐 Mentat）
- **机制**：运行测试 → GPT-4 读错误自动修复 → 重跑直到通过。2023 年的先驱，「验证失败→自动修复→重验」循环的鼻祖，已被 Aider/Plandex/Claude Code 生态吸收。

### 17. AgentOps —— agent 可观测性
- **仓库**：<https://github.com/AgentOps-AI/agentops>（约 5.8k★）
- **定位**：AI agent 监控（会话/LLM 调用/成本）+ 基准评测（gauntlet）+ evals。
- **机制**：追踪 agent 轨迹与工具调用，把「发生了什么」变成可审计证据——对应 vibe 对「fresh evidence」的要求：证据要有来源、可回放。

### 18. Braintrust / Autoevals —— 评估评分器
- **仓库**：<https://github.com/braintrustdata/autoevals>（约 1.0k★）；平台 <https://www.braintrust.dev>
- **机制**：**LLM-as-judge / 启发式 / 统计**三类评分器（factuality、safety、语义相似等），Python/TS，可离线运行、结果可上传对比；平台侧把离线实验与生产日志做回归对比。

### 19. DeepEval —— pytest for LLMs
- **仓库**：<https://github.com/confident-ai/deepeval>（约 18.2k★）
- **定位**：「LLM 应用的 pytest」。
- **核心机制**：**pytest 集成**的 LLM 单元测试 + 指标断言（G-Eval、事实一致性、幻觉检测等）+ dataset / CI 集成；支持对完整 agent 轨迹做端到端黑盒评估。
- **对照 vibe**：与 **Skill TDD（25 个对抗性行为测试场景，tests/scenarios.md）** 直接对应——把「文档化场景清单」升级为「可执行断言 + 指标」。

### 20. Claude Code 官方验证设施（/verify、hooks、checkpoints）
- **机制**（官方 changelog 佐证见 <https://github.com/cranot/claude-code-guide>）：内置 **`/verify` 与 `/code-review`** 命令（原自动运行，后改为显式调用）；**checkpoints**（自动 git 快照，可回滚）；**hooks**（PreToolUse / PostToolUse 可在每次工具调用后强制跑验证）；TDD 工作流。社区验证门禁模式：Ralph loops（`verify:"npm test"`，以 **exit code 判 SUCCESS**、失败重试，见 <https://github.com/minipuft/claude-prompts/blob/main/docs/guides/ralph-loops.md>）；TDD Guard MCP 等。
- **对照 vibe**：「验证命令 + exit code 门禁 + 检查点回滚」三件套，正是 vibe Verification 门禁在宿主上的落地形态——**vibe 应当把这条链路写成可执行约定**。

## 四、上下文管理与按需加载（Context Governor 侧）

### 21. Repomix —— 仓库打包 + 压缩
- **仓库**：<https://github.com/yamadashy/repomix>（约 28.3k★）
- **机制**：整个仓库打包成单文件（XML / Markdown / JSON / Plain）；尊重 .gitignore / .repomixignore；**Tree-sitter 语法级压缩**（只保留关键结构）；Secretlint 敏感信息扫描。
- **对照 vibe**：Context Governor 的「最小上下文」可借用「打包 + 语法压缩 + 安全扫描」策略——Resume/Task Pack 不必是整文档，可以是压缩摘要 + 指针。

### 22. Context7（Upstash）
- **仓库**：<https://github.com/upstash/context7>（约 61.9k★）
- **机制**：MCP server 提供最新第三方库文档，**检索 + 缓存 + 上下文压缩**，避免把文档全文灌入窗口。

### 23. 官方 MCP memory server 与 KG-memory 生态
- **仓库**：<https://github.com/modelcontextprotocol/servers>（约 90.3k★）的 `src/memory`
- **机制**：knowledge graph（**entities / relations / observations**）+ 工具（create_entities / add_observations / search_nodes / open_nodes / read_graph）+ JSONL 持久化。围绕它有大量 KG-memory MCP 变体（清单见 <https://github.com/TensorBlock/awesome-mcp-servers/blob/main/docs/knowledge-management--memory.md>，如 memex、graph-memory-mcp 等）。

### 24. AGENTS.md / CLAUDE.md —— 跨工具记忆载体
- **标准**：<https://agents.md/>（Linux Foundation 旗下 Agentic AI Foundation 维护，6 万+ 项目采用）；仓库 <https://github.com/agentsmd/agents.md>（约 24.3k★，见既有报告）
- **机制**：README for agents；任意 Markdown 结构；**嵌套文件就近优先**；monorepo 友好；Claude Code（CLAUDE.md）、Codex（AGENTS.md）、Cursor 互认。
- **对照 vibe**：vibe 的「入口文件（CLAUDE.md/AGENTS.md）引用状态目录」结构符合该生态，应继续对齐、不发明平行格式。

### 25. Anthropic Skills / Superpowers —— Skill 测试工程化
- **anthropics/skills**（<https://github.com/anthropics/skills>，约 176k★）：SKILL.md frontmatter（name + description）+ 渐进式披露；vibe 的 SKILL.md 已符合规范（见既有报告）。
- **obra/superpowers**（<https://github.com/obra/superpowers>，约 286k★，见既有报告）：内置 **verification-before-completion** 技能（运行命令、读输出、再声称完成）；**superpowers-evals** 用 fresh subagent 对 skill 行为打分，技能改动 **eval-gated**（行为分回退即回滚）——与 vibe 的 Skill TDD 同构但已脚本化、CI 化。

---

## 五、横向小结

| 方向 | 代表项目 | 对 vibe 的关键启示 |
|---|---|---|
| 文件即记忆 | basic-memory、Cline Memory Bank、directed-memory-bank、claude-flow | frontmatter + 双链 + 固定文件集 + git 同步 = 可检索、可恢复的仓库记忆 |
| 运行时记忆框架 | Letta、mem0、Graphiti、LangMem | 核心/归档分层、作用域与历史版本、双时态时间窗、双通道整理 |
| 完成判定 | SWE-bench、SWE-agent、OpenHands | FAIL_TO_PASS + 可复现执行环境 = 验证门禁的形式化标准 |
| 验证自动化 | Aider、Plandex、Wolverine、AutoPR、Claude Code /verify+hooks | 验证命令化 + exit code 门禁 + 每步提交/回退点 |
| 评估与可观测 | DeepEval、AgentOps、Braintrust/Autoevals、Superpowers evals | 可执行断言 + LLM 评分器 + 行为回归门禁 |
| 上下文最小化 | Repomix、Context7、ruflo Context Autopilot | 打包 + 压缩 + 恢复预算 + 阈值告警/剪枝 |
| 记忆协议 | memory-graph、AGENTS.md、MCP memory | 「何时写/何时读」写成显式指令；跨工具入口引用 |

---

## 六、针对 vibe-workflow 的 8 条具体优化建议

以下建议均对照 vibe 现有结构（`skills/vibe-workflow/assets/templates/*.md`、`references/*.md`、`tests/scenarios.md`、`tests/validate_skill.sh`），可直接落地。

### 建议 1：为所有状态文档引入统一 frontmatter + 双链索引（借鉴 basic-memory、directed-memory-bank、Cline Memory Bank）
- 给 `assets/templates/` 下 11 个模板（PROJECT_BRIEF / PROJECT / DECISION / PROPOSED_DESIGN / TECH_DESIGN / IMPLEMENTATION_PLAN / PROGRESS / VERIFICATION / SPEC / BUG / CHANGE）定义统一 YAML frontmatter：`type / status / updated / release_id / traceability（req_id → ac_id → task_id → test_id → evidence_refs）/ parent_links`。
- 新增 `docs/vibe/_index.md`（记忆清单 + 检索入口，仿 directed-memory-bank），文档间用 wiki-links 互链（如 VERIFICATION.md 反向链接到 REQ 与 TASK），形成**人可读、agent 可导航**的轻量知识图谱——不引入数据库，与「仓库即记忆」一致。
- 收益：Requirement Traceability 从「文档内表格」升级为「跨文档可遍历的链」；Context Governor 加载时可按 frontmatter 过滤。

### 建议 2：记忆分层 + 显式恢复预算（借鉴 Letta core/archival、Repomix 压缩、ruflo Context Autopilot）
- 明确**常驻最小集（core）** = PROJECT_BRIEF + active 状态 + 最近 1 条 VERIFICATION 摘要；其余（历史决策、设计、证据）一律归档、按需加载（archival）——写进 `references/context.md`。
- 为 Bootstrap / Resume / Task 三个 Pack 各定**token 预算**（如 Bootstrap ≤ 800、Resume ≤ 2k、Task Pack 按需但给出「目录 + 摘要 + 必要片段」三段式），压缩策略参考 Repomix 的 Tree-sitter 压缩与 ruflo 的阈值：上下文占用 >70% 告警、>85% 剪枝。

### 建议 3：给事实加「双时态」语义（借鉴 Graphiti bi-temporal、mem0 历史跟踪）
- DECISION.md / VERIFICATION.md 每条记录增加 `valid_from / valid_until`（事实有效窗）与 `recorded_at`（事件时间）两个时间戳。
- **Release 封存** = 产物目录 `releases/<id>/` 只读、`valid_until = never`、任何人不得改写；**living docs** = `valid_until` 未过期的当前事实；同一主题的新旧决策并存（旧决策标 `superseded_by`），而不是覆盖删除。
- 收益：彻底解决「历史产物不可篡改 vs living docs 描述当前」的语义冲突，Debug Snapshot 也天然带「当时的事实」时间戳。

### 建议 4：Verification 门禁命令化 + FAIL_TO_PASS 判定（借鉴 Claude Code /verify+hooks、Aider --test/--lint、Plandex verify、SWE-bench）
- 在 SKILL.md 中规定：完成声明前必须运行**项目级 `scripts/verify.sh`**（或等价命令），并把 `exit code + 输出摘要 + 耗时 + 产物 sha256` 自动追加到 VERIFICATION.md 的证据表——**没有 exit code 的「我认为完成」不构成证据**。
- 判定标准采用 **FAIL_TO_PASS**（本次新增/指定的验证用例必须从失败变通过），而不是「整个测试套件恰好绿」；对无测试项目的场景，至少要求 lint/build/类型检查 + 一条可复现的手工验证命令。
- 若宿主支持 hooks（Claude Code PostToolUse），在 SKILL.md 里给出参考配置，把「编辑后自动跑验证」固化成钩子，减少依赖 agent 自觉。

### 建议 5：证据持久化 schema 与 git 绑定（借鉴 SWE-bench task 结构、Aider 自动提交、ruflo proof chain）
- 定义 evidence 条目标准字段：`{command, exit_code, stdout_summary, artifacts[], commit_sha, timestamp, rerunnable}`，写入 `docs/vibe/evidence/<task_id>/`，并被 VERIFICATION.md 引用。
- 对齐 SWE-bench 的 `base_commit / gold_patch / test_patch`：**验证用例本身作为一等公民存档**（哪个测试从失败→通过、在哪个 commit），这样任何后续会话都能重放「当时怎么验证的」。
- 关键产物（Release 目录、验证结果）随 git 提交；预算允许时对 Release 目录做 sha256 清单（对标 ruflo 的防篡改证明链），强化「封存不可篡改」。

### 建议 6：Circuit Breaker 绑定 git 检查点与失败指纹（借鉴 Claude Code / Roo Code checkpoints、Plandex rollback、Aider 每步提交）
- 规则：每次 PATCH 前先打 git 检查点（或强制先 commit），熔断后 Debug Snapshot 记录 `checkpoint_sha` 与回退命令——「STOP PATCHING → 回退重设计」必须能一键 `git checkout` 还原。
- 在 Debug Snapshot 中增加**失败指纹**（对错误类型做归一化，如「同一测试失败 3 次」「同一模块编译错 3 次」），避免「换汤不换药」地数次数；指纹命中即触发熔断，而不是等到第 3 次原始文本相同。

### 建议 7：会话收尾/恢复管线 + 显式记忆读写指令（借鉴 claude-flow 会话日志、claude-mem capture→compress→inject、memory-graph 协议）
- 定义**会话收尾协议**（写进 SKILL.md / routing.md）：每次会话结束强制更新 PROGRESS.md（未完成项、新决策、失败历史）+ 生成 Resume Pack（摘要 ≤ 预算 + 指针）；新会话启动第一步读 Resume Pack，再按需展开——把 claude-flow「git 同步会话日志」和 claude-mem「自动压缩注入」的机制指令化。
- 给 agent 一份**显式记忆读写指令**（仿 memory-graph 的 AGENTS.md 片段）：何时 store（新决策/新失败/新证据）、何时 recall（任务开始、失败重试前）、类型标签（decision/failure/evidence/pattern），直接写入 `references/context.md`。

### 建议 8：Skill TDD 可执行化 + LLM 断言（借鉴 DeepEval pytest 风格、SWE-bench FAIL_TO_PASS、Superpowers eval-gated）
- 把 `tests/scenarios.md` 的 25 个对抗场景从「文档清单」升级为**可执行测试**：每个场景 = 最小 fixture（临时 git 仓库 + 模拟会话消息序列）+ 断言（exit code / 产物文件内容 / 输出消息序列），`tests/validate_skill.sh` 已存在，进一步加 CI（GitHub Actions）与 **FAIL_TO_PASS 回归门禁**（新场景必须从 fail→pass，且旧场景不得回退）。
- 对无法用 shell 判定的行为（如「不得在无证据时声称 DONE」「熔断后必须回退重设计」），引入 **LLM-as-judge 评分器**（借鉴 Autoevals / DeepEval G-Eval / Superpowers evals）：跑真实或模拟会话，用固定评分 prompt 打分，结果存 `tests/results/`，**行为分回退即阻断合并**。

---

## 参考 URL 汇总

**记忆 / 文件即记忆**
- <https://github.com/basicmachines-co/basic-memory>
- <https://github.com/cline/cline>；<https://docs.cline.bot/best-practices/memory-bank>
- <https://github.com/RooCodeInc/Roo-Code>
- <https://github.com/pmikutel/directed-memory-bank>
- <https://github.com/ruvnet/ruflo>（claude-flow 社区分支；原 sleepycatcoding/claude-flow 已下线）
- <https://github.com/thedotmack/claude-mem>
- <https://github.com/memory-graph/memory-graph>
- <https://github.com/rohitg00/agentmemory>

**记忆框架**
- <https://github.com/letta-ai/letta>；<https://arxiv.org/abs/2410.17276>
- <https://github.com/mem0ai/mem0>
- <https://github.com/getzep/graphiti>；<https://github.com/getzep/zep>
- <https://github.com/langchain-ai/langmem>

**验证 / 质量保障**
- <https://github.com/SWE-bench/SWE-bench>；<https://github.com/microsoft/swe-bench-live>
- <https://github.com/SWE-agent/SWE-agent>
- <https://github.com/OpenHands/OpenHands>
- <https://github.com/irgolic/AutoPR>；<https://github.com/qodo-ai/pr-agent>
- <https://github.com/Aider-AI/aider>；<https://aider.chat/docs/usage/tests.html>
- <https://github.com/plandex-ai/plandex>
- <https://github.com/biobootloader/wolverine>
- <https://github.com/AgentOps-AI/agentops>
- <https://github.com/braintrustdata/autoevals>；<https://www.braintrust.dev>
- <https://github.com/confident-ai/deepeval>
- <https://github.com/cranot/claude-code-guide>（Claude Code 官方命令 changelog：/verify、/code-review）
- <https://github.com/minipuft/claude-prompts/blob/main/docs/guides/ralph-loops.md>

**上下文 / 标准 / 生态**
- <https://github.com/yamadashy/repomix>
- <https://github.com/upstash/context7>
- <https://github.com/modelcontextprotocol/servers>（src/memory）
- <https://github.com/TensorBlock/awesome-mcp-servers/blob/main/docs/knowledge-management--memory.md>
- <https://agents.md/>；<https://github.com/agentsmd/agents.md>
- <https://github.com/anthropics/skills>
- <https://github.com/obra/superpowers>

**vibe-workflow 本仓库**：<https://github.com/sz-xiaohuolong/vibe-workflow>；既有调研 <docs/competitive-analysis-2026-09.md>
