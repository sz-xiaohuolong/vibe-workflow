# Quality、Risk、Review、Testing 与 Release

## 何时读取

选择 QA 强度、处理高风险模块、执行 Release Review、运行真实环境测试、声明完成、执行发布或封存 Release 时读取本文件。

用户仅要求 Commit / Push / PR 时采用 [Lightweight Git Workflow](execution.md#lightweight-git-workflow)，不启动本文件的完整 Release Review/Testing/Shipping。已有证据的适用性按代码范围和环境判断；Git 成功不提供新的功能验证证据，不改变 Workflow State 或 Verification Status。

## Quality Profile

优先使用项目已声明的 profile；没有时：明确 throwaway prototype 可用 Prototype，普通项目默认 Standard，面向真实用户/生产或高风险系统使用 Production。profile 显著改变成本或交付承诺时向用户展示建议和影响。

| Profile | 最低检查 |
|---|---|
| Prototype | build/run、核心测试、关键人工流程、已知限制 |
| Standard | unit/integration、lint/typecheck、build、回归、基本安全、关键用户流程 |
| Production | Standard + 深入安全、迁移、性能（相关时）、observability、部署/恢复验证 |

不要用 Production 清单压在普通 UI Tiny Task 上；也不要以 Prototype 标签跳过当前核心行为验证。

## Risk Tags

出现以下标签时提高验证强度，并读取项目相应安全/领域规则：

```text
AUTH  PAYMENT  DATABASE  FILE_SYSTEM  USER_INPUT
NETWORK_API  SECRETS  PERMISSIONS  PUBLIC_ENDPOINT
MIGRATION  DESTRUCTIVE_OPERATION
```

至少关注 Secret handling、input validation、AuthN/AuthZ、injection、data exposure、sensitive logs、destructive target 和 recovery。风险检查只覆盖实际受影响范围；不要求所有普通 Task 做完整安全审计。

---

## Task Verification 与交付三态

### Task Delivery Status

进度状态只描述当前 Task/功能的交付程度，独立于 Release 的 `Verification Status` 和 `Shipping Authorization`：

| 状态 | 可写入条件 | 不得推断 |
|---|---|---|
| `NOT_STARTED` / `IN_PROGRESS` / `BLOCKED` | 实际执行位置或阻塞证据 | 已实现或已验证 |
| `IMPLEMENTED_UNVERIFIED`（已实现待验证） | 代码或 artifact 已存在，但适用检查未运行、已过期或未覆盖 AC | `DONE`、`VERIFIED` |
| `POC_VALIDATED`（已通过 POC） | 有明确范围内的概念可行性演示或探针证据 | 正式功能已实现、Release AC 已通过 |
| `VERIFIED`（已验证） | 当前实现的适用 AC、自动化检查和受影响运行路径均有 fresh evidence；不适用项有理由 | Shipping Authorization 已获批 |

POC 是独立的局部证据；从 POC 转正式交付时，先确认正式需求、实现边界和 AC，再运行正式环境所需验证。仅有 POC 的 REQ/AC 仍为 `UNVERIFIED`。代码已写但 CI 将来才运行时保持 `IMPLEMENTED_UNVERIFIED`。一个 Release 的 Verification Status 由其全部适用 REQ/AC 和 Release 检查决定，不能由单个 Task 状态自动晋级。

根据项目运行能证明当前 Task 的最小充分检查：
- relevant tests；
- lint/typecheck/compile/build 中适用项；
- 受影响的用户行为或接口；
- migration/permission/security checks（适用时）；
- diff inspection；
- 关联 REQ/AC 的 evidence。

使用 fresh output。旧运行、CI 将来会跑、页面看起来正常、代码已存在或另一个 Agent 报告成功都不是当前证据。

---

## 阶段 4：Release Review（发布评审，置于系统测试之前）

在耗费高成本运行端到端真实测试之前，独立设置 Stage 4 Review，确保在代码与规格层面提前拦截隐患：

```text
Stage 3: Building (完成 Task 与单测)
    ↓
Stage 4: Review (规格合规性 + 工程质量 + 代码消肿)
    ↓ (通过全部 Critical/Important)
Stage 5: Testing (系统级真实环境/真实浏览器验收)
```

### 1. 显式调用独立代码评审
调用 `gstack:review`（或 `superpowers:requesting-code-review`），Reviewer 获得已冻结 SPEC/AC、精确 diff 范围和 Task 级单测证据，从独立视角审查。

### 2. 五维审查透镜 (Review Lenses)
1. **Scope / CEO 透镜**：核验 SPEC/AC 覆盖度，拦截未获批的 Scope Creep 与过度设计。
2. **Design Anti-Slop 透镜**：针对 UI/UX 审查是否存在廉价 AI 模板感（排版层次、间距、空状态、响应式）。
3. **Staff 隐蔽 Bug 透镜**：排查并发竞态、时区处理、资源泄露、边缘异常与破坏性兼容性。
4. **Codebase Deslop 透镜**：显式调用 `gstack:deslop-shared-libs`，审查多模块间是否重复实现局部 helper，提炼公共库。
5. **CSO 安全透镜**：若任务涉及安全/权限 Risk Tags，显式调度 `gstack:cso` 进行 STRIDE/OWASP 威胁建模。

Critical/Important 问题解决并重新通过复审后才能进入 Stage 5。发现根本性需求偏差时，必须回退至 Stage 1 走变更门禁。

---

## 阶段 5：Release Testing（真实环境系统测试）

### 1. Test Matrix (按项目类型定制策略)
- **Web / 前端项目**：使用 Playwright、真实 Chromium 探针（`gstack:qa` / `gstack:browse`）模拟真实交互。
- **API / 后端项目**：运行真实服务实例、API 集成测试套件与边界压力测试。
- **CLI 项目**：运行真实子进程命令，断言退出码、stdout、stderr 与文件系统副作用。
- **桌面 / 移动端项目**：在对应模拟器或真实环境执行打包与生命周期测试。

### 2. GUI/Web 真实运行证据标准 (.evidence/)
针对涉及界面或用户交互的系统，**严禁仅凭纯 Mock 单元测试声称验收通过**：
- 显式调用真实浏览器探针（`gstack:qa <url>`、`gstack:browse` 或 Playwright）；
- 捕获控制台日志（Console Errors，必须为 0 报错）；
- 捕获关键操作的页面截图与 Network HAR/请求日志；
- 将原始截屏与日志统一归档于 `.evidence/<release-id>/` 目录，并在 `VERIFICATION.md` 中建立索引。

### 3. Completion Claim Gate
任何 `DONE`、`FIXED`、`VERIFIED`、`READY_TO_SHIP` 声明前：
1. 明确证明该声明的具体命令与用户路径；
2. 运行完整检查并核对 exit code 与失败数；
3. 核对证据是否覆盖全部适用 REQ/AC 与 Test Seams；
4. 显式使用 `superpowers:verification-before-completion`（缺失时执行内置等价 gate）。

---

## 阶段 6：Shipping Gate 与两权分立

### Verification 与 Authorization 两权分立

```text
Verification Status: VERIFIED | PARTIAL | UNVERIFIED | FAILED
Shipping Authorization: NOT_REQUESTED | PENDING | APPROVED | DENIED
```

- `APPROVED` 不改变 Verification Status；人类授权不能把未测试改写为通过。
- 缺少适用 REQ/AC 证据时，绝对不能标 `READY_TO_SHIP`。
- 风险接受记录可以说明人类决定，但不能把未知结果写成 `VERIFIED`。

### READY_TO_SHIP Gate
必须同时满足：
- 当前 Release 的所有适用 REQ/AC 均达到 `VERIFIED`；
- 必需 checks 有 fresh evidence，`.evidence/` 包含有效真机/浏览器证据；
- 无未解决的阻断 review finding；
- docs/traceability 一致。

### Human Shipping Gate
正式 publish、deploy、release 需要对精确 target 的明确 Shipping Authorization，且仍须满足上述 READY_TO_SHIP Gate。获得授权后，**显式调用 `gstack:ship`**（或 `superpowers:finishing-a-development-branch`）执行发布所需的版本 Bump、Changelog 审计、Release Commit、Tag 与 PR 创建。

普通 `COMMIT | PUSH_BRANCH | COMMIT_AND_PUSH | OPEN_PR` 的明确操作授权独立于 Shipping Authorization；不要求 READY_TO_SHIP，可同步未验证的开发分支，不调用 `gstack:ship`。已知目标会自动触发正式部署/发布时仍适用完整 Shipping Gate，不能借普通 Git 请求绕过。

---

## 阶段 7：Reflecting 与 Release 封存

进入 `RELEASED` 后：
1. **显式调用 `gstack:retro`**：自动化分析提交历史、返工频率与耗时瓶颈；
2. 生成 `RETRO.md` 并执行经验分类沉淀：
   - 一次性缺陷 ➔ 归档 `BUG-xxx.md`；
   - 重大架构决策 ➔ 沉淀 `DECISION.md`；
   - 当前架构事实 ➔ 合并更新 living `TECH_DESIGN.md`；
   - 重复性 Agent 错误 ➔ 提炼反模式写入 `AGENTS.md`；
   - 新产品构想 ➔ 记录为下一 Release 候选 Backlog。
3. 将本次 Release 所有 artifacts 封存为不可篡改历史快照。
