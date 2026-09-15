# Installing Vibe Workflow for OpenAI Codex

## Global Installation (CLI)

Run the Codex internal installer script from your terminal:

```bash
python3 "${CODEX_HOME:-$HOME/.codex}/skills/.system/skill-installer/scripts/install-skill-from-github.py" \
  --repo sz-xiaohuolong/vibe-workflow \
  --path skills/vibe-workflow
```

Or run the repository installer:

```bash
./install.sh codex
```

## In-Chat Installation

In an active Codex conversation, send:

```text
Please use $skill-installer from https://github.com/sz-xiaohuolong/vibe-workflow/tree/main/skills/vibe-workflow to install this skill.
```

## Verification

In your next session, test invocation:

```text
$vibe-workflow Inspect current project state and verify requirement freeze.
```
