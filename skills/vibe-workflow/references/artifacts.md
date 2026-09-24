# Artifact 模型与追踪

## 何时读取

首次接入项目、建立 Release、创建或更新文档、解决事实冲突、做 Requirement Traceability 或封存 Release 时读取本文件。

## 先接管，后补齐

1. 检查仓库已有 AGENTS、README、docs、需求、设计、进度、测试、迁移和发布约定。
2. 找到职责等价物时沿用，不额外创建平行目录。
3. 只有职责缺失时，才从 `assets/templates/` 复制相应模板。
4. 在项目已有 Document Map、`DOCUMENT_MAP.md` 或等价索引中记录“职责 → 实际路径 → 状态 → 依据”。一个仓库只维护一个权威地图；索引只导航，不承载产品或技术结论。首次审计和重跑规则见 [init.md](init.md)。
5. 更新 AGENTS 时保留已有规则，只加入必要的事实源路径和恢复顺序；不复制产品正文。

## Release-scoped artifacts

建议路径：

```text
docs/vibe/releases/<release-id>/
├── PROJECT_BRIEF.md
├── CHANGE.md
├── SPEC.md
├── PROPOSED_DESIGN.md
├── IMPLEMENTATION_PLAN.md
└── VERIFICATION.md
```

| Artifact | 拥有的事实 | 不拥有的事实 |
|---|---|---|
| PROJECT_BRIEF | Problem、Target User、Scope、Constraints、Acceptance Goals、Requirement Version/Status | 低层实现设计 |
| CHANGE | 相对上一 Release 的 Added/Changed/Removed/Fixed | 当前完整产品行为 |
| SPEC | 当前 Release 的完整 Effective Product Behavior、REQ/AC、状态、错误、边界、non-goals | 私有实现细节 |
| PROPOSED_DESIGN | 当前 Release 尚未实现的目标技术方案、影响、恢复、验证设计和批准状态 | 当前真实架构 |
| IMPLEMENTATION_PLAN | Slice/Task、依赖、文件、验证、REQ/AC 映射 | 新产品能力 |
| VERIFICATION | 每个 REQ/AC 的实际证据、结果、限制、commit/artifact | 未执行检查的推测 |

CHANGE 是 delta；SPEC 是完整当前行为。Agent 默认读取当前 Release 的 Effective SPEC，不叠加所有历史 delta 推导需求。

## Living project documents

```text
AGENTS.md
docs/vibe/PROJECT.md
docs/vibe/TECH_DESIGN.md
docs/vibe/PROGRESS.md
docs/vibe/decisions/
docs/vibe/bugs/
```

`DOCUMENT_MAP.md` 仅在仓库没有既有地图时创建；与 `PROJECT.md` 内的地图二选一。以上目录只是新建项目的建议路径，不要求存量仓库迁移。

| Artifact | 职责 |
|---|---|
| AGENTS.md | Agent 长期行为规则、事实源入口、项目命令；不复制业务正文 |
| PROJECT.md | 当前项目定位、当前 Release、Quality Profile；可承载既有 Document Map |
| DOCUMENT_MAP.md 或既有地图 | 治理职责的真实路径、状态和定位依据；仅作导航 |
| TECH_DESIGN.md | 当前真实架构、模块、接口、数据、权限、运行和验证入口 |
| PROGRESS.md | 当前 State/Status/Slice/Task、Last Stable Commit、证据、阻塞和 Next Task |
| DEC-xxx.md | 重大选择、方案、取舍、批准、影响和恢复 |
| BUG-xxx.md | 症状、复现、证据、根因、修复、回归测试和状态 |

## 事实所有权

不存在一个文件对所有事实都“优先”。按问题找 owner：

- 产品应该如何行为：当前 Effective SPEC。
- 产品现在实际如何行为：代码、运行证据和测试；若偏离 SPEC，必须显式处理冲突。
- 当前架构：TECH_DESIGN，并由代码/配置核验。
- 某 Release 尚未实现的目标技术方案：该 Release 的 PROPOSED_DESIGN；实现与验证后才把成立部分合并进 TECH_DESIGN。
- 当前执行位置：PROGRESS，并由 Git/代码/证据核验。
- 为什么这样决定：DEC。
- 某历史版本当时是什么：该 Released Release 的封存 artifacts。

发现冲突时不要选择最方便的文件静默覆盖。说明冲突、确定 owner、修正过期文档或进入 Requirement Change。

## 当前架构与目标方案

`TECH_DESIGN.md` 只描述由代码、配置或运行证据核验的当前架构。不得在实现前把目标设计写成当前事实。

新 Release 的设计写入 release-scoped `PROPOSED_DESIGN.md`，并标明 `Status: PROPOSED | APPROVED | IMPLEMENTED | REJECTED`、目标 Release、相关 REQ/AC 和 DEC。`DESIGNED` 的主要证据是已批准的 PROPOSED_DESIGN 及必要 DEC；实现和验证后，再将真实成立的部分合并到 TECH_DESIGN，并保留 proposal/DEC 作为历史。

## Requirement Traceability

轻量追踪链：

```text
REQ-003
→ AC-007
→ PROPOSED_DESIGN §4.2 / DEC-012
→ SLICE-02 / TASK-09
→ RecordingServiceTests
→ PASS evidence
→ commit or result artifact
```

分散维护但必须可连接：

- SPEC：REQ → AC。
- PROPOSED_DESIGN/DEC：REQ/AC → 目标 Design；实现并验证后由 TECH_DESIGN 描述成立的当前架构。
- IMPLEMENTATION_PLAN：REQ/AC → Slice/Task/Test。
- PROGRESS：Task → current evidence/status。
- VERIFICATION：REQ/AC → evidence/result/commit。

Release Verification 必须能逐项回答“REQ 是否真的完成”，不能只回答“代码写好了”。

## 更新矩阵

| 变化 | 必须更新 | 按需更新 |
|---|---|---|
| 新 Release/Feature | PROJECT_BRIEF、SPEC、PLAN、PROGRESS | PROPOSED_DESIGN、DEC、CHANGE；实现后按证据更新 TECH_DESIGN |
| 产品行为变化 | 当前 Release baseline/SPEC、CHANGE | PROJECT、PROPOSED_DESIGN、DEC |
| 架构/数据/公开接口变化 | PROPOSED_DESIGN、PLAN、PROGRESS；适用 Gate 时含 DEC | SPEC（产品行为受影响时）；实现验证后更新 TECH_DESIGN |
| Bug 修复 | BUG、测试/evidence | TECH_DESIGN、PROGRESS、VERIFICATION |
| Task 完成 | PROGRESS、Task evidence | PLAN 状态、BUG/DEC |
| Release 完成 | VERIFICATION、PROGRESS | PROJECT、release notes |

不相关文档无需机械修改。若容易造成误解，在当前记录中写明“不更新及理由”。

## 模板选择

从以下文件复制，而不是把模板作为 reference 阅读：

- `assets/templates/PROJECT_BRIEF.md`
- `assets/templates/PROJECT.md`
- `assets/templates/DOCUMENT_MAP.md`（仅在现有仓库没有地图时）
- `assets/templates/CHANGE.md`
- `assets/templates/SPEC.md`
- `assets/templates/TECH_DESIGN.md`
- `assets/templates/PROPOSED_DESIGN.md`
- `assets/templates/IMPLEMENTATION_PLAN.md`
- `assets/templates/PROGRESS.md`
- `assets/templates/DECISION.md`
- `assets/templates/BUG.md`
- `assets/templates/VERIFICATION.md`

复制后将未知事实明确标为“待澄清/未验证”，不得猜测填充；未通过 Requirement Gate 时不得把模板状态改成 FROZEN。
