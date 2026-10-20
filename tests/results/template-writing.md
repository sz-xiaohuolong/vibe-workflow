# 标准模板与 PRD 命名验证记录

- 日期：2026-10-20。
- 修改前基线：`dd72b279b4bb36474ff9fdd252846bb8de7ddccb`。
- 范围：五份文档模板、默认 PRD 命名、适用内容填写方式，以及旧 SPEC 入口兼容。
- 原始任务与评估条件：[执行场景](../scenarios-template-writing.md)。
- 可核对产物：[文件哈希与运行清单](template-writing/manifest.json)、[首轮差异](template-writing/legacy-initial.patch)、[复验差异](template-writing/legacy-final.patch)。

## 静态检查

在本轮实际工作树运行 `bash tests/validate_skill.sh`，退出码 0。Skill Creator、元数据、相对资源链接、必要文件、七阶段和 Git/Shipping 契约、公共规则资源结构全部通过。校验入口已由 `assets/templates/SPEC.md` 改为 `assets/templates/PRD.md`，测试接缝等既有验收能力仍保留。

`git diff --check` 通过。对本轮修改的指南、模板、reference 和适配说明核对相对链接，通过；原有 `tests/results`、`tests/fixtures` 和历史 `docs/plans/2026-10-20-document-quality` 内容未改动。

环境未安装 `skills-ref`，使用现有 Skill Creator 校验器。静态检查只覆盖它实际检查的结构，不能单独证明文档质量或 Agent 行为。

## TW-01：本仓库真实任务的文档样例

[五份可阅读样例](../../docs/plans/2026-10-20-template-writing/README.md)依据本仓库此次已批准改造编写。独立执行者只获得候选 Skill、选定源文件快照与任务输入，完成了需求概要、PRD、方案设计和当前技术设计；实施计划由主执行者使用相同模板补写。因此本例不是“五份全部独立生成”的通过证明。

主执行者阅读输出后，确认 PRD 已展开九章、前三章具有独立摘要和概要引用、REQ/AC 可追踪；当前设计区分静态文件事实与未运行的检查；本任务没有凭空添加 UI、数据库或埋点。样例仍需人工整理：方案初稿将已排除选项列成备选，已改为既定范围下的选择依据；同时修正搬入仓库后的资料链接和行尾空白。原始文件哈希与整理差异保存在 [sample-editorial.json](template-writing/sample-editorial.json)。不把初稿完整落盘直接等同于可读性验收。

独立生成使用初始候选快照；之后针对旧计划字段只补充一句写作指导，五模板未变，因此保留这次生成结果，没有重做相同输入。样例的输入、快照范围与最新实际验证记录分别链接，不把快照生成者未执行的检查写成通过。本例不构成对无人审校写作质量的保证。

## TW-02：旧 SPEC 项目实际执行

使用原有 [document-sync.json](../fixtures/document-sync.json) 分别建立两个本地隔离工作区。两位独立执行者只获得同一用户请求、单个工作区和对应只读 Skill；未读取评估依据、其他组输出或历史结果。没有修改真实业务项目、联网、安装、推送或发布。

| 检查 | 首轮 | 规则修正后独立复验 |
|---|---|---|
| 沿用 R2 的 SPEC 需求入口，无新 PRD 或第二套地图 | 通过 | 通过 |
| R1 封存文件、源码、测试、实际规则和原需求保持字节一致 | 通过 | 通过 |
| 三项搜索单测实际通过，本地显示入口实际运行 | 通过 | 通过 |
| TASK-020 已验证，TASK-021 未开始，AC-003 未验证，R2 保持 PARTIAL | 通过 | 通过 |
| 计划只引用实际状态，不重复维护状态值 | 未通过：旧计划被同步为 VERIFIED | 通过：旧运行状态字段改为进度/验证记录链接 |

两轮均只改动六份既有文档：DOCUMENT_MAP、PROJECT、PROGRESS、TECH_DESIGN、R2 IMPLEMENTATION_PLAN 和 R2 VERIFICATION。主执行者读取完整差异，并以原始文件内容核对修改集合、源码与历史哈希、SPEC 路径、未完成范围和本地提交数量；核对通过。两份工作区均只有初始化基线提交，没有执行者新增提交。

首轮暴露的具体问题是：虽然新计划模板没有实际状态列，执行者在旧计划中仍沿用并更新了已有 `Status` 字段。修正只补充到 `references/document-quality.md` 的实施计划写法：本次更新的旧计划已有运行状态字段时，改为事实 owner 链接，保留任务、依赖与历史说明。五份模板未因此改变。首轮输出保留，没有覆盖为通过；使用原始输入和独立工作区复验。

复验实际命令及结果：

```text
PYTHONDONTWRITEBYTECODE=1 python3 -m unittest discover -s tests -v
3 项测试通过，退出码 0。

PYTHONDONTWRITEBYTECODE=1 python3 src/app.py
标准输出：本地文本工具
退出码 0。
```

被测环境为 Python 3.14.7；复验基线为 `1472d69513bb1911c420b85aa12fb34126fc18f9`，源文件来自上述隔离夹具。具体输入、覆盖、限制与结果保存在 [复验差异](template-writing/legacy-final.patch)内的 VERIFICATION 更新中。首次执行的原始工具输出确认三项单测为 OK，另以子进程断言显示入口退出码、标准输出及标准错误；该轮基线为 `5c3ddabb7c413d19a3613d957ab29ecf252930af`。

这些是隔离夹具的真实运行结果，不是业务产品或发布验收；本轮没有把夹具的既有历史日志当作新执行证据。

## 验证边界

真实任务样例的独立生成未覆盖全部五份文档；旧项目每轮使用一次独立执行，修正规则后对已发现的问题独立复验。这不是稳定性统计、跨模型对照或任意项目保证。用户的阅读体验仍需用户判断；不以章节数、字数或 Agent 自评分替代。
