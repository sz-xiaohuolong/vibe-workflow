# Vibe Workflow Skill V0.1 设计

## 目标

创建一个轻量但严格的软件项目生命周期 Orchestrator Skill。它以 Release 为主要生命周期单位，在冻结需求、Effective SPEC、技术设计、实施计划、实现、验证、评审、发布和维护之间维持可追踪的持久状态。

`vibe-workflow` 只负责三件事：判断当前处于什么状态、判断何时调用什么专业能力、把输出写回正确的仓库事实源。它不重新实现需求访谈、TDD、系统调试、代码评审或 Git 分支收尾。

## 非目标

- 不成为 IDE、Coding Agent runtime、多 Agent 框架或项目管理系统。
- 不替代 `grill-me` 或等价 Requirement Clarification Skill。
- 不复制 Superpowers 的工程方法。
- 不绑定语言、IDE、Agent 产品、LLM 厂商或具体模型。
- 不自动执行 push、PR、publish、deploy、release 或不可逆外部操作。
- 不在 V0.1 实现通用 Markdown 状态解析器或自动模型调度。

## Constitution

1. Requirements are frozen before engineering begins.
2. What to build is frozen. How to build it is delegated.
3. Agent 不得静默改变产品范围。
4. 产品变更必须经过明确的人类决策。
5. Repository is memory. Chat is conversation.
6. 默认使用 Minimal Sufficient Context。
7. Released artifacts 封存；Living documents 描述当前事实。
8. 复杂任务严谨，简单任务不官僚。
9. 没有 fresh verification evidence，不得声称完成。
10. 优先调用专业 Skill，而不是复制其教程。

产品意图包括功能范围、非目标、目标用户、核心用户流程、平台范围、关键限制、验收标准和 Release 边界。内部命名、私有接口、helper、普通目录组织、测试文件组织以及沿用现有仓库模式的实现细节通常由 Agent 自主决定。

## 领域模型

```text
Project
└── Release
    ├── Phase（可选）
    └── Vertical Slice
        └── Task
```

Release 是需求冻结、SPEC、计划、验证和发布的完整单位。Phase 仅用于确有必要的复杂 Release。优先按可运行、可验证、可提交、可回退的业务闭环拆分 Vertical Slice。

Workflow State 与 Operational Status 分开：

- Workflow State：`REQUIREMENTS_FROZEN | SPECIFIED | DESIGNED | PLANNED | BUILDING | VERIFYING | REVIEWING | READY_TO_SHIP | RELEASED`
- Operational Status：`ACTIVE | WAITING_HUMAN | BLOCKED | REPLAN_REQUIRED`

## Release 生命周期

```text
REQUIREMENTS_FROZEN
→ SPECIFIED
→ DESIGNED
→ PLANNED
→ BUILDING
→ VERIFYING
→ REVIEWING
→ READY_TO_SHIP
→ RELEASED
```

工程入口要求：

```text
Requirement Status == FROZEN
Open Questions == None
Current Release ID exists
Acceptance Goals are testable
```

入口失败时，不得进入 SPEC、设计或实现；应输出缺失项并路由到 `grill-me` 或等价能力。Released Release 不再静默编辑；后续维护创建新的 Release 或 patch Release。

Requirement Change 和 Circuit Breaker 是旁路：

- 获批的 Requirement Change 更新 Requirement Version、Effective SPEC 和影响分析，并回退到最早被新事实失效的状态。
- 连续三次同类失败、回归扩散、架构假设失效或修改范围持续扩大时，Operational Status 进入 `REPLAN_REQUIRED`，停止继续 patch。

## 任务路由

先判类型：`NEW_PROJECT | FEATURE | BUG | REFACTOR | SPIKE | REQUIREMENT_CHANGE`。

再判复杂度：

| 复杂度 | 典型特征 | Document Budget |
|---|---|---|
| Tiny | 单点、低风险、边界清楚 | 通常不新增正式文档 |
| Bounded | 一个有限的可验证闭环 | Task/Feature contract、Acceptance、Tests |
| Architectural | 跨模块、多会话、多方案或高风险 | 完整设计、Decision、Plan、Verification |

Risk Gate 和 Decision Gate 优先于复杂度。Tiny 任务仍需清晰意图，但可以使用用户精确请求形成 task-local frozen intent。Spike 只产出调查结论；采用 Spike 代码或方案是新的工程决策。

## Artifact 模型

Release-scoped artifacts：

```text
docs/vibe/releases/<release-id>/
├── PROJECT_BRIEF.md
├── CHANGE.md
├── SPEC.md
├── IMPLEMENTATION_PLAN.md
└── VERIFICATION.md
```

Living project documents：

```text
AGENTS.md
docs/vibe/PROJECT.md
docs/vibe/TECH_DESIGN.md
docs/vibe/PROGRESS.md
docs/vibe/decisions/
docs/vibe/bugs/
```

事实所有权：产品意图由当前 Effective SPEC 拥有；当前实现由代码、测试和 TECH_DESIGN 共同描述；执行状态由经仓库证据核验的 PROGRESS 拥有；决策原因属于 DEC；历史行为属于已封存 Release artifacts；Agent 行为和索引属于 AGENTS.md。

追踪链为：

```text
REQ → AC → Design → Slice/Task → Test → Verification Evidence → Commit/Artifact
```

不建立巨型中央数据库。SPEC 维护 REQ/AC，Implementation Plan 维护任务映射，VERIFICATION 回答每个 REQ/AC 是否由什么证据证明。

## Context Governor

Bootstrap Pack 读取仓库规则、现有文档、当前 Release、构建和测试入口。Resume Pack 读取 AGENTS、PROJECT、PROGRESS、当前 Effective SPEC 和当前 Task 所需材料。Task Context Pack 只加载当前 REQ/AC、相关设计章节、计划任务、代码、测试以及必要的 Decision/Bug record。

默认不加载全部历史 Release、全部 Git history、无关模块、依赖目录和构建产物。历史 Release 仅用于回归、影响分析和决策溯源。

## Human Decision Gates

以下事项必须暂停并获得明确确认：产品范围或需求变化、公开 API 破坏、Schema/DDL/迁移、长期兼容性的架构方向、权限或安全模型、新付费外部服务、破坏性操作、不可逆副作用，以及 push/PR/publish/deploy/release。

Gate 输出必须包含 Current Requirement、Evidence、Problem、Options、Trade-offs、Recommendation、Impact、Recovery 和 Human Decision Required。用户确认后再记录 DEC 并更新受影响事实源。

## 外部 Skill 路由

| 场景 | 首选能力 |
|---|---|
| 需求不完整 | `grill-me` 或等价 Requirement Clarification Skill |
| Architectural 设计 | `superpowers:brainstorming` |
| 多步骤计划 | `superpowers:writing-plans` |
| 正式实现隔离 | `superpowers:using-git-worktrees` |
| Feature/Bug/Refactor 实现 | `superpowers:test-driven-development` |
| Bug、失败、异常 | `superpowers:systematic-debugging` |
| 独立任务并行 | `superpowers:dispatching-parallel-agents` |
| 计划执行 | `superpowers:subagent-driven-development` 或 `superpowers:executing-plans` |
| 重要任务或合并前评审 | `superpowers:requesting-code-review` |
| 完成声明 | `superpowers:verification-before-completion` |
| 分支收尾 | `superpowers:finishing-a-development-branch` |

外部 Skill 缺失时使用可用的等价能力或最小本地流程，并明确降级；不得假装已调用。`vibe-workflow` 负责把结果写回 TECH_DESIGN、IMPLEMENTATION_PLAN、PROGRESS、DECISION、BUG 和 VERIFICATION。

## Skill 结构

`SKILL.md` 只保留 description、Constitution、入口 Gate、状态机、Router、全局关卡、外部 Skill 路由和 progressive disclosure index。详细内容分布到 `references/lifecycle.md`、`routing.md`、`artifacts.md`、`context.md`、`gates.md`、`execution.md` 与 `quality-and-release.md`。

会被复制到目标项目的 Markdown 模板存放在 `assets/templates/`。V0.1 不创建运行时脚本；只有真实使用证明存在重复、可机械检查的失败后，才考虑 validator。

## 行为测试

测试采用 Skill TDD：先在无 Skill 条件下运行 realistic pressure scenarios，逐字记录失败和 rationalization；再实现最小 Skill，重放相同场景；最后根据新 loophole 修正规则并复测。

Constitution 类场景必须全部通过：需求冻结、范围变化、破坏性/Schema Gate、发布授权和 evidence-based completion。Router、Context、Document Budget 场景不得出现严重误路由。高风险措辞需使用 fresh context 做 no-guidance control 和候选规则的多次 micro-test。

## V0.1 边界

V0.1 交付中文 `SKILL.md`、中文 references、中文项目模板、UI metadata、行为场景、评分规则和 baseline/post-skill 证据。状态枚举、文件名、frontmatter key、Requirement ID 和外部 Skill 名保留英文，以保证互操作性。
