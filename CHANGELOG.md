# Changelog

All notable versions of this methodology. Format roughly follows [Keep a Changelog](https://keepachangelog.com/).
This project's versioning follows the methodology's own evolution, not strict semver — major versions correspond to structural changes; minor versions add modes or refine mechanics.

---

## [2.2.1] — 2026-05-04

### Fixed
- **`README.md` and `README.zh-CN.md` Status section**: still showed `v2.1` even though the repo had bumped to `v2.2.0` — now reflects v2.2.
- **`METHODOLOGY.md` §3.4**: still claimed `CLAUDE.md` was the methodology's "only reliable triggering point" — outdated since v2.2.0 added SKILL.md and three other adapter formats. Rewritten to list all five entry points (CLAUDE.md / SKILL.md / .cursorrules / .github/copilot-instructions.md / AGENTS.md) and clarify that the methodology is tool-agnostic.
- **`SKILL.md` description** trigger condition (2): "user opens a directory containing brain/" was over-broad and contradicted the methodology's activation boundary (don't auto-activate during casual conversation). Tightened to require an explicit user request to resume / continue / load / check status. Added an explicit "Activation boundary" section restating the rule.

### Triggered by
A second round of external review (GPT-based) caught three internal-consistency bugs that v2.2.0 missed: stale version statement, outdated "only entry point" claim, and an SKILL.md trigger that would cause the methodology's own activation boundary to be violated by Claude Code.

---

## [2.2.0] — 2026-05-04

### Added
- **`SKILL.md`** at repo root — Anthropic-style skill manifest with frontmatter (name / description / allowed-tools), making project-brain installable as a Claude Code skill via `git clone … ~/.claude/skills/project-brain/`
- **Adapter templates** for AI tools beyond Claude Code:
  - `templates/.cursorrules` — Cursor
  - `templates/.github/copilot-instructions.md` — GitHub Copilot Chat
  - `templates/AGENTS.md` — Codex CLI, Aider, Continue (AGENTS.md convention)
- **`scripts/scaffold.sh`** — mechanical scaffolding script (no judgment logic by design). One command copies `brain/` + selected adapters into a target project
- **README two-option Quick start**: install as Claude skill OR manual scaffold for any AI tool
- **README compatibility table** listing all 4 adapter files

### Fixed
- `templates/brain/README.md` — broken relative link `../METHODOLOGY.md` (would dangle once the template is copied into a user's project) → replaced with absolute GitHub URL

### Changed
- **Authors / LICENSE narrative coordination**:
  - `LICENSE` Copyright: `Rebecca and Sage` → `Ethan-YS (Sprout Labs)` (legal entity now matches Sprout Labs / Ethan branding in README header)
  - `README` / `METHODOLOGY` Authors section keeps the "Rebecca + Sage" collaboration narrative, with an explainer that Rebecca is Ethan's working name in collaboration contexts. Both layers coexist: business identity (Sprout Labs / Ethan) for legal / commercial; collaboration narrative (Rebecca + Sage) for project storytelling.
- `assets/social-preview.png` losslessly compressed (1.4 MB → 650 KB, fits well under GitHub's 1 MB social preview limit)

### Triggered by
External review feedback (GPT-based) flagged: (a) project sells itself as "AI-tool agnostic" but only ships a Claude adapter; (b) repo claims "skill" without a SKILL.md manifest; (c) header / authors / LICENSE narratives don't agree; (d) `templates/brain/README.md` has a relative link that breaks when copied. v2.2.0 addresses all four — turning project-brain from "methodology + templates" into an actually distributable, multi-tool, install-and-go skill.

---

## [2.1.0] — 2026-04-30

### Added
- **Workstream split mode** — for projects with parallel independent workstreams (e.g., development + operations + outreach in one product). `STATUS_<workstream>.md` / `HANDOFF_<workstream>.md` / `handoffs/<workstream>/` split per workstream; `PROJECT.md` / `MAP.md` / `DECISIONS.md` / `topics/` stay shared.
- `MAP.md` §6 "Workstream registry" (multi-workstream projects only)
- §3.5 in METHODOLOGY explaining the split: what splits, what stays shared, naming convention, enable/upgrade paths
- §4.7 in METHODOLOGY explaining update mechanism in multi-workstream context
- §1.3 startup protocol now branches on single- vs multi-workstream
- §1.4 kick-off has new step asking user single/multi-workstream
- **Trap 14**: same-window workstream switch memory pollution discipline

### Changed
- Default mode (single-workstream) is unchanged — v2.1 is an extension, not a replacement
- `MAP.md` "MAP self-calibration" section moved from §6 to last section (now §7 in multi-workstream-enabled MAP, still §6 in single-workstream MAP)

### Triggered by
A non-development project running parallel workstreams (operations + outreach) hit v2's hidden assumption "one project = one workstream." The user had naturally evolved a workaround using `STATUS_<workstream>.md` naming. v2.1 folds that workaround into the methodology.

---

## [2.0.0] — 2026-04-30

### Added
- `HANDOFF.md` — cross-window transient bridge (separate from STATUS)
- `handoffs/` directory for archived past handoffs
- **Judgment Division Principle** (§4.4) — the user decides "should we record?"; the AI decides "what specifically"; the user reviews the AI's judgment
- **Gentle inquiry for DECISIONS** (§4.5) — replaces hard-keyword detection; "does this count as decided?" instead of asserting "we decided X"
- Visible placeholders (`⚠️ TODO ⚠️` instead of `_TODO_`) — easier to spot when filling in templates
- Explicit git prerequisite — methodology assumes git history (Trap 13)
- **8 traps** documented from real evolution (Traps 1-9 + 10-13)
- Project-root `CLAUDE.md` becomes the only reliable continuity trigger (relies on Claude Code auto-load, not on AI scanning directories)

### Changed
- **Folder restructure**: `meta/` + `docs/` (v1's two-layer structure) merged into a single `brain/` folder containing the continuity layer (5 files at root) + `brain/topics/` (4 categories). Verbal alignment with file structure.
- `STATUS.md` and `HANDOFF.md` separated cleanly — STATUS is steady-state, HANDOFF is transient at window-switch
- Template language: paths and references use English (`brain/`, `topics/`); user-facing text remains language-neutral
- Removed `last_updated` field — protocol guarantees freshness; staleness check via `git log -1 --format=%ad <path>` if really needed

### Removed
- Auto-detection of "is this a project directory?" (the AI doesn't auto-scan; relies on user's explicit speech or project-root `CLAUDE.md`)
- Auto-handoff triggers based on context-window usage (the user controls when to switch windows)
- Sanity-check report enforcement on session start (only inside project directories with `brain/`; doesn't pollute non-project sessions)

### Triggered by
Survey of community approaches (Prompt Shelf, softaworks/agent-toolkit, Anthropic skills repo) revealed v1's structural advantages but mechanism gaps. Eight rounds of user-AI iteration, in which the user systematically rejected mechanism-creep ("don't automate judgments I should be making"), crystallized into the Judgment Division Principle.

---

## [1.0.0] — 2026-04-23

### Added
- **`meta/` folder** with 4 core files:
  - `PROJECT.md` (project definition + non-goals)
  - `MAP.md` (project map + topic doc index)
  - `STATUS.md` (current state, soft cap 80 lines)
  - `DECISIONS.md` (append-only decision log, requires "rejected alternatives")
- **`docs/` folder** with 4 problem-dimension subdirectories: `systems/`, `operations/`, `planning/`, `feedback/`
- Project-root `CLAUDE.md` directing new sessions to read `meta/MAP.md` + `meta/STATUS.md` first
- The "**rejected alternatives**" mandatory field for every DECISIONS entry
- The "**what we explicitly DON'T do**" forcing function in PROJECT.md
- 9 traps documented from initial implementation experience
- 4-stage migration sequence for existing projects (A: relocate, B: content unpacking, C: backfill DECISIONS, D: fill continuity layer, E: project-root CLAUDE.md)

### Triggered by
A real project that had accumulated 15+ scattered documents and one 32KB monolithic dev file. Every new AI session needed to re-read everything to figure out "what's going on here?" The realization: **larger context windows don't help — better information structure does.**

---

## Versioning principle

This methodology's version numbers track its own conceptual evolution:

- **Major version** (1.x → 2.x): structural change to the file layout (e.g., `meta/` + `docs/` → `brain/`)
- **Minor version** (2.0 → 2.1): adds a new optional mode or significantly refines mechanics
- **Patch version** (e.g., 2.1.1): clarifications, typo fixes, additions to traps

Open-source release versioning starts from 2.1.0 — corresponds to the version actually in production use by the original authors at the time of public release.
