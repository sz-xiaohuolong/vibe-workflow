# 当前技术设计 — Vibe Workflow 标准文档与命名入口

当前仓库以 Markdown Skill、reference、模板和示例指导 Agent 执行工作流，使用 YAML 提供宿主展示元数据，并以 Bash 完成安装及静态校验。快照已经包含五类标准模板、PRD 九章及旧 SPEC 兼容表达。本文件只记录本次读取实际文件所得的静态事实；没有执行安装、校验、测试、Git 检查或运行验证，不能据此声称这些路径运行成功。

| 维护信息 | 内容 | 核验信息 | 内容 |
|---|---|---|---|
| 适用范围 | 2026-10-20 提供的本仓库只读快照 | 版本来源 | [SNAPSHOT.json](SNAPSHOT.json) |
| 来源仓库与分支 | `sz-xiaohuolong/vibe-workflow`，`main` | 基础提交 | `dd72b279b4bb36474ff9fdd252846bb8de7ddccb` |
| 快照状态 | 本轮模板修改尚未提交；不包含本轮运行结果 | 本次事实依据 | 下列真实源文件与配置；不引用历史执行结论 |
| 关联需求 | [PRD.md](PRD.md) | 目标方案 | [PROPOSED_DESIGN.md](PROPOSED_DESIGN.md) |

## 1. 系统现状与边界

**系统职责。** [Skill 主入口](../../../skills/vibe-workflow/SKILL.md)定义 Tiny、Bounded、Architectural/正式 Release 等执行路径、七阶段模型、事实所有权与门禁，并将详细规则交给 reference。Agent 按文档协议读取文件、判断授权、执行任务和记录证据；这些规则不是自动运行的后台状态机。

**本次相关能力。** 主入口末段要求新建或实质修改核心文档时先读对应模板；[写作规范](../../../skills/vibe-workflow/references/document-quality.md)规定五模板职责、通用写法及各类文档要求；五模板实际文件均存在于 `assets/templates/`，其正文结构见第 4 节。

**外部边界。** 用户提供产品意图与授权，项目仓库承载实际 owner 和事实；宿主决定 Skill 加载及工具可用性。`install.sh` 向宿主目录复制 Skill 或生成 Cursor 规则；校验脚本依赖本机工具及外部 Skill Creator validator。上述外部环境均未由本次执行核验。

**当前限制。** 文件结构与说明只能支持静态内容事实，不能证明 Agent 实际行为、全部宿主兼容、校验通过、安装成功或远程同步完成。本次未新增在线服务、数据库或业务应用，也未将目标方案描述为已经验证的能力。

## 2. 技术栈与工程结构

### 2.1 当前技术栈

| 使用位置 | 技术及实际版本 | 代码或配置依据 | 事实范围 |
|---|---|---|---|
| Skill 与文档 | Markdown，未固定解析器版本 | `SKILL.md`、`references/*.md`、`assets/templates/*.md` | 已读取相关正文；跨宿主渲染未验证 |
| 宿主展示元数据 | YAML，运行解析器版本未核验 | [agents/openai.yaml](../../../skills/vibe-workflow/agents/openai.yaml) | 文件只有 `interface`，含 display_name、short_description、default_prompt |
| 安装器 | Bash，运行版本未核验 | [install.sh](../../../install.sh) | 已读取脚本；未运行任何安装分支 |
| 校验驱动 | Bash、`uv`、Python、PyYAML、`rg`，运行版本未核验 | [validate_skill.sh](../../../tests/validate_skill.sh) | 入口和调用可定位；未执行 |
| 外部规范校验 | Skill Creator `quick_validate.py`；可选 `skills-ref` | 同上，`SKILL_CREATOR_VALIDATOR` 及工具判断分支 | 外部工具及依赖未检查，不主张环境可用 |

### 2.2 目录、组件与依赖方向

| 目录或组件 | 当前职责 | 入口与接口 | 依赖方向 | 文件依据 |
|---|---|---|---|---|
| `skills/vibe-workflow/SKILL.md` | 生命周期、路由及编排边界 | `$vibe-workflow` 对话入口 | 按需读取 reference、模板 | “先选执行路径”“七阶段生命周期”“Gate、状态与完成声明” |
| `references/` | 规则细节 | 文档内相对链接 | 引用模板及关联规则 | `document-quality.md`、`artifacts.md`、`init.md`、`context.md`、`execution.md` 等 |
| `assets/templates/` | 可填写产物结构 | 各职责 Markdown 模板 | 引用其他职责，不执行程序 | 五模板及 PROJECT、地图、进度、验证等资源 |
| `assets/examples/document-quality.md` | 写作正反例 | 模板和规范引用 | 解释写法，不产生项目事实 | 文件开头明确“虚构片段” |
| `agents/openai.yaml` | Codex 展示和默认提示 | `interface` 配置 | 默认提示调用 Skill | `display_name: Vibe Workflow` 及 `$vibe-workflow` 提示 |
| `adapters/cursor/vibe-workflow.mdc` | 仓库内 Cursor 适配文本 | MDC frontmatter 与说明正文 | 指向 Skill 模板和 reference | 产物位置及新 PRD/旧 SPEC 说明 |
| `install.sh` | 分发 Skill、生成 Cursor 规则 | agent 参数 | 读取源 Skill；向目标目录写入 | `install_to_dir`、`install_cursor` 和参数分派 |
| `tests/validate_skill.sh` | 静态结构与契约检查 | Bash 脚本入口 | 读取 Skill、部分测试资源及外部 validator | required_files、链接扫描、断言及可选校验分支 |
| README、指南及概念文档 | 对人说明用法和职责 | 文档链接 | 导航到 Skill 内规范 | README、`docs/USER_GUIDE.zh-CN.md`、`docs/concepts/artifacts.md` 等 |

### 2.3 现行工程约定

`SKILL.md` 的 frontmatter 声明名称 `vibe-workflow`；正文要求沿已有实际规则和唯一地图定位，不复制第二份事实 owner。新建需求默认 PRD，旧 SPEC 或等价路径继续沿用，REQ/AC 与机器状态不变。

当前没有从所读文件取得固定 Bash/Python/工具版本依据，不能填写推测版本。校验脚本通过 `uv run --no-project --with pyyaml` 调用 Python，外部 validator 默认由 `CODEX_HOME` 或 `HOME` 下的 Skill Creator 路径解析，也允许 `SKILL_CREATOR_VALIDATOR` 指定。这里只记录配置入口，不读取或披露凭据。

没有应用编译或服务启动契约需要为本任务新增。现有格式、元数据和链接检查入口存在，执行结果均未由本次产生。

## 3. 核心架构、数据流与状态

### 3.1 核心读写路径

1. **输入与定位。** Agent 从用户请求和宿主适用规则出发；`init.md` 规定实际 AGENT/AGENTS 入口及 owner 定位，`context.md` 规定读取当前任务的最小上下文。
2. **模板读取与正文写入。** `document-quality.md` 的模板表定位对应资源，模板要求正文填写具体契约并清理占位。实际项目的 Agent 在用户授权路径写入，模板本身没有文件生成代码。
3. **读取与传播。** BRIEF、PRD、目标设计、当前设计及计划按职责互相引用；`artifacts.md` 的更新矩阵规定变化后同步受影响 owner。
4. **失败与恢复。** 文档协议要求未知保持未知，冲突确定事实 owner，同类失败按既有熔断协议处理；代码中的校验脚本失败则退出。文档行为路径未进行本次运行观察。

### 3.2 状态与共享数据

| 状态或数据 | 当前含义与生命周期 | 写入职责 | 读取与刷新方式 | 失败与恢复 | 事实依据 |
|---|---|---|---|---|---|
| 需求控制与 REQ/AC | 概要保存基线，PRD 保存完整行为与验收 | 对应项目的实际需求 owner | 设计、计划、验证通过标识引用 | 需求冲突不得静默改写 | BRIEF/PRD 模板，`artifacts.md` |
| Workflow State | `REQUIREMENTS_FROZEN → SPECIFIED → … → REFLECTING` | 对应项目进度 owner，实际 Agent 执行 | 恢复时由 Git/代码/证据核对 | 回退到最早失效状态；文件命名不改状态 | 主入口、`references/lifecycle.md` |
| Verification Status | `VERIFIED/PARTIAL/UNVERIFIED/FAILED` | 实际验证 owner | 引用有效证据与覆盖范围 | 授权不把未知改为通过 | 主入口、VERIFICATION 模板 |
| 方案与当前事实 | 方案状态与现状分开 | PROPOSED_DESIGN 与 TECH_DESIGN 各有职责 | 实现并有核验依据后只同步成立部分 | 未成立部分留在方案或缺口 | `artifacts.md`“当前架构与目标方案” |
| 任务实际状态 | 计划预期与进度结果分开 | 实际 PROGRESS，证据归验证记录 | 完成、阻塞或变更后同步相关事实 | 保留恢复点及限制，不复制第二份状态表 | `execution.md`、PROGRESS/PLAN 模板 |

上表为已存在的文本契约，不表明任何当前项目已进入所列状态。本次没有获取可证明当前 Release、Stage、Task 实际状态的运行记录。

## 4. 当前数据模型与接口

### 4.1 文档结构与存储

当前相关持久化对象是版本库中的 Markdown/YAML/脚本文件，没有本次要新增的表结构、索引或缓存。五份模板的实际正文如下：

| 模板 | 当前可定位结构 | 来源位置 |
|---|---|---|
| PROJECT_BRIEF | 需求控制及六部分：背景定位、用户场景、目标范围、约束、成功目标、待决问题 | [PROJECT_BRIEF.md](../../../skills/vibe-workflow/assets/templates/PROJECT_BRIEF.md) |
| PRD | 九章：背景、目标、用户、优先级、详细规格验收、交互、限制边界、埋点、待决风险 | [PRD.md](../../../skills/vibe-workflow/assets/templates/PRD.md) |
| PROPOSED_DESIGN | 七部分：背景目标、栈约定、架构流程、详细设计、选择、安全观测、风险验证恢复 | [PROPOSED_DESIGN.md](../../../skills/vibe-workflow/assets/templates/PROPOSED_DESIGN.md) |
| TECH_DESIGN | 八部分：系统边界、栈结构、架构状态、数据接口、逻辑恢复、安全观察、运行验证、缺口 | [TECH_DESIGN.md](../../../skills/vibe-workflow/assets/templates/TECH_DESIGN.md) |
| IMPLEMENTATION_PLAN | 六部分：环境、文件映射、任务依赖、追溯矩阵、交付恢复、里程碑偏差 | [IMPLEMENTATION_PLAN.md](../../../skills/vibe-workflow/assets/templates/IMPLEMENTATION_PLAN.md) |

PRD 模板前三章各有独立摘要字段和“基线来源”；功能表使用 REQ；详细规格列主流程、规则权限、异常和 AC。专业章节包含条件提示，限制性能等数字和额外机制的引入。以上只说明文件中存在这些结构，不证明生成结果总是遵循。

文档保留和隐私由 `artifacts.md` 管理：可读摘要与原始证据分离，`.evidence/` 按需使用，历史封存不回写。该规则不是自动清理器；本次不创建证据目录，也不清理任何既有文件。

### 4.2 接口契约与兼容

**`$vibe-workflow` 与 `init`。** 这是宿主中的对话协议；使用方为 Agent。`init.md` 明确 `init` 不要求 CLI 或额外工具，输入为用户请求与现有仓库事实，输出为适用接入或审计行为。只读时不写规则及地图；Tiny、普通 Git 等场景不自动初始化。

**文档需求入口。** `artifacts.md`、`init.md` 和主入口明确：新建用 `PRD.md`，存量 `SPEC.md`/等价路径继续作为 PRD owner，不迁移不复制；`SPECIFIED` 等机器状态不变。唯一地图模板记录真实路径，不能代替所指向正文。

**安装器接口。** `install.sh` 接收 `claude`、`codex`、`gemini`、`project`、`cursor`、`all`、`auto` 及帮助参数，默认 `auto`。`install_to_dir` 将源 Skill 复制到目标目录；目标是指向同一源的符号链接时提前返回，否则脚本含清理目标内容和复制动作。`install_cursor` 使用脚本内独立 heredoc 生成规则，没有读取仓库的独立适配文件。实际安装和兼容结果均未验证。

**校验器接口。** `tests/validate_skill.sh` 解析仓库与 Skill 路径，先定位外部 quick validator，再运行元数据、相对链接、必需文件及文本契约检查；随后引用部分场景和夹具资源，最后可选调用 `skills-ref`。

| 失败条件 | 文件中定义的可见行为 | 状态与限制 | 文件依据 |
|---|---|---|---|
| 安装源目录不存在 | 向标准错误输出错误并退出 1 | 不进入后续安装；未实际触发 | `install.sh` 开头 |
| 未知安装参数 | 输出未知参数及用法并退出 1 | 未实际触发；不等同已验证错误处理 | 安装器参数分派 |
| quick validator 文件不存在 | 输出缺失路径与环境变量提示并退出 1 | 后续检查不执行；本次未检查该文件是否存在 | 校验脚本开头 |
| 必需文件、链接或断言失败 | `set -euo pipefail`、Python assert 或命令失败使脚本终止 | 是否在实际输入触发未知 | 校验脚本各检查段 |
| `skills-ref` 不在 PATH | 输出 unavailable 提示，不运行该可选工具 | 不能解释为可选工具已通过，更不能证明行为覆盖 | 校验脚本结尾 |

## 5. 核心逻辑、错误与恢复

**规范执行。** 核心逻辑由文本规则交给 Agent：先按任务选路径，确认已有授权，定位 owner，读取模板，写入适用契约并保持证据边界。没有可执行模块为项目自动检查全部产品行为。

**校验逻辑。** 脚本检查 frontmatter、元数据键、链接目标、required_files、部分关键契约字符串、七阶段顺序与既有规则资源结构。它引用的 PRD 文件名为 `assets/templates/PRD.md`，仍读取 `SPECIFIED` 等既有状态文本。相对链接扫描遍历 Skill 目录，不等同扫描整个仓库，也不验证章节锚点目标或正文可执行性。

**并发、事务与重试。** 所读安装和校验脚本没有针对本次文档任务新增锁、事务或自动重试。安装会修改目标目录；校验是顺序命令与断言，失败终止。不能据此推断所有宿主或共享目录中的并发安全。

**取消与依赖失败。** 脚本依赖命令返回行为，没有为本任务新增取消清理或降级服务。安装中断后的目标目录完整性、校验工具可用性与恢复均未演练。

**恢复。** 快照给出基础提交，但同时注明本轮修改尚未提交。基础提交不是本轮已验证稳定点，不能用它覆盖用户工作。后续恢复需要先保存并定位本任务差异，只恢复精确相关文件；当前没有可引用的成功恢复证据。

## 6. 安全、隐私与运行观察

| 关注点 | 当前机制与范围 | 实现或配置入口 | 依据与限制 |
|---|---|---|---|
| 用户授权与副作用 | Skill 规定产品范围和风险选择由人决定，既有授权复用 | 主入口、gates/execution 规则 | 文本边界存在；未观察实际执行行为 |
| 安装目标写入 | 清理并复制目标目录，或生成 Cursor 文件 | `install_to_dir`、`install_cursor` | 有真实写入副作用，因此本次仅阅读 |
| 外部校验依赖 | validator 路径可覆盖，`uv` 提供 Python/PyYAML 调用 | `SKILL_CREATOR_VALIDATOR`、校验命令 | 依赖版本、可用性和获取行为未核验 |
| 证据与敏感数据 | 保留必要摘要、避免无关采集，保护引用和不可重建证据 | `artifacts.md` | 是维护约定，不是运行访问控制或自动存储服务 |

日志与排障入口是现有脚本标准输出/错误、退出结果及项目的实际验证记录。所读实现未为本次功能接入指标、追踪或告警平台；不从示例数字推导生产阈值。脚本最后的 `PASS` 文本只是源文件内容，本次没有输出过该检查结果。

## 7. 运行与验证入口

以下入口均未由本次执行，没有可引用的本轮通过结果。

| 用途 | 命令或操作入口 | 前置环境与配置 | 当前事实及限制 |
|---|---|---|---|
| Skill 使用 | 宿主对话中调用 `$vibe-workflow` | 宿主已正确加载 Skill 和项目权限 | 协议及元数据存在；本次未执行跨宿主行为验证 |
| 静态与结构校验 | `./tests/validate_skill.sh` | Bash、uv/Python、rg、quick validator、所需测试资源；PyYAML 按脚本提供 | 脚本已读取，未运行；当前快照不是完整校验环境证明 |
| 可选标准校验 | 脚本内 `skills-ref validate` 分支 | PATH 中有 `skills-ref` | 配置存在，可用性和结果未核验 |
| Skill 原生安装 | `./install.sh codex` 等明确目标 | 目标目录写权限及用户明确安装授权 | 脚本存在；未执行，不代表已安装 |
| Cursor 安装 | `./install.sh cursor` | 明确工作区及写权限 | 使用内嵌文本；与独立适配文件的完整一致性未验证 |
| 提交与分支同步 | `references/execution.md` 的 Lightweight Git Workflow | 实际工作树、分支、upstream、remote 和授权范围明确 | 原任务有授权；本次快照禁止执行，实际目标和结果未核验 |

README 提供既有进度与历史结果链接，但本次按任务限制没有读取这些输出，也没有继承其测试结论。后续执行前应定位真正承担本任务实际状态、证据的原有 owner，不能把本组需求和计划文档当作第二套结果台账。

## 8. 已知缺口与待核验项

| 缺口或未知 | 对当前理解、运行或维护的影响 | 下一核验入口 | 相关方案或任务 |
|---|---|---|---|
| 本轮检查没有执行 | 不能声明模板行为、静态校验或验收通过 | 完整且获准环境中的脚本及人工契约审阅 | 计划 TASK-004 |
| 校验依赖不在快照证明范围 | quick validator、工具与版本可能影响执行 | 脚本参数、实际工具环境；不在本次安装 | 计划第 1 节 |
| 脚本引用的测试资源未随本次提供 | `tests/scenarios-v0.3.md`、`tests/fixtures/agent-rules.json`、`tests/scenarios-agent-rules.md` 不能作为本次已执行输入 | 后续完整仓库的资源定位；本次不读取评估正文 | 计划 TASK-004 |
| 静态检查不足以覆盖写作行为 | 文件、链接或关键词存在不能证明实际正文质量和兼容行为 | 用真实仓库任务审阅生成文档及 owner 选择 | 方案第 7.2 节、计划第 4 节 |
| Cursor 两个文本来源 | 独立适配文件有 PRD/模板说明，安装器另有内嵌正文，不能假设同步 | 精确比较本次契约是否需要进入生成入口 | 计划 TASK-002 |
| 实际进度/验证 owner 未读取 | 不清楚哪条既有记录保存本任务实际状态与证据 | 后续先按项目入口定位，不复制状态表 | 计划第 6 节 |
| 当前工作树与远程未查询 | 快照 `main` 不证明实际 upstream、remote、远端状态或分支保护 | 后续按轻量 Git 协议定位明确目标 | 计划 TASK-005 |
| 基础提交不含本轮未提交变化 | 不能将基础提交直接当本轮恢复点或已验证稳定点 | 保留原始差异，保存明确恢复依据 | 计划第 5.3 节 |

本文件不宣称“无其他影响”。未读取、未运行和未提供的部分继续保持未核验；目标和选择理由见方案设计，后续只把已成立事实同步回来。
