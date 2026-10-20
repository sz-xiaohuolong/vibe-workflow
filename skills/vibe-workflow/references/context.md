# Context Governor

## 何时读取

首次接入、跨会话恢复、开始 Task、上下文膨胀、历史文档很多，或准备给其他 Agent 组装任务输入时读取本文件。

## 原则

**Minimal Sufficient Context**：足以正确完成当前决策或 Task 的最小事实集合。Context Governor 同时是 Cost Governor。

不以“读得越多越安全”为默认。混入历史、无关决策和未生效方案会降低事实一致性。

## Bootstrap Pack

仅明确接管或复杂任务需要 Bootstrap Pack；普通 Tiny 与 Git 请求只读适用项目规则、相关文件、必要状态。首次接管仓库时读取：

- 按宿主实际机制适用的上级与范围内规则，以及按 [规则入口定位](init.md#规则入口定位) 找到的 `AGENT.md` 或 `AGENTS.md`；不把文件名兼容当作宿主自动加载保证。
- README、依赖和构建/测试入口。
- 现有需求、设计、进度、决策、Bug、迁移与发布目录的职责。
- 当前工作树、分支和最近相关状态。
- PROJECT/Document Map 或等价索引。

用户明确运行 `$vibe-workflow init` 时按 [init.md](init.md) 审计、合并规则和更新映射；只读请求不写文件。需求未冻结不妨碍现状审计与事实记录，但不能因此进入 PRD/Build。空仓库新项目在范围确认且获准进入 Planning 后执行同一协议的最小规则接入，无需额外 init；首轮澄清、Tiny 与普通 Git 不触发。

目的只是建立事实源地图和当前 Release，不是把整个仓库永久留在上下文。

## Resume Pack

先按本次意图分流；Tiny 不遍历 Release 文档，也不因缺少 Release ID 阻塞。Bounded 优先从既有任务记录恢复目标、批准范围、验收和进度；没有正式 Release 时不补建 Release 文档。需要恢复完整 Release 状态时依次读取：

1. 按同一入口定位顺序读取真实项目规则文件，不只查默认 `AGENTS.md`；宿主未自动发现的已采用入口须显式读取。
2. 唯一权威的 PROJECT/Document Map，按其中真实路径定位资料。
3. PROGRESS。
4. 当前 Release 的 PROJECT_BRIEF 和 Effective PRD 中相关部分。
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
实际规则入口中的相关约束
PROJECT path map
PROGRESS current task block
PRD relevant REQ/AC and Test Seams
PROPOSED_DESIGN relevant approved section, when applicable
TECH_DESIGN current-state relevant section
IMPLEMENTATION_PLAN current task (Task Handoff Contract)
related code and tests
relevant DEC/BUG only
```

## 七阶段 Minimal Context Pack 映射

按阶段精准注入事实，严禁全量加载造成上下文污染与 Token 爆炸：

| 阶段 | 允许加载的核心上下文 | 严禁加载的冗余内容 |
|---|---|---|
| **1. Thinking** | 用户原始输入、实际项目规则、既有项目事实与地图 | 历史代码细节、PRD 模板、长篇实现计划 |
| **2. Planning** | 冻结的 PROJECT_BRIEF、living TECH_DESIGN、架构备选方案 | 具体的非关键业务代码、未获批的临时设想 |
| **3. Building** | 当前 Task Handoff Contract、相关 PRD/AC/Seams、最小受影响代码与单测 | 整个 Release 的非关联模块代码、全部 Git 日志 |
| **4. Review** | 冻结 PRD/AC、本次 Release 纯净 Diff、Task 级单测证据 | 漫长的调试过程、全部聊天上下文 |
| **5. Testing** | Test Matrix、系统运行环境、端到端测试入口与探针配置 | 内部辅助函数的细枝末节、早先废弃的原型代码 |
| **6. Shipping** | `VERIFICATION.md`、CHANGELOG、VERSION、部署配置 | 已经通过的单元测试过程细节 |
| **7. Reflecting** | 本次 Release 返工记录、Circuit Breaker 快照、Bug 归档、实际项目规则 | 业务功能正文、外部网络参考资料 |

## 默认排除

- 历史 Release 的全部 PROJECT_BRIEF/PRD/VERIFICATION。
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
