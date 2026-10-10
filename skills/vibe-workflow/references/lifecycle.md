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

对已发布产品的 Bug 修复创建新的 patch Release 或后续 Release；旧 Release 严格封存当时事实。这个封存边界优先于 Tiny 的轻文档预算：Tiny patch Release 仍保留新 Release 必需的事实职责，但每份只写该修复所需的最小内容，不生成冗余文件，严禁回写已发布版本的历史文档。

Release 是对外有意义的范围/验收/发布边界；Slice 是同一 Release 中可运行、可验证的业务切片，Task 是更小的原子工作项。

普通 `COMMIT`、`PUSH_BRANCH`、`COMMIT_AND_PUSH`、`OPEN_PR` 是当前阶段内的保存/协作动作，执行 [Lightweight Git Workflow](execution.md#lightweight-git-workflow)。它们不进入 Stage 6、不推进 Current Stage 或 Workflow State、不改写验证状态，也不触发 Release 封存或 Reflecting；`BUILDING` 的开发分支即使 Release 未验证，也可在明确授权后推送。正式 Publish / Deploy / Release 才进入下述 Shipping 契约。

---

## 七阶段敏捷开发模型 (The 7-Stage Lifecycle)

每个 Release 标准流转经历 7 个阶段，支持按证据动态回退，形成持续闭环：

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
| **4. Review** | `REVIEWING` | **置于系统测试前**：审查规格一致性与代码异味 | 代码评审记录、消肿重构提交 |
| **5. Testing** | `VERIFYING` | 真实浏览器/真机环境验收、端到端用户流 | `VERIFICATION.md`, `.evidence/<id>/` |
| **6. Shipping** | `READY_TO_SHIP` ➔ `RELEASED` | 独立发布授权、CI 审计、版本 Bump、发布部署 | Release Commit/Tag/PR、封存快照 |
| **7. Reflecting** | `REFLECTING` ➔ 闭环进入下版 | 结构化复盘、经验分类沉淀、更新工程规则 | `RETRO.md`, `AGENTS.md`, living `TECH_DESIGN.md` |

---

## 七阶段执行契约 (Stage Execution Contracts)

### 阶段 1：Thinking（思考）
- **Entry Gate**：收到新项目立项、新 Release、或需求变更请求。
- **Required Inputs**：用户原始输入、仓库既有 `AGENTS.md`、`DOCUMENT_MAP.md`、当前产品事实。
- **Actions**：
  1. 识别任务属性（NEW_PROJECT / FEATURE / BUG / SPIKE / REQUIREMENT_CHANGE / TINY）；
  2. **【显式调用与负向禁止令】首轮严禁执行 `write_to_file` 创建任何实现或规划文档！**
     - 若可用，显式优先触发 `gstack:office-hours`（执行 YC 6 问：需求真实性、Narrowest Wedge、Non-goals 减法）；
     - 进一步调用 `grill-me` 针对边界条件、数据模型、验收指标进行逐项深水区对质；
     - 若上述外部技能未安装，**强制显式调用内置交互工具（如 `ask_question`）**，抛出 3~5 个关于边界、不做的范围、数据格式的结构化问题，等待人类答复；
  3. 若需验证技术可行性，允许受控 Discovery Spike（限定时限与丢弃边界，探针代码不入主分支）；
  4. 人类对质答复完成后，锁定需求基线，确定可独立测试的 Acceptance Goals。
- **External Skills**：`gstack:office-hours`、`grill-me`、`gstack:design-shotgun`（Spike 原型）。
- **Outputs**：`PROJECT_BRIEF.md`（状态锁定为 `FROZEN`，`Open Questions == None`）。
- **Exit Gate**：满足 `Requirement Status == FROZEN` 且 `Open Questions == None`，验收目标可独立判定。
- **Failure Route**：若存在未解决歧义，保持 `WAITING_HUMAN`，禁止进入 Planning 阶段。

### 阶段 2：Planning（规划）
- **Entry Gate**：Stage 1 成功退出，需求基线已冻结。
- **Required Inputs**：已冻结的 `PROJECT_BRIEF.md`、当前系统架构 `TECH_DESIGN.md`。
- **Actions**：
  1. **【显式调用】架构方案头脑风暴**：显式提示并调用 `superpowers:brainstorming`，探索 2~3 种技术选型方案与权衡；
  2. **Effective SPEC 编制**：将冻结需求展开为可验证行为契约，显式定义 **Test Seams（外部可观察测试接缝）**；
  3. **方案多维评审**：显式调用 `gstack:autoplan`（或依次调度 `plan-ceo-review`、`plan-eng-review`），对架构、减法与数据流进行全方位自动/半自动评审；重大决策记录 `DECISION.md` 并过 Human Gate；
  4. **【显式调用】实施计划拆解**：显式调用 `superpowers:writing-plans`，按 Vertical Slice 拆分 Task，建立 **Task Dependency Graph**，明确标注 **Ready Frontier（无阻塞可就绪任务）**，建立 `REQ ➔ AC ➔ Design ➔ Task ➔ Test Seam` 映射矩阵。
- **External Skills**：`superpowers:brainstorming`、`gstack:autoplan`（或 `plan-ceo-review`/`plan-eng-review`）、`superpowers:writing-plans`。
- **Outputs**：`SPEC.md`、`PROPOSED_DESIGN.md`、`IMPLEMENTATION_PLAN.md`（含 Test Seams 与 Dependency Graph）。
- **Exit Gate**：计划具备完整依赖拓扑，每项 AC 均有对应的 Test Seams 与执行 Task，高风险架构决策已获批。
- **Failure Route**：架构假设被推翻或发现伪需求，回退至 Stage 1（Thinking）修改需求基线。

### 阶段 3：Building（构建）
- **Entry Gate**：Stage 2 规划获批，进入已就绪的 Vertical Slice。
- **Required Inputs**：当前 Task Context Pack（含 Task Handoff Contract、相关 SPEC、测试接缝）。
- **Actions**：
  1. 按照 **Task Handoff Contract** 协议执行任务：
     - `Task ID`、`Goal`、`Related REQ/AC`、`Dependencies`、`Allowed Modification Scope`、`Test Seams`、`Risk Tags`；
  2. **【显式调用】隔离开发**：对于需要分支/独立目录的任务，显式提示并调度 `superpowers:using-git-worktrees`；
  3. **【显式调用】多任务并行分发**：对处于 Ready Frontier 且互无共享状态的独立 Task，显式调用 `superpowers:subagent-driven-development` 并行分发；有共享写状态的强制串行；
  4. **【显式调用】Task 执行协议**：每个 Task 执行前，必须在提示语中显式注入 **`**REQUIRED SUB-SKILL:** superpowers:test-driven-development`**，严格遵守 `红 (失败单测) ➔ 绿 (最小实现) ➔ 蓝 (重构优化)` 闭环；
  5. 遇到连续 3 次同类失败或方向迷失，禁止继续盲改，显式触发 **`gstack:investigate`** 或 `superpowers:systematic-debugging` 进行根因分析，并触发 Circuit Breaker（置 `REPLAN_REQUIRED`）。
- **External Skills**：`superpowers:test-driven-development`、`superpowers:subagent-driven-development`、`superpowers:using-git-worktrees`、`gstack:investigate`（或 `superpowers:systematic-debugging`）。
- **Outputs**：功能代码、单元测试代码、更新后的 `PROGRESS.md`（标记任务为 `IMPLEMENTED_UNVERIFIED` 或 `VERIFIED`）。
- **Exit Gate**：当前 Release 所有 Slice 的 Task 均实现完毕，局部测试全绿，diff 无越界。
- **Failure Route**：触发 Circuit Breaker 时回退至 Stage 2（Planning）重新设计。

### 阶段 4：Review（评审）⭐ 放在 Testing 之前
- **Entry Gate**：Stage 3 全部 Task 构建完成，局部测试通过，代码 diff 稳定。
- **Required Inputs**：已冻结 SPEC/AC、本次 Release 完整 Diff、Task 级实现与单测证据。
- **Actions**：
  1. **【显式调用】代码质量与规格评审**：显式调用 `gstack:review`（或 `superpowers:requesting-code-review`），由独立视角审查：
     - **Spec Compliance**：是否 100% 覆盖已冻结的 REQ/AC？是否遗漏边界？是否产生未经批准的 Scope Creep？
     - **Engineering Quality**：并发竞态、时区、资源泄露、错误处理健壮性；
  2. **【显式调用】代码消肿与公共库抽取**：显式调用 `gstack:deslop-shared-libs`，扫描跨模块重复代码与过早抽象，合并冗余；
  3. **【显式调用】安全威胁审查**：若任务标记有 Security/Auth Risk Tag，显式调度 `gstack:cso` 进行威胁建模与脆弱性检查。
- **External Skills**：`gstack:review`、`superpowers:requesting-code-review`、`gstack:deslop-shared-libs`、`gstack:cso`。
- **Outputs**：评审意见记录、消肿重构提交、更新后的代码基线。
- **Exit Gate**：所有 Critical 与 Important 评审问题均已修复并通过复审，无未授权范围漂移。
- **Failure Route**：
  - 发现实现缺陷或代码异味 ➔ 回退至 Stage 3（Building）修复；
  - 发现需求存在根本性理解偏差 ➔ 回退至 Stage 1（Thinking）走变更门禁。

### 阶段 5：Testing（测试）⭐ 真实环境与端到端验收
- **Entry Gate**：Stage 4 Review 全部通过，进入系统级真实环境验证。
- **Required Inputs**：Test Matrix、运行环境配置、被测系统入口。
- **Actions**：
  1. 执行系统集成测试与回归测试用例；
  2. **【显式调用】Web/UI/GUI 真机与真实浏览器验收**：严禁只用 Mock 测试充数，显式调用 `gstack:qa` 或 `gstack:browse`，驱动真实 Chromium 探针模拟用户真实交互流程；
  3. 捕获真实运行证据：Console Logs（无报错）、Network 流量日志、界面关键操作截图，持久化存入 `.evidence/<release-id>/` 目录；
  4. 逐项核验 REQ/AC 证据闭环，严格区分 `IMPLEMENTED_UNVERIFIED`、`POC_VALIDATED` 与 `VERIFIED`。
- **External Skills**：`gstack:qa`、`gstack:browse`、`superpowers:verification-before-completion`、Playwright / 原生测试套件。
- **Outputs**：`VERIFICATION.md`（REQ/AC 逐行证据矩阵）、`.evidence/<release-id>/` 原始运行截屏与日志。
- **Exit Gate**：所有适用 REQ/AC 的 Verification Status 均为 `VERIFIED`，有新鲜且不可篡改的证据，状态达到 `READY_TO_SHIP`。
- **Failure Route**：测试失败 ➔ 记录 Bug ➔ 回退至 Stage 3（Building）修复 ➔ 经过 Stage 4（Review）复审 ➔ 重新进入 Stage 5 验收。

### 阶段 6：Shipping（交付）
- **Entry Gate**：用户要求正式 Publish / Deploy / Release，Stage 5 验收完毕，Workflow State 达到 `READY_TO_SHIP`；普通 Git 操作不适用此阶段。
- **Required Inputs**：`VERIFICATION.md`、变更日志、版本号、部署环境信息。
- **Actions**：
  1. Preflight 检查：Git 状态干净、构建成功、无未解决阻塞项；
  2. Documentation Audit：更新 README、CHANGELOG、VERSION；
  3. **Human Shipping Gate**：出示发布提案（包含 target、影响、回滚方案），等待人类明确授权；
  4. **【显式调用】交付流自动化**：在获得人类明确许可后，显式调用 `gstack:ship`（自动执行版本 Bump、Changelog 归档、Git commit、Tag、PR 创建与部署流）；
  5. 部署 Smoke Test 与生产连通性检查；
  6. 归档 Release Artifacts。
- **External Skills**：`gstack:ship`、`superpowers:finishing-a-development-branch`。
- **Outputs**：Git Commit/Tag/PR、发布结果记录、封存的 Release 目录。
- **Exit Gate**：发布动作成功执行，确认部署无异常，状态推进为 `RELEASED`。
- **Failure Route**：人类拒绝发布 ➔ 保持 `READY_TO_SHIP`，不执行外部动作；发布失败 ➔ 启动回滚或恢复方案，记录问题并调查。

### 阶段 7：Reflecting（复盘）⭐ 持续进化
- **Entry Gate**：Stage 6 成功交付，状态已为 `RELEASED`。
- **Required Inputs**：本次 Release 过程证据、Circuit Breaker 记录、Bug 记录、开发耗时数据。
- **Actions**：
  1. **【显式调用】结构化复盘**：显式调用 `gstack:retro`，自动化分析提交历史、返工频率、耗时瓶颈与测试盲区；
  2. 经验分类沉淀：
     - 一次性缺陷 ➔ 留存 `BUG-xxx.md` 归档；
     - 重大架构抉择 ➔ 留存 `DECISION.md`；
     - 当前系统事实 ➔ 合并更新 living `TECH_DESIGN.md`；
     - 重复性 Agent 错误 ➔ 提炼 1~2 条反模式规则追加至 `AGENTS.md`（优先转化为自动化检测）；
     - 发现的新产品想法 ➔ 沉淀为下一 Release 的候选 Backlog（禁止自动污染下一版本 Frozen Scope）。
- **External Skills**：`gstack:retro`。
- **Outputs**：`RETRO.md`（复盘记录）、更新后的 `AGENTS.md`、更新后的 living `TECH_DESIGN.md`。
- **Exit Gate**：经验沉淀完成，活文档与历史快照严格对齐，闭环结束，准备进入下一 Release。
- **Failure Route**：无阻塞性失败；若复盘发现遗留严重隐患，直接建 Bug 作为下一 Release 最高优先级。

---

## 优雅降级与能力探测机制 (Graceful Degradation)

若运行环境未安装上述外部 Skill，Agent 必须遵循：
1. **先探测**：检查环境是否具备对应的外部 Skill 或 Slash Command；
2. **后降级**：若未安装，**在回复中显式告知用户**，并立即无缝降级为 `vibe-workflow` 内置的原生等价行为：
   - 缺少 `gstack:office-hours` / `grill-me` ➔ 降级使用内置 `ask_question` 抛出 3~5 个阻断式选择题对质；
   - 缺少 `superpowers:test-driven-development` ➔ 严格执行内置原生失败单测先行循环；
   - 缺少 `gstack:qa` / `gstack:browse` ➔ 降级使用 Playwright / Chromium CLI 或原生测试探针捕获证据；
   - 缺少 `gstack:retro` ➔ 降级使用内置 `RETRO.md` 模板进行人工结构化复盘。
3. **严禁报错中断**：外部技能缺失决不能成为流程崩溃的理由。

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
- 将验证有效的 1~2 条工程防坑守则提炼追加到仓库 `AGENTS.md`，实现跨会话持续记忆。

封存不是禁止纠错，而是禁止把今天的事实追溯覆盖为过去的事实。

## 恢复会话

新会话从 PROGRESS 开始，但不盲信它：

1. 读取 Current Release、Stage、State、Status、Slice、Task 和 Last Stable Commit。
2. 用 Git、代码、测试和关联 artifacts 核验。
3. 若状态过期，记录证据并修正 PROGRESS。
4. 若聊天口述冲突，向用户指出；不静默回退或前进。

恢复完成后只组装当前 Task Context Pack。
