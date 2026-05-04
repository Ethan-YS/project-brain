# topics/

This directory holds the project's **business / technical topic docs** — categorized by **what problem they answer**, not by business module.

## 4 categories and decision criteria

| Subdirectory | Contains | Decision criterion (ask yourself) |
|---|---|---|
| `systems/` | System design, architecture, technology choices | "Is this answering: how is it designed?" |
| `operations/` | Ops, processes, packaging, deployment | "Is this answering: how do I operate it / what to do each release?" |
| `planning/` | Roadmap, pricing strategy, plans | "Is this answering: what are we going to build / how do we plan it?" |
| `feedback/` | User feedback, bug tracking, triage | "Is this answering: what is reality / what are users telling us?" |

Each subdirectory has its own README explaining: what to put here, what NOT to put here, naming conventions, maintenance disciplines.

## Why "by problem dimension" instead of "by business module"

Modules grow, shrink, get renamed, get merged, get split. The four problem dimensions ("design / ops / planning / feedback") are far more stable.

A single business module (say, "payment") will scatter across four subdirectories:
- Design docs in `systems/`
- Deploy logs in `operations/`
- Pricing strategy in `planning/`
- User feedback in `feedback/`

But when you need to find something, you always know which subdirectory.

## vs the continuity layer (`brain/` direct children)

The 5 continuity-layer files (PROJECT/MAP/STATUS/DECISIONS/HANDOFF) are **read every session** metadata.
Topic layer (here) is **read on demand** — `MAP.md` §5 registers each topic doc with a "when to read" trigger condition.

## Maintenance disciplines

- Each doc starts with "this file answers: ..." to clarify boundaries
- New docs must be registered in `brain/MAP.md` §5
- Removed / deprecated docs must be unregistered from MAP §5
- No "last updated" field — protocol guarantees freshness; if you really need to know, use `git log -1 --format=%ad <path>`
