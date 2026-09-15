# Installing Vibe Workflow for Claude Code

## Standard Installation via `npx skills`

Claude Code fully supports the open `agentskills.io` specification. Run:

```bash
npx skills add sz-xiaohuolong/vibe-workflow
```

## Global Directory Installation

Alternatively, clone or copy the skill directory into your global Claude skills directory:

```bash
mkdir -p ~/.claude/skills
cp -R skills/vibe-workflow ~/.claude/skills/
```

Or using the repo installer:

```bash
./install.sh claude
```

## Project-Level Installation

To share Vibe Workflow with your team inside a specific repository:

```bash
mkdir -p .claude/skills
cp -R skills/vibe-workflow .claude/skills/
```
