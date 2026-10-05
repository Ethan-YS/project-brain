# Changelog

All notable versions of this methodology. Format roughly follows [Keep a Changelog](https://keepachangelog.com/).
This project's versioning follows the methodology's own evolution, not strict semver — major versions correspond to structural changes; minor versions add modes or refine mechanics.

---

## [2.7.0] — 2026-10-04

Second continuity channel. Triggered by Claude Code shipping **auto memory** — a per-repository `~/.claude/projects/<project>/memory/` directory whose `MEMORY.md` index is loaded into context at every session start. It is not a handoff mechanism (Anthropic's docs: a fresh session gets CLAUDE.md + the memory index, never a summary of the previous session) and it is invisible to every other tool, so it cannot replace `brain/`. But it is a second auto-loaded channel that Claude itself writes to, and the methodology can use that for exactly one thing: pointing at `brain/`.

### Added

- **Optional Claude Code auto-memory pointer** (METHODOLOGY §3.4): one `project`-type memory file + one `MEMORY.md` index line saying "continuity state lives in `brain/`; last HANDOFF at `<timestamp>` (`<workstream>`)". Created at kick-off, refreshed on every HANDOFF write (§4.3 gains step 3), replaced in place — never appended. Carries what the static instruction file cannot: when the last handoff happened. Optional and single-tool by design, same shape as the v2.6 SessionStart hook adapter; the two stack (hook = deterministic STATUS injection, pointer = Claude-authored signpost).
- **Trap 17 — auto memory as a shadow state store** (§6.6): the auto-loaded, Claude-writable, out-of-repo directory tempts an AI to keep "current state" there; the result is two states, one of which no other tool or `git log` can see. Also covers index accretion (appending a line per handoff until the 200-line load cap silently drops later entries). Not mechanizable by `doctor.sh` (outside the repo) — the first discipline-only trap since v2.6, flagged as such.
- **Startup discipline** (§1.3, SKILL §2): a surfaced pointer is a signpost only — run the read protocol, never report state from the pointer.

### Changed

- `SKILL.md` kick-off gains step 7 (write the pointer) and handoff gains step 4 (refresh it); `templates/CLAUDE.md` + `templates-zh/CLAUDE.md` window-switch line mentions the refresh.
- Trap count resynced to 17 in `README.md` and `SKILL.md`.

### Fixed

- **`README.zh-CN.md`** still said "14 条陷阱" and "catch 6 种" — the v2.6.1 resync only touched the English README and SKILL.md. Trap 15 in action, one release late. Now 17 / 8 checks.

### Why minor (not major)

File structure, templates' `brain/` layout, scaffold, doctor, and the four workflows are unchanged. What's added is an optional adapter for one tool plus the trap that guards it — the same class of change as v2.6's hook adapter.

---

## [2.6.1] — 2026-06-23

Internal-consistency fix from v2.6.0 (same shape as v2.2.1). v2.6.0 added `doctor.sh` checks 7 and 8 and labeled them "mechanizes Trap 15 / Trap 16" — but the trap list in `METHODOLOGY.md §6` stopped at Trap 14. So Trap 15 and Trap 16 were referenced (in the CHANGELOG and the doctor script) without ever being defined in the methodology: a dangling cross-reference — exactly the rot Trap 15 itself exists to catch, and one `doctor.sh` can't self-detect, since check 7 only scans a user project's `brain/`, never the methodology docs.

### Fixed

- **METHODOLOGY.md — new `§6.5 v2.6 traps (mechanized in doctor.sh)`** defining **Trap 15 (stale cross-references)** and **Trap 16 (cross-brain sibling references)**. Content matches what `doctor.sh` checks 7/8 already enforce; framed as the contrast to §6.4's discipline-only traps (these two shipped enforced from the day they were named).
- **`README.md` + `skills/project-brain/SKILL.md`**: "all 14 traps" → "all 16 traps". The count was stale the moment 15/16 were named.
- **`README.md` doctor pointer**: "catches the most common 6 traps" → reflects the 8 checks `doctor.sh` runs since v2.6.0 (checks 7/8 were added then, but this count wasn't updated alongside them).

### Triggered by

A walkthrough of the skill caught the dangling reference: `doctor.sh` and the CHANGELOG cite Trap 15/16, and `grep` confirmed neither appeared in `METHODOLOGY.md`. The fix is the project honoring its own discipline — Trap 15 is "stale cross-references," and the methodology was carrying one that pointed straight at its own missing definitions.

### Why a patch version

Per the versioning principle below, "additions to traps" is patch-level. This changes no file structure, templates, scaffold, or workflows — it backfills two definitions v2.6.0 should have shipped and resyncs the counts that referenced them.

---

## [2.6.0] — 2026-06-09

Mechanization release. Triggered by a model-generation review of the methodology, which surfaced a clean split: rules that encode **information design** (volatility-based file separation, continuity entry points — these stay) versus rules that encode **compensation for weaker AI judgment** (blanket ask-before-write, discipline-based reference hygiene — these can now relax or move into tooling). Two principles follow: spend git's reversibility instead of user attention where a wrong write is cheap, and never leave a mechanically-checkable rule to anyone's discipline.

### Added

- **doctor.sh check 7 — markdown link integrity**: relative links in `brain/` must resolve on disk (with `%20` decoding; fenced code blocks and HTML comments skipped); ASCII `#anchors` must exist at the target as an explicit `<a id>` or a matching heading slug; absolute-path links flagged. Mechanizes Trap 15 (stale cross-references). First run against real projects immediately caught true rot: wrong `../` depths, `~/`-prefixed links no renderer expands, links to since-renamed directories.
- **doctor.sh check 8 — cross-brain sibling references**: in projects with nested sub-brains, links from one sub-brain into a sibling's `brain/` are flagged — shared facts route via the parent brain; upward/downward references stay allowed. Mechanizes Trap 16.
- **Optional Claude Code SessionStart hook adapter** (`templates/claude-code-hooks.settings.json` + METHODOLOGY §3.4): injects `brain/STATUS.md` (+ `HANDOFF.md` if present) into context at session start, turning the startup protocol's STATUS half from prompted behavior into deterministic mechanism. Optional and single-tool by design — the methodology core stays tool-agnostic markdown.
- **doctor.sh checks 4/5 hardened against real-world formats** (follow-up from running the new checks across live projects): check 5 now recognizes markdown-link registrations, CJK filenames, and path-prefixed entries (e.g. `docs/foo.md`), and ignores placeholder lines (待添加/TODO/TBD); check 4 now recognizes numbered-decision headings (`### DR-NNN / TD-NNN`) alongside the template's bare-date style.

### Changed

- **§4.1 update mechanism → tiered trust.** Tier 1 (`STATUS` / `HANDOFF` / mechanical `MAP` registrations): the AI writes directly after the work lands and announces what it wrote in the same reply — git is the review surface, reverting costs one command. Tier 2 (`DECISIONS` / `PROJECT` / structural `MAP` redesigns): ask-before-write, unchanged — these encode shared commitments, and a wrong write corrupts understanding rather than a file. Silent writes remain forbidden at every tier; announcement is the non-negotiable part.
- **§4.4 "update the project brain" keeps per-item approval** even for Tier-1 files — that workflow is the user explicitly requesting a judgment checkpoint, which is a different moment than routine bookkeeping.
- SKILL.md core principles and both READMEs updated to match.

### Why minor (not major)

File structure, templates, scaffold, and all four workflows are unchanged. What changed is the trust calibration around writes and the enforcement medium for two traps (discipline → script).

---

## [2.5.1] — 2026-05-19

Documentation polish. Triggered by a real user comment pointing to discoverability gaps around v2.1's multi-workstream mode — the functionality has been there since v2.1, but the naming and prose weren't surfacing it for users searching with terms like "multi-thread project" / "parallel sessions" / "多线程项目".

### Added

- **README "The problem" section gained a new symptom line**: projects running multiple parallel workstreams (e.g., dev + ops + outreach) lose track of which session is on which line — explicit name-drop of the v2.1 use case in the problem statement itself. Same line added to README.zh-CN.md in Chinese.
- **`SKILL.md` description gained trigger (5)**: when the user describes the project as having multiple parallel workstreams / "多线程项目" / "多任务并行" — guide them to enable Multi-workstream Mode. Helps the matcher recognize this scenario in users' natural language.

### Changed

- **"Workstream split mode" → "Multi-workstream mode"**: renamed the v2.1 mode for clearer discoverability. The Chinese counterpart is "多线程模式" (the previous "工作流分裂模式" was awkward and didn't connect to Chinese users' mental model of "multi-threaded projects").
  - README.md §5 Core principle 5 title + evolution-story paragraph + documentation index link
  - README.zh-CN.md §5 Core principle 5 title + evolution-story paragraph
  - METHODOLOGY.md §3.5 title + two prose mentions (the "enable workstream split" → "enable multi-workstream mode" commit message example)
  - templates/AGENTS.md adapter (one mention)
  - templates-zh/brain/README.md §6 (one mention)
- **CHANGELOG.md v2.1 entry intentionally NOT renamed** — keeping "Workstream split mode" as the historical name for that release entry. Renaming history would erase the fact that the term was once different.

### Why a patch version (not minor)

No new functionality. v2.1's multi-workstream mode itself isn't changing — the templates, scaffold, SKILL workflows, doctor.sh all stay identical. Only documentation prose and the mode's display name are touched.

### Triggered by

A user commented on the marketplace listing asking "what about the case where multiple sessions are open simultaneously, or you're in the middle of one thing and need to switch to another?" The functionality to answer this (v2.1 multi-workstream mode) had existed for weeks, but the user's question revealed that:

1. README's "The problem" section listed 4 symptoms — none mentioned multi-workstream projects, so users searching for that scenario had no entry point
2. "Workstream split mode" as a name didn't match how Chinese users naturally describe the scenario (they think "多线程" / "并行任务")
3. SKILL.md description's 4 triggers didn't include any natural-language match for "multiple workstreams" or "多线程项目"

A single data point (n=1) is generally too thin to drive a change in v2's evolution philosophy ("real-world friction drives the next version"). But **documentation polish has a different threshold than functional change**: the cost of being more findable is near zero, the cost of being un-findable when functionality already exists is wasted user effort and false "v2 doesn't support this" impressions. The threshold for "polish what already exists to surface better" is lower than "add new mechanism."

### Considered and deferred

- **Adding an `examples/multi-workstream/` example project** — deferred. No specific user request asked for an example, and constructing a realistic multi-workstream example brand-from-scratch is ~30 minutes of new content creation rather than 10 minutes of audit-and-rename. Wait until at least one user asks specifically "do you have a multi-workstream example I can look at?" before building this.
- **A `scaffold.sh --workstreams "a,b,c"` flag** — deferred. Users who reach the multi-workstream mode either do it at kick-off (SKILL.md walks them through Step 2b) or as an existing-project upgrade (METHODOLOGY §3.5 enabling/upgrading procedure). The manual `cp STATUS.md STATUS_<workstream>.md` step is approximately 30 seconds. Adding a flag saves seconds but adds permanent maintenance surface — not worth it until there's evidence of repeated friction.
- **Renaming `STATUS_<workstream>.md` file naming convention** — deferred and likely permanent-defer. The file naming uses "workstream" because that's the structural noun. The *mode* is renamed to "Multi-workstream"; the *unit of work* stays "workstream" in file names. This keeps `git log` history continuous and avoids breaking existing projects' file names.

---

## [2.5.0] — 2026-05-18

Minor version bump. Adds first-class Chinese templates and a `--lang` flag for
`scaffold.sh`, so Chinese-documented projects can scaffold a fully Chinese
`brain/` and `CLAUDE.md`. Also promotes two field-tested improvements from real
project use into the methodology (`§1.4` and new `§1.4b`).

### Added

- **`templates-zh/` directory** mirroring `templates/` structure: Chinese versions of `CLAUDE.md` + `brain/{README,PROJECT,MAP,STATUS,DECISIONS,HANDOFF}.md` + `brain/topics/{,systems,operations,planning,feedback}/README.md` + `brain/handoffs/.gitkeep`. Placeholders remain `⚠️ TODO ⚠️` (cross-language; `doctor.sh` untouched).
- **`scripts/scaffold.sh --lang en|zh` flag**. Defaults to `en`. With `--lang zh`, `brain/` and `CLAUDE.md` are sourced from `templates-zh/`; the other three adapters (`.cursorrules`, `.github/copilot-instructions.md`, `AGENTS.md`) remain English regardless — they are consumed by AI tools, not humans, so the localization cost isn't worth the upkeep.
- **METHODOLOGY `§1.4` Step 1b — "Pick the scaffold level"**. New guidance for projects with nested sub-projects (monorepos, websites with sub-modules, multi-product workspaces): default to project-root `brain/`; promote a sub-project to its own `brain/` only when it really lives a separate life. Multi-level nesting (root + sub-project both have `brain/`) is explicitly out of v2 scope.
- **METHODOLOGY `§1.4b` — "Existing-material decomposition"**. New workflow for projects that already have 2–4 well-structured docs (e.g. `PLAN.md`, `ROADMAP.md`) but no `brain/` organization. Sits between `§1.4` (green-field) and `§1.5` (full migration). Includes explicit "AI may proceed with `git init` without asking" clause when the project has no version control yet.

### Changed

- `skills/project-brain/SKILL.md` `§1` kick-off step 3: mentions `--lang zh` for Chinese-documented projects.
- `README.md` and `README.zh-CN.md` Option B (manual scaffold) sections: document `--lang` usage and the rationale for not localizing non-Claude adapters.

### Why a minor version (not patch)

A new flag that changes `scaffold.sh` output is user-visible new functionality, not a bugfix. `2.4.x` patches kept scaffold output identical; `2.5.0` adds a new output mode.

### Maintainer notes — the `templates/` ↔ `templates-zh/` discipline

`templates/` and `templates-zh/` are **structure-locked**: section numbers, placeholder positions, table columns, document boundaries, and file lists must stay identical between the two. The only differences are language and the call-out conventions appropriate to that language's audience — nothing else.

**Invariant**: any structural change to `templates/` must be mirrored in `templates-zh/` in the same commit. Translation drift between the two breaks the guarantee that "scaffold language is purely a presentation choice."

If a future change adds a new file to `templates/brain/`, the same file must appear in `templates-zh/brain/` in the same PR. Future maintainers: when reviewing a PR that touches `templates/`, grep for the same path in `templates-zh/` and reject if missing.

### Triggered by

- **`templates-zh/` and `--lang`**: maintainers' real workflow (Chinese-language daily work, multiple projects in active use, 140+ stars) wanted a way to scaffold Chinese-language `brain/` without maintaining a private fork. Eliminates the dual-track drift risk between a public English plugin and a private Chinese maintainer's copy — by making both first-class outputs of the same source of truth.
- **`§1.4` Step 1b**: a website project's first kick-off (2026-04-25), v2's first real-project validation, surfaced the "do I scaffold at the website root or at a specific sub-module level?" question with no methodology guidance. The AI made an ad-hoc call ("website root"); the call was correct but had to be re-derived from first principles each time it came up.
- **`§1.4b`**: a macOS desktop app project (2026-05-02) didn't fit either `§1.4` (it already had `PLAN.md` + `ROADMAP.md` + an early `CLAUDE.md` — not green-field) or `§1.5` (no doc rot — those existing docs were well-structured, not unstructured). The hybrid path used to handle it (scaffold empty `brain/`, then map existing docs section-by-section into target files) wasn't in the methodology. Also surfaced "no git yet → AI should `git init` itself, not ask the user" as a workflow rule.

### Considered and deferred

- **Localizing `.cursorrules` / `AGENTS.md` / `.github/copilot-instructions.md` into Chinese versions** — deferred. These files are instruction inputs for AI tools, not human reading material. An English instruction file works equally well in any-language project. Adding Chinese versions would double maintenance with near-zero user-perceptible benefit.
- **A `--lang ja` / `--lang ko` / other languages** — deferred until there's evidence of real demand from non-English-non-Chinese users. The infrastructure (`templates-<lang>/` + `--lang` arg validation) supports it; adding a new language is a localization PR, not a methodology change.
- **Auto-detecting language from project locale / existing docs** — deferred. Pure prompt-driven heuristics are unreliable; an explicit flag is honest about what you're asking for. Auto-detection would also conflict with "user judgment is the trigger" from the v2 evolution story.

---

## [2.4.2] — 2026-05-07

Same-day point release. v2.4.1 surfaced the right release pipeline; v2.4.2 fixes
two real trigger-coverage bugs that would have caused Chinese-language users to
hit silent miss on `Startup` and `Handoff` workflows, and cleans up README
language consistency (English-only triggers in English README, Chinese-only in
zh-CN README).

### Fixed

- **`SKILL.md` `description` trigger (2) Startup was missing the Chinese variant**: the README (zh-CN) told users to say "继续这个项目" and the SKILL.md body table listed it, but the **`description` frontmatter field** — which is the only thing Claude Code's trigger matcher actually reads — did not contain it. So Chinese users saying "继续这个项目" could miss the skill entirely. Added it.
- **`SKILL.md` `description` trigger (3) Handoff was missing "切窗口"**: same pattern. The Chinese README listed "切窗口" alongside "压缩了" as a handoff trigger, but the `description` only had "压缩了". Chinese users saying "切窗口" could miss. Added it; also added it to the SKILL.md body table for symmetry.

### Changed

- **README.md and README.zh-CN.md Quick start trigger lists now language-pure**: previously both English and Chinese READMEs listed every trigger in both languages side-by-side ("set up project brain" / "建项目脑" — kick off a new brain). This is noise for the reader of either language alone. English README now lists only English triggers; Chinese README only Chinese. The SKILL.md description field still carries the full bilingual coverage (it's the matcher's source of truth).

### Maintainer notes — source-of-truth layering

Four places describe the same triggers, and they each serve a different audience. The layering is now:

| Layer | Audience | Content |
|---|---|---|
| `SKILL.md` `description` frontmatter | **Claude Code matcher** | Full bilingual coverage (English + Chinese for every trigger). The only place that affects runtime matching. |
| `SKILL.md` body table | Plugin maintainer reading the file | Full bilingual coverage (mirrors description for human readability). |
| `README.md` Quick start | English users discovering the plugin | English-only trigger list. |
| `README.zh-CN.md` Quick start | Chinese users discovering the plugin | Chinese-only trigger list. |

**Invariant**: every trigger that appears in either README must appear (in the same language) in `SKILL.md` description. Future trigger additions: update description first, then mirror in body table, then localize in the appropriate README.

### Triggered by

While preparing v2.4.1 community promotion, audit of the rendered English README on GitHub revealed Chinese trigger words mixed into the English Quick start. Investigating whether to strip them surfaced the deeper bug: not all README-advertised Chinese triggers actually exist in the `description` field. Three-layer audit caught two real silent-miss bugs.

### Considered and deferred

- **Adding more synonyms to each trigger** (e.g., "加载项目" / "项目接续" / "我先离开" / "睡了") — could broaden coverage, but expanding the trigger surface area without real-user evidence risks false-positive activation. Each addition should be triggered by a real "I said X and it didn't work" report. Defer to data.

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
