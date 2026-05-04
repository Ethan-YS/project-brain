# BUG_TRACKER — Active bugs

> Filtered from `FEEDBACK_INBOX.md`. Each bug has a stable ID; status flows: Inbox → Triaging → In Progress → Resolved → Released.

---

## In Progress (target this release)

### BUG-007 — Offline edits on two devices lose changes
- **Reported**: 4 users (most-voted issue)
- **Repro**: Edit note on Device A offline → Edit same note on Device B offline → Both come online → Device B's changes silently lost
- **Status**: Active (v0.4 main feature)
- **Owner**: founder
- **Notes**: see STATUS.md, currently building conflict detection + UI

## Triaging

### BUG-008 — Pasting Lightroom photo creates broken `file://` link
- **Reported**: 1 user (a photographer)
- **Repro**: Lightroom → drag photo → drop into Quill editor → link is `file://...` which dies on other devices
- **Status**: Won't fix in v0.4. Likely v0.5 — needs design work on "what should pasting an image actually do."
- **Owner**: deferred

### BUG-009 — Search highlights wrong term in CJK text
- **Reported**: 2 users (Chinese + Japanese)
- **Repro**: Search for `测试` → highlight starts 1 char too early
- **Status**: SQLite FTS5 tokenizer issue with CJK. Workaround exists (porter tokenizer instead of unicode61) but needs migration. v0.5 candidate.
- **Owner**: triaged, backlog

## Recently Resolved (released in v0.3.2)

### BUG-006 — `.dmg` install fails on Apple Silicon (arm64)
- **Reported**: 12 users in 24h after v0.3 release
- **Cause**: build pipeline only produced x86_64 binary
- **Fix**: switched to Universal Binary build (`npm run dist:mac` now produces both archs)
- **Released**: v0.3.2 (2026-04-22)
- **Followup**: added "test both arm64 and x86_64" to RELEASE_CHECKLIST as a red line

## Won't Fix / Deferred

### BUG-005 — License activation timeout on slow networks
- **Reported**: 1 user (rural connection)
- **Status**: Won't fix in current shape. Workaround: increase license worker timeout from 5s to 30s. The deeper fix (offline grace period) is a v1.0 feature.

---

## Bug ID allocation

Use sequential `BUG-NNN` (1-indexed). Don't reuse IDs even after resolution — historical references to BUG-007 should always resolve.

## Migration trigger

Move to GitHub Issues when bug count exceeds **50** active. Until then, this file is lighter — and avoids pushing user-feedback PII into a public repo (privacy rule: don't include real names, emails, payment IDs in commits).
