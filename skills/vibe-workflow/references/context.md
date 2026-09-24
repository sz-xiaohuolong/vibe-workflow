# Context Governor

## 何时读取

首次接入、跨会话恢复、开始 Task、上下文膨胀、历史文档很多，或准备给其他 Agent 组装任务输入时读取本文件。

## 原则

**Minimal Sufficient Context**：足以正确完成当前决策或 Task 的最小事实集合。Context Governor 同时是 Cost Governor。

不以“读得越多越安全”为默认。混入历史、无关决策和未生效方案会降低事实一致性。

## Bootstrap Pack

首次接管仓库时读取：

- 从当前目录向上适用的 AGENTS.md。
- README、依赖和构建/测试入口。
- 现有需求、设计、进度、决策、Bug、迁移与发布目录的职责。
- 当前工作树、分支和最近相关状态。
- PROJECT/Document Map 或等价索引。

用户明确运行 `$vibe-workflow init` 时按 [init.md](init.md) 审计和更新映射；需求未冻结不妨碍现状审计与事实记录，但不能因此进入 SPEC/Build。

目的只是建立事实源地图和当前 Release，不是把整个仓库永久留在上下文。

## Resume Pack

新会话依次读取：

1. AGENTS.md。
2. 唯一权威的 PROJECT/Document Map，按其中真实路径定位资料。
3. PROGRESS。
4. 当前 Release 的 PROJECT_BRIEF 和 Effective SPEC 中相关部分。
5. 当前 Task 对应的 PROPOSED_DESIGN、当前 TECH_DESIGN、PLAN、代码、测试和 evidence；没有目标架构变化时省略 PROPOSED_DESIGN。

然后核验：

- Current Release 是否存在。
- Workflow State/Operational Status 是否与 artifacts 一致。
- Current Task 是否有未完成 Gate。
- Last Stable Commit 是否可定位；没有 Git 时使用明确的 stable artifact/state。
- 上次 evidence 是否仍适用于当前代码。

聊天内容可以提供线索，不能覆盖仓库证据。发现冲突时报告并修正错误事实源。

## Task Context Pack

每个 Task Pack 应能单独回答：

- 目标：当前 Task 的唯一交付是什么？
- 范围：关联哪些 REQ/AC，明确不做什么？
- 设计：相关模块、接口、数据和批准 Decision 是什么？
- 现状：相关代码/测试目前如何工作？
- 验证：什么命令或用户路径证明完成？
- 状态：上一个稳定点、已知 Bug、阻塞和 Next Task 是什么？

典型内容：

```text
AGENTS relevant rules
PROJECT path map
PROGRESS current task block
SPEC relevant REQ/AC
PROPOSED_DESIGN relevant approved section, when applicable
TECH_DESIGN current-state relevant section
IMPLEMENTATION_PLAN current task
related code and tests
relevant DEC/BUG only
```

## 默认排除

- 历史 Release 的全部 PROJECT_BRIEF/SPEC/VERIFICATION。
- 无关 Bug、Decision、模块和测试。
- 整个 Git history、全部 PR 讨论。
- node_modules、vendor、build artifacts、generated files。
- 已拒绝或未批准的方案正文，除非当前 Decision 需要比较。
- 与当前任务无关的外部资料。

## 何时加载历史

仅当当前问题需要：

- 回归定位或兼容性比较。
- Requirement/architecture 决策溯源。
- 数据迁移的上一支持版本。
- 已知 Bug 的引入点。
- 审计历史发布事实。

即使需要历史，也先读取明确关联的 Release/DEC/commit，不全量加载。

## 为 Agent 组装 Context

给并行或评审 Agent 的 prompt 使用正向 contract：

1. Objective。
2. Exact scope 和 non-goals。
3. Required source paths/sections。
4. Applicable REQ/AC/Decision。
5. Allowed side effects 和 Human Gates。
6. Expected evidence/output。

不要传递整个聊天历史。不要把 evaluator oracle、怀疑的 bug 或预期结论泄露给独立行为测试 Agent。

## Context 刷新

以下情况建立 fresh context，而不是继续堆积：

- 进入新的 Vertical Slice。
- Requirement Change 已批准并使旧假设失效。
- Circuit Breaker 触发。
- 当前上下文包含大量历史或互相矛盾的方案。
- 独立 Review/Verification。

刷新前更新 PROGRESS 和必要 evidence，保证新会话能从仓库恢复。
