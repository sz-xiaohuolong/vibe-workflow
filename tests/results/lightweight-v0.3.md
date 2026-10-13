# 轻量执行与技能冲突验证

日期：2026-10-13。结果：**2 个隔离实际修改场景通过，11 项决策走查通过；静态校验通过。**

## 方法与证据范围

依据 skill-creator 的 Independent Forward-Testing，创建三个独立上下文的子代理。只提供候选 Skill、用户请求和最少原始素材，不提供预期答案、已知问题、历史审计或 Oracle。L01、L02 分别在隔离临时 Git 工作区实际执行；L03–L12 为第三个代理处理的独立情境，L13 为启动器规则补测。

测试素材见[原始文件](../fixtures/lightweight-tasks.json)，重放请求与评估标准见[场景集](../scenarios-lightweight-v0.3.md)。工作目录是本机临时路径 `/tmp/vibe-forward-20261013/`，不作为长期或跨机器证据链接。

主 Agent 核对实际文件、diff、目录和任务记录，并独立运行修复后的回归用例。决策场景只证明本次 Agent 的规则选择，不等于已经运行 CI、浏览器、QA、部署、清理或多技能联调。本次没有无 Skill 对照组，不宣称耗时或 token 降幅。

## 实际修改结果

### L01：Tiny 文案修正

实际 diff 仅为：

```diff
-<html lang="zh-CN"><meta charset="utf-8"><title>工作台</title><button>保存草槁</button></html>
+<html lang="zh-CN"><meta charset="utf-8"><title>工作台</title><button>保存草稿</button></html>
```

子代理执行 `git diff --check`、指定文件 diff、status 与文字匹配检查。主 Agent 复核 `git diff`、status 和文件集合：仅 `index.html` 修改，没有新文件、证据目录、计划或提交。没有重新访谈或要求初始化 Release。

**结论：PASS。** 该静态样例无构建命令；没有将静态检查称为浏览器验收。

### L02：已批准任务的空白输入修复

实际实现只增加空白分支：

```diff
 def parse_limit(raw):
     text = raw.strip()
+    if not text:
+        return 20
     if not text.isdecimal():
         raise ValueError("invalid limit")
     return int(text)
```

仅 `limits.py` 与既有 `TASK.md` 改动，测试文件保持原样。子代理记录修复前空白输入的三个子用例报错，修复后通过；未重开需求访谈、改写其他解析语义、创建第二份计划或证据目录。

主 Agent 独立核验命令 `python3 -B -m unittest -v test_limits`，退出码 0，实际输出：

```text
test_blank_uses_default (test_limits.LimitTests.test_blank_uses_default) ... ok
test_invalid (test_limits.LimitTests.test_invalid) ... ok
test_number (test_limits.LimitTests.test_number) ... ok

Ran 3 tests in 0.000s
OK
```

覆盖空字符串、空白、零、非负整数、首尾空白及非法格式。此复核用于验证独立执行的实际结果；正常业务流程不要求重复跑同一套已可核对的测试。

**结论：PASS。** 文件集合和 diff 与请求一致，任务结果同步到原记录。

## 决策走查

| 场景 | Agent 的实际决定 | 结果 |
|---|---|---|
| L03 复用 CI | 先读取原始结果并核对范围；有效则复用，换阶段不重跑。没有凭题面直接宣布就绪。 | PASS |
| L04 数据库驱动变化 | 重验受影响数据库集成；保留无关有效结果，不把驱动升级自动当作 Schema 迁移。 | PASS |
| L05 一行权限改动 | 识别匿名访问和客户信息风险，先调查并明确具体方案与影响，保持待决定状态。 | PASS |
| L06 只读 QA | 选 qa-only，限定报告，不修复提交；局部通过不升级整个 Release。 | PASS |
| L07 QA 修改认证逻辑 | 沿用修复授权，撤回旧就绪声明；新 diff 复审并重验受影响路径。 | PASS |
| L08 PR 成功 | 只确认 PR 创建；核对 readiness 与已有精确授权后继续部署，取得目标版本及健康结果才标 RELEASED。 | PASS |
| L09 证据超预算 | 停止可选重型采集，保护被引用且不可重建的历史日志；仅清理本任务无用中间文件，不跳过必需验收。 | PASS |
| L10 SDD 与并行器冲突 | 保持单一 owner、SDD 串行实现；换编排须交接，不同时启动第二套实现器。 | PASS |
| L11 未确定 MVP | Thinking 澄清，grilling 或内置提问；首轮不写工程文件，不伪造冻结。 | PASS |
| L12 三次同类失败 | 停止盲改、保存用户工作及稳定点、记录现场，进入 REPLAN_REQUIRED 并选一种根因调查能力。 | PASS |
| L13 启动器争夺编排 | 用户显式入口下沿用计划执行，不重访谈或复制文档；未指定时先依据宿主/项目规则确定 owner，不修改全局钩子。 | PASS |

Agent 对全部演练明确说明未运行真实业务操作。L13 读取了最终补充的启动器规则；此前门禁表的文字同步没有改变上述场景的预期行为。

## 静态检查与适用限制

`bash tests/validate_skill.sh` 检查 Skill Creator 格式、元数据、资源路径、七阶段顺序及 Git/Shipping 契约，结果通过。新增 `orchestration.md` 纳入必需资源；移除两项依赖旧文案和旧章节位置的字面断言，没有用静态匹配代替行为结果。

`git diff --check` 通过。历史验证记录保持原样，既有场景未全部重跑。本次不能证明所有 Agent 宿主或所有外部技能组合都已集成验收；本机依赖核验及剩余限制见[更新记录](../../docs/SKILL_UPDATES.zh-CN.md)。
