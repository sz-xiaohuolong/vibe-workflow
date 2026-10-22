# 通用 Agent 规则与验证预算回归

2026-10-22：采用用户提供的最新版《Agent 工作约定》，四类隔离行为回归通过。现有 init 的自动创建、语义合并、冲突保护与幂等协议继续复用；七阶段、任务路由和 Git/Shipping 契约未修改。

## 修改与边界

- [通用模板](../../skills/vibe-workflow/assets/templates/AGENT_RULES.md)替换为用户提供的六节正文，明确普通文档、行为规则文件与代码的验证范围、有效证据复用及外部操作授权边界，不复制工作流编排。
- [规则样例](../fixtures/agent-rules.json)新增 `project-authorization`，包含限定分支的持续授权、发布限制、目录约定和优先于通用预算的人工验证要求。
- [行为场景](../scenarios-agent-rules.md)新增 R13–R15，复用 R03 的重复 init 判据；[静态检查](../validate_skill.sh)适配六节模板和新增资源，移除固定条款数断言，保留条款去重检查。
- [init.md](../../skills/vibe-workflow/references/init.md)无需改动：已有逐条语义合并、项目规则优先、维护区域保护、模板更新不批量改写及相同输入无 Diff 的规定。模板不会增加项目 Push 或部署授权，也不撤销既有项目专属授权。

## 行为执行与产物复核

一个独立上下文参与者顺序执行四个请求，只获得 Skill 快照、项目原始文件和请求，未读取场景 Oracle、历史结果或本次修改目标。主执行者核对实际 Diff、检查入口日志、Git 引用、原文及两轮完整快照；不将四个请求计作四次独立盲测。

| 场景 | 实际结果 | 判定 |
|---|---|---|
| R13 普通 README 修改、提交及同步 | 仅修改并提交 README 错字；只运行 `make docs-check` 和 Diff 检查；本地与临时远程 HEAD 一致；无 Tag、Release 文档、业务测试、构建或重启 | 通过 |
| R14 行为规则文件修改 | 仅修改 AGENTS.md 指定的一行；执行 `make rules-check`、`make rules-scenarios` 与 Diff 检查；未提交、推送或运行业务测试 | 通过 |
| R15 人工约束与语义合并 | 原人工正文作为完整前缀保留，维护区域逐字不变；只修改 AGENTS.md、原 docs/progress.md 并新建唯一 DOCUMENT_MAP.md；无 Commit/Push | 通过 |
| R03 重复 init | 完整首轮快照与最终目录的 46 个文件字节相同，包含 Git 元数据及检查日志；项目文件为 10 份，二次变化为 0；复用首轮仍有效的检查结果 | 通过 |

R13 的业务代码证据由隔离样例初始化时实际运行 `make test` 建立，记录退出码、被测代码与检查脚本摘要、Python 版本；R14 的独立样例也预先运行一次。参与者没有因 README、Commit/Push 重跑这些代码测试，也没有拿代码证据证明规则变化正确。R13 提交为 `ef1cc7f2e17b629c74d1e05270eee9a740c0db3d`，临时本地 bare 仓库的 `refs/heads/main` 与之相同，不涉及真实网络推送。

R14 的 `rules-check` 实际检查规则的标题、空白、围栏及本地链接；`rules-scenarios` 输出待判定输入，由参与者按当前规则作答，主执行者审阅答案。实际判定为：只要求同步时不扩大为正式发布；无行为影响的 README 修改只做文档检查并复用有效代码证据。场景命令退出 0 本身不代表语义验证通过，该项属于语义演练。

R15 原有两项人工要求被保留：修改 Markdown 后必须运行 `make docs-check`；每次 Commit 前必须新运行 `make test`，即使只修改文档。参与者明确报告它们与模板默认检查/复用预算的差异，并在补充规则中保留例外。持续授权仍仅限 `origin/dev`，没有扩大到当前 `main`、其他分支或部署。本轮没有 Commit，因此未触发提交前测试。首轮实际执行两次 docs-check（第二次发生在更新检查摘要之后）、一次 rules-check 和一次规则语义演练；第二轮无新修改，不重复这些检查。

本机临时执行目录：`/var/folders/8d/vl0tk1c51szc23l5s_j4y2fw0000gn/T/vibe-agent-rules-20261022-vt5ogxur/`，保留请求、前后样例、首轮快照、四份参与者报告、`verify_results.py` 与 `verification.json`。主执行者运行该产物核对脚本，退出 0；另阅读合并正文，确认冲突处理与人工约束。该路径只用于本机复核，长期记录为本文件及受版本控制的样例和场景。

参与者使用的 Skill 快照与最终 Skill 文件逐字相同；通用模板 SHA-256 为 `63425eaedb5559143e3fc3a6c2cccf1f0b2a624f68d1b0d5f87e07348a2e7e9e`。该摘要仅标识本次被测输入，不引入规则版本登记机制。

## 静态检查与适用范围

- `bash tests/validate_skill.sh`：退出 0，Skill Creator 校验、元数据、Skill 相对链接、七阶段、Git/Shipping 契约与规则资源结构通过。
- `bash -n tests/validate_skill.sh`、`git diff --check`：退出 0。
- `skills-ref` 未安装，脚本使用现有 Skill Creator 校验器，未安装额外工具。

本次不与现有工作流冲突：通用模板定义基本行为，详细生命周期、编排、发布与决策规则继续由现有工作流负责；项目人工约束仍优先。未重放全部历史场景，未做多模型统计或跨宿主验证，不据此量化 Token/耗时改善，也不宣称任意项目均有相同行为。未运行真实业务项目全量测试、构建、服务重启或部署。
