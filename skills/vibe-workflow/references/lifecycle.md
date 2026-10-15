# Release 七阶段敏捷生命周期

## 何时读取

开始新项目、新 Release、恢复状态、处理 Requirement Change、决定阶段回退或封存 Release 时读取本文件。

## Project 与 Release

Project 是长期维护对象；Release 是一次完整的七阶段闭环生命周期：

```text
Project
├── v0.1  RELEASED (已复盘封存)
├── v0.2  RELEASED (已复盘封存)
└── v0.3  BUILDING (当前进行中)
```

已发布产品的后续修改先作为当前任务或下一版候选记录，不回写旧 Release。只有形成新的对外发布边界时才创建 patch/后续 Release；Tiny 修复不因旧版已发布而立即生成整套文档。正式发布仍保留本次范围、验收和授权事实，可集中在既有发布记录。

Release 是对外有意义的范围/验收/发布边界；Slice 是同一 Release 中可运行、可验证的业务切片，Task 是更小的原子工作项。

普通 `COMMIT`、`PUSH_BRANCH`、`COMMIT_AND_PUSH`、`OPEN_PR` 是当前阶段内的保存/协作动作，执行 [Lightweight Git Workflow](execution.md#lightweight-git-workflow)。它们不进入 Stage 6、不推进 Current Stage 或 Workflow State、不改写验证状态，也不触发 Release 封存或 Reflecting；`BUILDING` 的开发分支即使 Release 未验证，也可在明确授权后推送。正式 Publish / Deploy / Release 才进入下述 Shipping 契约。

---

## 七阶段敏捷开发模型 (The 7-Stage Lifecycle)

完整 Release 按七阶段推进；Tiny/Bounded 使用入口中的轻量路径，不为一次编辑反复遍历各阶段。阶段职责可以由同一份精简记录承担，支持按证据回退：

```text
1. Thinking ──➔ 2. Planning ──➔ 3. Building ──➔ 4. Review ──➔ 5. Testing ──➔ 6. Shipping ──➔ 7. Reflecting
  (需求澄清)      (架构/计划)     (编码/TDD)     (规格/代码)     (真机/系统)     (授权/发布)     (复盘/沉淀)
      ▲               ▲               ▲                                                            │
      │               │               └─── 评审打回 / 测试失败 / CB熔断 ─────────────────────────────┘
      │               └─────────────────── 架构假设推翻 / 重大重构
      └─────────────────────────────────── 发现根本性需求偏差 / 开启下一 Release
```

### 宏观阶段与细粒度状态映射 (Stage-to-State Mapping)

| 阶段 (Stage) | 对应的细粒度 Workflow State | 阶段目标 | 交付物 (Artifacts) |
|---|---|---|---|
| **1. Thinking** | `REQUIREMENTS_FROZEN` | 需求对质、澄清边界、锁定基线 | `PROJECT_BRIEF.md` (FROZEN) |
| **2. Planning** | `SPECIFIED` ➔ `DESIGNED` ➔ `PLANNED` | 外部测试接缝、技术架构审查、依赖图与切片 | `SPEC.md`, `PROPOSED_DESIGN.md`, `IMPLEMENTATION_PLAN.md` |
| **3. Building** | `BUILDING` | Task 上下文包、TDD 循环、最小实现、单测绿化 | 源代码、单元测试、`PROGRESS.md` |
| **4. Review** | `REVIEWING` | **置于系统测试前**：审查规格一致性与代码异味 | 必要评审记录 |
| **5. Testing** | `VERIFYING` | 真实浏览器/真机环境验收、端到端用户流 | 验收矩阵、按需原始证据或 CI 链接 |
| **6. Shipping** | `READY_TO_SHIP` ➔ `RELEASED` | 按需版本更新、授权发布、核验实际结果 | 提交与适用发布回执；PR 仅显式要求时 |
| **7. Reflecting** | `REFLECTING` ➔ 闭环进入下版 | 结构化复盘、经验分类沉淀、更新工程规则 | `RETRO.md`、实际项目规则、living `TECH_DESIGN.md` |

---

## 七阶段执行契约

外部调用遵守 [编排契约](orchestration.md)，阶段表中的技能都是能力选项，不构成每项必跑。

### 阶段 1：Thinking

新产品或未决需求进入澄清。自动优先 Matt `grilling`，`grill-me` 仅供用户显式调用，缺失时内置结构化提问；先查可得事实，只询问影响范围和验收的未决决定。首轮需求澄清不创建规则文件、工程文档、脚手架或业务代码。精确已批准的任务不重走访谈。

产品减法确有必要时可选 office-hours；原型需求可按 Discovery Spike 协议限时隔离。出口为范围与可测验收获得确认，无阻塞产品问题；未决时 WAITING_HUMAN。正式 Release 才建立对应基线与 ID。

### 阶段 2：Planning

基于冻结范围确定规格、Test Seams、技术方案与任务依赖；普通内部实现自主决定。已有足够计划时不重复生成；Bounded 可用简短任务记录。

空仓库直接启动新项目且范围与验收已确认、获准进入本阶段时，先执行 [最小规则接入](init.md#新项目最小接入)：沿用实际规则入口或按约定新建，合并唯一公共模板，正式实现前完成。已有明确授权直接复用，无需额外 init 或确认；只读、Tiny、普通 Git 与临时目录单点任务不触发。规则入口只保留行为与已核验导航，不预写架构或验收事实。

技术方案有长期取舍时过 Architecture Gate；复杂多维方案选 autoplan，单一维度选对应评审，不叠加已完成透镜。复杂拆解可用 writing-plans，写入既有计划路径。brainstorming 7 以需求访谈为主，不作本阶段固定前置，不让它绕过中间评审接管下一阶段。

出口为任务、依赖、验收可执行且必要决定已批准。产品假设被推翻时回 Thinking；单纯技术调整只更新相关方案。

### 阶段 3：Building

按任务最小闭环实现。行为改动和 Bug 使用 TDD 或必要的真实回归验证，无行为变化编辑用适用检查。复杂委派才组装 Task Handoff Contract；简单任务直接执行。确需隔离时才用 worktree。

SDD 按任务串行实现与评审，executing-plans 用于检查点执行，二选一；独立调查或隔离并行由唯一 owner 按 [routing.md](routing.md) 调度，不将 SDD 当并行实现器。

同类失败连续三次、连锁回归或架构失效触发熔断；选择 investigate 或 systematic-debugging 之一。出口为当前范围实现且必要局部检查通过，未验证实现如实记录，不提升 Release 状态。

### 阶段 4：Review

正式 Release 在高成本系统测试前审查规格与 diff。Tiny 自查，Bounded 聚焦受影响范围，复杂 Release 独立审查。review 与 requesting-code-review 选一个；实际安全风险才加 cso，实际重复实现问题才加 deslop，不要求为评审制造重构。

无 Critical/Important 阻断项才能进入系统验收；实现缺陷回 Building，产品偏差回 Thinking。修复后复审受影响部分，不无条件重新运行整套评审。

### 阶段 5：Testing

按 [验证预算](quality-and-release.md) 检查适用 AC 与真实路径；可以复用输入与环境未变的真实结果。Web/GUI 行为须真实运行，纯文案 Tiny 不要求浏览器。截图按视觉需要、HAR/视频/trace 按诊断需要采集，默认摘要级证据。

只读验收用 qa-only/browse/原生工具；qa 的修复与提交均需在授权范围内。发现缺陷回 Building，修复后经过相关 Review 再验证失效部分。所有适用 Release AC 与必需检查通过、证据可取回时到 READY_TO_SHIP，不能因某个 Task 通过跳过其余范围。

### 阶段 6：Shipping

仅正式 Publish/Deploy/Release 进入，普通 Git 走 [Lightweight Git Workflow](execution.md#lightweight-git-workflow)。先核对 READY_TO_SHIP 与精确目标授权，已有授权不重复询问。

默认使用原生 Git 与项目既有发布命令，按需更新版本、变更说明和发布产物；个人开发不强制 PR、功能分支或 ship。只有用户显式要求 PR 时才选相应分支交付流程；已有 PR 的授权合并/部署可用 land-and-deploy。分支保护不允许直推时报告限制，不能擅自创建 PR。核验实际目标、版本/commit 及适用的 smoke/健康或包发布回执后才置 RELEASED；PR、合并或 ship 成功不等于已部署。简单发布在既有记录保留必要事实，无须补建整套文档。

失败记录真实结果，不重复触发不明状态的发布，也不在无授权时扩大回滚范围。

### 阶段 7：Reflecting

简单交付在既有记录简要总结；复杂 Release 或用户要求时用 retro。按事实更新相关 living docs；反复出现的问题才沉淀到实际项目规则入口，真正架构变化才更新 TECH_DESIGN。下一版想法仅进入候选 Backlog。

封存已发布事实，清理按 [证据保留策略](artifacts.md#证据预算与保留策略) 保护活跃引用与长期证明。无有价值经验时不为仪式新建空 RETRO。

## 能力缺失

先核对来源、实际注册名称和调用限制；当前所需技能缺失时简短说明并使用 [内置最小协议](orchestration.md)。缺少真实服务、浏览器或权限时记录未验证缺口，不能以降级为理由伪造成功。不要为尚未需要的所有技能逐个做安装检查。

---

## Operational Status

Workflow State 之外单独记录：

- `ACTIVE`：可以在当前 State 内继续。
- `WAITING_HUMAN`：正在等待 Human Gate 决定。
- `BLOCKED`：缺少权限、环境、输入或外部条件。
- `REPLAN_REQUIRED`：现有方案/计划不再可信，禁止继续局部 patch。

Operational Status 不会自动改变 Workflow State。例如 BUILDING 中发生 Requirement Change，可以保持 State 记录为 BUILDING，同时 Status 为 WAITING_HUMAN；获批后根据影响回退。

## Requirement Change 回退矩阵

获批变更后回退到最早被失效的状态：

| 影响 | 回退点 |
|---|---|
| 只改变任务顺序或内部实现 | `PLANNED` (Stage 2) |
| 改变模块边界、公开接口或数据模型 | `DESIGNED` (Stage 2) |
| 改变产品行为、范围、用户流程或验收 | `SPECIFIED` (Stage 2)，先更新 baseline/effective SPEC |
| Requirement Gate 不再成立 | Requirement Clarification，回退至 `REQUIREMENTS_FROZEN` (Stage 1) |

不要机械重走未受影响阶段，但必须做 impact analysis 并更新所有失效链接。

## 新 Release

1. 选择新的 Release ID。
2. 以当前产品事实和本次新增/修改范围形成新的 PROJECT_BRIEF。
3. Requirement Gate 通过后创建该 Release 的完整 Effective SPEC。
4. 有目标架构变化时创建该 Release 的 PROPOSED_DESIGN；必要 Decision 获批后才能进入 DESIGNED。
5. `CHANGE.md` 只表达相对上一 Release 的差异；Agent 默认不靠叠加多个 delta 推导当前需求。
6. 更新 PROGRESS 的 Current Release、Stage、State、Status 和 Next Task。

## 封存

`RELEASED` 并经过 `REFLECTING` 后：

- 不静默修改 PROJECT_BRIEF、SPEC、PROPOSED_DESIGN、PLAN、VERIFICATION 或 RETRO。
- 措辞歧义使用有日期、有理由、有链接的勘误记录。
- 当前行为改变时写入新 Release 的 Effective SPEC。
- 当前架构写入 Living TECH_DESIGN；历史原因写入 DEC。
- 有重复出现且已验证有效的经验时更新实际项目规则入口；无新经验时不新增规则。

封存不是禁止纠错，而是禁止把今天的事实追溯覆盖为过去的事实。

## 恢复会话

先按 [入口定位](init.md#规则入口定位) 读取项目实际采用的 `AGENT.md` 或 `AGENTS.md` 及宿主适用规则。Tiny 与普通 Git 只读取相关文件和必要状态；其余任务从现有 PROGRESS 或等价记录开始，但不盲信它：

1. 读取 Current Release、Stage、State、Status、Slice、Task 和 Last Stable Commit。
2. 用 Git、代码、测试和关联 artifacts 核验。
3. 若状态过期，记录证据并修正 PROGRESS。
4. 若聊天口述冲突，向用户指出；不静默回退或前进。

恢复完成后只组装当前 Task Context Pack。
