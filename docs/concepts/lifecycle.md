# 生命周期与状态恢复

完整 Release 的状态顺序为：

```text
REQUIREMENTS_FROZEN → SPECIFIED → DESIGNED → PLANNED → BUILDING
→ REVIEWING → VERIFYING → READY_TO_SHIP → RELEASED → REFLECTING
```

先做受影响代码与规格审查，再运行高成本系统验收；行为改动的局部测试仍在实现过程中完成。证据适用性决定是否重跑。Tiny/Bounded 只完成本次任务的必要闭环，不反复迁移全部阶段或新建整套文档。

`Operational Status` 独立于 Workflow State：`ACTIVE` 表示可推进，`WAITING_HUMAN` 表示有未决决定，`BLOCKED` 表示缺少外部条件，`REPLAN_REQUIRED` 表示当前方案已失效。普通 Git 操作不推进 Release 状态。

`READY_TO_SHIP` 需要所有适用验收与必需检查通过。`RELEASED` 还需要精确目标授权以及实际发布结果；创建 PR、合并或获得授权本身均不足以证明发布成功。

范围变化后只回退到最早失效的状态；保留仍然有效的计划和证据。后续 Tiny 修复先作为任务，真实发布时再建立下一 Release。封存后的历史不追溯覆盖。

阶段契约、回退矩阵和恢复步骤以[生命周期规则](../../skills/vibe-workflow/references/lifecycle.md)为准；授权与风险边界见[决策关卡](../../skills/vibe-workflow/references/gates.md)。
