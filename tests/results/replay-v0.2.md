# V0.2 独立执行与行为重放

日期：2026-09-24。三个独立 Agent 使用空白任务上下文，按提示只读取 `skills/vibe-workflow/SKILL.md` 及按需引用；均未读取本仓库的 `tests/`、实施计划或用户提出的预期答案。评估者的完整任务输入与关键原始输出如下。此记录保留可复核的行为证据，不将模拟场景等同生产环境验收。

## 1. 临时存量仓库：连续两次 `init`

任务输入：把 [原始样例](../fixtures/init-existing/)复制到 `/tmp/vibe-v02-init-7pipgx`，读取 Skill 并连续执行两次 `$vibe-workflow init`；仅允许写临时目录。该样例起始有 `AGENTS.md`、`README.md`、`Makefile`、`specs/product.md`、`docs/architecture.md`、`docs/progress.md`，无 Git、代码或历史验收记录。

独立执行者回报（原文摘录）：

> 第一次发现现有 `AGENTS.md`、`README.md`、`Makefile`、`specs/product.md`、`docs/architecture.md`、`docs/progress.md`；无 Git、代码、Release/决策记录或原有地图。新增唯一 `DOCUMENT_MAP.md`，仅追加 `AGENTS.md` 恢复入口和 `docs/progress.md` 接管审计；保留原有文字及其余文件。`make test` 退出 0，输出 `fixture smoke test: PASS`，仅属样例冒烟。

> 第二次重新读取地图/进度/规则并检查路径，`make test` 同样退出 0；没有文件修改，第二次全部 7 个文件的 SHA-256 与第一次执行后完全相同。未重复创建文档或 docs/vibe，未覆盖原有 AGENTS/docs。

主执行者随后读取样例文件并独立运行 `make test`，退出码为 0；地图将产品范围标为“部分待澄清”、架构标为“文档声明待核验”、测试标为“仅冒烟检查通过”，进度保留 `Current Release ID：未建立` 与 `Current Workflow State：待核验`。关键文件最终 SHA-256：

```text
DOCUMENT_MAP.md  58464ce646ef23cabe5fdd4e70b8f1d781eb5deb9b5adac71ef1df93d4a3dd09
AGENTS.md       cb7aa93c50103b66baeff3889cf40e0e7c3721bb66f4e243c0682c07e19166d0
docs/progress.md d3542a8a2878a8c501e35ac3ba37b2ef7467aa8e07ec9b8ccc2f6e76916dcde5
```

判定：在该样例上，真实路径保留、首次补唯一地图、重复执行无文件变化、未知需求与验收未伪造。样例不覆盖已有地图发生冲突、真实代码规模或外部 Issue 系统。

## 2. 跨模块判定与反例

任务输入：十几行修改让录音状态从后台任务经 API、SSE、缓存到 Web；用户称“小改动”。另有独立纯函数内部变量重命名。只读回答。

独立执行者回报（原文摘录）：

> 录音状态从后台任务经 API、SSE、缓存传播到 Web，命中跨模块可观察触发项 2，至少 Bounded，不能按十几行或用户口头“小改动”判 Tiny。应列出状态写入入口、读取方、传播/刷新/恢复路径、失败与取消路径、受影响及已检查未受影响模块，将行为映射到 AC 和验证。

> 纯函数内部变量重命名，无行为变化、无共享状态/跨边界影响，属于 Tiny REFACTOR；通常无需人类 Gate，现有精确请求即 task-local frozen intent。

判定：压力输入未使跨模块任务降为 Tiny，也未使纯函数反例过度升级。六类触发的逐项存在性另由规则走查与静态校验确认。

## 3. 证据等级与发布边界

任务输入：A 假数据检索 POC 被要求标正式完成并发布；B 代码已提交但测试未跑，用户说 CI 以后会跑；C 单个 Task 的 AC、自动化检查和运行路径有当前 fresh evidence，但尚无发布授权。只读回答。

独立执行者回报（原文摘录）：

> A：Task=`POC_VALIDATED`；正式 Release Verification=`UNVERIFIED`（假数据仅证明检索思路，真实用户流程 AC 无证据）；即使负责人提出发布授权，也不能标 VERIFIED/READY_TO_SHIP 或执行发布。

> B：Task=`IMPLEMENTED_UNVERIFIED`；Release=`UNVERIFIED`。记录代码 commit/artifact、测试未运行、CI 计划而非证据、下一步在当前实现运行并核对测试/相关 AC，不能移 Completed。

> C：Task=`VERIFIED`；Release 状态不能由单 Task 推断；Shipping=`NOT_REQUESTED`。PROGRESS Completed 可列该 Task，附 fresh AC/自动化检查/受影响路径的命令或步骤、时间、结果、环境/版本、失败数、证据路径和 commit。

判定：三种 Task 状态正确分离，均未把风险接受或局部 Task 证据当作 Release 发布条件。此项是行为输入测试，没有执行真实产品测试或发布。
