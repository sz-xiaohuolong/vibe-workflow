# vibe-workflow 开源竞品调研 · 主报告（整合版）

> 调研时间：2026-09-12 ｜ 调研方式：4 路并行子代理 + firecrawl 检索（本会话 web_search API 不可用；GitHub API 被限流，star 数为页面抓取近似值）
> 本主报告整合四路子报告：
> 1. `docs/competitive-analysis-2026-09.md` — 技能型 / 指令型工作流框架（superpowers、grind、AGENTS.md、ruflo、task-master…）
> 2. `COMPETITIVE_RESEARCH.md` — 规格驱动 / 任务管理 / 看板（OpenSpec、spec-kit、vibe-kanban、flow-engineering…）
> 3. `docs/research-agent-memory-verification-2026-09.md` — 记忆 / 上下文 / 验证与质量保障（basic-memory、Letta、SWE-bench、Aider…）
> 4. 多智能体编排平台（MetaGPT、ChatDev、OpenHands、gpt-pilot、morph、Claude-Squad…）— 见本文件第 2 节

---

## 0. 一句话结论

**vibe-workflow 的差异化护城河是「工程治理密度」：显式 Release 状态机、分类 Human Decision Gates、Verification/Shipping 两权分立、Circuit Breaker、Context Governor、Requirement Traceability——在所有开源同类中独一份。** 竞品强在 vibe 还没有的六个机制：**机器可校验状态、结构化增量（delta）、自动化一致性审计、任务级评审回环、上下文 token 预算、可执行验证（FAIL_TO_PASS）**。优化方向是「保持纯 skill、零运行时依赖的定位，把治理密度工具化」，而不是学竞品做 CLI/框架/看板。

---

## 1. 竞品格局总览（按定位分层）

| 层 | 项目 | star(约) | 一句话定位 | 对 vibe 的关键参考点 |
|---|---|---|---|---|
| **规格驱动** | github/spec-kit | 135.8k | GitHub 官方 SDD 工具包（Python CLI `specify`） | converge 自动审计、presets/bundles 扩展、T001 任务 ID |
| | Fission-AI/OpenSpec | 68k | SDD 规格层（`openspec/` + `/opsx` 命令，30+ 工具） | **结构化 delta（ADDED/MODIFIED/REMOVED）+ 归档命名**；"enablers not gates"（反面教材） |
| **技能框架** | obra/superpowers | ~286k | 技能流水线（TDD/规划/审查/调试），14 harness | 两阶段审查、plan-scoped workspace+ledger、eval-gated 测试 |
| | anthropics/skills | ~176k | Agent Skills 标准本体（agentskills.io） | SKILL.md 上传约束（description≤1024、保留字） |
| **任务/看板** | claude-task-master | 28.1k | 任务系统（tasks.json + MCP） | **机器可校验状态 + 工具分层加载（core 7 工具≈5k tokens）** |
| | BloopAI/vibe-kanban | 28.1k | 看板↔workspace↔10+ agent | ⚠️ **已停运**；可视化/行内 review 闭环（不造 GUI 只借鉴） |
| | GSD | ~23k | spec 驱动命令链 | ⚠️ **已归档**；每任务原子 commit（bisect 出 chaos） |
| **编排/执行** | OpenHands | ~88k | Agent Canvas 多 agent 控制中心 + automation | **Plan Mode 只读规划/写执行分离**、PLAN.md 产物化 |
| | MetaGPT | ~70k | SOP 驱动软件公司（角色流水线） | 产物契约表 + schema 校验（上游产物=下游输入契约） |
| | ruflo（原 claude-flow） | ~72k | agent meta-harness + GOAP 规划 | 失败即从当前状态重规划；Context Autopilot（70%告警/85%剪枝） |
| | ChatDev | ~34k | 虚拟软件公司 → 2.0 DevAll 平台 | DAG 任务拓扑（MacNet）、人类以 Reviewer 角色插队 |
| | gpt-pilot | ~34k | step 化全流程 agent | ⚠️ **已停维护 + 供应链蠕虫事件**；Reviewer 每步回环、context filtering |
| | morph | 已下线 | agent manager | 官方《Agentic Engineering》：checkpoint discipline、16-agent 共享写冲突案例 |
| | Claude-Squad | ~8.5k | tmux + git worktree 多实例 TUI | 物理隔离防并行冲突（vibe 已引用 worktree 生态） |
| **记忆/验证** | Letta/MemGPT | 24.7k | 核心/归档记忆分层 | 常驻最小集 vs 按需检索（Context Governor 理论框架） |
| | basic-memory / Memory Bank | 3.9k / 67.9k | 文件即记忆（frontmatter+双链） | **frontmatter + wiki-links 轻量知识图谱** |
| | SWE-bench | 5.8k | 完成判定的行业标准 | **FAIL_TO_PASS 判定**（新增验证用例从失败→通过） |
| | Aider / Plandex | 48.9k / 15.6k | 每步验证+自动提交 | 改一步验一步提交一步；git 即证据链 |
| | DeepEval / Autoevals | 18.2k / 1.0k | LLM 评估（pytest for LLM） | Skill TDD 场景可执行化 + LLM-as-judge 评分 |
| **学习型** | pro-workflow | ~2.9k | 从人类纠错学习（37 hooks + SQLite） | 纠错学习回路（vibe 的 Learning Loop 缺人类纠错信号） |

**关键生态信号**：
- Anthropic Claude Code **Dynamic Workflows（2026-06 research preview）**：生态正从「提示词编排」走向「代码化编排」（`agent()/parallel()/pipeline()` DSL）——vibe 的纯指令形态是差异化，但也提示 v0.2 可预留轻量可执行化路径。
- **供应链警示**：gpt-pilot 的 `core/telemetry/` 曾被植入窃密蠕虫（2025-08 至 2026-06，GitHub 已移除并通告）。这是 vibe「Security Gate / 绝不假装已调用外部 Skill」主张的现成注脚，也支持「纯 skill 零依赖」路线。
- **停运教训**：vibe-kanban（sunset）、GSD（archive）、morph（下线）、AutoGen（维护模式）——重工程量的「平台化」路线风险高；「最小维护面」是 vibe 的长期约束。

---

## 2. 多智能体编排平台（子代理 4 主要发现，并入本报告）

| 项目 | star(约) | 核心机制 | 对 vibe 的参考点 |
|---|---|---|---|
| MetaGPT | ~70k | `Code = SOP(Team)`：产品/架构/项目/工程师角色链，产物 schema 化落盘共享 repo | **SOP 产物契约表**：每阶段产物字段校验通过才放行 |
| ChatDev | ~34k | ChatChain Phase + 评审员 + **Human-Agent-Interaction**（人类可扮演 Reviewer 插队）+ MacNet DAG + ECL 经验库 | ①人类以角色身份插入流程中段；②任务依赖 DAG 拓扑 |
| OpenHands | ~88k | Agent Canvas + **Plan Mode（PLAN.md）** + automation（定时/webhook） | **规划只读、执行才可写**；PLAN.md 升格为状态与权限边界 |
| gpt-pilot | ~34k | 角色链（PO→Spec→Architect→Tech Lead→Dev→Code Monkey→**Reviewer→Troubleshooter**）+ context filtering + step 断点续传 | ①**Reviewer 每 Task 内联回环**；②只注入当前任务相关代码；⚠️供应链事件 |
| morph | 已下线 | Plan→Execute→Orchestrate；官方方法论文 | **checkpoint discipline**（显著变更前 commit、失败回滚不继续修）；16-agent 共享写互相覆盖案例=并行禁令实证 |
| Claude-Squad | ~8.5k | tmux + git worktree 物理隔离并行 | 「禁止共享写状态并发」的最干净执行载体=worktree |

---

## 3. 能力矩阵（vibe vs 主要竞品）

| 能力 | vibe-workflow | OpenSpec | superpowers | task-master | spec-kit | gpt-pilot | flow-engineering |
|---|---|---|---|---|---|---|---|
| 形态 | 纯 Skill | CLI+skills | 技能库插件 | CLI+MCP | Python CLI | 流水线 agent | Python CLI |
| 显式状态机 | ✅ Release 9 态 | ❌ artifact 图 | ❌ 线性流水线 | ❌ tag 队列 | ❌ 阶段产物 | ✅ step 链 | ✅ 10 态 |
| 人类决策 Gate | ✅ 4 类硬门禁 | ❌ | ⚠️ 签核点 | ❌ | ❌ | ⚠️ 介入 | ❌ |
| 验证/发布分权 | ✅ 两权分立 | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |
| 上下文治理 | ✅ 三级 Pack | ⚠️ 建议性 | ⚠️ subagent 转移 | ✅ 工具分层 | ❌ | ✅ filtering | ❌ |
| 需求追踪链 | ✅ REQ→证据 | ⚠️ req+scenario | ❌ | ❌ | ⚠️ FR→tasks | ❌ | ⚠️ drift |
| 增量表达 | ⚠️ CHANGE 文本 | ✅ 结构化 delta | ❌ | ❌ | ⚠️ 多产物 | ❌ | ⚠️ |
| 一致性审计 | ⚠️ 人工 | ✅ /opsx:verify | ❌ | ❌ | ✅ converge | ⚠️ Reviewer | ✅ drift |
| 快照/回滚 | ⚠️ Last Known Good | ❌ | ⚠️ worktree | ❌ | ❌ | ✅ step 恢复 | ✅ sha256 |
| 每任务评审 | ⚠️ 合并前可选 | ❌ | ✅ 两阶段 | ❌ | ❌ | ✅ Reviewer 回环 | ❌ |
| 完成判定 | ⚠️ 人工证据 | ⚠️ | ✅ verify-before-complete | ❌ | ❌ | ⚠️ | ✅ |

---

## 4. 对 vibe-workflow 的优化建议（整合去重 + 分优先级）

> 每条标注：**借鉴来源 → 具体改动 → 落点**（已对照 SKILL.md / references / 模板现状，不重复已有机制）。

### P0 — 立即可做（纯 Markdown / 脚本化，零运行时依赖，不破坏 V0.1「不建运行时」边界）

1. **机器可校验状态块 + 字段化任务 ID**（借鉴 task-master tasks.json / spec-kit T001 / OpenSpec yaml）
   - `PROGRESS.md` 顶部固定字段化状态块：`Current Release / State / Operational Status / Slice / Task / Last Stable Commit / Next Gate`；`IMPLEMENTATION_PLAN.md` 每 Task 追加 `T001 [status: pending|in_progress|done|blocked] + evidence commit`。
   - 配套约 30 行 `tests/validate_state.sh`（lint-only，复用现有 validate_skill.sh 思路）校验状态枚举顺序、REQ/AC 覆盖、Last Stable Commit 可定位。
   - **落点**：`references/artifacts.md`、`assets/templates/PROGRESS.md`、`assets/templates/IMPLEMENTATION_PLAN.md`。

2. **Verification 门禁命令化 + FAIL_TO_PASS 判定**（借鉴 Claude Code /verify+hooks、Aider、Plandex、SWE-bench）
   - 完成声明前必须运行项目级 `scripts/verify.sh`（或等价命令），证据表含 `exit code + 输出摘要 + 产物 sha256`；判定标准改为**新增/指定的验证用例从失败→通过**（FAIL_TO_PASS），不是「套件恰好绿」。
   - 证据条目 schema 落盘 `docs/vibe/evidence/<task_id>/`：`{command, exit_code, stdout_summary, artifacts[], commit_sha, timestamp, rerunnable}`。
   - **落点**：`references/quality-and-release.md`（Task/Release Verification 小节）、VERIFICATION 模板。

3. **结构化 delta + 归档命名**（借鉴 OpenSpec）
   - `CHANGE.md` 引入 `## ADDED / ## MODIFIED / ## REMOVED` 段，每条 REQ 配 `### Scenario:`（WHEN/THEN）；Release 目录命名 `releases/<YYYY-MM-DD>-<kebab-id>/`，禁止 `update/wip/changes` 泛化名。
   - **落点**：`assets/templates/CHANGE.md`、`references/artifacts.md`。

4. **统一 frontmatter + 双链索引**（借鉴 basic-memory / directed-memory-bank / Cline Memory Bank）
   - 11 个模板加 YAML frontmatter：`type / status / updated / release_id / traceability / parent_links`；新增 `docs/vibe/_index.md`（记忆清单 + 检索入口）；文档间 wiki-links 互链，让 REQ→AC→任务→测试→证据可遍历。
   - **落点**：`assets/templates/*.md`、`references/artifacts.md`（Requirement Traceability 小节）。

5. **Circuit Breaker 绑定 git 检查点 + 失败指纹**（借鉴 Claude Code/Roo checkpoints、Plandex、Aider、flow-engineering snapshot）
   - 每次 PATCH 前打 git 检查点；熔断时 Debug Snapshot 记录 `checkpoint_sha` + 回退命令（`git checkout <sha>`），并落盘 `docs/vibe/bugs/BUG-xxx.md` 成为可检索失败记忆（不再是聊天一次性记录）。
   - **失败指纹**归一化（同测试/同模块失败 3 次）触发熔断，而非「原始文本相同 3 次」。
   - **落点**：`references/execution.md`（Retry 与 Replan、Last Known Good State）。

### P1 — v0.2 范围（仍是「只做编排」，但给状态机加可选轻量执行层）

6. **Task 级 Reviewer 回环前置 + 双通道审查**（借鉴 gpt-pilot Reviewer、ChatDev Human 模式、superpowers SDD）
   - `IMPLEMENTATION_PLAN` 每 Task 内置「实现→自检→独立 Reviewer 检查 spec/AC 合规 + diff→退回或通过」，Task Review 通过才 commit 进下一 Slice；人类可随时以 Reviewer 身份插队（反馈显式路由进状态机）。
   - REVIEWING 升级为 **spec-compliance → code-quality 双通道 fresh subagent 审查**（critical 阻断），审查结论 + 修正记录共同构成 READY_TO_SHIP 硬性证据项。
   - **落点**：`references/execution.md`（Task Loop）、`references/quality-and-release.md`（Review）。

7. **只读规划 / 写执行分离 + PLAN 入口 Gate**（借鉴 OpenHands Plan Mode）
   - SKILL/AGENTS.md 声明 PLANNED 阶段只读工具集（grep/glob/读文件/写 PLAN，禁改业务代码），BUILDING 才放开写工具；「PLAN.md 已存在且 task 依赖已列全」设为 PLANNED→BUILDING 硬性入口检查。
   - **落点**：`SKILL.md`（Release 状态机小节）、`references/routing.md`。

8. **任务依赖 DAG 显式化**（借鉴 ChatDev MacNet、morph 16-agent 案例、task-master dependencies）
   - PLAN 中每 Task 声明 `depends_on`；并行决策基于依赖图：无共享依赖才可 Exploration Race，有依赖/共享文件的任务串行或隔离（worktree）。把 Anthropic 16-agent 互相覆盖修复案例写进 references 作为并行禁令实测依据。
   - **落点**：`references/execution.md`（Parallel Rules）、`references/routing.md`（串行与并行）。

9. **Context Governor 扩展 token 预算 + 能力白名单 + 语义组装**（借鉴 task-master 工具分层、Letta core/archival、ruflo Context Autopilot、gpt-pilot context filtering、Repomix）
   - Pack token 预算：Bootstrap ≤ 800 / Resume ≤ 2k / Task Pack 给「目录+摘要+必要片段」三段式；占用 >70% 告警、>85% 剪枝。
   - **Governance Level**（Tiny/Bounded/Architectural 对应不同命令白名单）：Pack 决定注入哪些文件，Level 决定允许哪些动作，两者正交。
   - Task Context Pack 按 REQ/AC + 依赖子图用 grep/glob/符号检索动态组装，并输出**上下文账单**（哪些文件、多少 token、为何）写入 PROGRESS 供审计。
   - **落点**：`references/context.md`。

10. **会话收尾/恢复管线 + 纠错学习回路**（借鉴 claude-flow 会话日志、memory-graph 协议、pro-workflow）
    - 收尾协议：会话结束强制更新 PROGRESS + 生成 Resume Pack；新会话第一步读 Resume。给 agent 显式记忆读写指令（何时 store/何时 recall + 类型标签 decision/failure/evidence/pattern）。
    - 新增 `docs/vibe/decisions/CORRECTION-xxx.md` 记录人类纠错→违反规则→修正判定标准，纳入 Resume Pack 默认加载；同一纠错重复 ≥2 次升级为 AGENTS.md/SKILL.md 规则修正（pro-workflow 的 Markdown 轻量版，不引 SQLite）。
    - **落点**：`references/context.md`、`references/execution.md`（Learning Loop）。

11. **SOP 产物契约表 + Convergence Check**（借鉴 MetaGPT 产物 schema、spec-kit converge、flow-engineering drift）
    - 为每个阶段定义产物契约表（必须产出哪些字段、下游消费哪些字段），配套 `tests/validate_artifacts.sh`（检查 SPEC 含 REQ/AC 编号、PLAN 含 task→REQ 映射、VERIFICATION 每行有 evidence+result+commit）。
    - VERIFYING 前置 Convergence Check：逐条 REQ/AC 在代码库搜实现证据（Completeness）、对照 PROPOSED_DESIGN 查偏离（Coherence）、缺口追加为新任务（append-only），输出 CRITICAL/WARNING/SUGGESTION 三级报告作为 VERIFICATION.md 第一节。

### P2 — 生态与标准（长期）

12. **对齐 agentskills.io + agents.md 标准**（借鉴 anthropics/skills、agentsmd/agents.md v1.1）
    - SKILL.md 遵守 description ≤ 1024 字符、避开保留字；补齐 `.agents/skills/` 与 `~/.claude/skills/` 双布局安装说明；AGENTS.md 显式声明遵循 agents.md 开放标准，不发明平行格式。

13. **产出可渲染 BOARD.md + preset 覆盖层**（借鉴 vibe-kanban 机制但不造 GUI、spec-kit presets、codefluent milestone）
    - 由 PROGRESS/PLAN 自动派生 `docs/vibe/BOARD.md`（列=状态机 9 态，卡片=Task+依赖+所属 REQ），任何 Markdown 看板渲染器可消费。
    - `docs/vibe/presets/<name>/` 覆盖层：项目可覆盖阶段模板与「外部 skill 调用表」（grill-me/superpowers → 可配置映射），核心 skill 不变，按「项目 override > 内置」解析；可选 Release↔GitHub milestone 双向映射。

14. **Skill TDD 可执行化 + eval-gated**（借鉴 superpowers-evals、DeepEval、SWE-bench FAIL_TO_PASS）
    - `tests/scenarios.md` 25 场景升级为可执行 fixture+断言（临时 git 仓库 + 模拟会话序列），`validate_skill.sh` 加 CI 与 FAIL_TO_PASS 回归门禁；不可 shell 判定的行为用 LLM-as-judge 评分，行为分回退即阻断合并。

---

## 5. 不建议做的事（保持护城河）

1. **不要给 vibe-workflow 引入运行时依赖**（CLI/数据库/MCP server）来模拟 OpenSpec/spec-kit——「纯 skill、零安装」是相对所有竞品的核心差异化（对标 spec-kit 社区「illusion of work」批评：产物越多、被 LLM 遵守的概率越低）。工具化只能是**可选的、无依赖的**本地脚本（validate_skill.sh 模式）。
2. **不要模仿 OpenSpec「enablers, not gates」取消门禁**——分类 Human Decision Gates + 两权分立正是 vibe 独有、竞品全缺的护城河。
3. **不要造 GUI/看板应用**——vibe-kanban 已停运，工程量巨大且不是编排层该做的事；用可渲染的 Markdown（BOARD.md）复用现有生态。
4. **不要绑定任何 IDE/模型/厂商**（Kiro 反面教材）——保持 SKILL.md/AGENTS.md 中立。

---

## 6. 参考资源

- 子报告 1：`docs/competitive-analysis-2026-09.md`
- 子报告 2：`COMPETITIVE_RESEARCH.md`（仓库根）
- 子报告 3：`docs/research-agent-memory-verification-2026-09.md`
- 各子报告末尾附完整参考 URL 清单（GitHub 仓库、文档、论文、公告）。
- 关键外部方法论：Anthropic《Agentic Coding Trends Report》2026；morph《Agentic Engineering》（verification loops / checkpoint discipline / review bottleneck）；AlphaCodium《From Prompt Engineering to Flow Engineering》（arXiv:2311.01505）。
