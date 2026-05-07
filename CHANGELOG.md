# Changelog

All notable versions of this methodology. Format roughly follows [Keep a Changelog](https://keepachangelog.com/).
This project's versioning follows the methodology's own evolution, not strict semver — major versions correspond to structural changes; minor versions add modes or refine mechanics.

---

## [2.4.1] — 2026-05-07

Same-day point release. v2.4.0 was the structural switch to plugin distribution; v2.4.1 lands the fixes that surfaced during local install on Claude Code 2.1.89.

### Fixed

- **`marketplace.json` schema**: top-level `description` field is rejected by `claude plugin validate` (`✘ root: Unrecognized key: "description"`). Moved to `metadata.description`, the validator-recognized location. v2.4.0's marketplace manifest accepted `marketplace add` but failed strict validation — now passes cleanly with zero warnings.

### Added

- **README Option A CLI fallback** (en + zh): the `/plugin` slash command isn't exposed in every Claude Code environment (some embedded / SDK contexts strip it). Added the `claude plugin marketplace add ...` / `claude plugin install ...` CLI subcommand form, framed as fallback-not-primary. Confirmed working via Claude Code 2.1.89.

### Maintainer notes — lessons learned shipping a Claude Code plugin

Real product behavior surfaced during local validation that future plugin maintainers should know. None of this is in our methodology — it's plugin-distribution infrastructure, recorded here so it's traceable.

- **`plugin update` checks `plugin.json` version, not git commit sha.** A plugin installed at commit A and the same plugin pushed at commit B that both declare `version: 2.4.0` will not trigger an update — Claude Code reports "already at the latest version (2.4.0)". To ship any plugin content change (even a docs-only fix), **bump `plugin.json` version**.
- **`marketplace update` syncs only the top-level `marketplace.json`, not the plugin source files inside.** Plugin source files (`SKILL.md` / `README.md` / `scripts/`) are pulled at install time and only refresh on a real `plugin update` (which requires the version bump above). To roll a stale install forward without a version bump, the user must `uninstall` then `install` again.
- **Maintainer release flow**: edit → bump `plugin.json` version → commit → push → users run `claude plugin marketplace update <name>` then `claude plugin update <plugin>`. The two-step (marketplace, then plugin) matters: the second step is what actually rotates the user's installed files.

### Triggered by

Local install verification of v2.4.0 on Claude Code 2.1.89 turned up two real issues and one observed behavior:
1. `claude plugin validate` rejected the v2.4.0 marketplace.json — fixed
2. `/plugin` slash command returned "isn't available in this environment" in the local environment — CLI fallback added to README
3. After fixing both, `claude plugin update project-brain@sprout-labs` reported "already at the latest version (2.4.0)" because `plugin.json` version hadn't moved — confirms the bump-version-to-ship rule above. v2.4.1 is the test of this exact pipeline.

### Considered and deferred

- **Calling this v2.5** — no, methodology unchanged; only distribution mechanics shifted within v2.4.x. Stay precise about what "minor" means
- **Adding a pre-publish version-bump check to `scripts/doctor.sh`** — `doctor.sh`'s scope is "structural health of `brain/`," not plugin-distribution housekeeping. Lives in two different layers. Defer

---

## [2.4.0] — 2026-05-07

### Changed

- **Distribution form**: `project-brain` now ships as a one-command Claude Code plugin via the `sprout-labs` marketplace. Users install with two slash commands inside Claude Code:

  ```
  /plugin marketplace add Ethan-YS/project-brain
  /plugin install project-brain@sprout-labs
  ```

  Replaces the previous `git clone https://github.com/Ethan-YS/project-brain.git ~/.claude/skills/project-brain` flow.

- **Repository layout** (Claude Code plugin convention):
  - `SKILL.md` → `skills/project-brain/SKILL.md` (preserved via `git mv` for blame continuity)
  - Internal `<skill-path>/scripts/scaffold.sh` references → `${CLAUDE_PLUGIN_ROOT}/scripts/scaffold.sh`
  - "alongside this file" cross-references → absolute `${CLAUDE_PLUGIN_ROOT}/...` paths (METHODOLOGY.md, templates/, scripts/doctor.sh)

- **README.md / README.zh-CN.md** Quick start rewritten:
  - **Option A** flips from manual `git clone` to plugin install, with the four user-facing trigger phrases listed inline (kick-off / startup / handoff / update) so a first-time user knows what to say after install
  - Old-user migration note added: `rm -rf ~/.claude/skills/project-brain` before installing the plugin (plugin install would otherwise shadow the standalone copy)
  - **Option B** (manual `scaffold.sh`) preserved unchanged for non-Claude-Code users (Cursor / Copilot / Codex / Aider) and for users who only want the bash scaffold without AI orchestration

### Added

- **`.claude-plugin/plugin.json`** — plugin manifest declaring `name`, `version: 2.4.0`, description, author (Ethan), homepage, repository, license, keywords
- **`.claude-plugin/marketplace.json`** — marketplace entry under `name: sprout-labs`, source `"./"` (the marketplace and the plugin live in the same repo). Marketplace name is brand-level rather than plugin-level, so future Sprout Labs plugins can list under the same marketplace without renaming

### Not changed

- `METHODOLOGY.md` — methodology itself unchanged. This release is distribution mechanics only
- `scripts/scaffold.sh` / `scripts/doctor.sh` — both still standalone-executable for non-plugin users
- `templates/` — unchanged
- `examples/small-saas/` — unchanged
- The methodology's **activation boundary** (no auto-trigger just because `brain/` exists; explicit user request required) — explicitly preserved in plugin form. The plugin format does not introduce auto-detection; plugin install only changes how the SKILL.md gets onto the user's machine, not when it activates

### Triggered by

Maintainer ask: "make this open-the-box installable as a skill." The previous flow required users to know the exact `~/.claude/skills/<name>/` path convention and run a `git clone` with a specific destination — high enough friction that real users would skip it. Claude Code's plugin marketplace system (officially supported as of late 2026) reduces install to two slash commands the user can copy-paste.

### Considered and deferred

- **Submitting to Anthropic's official `claude-plugins-official` marketplace** (https://claude.ai/settings/plugins/submit) — deferred until the project has n=3 real third-party users. Aligns with the "wait for real friction" stance set in v2.3.1's STATUS. The self-hosted `sprout-labs` marketplace works without that submission
- **Auto-trigger on directory entry** (e.g., detecting a `brain/` folder and activating without an explicit user request) — refused. This was already settled in v2 ("Judgment Division Principle"). Rebooting the auto-trigger debate inside a plugin context would re-litigate a closed question
- **Removing the standalone `git clone` install path entirely** — kept Option B for Cursor / Copilot / Codex users. The plugin path is for Claude Code only; the bash scaffold is the AI-agnostic fallback

---

## [2.3.1] — 2026-05-04

### Fixed

- **`README.md` / `README.zh-CN.md` Quick start**: the `Health check` block used `./scripts/doctor.sh /path/...` while the scaffold examples directly above used `./project-brain/scripts/...`. Copy-pasting both consecutively would file-not-found on the doctor line. Unified to `./project-brain/scripts/doctor.sh`.
- **`examples/small-saas/README.md`**: footer pointed to `examples/multi-workstream/` with `(TODO — not yet written)`. That directory is **intentionally deferred** until real-world multi-workstream usage produces one (per the project's "real friction tells you what's worth building" principle), not unfinished work. Reworded as deferred and linked to METHODOLOGY §3.5 instead.

### Triggered by

A third round of external review (GPT-based) after v2.3.0 release. Three suggestions raised; first two were the consistency bugs above (fixed). The third (appending `doctor` to `scaffold.sh` "Next steps" output) was deferred — doctor's design intent is periodic health-check on evolving `brain/`, not install-time validation; placing it as scaffold step 5 would fire false-positive warnings on fresh-scaffold placeholders and reframe the tool's mental model. Reasoning recorded in the maintainer's local DECISIONS for future-proofing.

---

## [2.3.0] — 2026-05-04

### Added

- **`scripts/doctor.sh`** — read-only structural health check covering 6 of the methodology's documented traps:
  1. brain/ structure completeness (required core files exist)
  2. STATUS.md soft cap (80 lines)
  3. `⚠️ TODO ⚠️` placeholder residue (PROJECT.md flagged as warning, others as info)
  4. DECISIONS entries missing "Rejected alternatives"
  5. MAP §5 ↔ topics/ consistency (unregistered files / stale entries)
  6. HANDOFF freshness (via `git log`, flags HANDOFFs > 14 days old)

  Reports issues with severity (❌ critical / ⚠️ warning / ℹ️ info) but **never modifies anything and never decides what should be fixed** — aligns with the "AI proposes, user decides" principle. Exit code 0 unless critical issues exist.

- **`examples/small-saas/`** — a fully-filled example project ("Quill," a fictional local-first markdown notes SaaS at v0.3). Every file in `brain/` populated with real-shaped content:
  - `PROJECT.md` with 4 explicit non-goals
  - `MAP.md` with module list, dependencies, topic doc index
  - `STATUS.md` mid-feature snapshot
  - `DECISIONS.md` with 4 entries (SQLite vs Postgres / Workers vs Lambda / no Vim mode / one-time purchase vs subscription) — each with concrete "Rejected alternatives"
  - `HANDOFF.md` showing a short, specific window-switch handoff
  - 4 topic docs (`SYNC_PROTOCOL`, `RELEASE_CHECKLIST`, `MOBILE_ROADMAP`, `BUG_TRACKER`)

  Validates against `doctor.sh` with 0 warnings. Designed to be the fastest way to understand "what filled-in `brain/` content actually looks like."

- **`examples/README.md`** — index for examples (more coming as the methodology is used in more contexts; PRs welcome).

### Changed

- README adds a "Health check" subsection in Quick start pointing to `doctor.sh`
- README adds an "See a fully-filled example" pointer to `examples/small-saas/`
- README Documentation section now lists all 7 entry-point files (METHODOLOGY / CHANGELOG / SKILL / templates / examples / scaffold.sh / doctor.sh)

### Triggered by

External review (GPT) suggested 6 enhancements after v2.2.1; we evaluated each against the "real friction tells you what's worth building" principle and chose the 2 with concrete user value:
- `doctor.sh` — auto-catches 6 of the documented traps; aligns with the "structure-only checks, no judgment" design principle
- `small-saas/` example — addresses the most common new-user feedback ("the templates are abstract; what does filled-in look like?")

Deferred (not in v2.3): adapter auto-generation (no real drift yet), Lite mode (no user pain reported), migration assistant script (LLM territory, not bash territory), DECISIONS-as-ADR-folder (no project has hit the 30+ entry threshold).

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
  - `LICENSE` Copyright clarified to `Ethan-YS (Sprout Labs)` (legal entity matches Sprout Labs / Ethan branding in README header)
  - `README` / `METHODOLOGY` Authors section unifies under Ethan-YS / Sprout Labs.
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
