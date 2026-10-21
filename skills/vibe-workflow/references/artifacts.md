# Artifact 模型与追踪

## 何时读取

首次接入项目、建立 Release、创建或更新文档、解决事实冲突、做 Requirement Traceability 或封存 Release 时读取本文件。

## 先接管，后补齐

1. 按 [规则入口定位](init.md#规则入口定位) 检查仓库已采用的 `AGENT.md` 或 `AGENTS.md`，以及 README、docs、需求、设计、进度、测试、迁移和发布约定。
2. 找到职责等价物时沿用，不额外创建平行目录。
3. 只有职责缺失时，才从 `assets/templates/` 复制相应模板。
4. 在项目已有 Document Map、`DOCUMENT_MAP.md` 或等价索引中记录“职责 → 实际路径 → 状态 → 依据”。一个仓库只维护一个权威地图；索引只导航，不承载产品或技术结论。首次审计和重跑规则见 [init.md](init.md)。
5. 正常 init 或新项目获准进入 Planning 时，按 [接入与最小合并协议](init.md) 合并唯一[通用模板](../assets/templates/AGENT_RULES.md)；保留人工规则与冲突条款，只补缺失行为和已核验的事实源入口。只读不写入；规则文件不复制需求、架构、数据库或进度正文。

新建需求文档默认使用 `PRD.md`，名称为“产品需求文档（PRD）”。存量项目已采用 `SPEC.md` 或其他等价路径时，仍将其识别为 PRD 的事实 owner，并在唯一地图中登记实际路径；不强制迁移、不复制第二份、不改写历史。下文的 PRD 均包含这类等价入口；`SPECIFIED` 等机器状态保持不变。

## Release-scoped artifacts

建议路径：

```text
docs/vibe/releases/<release-id>/
├── PROJECT_BRIEF.md
├── CHANGE.md
├── PRD.md
├── PROPOSED_DESIGN.md
├── IMPLEMENTATION_PLAN.md
├── VERIFICATION.md
└── RETRO.md
```

只有真正的 Release 才拥有上述目录；同一 Release 的 S1/S2/S3 记录在 `IMPLEMENTATION_PLAN.md` 的 Slice Map 和 living `PROGRESS.md` 中。每个 Slice 在 PROGRESS 清单中用一条记录写状态、证据链接和下一步，不为 Slice 新建 `releases/<release-id>-Sx/`、单独子目录或整套 PRD/PLAN/REVIEW/VERIFICATION。复杂切片确需调查、设计或决策文件时，按实际职责添加单份文件并链接，不能因此升级为 Release。已有历史目录不自动搬迁或改写；在 Document Map 中标明其历史性质，后续按真实 Release 边界写入。

| Artifact | 拥有的事实 | 不拥有的事实 |
|---|---|---|
| PROJECT_BRIEF | Problem、Target User、Scope、Constraints、Acceptance Goals、Requirement Version/Status | 低层实现设计 |
| CHANGE | 相对上一 Release 的 Added/Changed/Removed/Fixed | 当前完整产品行为 |
| PRD | 当前 Release 的完整有效产品行为、REQ/AC、测试接缝、产品状态转换、错误、边界与非目标 | 私有实现细节、开发进度或测试结果 |
| PROPOSED_DESIGN | 当前 Release 尚未实现的目标技术方案、影响、恢复、验证设计和批准状态 | 当前真实架构 |
| IMPLEMENTATION_PLAN | Slice/Task、Ready Frontier 依赖拓扑、Task Handoff Contract、验证、REQ/AC 映射 | 新产品能力 |
| VERIFICATION | 每个 REQ/AC 的实际证据、结果、限制、commit/artifact、.evidence 索引 | 未执行检查的推测 |
| RETRO | 结构化复盘、返工根因、各阶段瓶颈、反模式提炼、下一 Release 候选池 | 历史结论篡改、下版冻结范围 |

CHANGE 是 delta；PRD 是完整当前行为。Agent 默认读取当前 Release 的 Effective PRD，不叠加所有历史 delta 推导需求。

## Living project documents

```text
AGENTS.md
docs/vibe/PROJECT.md
docs/vibe/TECH_DESIGN.md
docs/vibe/PROGRESS.md
docs/vibe/decisions/
docs/vibe/bugs/
```

`AGENTS.md` 是无既有入口且用户未指定名称时的默认值；项目已采用 `AGENT.md` 则沿用，不同时生成两份工作约定。地图登记实际规则路径，后续恢复显式定位；自动加载遵循宿主机制。`DOCUMENT_MAP.md` 仅在仓库没有既有地图时创建，与 `PROJECT.md` 内的地图二选一。以上目录只是新建项目的建议路径，不要求存量仓库迁移。

`decisions/` 是可选目录，不因创建 Release、功能点或 Slice 而自动建立。只有选择存在有分量的备选方案、会长期影响架构或外部契约，或需要追溯人类批准依据与恢复方式时，才按既有约定记录独立 DEC；普通实现选择写在该 Release 的 `PROPOSED_DESIGN.md` 或任务记录中即可。即使需要 DEC，也沿用仓库已有的等价位置，不创建第二套决策台账。

API 调用文档按接口使用方需要维护，优先沿用既有 API 文档、OpenAPI 及生成文档或 SDK 文档，并在唯一地图登记契约源与调用说明入口。缺少调用说明职责时，才使用 `API.md` 模板建立项目级文档，不随 Release 复制；已有契约源时引用其字段和 Schema，不手写第二份。方案设计保留目标与取舍，当前技术设计保留实现事实及契约入口，调用文档说明如何使用，详见[写作规范](document-quality.md#api-调用文档)。

| Artifact | 职责 |
|---|---|
| 实际规则入口（AGENT.md 或 AGENTS.md） | Agent 长期行为规则、事实源入口、已核验项目命令；不复制业务正文 |
| PROJECT.md | 当前项目定位、当前 Release、Quality Profile；可承载既有 Document Map |
| DOCUMENT_MAP.md 或既有地图 | 治理职责的真实路径、状态和定位依据；仅作导航 |
| TECH_DESIGN.md | 当前真实架构、模块、接口、数据、权限、运行和验证入口 |
| API.md 或既有调用文档（按需） | 面向调用方的接入、认证、输入输出、错误、示例与兼容限制；引用已有权威契约 |
| PROGRESS.md | 当前 State/Status/Slice/Task、Last Stable Commit、证据、阻塞和 Next Task |
| DEC-xxx.md | 重大选择、方案、取舍、批准、影响和恢复 |
| BUG-xxx.md | 症状、复现、证据、根因、修复、回归测试和状态 |

## 面向人类的正文

新建或实质修改文档时，先使用下方对应模板，再按[文档写作规范](document-quality.md)填写。`PROJECT_BRIEF` 是需求概要，`PRD` 是产品需求文档，`PROPOSED_DESIGN` 是方案设计，`TECH_DESIGN` 是当前技术设计，另有实施计划和进度。标准章节提供写作顺序与填写要求，适用的契约必须展开，不能只交摘要；小更新保持局部。

PRD 的背景、目标与用户章节各保留可独立理解的简述，再引用 BRIEF 的相关基线；BRIEF 不复制逐功能规格。摘要帮助快速判断，正文展开流程、规则、异常与可观察验收。进度开头简述当前事实、缺口和下一步，实际状态、日期、偏差与证据只在 PROGRESS/VERIFICATION 维护。简单任务可合并短章节，明确不适用的内容可省略；有界面时逐项核对四种页面状态，其他专业内容按实际影响填写。不要把完整模板变成所有任务的强制文档套件。

## 原始证据与可读文档分离

原始日志、dump、截图和指标只有在帮助验收或排障时才落盘；默认沿用 CI/artifact 或项目既有路径。确需本地原始文件时用 `.evidence/<release-id>/<task-id>/`，没有 Release 则用 `.evidence/task-<id>/`，在项目 `.gitignore` 忽略 `/.evidence/`。Tiny 成功结果可只在回复或既有进度记录命令、范围和结果，不创建目录。配置、Schema、源数据不能仅凭 JSON 扩展名当作可清理证据。

可读记录保留命令、被测 commit/tree 或内容摘要、时间、环境、真实结果、覆盖范围、限制与证据指针，不粘贴整份日志。一份原始证据多处引用，不为每个技能复制。

## 证据预算与保留策略

项目在实际规则入口或已登记的等价规则里覆盖以下默认值；通用模板不携带项目专属预算，不把技能仓库的设置自动写入所有项目，也不自动迁移/删除已有证据。

| 项目 | 默认策略 |
|---|---|
| 采集级别 | summary：只记可核对结果；故障或特定验收才提升 targeted；full 需明确范围、理由和预算 |
| 成功原始记录 | 每个检查保留最近 1 次必要样本；已有 CI 证明时只保留链接与运行 ID |
| 失败记录 | 同一问题保留最近 3 次有诊断价值的尝试；唯一根因样本与未解决故障固定保留 |
| 日志体积 | 每份本地日志默认最多保留 2 MiB 的必要输出；超出时摘录并明确标为“节选”，记录完整来源；不得截掉失败结论或声称节选是完整日志 |
| 高成本采集 | HAR、视频、trace 默认关闭；截图限关键验收状态 |
| 临时保留期 | 7 天后仅成为清理候选；活跃、被引用、固定保留、不可重建证据不按年龄删除 |
| 本地软预算 | 每项目 200 MiB；超额时停止可选的重型采集，检查用量并压缩/归档，必需验证不能静默跳过 |

这些数值是新证据的可调整缺省，不是生产日志保留要求。开始大批采集前估算体积；不要先录满再讨论清理。若完整日志本身是验收要求，输出到项目认可的保留位置，不能用默认截断满足该项验收。

项目可按需要加入，例如：

```text
证据策略：summary；失败调查按需 targeted。
本地软预算 100 MiB，临时保留 3 天；成功样本 1 次，失败尝试 2 次。
HAR/视频默认关闭；发布证明保留在 CI，VERIFICATION 记录运行 ID 和有效期。
只清理当前任务自己生成、无引用的中间文件；历史清理先列候选。
```

### 清理条件

先核对文件生成者、当前任务/故障状态、VERIFICATION/PROGRESS/CI 引用与固定保留要求。当前任务自建且无引用的重复中间产物可清理；历史文件须有用户或项目既有清理授权，先列精确候选及大小。年龄或超预算本身不授权删除，不使用跨项目通配符清理。

支撑发布 VERIFIED/READY_TO_SHIP 或长期审计的证明必须可长期取回：保留带 commit、命令和结果的受版本控制摘要、有效 CI 运行记录或明确保留期的 artifact。不可重建且支撑结论的原始产物须稳定归档。替换本地引用时，先归档并验证能读取，更新指针后才能清理；归档失败保留原文件。临时路径不能被表述为跨机器可复核证明。

## 事实所有权

不存在一个文件对所有事实都“优先”。按问题找 owner：

- 产品应该如何行为：当前 Effective PRD。
- 产品现在实际如何行为：代码、运行证据和测试；若偏离 PRD，必须显式处理冲突。
- 当前架构：TECH_DESIGN，并由代码/配置核验。
- 某 Release 尚未实现的目标技术方案：该 Release 的 PROPOSED_DESIGN；实现与验证后才把成立部分合并进 TECH_DESIGN。
- 当前执行位置：PROGRESS，并由 Git/代码/证据核验。
- 为什么做出重大且需长期追溯的选择：DEC；普通实现取舍见对应设计或任务记录。
- 某历史版本当时是什么：该 Released Release 的封存 artifacts。

发现冲突时不要选择最方便的文件静默覆盖。说明冲突、确定 owner、修正过期文档或进入 Requirement Change。

## 当前架构与目标方案

`TECH_DESIGN.md` 只描述由代码、配置或运行证据核验的当前架构。不得在实现前把目标设计写成当前事实。

新 Release 的设计写入 release-scoped `PROPOSED_DESIGN.md`，并标明 `Status: PROPOSED | APPROVED | IMPLEMENTED | REJECTED`、目标 Release、相关 REQ/AC 和 DEC。`DESIGNED` 的主要证据是已批准的 PROPOSED_DESIGN 及必要 DEC；实现和验证后，再将真实成立的部分合并到 TECH_DESIGN，并保留 proposal/DEC 作为历史。

## Requirement Traceability

轻量追踪链：

```text
REQ-003
→ AC-007
→ SEAM-002 (外部可观察测试接缝)
→ PROPOSED_DESIGN §4.2 / DEC-012
→ SLICE-02 / TASK-09 (Task Handoff Contract)
→ RecordingServiceTests / 真实浏览器探针
→ PASS evidence 摘要或必要原始文件指针
→ commit or result artifact
```

分散维护但必须可连接：

- PRD：REQ → AC → Test Seams。
- PROPOSED_DESIGN/DEC：REQ/AC → 目标 Design；实现并验证后由 TECH_DESIGN 描述成立的当前架构。
- IMPLEMENTATION_PLAN：REQ/AC/Seams → Slice/Task/Test (Task Handoff Contract)。
- PROGRESS：Task → current evidence/status。
- VERIFICATION：REQ/AC/Seams → evidence/result/commit，并链接适用的本地/CI 证据。
- RETRO：本次 Release 过程证据 ➔ 经验分类沉淀 ➔ 反哺实际项目规则入口。

Release Verification 必须能逐项回答“REQ 是否真的完成”，不能只回答“代码写好了”。

## 更新矩阵

| 变化 | 必须更新 | 按需更新 |
|---|---|---|
| 新 Release（实际形成新的发布边界时） | PROJECT_BRIEF、PRD、PLAN、PROGRESS | PROPOSED_DESIGN、DEC、CHANGE；实现后按证据更新 TECH_DESIGN |
| 切换当前 Release | PROJECT 的当前 Release、PROGRESS 的定位信息、权威地图的当前入口 | 当前定位或边界发生变化时更新 PROJECT 对应段落 |
| 当前 Release 内新 Feature/Slice | PROGRESS 清单一条；PLAN 的 Slice Map 按需更新 | 影响既有 REQ/AC 时更新对应验证行；无独立文档套件；若改变冻结范围，先过 Requirement Change Gate |
| 产品行为变化 | 当前 Release baseline/PRD、CHANGE | PROJECT、PROPOSED_DESIGN、DEC |
| 架构/数据/公开接口变化 | PROPOSED_DESIGN、PLAN、PROGRESS；适用 Gate 时含 DEC | PRD（产品行为受影响时）；实现验证后更新 TECH_DESIGN |
| 架构变化实现并验证后 | TECH_DESIGN 中受影响的模块、接口与运行命令 | 当前 Release 的 PROPOSED_DESIGN 实现状态 |
| 供调用方使用的接口新增或变化（含 Bug 修复；认证、参数、返回、错误或兼容行为） | 与实现同轮同步契约权威源及调用说明的受影响部分 | 受影响的示例、生成文档与地图入口；沿用项目既有生成方式 |
| Bug 修复 | 现有任务/Issue 与适用测试/evidence；复杂时 BUG | TECH_DESIGN、PROGRESS、VERIFICATION |
| Task 完成、阻塞或验证结果变化 | PROGRESS、Task evidence；已有 VERIFICATION 的对应验收行 | 预期步骤、依赖、范围或验证方法变化时更新 PLAN；适用 BUG/DEC；首次记录验证时沿用现有证据位置 |
| READY_TO_SHIP 判定、发布后收尾 | 核对 PROJECT、PROGRESS、权威地图、PLAN、VERIFICATION、TECH_DESIGN 中相关版本、状态、路径与证据，修正过期内容 | 沿用职责等价文档，只处理适用项 |
| Release 完成与复盘 | 验证、进度与当前版本事实；既有记录中的必要复盘结论 | 复杂 Release 的 RETRO、release notes、有新经验时的实际项目规则 |

以上职责只在本次变化适用且存在相应事实源时同步，Tiny/Bounded 不为套矩阵新建整套文档。不相关文档无需机械修改。若容易造成误解，在当前记录中写明“不更新及理由”。

### 文档同步检查点

上述事件发生后，在同一轮结束或推进阶段前，按更新矩阵核对受影响的事实源，只修改变化的字段或段落。同步依据是代码、配置与实际证据；不得为消除文档差异把未验证项改为通过，也不得回写已封存的历史文档。恢复会话时发现的相关过期内容也在本轮同步。

影响当前任务或交付判断的版本、状态、路径或证据冲突，须先核验并修正，再推进阶段或作完成声明；证据缺失时记录缺口并保留未验证状态。沿用现有路径，不新建同步台账，不为 Tiny 任务补齐 Release 文档套件，也不因普通 Commit / Push / PR 启动完整文档审计。

## 模板选择

先读取与本次写作对应的模板，按其结构和填写要求完善已有事实 owner；只有职责缺失时才复制创建。模板提供正文骨架，reference 说明适用条件与维护职责。可选模板如下：

- `assets/templates/PROJECT_BRIEF.md`
- `assets/templates/PROJECT.md`
- `assets/templates/DOCUMENT_MAP.md`（仅在现有仓库没有地图时）
- `assets/templates/CHANGE.md`
- `assets/templates/PRD.md`
- `assets/templates/TECH_DESIGN.md`
- `assets/templates/API.md`（缺少 API 调用说明入口时按需使用）
- `assets/templates/PROPOSED_DESIGN.md`
- `assets/templates/IMPLEMENTATION_PLAN.md`
- `assets/templates/PROGRESS.md`
- `assets/templates/DECISION.md`
- `assets/templates/BUG.md`
- `assets/templates/VERIFICATION.md`
- `assets/templates/RETRO.md`

复制后将未知事实明确标为“待澄清/未验证”，不得猜测填充；未通过 Requirement Gate 时不得把模板状态改成 FROZEN。
