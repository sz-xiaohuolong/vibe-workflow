# Integrating Vibe Workflow with Cursor & Windsurf

Cursor and Windsurf support rule-based prompting via custom instructions.

## Cursor Integration

1. Run the repo installer to generate rule definitions:
   ```bash
   ./install.sh cursor
   ```
2. Or manually copy `adapters/cursor/vibe-workflow.mdc` to `.cursor/rules/vibe-workflow.mdc` in your target repository.

## Windsurf Integration

Copy `adapters/windsurf/.windsurfrules` to the root of your workspace:
```bash
cp adapters/windsurf/.windsurfrules .windsurfrules
```

## Cline & Roo Code

Copy `adapters/cline/.clinerules` to the root of your workspace:
```bash
cp adapters/cline/.clinerules .clinerules
```
