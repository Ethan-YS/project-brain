# HANDOFF — Cross-window Bridge

> **What this file answers**: "What was the previous session doing right before window-switch? What's still warm in their head that didn't make it into STATUS?"
>
> **Character**:
> - **Transient**. The currently-online AI writes this when the user signals window-switch.
> - **Before next switch**, the AI first `git mv` the existing `HANDOFF.md` to `handoffs/<its-last-modified-timestamp>.md`, then writes the new one. The main file `HANDOFF.md` always represents the most recent switch.
> - **Light**. When STATUS is freshly overwritten, HANDOFF can be very short or near-empty — it only carries **things that can't yet be settled into the structured files** (hunches not yet articulated, weird debugging observations, half-tried approaches).
>
> **vs `STATUS.md`**:
> - STATUS = steady state ("currently working on X")
> - HANDOFF = transient at the switch — **NOT a backup of STATUS**
>
> **Who reads this**: the AI starting a new session (if this file exists).
>
> **Multi-workstream (v2.1)**: copy this template as `HANDOFF_<workstream>.md` (e.g., `HANDOFF_dev.md`); archive to `handoffs/<workstream>/YYYY-MM-DD-HHMM.md`. See METHODOLOGY §3.5.

---

<!-- Recommended minimal form: single free-form paragraph, < 5 lines.

Example:

2026-04-30 21:30 switching windows (context at 70%).
Currently stopped at src/auth/login.ts:42. Next session reads STATUS, picks up step 2 directly.
Have a hunch token boundary case still has an edge — try edge inputs when picking back up.

If STATUS is freshly overwritten and there's no "still-warm-not-yet-settled" content, even shorter:

2026-04-30 21:30 switching windows. STATUS overwritten. No fresh ambiguous content.

Don't pad to look complete. HANDOFF's value is "short and accurate." -->

_Filled in by the AI at the first window-switch_
