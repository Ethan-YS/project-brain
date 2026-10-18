# HANDOFF — Shift Report

> **What this file answers**: "What does the next window need to know first, and what is still only in the outgoing window's head?"
>
> **Character**:
> - **Transient**. The currently-online AI writes this when the user signals a window-switch / handoff / shift change.
> - **Before next switch**, the AI first moves anything in this file that is *still valid* into STATUS, DECISIONS or `topics/operations/RUNBOOK.md`.
> - **Then archives**: `git mv` the file to `handoffs/<its-last-modified-timestamp>.md` and writes the new one. The main file `HANDOFF.md` always represents the most recent switch; the archive is history, never current (Trap 21).
> - **A shift report, not a backup** (v2.9). Real handoffs settled into the six sections below — use them, delete the empty ones. The discipline is not "keep it short"; it is **don't write what the next window can look up**. STATUS has the state, DECISIONS the why, RUNBOOK the commands and traps. HANDOFF carries what only this shift knows.
>
> **vs `STATUS.md`**:
> - STATUS = steady state ("currently working on X") — overwritten at every session end
> - HANDOFF = what this shift saw that STATUS can't carry — **NOT a copy of STATUS**
>
> **Who reads this**: the AI starting a new session (if this file exists).
>
> **Multi-workstream (v2.1)**: copy this template as `HANDOFF_<workstream>.md` (e.g., `HANDOFF_dev.md`); archive to `handoffs/<workstream>/YYYY-MM-DD-HHMM.md`. See METHODOLOGY §3.5.
>
> **Concurrent windows (v2.8)**: name other workstreams, not their current windows — window names go stale at the next switch; the roster in MAP §6 is where they live (Trap 18). Same for neighbour projects (v2.9): name the project, never its session id.

---

<!-- Six sections (why these six: METHODOLOGY §3.2). Delete any with nothing in it — an empty heading is noise.
     If STATUS was just overwritten and nothing is warm, the whole file can be two lines:

     2026-04-30 21:30 switching windows. STATUS overwritten; nothing warm. -->

## This shift

<!-- When and why you're switching (context limit / break / refocus); what landed, by commit. Two or three lines — the detail is in git and STATUS. -->

## First thing for the next window

<!-- The one thing to do or check before anything else. Point at STATUS "Next steps" rather than repeating it. -->

## Procedures found this shift

<!-- A way of doing something that took effort to find. Write it into topics/operations/RUNBOOK.md and leave a one-line pointer here — not the procedure itself. -->

## Waiting on others

<!-- What you're waiting on that the STATUS ledgers don't already carry: the user's pending answers, a neighbour project's reply, an external party. -->

## New traps

<!-- Things that bit you this shift. Add each to RUNBOOK §4 (numbered) and list the numbers here. -->

## Still warm

<!-- The genuinely unwritten: hunches, half-tried approaches, odd observations you can't explain yet. The original reason this file exists. -->

_Filled in by the AI at the first window-switch_
