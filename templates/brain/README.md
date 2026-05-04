# brain/

This folder holds **everything about this project itself** — for future sessions, new windows, new collaborators to pick up the project quickly.

## Continuity layer (read every session)

5 core files directly under `brain/`:

| File | Answers | Time-scale |
|---|---|---|
| `PROJECT.md` | What is this project? Why does it exist? **What do we explicitly NOT do?** | Near-immutable |
| `MAP.md` | What does the project look like? Where do I find what? | Evolves with structure |
| `STATUS.md` | Where are we? Next step? What's blocked? | Instantaneous, overwritable |
| `DECISIONS.md` | Why did we do X? Why didn't we do Y? | Append-only |
| `HANDOFF.md` | The previous session's still-warm thoughts at window-switch | Transient, overwritten per switch |

`handoffs/` — past HANDOFFs archived as `YYYY-MM-DD-HHMM.md`.

## Topic layer (read on demand)

`topics/` — 4 categories, each business/technical doc placed by **what problem it answers**:

- `systems/` — "How is this designed?"
- `operations/` — "How do I operate it / what to do each release?"
- `planning/` — "What are we going to build / how do we plan it?"
- `feedback/` — "What is reality / what are users telling us?"

Decision criterion: see `topics/README.md`.

## How a new session uses this

1. Read `MAP.md` first — understand structure + know where docs live
2. Read `STATUS.md` next — know current progress
3. If `HANDOFF.md` exists, read it — get the previous session's "still warm" thoughts
4. Read `PROJECT.md` / `DECISIONS.md` on demand — understand scope / trace why
5. Use `MAP.md` §5 topic doc index to enter `topics/` content as needed

## Maintenance disciplines

- **Continuity layer 5 files don't overlap**: any piece of info should clearly belong to one of them. Mixing causes degradation.
- **PROJECT shouldn't change often**: if it does, the project's definition is drifting — record that in DECISIONS.
- **STATUS soft cap 80 lines**: over that, settle content into MAP (structural) or DECISIONS (rationale), then overwrite.
- **DECISIONS append-only**: never modify history. Even when overturning, do it with a new entry that supersedes the old one.
- **HANDOFF overwritten at next window-switch**: previous version archived to `handoffs/` first.

## Multi-workstream mode (v2.1, optional)

If this project has parallel independent workstreams, the continuity layer splits:
- Files become `STATUS_<workstream>.md` / `HANDOFF_<workstream>.md`
- Archives become `handoffs/<workstream>/YYYY-MM-DD-HHMM.md`
- PROJECT / MAP / DECISIONS / topics stay shared

See METHODOLOGY §3.5.

## Full methodology

See [`../METHODOLOGY.md`](../METHODOLOGY.md) (or wherever `project-brain` is located).
