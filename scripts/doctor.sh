#!/usr/bin/env bash
#
# project-brain doctor — structural health check
#
# Runs read-only checks against a project's brain/ folder. Reports issues but
# never modifies anything and never decides what should be fixed — that's still
# the user's call. Aligns with the methodology's "AI proposes, user decides"
# principle.
#
# Usage:
#   ./scripts/doctor.sh                           # check current directory
#   ./scripts/doctor.sh /path/to/your/project     # check specified directory
#
# Exit codes:
#   0  — no critical issues (warnings/info still printed)
#   1  — critical issues found (missing core files, decisions without rejected alternatives, etc.)
#
# Checks performed:
#   1. brain/ directory structure (required core files exist)
#   2. STATUS.md(_<workstream>.md) line count (soft cap 80)
#   3. ⚠️ TODO ⚠️ placeholder count per file
#   4. DECISIONS.md entries missing "Rejected alternatives" / "被否决"
#   5. MAP.md §5 ↔ brain/topics/ file consistency
#   6. HANDOFF.md last-modified vs git log (stale HANDOFF without archive)

set -o pipefail

# Colors (only if stdout is a terminal)
if [[ -t 1 ]]; then
  RED=$'\033[0;31m'
  YELLOW=$'\033[0;33m'
  CYAN=$'\033[0;36m'
  GREEN=$'\033[0;32m'
  BOLD=$'\033[1m'
  RESET=$'\033[0m'
else
  RED="" YELLOW="" CYAN="" GREEN="" BOLD="" RESET=""
fi

# Counters
CRITICAL=0
WARNINGS=0
INFO=0

# Helpers
critical() { echo "${RED}❌ ${1}${RESET}"; CRITICAL=$((CRITICAL+1)); }
warning()  { echo "${YELLOW}⚠️  ${1}${RESET}"; WARNINGS=$((WARNINGS+1)); }
info()     { echo "${CYAN}ℹ️  ${1}${RESET}"; INFO=$((INFO+1)); }
ok()       { echo "${GREEN}✅ ${1}${RESET}"; }

# Resolve target
TARGET="${1:-.}"
TARGET="$(cd "$TARGET" 2>/dev/null && pwd || echo "")"
if [[ -z "$TARGET" || ! -d "$TARGET" ]]; then
  echo "${RED}error:${RESET} target directory not found: ${1:-.}"
  exit 2
fi

BRAIN="$TARGET/brain"
echo "${BOLD}🩺 project-brain doctor${RESET}"
echo "   Target: $TARGET"
echo ""

# ─────────────────────────────────────────────────────────
# Check 1: brain/ structure
# ─────────────────────────────────────────────────────────
echo "${BOLD}1. brain/ structure${RESET}"

if [[ ! -d "$BRAIN" ]]; then
  critical "no brain/ folder found at $BRAIN — run scripts/scaffold.sh first"
  echo ""
  exit 1
fi

# Required files (single-workstream OR multi-workstream)
required_shared=(PROJECT.md MAP.md DECISIONS.md)
for f in "${required_shared[@]}"; do
  [[ -f "$BRAIN/$f" ]] || critical "missing required file: brain/$f"
done

# STATUS / HANDOFF: either default (single-workstream) OR _<workstream> (multi)
status_files=("$BRAIN"/STATUS*.md)
handoff_files=("$BRAIN"/HANDOFF*.md)

if [[ ! -e "${status_files[0]}" ]]; then
  critical "no STATUS.md or STATUS_<workstream>.md found"
fi

# topics/ existence (recommended but not strictly required)
[[ -d "$BRAIN/topics" ]] || warning "no brain/topics/ folder — topic-layer docs will have nowhere to live"

if (( CRITICAL == 0 )); then ok "core structure intact"; fi
echo ""

# ─────────────────────────────────────────────────────────
# Check 2: STATUS line count (soft cap 80)
# ─────────────────────────────────────────────────────────
echo "${BOLD}2. STATUS soft cap (80 lines)${RESET}"
status_ok=true
for status_file in "$BRAIN"/STATUS*.md; do
  [[ -e "$status_file" ]] || continue
  lines=$(wc -l < "$status_file" | tr -d ' ')
  basename_status=$(basename "$status_file")
  if (( lines > 80 )); then
    warning "$basename_status is $lines lines (soft cap 80) — settle stable content into MAP.md or DECISIONS.md, then overwrite"
    status_ok=false
  fi
done
if $status_ok; then ok "all STATUS files within 80 lines"; fi
echo ""

# ─────────────────────────────────────────────────────────
# Check 3: ⚠️ TODO ⚠️ placeholders
# ─────────────────────────────────────────────────────────
echo "${BOLD}3. ⚠️ TODO ⚠️ placeholders${RESET}"
todo_total=0
while IFS= read -r -d '' file; do
  count=$(grep -c "⚠️ TODO ⚠️" "$file" 2>/dev/null | tr -d ' \n' || echo 0)
  count=${count:-0}
  if [[ "$count" =~ ^[0-9]+$ ]] && (( count > 0 )); then
    todo_total=$((todo_total + count))
    rel="${file#$TARGET/}"
    # PROJECT.md TODOs are usually mandatory; others may be intentional
    if [[ "$file" == "$BRAIN/PROJECT.md" ]]; then
      warning "$rel still has $count placeholder(s) — was that intentional?"
    else
      info "$rel has $count placeholder(s) (may be intentional if the field has no content yet)"
    fi
  fi
done < <(find "$BRAIN" -type f -name "*.md" -print0 2>/dev/null)
if (( todo_total == 0 )); then ok "no ⚠️ TODO ⚠️ placeholders remaining"; fi
echo ""

# ─────────────────────────────────────────────────────────
# Check 4: DECISIONS missing "Rejected alternatives"
# ─────────────────────────────────────────────────────────
echo "${BOLD}4. DECISIONS entries integrity${RESET}"
if [[ -f "$BRAIN/DECISIONS.md" ]]; then
  # Use awk to find each ### YYYY-MM-DD entry and check if "Rejected alternatives" or "被否决" appears before next ### or EOF
  missing=$(awk '
    /^### [0-9]{4}-[0-9]{2}-[0-9]{2}/ {
      if (in_entry && !found) {
        print title
      }
      in_entry = 1
      found = 0
      title = $0
      next
    }
    in_entry && /Rejected alternatives|被否决的方案|被否决的替代方案/ {
      found = 1
    }
    END {
      if (in_entry && !found) {
        print title
      }
    }
  ' "$BRAIN/DECISIONS.md")

  if [[ -n "$missing" ]]; then
    while IFS= read -r line; do
      critical "DECISIONS entry missing 'Rejected alternatives': $line"
    done <<< "$missing"
  else
    # Count actual entries (skip examples in comments)
    entry_count=$(grep -c "^### [0-9]\{4\}-" "$BRAIN/DECISIONS.md" 2>/dev/null | tr -d ' \n' || echo 0)
    entry_count=${entry_count:-0}
    if [[ ! "$entry_count" =~ ^[0-9]+$ ]] || (( entry_count == 0 )); then
      info "DECISIONS.md has no entries yet — append your first real decision"
    else
      ok "$entry_count entry/entries, all include 'Rejected alternatives'"
    fi
  fi
else
  critical "missing brain/DECISIONS.md"
fi
echo ""

# ─────────────────────────────────────────────────────────
# Check 5: MAP §5 ↔ topics/ files
# ─────────────────────────────────────────────────────────
echo "${BOLD}5. MAP §5 ↔ topics/ consistency${RESET}"
if [[ -f "$BRAIN/MAP.md" && -d "$BRAIN/topics" ]]; then
  # Find the §5 (topics index) section: starts at a heading mentioning "topics" / "专题",
  # ends at the next ## heading. We look specifically for the "topics" section header.
  map_section=$(awk '
    /^## .*([Tt]opic[s]?|[Pp]rofile[s]?|[Pp]rofessional|专题|topics\/|topics docs)/ { in_topics=1; next }
    /^## / && in_topics { in_topics=0 }
    in_topics { print }
  ' "$BRAIN/MAP.md" 2>/dev/null)

  # Files registered in §5 (any .md filename inside backticks)
  # Filter out: placeholders (⚠️ TODO ⚠️), the 5 core continuity files, common skeleton tokens
  registered=$(echo "$map_section" | grep -oE '`[A-Za-z0-9_./-]+\.md`' | tr -d '`' | sort -u | \
    grep -vE '^(PROJECT|MAP|STATUS|DECISIONS|HANDOFF|README|CLAUDE|SKILL|AGENTS)\.md$' | \
    grep -vE '^(X|TODO|placeholder)\.md$')

  # Files actually existing in topics/ (excluding READMEs which are descriptive, not registered)
  actual_files=()
  while IFS= read -r f; do
    actual_files+=("$f")
  done < <(find "$BRAIN/topics" -type f -name "*.md" ! -name "README.md" 2>/dev/null)

  unregistered_count=0
  stale_count=0

  # Files in topics/ but not registered in MAP §5
  for file_path in "${actual_files[@]}"; do
    fname=$(basename "$file_path")
    if [[ -n "$registered" ]] && ! echo "$registered" | grep -qF "$fname"; then
      rel="${file_path#$BRAIN/}"
      info "topics/ file not registered in MAP §5: $rel"
      unregistered_count=$((unregistered_count + 1))
    elif [[ -z "$registered" ]]; then
      rel="${file_path#$BRAIN/}"
      info "topics/ file not registered in MAP §5: $rel"
      unregistered_count=$((unregistered_count + 1))
    fi
  done

  # Files registered in MAP §5 but not on disk
  if [[ -n "$registered" ]]; then
    while IFS= read -r ref; do
      [[ -z "$ref" ]] && continue
      fname=$(basename "$ref")
      if ! find "$BRAIN/topics" -type f -name "$fname" 2>/dev/null | grep -q .; then
        warning "MAP §5 references file not found in topics/: $fname"
        stale_count=$((stale_count + 1))
      fi
    done <<< "$registered"
  fi

  if (( unregistered_count == 0 && stale_count == 0 )); then
    ok "MAP §5 and topics/ in sync"
  fi
else
  [[ -f "$BRAIN/MAP.md" ]] || critical "missing brain/MAP.md"
  [[ -d "$BRAIN/topics" ]] || info "no brain/topics/ — skipping consistency check"
fi
echo ""

# ─────────────────────────────────────────────────────────
# Check 6: HANDOFF freshness vs archival
# ─────────────────────────────────────────────────────────
echo "${BOLD}6. HANDOFF freshness${RESET}"
if [[ -d "$TARGET/.git" ]]; then
  for handoff_file in "$BRAIN"/HANDOFF*.md; do
    [[ -e "$handoff_file" ]] || continue
    rel="${handoff_file#$TARGET/}"
    last_modified=$(git -C "$TARGET" log -1 --format=%ct -- "$rel" 2>/dev/null || echo "")
    if [[ -n "$last_modified" ]]; then
      now=$(date +%s)
      age_days=$(( (now - last_modified) / 86400 ))
      if (( age_days > 14 )); then
        info "$(basename "$handoff_file") is ${age_days} days old — if you've switched windows since, archive it to handoffs/<timestamp>.md"
      fi
    fi
  done
  if (( INFO == 0 && WARNINGS == 0 && CRITICAL == 0 )); then
    ok "HANDOFF status looks fresh"
  fi
else
  info "no git history — skipping HANDOFF freshness check (the methodology assumes git, see Trap 13)"
fi
echo ""

# ─────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────
echo "${BOLD}Summary${RESET}"
total=$((CRITICAL + WARNINGS + INFO))
if (( total == 0 )); then
  echo "${GREEN}🌱 All checks passed.${RESET}"
  exit 0
elif (( CRITICAL == 0 )); then
  echo "$total observation(s): ${YELLOW}$WARNINGS warning(s)${RESET}, ${CYAN}$INFO info${RESET}"
  exit 0
else
  echo "$total issue(s): ${RED}$CRITICAL critical${RESET}, ${YELLOW}$WARNINGS warning(s)${RESET}, ${CYAN}$INFO info${RESET}"
  exit 1
fi
