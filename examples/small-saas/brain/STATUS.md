# STATUS — Current Development State

> **What this file answers**: "Where are we? Next step? What's blocked?"
> **Soft cap**: 80 lines. Overwrite freely after settling stable content into MAP / DECISIONS.

---

## What we're doing now

**v0.4 — Offline editing UX**. Users can already edit while offline (notes are local files); the gap is **what happens when both devices edited the same note offline and then come online**. Currently the second device just loses its changes — that's #BUG-007 (top-voted user complaint).

## Next steps

1. Finish `LocalSyncEngine.detectConflicts()` — currently stubbed; needs to compare file mtime + content hash and produce a conflict object
2. Build `editor/ConflictView.tsx` — UI to show "your version vs the other device's version" side-by-side with a merge button
3. Add 5 conflict resolution test cases to `__tests__/sync/`
4. Pre-release: run `scripts/doctor.sh` and `RELEASE_CHECKLIST.md`

## Blockers / things to confirm

- **Unclear**: should we offer auto-merge for non-overlapping line edits, or always require manual review? The user research is ambiguous. Decision likely needs to be made before #BUG-007 closes.
- **External**: Stripe webhook latency has been spiky this week (3 reports of "I paid but didn't get the license email" — usually delivers in 15min). Not an action item yet, but if it gets worse we may need to add a "manual license recovery" admin endpoint.

## Uncommitted changes

- `desktop/renderer/src/editor/ConflictView.tsx` — first sketch, no styling, mock data only. Don't commit until decisions on auto-merge are made.

## What the most recent session did

- Wrote conflict-detection logic in `LocalSyncEngine.ts` (lines 80-142), but `detectConflicts()` itself is still a TODO at line 142
- Filed BUG-008 (Lightroom-style photo paste pastes a broken file:// link) — minor, deferred to v0.5
- Updated `topics/systems/SYNC_PROTOCOL.md` with the new conflict detection design
- Released v0.3.2 patch (fixes mac arm64 packaging — this should have been caught earlier; added to RELEASE_CHECKLIST)
