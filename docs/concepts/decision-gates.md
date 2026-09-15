# Human Decision Gates & Schema Protocol

> The boundary between human authority and agent delegation in Vibe Workflow.

---

## 1. Product Intent vs. Implementation Detail

### Human Decision Authority (Mandatory Gate)
- Product scope additions, feature removal, or behavior modifications.
- Public API breaking changes and backward compatibility contracts.
- Database Schema, DDL, table relationships, migrations, and destructive data backfills.
- Architecture choices with long-term lock-in (e.g., storage vendor, security protocol).
- Authentication, authorization, sensitive data logging, or permissions.
- Introduction of external paid services, secrets, or network perimeter changes.
- Destructive operations and irreversible side-effects.
- Deploying, publishing, pushing, or creating release tags.

### Agent Implementation Authority (Delegated by Default)
- Private class, function, and variable naming.
- Helper method extraction and internal module refactoring.
- Local folder organization and test file organization.
- Implementing features following existing codebase patterns without changing external commitments.

---

## 2. Database Schema Five-Step Protocol

Any schema change must strictly follow this sequential pipeline:

```text
1. Investigate (Audit schema, data volume, and dependencies)
   ↓
2. Proposal Marked Pending (Detailed proposal with rollback and nullability rules)
   ↓
3. Explicit Human Approval (User explicitly confirms proposal and risk assessment)
   ↓
4. Migration Implementation (Write reversible migration scripts)
   ↓
5. Migration Verification (Execute up/down verification in isolated environment)
```

> **Key Rule**: A product owner stating "just add the column" does NOT constitute approval unless data semantics, migration locks, and rollback paths have been documented and reviewed.
