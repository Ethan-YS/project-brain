# DECISIONS — Decision Log

> **What this file answers**: "Why did we do X? Why didn't we do Y?"
>
> **Character**:
> - **Append-only**, never modify historical entries (even when overturned, write a new entry that supersedes; don't edit the old one)
> - **Reverse-chronological** — newest at the top, oldest at the bottom
> - **Each entry must include 5 elements** (template below)
>
> **vs `CHANGELOG`**:
> CHANGELOG records "what was done"; DECISIONS records "**why** it was done + why **NOT** the alternatives."
> Without "rejected alternatives," this file degrades into a worse CHANGELOG.
>
> **Who reads this**: when tracing a design's rationale; when trying to understand "why is the project shaped this way?"; when something doesn't make sense.

---

## Entry format (template)

```markdown
### YYYY-MM-DD — [Short title of the decision]

- **Decision**: what specifically was decided
- **Why**: motivation, tradeoffs, what triggered this decision
- **Rejected alternatives**:
  - Considered A, didn't pick because: ...
  - Considered B, didn't pick because: ...
- **Affected scope**: which modules / files / processes are impacted
- **Trigger context**: what occasion led to this (bug? user feedback? methodology discussion?)
```

**Why "rejected alternatives" is mandatory**:
Without it, future readers only see "what was done," not "what was traded off." A decision's real value is in **the paths not taken** — that's where a project's judgment lives.

---

## Decision records (newest at top)

<!-- New entries are appended below this divider. Don't modify existing entries. -->

<!-- Sample starter entry (recommended to keep — proves this file's been used since day one):

### YYYY-MM-DD — Establishing project-brain

- **Decision**: Adopt the `brain/` single-folder structure (5 continuity-layer files + 4 topic categories), with project-root `CLAUDE.md` as the continuity protocol entry.
- **Why**: A project needs a "future-me / new-AI-session can pick this up" skeleton from day one. Refactoring after scattered docs accumulate costs more.
- **Rejected alternatives**:
  - **Wait until the project runs a while, then organize**: organic growth structures have unclear boundaries; later refactor is more expensive
  - **Just a single README**: a single file rapidly outgrows its "quick scan" value threshold
- **Affected scope**: how all docs are organized in this project
- **Trigger context**: new project kick-off. Methodology from project-brain.

-->

⚠️ TODO ⚠️ — append your first real decision here
