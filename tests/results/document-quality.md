# 文档质量优化对照记录

三类固定场景的生成与事实检查已完成：简单修改保留局部更新，中等文档减少重复视图，复杂文档保留状态、竞态和恢复约束。初次候选出现的匹配语义补写已修正规则并复验；用户阅读体验尚待评阅。

日期：2026-10-20。输入和评估依据见[场景](../scenarios-document-quality.md)、[夹具](../fixtures/document-quality.json)；规则版本、生成条件与文件摘要见[清单](document-quality/manifest.json)。实现范围见[需求分析](../../docs/plans/2026-10-20-document-quality/SPEC.md)。

## 对照入口与结果

行数包含空行，仅辅助定位规模变化；中等、复杂为四份文档合计，不能据此单独判定质量。

| 场景 | 基线 | 初次候选 | 修正后复验 | 实际观察 |
|---|---|---|---|---|
| 简单：仅更新已有进度 | [19 行](document-quality/baseline/simple/PROGRESS.md) | [17 行](document-quality/candidate/simple/PROGRESS.md) | 未重跑，沿用局部更新结果 | 两组均保留其他任务、历史与人工说明，保持已实现待验证，不新建其余文档 |
| 中等：本地标题搜索 | [293 行，计划入口](document-quality/baseline/medium/IMPLEMENTATION_PLAN.md) | [127 行，需求入口](document-quality/candidate/medium/SPEC.md) | [130 行，计划入口](document-quality/candidate-v2/medium/IMPLEMENTATION_PLAN.md) | 复验省略同步过滤的独立流程/状态视图及未委派任务的完整交接展示，正确保留匹配规则缺口 |
| 复杂：后台上传 | [445 行，计划入口](document-quality/baseline/complex/IMPLEMENTATION_PLAN.md) | [257 行，计划入口](document-quality/candidate/complex/IMPLEMENTATION_PLAN.md) | [254 行，计划入口](document-quality/candidate-v2/complex/IMPLEMENTATION_PLAN.md) | 任务表保留依赖、修改边界、验证和恢复；需求与方案保留复杂状态及跨页面传播细节 |

每个入口所在目录保存该组全部适用文档及相同的 `INPUT.json`；原始输出未由主执行者润色。最终采用简单初次候选、中等与复杂候选 v2 的检查结果。

## 基线实际观察

- 简单样例的局部维护已符合预期。这次改动应保持该行为，不能把所有基线都描述成失败。
- 中等样例的[需求分析](document-quality/baseline/medium/SPEC.md)在产品行为和 AC 表之后，又用用户流程与状态转换重复同步过滤；[实施计划](document-quality/baseline/medium/IMPLEMENTATION_PLAN.md)为三个未委派任务展开交接字段；[进度](document-quality/baseline/medium/PROGRESS.md)在多张表和下一步章节重复页面接入与验证缺口。
- 复杂样例的[实施计划](document-quality/baseline/complex/IMPLEMENTATION_PLAN.md)同时展示切片、依赖图、逐任务交接和追踪矩阵；[进度](document-quality/baseline/complex/PROGRESS.md)又维护任务、切片与验收缺口表。候选把共同事实合并，复杂设计本身仍保留必要篇幅。

基线确认了重复视图与交接展示过重的问题；没有据此判定基线普遍丢失事实或虚构成功。

## 发现、修正与复验

中等场景只确认“按标题匹配”，未定义包含匹配或完整等值匹配。[初次候选](document-quality/candidate/medium/SPEC.md)自行确定了包含匹配，属于无依据的用户可见规则，不能因文档缩短而通过事实检查。

处理时保留输入与初次输出，在[写作规范](../../skills/vibe-workflow/references/document-quality.md#需求分析)补充 AC 溯源和验收示例边界：缺少且会改变可见结果的条件应标为待澄清，输入标注冻结也不授权补写产品含义。仅替换规则快照，复验中等与复杂场景。

[中等复验需求](document-quality/candidate-v2/medium/SPEC.md)明确列出匹配细则缺口，保留大小写、首尾空白、空查询、无匹配提示、清空恢复、记录及顺序不变和全部非目标。[复验进度](document-quality/candidate-v2/medium/PROGRESS.md)保留 TASK-020 已实现待验证、TASK-021 尚未开始，3/3 测试仅为夹具既有局部记录，页面与容量仍未验证。

[复杂复验需求](document-quality/candidate-v2/complex/SPEC.md)保留六项 REQ/AC、FIFO、并发最多 2、取消后拒绝迟到响应、手动同键重试、队列唯一写入与双页面订阅、令牌过期暂停和登录后手动继续、重启不恢复及原文件保留。[方案](document-quality/candidate-v2/complex/PROPOSED_DESIGN.md)展开取消占位、旧尝试隔离、订阅重入、影响与恢复；[进度](document-quality/candidate-v2/complex/PROGRESS.md)只把 E-02 标为 POC_VALIDATED，保留集成缺口、远端带宽回收未知与稳定提交缺失。

## 检查结果与证据范围

| 检查 | 实际结果与限制 |
|---|---|
| `./tests/validate_skill.sh` | 通过 Skill Creator、元数据、相对资源路径、七阶段和 Git/Shipping 静态契约；`skills-ref` 未安装，使用现有校验器 |
| 固定输入与规则摘要 | 每组案例输入与“通用提示 + 固定案例”一致，同案例各组输入字节相同；基线摘要匹配指定 Git 提交，候选 v2 摘要匹配当前 Skill 全部文件 |
| 输出与局部维护 | 各目录仅有指定文档与输入；简单两组的其他任务、历史记录、人工说明逐字保留 |
| 事实与条件展开 | 主执行者逐项核对最终输出；中等省略重复同步视图，复杂保留状态与跨模块细节。静态断言只证明条件指引存在 |
| 独立审查 | 规则及示例审查无阻断问题；中等 v2 输入/输出独立事实审查未发现需修正缺陷，12 处链接有效；规范、模板、指南与规划的 13 份文件共 63 处本地链接及锚点有效，命名一致 |
| 收尾检查 | 对照记录、更新说明、规划与最终输出等 18 份文件的 120 处本地链接及锚点有效；`git diff --check` 通过 |

对应本次 AC：AC-02、AC-03、AC-04、AC-06 的样例客观检查已完成；AC-01 的重点入口可定位，AC-05 的按需入口与自行检查已接入；AC-07 的三种复杂度和四类适用输出已保存。实际阅读体验、跨任务持续表现及跨宿主自动触发不由这些检查代替。

输入中的 E-01/E-02 是虚构夹具的既有记录。本次实际执行的是文档生成、文件/摘要检查和审查，没有运行真实搜索、上传、浏览器或服务端测试。

## 适用限制与用户反馈

基线提交为 `52c8c70c08dda1fd06c3c0a3e51faa0673128a2b`。每组每例一次独立上下文生成，修正规则后中等与复杂各复验一次；使用宿主默认模型，不覆盖参数，无法固定温度或随机种子。此记录属于小规模回归，不是统计重复或跨模型评测，也不能证明所有任务都会缩短。

用户阅读体验：**待评阅**。优先对比中等场景的[原实施计划](document-quality/baseline/medium/IMPLEMENTATION_PLAN.md)与[新实施计划](document-quality/candidate-v2/medium/IMPLEMENTATION_PLAN.md)，以及复杂场景的[原方案设计](document-quality/baseline/complex/PROPOSED_DESIGN.md)与[新方案设计](document-quality/candidate-v2/complex/PROPOSED_DESIGN.md)。是否更便于理解和判断，待用户实际阅读后记录，不预先标为验收通过。
