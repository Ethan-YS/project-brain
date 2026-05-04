# PROJECT — Quill

> **What this file answers**: "What is this project? What problem does it solve? **What do we explicitly NOT do?**"

---

## One-line definition

A local-first markdown notes app sold as a SaaS — your notes are plain `.md` files on your disk; the cloud only handles cross-device sync and licensing.

## Problem solved

Existing notes apps (Notion, Bear, Roam, etc.) store your notes in their proprietary database — switching tools or shutting down their service means losing structure or losing notes entirely.

Quill keeps your notes as plain markdown files in a folder you choose. The app reads/writes those files directly; the optional sync server only ferries encrypted file diffs between your devices. You can stop paying us, uninstall the app, and your notes are untouched on disk.

The user gets: portable notes + cross-device sync + a one-time purchase (no subscription anxiety).

## What we explicitly DON'T do (non-goals)

- **No team collaboration / shared workspaces**, because team features add ~10× complexity for ~1.5× revenue, and our target user explicitly wants a personal tool. If they need team docs, they should use Notion or HackMD.
- **No WYSIWYG / rich text editor**, because the simpler the storage format, the longer the user's notes outlast the tool. Plain markdown stays readable in any text editor for the next 30 years; Lexical or Tiptap don't.
- **No mobile native apps in v1**, because shipping desktop solidly first matters more than stretching to a half-baked mobile experience. Mobile is on the roadmap but not before desktop is rock-solid.
- **No AI features in v1**, because "local-first" + "AI requires cloud / sends your notes to OpenAI" creates a value contradiction. AI features will arrive only when we can run them via local models or with explicit, opt-in cloud round-trips.

## Target users / who uses this

**Uses this**: individual knowledge workers — programmers, writers, researchers, lawyers — who:
- Have been burned by Notion exports / Evernote downgrades / Roam pricing changes
- Want their notes to outlast any single tool
- Are comfortable with plain markdown (or willing to learn)

**Doesn't use this**: teams that need shared workspaces; users who want WYSIWYG-rich docs with embedded databases; users who want AI integration as a primary feature.

## Project origin and core beliefs

Quill started after the founder lost ~200 notes during a Notion sync incident in 2025. Core beliefs:
- **Your notes belong to you, on your disk.** The SaaS layer is a convenience, not a hostage situation.
- **Local-first is not a feature, it's the architecture.** Sync, search, even AI all have to fit around plain `.md` files.
- **Simple formats outlast everything.** Markdown survived 20 years; no proprietary format has.
- **Solo-friendly business model.** One-time purchase, not subscription, because the founder is one person and aligns better with "buy a tool" than "rent a service."
