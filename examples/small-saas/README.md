# Example: Quill — a local-first notes SaaS

This example shows what a `brain/` folder looks like for a fictional but fully-shaped SaaS project after about three months of solo development.

## The fictional project

**Quill** is a local-first markdown notes app sold as a SaaS:
- **Core value**: notes stay on the user's machine in plain markdown files; the SaaS layer adds cross-device sync + a buyable license + email support
- **Stage**: v0.3 released, ~80 paying users, mid-development on v0.4 (offline editing improvements)
- **Stack**: Electron desktop + FastAPI sync server on Cloudflare Workers + SQLite local store + Stripe billing
- **Business model**: one-time purchase ($49 lifetime) — not a subscription
- **Single founder** + an AI collaborator on day-to-day work

## What's in this example

```
brain/
├── PROJECT.md       — One-line definition + 4 explicit non-goals
├── MAP.md           — Module list, dependencies, topic doc index (10 docs registered)
├── STATUS.md        — Currently working on offline editing UX, blocked on conflict resolution algorithm
├── DECISIONS.md     — 4 real-shaped decisions: SQLite vs Postgres / Workers vs Lambda / no Vim mode / one-time purchase vs subscription
├── HANDOFF.md       — A short "switching windows mid-feature" handoff
├── handoffs/        — (empty in this example, but where archived HANDOFFs would go)
└── topics/
    ├── systems/SYNC_PROTOCOL.md       — How the sync algorithm works
    ├── operations/RELEASE_CHECKLIST.md — Pre-release checks
    ├── planning/MOBILE_ROADMAP.md      — Mobile platform plan (deferred)
    └── feedback/BUG_TRACKER.md         — Active bugs from users
```

## How to read this example

Open the files in this order:
1. `brain/PROJECT.md` — Get the project's shape in 30 seconds
2. `brain/MAP.md` — See the module structure and where everything lives
3. `brain/STATUS.md` — Understand what the founder is working on right now
4. `brain/DECISIONS.md` — Read the 4 entries; notice how each "Rejected alternatives" section makes the entry valuable beyond a CHANGELOG line
5. `brain/HANDOFF.md` — See how short and specific a window-switch handoff can be
6. Browse `brain/topics/` for one of each category to see how problem-dimension classification plays out

This example is **single-workstream** (one main development line). Multi-workstream examples are intentionally deferred until real-world usage produces one — see [METHODOLOGY §3.5](../../METHODOLOGY.md#35-workstream-split-mode-v21-optional) for when the split mode applies.
