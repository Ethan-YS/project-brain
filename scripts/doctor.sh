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
#   2. STATUS.md(_<workstream>.md) size — soft cap 80 lines or ~6,000 characters, whichever trips first (Trap 8)
#   3. ⚠️ TODO ⚠️ placeholder count per file
#   4. DECISIONS.md entries missing "Rejected alternatives" / "被拒绝的方案" (被否决的方案 etc. also accepted)
#   5. MAP.md §5 ↔ brain/topics/ file consistency
#   6. HANDOFF.md last-modified vs git log (stale HANDOFF without archive)
#   7. Markdown link integrity (relative links resolve; ASCII #anchors exist at target) — Trap 15. handoffs/ is skipped: archives are history (Trap 21)
#   8. Cross-brain sibling references (nested sub-brains must route shared facts via the parent brain) — Trap 16
#   9. Workstream registry ↔ STATUS_/HANDOFF_ files (multi-workstream projects)
#  10. Roster window names leaking into active STATUS / HANDOFF files — Trap 18 (concurrent mode)
#  11. HANDOFF shape — a current HANDOFF citing an archived one as still valid, or longer than its STATUS once past 40 lines (Traps 10 / 21)

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

# Characters, not bytes, whatever the locale: drop UTF-8 continuation bytes, count the rest (+1 per newline)
count_chars() { LC_ALL=C awk '{ gsub(/[\200-\277]/, ""); n += length($0) + 1 } END { print n + 0 }' "$1" 2>/dev/null || echo 0; }

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
# Check 2: STATUS size (soft cap 80 lines / ~6,000 characters — Trap 8)
# The line cap alone is gameable without anyone meaning to: struck-through
# items and history nested as sub-bullets keep the line count flat while the
# file turns into a log. Both measures are reported; whichever trips first.
# ─────────────────────────────────────────────────────────
echo "${BOLD}2. STATUS soft cap (80 lines / ~6,000 characters)${RESET}"
status_ok=true
for status_file in "$BRAIN"/STATUS*.md; do
  [[ -e "$status_file" ]] || continue
  lines=$(wc -l < "$status_file" | tr -d ' ')
  chars=$(count_chars "$status_file")
  basename_status=$(basename "$status_file")
  if (( lines > 80 )); then
    warning "$basename_status is $lines lines (soft cap 80) — settle stable content into MAP.md or DECISIONS.md, then overwrite"
    status_ok=false
  fi
  if (( chars > 6000 )); then
    warning "$basename_status is $chars characters (soft cap ~6,000) in $lines lines — long lines, struck-through items or nested history make a log, not a state; settle it, then overwrite (Trap 8)"
    status_ok=false
  fi
done
if $status_ok; then ok "all STATUS files within 80 lines / 6,000 characters"; fi
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
  # Use awk to find each entry heading and check if "Rejected alternatives" or its
  # zh label appears before the next entry or EOF. The zh template says 被拒绝的方案;
  # live brains also carry 被否决的方案 / 被否决的替代方案 — all four variants pass.
  # Recognized heading styles:
  #   ### YYYY-MM-DD ...        (v2 template default)
  #   ### DR-NNN / TD-NNN ...   (numbered-decision style)
  missing=$(awk '
    /^### ([0-9]{4}-[0-9]{2}-[0-9]{2}|(DR|TD)-[0-9]+)/ {
      if (in_entry && !found) {
        print title
      }
      in_entry = 1
      found = 0
      title = $0
      next
    }
    in_entry && /Rejected alternatives|被(拒绝|否决)的(替代)?方案/ {
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
      critical "DECISIONS entry missing 'Rejected alternatives' / '被拒绝的方案': $line"
    done <<< "$missing"
  else
    # Count actual entries (skip examples in comments)
    entry_count=$(grep -cE "^### ([0-9]{4}-|(DR|TD)-[0-9]+)" "$BRAIN/DECISIONS.md" 2>/dev/null | tr -d ' \n' || echo 0)
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

  # Lines that are placeholder / future mentions don't count as registrations
  map_lines=$(echo "$map_section" | grep -vE '待添加|TODO|TBD|⚠️')

  # Files registered in §5 — both backtick mentions and markdown-link targets
  # (CJK filenames and path-prefixed registrations like docs/foo.md included)
  registered=$( { echo "$map_lines" | grep -oE '`[^`]+\.md`' | tr -d '`'; \
                  echo "$map_lines" | grep -oE '\]\([^)#]+\.md\)' | sed -E 's/^\]\(//; s/\)$//; s/%20/ /g'; } | \
    sort -u | \
    grep -vE '(^|/)(PROJECT|MAP|STATUS|DECISIONS|HANDOFF|CLAUDE|SKILL|AGENTS)\.md$' | \
    grep -vE '(^|/)README\.md$' | \
    grep -vE '^(X|TODO|placeholder)\.md$')

  # Glob / brace registrations (round*.md, recheck-{a,b}.md) describe a set of
  # files, not one: set them aside as patterns, match topics/ files against them
  globs=$(echo "$registered" | grep -E '[*?{[]')
  registered=$(echo "$registered" | grep -vE '[*?{[]')
  matches_glob() {
    local fname="$1" pat
    [[ -z "$globs" ]] && return 1
    while IFS= read -r pat; do
      [[ -z "$pat" ]] && continue
      pat=$(basename "$pat" | sed -E 's/\{([^}]*)\}/@(\1)/g; s/,/|/g')
      shopt -s extglob
      # shellcheck disable=SC2053
      if [[ "$fname" == $pat ]]; then shopt -u extglob; return 0; fi
      shopt -u extglob
    done <<< "$globs"
    return 1
  }

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
    matches_glob "$fname" && continue
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

  # Files registered in MAP §5 but not on disk — absolute and ~/ registrations
  # (a file outside the repo, e.g. a neighbour's doc) are checked as written;
  # path-prefixed ones resolve against brain/, brain/topics/, and the project
  # root before falling back to a basename search inside topics/
  if [[ -n "$registered" ]]; then
    while IFS= read -r ref; do
      [[ -z "$ref" ]] && continue
      case "$ref" in
        /*|"~/"*)
          abs="$ref"; [[ "$ref" == "~/"* ]] && abs="$HOME/${ref#"~/"}"
          if [[ ! -e "$abs" ]]; then
            warning "MAP §5 references file not found: $ref"
            stale_count=$((stale_count + 1))
          fi
          continue
          ;;
      esac
      if [[ -e "$BRAIN/$ref" || -e "$BRAIN/topics/$ref" || -e "$TARGET/$ref" ]]; then
        continue
      fi
      fname=$(basename "$ref")
      if ! find "$BRAIN/topics" -type f -name "$fname" 2>/dev/null | grep -q .; then
        warning "MAP §5 references file not found: $ref"
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
  fresh_issues=0
  for handoff_file in "$BRAIN"/HANDOFF*.md; do
    [[ -e "$handoff_file" ]] || continue
    rel="${handoff_file#$TARGET/}"
    last_modified=$(git -C "$TARGET" log -1 --format=%ct -- "$rel" 2>/dev/null || echo "")
    if [[ -n "$last_modified" ]]; then
      now=$(date +%s)
      age_days=$(( (now - last_modified) / 86400 ))
      if (( age_days > 14 )); then
        info "$(basename "$handoff_file") is ${age_days} days old — if you've switched windows since, archive it to handoffs/<timestamp>.md"
        fresh_issues=$((fresh_issues+1))
      fi
    fi
  done
  # Per-check counter (v2.9): the old global test went silent whenever an earlier check had printed anything
  if (( fresh_issues == 0 )); then ok "HANDOFF status looks fresh"; fi
else
  info "no git history — skipping HANDOFF freshness check (the methodology assumes git, see Trap 13)"
fi
echo ""

# ─────────────────────────────────────────────────────────
# Shared helper: extract markdown link targets from a file,
# skipping fenced code blocks and HTML comments (template examples live there)
# ─────────────────────────────────────────────────────────
extract_links() {
  awk '
    in_comment { if (sub(/.*-->/, "")) { in_comment = 0 } else { next } }
    /^[[:space:]]*```/ { in_code = !in_code; next }
    in_code { next }
    {
      gsub(/<!--([^-]|-[^-]|--+[^->])*--+>/, "")
      if (match($0, /<!--/)) { $0 = substr($0, 1, RSTART - 1); in_comment = 1 }
      print
    }
  ' "$1" 2>/dev/null | grep -oE '\]\([^)]+\)' | sed -E 's/^\]\(//; s/\)$//; s/ "[^"]*"$//'
}

# ─────────────────────────────────────────────────────────
# Check 7: Markdown link integrity (Trap 15)
# ─────────────────────────────────────────────────────────
echo "${BOLD}7. Markdown link integrity${RESET}"
link_issues=0
while IFS= read -r -d '' file; do
  rel="${file#$TARGET/}"
  dir=$(dirname "$file")
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    case "$target" in
      http://*|https://*|mailto:*) continue ;;
      *xxx*|*XXX*|*⚠️*) continue ;;   # placeholder examples, not real links
    esac
    path="${target%%#*}"
    path="${path//%20/ }"
    frag=""
    [[ "$target" == *"#"* ]] && frag="${target#*#}"
    if [[ -z "$path" ]]; then
      resolved="$file"   # pure in-file anchor (#section)
    elif [[ "$path" = /* ]]; then
      info "absolute-path link in $rel: $target — breaks on other machines/clones; prefer relative"
      link_issues=$((link_issues+1))
      continue
    else
      resolved="$dir/$path"
    fi
    if [[ -n "$path" && ! -e "$resolved" ]]; then
      warning "dangling link in $rel: $target"
      link_issues=$((link_issues+1))
      continue
    fi
    # Anchor validation — ASCII anchors only (the methodology's anchor discipline:
    # lowercase-hyphen ids; non-ASCII fragments are renderer-dependent, skip them)
    if [[ -n "$frag" && "$resolved" == *.md && -f "$resolved" ]]; then
      if [[ "$frag" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
        if ! grep -qiE "<a[[:space:]]+id=[\"']${frag}[\"']" "$resolved"; then
          if ! grep -E '^#{1,6} ' "$resolved" | sed -E 's/^#{1,6} +//' | tr '[:upper:]' '[:lower:]' \
               | sed -E 's/[][(){}`*_:,."'"'"']//g; s/  +/ /g; s/^ //; s/ $//; s/ /-/g' \
               | grep -qxF "$frag"; then
            warning "anchor #$frag not found in ${resolved#$TARGET/} (linked from $rel) — prefer an explicit <a id=\"$frag\"></a>"
            link_issues=$((link_issues+1))
          fi
        fi
      fi
    fi
  done < <(extract_links "$file")
done < <(find "$BRAIN" -type d -name handoffs -prune -o -type f -name "*.md" -print0 2>/dev/null)
if (( link_issues == 0 )); then ok "all relative links and ASCII anchors resolve"; fi
# Archived handoffs were written at brain/ and moved by git mv, so their relative links break by construction.
# They are history that nothing current depends on (Trap 21) — not checked, not counted.
archived_n=$(find "$BRAIN/handoffs" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
if (( archived_n > 0 )); then echo "   (handoffs/ skipped: $archived_n archived handoff(s) — archives are history, links there aren't maintained)"; fi
echo ""

# ─────────────────────────────────────────────────────────
# Check 8: Cross-brain sibling references (Trap 16)
# ─────────────────────────────────────────────────────────
echo "${BOLD}8. Cross-brain references (nested sub-brains)${RESET}"
all_brains=()
while IFS= read -r -d '' b; do
  case "$b" in
    */node_modules/*|*/.git/*|*/templates/*|*/templates-zh/*|*/examples/*) continue ;;
  esac
  all_brains+=("$b")
done < <(find "$TARGET" -type d -name brain -print0 2>/dev/null)

if (( ${#all_brains[@]} <= 1 )); then
  ok "single brain/ — no cross-brain coupling possible"
else
  cross_issues=0
  for src_brain in "${all_brains[@]}"; do
    src_root=$(dirname "$src_brain")
    while IFS= read -r -d '' file; do
      rel="${file#$TARGET/}"
      dir=$(dirname "$file")
      while IFS= read -r target; do
        case "$target" in
          http://*|https://*|mailto:*|"#"*) continue ;;
          *xxx*|*XXX*|*⚠️*) continue ;;
        esac
        path="${target%%#*}"
        path="${path//%20/ }"
        [[ -z "$path" || "$path" = /* ]] && continue
        pdir=$(cd "$dir" 2>/dev/null && cd "$(dirname "$path")" 2>/dev/null && pwd)
        [[ -z "$pdir" ]] && continue
        resolved="$pdir/$(basename "$path")"
        [[ -e "$resolved" ]] || continue
        for dst_brain in "${all_brains[@]}"; do
          [[ "$dst_brain" == "$src_brain" ]] && continue
          case "$resolved" in
            "$dst_brain"/*)
              dst_root=$(dirname "$dst_brain")
              case "$src_root" in
                "$dst_root"/*) : ;;   # upward into an ancestor brain — allowed
                *)
                  case "$dst_root" in
                    "$src_root"/*) : ;;   # downward into a descendant brain — allowed
                    *)
                      warning "sibling-brain reference in $rel → ${resolved#$TARGET/} — route shared facts via the parent brain (Trap 16)"
                      cross_issues=$((cross_issues+1))
                      ;;
                  esac
                  ;;
              esac
              ;;
          esac
        done
      done < <(extract_links "$file")
    done < <(find "$src_brain" -type f -name "*.md" -print0 2>/dev/null)
  done
  if (( cross_issues == 0 )); then ok "${#all_brains[@]} brains found, no sibling-to-sibling data references"; fi
fi
echo ""

# ─────────────────────────────────────────────────────────
# MAP §6 workstream section (check 9) — a ## heading that mentions
# "Workstream" / "工作流", up to the next ## heading (### subsections stay
# inside). 工作流 also means "workflow", so when several headings match, the
# one whose body mentions STATUS_ files wins. Check 10 finds the roster by its
# column header instead (v2.9.2), so it doesn't depend on this heading.
# ─────────────────────────────────────────────────────────
ws_section() {
  [[ -f "$BRAIN/MAP.md" ]] || return 0
  awk '
    /^[[:space:]]*```/ { in_code = !in_code }
    /^## / && !in_code {
      cur = 0
      if ($0 ~ /[Ww]orkstream|工作流/) { n++; cur = n; body[n] = "" }
      next
    }
    cur { body[cur] = body[cur] $0 "\n"; if ($0 ~ /STATUS_/) hit[cur] = 1 }
    END {
      pick = 0
      for (i = 1; i <= n; i++) if (hit[i]) { pick = i; break }
      if (!pick && n) pick = 1
      if (pick) printf "%s", body[pick]
    }
  ' "$BRAIN/MAP.md" 2>/dev/null
}

# ─────────────────────────────────────────────────────────
# Check 9: Workstream registry ↔ files (multi-workstream only)
# ─────────────────────────────────────────────────────────
echo "${BOLD}9. Workstream registry ↔ files${RESET}"
ws_files=()
for f in "$BRAIN"/STATUS_*.md; do
  [[ -e "$f" ]] && ws_files+=("$f")
done
if (( ${#ws_files[@]} == 0 )); then
  ok "single-workstream project — nothing to check"
else
  section=$(ws_section)
  reg_issues=0
  if [[ -z "$section" ]]; then
    warning "multi-workstream project (${#ws_files[@]} STATUS_<workstream>.md files) but MAP.md has no workstream registry section (§6, METHODOLOGY §3.5)"
    reg_issues=$((reg_issues+1))
  else
    for f in "${ws_files[@]}"; do
      name=$(basename "$f"); ws="${name#STATUS_}"; ws="${ws%.md}"
      if ! grep -qF -- "$name" <<< "$section"; then
        warning "workstream '$ws' ($name) is not registered in MAP §6"
        reg_issues=$((reg_issues+1))
      fi
      if [[ ! -e "$BRAIN/HANDOFF_$ws.md" ]]; then
        info "no HANDOFF_$ws.md for workstream '$ws' — expected once its first window switches"
        reg_issues=$((reg_issues+1))
      fi
    done
    # Registered in §6 but missing on disk (placeholder and retired rows skipped)
    while IFS= read -r ref; do
      [[ -z "$ref" || -e "$BRAIN/$ref" ]] && continue
      warning "MAP §6 registers $ref but brain/$ref doesn't exist — if the workstream was retired, mark its row 'retired <date>'"
      reg_issues=$((reg_issues+1))
    done < <(grep -vE '⚠️|[Rr]etired|已结束|退役' <<< "$section" | grep -oE 'STATUS_[^`|)( ]+\.md' | grep -v '<' | sort -u)
  fi
  if (( reg_issues == 0 )); then ok "${#ws_files[@]} workstream(s), all registered in MAP §6 with their files"; fi
fi
echo ""

# ─────────────────────────────────────────────────────────
# Check 10: Window names outside the roster (Trap 18)
# Concurrent mode keeps current window names in one table — MAP §6
# "Who's on it now". A roster name showing up in an active STATUS / HANDOFF
# is either provenance (fine) or an address that goes stale at the next
# switch; the script can't tell which, so it reports info for a human glance.
# The roster is found by its "current window" column anywhere in MAP.md, not
# through ws_section: a single-workstream project with neighbours keeps a
# one-row roster under whatever its §6 is called ("## 6. 邻居项目" has no
# 工作流 in it). A cell wrapped in parentheses ("(unclaimed)", "（待认领）")
# is a placeholder, not a window name.
# ─────────────────────────────────────────────────────────
echo "${BOLD}10. Window names outside the roster (Trap 18)${RESET}"
roster_rows=$( [[ -f "$BRAIN/MAP.md" ]] && awk -F'|' '
  function clean(x) { gsub(/\*\*|`/, "", x); gsub(/^[ \t]+|[ \t]+$/, "", x); return x }
  /^[ \t]*```/ { in_code = !in_code; in_table = 0; wcol = 0; next }
  in_code { next }
  /^[ \t]*\|/ {
    if (!in_table) {                       # header row of a new table
      in_table = 1; wcol = 0
      for (i = 2; i < NF; i++) {
        h = tolower($i)
        if (h ~ /current window|现在的窗口|当前窗口|窗口名/) { wcol = i; print "@@roster@@"; break }
      }
      next
    }
    if ($0 ~ /^[ \t]*\|[-:| \t]+\|[ \t]*$/) next   # separator row
    if (wcol) {
      name = clean($wcol); ws = clean($2)
      if (name != "" && name !~ /⚠️/ && name !~ /^[-—–]+$/ && name !~ /^[0-9]+$/ && name !~ /^(\(|（).*(\)|）)$/ && name != ws) print name
    }
    next
  }
  { in_table = 0; wcol = 0 }
' "$BRAIN/MAP.md" 2>/dev/null)
roster=$(grep -vxF '@@roster@@' <<< "$roster_rows" | sort -u)
if [[ "$roster_rows" != *"@@roster@@"* ]]; then
  ok "no \"Who's on it now\" roster in MAP.md — nothing to check"
elif [[ -z "$roster" ]]; then
  ok "roster in MAP.md has no window claimed yet — nothing to check"
else
  leaks=0
  while IFS= read -r name; do
    [[ -z "$name" ]] && continue
    for f in "$BRAIN"/STATUS*.md "$BRAIN"/HANDOFF*.md; do
      [[ -e "$f" ]] || continue
      n=$(grep -cF -- "$name" "$f" 2>/dev/null | tr -d ' \n')
      if [[ "$n" =~ ^[0-9]+$ ]] && (( n > 0 )); then
        info "$(basename "$f") names current window '$name' on $n line(s) — name the workstream instead, unless it's provenance (Trap 18)"
        leaks=$((leaks+1))
      fi
    done
  done <<< "$roster"
  if (( leaks == 0 )); then ok "roster window names appear only in the roster"; fi
fi
echo ""

# ─────────────────────────────────────────────────────────
# Check 11: HANDOFF shape (Traps 10 / 21, v2.9)
#   a) a current HANDOFF citing an archived handoff as still valid — the chain the
#      next window has to walk; that content belongs in STATUS / RUNBOOK / DECISIONS
#   b) a current HANDOFF longer than the STATUS it bridges (and over 40 lines, so a
#      short pair never trips it) — a shift report carrying state, procedures or
#      rationale that have a home elsewhere; c) a HANDOFF with no STATUS beside it
# Both are info: the script can't read intent, only shape.
# ─────────────────────────────────────────────────────────
echo "${BOLD}11. HANDOFF shape (Traps 10 / 21)${RESET}"
shape_issues=0
for handoff_file in "$BRAIN"/HANDOFF*.md; do
  [[ -e "$handoff_file" ]] || continue
  hname=$(basename "$handoff_file")
  suffix="${hname#HANDOFF}"                 # ".md" or "_<workstream>.md"
  status_file="$BRAIN/STATUS$suffix"
  chain=$(grep -niE 'handoffs/|previous handoff|last handoff|上一份|上一班' "$handoff_file" 2>/dev/null \
          | grep -E 'still (valid|appl)|remain(s)? valid|仍然有效|仍有效|还有效|依然有效|去那里查|去那儿查|照旧有效' | head -3)
  if [[ -n "$chain" ]]; then
    info "$hname cites an archived handoff as still valid — move that content into STATUS / RUNBOOK / DECISIONS; archives are history (Trap 21):"
    while IFS= read -r l; do
      [[ -z "$l" ]] && continue
      printf '      line %s: …%s…\n' "${l%%:*}" "$(printf '%s' "${l#*:}" | awk '{ i = index($0, "handoffs/"); s = (i > 40) ? i - 40 : 1; print substr($0, s, 120) }')"
    done <<< "$chain"
    shape_issues=$((shape_issues+1))
  fi
  if [[ -f "$status_file" ]]; then
    hl=$(wc -l < "$handoff_file" | tr -d ' '); sl=$(wc -l < "$status_file" | tr -d ' ')
    if (( hl > 40 && hl > sl )); then
      info "$hname is $hl lines, $(basename "$status_file") is $sl — a shift report longer than the state it bridges usually carries content that belongs in STATUS or RUNBOOK (Trap 10)"
      shape_issues=$((shape_issues+1))
    fi
  else
    info "$hname has no $(basename "$status_file") beside it — a HANDOFF without its STATUS (multi-workstream: register the workstream in MAP §6, METHODOLOGY §3.5)"
    shape_issues=$((shape_issues+1))
  fi
done
if (( shape_issues == 0 )); then ok "current HANDOFF(s) cite no archive as current and are no longer than their STATUS"; fi
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
