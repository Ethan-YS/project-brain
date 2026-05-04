# feedback/

> **What goes here**: User feedback, bug tracking, triage process.
>
> **Decision criterion**: ask yourself — "Is this doc answering: **what is reality / what are users telling us?**"

---

## Typical content (the common 3-piece set)

| File | Purpose |
|---|---|
| `FEEDBACK_INBOX.md` | **Raw** feedback inbox, reverse-chronological, preserves user's actual words |
| `BUG_TRACKER.md` | Filtered-from-inbox **actionable bugs**, tracked by ID with status |
| `FEEDBACK_TEMPLATES.md` | Templates for feedback collection + reply templates + triage flow + severity rubric |

## Doesn't belong here

- ❌ System design → `systems/` (a bug's **root cause analysis** may inform systems docs, but the bug entry itself belongs here)
- ❌ Release procedures → `operations/`
- ❌ Feature planning → `planning/`
- ❌ A bug's **decision rationale** after fix → `brain/DECISIONS.md` (if the fix involved an irreversible design change)

## Division of the 3 files

- **INBOX = raw**: **preserve user's words** verbatim. Don't process, merge, or shorten. It's a "data source," not a "todo list."
- **TRACKER = actionable**: filter from INBOX what we'll fix, assign BUG-XXX IDs, track state.
- **TEMPLATES = process**: templates for users + flow + rubric for ourselves.

**Cross-reference rule**: each bug has its own ID (BUG-XXX). When INBOX entries reference a bug, they cite the ID ("filed as BUG-008"); TRACKER entries can also cite the original feedback's date. Bidirectional reference makes "which user reported this first" traceable.

## Privacy rules (read this)

FEEDBACK_INBOX may receive real user info. **Don't commit to git**:
- ❌ Real names / emails / phone numbers / verified social accounts
- ❌ Activation codes / payment proofs / order numbers
- ❌ Screenshots containing user PII

**OK to commit**:
- ✅ User pseudonyms / handles
- ✅ Public product feedback content
- ✅ System info (OS version, app version)

## Migration threshold

If bug count **exceeds ~50, consider migrating to GitHub Issues**. Below that, markdown-based is light enough — and avoids pushing user-feedback PII into a public repo.

## State flow

Suggested bug states:
```
Inbox → Triaging → In Progress → Resolved → Released
                                    │
                                    └→ Won't Fix / Deferred
```

Before each release, clear "In Progress" or label "deferred to next version." After release, move "Resolved" to "Released."
