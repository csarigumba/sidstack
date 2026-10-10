#!/usr/bin/env bash
# Structural checks that hold on every agent platform, not just Claude Code:
# every skills/<dir>/SKILL.md has YAML frontmatter with name == <dir> and a non-empty description.
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
count=0

for dir in skills/*/; do
  dir="${dir%/}"
  name="$(basename "$dir")"
  file="$dir/SKILL.md"
  count=$((count + 1))

  if [ ! -f "$file" ]; then
    echo "MISSING  $file"; fail=1; continue
  fi
  if [ "$(head -n1 "$file")" != "---" ]; then
    echo "NO-FRONTMATTER  $file"; fail=1; continue
  fi

  fm="$(awk 'NR==1{next} /^---$/{exit} {print}' "$file")"
  fm_name="$(printf '%s\n' "$fm" | sed -n 's/^name:[[:space:]]*//p' | head -n1 | tr -d '"'"'")"
  fm_desc="$(printf '%s\n' "$fm" | sed -n 's/^description:[[:space:]]*//p' | head -n1)"

  if [ "$fm_name" != "$name" ]; then
    echo "NAME-MISMATCH  $file: frontmatter '$fm_name' != dir '$name'"; fail=1
  fi
  if [ -z "$fm_desc" ]; then
    echo "NO-DESCRIPTION  $file"; fail=1
  fi
  if ! printf '%s' "$name" | grep -Eq '^[a-z0-9]+(-[a-z0-9]+)*$'; then
    echo "BAD-NAME  $dir: use lowercase-kebab-case"; fail=1
  fi
done

# Manifest versions must agree, or one platform silently ships a stale build.
v_plugin="$(jq -r .version .claude-plugin/plugin.json)"
v_market="$(jq -r '.plugins[0].version' .claude-plugin/marketplace.json)"
if [ "$v_plugin" != "$v_market" ]; then
  echo "VERSION-DRIFT  plugin.json=$v_plugin marketplace.json=$v_market"; fail=1
fi

# Hook scripts run on every shell call; a non-executable one silently does nothing.
for f in hooks/*.sh; do
  [ -x "$f" ] || { echo "NOT-EXECUTABLE  $f"; fail=1; }
done
# Every denylist pattern must be a valid ERE, or the guard skips it without warning.
while IFS= read -r pattern || [ -n "$pattern" ]; do
  case "$pattern" in ''|\#*) continue ;; esac
  rc=0; printf 'x\n' | grep -qE -- "$pattern" 2>/dev/null || rc=$?
  [ "$rc" -le 1 ] || { echo "BAD-REGEX  $pattern"; fail=1; }
done < hooks/dangerous-patterns.txt

if [ "$fail" -eq 0 ]; then
  echo "ok: $count skills, version $v_plugin, hooks executable, patterns valid"
fi
exit "$fail"
