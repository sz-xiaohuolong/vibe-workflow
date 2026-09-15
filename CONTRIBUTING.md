# Contributing to Vibe Workflow

Thank you for your interest in improving Vibe Workflow!

## How We Work

Vibe Workflow is an engineering lifecycle orchestrator. Changes to its rules, states, or prompts must adhere to **Skill TDD**:

1. **Adversarial Scenarios First**: Propose new behavioral boundaries by creating an adversarial test case in `tests/scenarios.md`.
2. **Minimal Rule Changes**: Keep `SKILL.md` and references minimal. Avoid adding verbose prose or arbitrary bureaucracy.
3. **Validate**:
   Run the test validation script:
   ```bash
   ./tests/validate_skill.sh
   ```
4. **Pull Requests**: Open a PR with clear evidence showing before/after behavior.
