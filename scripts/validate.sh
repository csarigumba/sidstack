#!/usr/bin/env bash
# Structural checks that hold on every agent platform, not just Claude Code:
# skills live at skills/<category>/<skill>/SKILL.md; frontmatter name == <skill>, description non-empty;
# every category folder is listed in plugin.json "skills" (unlisted = silently not loaded).
set -euo pipefail
cd "$(dirname "$0")/.."

fail=0
count=0
seen=""

for dir in skills/*/*/; do
  dir="${dir%/}"
  name="$(basename "$dir")"
  file="$dir/SKILL.md"
  count=$((count + 1))

  # Skill names are global in the plugin namespace, so two categories cannot share one.
  if printf '%s\n' "$seen" | grep -qx "$name"; then
    echo "DUPLICATE-NAME  $name appears in more than one category ($dir)"; fail=1
  fi
  seen="$seen
$name"

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

# Every category folder must be listed in plugin.json "skills", or Claude Code never loads it.
# A stray SKILL.md directly under skills/ (old flat layout) is also a mistake.
listed="$(jq -r '.skills[]' .claude-plugin/plugin.json | sed 's#^\./##; s#/$##')"
for cat in skills/*/; do
  cat="${cat%/}"
  if [ -f "$cat/SKILL.md" ]; then
    echo "FLAT-SKILL  $cat: move it into a category folder"; fail=1; continue
  fi
  printf '%s\n' "$listed" | grep -qx "$cat" || { echo "UNLISTED-CATEGORY  $cat: add \"./$cat/\" to plugin.json skills"; fail=1; }
done
while IFS= read -r cat; do
  [ -d "$cat" ] || { echo "MISSING-CATEGORY  plugin.json lists $cat but it does not exist"; fail=1; }
done <<< "$listed"

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

# Plugin subagents: agents/<name>.md with frontmatter name == filename stem; Claude Code skips a file
# with no name silently, and a mismatched name breaks every "sidstack:<name>" reference in the skills.
agent_count=0
for f in agents/*.md; do
  [ -e "$f" ] || continue
  agent_count=$((agent_count + 1))
  stem="$(basename "$f" .md)"
  if [ "$(head -n1 "$f")" != "---" ]; then
    echo "NO-FRONTMATTER  $f"; fail=1; continue
  fi
  afm="$(awk 'NR==1{next} /^---$/{exit} {print}' "$f")"
  a_name="$(printf '%s\n' "$afm" | sed -n 's/^name:[[:space:]]*//p' | head -n1 | tr -d '"'"'")"
  a_desc="$(printf '%s\n' "$afm" | sed -n 's/^description:[[:space:]]*//p' | head -n1)"
  [ "$a_name" = "$stem" ] || { echo "AGENT-NAME-MISMATCH  $f: frontmatter '$a_name' != file '$stem'"; fail=1; }
  [ -n "$a_desc" ] || { echo "AGENT-NO-DESCRIPTION  $f"; fail=1; }
done

if [ "$fail" -eq 0 ]; then
  echo "ok: $count skills, $agent_count agents, version $v_plugin, hooks executable, patterns valid"
fi
exit "$fail"
