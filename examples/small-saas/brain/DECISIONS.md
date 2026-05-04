# DECISIONS — Decision Log

> **Append-only.** Each entry must include "Rejected alternatives" — without it, this file degrades into a worse CHANGELOG. **Newest at top.**

---

## Entry format

```markdown
### YYYY-MM-DD — [Short title]

- **Decision**: what specifically was decided
- **Why**: motivation, tradeoffs, what triggered this
- **Rejected alternatives**:
  - Considered A, didn't pick because: ...
  - Considered B, didn't pick because: ...
- **Affected scope**: which modules / files / processes
- **Trigger context**: what occasion led to this
```

---

## Decision records (newest at top)

### 2026-04-20 — One-time purchase ($49 lifetime), not subscription

- **Decision**: Quill is sold as a one-time purchase. $49 buys lifetime access to all current features + minor version updates. Major versions (v2.0+) may require a paid upgrade — but v1.x updates are forever.
- **Why**: Our target user (Notion-burned knowledge workers) has explicit subscription fatigue. They want to *buy a tool*, not *rent a service*. Aligning the business model with the user's value system is itself a marketing channel — the pricing page is half the pitch.
- **Rejected alternatives**:
  - **Subscription ($5/month)**: easier MRR math, but contradicts the "your notes belong to you" core belief. Subscription means "stop paying and lose access," which is exactly what Notion does to people. Couldn't say one thing in marketing and the other in pricing.
  - **Freemium with paid sync**: would put the "your notes are yours" belief in the free tier and the value capture in sync — but user testing showed people who want local-first also want sync; making them pay for sync feels like a tax on the founding philosophy.
- **Affected scope**: Billing logic in `worker/license/`, pricing page, all marketing copy.
- **Trigger context**: Pre-launch debate on monetization model. Final push from a user testing call where 4/5 testers said "I'd pay one-time but not subscribe."

### 2026-03-12 — Cloudflare Workers (not AWS Lambda) for sync server

- **Decision**: The sync server runs on Cloudflare Workers + R2 + KV. Not AWS Lambda + S3 + DynamoDB.
- **Why**: Cloudflare Workers have ~0ms cold start (Lambda is 100-500ms for Python). For a sync server that gets pinged every few seconds during active editing, cold starts dominate UX. Cloudflare's R2 has no egress fees (Lambda + S3 has $0.09/GB egress that scales with user count). KV is dirt-simple for the device-pairing table.
- **Rejected alternatives**:
  - **AWS Lambda + API Gateway + S3 + DynamoDB**: AWS toolchain is more familiar, but cold starts hurt sync UX, egress costs scale with success (a feature shouldn't get more expensive as it gets more popular), DynamoDB pricing is anxiety-inducing for a solo dev.
  - **Self-hosted on a VPS**: cheaper at scale but operational burden is exactly what a solo founder shouldn't take on. Also no edge replication — sync latency varies wildly by user location.
  - **Vercel Functions / Deno Deploy**: similar edge benefits to Cloudflare, but less mature for non-frontend workloads. Cloudflare Workers + R2 is the most boring choice that works.
- **Affected scope**: `worker/`, deploy scripts, monitoring (we use Cloudflare Analytics, not Datadog).
- **Trigger context**: Initial infrastructure decision before writing the first sync code.

### 2026-02-28 — SQLite (not Postgres) for local store

- **Decision**: Each Quill installation has its own SQLite database for note metadata + full-text search index. Notes themselves stay as plain `.md` files; SQLite is just the index.
- **Why**: SQLite is local, embedded, zero-ops, and bulletproof for single-user workloads. We don't need clustering, replication, or concurrent multi-user writes — every assumption Postgres is built for is irrelevant here.
- **Rejected alternatives**:
  - **Postgres on a Cloudflare Hyperdrive**: would need a per-user database or a tenant column, network latency on every search, server-side cost scaling with user count, much more operational surface area. Solving problems we don't have.
  - **Just `.md` files + filesystem search (ripgrep)**: would work but would mean re-scanning files on every search; for a knowledge base of 5000+ notes, search latency becomes painful. The SQLite FTS index is the right tradeoff between "local-first" and "actually fast."
  - **DuckDB**: tempting (great FTS, columnar) but the toolchain for embedded use in Electron is less mature than SQLite. SQLite is boring and that's good.
- **Affected scope**: `desktop/renderer/src/store/`, search feature, sync engine (sync diffs are computed against SQLite metadata).
- **Trigger context**: Initial architecture decision when the project was named.

### 2026-01-15 — No Vim mode in v1

- **Decision**: Quill v1.x ships with standard CodeMirror 6 keybindings only — no Vim mode, no Emacs mode, no custom keymap UI.
- **Why**: Implementing reliable Vim emulation inside CodeMirror 6 is genuinely hard (cm-vim is a separate maintained package with its own quirks). Solo dev — every feature has a maintenance tail. The 5% of users who *need* Vim are also the 5% who can use a different editor for note-taking, while the other 95% don't care. The bar for "must-have v1 feature" is "would the average target user notice if it's missing?" — Vim mode fails this.
- **Rejected alternatives**:
  - **Implement with cm-vim package**: ~1 week of work, ongoing maintenance every CodeMirror major version. Not free.
  - **Custom keymap configuration UI**: even more work than Vim mode, and most users won't customize keybindings anyway.
  - **Promise Vim mode for v2.0**: users will ask, say "post-v1 we'll consider it," don't commit yet.
- **Affected scope**: Editor module, keyboard shortcut docs, future maintenance burden.
- **Trigger context**: Feature scope debate during v0.1 planning. A vocal early user kept asking for Vim mode; needed to make a clean "no" with a reason.
