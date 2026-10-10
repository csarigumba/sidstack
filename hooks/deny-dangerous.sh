#!/bin/bash
# Dangerous-command guard. Blocks catastrophic shell commands before an agent runs them.
#
# Denylist: dangerous-patterns.txt next to this script (one ERE regex per line, # = comment).
# Override with SIDSTACK_DANGEROUS_PATTERNS=/path/to/file.
#
# Wired by:
#   Claude Code  hooks/hooks.json in this plugin        PreToolUse, matcher Bash
#   Codex        ~/.codex/hooks.json                    PreToolUse, matcher Bash
#   Any agent that passes hook JSON on stdin and honors exit 2 = block.
#
# stdin:  hook JSON. Command is read from .tool_input.command (Claude Code, Codex),
#         .toolInput.command, or .command.
# Block:  exit 2, reason on stderr. The agent sees the reason and must not retry.
# Allow:  exit 0, silent. Missing jq or missing patterns file = allow (fail open
#         rather than break every shell call).

export PATH="/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:$PATH"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PATTERNS_FILE="${SIDSTACK_DANGEROUS_PATTERNS:-$SCRIPT_DIR/dangerous-patterns.txt}"

command -v jq >/dev/null 2>&1 || exit 0

INPUT=$(cat)
CMD=$(printf '%s' "$INPUT" | jq -r '.tool_input.command // .toolInput.command // .command // empty' 2>/dev/null)

[ -z "$CMD" ] && exit 0
[ -f "$PATTERNS_FILE" ] || exit 0

while IFS= read -r pattern || [ -n "$pattern" ]; do
  case "$pattern" in ''|\#*) continue ;; esac
  if printf '%s\n' "$CMD" | grep -qE -- "$pattern" 2>/dev/null; then
    echo "Blocked by the sidstack dangerous-command guard ($PATTERNS_FILE). Matched pattern: $pattern. Do not retry it or work around the guard; explain the block to the user instead." >&2
    exit 2
  fi
done < "$PATTERNS_FILE"

exit 0
