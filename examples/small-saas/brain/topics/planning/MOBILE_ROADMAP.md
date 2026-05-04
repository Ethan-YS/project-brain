# MOBILE_ROADMAP — Mobile platform plan

> **Status**: deferred to v1.0+. This doc captures the plan and the reasons it's not happening yet.

---

## Why mobile is on the roadmap

User research consistently shows ~30% of target users want to **read** notes on phone (occasional reference) and ~10% want to **lightly edit** (capture quick thoughts that get cleaned up later on desktop).

Almost nobody wants the full editing experience on phone — and the few who do are using Obsidian Mobile or similar. We won't compete on power-mobile-editing.

## Why it's deferred

Three reasons, in order of weight:

1. **Solo dev capacity**: shipping iOS + Android takes ~3 months, during which desktop polish + bug fixes would slow to a crawl. v0.x users (who paid for the desktop product) come first.
2. **Sync architecture stability**: mobile devices are a much harsher sync environment (background suspend, network flakiness, battery constraints). Building mobile before the desktop sync engine is rock-solid means inheriting all desktop sync bugs *plus* mobile-specific ones.
3. **Local-first on mobile is harder**: iOS sandboxing makes "your notes are plain `.md` files in a folder you choose" mostly false on iOS — files live in app-private storage and have to be exported. The story is messier; we want time to find the right shape, not ship a compromise.

## When mobile happens

Trigger conditions (all must be true):
- v1.0 desktop release shipped + 3 months of stability
- Sync engine has had < 5 sync-related bugs reported in 60 days
- Founder either has bandwidth or has hired help

## What the first mobile release will be

**Read-only iOS app**, shipped first. No editing, just access:
- Browse note tree
- Read notes
- Full-text search
- Sync from desktop (one-way: pull only)

This is the least risky shape: zero conflict resolution complexity, sandboxing is just "we read the files we synced down," easy to test.

**Edit support comes later** (call it v1.5 mobile) — once read-only proves the sync engine handles mobile gracefully.

**Android** comes after iOS works. Android sandboxing is friendlier, which is why iOS goes first (handle the harder case before the easier).

## What we won't build for mobile

- Quick capture widgets (interesting but a feature creep risk)
- Voice-to-note (out of scope, AI feature)
- iCloud Drive integration (we have our own sync; mixing two creates support nightmares)

## Open questions

- React Native vs SwiftUI / native? Leaning native for iOS (better local file access), but RN is faster to ship.
- Subscribe-only mobile, or included with one-time purchase? Likely included — splitting platforms feels like a betrayal of "buy a tool" model.

---

**Last updated**: 2026-04-08
