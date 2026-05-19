#!/usr/bin/env bash
#
# project-brain scaffold script
# Mechanically copies templates into a target project root.
# No judgment logic — by design.
#
# Usage:
#   ./scripts/scaffold.sh                          # scaffold into current directory (English)
#   ./scripts/scaffold.sh /path/to/your/project    # scaffold into the specified directory
#   ./scripts/scaffold.sh --tools claude,cursor    # only copy specific adapters
#   ./scripts/scaffold.sh --lang zh                # use Chinese templates for brain/ + CLAUDE.md
#
# Adapters available:
#   claude    → CLAUDE.md (Claude Code)
#   cursor    → .cursorrules (Cursor)
#   copilot   → .github/copilot-instructions.md (GitHub Copilot Chat)
#   agents    → AGENTS.md (Codex CLI, Aider, etc., AGENTS.md convention)
#
# Default: all four adapters are copied.
#
# Languages:
#   en (default)  → templates/        — English brain/ + CLAUDE.md
#   zh            → templates-zh/     — Chinese brain/ + CLAUDE.md
#
# The other three adapters (.cursorrules / .github/copilot-instructions.md / AGENTS.md)
# remain English regardless of --lang — they are consumed by AI tools, not by humans,
# and an English instruction file works equally well in any-language project.

set -euo pipefail

# Resolve script + repo paths (so this works no matter where you run it from)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES="$REPO_ROOT/templates"
TEMPLATES_ZH="$REPO_ROOT/templates-zh"

# Parse args
TARGET="."
TOOLS="claude,cursor,copilot,agents"
LANG_OPT="en"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tools)
      TOOLS="$2"
      shift 2
      ;;
    --lang)
      LANG_OPT="$2"
      shift 2
      ;;
    --help|-h)
      grep '^#' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *)
      TARGET="$1"
      shift
      ;;
  esac
done

# Validate --lang
case "$LANG_OPT" in
  en|zh) ;;
  *)
    echo "❌ Unknown --lang value: $LANG_OPT (supported: en, zh)" >&2
    exit 1
    ;;
esac

# Pick source paths for brain/ and CLAUDE.md based on language
# Other adapters always come from English templates/ (read by AI tools, not humans).
if [[ "$LANG_OPT" == "zh" ]]; then
  if [[ ! -d "$TEMPLATES_ZH" ]]; then
    echo "❌ Chinese templates not found at $TEMPLATES_ZH" >&2
    exit 1
  fi
  BRAIN_SOURCE="$TEMPLATES_ZH/brain"
  CLAUDE_SOURCE="$TEMPLATES_ZH/CLAUDE.md"
else
  BRAIN_SOURCE="$TEMPLATES/brain"
  CLAUDE_SOURCE="$TEMPLATES/CLAUDE.md"
fi

# Resolve absolute target path
TARGET="$(cd "$TARGET" 2>/dev/null && pwd || (mkdir -p "$TARGET" && cd "$TARGET" && pwd))"

echo "📂 project-brain scaffold"
echo "   Source:    $REPO_ROOT"
echo "   Target:    $TARGET"
echo "   Tools:     $TOOLS"
echo "   Language:  $LANG_OPT"
echo ""

# Copy brain/ folder (always)
if [[ -d "$TARGET/brain" ]]; then
  echo "⚠️  $TARGET/brain already exists — skipping (rename or remove first if you want a fresh scaffold)"
else
  cp -r "$BRAIN_SOURCE" "$TARGET/brain"
  echo "✅ brain/ copied ($LANG_OPT)"
fi

# Copy adapters
IFS=',' read -ra TOOL_LIST <<< "$TOOLS"
for tool in "${TOOL_LIST[@]}"; do
  case "$tool" in
    claude)
      if [[ -f "$TARGET/CLAUDE.md" ]]; then
        echo "⚠️  CLAUDE.md exists — skipping"
      else
        cp "$CLAUDE_SOURCE" "$TARGET/CLAUDE.md"
        echo "✅ CLAUDE.md copied (Claude Code, $LANG_OPT)"
      fi
      ;;
    cursor)
      if [[ -f "$TARGET/.cursorrules" ]]; then
        echo "⚠️  .cursorrules exists — skipping"
      else
        cp "$TEMPLATES/.cursorrules" "$TARGET/.cursorrules"
        echo "✅ .cursorrules copied (Cursor)"
      fi
      ;;
    copilot)
      if [[ -f "$TARGET/.github/copilot-instructions.md" ]]; then
        echo "⚠️  .github/copilot-instructions.md exists — skipping"
      else
        mkdir -p "$TARGET/.github"
        cp "$TEMPLATES/.github/copilot-instructions.md" "$TARGET/.github/copilot-instructions.md"
        echo "✅ .github/copilot-instructions.md copied (GitHub Copilot Chat)"
      fi
      ;;
    agents)
      if [[ -f "$TARGET/AGENTS.md" ]]; then
        echo "⚠️  AGENTS.md exists — skipping"
      else
        cp "$TEMPLATES/AGENTS.md" "$TARGET/AGENTS.md"
        echo "✅ AGENTS.md copied (Codex CLI / AGENTS.md convention)"
      fi
      ;;
    *)
      echo "⚠️  Unknown tool: $tool (skipping)"
      ;;
  esac
done

echo ""
echo "🌱 Done. Next steps:"
echo "   1. cd $TARGET"
echo "   2. Fill in brain/PROJECT.md (one-line definition + what you explicitly DON'T do)"
echo "   3. grep -rn '⚠️ TODO ⚠️' brain/   # walk through placeholders"
echo "   4. Make 'establishing project-brain' the first DECISIONS entry"
echo ""
echo "Full methodology: https://github.com/Ethan-YS/project-brain/blob/main/METHODOLOGY.md"
