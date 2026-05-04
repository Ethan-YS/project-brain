#!/usr/bin/env bash
#
# project-brain scaffold script
# Mechanically copies templates into a target project root.
# No judgment logic — by design.
#
# Usage:
#   ./scripts/scaffold.sh                          # scaffold into current directory
#   ./scripts/scaffold.sh /path/to/your/project    # scaffold into the specified directory
#   ./scripts/scaffold.sh --tools claude,cursor    # only copy specific adapters
#
# Adapters available:
#   claude    → CLAUDE.md (Claude Code)
#   cursor    → .cursorrules (Cursor)
#   copilot   → .github/copilot-instructions.md (GitHub Copilot Chat)
#   agents    → AGENTS.md (Codex CLI, Aider, etc., AGENTS.md convention)
#
# Default: all four adapters are copied.

set -euo pipefail

# Resolve script + repo paths (so this works no matter where you run it from)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"
TEMPLATES="$REPO_ROOT/templates"

# Parse args
TARGET="."
TOOLS="claude,cursor,copilot,agents"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --tools)
      TOOLS="$2"
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

# Resolve absolute target path
TARGET="$(cd "$TARGET" 2>/dev/null && pwd || (mkdir -p "$TARGET" && cd "$TARGET" && pwd))"

echo "📂 project-brain scaffold"
echo "   Source:  $REPO_ROOT"
echo "   Target:  $TARGET"
echo "   Tools:   $TOOLS"
echo ""

# Copy brain/ folder (always)
if [[ -d "$TARGET/brain" ]]; then
  echo "⚠️  $TARGET/brain already exists — skipping (rename or remove first if you want a fresh scaffold)"
else
  cp -r "$TEMPLATES/brain" "$TARGET/brain"
  echo "✅ brain/ copied"
fi

# Copy adapters
IFS=',' read -ra TOOL_LIST <<< "$TOOLS"
for tool in "${TOOL_LIST[@]}"; do
  case "$tool" in
    claude)
      if [[ -f "$TARGET/CLAUDE.md" ]]; then
        echo "⚠️  CLAUDE.md exists — skipping"
      else
        cp "$TEMPLATES/CLAUDE.md" "$TARGET/CLAUDE.md"
        echo "✅ CLAUDE.md copied (Claude Code)"
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
