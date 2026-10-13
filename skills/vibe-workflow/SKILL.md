---
name: vibe-workflow
description: Use when 软件项目任务跨越多个步骤、会话或 Release，或需要接管存量仓库、协调项目状态、决策关卡与验证证据；继续已采用本工作流的项目时，简单任务走轻量路径。
---

# Vibe Workflow

负责软件项目的七阶段生命周期、范围与决策、事实源、专业技能编排及完成证据。**流程强度由本次任务决定，不由项目规模或已安装技能数量决定。**

## 核心约束

1. 产品范围由人类决定；明确请求和已有批准可直接使用，不重复申请。普通内部实现由 Agent 决定。
2. 新产品或未确认范围先澄清；**首轮需求澄清不创建工程文档、脚手架或业务代码**。已精确授权的任务不属于首轮需求探索。
3. 仓库保存事实，聊天提供意图；只读当前任务所需上下文，沿用既有文档路径。
4. 只有对应当前被测输入与环境的有效证据才能支持完成声明；不得把授权、POC、已写代码或他人摘要当成验证。
5. 发布授权与验证状态独立；已发布历史封存，当前事实只更新适用文档。
6. 每个任务只有一个执行编排 owner；专业技能不能自行扩大范围、生成第二套权威文档或接管下一阶段。

## 先选执行路径

先读适用 `AGENTS.md`，确认请求、影响范围和已有授权；检查产品、Schema、安全、外部付费/数据边界、破坏性动作及发布风险，再分类。文件少不代表低风险。

| 路径 | 适用条件 | 最小闭环 |
|---|---|---|
| 普通 Git | 只要求 Commit / Push / PR | [Lightweight Git Workflow](references/execution.md#lightweight-git-workflow)；检查目标、diff 与已有证据后执行 |
| Tiny | 精确、单点、低风险、无共享状态和未决 Gate | 读相关文件 → 修改 → 最小检查 → 报告；已有进度约定只更新相关一行 |
| Bounded | 有限业务闭环，范围与验收已知 | 一份已有任务记录或简短计划，相关测试和针对性审查；不强制多角色评审 |
| Architectural / 正式 Release | 长期架构/公共契约选择、多领域风险，或明确发布边界 | 按下述七阶段推进，读取相关 reference |

Tiny 使用用户精确请求作为 **task-local frozen intent**，不要求 Release ID、整套 SPEC/PLAN、正式阶段迁移或 `.evidence/` 目录。默认不启用 grilling、brainstorming、autoplan、子代理、worktree、全量 Review/QA、retro；实际风险或用户显式要求才扩展。文档、文案、静态配置和无行为变化的小修改不机械补 TDD 测试。实现后报告恰好验证了什么，不把局部通过升级为 Release VERIFIED。

仅多会话或多个文件不自动升级为 Architectural。详细阈值、文档预算与风险覆盖见 [routing.md](references/routing.md)。

## 启动或恢复

Tiny 与普通 Git 只读取适用规则、相关文件和必要的现有状态；不遍历所有 Release 文档。其余任务：

1. 查找唯一 Document Map 与当前进度，缺失时再发现等价路径；不自动 init 或补齐模板。
2. 用 Git、代码、测试核验当前 Release、Stage、State、Task 和稳定点；报告与聊天或文档的冲突。
3. 未决产品/风险选择先过 Gate；已经确认的范围进入当前工作，不重新对质。
4. 根据 [context.md](references/context.md) 加载最小任务上下文。

`$vibe-workflow init` 用于接管仓库、建立职责地图，执行 [init.md](references/init.md)；它是对话子命令，不要求 CLI。只读现状审计可以先于需求冻结。

## 七阶段生命周期

这是 Release 的状态模型，不是每次编辑都必须运行的技能串联。

```text
1. Thinking → 2. Planning → 3. Building → 4. Review → 5. Testing → 6. Shipping → 7. Reflecting
```

| 阶段 | 核心职责 | 按需选择专业技能 | 出口证据 |
|---|---|---|---|
| **1. Thinking** | 澄清未决产品范围、冻结可测目标 | 自动优先 Matt `grilling`；`grill-me` 仅供用户显式调用；缺失时内置结构化提问 | 已确认范围与验收，无阻塞产品问题 |
| **2. Planning** | 基于冻结需求比较技术方案、拆解任务与 Test Seams | 复杂方案选 `gstack:autoplan` 或所需单项评审；复杂计划用 `superpowers:writing-plans` | 必要方案批准、依赖与验收可执行 |
| **3. Building** | 小切片实现、行为测试、失败熔断 | 行为改动用 `superpowers:test-driven-development`；复杂计划可选 SDD 或 executing-plans；排障只选一个技能 | 实现与局部适用检查通过 |
| **4. Review** | 在高成本系统测试前核对规格与风险 | `gstack:review` 或 `superpowers:requesting-code-review` 二选一；确有风险时追加专项 | 无阻断问题；记录被审查范围 |
| **5. Testing** | 验证受影响系统路径，复用有效证据 | 只读验收选 `gstack:qa-only`、`gstack:browse` 或原生测试；`qa` 仅在修复已获授权时使用 | 适用 AC 的证据矩阵，缺口如实记录 |
| **6. Shipping** | 按精确授权发布并核实目标结果 | 默认原生 Git + 项目发布命令；显式要求 PR 时才选相应 ship/合并流程 | 发布目标与版本匹配，适用 smoke/健康检查通过 |
| **7. Reflecting** | 沉淀有价值的经验 | 有跨任务过程数据或用户要求时用 `gstack:retro`；简单交付简短记录 | 相关 living docs 与历史事实一致 |

`superpowers:brainstorming` 不作为 Planning 固定前置：新版负责产品意图探索，不能在需求已冻结后重新访谈或抢先转入 writing-plans。用户显式请求时按当前任务边界使用；未决产品问题回到 Thinking。

## 技能编排契约

调用前按 [orchestration.md](references/orchestration.md) 核对实际名称、来源、可用性、调用限制及副作用。`gstack:review` 等是逻辑名称，宿主可能暴露 `gstack-review` 或 `review`；以实际注册项为准，不猜工具名或执行同名 shell 命令。

传入：**目标、冻结输入、允许修改范围、权威输出路径、允许副作用、所需验证、停止点**。缺少适用技能时简短说明并执行必要的内置协议；缺少真实环境时只能记录验证缺口，不能将降级称为等价运行成功。

- 一个环节选一个主技能；autoplan 与它已执行的单项评审不叠加，两个代码审查器不默认重复运行。
- 外部技能的默认文档、提交、发布、安装、遥测或下一技能建议不构成新增授权。
- 技能不能遵守当前范围或成本边界时，选择更窄能力或内置协议；不声称执行了被跳过的流程。
- `subagent-driven-development` 按任务串行实现及评审，**不得把它当并行实现器**。隔离执行依 [routing.md](references/routing.md) 调度，不并列运行第二个顶层 owner。

## 验证与证据预算

先确定本次声明、受影响路径和最小充分检查。同一输入、依赖、配置与相关环境未变的真实结果可复用；不因换阶段、压缩上下文、提交或另一个技能接手而重跑。证据范围不明、修复改变行为或环境改变时重验受影响部分。

- Tiny：diff 与必要的局部检查；默认只保留摘要，不制造成功日志目录。
- Bounded：相关单测/集成、受影响路径；通过后停止，不顺带全量 QA。
- Release：覆盖所有适用 AC 与项目要求；组合有效的局部/CI 证据并补齐缺口。
- Web/GUI 行为验收须有真实运行证据；截图按视觉验收需要采集，HAR/视频/trace 只用于相关诊断。纯文案 Tiny 不因此强制启动浏览器。

详见 [quality-and-release.md](references/quality-and-release.md)。`.evidence/` 按需暂存原始证据；项目可在 `AGENTS.md` 覆盖预算与保留规则。保护被引用及不可重建证据，清理按 [artifacts.md](references/artifacts.md#证据预算与保留策略) 执行。

## Gate、状态与完成声明

完整 Release 开工须满足：`Requirement Status == FROZEN`、`Open Questions == None`、Release ID 存在、Acceptance 可测试。Tiny/Bounded 可使用已确认的任务范围，不为缺少这些文件而重新要求产品决定。

产品范围、公开兼容性、Schema/迁移、长期架构方向、Auth/Permission、重要外部数据/付费边界及不可逆动作须有明确决定；已有授权覆盖本次目标时沿用。细则见 [gates.md](references/gates.md)。

```text
REQUIREMENTS_FROZEN → SPECIFIED → DESIGNED → PLANNED → BUILDING
→ REVIEWING → VERIFYING → READY_TO_SHIP → RELEASED → REFLECTING

Operational Status: ACTIVE | WAITING_HUMAN | BLOCKED | REPLAN_REQUIRED
Verification Status: VERIFIED | PARTIAL | UNVERIFIED | FAILED
Shipping Authorization: NOT_REQUESTED | PENDING | APPROVED | DENIED
```

发布只在 READY_TO_SHIP 且目标已获授权后执行；普通 Commit / Push / PR 沿用轻量 Git 路径。个人项目默认沿用当前明确分支直接提交/推送，正式版本按项目命令发布；不自动开 PR、功能分支或调用 ship。只有用户显式要求 PR 才创建；分支保护不允许直推时说明限制，不绕过规则或擅自改走 PR。仅同步远程不隐含打 Tag、创建 Release 或部署。PR 创建、合并或 ship 成功不能单独证明部署完成。状态回退与封存见 [lifecycle.md](references/lifecycle.md)。

同类失败连续三次、连锁回归、架构假设失效或范围持续扩大时停止盲改，保存用户工作与可恢复稳定点，记录最小 Debug Snapshot，转根因调查或重新规划。实现、任务交接与熔断见 [execution.md](references/execution.md)。

维护文档时只更新受影响的事实 owner；职责地图、模板选择和同步检查点见 [artifacts.md](references/artifacts.md)。
