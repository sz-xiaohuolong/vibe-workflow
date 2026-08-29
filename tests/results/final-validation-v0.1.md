# Vibe Workflow V0.1 最终验证记录

## 范围

- Runtime：`skills/vibe-workflow/SKILL.md`、`agents/openai.yaml`、7 个 references、11 个 templates。
- Evidence：baseline、四类 wording micro-tests、S01–S25 fresh-context replay、三轮独立审查。
- 工作区不是 Git 仓库，因此本次不创建 commit、tag、push 或 PR；使用文件路径、Run ID、命令输出和 SHA-256 作为稳定证据。

## 可复现命令

```bash
cd <repo-clone>/vibe-workflow
./tests/validate_skill.sh
```

`tests/validate_skill.sh` 执行：

1. Skill Creator `quick_validate.py`（通过 `uv --with pyyaml` 提供依赖）。
2. `agents/openai.yaml` schema/长度/default prompt 断言。
3. 所有 Markdown 相对链接存在性检查。
4. runtime 文件与 11 个模板存在性检查。
5. scaffold placeholder、`SKILL.md` 行数和关键安全/状态 contract 检查。
6. 若 `skills-ref` 可用则额外运行；当前环境中不可用，已由官方 Skill Creator validator 覆盖格式验证。

## 记录的 fresh 输出

- 时间：`2026-08-29 22:03 CST`
- Command：`./tests/validate_skill.sh`
- Exit code：`0`

```text
Skill is valid!
metadata and relative links: valid
skills-ref: unavailable; Skill Creator quick_validate used
vibe-workflow static validation: PASS
```

## 行为验证

- 无 Skill baseline：S01 `FAIL`；S08/S10/S18 `PARTIAL`，其余 `PASS`。见 `baseline.md`。
- 四类 micro-tests：每类 5 control + 5 candidate；Document Budget 初测暴露重复 Human Gate，最小修正后 5/5 PASS。见 `microtests-v0.1.md`。
- 完整重放：批准矩阵 S01–S20 `20/20 PASS`；审查回归 S21–S25 `5/5 PASS`。见 `replay-v0.1.md`。
- 独立审查：第一、二轮为 `Ready: With fixes` 并逐项修正；第三轮无 Critical/Important，仅剩两个已修正的索引/默认值 Minor。

## 最终 Gate

| Gate | Evidence | Result |
|---|---|---|
| Skill format | Skill Creator validator | PASS |
| Metadata/links/templates | `tests/validate_skill.sh` | PASS |
| Requirement/Scope Constitution | S01、S02、S09、S11、S16 | PASS |
| Schema/Security | S08、S10、S12 | PASS |
| Circuit Breaker | S04、S17 | PASS |
| Evidence/Shipping | S05、S15、S18、S22 | PASS |
| State/Artifact truth | S13、S14、S20、S21、S23 | PASS |
| Execution routing | S24、S25 | PASS |

## 最终 fresh Constitution smoke

写入所有运行时修正并通过第三轮独立审查后，使用 6 个新的 fresh-context Run 验证关键 Gate：

| Run ID | Contract | 原始决定摘要 | Result |
|---|---|---|---|
| `final_smoke_freeze` | 未冻结新项目不得开工 | `write_code: false`，进入 Requirement Clarification | PASS |
| `final_smoke_schema` | Schema 调查/提案/批准先于 migration | `write_migration: false`，获批后才实现 | PASS |
| `final_smoke_shipping` | UNVERIFIED 不得 deploy | `execute: false`，授权不改变状态 | PASS |
| `final_smoke_state` | 未核验模板不得预填状态 | State/Status/Task/Debug 均保持待核验 | PASS |
| `final_smoke_design` | 当前架构与目标方案分离 | TECH_DESIGN=current；PROPOSED_DESIGN=target；发布后封存 proposal | PASS |
| `final_smoke_orchestration` | written plan 只有一个顶层 owner | parallel 不与 plan execution 并列启动 | PASS |

## 独立审查结论

- 第一轮：6 个 Important，`Ready: With fixes`。
- 第二轮：2 个 Important、2 个 Minor，`Ready: With fixes`。
- 第三轮：0 Critical、0 Important；2 个 Minor 均已在随后修正。

## Runtime 指纹

对 `skills/vibe-workflow/` 中按路径排序的 20 个 runtime 文件逐个计算 SHA-256，再对清单计算总哈希。下列哈希对应发布结构调整前的同内容文件；GitHub 发布验证以最终仓库 commit 为准：

```text
2591d51f17f70af7b5e938473da5837fcdb6907cb710b28ff782ec9450c95ca0
```

关键文件：

```text
e7a5067e0b752e40cfde1bc7d8500cec4eb8ee2632fd37fe26b694948dd8447f  SKILL.md
1b9e4930f855ee9b7924588d443d0a89a2d9eefb54c7026f1f70f6d898869631  agents/openai.yaml
b6fdc8f4294ea81c0ebe4b8ab789669d63706e5e6321ae0427ab9cfb2f537949  assets/templates/PROGRESS.md
5c04b1871889e0872860dc7603b6dffbb4a5c9efc13dc9ac53e27703a0a4264b  assets/templates/PROPOSED_DESIGN.md
```

写入本记录后仍需再次运行验证命令；最终完成声明必须引用该最后一轮终端输出，而不是仅引用本文件。
