# Vibe Workflow

一个中文 Codex Agent Skill，用于协调长期软件项目的版本生命周期、需求冻结、决策关卡、上下文恢复、范围控制与验证证据。

它解决的核心问题不是“怎样写某一段代码”，而是让 Agent 在跨任务、跨会话和跨 Release 的项目中持续回答：现在处于什么状态、下一步能做什么、何时必须停下来等待决定，以及凭什么声称完成。

## 一键安装

在 Codex 中粘贴以下指令：

```text
请使用 $skill-installer 从 https://github.com/sz-xiaohuolong/vibe-workflow/tree/main/skills/vibe-workflow 安装这个 Skill
```

也可以在终端运行 Codex 内置安装器：

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo sz-xiaohuolong/vibe-workflow \
  --path skills/vibe-workflow
```

安装后从下一轮对话开始可用：

```text
$vibe-workflow 继续当前软件项目，并从仓库事实恢复正确状态。
```

## 主要能力

- Requirement Freeze 与工程入口 Gate
- Release 状态机和 Operational Status
- Product、Schema、Security、External Service 与 Shipping Gate
- Tiny / Bounded / Architectural 文档预算
- Minimal Sufficient Context 与跨会话恢复
- Circuit Breaker 与 `REPLAN_REQUIRED`
- Verification Status 与 Shipping Authorization 分离
- Released artifacts 封存和 Requirement Traceability
- 与 Superpowers 等专业 Skill 的编排与降级

## 仓库结构

```text
skills/vibe-workflow/   可直接安装的 Skill
tests/                  行为场景、基线、复测和验证脚本
docs/                   V0.1 设计与实现计划
```

## 验证

```bash
./tests/validate_skill.sh
```

V0.1 包含四类 control/candidate wording micro-tests、20 个批准场景和 5 个独立审查回归场景。测试证据位于 [`tests/results/`](tests/results/)。

## License

[MIT](LICENSE)
