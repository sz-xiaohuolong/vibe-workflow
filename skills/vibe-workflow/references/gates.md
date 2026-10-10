# Product、Requirement 与 Decision Gates

## 何时读取

需求未冻结、发现 scope creep、需要 Schema/权限/公开接口/付费服务/破坏性操作，或不确定一个选择属于 Product Intent 还是 Implementation Detail 时读取本文件。

## Product Intent 与 Implementation Detail

Product Intent 必须由人类确认：

- 功能范围、非目标、目标用户、核心用户流程。
- 平台与 Release 边界。
- 关键限制、Acceptance Criteria。
- 数据业务含义、保留/删除语义。
- 权限、安全、公开兼容性和付费承诺。

Implementation Detail 默认委派给 Agent：

- 私有命名、类/函数拆分、helper。
- 私有接口和普通目录组织。
- 测试文件组织。
- 在不改变外部承诺时沿用仓库模式的局部实现。

判定问题：选择是否改变用户承诺、外部契约、数据含义、权限边界、长期成本或难以回退的方向？是，则进入 Gate。

## Requirement Change Workflow

```text
STOP affected implementation
→ gather evidence
→ write change proposal
→ Human Decision
→ new Requirement Version/baseline
→ update Effective SPEC
→ impact analysis
→ update Design/Plan/Progress
→ resume from earliest invalidated state
```

Change Proposal 必须包含：

1. Current Requirement 和关联 REQ/AC。
2. Problem。
3. Evidence。
4. Impact：用户、数据、权限、兼容性、成本、计划和验证。
5. Options 与 trade-offs。
6. Recommendation 和理由。
7. Recovery/rollback。
8. Human Decision Required。

未确认时可以调查并保存待确认方案；不得把它写成 Effective SPEC、migration 或既成产品行为。

## Approval Contract

有效批准必须指向一个明确方案及其已展示影响。以下不充分：

- “直接做吧”但没有冻结范围。
- “你自己决定细节”但选择改变产品行为。
- “就一个字段”但数据语义、迁移和恢复尚未说明。
- 对旧方案的批准被用于扩大后的新方案。

调查完成、代码写法已知、方案文档已创建都不等于获批。方案影响发生实质变化时，状态回到 `WAITING_HUMAN` 并重新确认。

普通 Git 操作采用 [Lightweight Git Workflow](execution.md#lightweight-git-workflow)：用户明确要求 Commit / Push / PR，且仓库、diff 范围与目标已确定时，该请求就是本次操作的明确授权；`COMMIT_AND_PUSH` 的授权覆盖同一范围内的提交和推送，不再重复申请。普通 Git 操作授权不等于 Shipping Authorization。目标分支不明、force push（包括 `--force-with-lease`）、覆盖历史、未授权危险修改或已知部署副作用须单独明确确认；普通 Push 授权不能被扩大使用。

## Schema / Migration Gate

任何表、字段、索引、约束、关系、数据回填、删除或等价 ORM schema 变更都遵循：

```text
investigate
→ proposal marked pending
→ explicit human approval of the presented plan
→ migration implementation
→ migration verification
```

方案至少说明：

| 项目 | 内容 |
|---|---|
| 业务语义 | 谁创建/读取/修改/删除，状态和保留期含义 |
| 现状 | 表结构、数据量/质量、读写路径、下游依赖 |
| 模型 | 类型、可空性、默认值、主外键、唯一/检查约束、索引 |
| 选项 | 维持现状、扩字段、拆/合表或其他方案的取舍 |
| 迁移 | 顺序、锁/性能、回填、兼容窗口、发布次序 |
| 安全 | 权限、敏感数据、审计、软删/硬删 |
| 恢复 | 备份、失败处理、可验证 rollback/forward fix |

产品负责人说“直接迁移”不能替代对具体数据方案的批准，除非上述语义、影响和恢复已经展示并被明确接受。

## Architecture Gate

只有会锁定长期方向或跨外部边界的 Architecture 选择需要 Human Gate，例如：公共协议、核心数据模型、部署拓扑、跨平台兼容、重要供应商依赖。

普通模块拆分和内部实现路径无需频繁询问。若确需 Gate，先调用 `superpowers:brainstorming` 或等价能力比较 2–3 个实质方案，再记录 DEC。方案评审时可借助多维审查透镜：CEO 减法（砍过度设计）、设计审美（防 AI Slop 塑料感）及工程复杂度（或调用 `gstack:autoplan` 统一走查）。

## Security / Permission Gate

UI 改动不能代表授权正确。改变匿名访问、AuthN/AuthZ、Secret、敏感日志、用户输入、公开 endpoint 或数据暴露时：

- 调查真实执行层的权限检查。
- 遵循 STRIDE 威胁建模与 OWASP 安全准则（可用时调用 `gstack:cso` 执行结构化威胁分析）。
- 说明角色、资源、操作和失败行为。
- 评估数据泄露、绕过和审计。
- 得到明确产品/安全决定后再实现。

## External Service Gate

新付费服务、Secret、网络数据传输或供应商锁定需要说明：成本、数据流、隐私/合规、失败模式、退出方案、替代方案和 Release 影响。试用 key 不构成接入授权。

## 七阶段核心门禁一览

| 阶段 | 守门门禁 (Gate) | 判定依据 | 未通过时的阻断行为 |
|---|---|---|---|
| **1. Thinking** | **Requirement Freeze Gate** | 需求无歧义、首轮禁止写文件、AC 明确 | 保持 `WAITING_HUMAN`，严禁建立 SPEC/PLAN 或写代码 |
| **2. Planning** | **Design & Plan Gate** | 方案通过多维评审、Test Seams 明确、任务依赖拓扑就绪 | 保持 `DRAFT`，严禁派发任务进入 Building |
| **3. Building** | **Task TDD & Handoff Gate** | 遵循红绿循环、局部单测全绿、无越界改动 | 严禁标为 `IMPLEMENTED`，连续 3 次失败触发熔断 |
| **4. Review** | **Release Review Gate** | Spec 100% 合规、无 Scope Creep、代码质量全过 | 严禁进入 Testing，直接打回 Building 修复 |
| **5. Testing** | **Release Verification Gate** | 所有适用 REQ/AC 达到 `VERIFIED`，真机/浏览器证据新鲜有效 | 严禁进入 `READY_TO_SHIP`，记录 Bug 回退修复 |
| **6. Shipping** | **Human Shipping Gate** | Release 就绪，人类针对明确发布 target 做出授权 | 严禁执行未经授权的 publish / deploy / release；普通 Git 另走轻量流程 |
| **7. Reflecting** | **Continuous Learning Gate** | 结构化复盘完成、经验沉淀入 `AGENTS.md` | 严禁篡改已封存历史或污染下版 Frozen Scope |

## Verification 与 Shipping 分离

- Verification Gate 只由实际证据决定。
- Shipping Gate 决定是否执行正式 publish/deploy/release；普通 commit/push/PR 的操作授权独立判断。

人类风险接受不能把 `UNVERIFIED` 改成 `VERIFIED`，也不能让缺少 REQ/AC evidence 的 Release 成为 `READY_TO_SHIP`。

V0.3 严格延续两权分立，不支持 emergency release 旁路：

- `publish/deploy/release` 的必要前置条件是 Workflow State 已为 `READY_TO_SHIP`，之后仍需对精确 target 获得 Shipping Authorization。
- 普通 commit/push/PR 可按 Lightweight Git Workflow 的已有明确授权执行，无须完整 Release Verification；保留原 Current Stage、Workflow State 与真实 Verification Status，不得因 Git 成功声称已验证、可发布或 Release 完成。
- 人类若要求发布未验证版本，拒绝执行该发布动作，记录缺口与后果；不得用“已接受风险”绕开生命周期状态。
