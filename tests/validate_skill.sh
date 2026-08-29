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
  references/routing.md
  references/artifacts.md
  references/context.md
  references/gates.md
  references/execution.md
  references/quality-and-release.md
  assets/templates/PROJECT_BRIEF.md
  assets/templates/PROJECT.md
  assets/templates/CHANGE.md
  assets/templates/SPEC.md
  assets/templates/TECH_DESIGN.md
  assets/templates/PROPOSED_DESIGN.md
  assets/templates/IMPLEMENTATION_PLAN.md
  assets/templates/PROGRESS.md
  assets/templates/DECISION.md
  assets/templates/BUG.md
  assets/templates/VERIFICATION.md
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
rg -q 'publish/deploy/release.*READY_TO_SHIP' "$skill_dir/SKILL.md"
rg -q 'subagent-driven-development' "$skill_dir/SKILL.md"
rg -q 'executing-plans' "$skill_dir/SKILL.md"
rg -q 'written plan.*顶层执行编排' "$skill_dir/SKILL.md"
rg -q 'Current Workflow State: `未建立/待核验`' "$skill_dir/assets/templates/PROGRESS.md"
rg -q 'Triggered: `待核验`' "$skill_dir/assets/templates/PROGRESS.md"
rg -q 'Status: `PROPOSED`' "$skill_dir/assets/templates/PROPOSED_DESIGN.md"
rg -q 'PROPOSED_DESIGN.md' "$skill_dir/references/artifacts.md"
rg -q 'PROPOSED_DESIGN' "$skill_dir/references/context.md"
rg -q 'Proposed Design:' "$skill_dir/assets/templates/IMPLEMENTATION_PLAN.md"
rg -q 'Verification Status' "$skill_dir/assets/templates/VERIFICATION.md"
rg -q 'Shipping Authorization' "$skill_dir/assets/templates/VERIFICATION.md"

if command -v skills-ref >/dev/null 2>&1; then
  skills-ref validate "$skill_dir"
else
  echo "skills-ref: unavailable; Skill Creator quick_validate used"
fi

echo "vibe-workflow static validation: PASS"
