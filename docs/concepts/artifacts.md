# Artifact Model & Fact Ownership

> Mapping engineering truth across living documents and release-scoped archives.

---

## 1. Release-Scoped Artifacts (Archival & Immutable upon Release)

Located at: `docs/vibe/releases/<release-id>/`

```text
docs/vibe/releases/<release-id>/
├── PROJECT_BRIEF.md         # Problem, Target Users, Scope, Non-Goals, Frozen Req Status
├── CHANGE.md                # Delta relative to prior release (Added/Modified/Removed)
├── SPEC.md                  # Complete Effective Product Behavior (REQ, AC, Error states)
├── PROPOSED_DESIGN.md       # Target architectural changes & proposed schema migrations
├── IMPLEMENTATION_PLAN.md   # Vertical slices, task graph, test mappings
└── VERIFICATION.md          # Traceability evidence matrix for every REQ / AC
```

---

## 2. Living Project Documents (Constantly Verifiable)

Located at: `docs/vibe/`

- **`AGENTS.md`**: Core agent operating directives and repo script entrypoints.
- **`docs/vibe/PROJECT.md`**: Global project charter, current active release pointer, and quality profile.
- **`docs/vibe/TECH_DESIGN.md`**: Living system architecture—must accurately describe currently working, passing code.
- **`docs/vibe/PROGRESS.md`**: Single durable tracker of current state, stable commit, blockers, and next task.
- **`docs/vibe/decisions/DEC-xxx.md`**: Architecture Decision Records (ADRs).
- **`docs/vibe/bugs/BUG-xxx.md`**: Deep systematic root-cause analyses.
