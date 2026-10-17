#!/usr/bin/env bash
set -euo pipefail

test_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_dir="$(cd "$test_dir/.." && pwd)"
skill_dir="$repo_dir/skills/vibe-workflow"
default_validator="${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-creator/scripts/quick_validate.py"
validator="${SKILL_CREATOR_VALIDATOR:-$default_validator}"

if [[ ! -f "$validator" ]]; then
  echo "Skill Creator validator not found: $validator" >&2
  echo "Set SKILL_CREATOR_VALIDATOR to quick_validate.py." >&2
  exit 1
fi

uv run --no-project --with pyyaml python "$validator" "$skill_dir"

uv run --no-project --with pyyaml python - "$skill_dir" <<'PY'
import pathlib
import re
import sys
import yaml

root = pathlib.Path(sys.argv[1])

skill = (root / "SKILL.md").read_text()
assert skill.startswith("---\nname: vibe-workflow\ndescription: Use when ")
assert skill.count("\n---\n") >= 1
assert len(skill.splitlines()) <= 500

metadata = yaml.safe_load((root / "agents/openai.yaml").read_text())
assert set(metadata) == {"interface"}
interface = metadata["interface"]
assert set(interface) == {"display_name", "short_description", "default_prompt"}
assert interface["display_name"] == "Vibe Workflow"
assert 25 <= len(interface["short_description"]) <= 64
assert "$vibe-workflow" in interface["default_prompt"]

broken = []
link_pattern = re.compile(r"\[[^\]]+\]\(([^)]+)\)")
for markdown in root.rglob("*.md"):
    for target in link_pattern.findall(markdown.read_text()):
        if target.startswith(("http://", "https://", "#", "/")):
            continue
        relative_target = target.split("#", 1)[0]
        if relative_target and not (markdown.parent / relative_target).exists():
            broken.append(f"{markdown.relative_to(root)} -> {target}")
assert not broken, broken

print("metadata and relative links: valid")
PY

required_files=(
  references/lifecycle.md
  references/init.md
  references/routing.md
  references/orchestration.md
  references/artifacts.md
  references/context.md
  references/gates.md
  references/execution.md
  references/quality-and-release.md
  assets/templates/AGENT_RULES.md
  assets/templates/PROJECT_BRIEF.md
  assets/templates/PROJECT.md
  assets/templates/DOCUMENT_MAP.md
  assets/templates/CHANGE.md
  assets/templates/SPEC.md
  assets/templates/TECH_DESIGN.md
  assets/templates/PROPOSED_DESIGN.md
  assets/templates/IMPLEMENTATION_PLAN.md
  assets/templates/PROGRESS.md
  assets/templates/DECISION.md
  assets/templates/BUG.md
  assets/templates/VERIFICATION.md
  assets/templates/RETRO.md
)

for required_file in "${required_files[@]}"; do
  test -f "$skill_dir/$required_file"
done

test ! -e "$skill_dir/README.md"
test ! -d "$skill_dir/scripts"

if rg -n 'TODO|TBD|Briefly describe|Add the task-specific' \
  "$skill_dir/SKILL.md" "$skill_dir/agents" "$skill_dir/references" "$skill_dir/assets"; then
  echo "scaffold placeholders found" >&2
  exit 1
fi

rg -q 'Requirement Status == FROZEN' "$skill_dir/SKILL.md"
rg -q 'READY_TO_SHIP' "$skill_dir/SKILL.md"
rg -q 'subagent-driven-development' "$skill_dir/SKILL.md"
rg -q 'executing-plans' "$skill_dir/SKILL.md"
rg -q 'orchestration.md' "$skill_dir/SKILL.md"
rg -q '^\| Release `<ID>` \|' "$skill_dir/assets/templates/PROGRESS.md"
rg -q '^\- \[ \] `SLICE-01`' "$skill_dir/assets/templates/PROGRESS.md"
rg -q 'Triggered: `待核验`' "$skill_dir/assets/templates/PROGRESS.md"
rg -q 'Status: `PROPOSED`' "$skill_dir/assets/templates/PROPOSED_DESIGN.md"
rg -q 'PROPOSED_DESIGN.md' "$skill_dir/references/artifacts.md"
rg -q 'PROPOSED_DESIGN' "$skill_dir/references/context.md"
rg -q 'Proposed Design:' "$skill_dir/assets/templates/IMPLEMENTATION_PLAN.md"
rg -q 'Verification Status' "$skill_dir/assets/templates/VERIFICATION.md"
rg -q 'Shipping Authorization' "$skill_dir/assets/templates/VERIFICATION.md"
rg -q '\$vibe-workflow init' "$skill_dir/SKILL.md"
rg -q '再次.*init' "$skill_dir/references/init.md"
rg -q '一个仓库只保留一个权威地图' "$skill_dir/references/init.md"
rg -q '跨模块可观察触发' "$skill_dir/references/routing.md"
rg -q 'POC_VALIDATED' "$skill_dir/references/quality-and-release.md"
rg -q 'IMPLEMENTED_UNVERIFIED' "$skill_dir/assets/templates/PROGRESS.md"
rg -q 'POC_VALIDATED' "$skill_dir/assets/templates/VERIFICATION.md"

# V0.3 七阶段与契约断言
test -f "$repo_dir/tests/scenarios-v0.3.md"
rg -q '## S31' "$repo_dir/tests/scenarios-v0.3.md"
rg -q '## S44' "$repo_dir/tests/scenarios-v0.3.md"
rg -q 'Test Seams' "$skill_dir/assets/templates/SPEC.md"
rg -q 'Ready Frontier' "$skill_dir/assets/templates/IMPLEMENTATION_PLAN.md"
rg -q 'Task Handoff Contract' "$skill_dir/assets/templates/IMPLEMENTATION_PLAN.md"
rg -q 'Current Stage' "$skill_dir/assets/templates/PROGRESS.md"
rg -q 'Test Matrix' "$skill_dir/assets/templates/VERIFICATION.md"
rg -q '\.evidence' "$skill_dir/assets/templates/VERIFICATION.md"
rg -q 'Release Retrospective' "$skill_dir/assets/templates/RETRO.md"
rg -q '1\. Thinking.*2\. Planning.*3\. Building.*4\. Review.*5\. Testing.*6\. Shipping.*7\. Reflecting' "$skill_dir/SKILL.md"
rg -q 'Discovery Spike' "$skill_dir/references/routing.md"
rg -q 'Task Handoff Contract' "$skill_dir/references/execution.md"

# Git/Shipping 分离的静态契约检查；场景行为由 S45–S53 独立重放。
uv run --no-project python - "$skill_dir" "$repo_dir/tests/scenarios-v0.3.md" <<'PY'
import pathlib
import re
import sys

root = pathlib.Path(sys.argv[1])
skill = (root / "SKILL.md").read_text()
execution = (root / "references/execution.md").read_text()
quality = (root / "references/quality-and-release.md").read_text()
gates = (root / "references/gates.md").read_text()
lifecycle = (root / "references/lifecycle.md").read_text()
scenarios = pathlib.Path(sys.argv[2]).read_text()

stage_names = ["Thinking", "Planning", "Building", "Review", "Testing", "Shipping", "Reflecting"]
for source in (skill, lifecycle):
    rows = re.findall(r"^\| \*\*(\d)\. (\w+)\*\*", source, re.M)
    assert rows == [(str(i), name) for i, name in enumerate(stage_names, 1)], rows

assert "## Lightweight Git Workflow\n" in execution, "缺少独立的轻量 Git 流程"
git_section = execution.split("## Lightweight Git Workflow\n", 1)[1].split("\n## Vertical Slice", 1)[0]
actions = re.findall(r"^\| `(\w+)` \|", git_section, re.M)
assert actions == ["COMMIT", "PUSH_BRANCH", "COMMIT_AND_PUSH", "OPEN_PR"], actions

for path in ("SKILL.md", "references/lifecycle.md", "references/routing.md", "references/gates.md", "references/quality-and-release.md"):
    assert "execution.md#lightweight-git-workflow" in (root / path).read_text(), path

shipping = quality.split("### Human Shipping Gate\n", 1)[1].split("\n---", 1)[0]
assert "READY_TO_SHIP Gate" in shipping
assert "Shipping Authorization" in shipping
# 原触发句会把全部 Push/PR 误送到 gstack:ship，必须保持移除。
assert "Push、PR、publish、deploy、release" not in shipping
assert "Shipping Gate 只决定是否执行 push/PR" not in gates
assert "严禁执行 git push / deploy / release" not in gates

for number in range(45, 54):
    scenario = scenarios.split(f"## S{number} ", 1)[1].split("\n## S", 1)[0]
    assert "### Participant Prompt" in scenario and "### Evaluator Oracle" in scenario

print("Git/Shipping 静态契约：通过；七阶段结构保持不变")
PY

# 仅验证公共模板、样例和场景结构；实际合并行为按场景执行并核对文件差异。
uv run --no-project python - "$skill_dir" "$test_dir" <<'PY'
import json
import pathlib
import re
import sys

root, tests = map(pathlib.Path, sys.argv[1:])
template_path = root / "assets/templates/AGENT_RULES.md"
template = template_path.read_text()
assert template.startswith("# Agent 工作约定\n")
assert re.findall(r"^## (\d)\. ", template, re.M) == list("12345")
clauses = re.findall(r"^- (.+)$", template, re.M)
assert len(clauses) == len(set(clauses)) == 27
copies = [path for path in root.rglob("*.md") if template.strip() in path.read_text()]
assert copies == [template_path], copies
fixtures = json.loads((tests / "fixtures/agent-rules.json").read_text())
assert set(fixtures) == {"existing-agents", "existing-agent", "both", "conflict", "template-update"}
for files in fixtures.values():
    for name, content in files.items():
        assert not pathlib.Path(name).is_absolute() and ".." not in pathlib.Path(name).parts
        assert isinstance(content, str) and content
scenarios = (tests / "scenarios-agent-rules.md").read_text()
assert re.findall(r"^## R(\d+) ", scenarios, re.M) == [f"{i:02}" for i in range(1, 13)]
for section in re.split(r"\n## R\d+ ", scenarios)[1:]:
    assert "### Participant Prompt" in section and "### Evaluator Oracle" in section
print("规则接入资源结构：通过；行为结果须另查执行记录")
PY

if command -v skills-ref >/dev/null 2>&1; then
  skills-ref validate "$skill_dir"
else
  echo "skills-ref: unavailable; Skill Creator quick_validate used"
fi

echo "vibe-workflow static validation: PASS"
