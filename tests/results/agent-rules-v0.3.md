# 通用 Agent 工作约定接入回归

日期：2026-10-15。结论：**12 个场景的适用行为通过；7 组连续 init 全部逐文件字节一致。** 这是本次隔离样例的执行结果，不代表任意宿主或任意项目的保证。

## 方法与基线

沿用[场景组织](../scenarios-agent-rules.md)、[评分维度](../rubric.md)、[存量样例](../fixtures/init-existing/)与[规则变体](../fixtures/agent-rules.json)。旧版基线为修改前 `1bf1959` 的 Skill 快照；候选使用修改后的只读快照。参与者只获得 Skill 路径、各目录原始用户请求及读写边界，没有获得 Oracle、预期结果或主会话修改要求。

基线由一个独立上下文依次执行两个请求；候选分别由三个独立上下文执行存量接入、冲突合并、阶段与轻量边界，另一个未参与接入的独立上下文执行恢复。一个参与者连续处理多个目录及第二次 init，不计作多次独立盲测。主执行者另行读取实际产物，比较文件集合、原文、维护区域、首轮快照与二次结果，并核对本地 Git 远程。

临时根目录为 `/var/folders/8d/vl0tk1c51szc23l5s_j4y2fw0000gn/T/vibe-agent-rules-20261015-utpac4jt/`；本地保存了 `before-*`、`first-*`、`checkpoint-thinking`、`verify_files.py` 和 `verification.json`。这些路径仅供本机本次复核；长期依据为本记录、版本控制中的样例、请求和规则，不将临时路径称为跨机器归档。

两个旧版请求均实际生成了 `AGENTS.md`，但正文只有恢复导航，未写入通用约定：

| 请求 | 实际文件结果 | 相对新目标的缺口 |
|---|---|---|
| 缺规则的存量项目正常 init | 新增规则入口、地图，更新既有进度 | 规则正文只有 3 条恢复与命令指针 |
| 明确范围、已批准 Planning 的空项目直接启动 | 新增 7 份 Markdown，包括规则入口与规划文档 | 规则正文仍只有 3 条导航，没有通用行为正文 |

旧版实际原文摘录：“先读取唯一职责地图 `DOCUMENT_MAP.md`，按地图定位本次任务需要的事实源。”新规则针对这类条件触发与内容遗漏补入模板及最小合并协议，不归因于参与者故意跳过已有规则。

## 候选执行结果

| 场景 | 实际操作与可观察结果 | 结果 |
|---|---|---|
| R01 无规则文件 | `missing` 新建 `AGENTS.md`，正文以完整模板开头，追加真实地图/命令入口；只另建唯一地图并更新原进度 | PASS |
| R02 等价规则与人工内容 | `existing-agents` 原文完整保留，原有中文偏好、先读资料、保护用户修改与文档职责不再整段复制；缺失内容放入补充章节 | PASS |
| R03 两次 init | 7 个接入样例分别实际执行两轮；完整文件集合与全部字节相同，未回退第二轮结果 | PASS |
| R04 冲突、人工维护区域 | `conflict` 原英语偏好及人工配置验证规则逐字保留；未追加相反的中文默认或强制重验条款；报告两处具体差异 | PASS |
| R05 既有单数与双文件 | `existing-agent` 只更新 `AGENT.md`；`both` 按原地图只补 `AGENT.md`，另一份宿主提示 `AGENTS.md` 字节不变 | PASS |
| R06 指定名称 | `explicit-agent` 新建 `AGENT.md` 并完整写入模板，未新建 `AGENTS.md`，地图登记真实路径 | PASS |
| R07 首轮澄清 | `new-staged` 首轮结束的 `checkpoint-thinking` 与原目录逐字一致，仅含 `.gitkeep` | PASS |
| R08 进入 Planning | `new-staged` 后续范围批准后，以及独立 `new-direct` 首条已批准请求，均无需另说 init 或重复确认；规则先于规划写入，最终各新增 6 份 Markdown，无实现或脚手架 | PASS |
| R09 只读边界 | `readonly-existing`、已有范围与 Planning 授权的 `readonly-new`，文件集合与字节均不变，只报告建议差异 | PASS |
| R10 Tiny 与普通 Git | Tiny 仅替换按钮错字；Git 样例仅提交现有注释并推送本地 bare remote，未生成任何规则、地图或 Release 文档 | PASS |
| R11 下一会话恢复 | 未参与初始化的 Agent 实际读取 `AGENT.md`、既有地图和真实进度等文件，恢复中文与 samples/ 约束；整个项目字节不变 | PASS |
| R12 后续核对 | `template-update` 以局部旧正文模拟待补缺口；维护区域原文与人工验证约束完整保留，语义补缺，二次 init 无变化 | PASS |

新项目的六份文件为 `AGENTS.md`、`DOCUMENT_MAP.md`、`docs/vibe/PROGRESS.md`，以及 v0.1 的 `PROJECT_BRIEF.md`、`SPEC.md`、`IMPLEMENTATION_PLAN.md`。后五份属于用户本轮明确要求的工程规划；规则文件只含通用行为及真实地图链接，没有写入技术方案、业务进度或验收结论。状态为 Planning / PLANNED，业务 AC 为 UNVERIFIED，未进入实现。

冲突样例具体保留：“本项目所有沟通使用英语”；维护区域内“受影响的配置变化后，可以由维护者决定复用旧结果；Agent 不得擅自强制重跑。”参与者在补充正文中引用人工验证约定，并报告与模板第 1、4 节的差异。标记内外没有删除或覆盖原文。

## 文件复核与命令

主执行者运行临时 `verify_files.py`，退出 0。该核对只读取产物，不执行或模拟规则合并：

- 比较所有 7 组 `first-*` 与二次目录的路径集合、每份文件字节；检查原有规则为最终正文完整前缀、维护区域逐字一致、非目标规则文件不变。
- 核对缺规则样例完整模板、新入口名称、未生成重复入口；读取补充正文检查等价语义和冲突处理。原 `Makefile`、产品与架构正文均保持原样。
- 比较 Thinking 快照、只读目录和恢复目录；检查两个规划目录只新增 Markdown，Tiny 精确字节结果、Git 提交范围及远程 HEAD。

| 接入目录 | 首次变化文件 | 二次变化文件数 | 最终文件数 |
|---|---|---|---|
| missing | AGENTS.md、DOCUMENT_MAP.md、docs/progress.md | 0 | 7 |
| existing-agents | AGENTS.md、DOCUMENT_MAP.md、docs/progress.md | 0 | 7 |
| existing-agent | AGENT.md、DOCUMENT_MAP.md、docs/progress.md | 0 | 7 |
| both | AGENT.md、DOCUMENT_MAP.md、docs/progress.md | 0 | 8 |
| explicit-agent | AGENT.md、DOCUMENT_MAP.md、docs/progress.md | 0 | 7 |
| conflict | AGENTS.md、README.md、docs/progress.md | 0 | 6 |
| template-update | AGENTS.md、README.md、docs/progress.md | 0 | 6 |

后两组将 README 中已有文档入口扩展为唯一职责地图，没有创建并列地图。前两组及指定名称组新增唯一 `DOCUMENT_MAP.md`；单数与双文件组沿用原地图。

五个存量接入、两个冲突接入、一个只读审计和独立恢复均实际运行 `make test`，退出 0，仅输出 `fixture smoke test: PASS`；这是固定回显，不能证明任何录音业务通过。没有 Git 的样例执行 Git 检查返回 128，报告为无法核验提交与分支，而非产品失败。新项目参与者曾有一次相对路径计算错误，发生在写入前；修正取路径方式后完成，最终产物由主执行者重新核对。

普通 Git 样例实际执行范围检查、暂存、`git commit`、`git push origin main:main` 与远程核对；提交为 `4dbb17aa8247103388e6358f9f449a6652caa67a`，只包含 `app.py` 注释改动，工作树干净，远程 `refs/heads/main` 与本地 HEAD 相等。remote 为临时本地 bare 仓库，无网络发布。

本次 8 项行为相关资源（SKILL、init/context/artifacts/lifecycle、公共模板、两份地图模板）与最终工作区逐字相同，组合 SHA-256 为 `8245d3b84ee8431658f790952e50d4c70ce29e6ce262f49bc7315be9e08c72de`。公共模板 SHA-256 为 `6ad1c0e8a0683957c5d8a71ed56c163fa61150fc87b78ab96aba68c72131159e`；双文件样例未修改的 `AGENTS.md` 为 `604ccdc03e06eae877bbf044c72bfa490bf45e4377bdda218e1bd8f0ad356565`。这些摘要仅用于测试复核，没有引入项目规则版本或哈希登记系统。

## 修改文件与职责

下表路径均相对仓库根目录，同组文件承担所列的相同职责。

| 文件 | 本次职责 |
|---|---|
| skills/vibe-workflow/SKILL.md | 两种触发、授权边界及统一定位入口 |
| skills/vibe-workflow/references/init.md | 入口选择、逐条合并、冲突与幂等、新项目最小接入的唯一协议 |
| skills/vibe-workflow/assets/templates/AGENT_RULES.md | 公共正文唯一副本，5 节 24 条 |
| skills/vibe-workflow/references/context.md | Bootstrap/Resume 读取真实规则路径 |
| skills/vibe-workflow/references/lifecycle.md | Thinking 禁写文件、Planning 最小接入及恢复/复盘沿用入口 |
| skills/vibe-workflow/references/artifacts.md | 规则与业务文档职责、地图登记及模板使用边界 |
| skills/vibe-workflow/references/execution.md、gates.md、quality-and-release.md | 后续经验写回实际入口，避免另建 AGENTS.md |
| skills/vibe-workflow/assets/templates/DOCUMENT_MAP.md、PROJECT.md | 地图字段记录真实规则路径 |
| skills/vibe-workflow/assets/templates/RETRO.md、VERIFICATION.md | 复盘和证据策略引用实际入口 |
| docs/USER_GUIDE.zh-CN.md | 接管、新项目、恢复、合并与项目配置教程 |
| docs/concepts/context-governor.md、artifacts.md | 概念页读取与职责说明一致 |
| README.md、README.zh-CN.md | 快速开始说明两种自动接入 |
| docs/SKILL_UPDATES.zh-CN.md | 2026-10-15 调整及验证入口 |
| tests/scenarios-agent-rules.md | R01–R12 的请求、可观察结果及 Oracle |
| tests/fixtures/agent-rules.json | 人工、单数、双文件、冲突和局部旧正文样例 |
| tests/validate_skill.sh | 保留既有检查，增加单模板、24 条结构及样例/场景校验 |
| tests/results/agent-rules-v0.3.md | 本记录，执行结果、文件复核及范围限制 |

## 静态检查与未覆盖范围

`bash tests/validate_skill.sh`、`bash -n tests/validate_skill.sh`、`git diff --check` 通过；Skill Creator 校验、元数据、Skill 相对链接、七阶段、Git/Shipping 旧契约与新增资源结构均通过。`skills-ref` 未安装，沿用已有 Skill Creator 校验器，没有安装额外工具。新增正文与修改文档的本地相对链接另行核对。

未执行跨宿主的自动规则发现集成测试、多模型统计重放、真实业务仓库接管、嵌套/上级规则冲突、两个规则入口声明互相矛盾的实际写入场景，或任意未来模板版本迁移。R12 仅是局部旧正文的模拟。没有全量重放历史 S01–S54 或全部轻量场景，没有运行真实业务验收、浏览器 QA、部署或版本发布。上述范围均标为未验证；静态结构通过不替代这些行为证据。
