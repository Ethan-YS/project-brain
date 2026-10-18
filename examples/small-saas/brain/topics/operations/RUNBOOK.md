# RUNBOOK — Commands, health check, where to look, traps

> **What this file answers**: "How do I operate Quill, how do I know it's healthy, where do I look when it isn't, and what has bitten us before?"
> Slow-changing, append-mostly. Handoffs point here instead of retelling.

---

## 1. Commands

```bash
# Dev
npm run dev                                 # Electron + renderer with hot reload
npm test                                    # unit + sync tests (Windows CI runs the same)
npm run test:sync -- --grep conflict        # just the conflict cases while working on #BUG-007

# Release (walk RELEASE_CHECKLIST.md first)
npm run package -- --mac --arm64 --x64      # both mac archs — arm64 alone shipped broken once (trap 2)
npm run package -- --win
npm run release:tag v0.4.0

# Licenses (Stripe)
node scripts/licenses.mjs find <email>      # did the webhook create a license for this payment?
node scripts/licenses.mjs resend <email>    # resend the license email (idempotent)
```

## 2. Health check

```bash
npm run check     # one screen: sync engine self-test · Stripe webhook reachability · last 5 license emails · packaging targets present
```

Each line is ✅ / ⚠️ / ❌. `webhook: ⚠️ slow (>15 min)` is the Stripe latency we've seen this week — not ours to fix, but say so in STATUS.

## 3. When something breaks, look here first

| Symptom (as the user says it) | Look first | Then |
|---|---|---|
| "I paid but got no license email" | `npm run check` → webhook line | `node scripts/licenses.mjs find <email>`; license exists → `resend`; doesn't → Stripe dashboard, webhook attempts |
| "My note from the other device is gone" | #BUG-007 — second device loses offline edits on reconnect | `SYNC_PROTOCOL.md` §conflict detection; `detectConflicts()` is still stubbed (STATUS) |
| Conflict tests flake on Windows CI only | trap 1 (mtime resolution in the `fs.statSync` mock) | the algorithm — only after ruling trap 1 out |
| "The mac app won't open" | which arch they downloaded — v0.3.1 arm64 was broken (trap 2) | `RELEASE_CHECKLIST.md` step "test both mac archs" |

## 4. Traps (numbered, append-only)

1. **Windows mtime resolution.** The test framework's `fs.statSync` mock returns ~2-second mtime drifts on Windows. Conflict tests that compare mtimes flake there first. Rule this out before suspecting the conflict algorithm. (Seen 2026-04-24; not fixed.)
2. **mac arm64 packaging.** v0.3.1 shipped an arm64 build that wouldn't launch; x64 was fine. Fixed in v0.3.2; RELEASE_CHECKLIST now says test both archs on real hardware.
3. **Stripe webhook latency** spikes to 15+ minutes some weeks. Not a bug on our side — don't rebuild the license flow because of it. Three reports = a line in STATUS, not an action item.
4. **Lightroom photo paste** pastes a `file://` link, not the image (#BUG-008). Deferred to v0.5; don't "quick fix" it in the editor — it's a clipboard-format issue.
