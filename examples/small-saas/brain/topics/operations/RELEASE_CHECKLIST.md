# RELEASE_CHECKLIST — Pre-release red lines

> Walk through this before tagging a release. Red lines are the ones we've been bitten by; "soft" items are reminders that don't block release.

---

## 🔴 Red lines (must pass)

- [ ] **Both `mac-arm64` and `mac-x86_64` builds tested** on real hardware (not just CI).
  - Why: v0.3.1 shipped broken on arm64 because we only tested on Intel mac. Cost us 1 day of user complaints.
- [ ] **Sync round-trip tested** between two devices (or at minimum: install → save → uninstall → reinstall → restore).
  - Why: BUG-002 was a sync regression that survived because we only tested locally.
- [ ] **License activation flow** end-to-end on a fresh machine (not the dev machine where keys are cached).
  - Why: BUG-005 was an activation bug that worked on every machine that already had a license cached.
- [ ] **All `BUG_TRACKER.md` items in "In Progress"** either resolved or moved to "Deferred to next version" with a 1-line reason.
- [ ] **Run `scripts/doctor.sh`** on the project — fix any ❌ critical issues.

## 🟡 Soft checks (good to do, doesn't block)

- [ ] CHANGELOG entry written (user-facing language, not commit titles)
- [ ] Screenshots updated if UI changed meaningfully
- [ ] FEEDBACK_INBOX scanned for "anyone reported an issue with X recently"
- [ ] Sentry / error tracking dashboard checked for last 7 days

## Build commands

```bash
npm run dist:mac    # produces .dmg files for arm64 + x86_64 (Universal Binary)
npm run dist:win    # produces .exe installer
npm run dist:linux  # produces .AppImage
```

Each takes ~10 minutes. The mac builds need notarization, which adds another 5-10 min and requires Apple Developer cert env vars set.

## Tag and publish

```bash
git tag v0.X.Y
git push origin v0.X.Y
# GitHub Actions will publish to releases page from the tag
```

## After release

- [ ] Announce in the user newsletter (Mailchimp template "Quill release")
- [ ] Update homepage if a major feature
- [ ] Watch Stripe / Sentry for ~24h post-release for spike in errors

---

**Last updated**: 2026-04-12 (added `scripts/doctor.sh` step)
