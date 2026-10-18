# RUNBOOK — Commands, health check, where to look, traps

> **What this file answers**: "How do I operate this, how do I know it's healthy, where do I look when it isn't, and what has bitten us before?"
>
> **Character**: slow-changing, append-mostly. The one topic doc the template ships pre-registered in MAP §5 (v2.9), because in practice this content had no home and lived in handoffs — where it went stale with every switch.
>
> **Who reads this**: anyone about to operate the project; anyone debugging; the AI writing a HANDOFF ("new traps" and "procedures found" go here, not into the handoff).
>
> **vs `MAP.md` §1**: MAP §1 is the minimum to get the project running. This file is everything after that.
> **vs `STATUS.md` "How to verify this"**: STATUS names which commands to run *now*; this file explains what each one reports.

---

## 1. Commands

<!-- Routine operations beyond "run the project": import, rebuild, batch jobs, deploy, rollback. One line of intent per command. Group by task, not by tool. -->

```bash
⚠️ TODO ⚠️
```

## 2. Health check

<!-- What reports live state, and what each line means. If there is a doctor / status / check command, this is where it's documented. If nothing is automated yet, say so — the next session will know not to look for it. -->

```bash
⚠️ TODO ⚠️
```

## 3. When something breaks, look here first

<!-- Symptom → first place to look → second place. Written in the user's words ("why didn't it run last night"), not the system's. Grows one row per incident. -->

| Symptom (as the user says it) | Look first | Then |
|---|---|---|
| ⚠️ TODO ⚠️ | | |

## 4. Traps (numbered, append-only)

<!-- Things that bit us. Numbered so handoffs and STATUS can cite "trap 7" instead of retelling it. Never renumber; strike through when a trap stops applying, don't delete. -->

1. ⚠️ TODO ⚠️
