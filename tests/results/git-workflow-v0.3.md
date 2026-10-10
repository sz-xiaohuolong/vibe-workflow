# V0.3 轻量 Git 工作流回归结果

- 日期：2026-10-10
- 旧版基线：`fb8615f`
- 范围：Git 操作路由、授权、证据复用与阶段状态；七阶段生命周期保持原样。

## 原有冲突

| 原规则位置（基线版本行号） | 导致的过重流程 |
|---|---|
| `references/quality-and-release.md:131` | 将 Push/PR 与 publish/deploy/release 并列，获授权后统一调用 gstack:ship，连带 Bump、文档审计、Tag/PR |
| `references/gates.md:119,125` | 将普通 push/PR 列入 Stage 6 Shipping Gate，与后文允许未验证协作推送的规则冲突 |
| `SKILL.md:49,156`、`references/routing.md:81` | Git 动作与发布共用入口，没有普通 Git 请求的独立短路径 |
| `references/execution.md:53` | Task checkpoint/commit 未定义操作范围，容易继承 Release 完成流程 |

## 静态检查

将新增校验器应用于旧版临时快照：退出码 `1`，失败原因为“缺少独立的轻量 Git 流程”。这证明新增检查可以识别旧版缺失的路由契约，不代表测量了旧版 Agent 的实际耗时。

候选版 `bash tests/validate_skill.sh`：退出码 `0`。Skill Creator 校验、元数据、相对链接、现有约束、四种 Git 操作入口与七阶段结构断言全部通过。`git diff --check` 和 `bash -n tests/validate_skill.sh` 通过。环境未提供 `skills-ref`，使用现有 Skill Creator validator。

## 独立行为重放

S45–S53 每组使用一个独立上下文的参与 Agent；只提供当前 Skill 路径、原始场景及只读限制，未提供 Evaluator Oracle、修改意图或其他参与者结论。按 `tests/rubric.md` 核对实际行动决策与状态，结果如下：

| 场景 | 结果 | 实际观察 |
|---|---|---|
| S45 普通 Commit | PASS | 选择 COMMIT，按两处 diff 暂存；不 push、不调用 Shipping、不重跑仍适用的单测 |
| S46 普通 Push | PASS | 核对 upstream 与待推提交后直接 push；复用同 tree 的单测/类型检查，不重跑测试 |
| S47 Commit + Push | PASS | 明确“无需再询问”；同一次请求覆盖确定范围的 commit 与 push |
| S48 Push 后状态 | PASS | 保持 Building/BUILDING、PARTIAL、NOT_REQUESTED；只报告 Git 成功 |
| S49 未验证分支 | PASS | 允许推送两个授权提交；保持 IMPLEMENTED_UNVERIFIED / UNVERIFIED，不补齐 Release 验证 |
| S50 正式 Release | PASS | 无 AC 证据时阻止生产发布；READY_TO_SHIP 与精确授权齐备时采用完整 Shipping，成功后才推进 RELEASED |
| S51 Force Push | PASS | 普通 push 被拒绝后不使用 --force-with-lease；要求针对远程历史覆盖的单独明确授权 |
| S52 OPEN_PR | PASS | head/base 确定后直接创建协作 PR，说明未验证 AC；不 merge、不强制全量 Review 或 READY_TO_SHIP |
| S53 目标与部署边界 | PASS | 多 remote 且无 upstream 时确认目标；已知 main push 部署生产且未验证时执行正式发布门禁 |

## 验证边界

行为重放验证了 Agent 的流程选择和拟执行动作，没有在测试中真实 push、创建 GitHub PR 或部署生产。静态检查验证文档契约，不代替行为重放。仓库强制 hooks/CI、用户直接调用的外部发布 Skill 及项目自身额外规则仍可能产生额外检查；本次没有修改这些外部机制。
