# Installing Vibe Workflow for Antigravity & Gemini CLI

## Global Installation

Antigravity and Gemini CLI load customizations from `~/.gemini/config/skills/`:

```bash
mkdir -p ~/.gemini/config/skills
cp -R skills/vibe-workflow ~/.gemini/config/skills/
```

Or using the repo installer:

```bash
./install.sh gemini
```

## Project Workspace Installation

To enable Vibe Workflow for a specific project workspace:

```bash
mkdir -p .agents/skills
cp -R skills/vibe-workflow .agents/skills/
```

The agent will discover `vibe-workflow` hierarchically from the current working directory to the Git root.
