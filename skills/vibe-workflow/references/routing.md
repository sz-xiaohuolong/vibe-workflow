# 任务路由与 Document Budget

## 何时读取

收到新任务、判断是否需要正式文档、区分 Tiny/Bounded/Architectural、处理 Spike，或决定是否并行时读取本文件。

## 路由顺序

```text
Applicable repository rules
→ Product/Risk/Decision Gates
→ Task Type
→ Complexity
→ Document Budget
→ Quality Profile
→ Dependency / Shared-state analysis
→ Serial or Parallel execution
```

Gate 必须先于复杂度和调度。不要先说“只是 Tiny”再检查权限；不要先把 Schema Task 分给 Agent 再补方案审批。

## Task Type

| Type | 判断 | 主要路径 |
|---|---|---|
| `NEW_PROJECT` | 没有已确认产品基线或现有系统 | Requirement Gate；通常 Architectural |
| `FEATURE` | 新增或改变用户可观察能力 | 判断是否属于当前 frozen scope |
| `BUG` | 实现偏离当前有效预期 | reproduce → root cause → regression test → fix |
| `REFACTOR` | 保持行为，改变内部结构 | 明确不变项、测试保护、最小范围 |
| `SPIKE` | 以学习/可行性为结果 | 定义问题、时限和丢弃边界；不把探针当生产实现 |
| `REQUIREMENT_CHANGE` | 改变冻结的产品意图 | 停止受影响工作，进入 Human Gate |

如果 Bug 调查证明实现符合 SPEC、真正错误是产品预期，则改为 `REQUIREMENT_CHANGE`。

## Complexity

### Tiny

同时满足：影响单点、行为明确、低风险、无跨模块共享状态、无 Gate、可在一个小验证闭环内完成。

使用用户精确请求作为 task-local frozen intent。通常不新建正式 PROJECT_BRIEF、SPEC、TECH_DESIGN 或 PLAN。若项目已有 PROGRESS/CHANGE 约定，只做最小同步。

若当前用户消息已精确指定单点、低风险且无语义变化的修改，它已经是该 Tiny Task 的明确人类决定；不要因为旧 baseline 的字面值不同而制造第二次 Human Gate。只有仍需 Agent 选择产品含义、边界、风险或 Acceptance 时，才升级为 `REQUIREMENT_CHANGE`。

示例：按钮文案、局部样式、明确的静态配置值。

### Bounded

有一个有限业务闭环，可能跨少量文件，但边界、Acceptance 和风险已知。记录 Task/Feature contract、相关 AC、实现任务和验证；没有架构选择时不强制完整设计文档。

示例：在当前 Release 已批准范围内增加“删除录音”完整闭环。

### Architectural

满足任一项：新项目/子系统、跨多个领域、改变长期接口/数据/权限、存在多个实质方案、多会话执行、迁移、跨外部系统且锁定长期契约或部署方式、失败难以回退。

需要完整 Requirement baseline、Effective SPEC、Technical Design/Decision、Implementation Plan 和 Release Verification。

### 跨模块可观察触发

只要改动触及以下任一项，至少按 Bounded 记录影响与验证，不能仅凭代码行数或单个文件判为 Tiny：

1. 同一持久化资源有多个写入入口或读取方。
2. 状态跨 API、SSE、缓存或后台任务传播。
3. 受影响流程涉及 Agent、MCP 工具、向量索引或检索结果的生产与消费。
4. 同一行为跨 Web/桌面/移动端、不同运行时或第三方服务。
5. 改动权限、密钥或数据暴露面。
6. Schema/迁移及依赖它的状态机、读写路径。

至少列出写入入口、读取方、传播/刷新/恢复路径、失败与取消路径、受影响及已检查未受影响的模块，并把对应行为映射到 AC 和验证。若触及长期公共契约、核心模型、迁移、多会话或难以回退的选择，升级 Architectural；第 5、6 类还须先通过 Security/Schema Gate。跨模块 Bug 沿用 BUG 记录并补影响范围，不因此强制新建完整 Release 文档。无共享状态、无跨边界影响的局部纯函数改动不因技术关键词出现而升级。

## Gate 覆盖规则

以下标签覆盖 Tiny/Bounded：

- Auth、Payment、Permission、Sensitive data
- Database schema、Migration、Destructive data operation
- Public API、Compatibility、Platform boundary
- Secret、Paid external service、Network data boundary
- Push、PR、Publish、Deploy、Release

代码行数不是风险等级。一行匿名下载条件修改属于 Security Gate；nullable 字段仍属于 Schema Gate。

## Document Budget

| 情况 | 必需持久化内容 |
|---|---|
| Tiny，未采用 vibe docs | 不强制新增文档；精确请求 + diff + evidence |
| Tiny，已有受治理项目 | 按现有约定更新 PROGRESS/CHANGE 中相关一行 |
| Bounded | Task/Feature contract、AC、相关 tests/evidence |
| Architectural | Release artifact 全套及必要 DEC |
| Bug | BUG record；只有复杂/跨模块时增加详细影响与进度 |
| Spike | 问题、范围、证据、结论、是否丢弃；不得标成功能完成 |

不要为了流程创建空目录、重复台账或没有事实所有权的文档。

## 自主决定与 Human Gate

Agent 自主决定：内部函数/类命名、私有接口、helper 抽取、局部文件组织、测试文件组织、沿用仓库既有模式的实现细节。

向用户请求决定：产品范围、目标用户、核心流程、平台边界、关键限制、Acceptance、公开兼容性、数据语义、权限、安全、付费服务和不可逆动作。

判断问题：这个选择是否会改变用户承诺、外部契约、数据含义、权限边界、长期成本或难以回退的方向？否，则通常是 Implementation Detail。

## 串行与并行

只有同时满足以下条件才允许 Execution Parallel：

- Task 没有未完成 Gate。
- 没有前后依赖。
- 不修改同一核心文件、Schema、迁移或共享写状态。
- 每个 Task 有独立 Context、Acceptance 和验证。
- 有明确 Integration/Review Gate。

可以并行：独立文案、独立纯函数测试、互不相交模块的只读调查。

必须串行：Schema 与依赖它的状态机、共享 API contract 的两端、同一核心文件、需要先做 Decision 的任务。

Exploration Race 可让多个 Agent 独立提出方案；比较和决定完成前不得并行实现。

## 计划执行与并行的优先级

若存在已批准的 written plan，先选择一个顶层执行 owner：当前会话使用 `superpowers:subagent-driven-development`，单独会话/检查点执行使用 `superpowers:executing-plans`。不要同时再启动 `superpowers:dispatching-parallel-agents` 作为竞争的顶层 workflow。

`dispatching-parallel-agents` 只用于：没有 written plan 的独立调查/分析，或顶层计划执行 owner 已明确下放的无依赖子任务。并行仍须满足本文件的 Gate、依赖、共享写状态和 Integration/Review 条件。
