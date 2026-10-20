# 技能更新与编排调整记录

最新调整日期：2026-10-20。本记录覆盖 vibe-workflow 工作区调整及 2026-10-13 的本机依赖更新；提交与远程同步状态以 Git 记录为准。业务项目中的既有证据保持原样。

## 2026-10-20：四类工程文档写作规范

- 内置[文档写作规范](../skills/vibe-workflow/references/document-quality.md)和[正反例](../skills/vibe-workflow/assets/examples/document-quality.md)，覆盖需求分析、方案设计、实施计划、进度；保留原文件名和编号。
- 四类模板按实际条件展开流程、状态、测试接缝及交接信息；简单更新保持局部，复杂任务保留约束、依赖、验证和恢复，不增加审批。
- 完成三类固定场景的生成对照与事实检查，修复了初次输出自行补定匹配语义的问题；静态校验通过，用户阅读体验待评阅。原始输出、修正依据和检查限制见[对照记录](../tests/results/document-quality.md)。

## 2026-10-15：项目规则自动接入

- 已有项目正常 `$vibe-workflow init`：先读适用规则与文档入口，再合并通用约定；已有授权不重复申请。明确只读时只报告建议差异。
- 空仓库直接启动新项目：首轮需求澄清不写文件，范围与验收确认且获准进入 Planning 后自动最小接入，正式实现前完成，无需再执行 init。Tiny、普通 Git、临时目录单点任务和普通恢复不触发。
- 公共正文只维护在[单份模板](../skills/vibe-workflow/assets/templates/AGENT_RULES.md)，合并行为集中在[初始化协议](../skills/vibe-workflow/references/init.md)。已有语义等价内容不重复，人工内容和冲突规则保留；维护区域不构成整块覆盖授权。相同输入重复 init 保持字节不变；模板更新在各项目下次 init 时核对，不批量改写历史项目。
- 优先沿用项目已采用的 `AGENT.md` 或 `AGENTS.md`，没有入口时使用用户指定名称，否则默认 `AGENTS.md`。地图、恢复规则、生命周期、模板和指南同步指向实际入口；文件名兼容不保证宿主自动加载。
- 没有增加 CLI、安装工具、PR、worktree、第二套事实源或本仓库根规则文件。原需求门禁、有效证据复用、个人开发发布和证据预算继续适用。

验证场景、真实文件结果与未覆盖范围见[规则接入回归记录](../tests/results/agent-rules-v0.3.md)。

## 依赖状态

先前逐项比对覆盖 Matt、Superpowers、gstack 共 26 个直接及备选技能。本次按套件更新，避免入口正文与运行资源版本不一致；新增编排选项 qa-only、land-and-deploy 随 gstack 更新。

| 套件 | 更新结果 | 核验依据 |
|---|---|---|
| Matt grilling | 保持已更新的版本；中文入口描述保留 | 上游提交 `49dd158d1076134a641b33efb035946536778336` |
| Matt grill-me | 更新委托文本为调用 `grilling`；保留仅用户调用限制 | 同一上游提交；安装后主文件与下载源一致 |
| Superpowers | 通过 Codex 插件管理安装并启用 `7.0.0` | 官方仓库 `v7.0.0`，提交 `bb92a77741419a4ab5f06e711a283343f1ada0c3`；插件列表显示 installed/enabled |
| gstack | `1.91.42.0` → `1.91.95.0` | 提交 `dbf400ec3f1ffb96a429f0d0b29ca932b3d6c6f0`；运行器重建、宿主安装刷新、版本迁移完成 |

Superpowers 官方仓库内的市场名称是 `superpowers-dev`，本次固定到 `v7.0.0`，并非使用浮动开发分支。旧缓存保留；运行中会话的技能清单未验证热刷新，后续新会话应重新发现实际可用入口。

gstack 的 Claude、Cursor、Codex 全局安装均显示 `1.91.95.0`。Codex 缺失的 VERSION、question-registry、jargon-list、设计评审、测试价值标准、安全专家等运行资源现已存在。本机 `gstack-` 前缀定制保留；核对当前 55 份源码差异均只涉及名称前缀。

升级前的 gstack 定制、配置与安装登记，以及 grill-me 原文件，分别备份到本机 `~/.codex/skill-backups/gstack/20261013-114250/` 与 `~/.codex/skill-backups/grill-me/20261013-114633/`。

## 上游变化及本次适配

- Superpowers 7 的 brainstorming 以意图访谈为主：冻结需求不再把它当 Planning 固定前置，避免第二轮需求采访和重复计划。
- gstack 更新完善 autoplan 的恢复、门禁决策标识和产物校验；复杂多维方案才选 autoplan，不再叠加它已完成的单项评审。
- gstack 更新增强 review、排障和结果解析；vibe-workflow 选择一个主审查/排障能力，简单任务直接执行最小协议。
- 新版 gstack 对跨服务评审同意和推理成本有更多控制；已有全局偏好保持，外部调用仍须符合本次任务范围。
- 安装更新补齐非 Claude 宿主资源，并按已使用宿主裁剪生成内容；不将上游示例节省量当成本机实测，也不据此删除项目证据。
- 只读验收使用 qa-only；qa 修改后重验受影响部分。ship 的 PR 回执与实际部署分开，真实发布按授权接 land-and-deploy 或项目流程。

## 工作流规则

[主入口](../skills/vibe-workflow/SKILL.md) 从 252 行减为 106 行，复杂规则按需读取。主要变化：

1. **按本次任务选择流程**：Tiny 不强制 Release ID、成套文档、TDD、子代理、worktree 或全量 QA；Bounded 沿用既有计划。权限、迁移和发布等风险仍先检查。
2. **统一技能调用边界**：目标、冻结输入、范围、权威路径、副作用、验证预算和停止点；一个执行 owner，SDD 实现任务串行。显式入口及项目规则优先，未改全局启动钩子。
3. **按证据是否仍适用决定重跑**：读取真实结果，核对输入、依赖、配置和环境。换阶段、提交、切换技能不是独立重跑理由；修复或环境变化才重验失效部分。
4. **默认保留摘要**：需要时才写 `.evidence`；HAR/视频/trace 默认关闭。缺省每项目 200 MiB 软预算、每日志 2 MiB 必要输出、1 个成功样本和 3 次有价值失败样本，可由项目 AGENTS 覆盖。
5. **个人发布默认直发**：原生 Git + 项目发布命令，只有用户显式要求才创建 PR；同步远程不隐含打 Tag、创建 Release 或部署。保护分支拒绝直推时报告限制，不自动绕过或另开 PR。
6. **保留与清理分开**：7 天只使文件成为候选；活跃、被引用、固定保留及不可重建证据受保护，历史清理需要授权。这些规则不是自动清理器，也不能限制 Codex 自身日志。

README、工程宪法、使用指南、生命周期概念页与验证模板同步更新。[项目配置示例](USER_GUIDE.zh-CN.md#44-按项目配置证据策略)可直接复用。

## 核验结果与限制

- 静态校验通过：Skill Creator、元数据、相对资源路径、七阶段和 Git/Shipping 契约。`skills-ref` 未安装，使用现有 Skill Creator 校验器。
- 两个隔离实际修改与十一项决策走查见[行为验证记录](../tests/results/lightweight-v0.3.md)。没有运行真实产品部署、完整浏览器 QA 或付费跨模型评审。
- gstack 的 `setup --status` 返回 1：Claude 安装的检查器将普通 `review` 与前缀 `gstack-review` 的条件路径同时视为必需路径。实际所需 `../gstack-qa/sections/exploratory.md` 存在；Codex/Cursor 节选路径检查全部通过。未为消除误报修改上游生成文件或创建重复技能。
- gstack 源码目录内另有版本正确的 Codex 项目渲染，状态为未登记；全局 Codex 安装已登记且已刷新，未为旧渲染重复运行安装。
- CSO 镜像预载为 4/6；两项下载达到每项 30 秒时限。本次没有运行增强扫描，不能声称它已完整可用；未继续反复拉取镜像。

## 上游来源

- [Matt grill-me 固定版本](https://github.com/mattpocock/skills/blob/49dd158d1076134a641b33efb035946536778336/skills/productivity/grill-me/SKILL.md)
- [Superpowers 7.0.0](https://github.com/obra/superpowers/releases/tag/v7.0.0)
- [gstack 固定提交更新日志](https://github.com/garrytan/gstack/blob/dbf400ec3f1ffb96a429f0d0b29ca932b3d6c6f0/CHANGELOG.md)
- [gstack 本次版本差异](https://github.com/garrytan/gstack/compare/52eec18c6347a018ba51a9c9daf1766ce25ef6c8...dbf400ec3f1ffb96a429f0d0b29ca932b3d6c6f0)
