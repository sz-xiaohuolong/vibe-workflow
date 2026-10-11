---
name: vibe-workflow
description: Use when 软件项目任务跨越多个步骤、会话或 Release，或需要接管存量仓库、协调持久项目状态、决策关卡、范围控制、上下文恢复与完成证据；也用于继续已经采用 vibe-workflow 的项目。
---

# Vibe Workflow

## 定位

把已经确认的产品意图可靠地推进为可验证的软件。`vibe-workflow` 是生命周期 Orchestrator：负责调度 Release 七阶段状态机、执行工程门禁、编排专业 Skill，以及治理仓库权威事实源。

**Matt 的 `grilling` 负责确认做什么；Vibe Workflow 负责可靠地把它做出来。`grill-me` 是用户显式调用的需求对质入口。**

## Constitution (工程宪法)

1. 工程开始前必须冻结需求基线；首轮交互严禁偷跑创建脚手架或业务代码。
2. **What to build is frozen. How to build it is delegated.**
3. 不得静默改变产品范围；产品变化必须经过明确的人类决策。
4. 实现细节默认由 Agent 自主决定，除非跨越 Decision Gate。
5. **Repository is memory. Chat is conversation.**
6. 默认只加载 Minimal Sufficient Context，按阶段精准注入上下文。
7. Released artifacts 封存；Living documents 描述当前事实。
8. 复杂任务严谨，简单任务不官僚。
9. 没有新鲜有效的真实证据（fresh verification evidence），严禁声称完成。
10. 优先调用外部专业 Skill，缺失时执行内置等价协议优雅降级。

---

## Lightweight Git Workflow（轻量 Git 工作流）

用户只要求 `COMMIT`、`PUSH_BRANCH`、`COMMIT_AND_PUSH` 或 `OPEN_PR` 时，优先走 [execution.md](references/execution.md#lightweight-git-workflow)，不进入 Stage 6 Shipping。检查本次 Git 范围、目标、风险和已有证据即可；不自动启动完整 Release Verification、全量 Code Review、`gstack:ship`、版本 Bump、Release Tag、完整 Documentation Audit、Release Archive 或 Reflecting。

明确的 Commit / Push / PR 请求在目标和影响范围确定时就是本次操作授权，不重复询问；目标不明、force push、覆盖历史或高风险副作用仍须单独确认。Git 操作不改变 Current Stage、Workflow State 或真实验证状态；未完成 Release Verification 的开发分支可以授权推送。正式 Publish / Deploy / Release，以及已知会触发这些动作的 Git 目标，继续遵循完整 Shipping Gate。

---

## 七阶段敏捷开发工作流 (Standard 7-Stage Agile Lifecycle)

每个 Release 均采用标准的七阶段敏捷生命周期，支持根据证据动态回退，形成持续演进闭环：

```text
1. Thinking ──➔ 2. Planning ──➔ 3. Building ──➔ 4. Review ──➔ 5. Testing ──➔ 6. Shipping ──➔ 7. Reflecting
  (需求澄清)      (架构/计划)     (编码/TDD)     (规格/代码)     (真机/系统)     (授权/发布)     (复盘/沉淀)
      ▲               ▲               ▲                                                            │
      │               │               └─── 评审打回 / 测试失败 / CB熔断 ─────────────────────────────┘
      │               └─────────────────── 架构假设推翻 / 重大重构
      └─────────────────────────────────── 发现根本性需求偏差 / 开启下一 Release
```

| 阶段 (Stage) | 核心目标与动作 | 显式触发与外部技能 | 交付产物与出口条件 |
|---|---|---|---|
| **1. Thinking** | 澄清需求、明确边界、锁定基线<br/>**【首轮严禁写文件】** | 自动需求对质优先使用 Matt 的 `grilling`；用户显式请求 `grill-me` 时使用该入口；技能不可用时降级为内置结构化提问协议 | `PROJECT_BRIEF.md` (FROZEN)<br/>`Requirement Status == FROZEN`<br/>`Open Questions == None` |
| **2. Planning** | 方案头脑风暴、定义 Test Seams、多维评审、拆解依赖图 | 方案探索调用 `superpowers:brainstorming`；方案审查调用 `gstack:autoplan` (或 `plan-ceo/eng-review`)；计划拆解调用 `superpowers:writing-plans` | `SPEC.md`, `PROPOSED_DESIGN.md`<br/>`IMPLEMENTATION_PLAN.md`<br/>包含 Test Seams 与 Ready Frontier |
| **3. Building** | 组装任务包、TDD 循环、最小实现、分支隔离、CB 熔断 | Task 派发显式注入 `superpowers:test-driven-development`；并行调度 `superpowers:subagent-driven-development`；分支隔离调用 `superpowers:using-git-worktrees`；连续3次失败调用 `gstack:investigate` | 源码、单测、`PROGRESS.md`<br/>局部测试全绿、diff 无越界 |
| **4. Review** | **置于系统测试前**：审查 Spec 契约合规、代码异味、消肿 | 显式调用 `gstack:review`（或 `superpowers:requesting-code-review`）；代码消肿调用 `gstack:deslop-shared-libs`；安全审查调用 `gstack:cso` | 评审记录、消肿重构提交<br/>无阻断 Critical/Important 问题 |
| **5. Testing** | 系统级集成测试、真实无头/真机浏览器验收、证据归档 | 显式调度 `gstack:qa` 或 `gstack:browse`，驱动真实 Chromium 探针模拟交互；完成前显式调用 `superpowers:verification-before-completion` | `VERIFICATION.md` (逐项证据矩阵)<br/>`.evidence/<release-id>/` 原始日志/截图<br/>所有 AC 达到 `VERIFIED` |
| **6. Shipping** | 正式发布：独立发布授权、CI 审计、版本 Bump、Changelog 归档、发布 | 获得人类明确发布授权后，显式调用 `gstack:ship`（或 `superpowers:finishing-a-development-branch`）自动化交付 | Release Commit/Tag/PR、发布记录<br/>状态推进为 `RELEASED` |
| **7. Reflecting** | 结构化复盘、分析返工与耗时瓶颈、提炼反模式写入规则 | 显式调用 `gstack:retro` 执行自动化提交与流程分析 | `RETRO.md`、更新 `AGENTS.md`、更新 living `TECH_DESIGN.md` |

---

## 外部 Skill 显式编排与优雅降级

### 显式强提示规则 (Explicit Invocation Directives)
1. **Thinking 阶段**：接收到全新产品或未冻结需求时，遵循以下调用规则：
   - 自动需求对质优先使用 Matt 的 `grilling`。
   - 用户显式请求 `grill-me` 时，使用该用户入口；不得自动调用该入口。
   - 首轮需求澄清不创建工程文档，严禁执行 `write_to_file` 创建代码或规划文档。
   - 技能不可用时，降级为内置结构化提问协议，使用可用交互工具（如 `ask_question`）澄清关键产品问题。

   调用前核对技能来源、实际名称与调用限制；仅有声明 `disable-model-invocation: true` 的 `grill-me` 时，不得将其作为 `grilling` 的自动替代。

2. **Planning 阶段**：架构方案制定前，显式提示并调度 `superpowers:brainstorming`；方案审查显式调用 `gstack:autoplan`；实施拆解显式调用 `superpowers:writing-plans`。
3. **Building 阶段**：向 Agent 派发任务时，Task Handoff Contract 必须显式注入 **`**REQUIRED SUB-SKILL:** Use superpowers:test-driven-development`**。遇到连续 3 次同类失败立即熔断，显式触发 `gstack:investigate`。
4. **Review 阶段**：在端到端系统测试前，显式调用 `gstack:review` 独立审查 Spec Compliance 与代码健壮性，显式调用 `gstack:deslop-shared-libs` 抽取公用库。
5. **Testing 阶段**：Web/UI 场景严禁纯 Mock 充数，显式调用 `gstack:qa` 或 `gstack:browse` 捕获真实 Chromium 控制台日志（0 报错）与界面截屏写入 `.evidence/`。
6. **Shipping 阶段**：正式 Publish / Deploy / Release 获得人类授权后，显式调用 `gstack:ship` 自动完成版本 Bump、Changelog 审计与发布交付；普通 Git 请求走 Lightweight Git Workflow。
7. **Reflecting 阶段**：Release 交付后，显式调用 `gstack:retro` 自动化复盘，将反模式守则沉淀至 `AGENTS.md`。

### 优雅降级机制 (Graceful Degradation)
Agent 在调用外部 Skill 前先执行能力探测。若外部技能未安装或不可用：
- **在对话中显式告知用户**缺少该技能；
- **立即无缝降级为 `vibe-workflow` 内置的原生等价行为**（内置 `ask_question` 对质、内置红绿测试循环、内置 diff 审查、原生测试探针）；
- **严禁报错中断流程**。

---

## 工程入口 Gate

新项目或新 Release 只有同时满足以下条件才能进入 SPEC、技术设计或 Build。`$vibe-workflow init` 的现状审计和事实映射不属于工程开工，可以在需求未冻结时进行：

```text
Requirement Status == FROZEN
Open Questions == None
Current Release ID exists
Acceptance Goals are testable
```

任一条件失败：停止工程活动，列出缺失项，首轮禁止写文件，并按 Thinking 调用规则优先使用 Matt 的 `grilling` 对质；用户显式请求时使用 `grill-me`，技能不可用时降级为内置结构化提问协议。不要替用户主观推导或补全产品行为。

以下说法都不构成 Requirement Freeze：
- “直接做，别再问了”
- “细节你自己定”
- “先做一个 MVP”
- “今晚要演示”
- 已写 `FROZEN`，但 Open Questions 仍非空

**授权实现不等于授权定义产品范围。**

Tiny 任务可以使用用户的精确请求形成 task-local frozen intent；它不得包含未确认的额外产品行为。详细条件见 [routing.md](references/routing.md)。

当用户当前消息已经精确授权一个单点、低风险、无语义变化的修改（如明确把按钮“保存”改为“存储”），该消息本身就是该 Tiny Task 的人类决定；不要只因旧 baseline 的字面内容不同而再次请求批准。只有仍存在产品含义、边界、风险或验收选择时才进入 Requirement Change Gate。

---

## 启动或继续工作

仅执行 Git 请求时，直接采用 Lightweight Git Workflow 的最小上下文与检查，不为保存进度补齐需求基线或遍历七阶段文档。

1. 从当前目录向上读取适用的 `AGENTS.md`。
2. 查找唯一权威的 Document Map、当前项目索引和进度文档；优先按地图中的真实路径读取，缺失时再发现 `docs/vibe/PROJECT.md`、`docs/vibe/PROGRESS.md` 或等价文档。
3. 用仓库、Git、代码和测试证据核验当前 Release、Stage、State、Slice、Task 与 Last Stable Commit。
4. 若聊天与仓库事实冲突，显式报告冲突；不要静默采用聊天记忆。
5. 先判断 Gate，再判断任务复杂度和是否并行。
6. 只读取当前分支所需 reference 和 Task Context Pack。

用户说 `$vibe-workflow init`、接管旧仓库或初始化项目治理时，执行 [init.md](references/init.md)；`init` 是 Skill 的对话子命令，不要求安装 CLI。首次接入、跨会话恢复和上下文裁剪规则见 [context.md](references/context.md)。

---

## 细粒度 Release 状态机

```text
REQUIREMENTS_FROZEN (Stage 1)
→ SPECIFIED (Stage 2)
→ DESIGNED (Stage 2)
→ PLANNED (Stage 2)
→ BUILDING (Stage 3)
→ REVIEWING (Stage 4)
→ VERIFYING (Stage 5)
→ READY_TO_SHIP (Stage 6)
→ RELEASED (Stage 6)
→ REFLECTING (Stage 7 ➔ 下一 Release)
```

另行记录 `Operational Status: ACTIVE | WAITING_HUMAN | BLOCKED | REPLAN_REQUIRED`。Requirement Change、状态回退、新 Release 与封存规则见 [lifecycle.md](references/lifecycle.md)。

---

## 路由顺序与 Ready Frontier

路由顺序不可颠倒：
1. 先区分普通 Git 操作与正式发布意图；普通 Git 走 Lightweight Git Workflow，其余检查 Product、Schema、Security、Destructive、External Service 和 Shipping Gate。
2. 分类任务：`NEW_PROJECT | FEATURE | BUG | REFACTOR | SPIKE | REQUIREMENT_CHANGE`。
3. 分类复杂度：`Tiny | Bounded | Architectural`。
4. 确定 Document Budget 和 Quality Profile。
5. **Ready Frontier 判定**：仅前置依赖全部完成且无共享写状态的任务允许并行分发；触及公共状态或 Schema 强制串行。

完整二维 Router、跨模块可观察触发条件、Document Budget、Spike 原型规范见 [routing.md](references/routing.md)。

---

## Human Decision Gates

以下事项必须在实现前停下并获得明确决定：
- Product scope 或 Requirement change
- Public API breaking change 或兼容性破坏
- Schema、DDL、迁移、历史数据回填或破坏性数据操作
- 会锁定长期方向的 Architecture decision
- Auth、Permission、Security 或数据暴露模型
- 新外部付费服务、Secret 或重要网络数据边界
- Destructive operation 或不可逆外部副作用
- Publish、Deploy、Release；普通 Commit / Push / PR 按 Lightweight Git Workflow 判断已有授权与风险

普通内部命名、私有接口、helper、局部目录和测试组织由 Agent 自主决定。方案 contract 见 [gates.md](references/gates.md)。

---

## Verification 与 Shipping 是两个独立 Gate

```text
Verification Status = 证据说明了什么 (VERIFIED | PARTIAL | UNVERIFIED | FAILED)
Shipping Authorization = 人类是否授权外部发布动作 (NOT_REQUESTED | PENDING | APPROVED | DENIED)
```

人类可以决定承担风险，但不能把缺失证据改写为 `VERIFIED` 或 `READY_TO_SHIP`。存在未覆盖的 REQ/AC 时保持 `UNVERIFIED` 或 `BLOCKED`；不得用“负责人接受风险”绕过事实状态。

`publish/deploy/release` 只有在 Workflow State 已为 `READY_TO_SHIP` 且获得精确 Shipping Authorization 后才可执行。普通 commit/push/PR 的操作授权独立于 Shipping Authorization，不以 READY_TO_SHIP 为前置条件，也不代表 Release 已验证或可发布。

Task 进度须区分 `IMPLEMENTED_UNVERIFIED`、`POC_VALIDATED` 与 `VERIFIED`；POC 和已写代码不能推动 Release 进入 READY_TO_SHIP。详情见 [quality-and-release.md](references/quality-and-release.md)。

---

## Build、Task Handoff 与熔断恢复

按 Vertical Slice 和小 Task 推进。每个 Task 按照 **Task Handoff Contract** 组装最小上下文，在确认范围内遵循 TDD 循环实现，获取 Test Seams 证据，检查 diff，再更新 PROGRESS。

同类失败连续三次、修 A 坏 B/C、架构假设失效或改动范围持续扩大时：

```text
STOP PATCHING
→ preserve Last Known Good State
→ record Debug Snapshot
→ Operational Status = REPLAN_REQUIRED
→ 调用 gstack:investigate 或 systematic debugging
```

不得把“再改一个参数”包装成 Retry。详情见 [execution.md](references/execution.md)。

若存在已批准的 written plan，当前会话使用 `subagent-driven-development`，单独会话按检查点执行使用 `executing-plans` 作为顶层执行编排；不得再并列启动另一个顶层执行编排。

---

## Artifact 索引

- 建立、接管或维护 Release/living docs、事实所有权、面向人类的摘要与 `.evidence/` 存放时，读 [artifacts.md](references/artifacts.md)。
- 执行 `$vibe-workflow init`、建立或刷新现有仓库职责地图时，读 [init.md](references/init.md)。
- 首次接入、恢复会话或控制读取范围时，读 [context.md](references/context.md)。
- Product/Implementation 边界、Requirement Change、Schema 和 Human Gate 时，读 [gates.md](references/gates.md)。
- Build、Bug、失败熔断、并行或经验沉淀时，读 [execution.md](references/execution.md)。
- 选择 QA 强度、Release Review、Testing、Shipping 或完成措辞时，读 [quality-and-release.md](references/quality-and-release.md)。

---

## Red Flags (红线行为)

- 在需求未冻结时首轮调用 `write_to_file` 创建文档、脚手架或写代码
- 把“用户让我自行决定”解释为产品范围授权
- 把待确认方案写成 SPEC、migration 或既成事实
- 先安排 Schema/Permission Task，之后才补审批
- 默认读取全部历史 Release 或完整 Git history 造成上下文膨胀
- 因内部命名等实现细节频繁询问用户打扰心流
- 同类失败三次后仍继续盲目局部 patch
- 在 Review 阶段前未先保证局部单测全绿；或在系统 Testing 失败时绕过 Bug 回退流程
- 用旧测试、页面观感、代码已写或 Agent 报告声称完成
- 把 Shipping Authorization 当作 Verification Evidence
- 静默修改已发布的历史 Release artifact

---

## Quick Reference

| 问题 | 回答 |
|---|---|
| 产品范围是否已冻结？ | 看可观察 Gate，不看口头催促；首轮未冻结严禁写文件 |
| 这是产品决定还是实现细节？ | 产品意图需人类决定；内部实现默认委派 |
| 需要多少文档？ | 由复杂度和风险决定；Tiny 任务仅需单行记录，严禁官僚化 |
| 下一步读什么？ | PROGRESS + 当前 Effective SPEC + 当前 Task Context Pack |
| 能否并行？ | 必须属于 Ready Frontier，且无依赖、无共享写状态 |
| Review 何时执行？ | 在 Stage 3 构建完成后、Stage 5 系统/真实环境测试之前独立执行 |
| 能否说完成？ | 只有新鲜有效的真实运行证据覆盖适用 REQ/AC |
| 发布获批是否等于已验证？ | 否；Verification Status 与 Shipping Authorization 独立判定 |
