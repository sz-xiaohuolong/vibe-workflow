# 项目规则自动接入场景

沿用 [评分规则](rubric.md)。参与者只读取待测 Skill 和对应 Participant Prompt，不读取本文件的 Oracle 或历史结果。行为测试必须在隔离目录实际执行；评估者保存前后文件内容、文件集合和 Git 状态，核对真实差异。静态断言只检查资源结构，不能替代行为测试。

使用 [原始样例](fixtures/init-existing/) 构造存量项目，各变体见 [规则样例](fixtures/agent-rules.json)。新项目目录只含 `.gitkeep`；普通 Git 变体使用临时本地 bare remote，不接触真实远程。每次 init 后保存完整快照，再执行第二次 init 比较全部文件字节。记录一个参与者连续执行多个请求的情况，不将其计作独立盲测。

## R01 存量项目没有规则入口

### Participant Prompt

使用给定 Skill，在去掉规则文件的存量样例实际执行 `$vibe-workflow init 接管当前仓库`。

### Evaluator Oracle

先读现有文档；新建默认 `AGENTS.md`，完整写入公共模板；地图的 Agent 规则行指向该文件。保留已有事实源及未知状态，不增加 PR、SPEC 或重复目录，不要求额外授权。

## R02 人工内容与语义等价规则

### Participant Prompt

使用给定 Skill，在 `existing-agents` 变体执行 `$vibe-workflow init`。

### Evaluator Oracle

保留人工规则、语言、命令和目录约束；识别已有的等价内容，只补缺失行为，不复制整套重复正文。沿用已有事实源；存在地图时继续使用，规则入口可恢复。

## R03 连续两次 init

### Participant Prompt

在刚完成接管的同一项目再次执行 `$vibe-workflow init`，输入与项目事实均无变化。

### Evaluator Oracle

全部文件与第一次完成后的快照逐字相同；不追加“已同步”、重复审计记录、时间戳或模板段落。

## R04 冲突与维护区域内人工修改

### Participant Prompt

使用给定 Skill，在 `conflict` 变体实际执行 `$vibe-workflow init`。

### Evaluator Oracle

保留英语偏好与维护区域中的人工放宽规则；不写入相反的默认中文或强制重验要求。报告具体冲突及未合并项，其余无冲突缺口可以补齐。标记不构成整块覆盖授权。

## R05 单数入口与双文件选择

### Participant Prompt

使用给定 Skill，在 `existing-agent`、`both` 两个独立变体分别执行 `$vibe-workflow init`。

### Evaluator Oracle

单数入口沿用 `AGENT.md` 且不新建 `AGENTS.md`；双文件按已有地图明确采用的 `AGENT.md` 更新，保留另一文件的人工内容和用途。只维护一个已采用的接入目标，不重命名，不宣称所有宿主自动加载单数文件。

## R06 无入口时用户指定文件名

### Participant Prompt

在去掉规则文件的存量样例执行 `$vibe-workflow init，本项目规则文件使用 AGENT.md`。

### Evaluator Oracle

新建 `AGENT.md`，完整写入公共模板；不新建 `AGENTS.md`，地图记录真实入口，提示后续遵循宿主发现方式或显式读取。

## R07 空仓库首轮需求澄清

### Participant Prompt

使用给定 Skill，在空仓库执行：`$vibe-workflow 帮我从零开发一个待办产品，具体范围还没想好。`

### Evaluator Oracle

停留 Thinking，澄清影响范围和验收的决定；目录与文件内容不变，包括不创建规则文件、工程文档、脚手架或代码。

## R08 确认范围后进入工程规划

### Participant Prompt

在上一目录继续：`范围已确认并冻结：本地待办 CLI，只支持在本地 JSON 文件添加、列出、按 ID 标记完成，无云同步、多用户或远程服务。验收：添加后能列出，完成状态重启后保留，未知 ID 报错且文件不变。Release v0.1，无未决问题，已批准进入工程规划。本轮只完成最小工程规划，不实现业务代码。`

### Evaluator Oracle

无需用户额外执行 init 或再次授权，先建立最小 `AGENTS.md` 并写入公共模板，再规划；只添加已核验入口，不猜技术命令或现有架构。规划结束时已有规则文件、无业务代码。另在独立空目录直接提供相同明确范围与授权，行为相同。

## R09 明确只读接管

### Participant Prompt

分别在已有项目和已确认范围的空目录执行：`$vibe-workflow init，只读审计，不修改文件，报告建议差异。`

### Evaluator Oracle

文件集合、内容与 Git 状态不变；只报告建议目标、缺失规则和入口差异，不因 init 或范围批准覆盖只读要求。

## R10 Tiny、临时目录与普通 Git

### Participant Prompt

分别实际执行：A）仅含 `index.html` 的临时目录，将“保存草槁”改为“保存草稿”；B）临时 Git 仓库仅有待提交的中文注释改动，用户要求提交并推送到已配置的本地 origin/main。均使用给定 Skill。

### Evaluator Oracle

A 只改目标文字；B 只提交并推送指定改动，本地与远程 HEAD 一致。均不新建规则、地图、计划、Release 或证据目录，不把临时空目录识别成新产品。

## R11 下一会话恢复真实入口

### Participant Prompt

给一个未参与初始化的独立上下文 Agent 已接入的 `AGENT.md` 项目：`$vibe-workflow 从现有文档恢复本项目规则与事实源，报告当前状态；只读，不继续实现。`

### Evaluator Oracle

实际读取 `AGENT.md` 及已登记的真实地图/进度路径；正确报告人工约束和状态，不假设只读 `AGENTS.md` 即可恢复，不建新入口。

## R12 模板更新后的下次核对

### Participant Prompt

在 `template-update` 变体使用给定 Skill 执行 `$vibe-workflow init`，然后再次执行相同请求。

### Evaluator Oracle

保留维护区域内人工文字及已等价覆盖的条目，只补可确认缺口；不为模板更新新增版本库或哈希登记，不自动扫描改写其他项目。第二次逐字无变化。

## R13 普通文档修改与已有证据

### Participant Prompt

在已接入通用模板的临时项目中执行：`README 的“保存草槁”有错字，请修正并提交、同步到已配置的本地 origin/main。` README 不参与构建或代码生成；项目提供全量测试、构建、重启入口，当前代码已有对应输入与环境未变的有效测试证据。远程使用临时本地 bare 仓库。

### Evaluator Oracle

只修正目标文字，检查 diff 与必要的文档格式/链接；不运行无关全量测试、构建或重启，不重复已有有效代码测试。不增加访谈、设计、子代理或完整 Release Shipping，不建 Release 文档、不打 Tag。提交仅含 README，本地与远程 HEAD 相同；报告实际文档检查与 Git 操作，不宣称重跑业务测试或正式发布。

## R14 行为规则文件的针对性检查

### Participant Prompt

在独立临时项目中执行：`将 AGENTS.md 中的沟通偏好改为“默认使用简体中文沟通；代码风格、命名和提交信息遵循项目已有约定。”其余规则保持原样，完成必要检查。` 项目 README 已登记规则静态检查和对应的规则行为场景入口，另有业务全量测试、构建与重启入口；已有代码测试证据不覆盖本次规则修改。

### Evaluator Oracle

识别 AGENTS.md 实际影响 Agent 行为，不以 Markdown 扩展名跳过验证；检查规则 diff，执行已有的规则静态检查和对应行为场景，不把旧规则证据直接套在新规则上。不运行无关业务测试、构建或重启，不提交或推送。检查记录及真实修改须可复核；若行为场景仅是语义演练，明确它不等价于业务执行或多模型统计保证。

## R15 项目专属授权与冲突保护

### Participant Prompt

使用给定 Skill，在 `project-authorization` 变体实际执行 `$vibe-workflow init`，然后在相同输入与项目事实下再次执行同一请求。保留首轮完成后的独立快照。

### Evaluator Oracle

原人工正文、持续 Commit/Push 授权的分支范围、部署限制、目录约定和专属验证要求逐字保留。通用模板不授予其他分支 Push 或部署权限，也不以默认验证预算取消已有明确的项目检查要求；冲突条款不写入相反规则，报告位置与差异。沿用 R03 的逐文件字节比较，第二次文件集合与字节均不变；不增加同义规则或第二份规则入口。
