# 验证、评审与发布

## 何时读取

选择验证范围、处理高风险模块、评审、系统验收、完成声明或发布时读取。仅 Commit / Push / PR 使用 [Lightweight Git Workflow](execution.md#lightweight-git-workflow)，不启动完整 Release 流程。

## Quality Profile 与本次范围

优先项目 profile；缺省普通项目 Standard，明确丢弃的原型 Prototype，高风险交付 Production。profile 描述质量目标，不是每个 Task 都要重跑的清单。

| Profile | 按改动选择的检查 |
|---|---|
| Prototype | 可运行探针、核心假设、已知限制；结果只支持 POC |
| Standard | 相关单测/集成、适用 lint/typecheck/build、受影响用户路径与风险 |
| Production | Standard + 实际涉及的安全、迁移、性能、可观察性及发布/恢复检查 |

Production 项目中的纯文案 Tiny 仍按 Tiny 验证；一行权限条件改变仍需安全检查与批准。Risk Tags 包括 AUTH、PAYMENT、DATABASE、FILE_SYSTEM、USER_INPUT、NETWORK_API、SECRETS、PERMISSIONS、PUBLIC_ENDPOINT、MIGRATION、DESTRUCTIVE_OPERATION，只扩大实际受影响范围。

## 验证预算与停止条件

开始前在当前任务记录或对话明确：本次要支持的声明、受影响路径、最小检查集合、已有可复用证据。无须建立单独预算台账。

| 路径 | 默认执行预算 | 升级原因 |
|---|---|---|
| Tiny 无行为变化 | diff 与必要静态/局部检查；不新写镜像测试，不启动完整服务或 QA | 发现实际行为、共享状态或风险边界变化 |
| Tiny 行为 / Bounded | 最小相关测试集，一次受影响真实路径验证（适用时） | 失败、新风险、共享依赖变化或覆盖不足 |
| Architectural / Release | 风险与 AC 覆盖矩阵；复用有效局部/CI 结果，只补缺口 | 公共契约、依赖/环境变动、集成风险或项目强制全量检查 |

“最小”不是固定测试数量，必须能证明本次承诺；一次命令可覆盖多项 AC，一份证据只存一次并由多处引用。先低成本检查，再付费、长耗时或全量测试。高成本步骤须与本次范围相称；新增付费服务仍过授权 Gate。

适用检查通过且无新变化就停止。重跑必须有具体原因：修复使证据失效、环境改变、失败调查或明确额外验收要求。换技能、切阶段、提交、格式调整、上下文压缩都不是独立重跑理由。不得为了“更放心”无限扩测试，不以减少成本为理由忽略必需检查。

## fresh evidence 的适用性

fresh 指与当前被测对象对应，不等于每轮对话重新执行。复用前读取原始运行结果或可信 CI 记录，核对：

- 被测 commit/tree 或相关文件摘要；未提交改动须可识别。
- 命令、测试范围、真实退出码/失败数、时间与环境。
- 相关依赖、配置、测试输入和外部服务状态是否改变。

无关文档提交可复用已有代码验证，说明范围即可；依赖锁文件、公共模块、构建配置、环境或相关外部状态变化时重验受影响部分。线上健康具有时效性，不能沿用上次部署前的健康结果替代本次发布后检查。只有 Agent 的“通过”摘要、缺失原始结果或无法确定输入的旧日志不算可复用证据。

## Task Delivery Status

| 状态 | 条件 |
|---|---|
| NOT_STARTED / IN_PROGRESS / BLOCKED | 实际执行位置或阻塞 |
| IMPLEMENTED_UNVERIFIED | 实现存在，但必要检查未运行、失效、失败或覆盖不足 |
| POC_VALIDATED | 指定范围的可行性已有证据，不代表正式功能完成 |
| VERIFIED | 本次适用 AC 与受影响路径都有有效证据，不适用检查已说明理由 |

Task VERIFIED 不自动推进 Release。完整 Release 仍须全部适用 REQ/AC 和必需检查；没有覆盖的保持 PARTIAL/UNVERIFIED/FAILED。代码存在、CI 将来会跑、页面观感或授权均不能替代证据。

## 阶段 4：Review

正式 Release 在高成本系统 Testing 前评审规格、diff 与风险；局部开发测试可以先运行。Tiny 自查 diff，Bounded 聚焦受影响范围，Architectural/Release 使用独立审查；用户明确要求时按其范围执行。

`gstack:review` 与 `superpowers:requesting-code-review` 选一个主审查；已有同一 diff 的有效审查可以复用。只在实际 UI 风险、并发/边界风险、安全风险或重复实现问题上追加对应透镜，`deslop-shared-libs` 与 `cso` 不是所有 Task 的必经步骤。没有值得抽取的公共逻辑时不制造重构。

调用遵守 [编排契约](orchestration.md)，控制修改、提交和外部审查副作用。阻断问题修复后复审受影响部分；发现产品偏差回 Thinking。不能把旧 diff 的审查批准套在新增修复上。

## 阶段 5：Testing

| 项目 | 真实运行路径 |
|---|---|
| Web/GUI | qa-only、browse、Playwright 或宿主浏览器测试受影响交互；不能用纯 Mock 证明系统行为 |
| API/后端 | 真实服务的相关接口与集成；压力测试只在性能风险或验收要求时运行 |
| CLI | 真实子进程、退出码、输出与实际文件副作用 |
| 桌面/移动端 | 对应模拟器或设备的受影响流程；打包/生命周期只在相关范围验收 |

纯验收优先 `gstack:qa-only`；`gstack:qa` 会修复并提交，只在这些动作均获授权时调用，否则只读验收后由 owner 修复。任何修复都回 Building，并对变更做 Review 和 Testing；只重验失效部分。

### 真实证据按问题采集

- 功能路径记录步骤、预期/实际和失败数；视觉验收按需保留关键状态截图，不为每个动作截图。
- 控制台检查限定本次会话和路径。新增或相关错误必须解释/修复；已有无关第三方错误记录来源与影响，不能通过清空控制台制造“零报错”，也不因无关噪声阻断所有交付。
- HAR、视频、trace、全量网络日志默认关闭；只在对应网络/时序/间歇故障调查或项目明确要求时开启，脱敏后保留必要片段。
- 原始文件按 [证据预算](artifacts.md#证据预算与保留策略) 留存；Tiny 无行为文案检查不强制启动浏览器或建目录。

### Completion Claim Gate

任何 DONE、FIXED、VERIFIED、READY_TO_SHIP 声明前：确定声明范围 → 检查证据有效性 → 仅运行缺失/失效的必要检查 → 读真实退出码与失败数 → 核对覆盖与限制 → 报告实际结果。

需要外部检查协议时可用 `superpowers:verification-before-completion`；与本次预算或证据复用要求冲突时执行上述内置 Gate。不要宣称调用了未运行的技能或把静态审查写成真实执行。

## 阶段 6：Shipping Gate

```text
Verification Status: VERIFIED | PARTIAL | UNVERIFIED | FAILED
Shipping Authorization: NOT_REQUESTED | PENDING | APPROVED | DENIED
```

APPROVED 不改变验证事实，风险接受不能把缺失检查改成通过。

### READY_TO_SHIP Gate

- 全部适用 Release REQ/AC 与必需检查已有有效证据；允许组合、复用可核对结果。
- 无阻断 review finding，相关文档/追踪一致。
- 需要真实环境验证的行为有对应证据；CLI 不要求浏览器，文案不要求 HAR。
- 长期发布证明可取回；不依赖将被清理的唯一原始文件。

### Human Shipping Gate

正式 publish、deploy、release 须满足 READY_TO_SHIP Gate 与精确目标的 Shipping Authorization。已有明确授权直接使用；只在目标、风险或范围改变时重新确认。

默认选择项目已有的直接发布路径，个人开发不强制 PR、功能分支、worktree 或 `gstack:ship`：

1. 核对本次范围、仍适用的验证结果、目标分支/环境和已有发布授权，只补缺失证据。
2. 按项目约定更新版本和必要变更说明，使用原生 Git 提交、推送；Tag、Release、软件包或部署只执行本次目标需要且已获授权的动作。
3. 核对远程提交及实际发布回执。软件包验证包名/版本，服务部署验证目标/版本和适用 smoke/健康结果；不为无部署的发布强造健康检查。
4. 在既有发布记录中保留结果与证据；小版本不为 Shipping 补建整套文档、多角色评审或完整复盘。

只有用户显式要求 PR 时才创建，并按需要选择 `gstack:ship` 或 `superpowers:finishing-a-development-branch`；已有 PR 需合并和部署时可使用已获授权的 `gstack:land-and-deploy`。技能若强制 PR 而本次选择直发，就使用原生 Git 与项目命令，不调用该技能。分支保护要求 PR 时报告限制并等待用户选择，不绕过规则或擅自创建 PR。

PR、分支推送或 ship 成功不能单独证明实际发布完成；达到本次目标的产物、版本和结果均核实后才标 RELEASED。

普通 `COMMIT | PUSH_BRANCH | COMMIT_AND_PUSH | OPEN_PR` 继续走 [Lightweight Git Workflow](execution.md#lightweight-git-workflow)，无需 READY_TO_SHIP，不调用 ship，不改变原验证状态。已知会触发正式发布的 Git 目标仍需发布 Gate。

---

## 阶段 7：Reflecting

发布后只沉淀有用事实：简单 patch 可在既有记录写几句结果与教训；复杂 Release 或用户要求时用 `gstack:retro` 分析返工、提交和耗时。只有重复的项目行为问题才更新 AGENTS，架构确有变化才更新 TECH_DESIGN，不机械改所有文件。

保留发布时的验证与授权事实，封存历史。发现的新产品想法进入候选 Backlog，不能污染下一版冻结范围。证据清理仍保护长期证明和活跃引用。
