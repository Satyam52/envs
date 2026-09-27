#!/usr/bin/env bash
# Install/sync skills from this repo into every harness location.
# Strategy: symlink (single source of truth stays in this repo).
# Sources:
#   skills/*            — owned snapshot-copies (personalize here)
#   vendor/*/skills/*   — third-party submodules (read-only, update via git submodule)
# Usage:
#   ./scripts/install.sh            # link all skills to all harnesses
#   ./scripts/install.sh --check     # verify links only
#   SKILLS="scientific-figure-making ponytail" ./scripts/install.sh
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_ROOT/skills"
SKILLS_FILTER="${SKILLS:-}"   # space-separated allowlist, empty = all
MODE="${1:---install}"

# Canonical discovery paths per harness (VS Code, Claude, Codex, Cursor all read .agents/skills).
TARGETS=(
  "$HOME/.agents/skills"
  "$HOME/.claude/skills"
  "$HOME/.cursor/skills"
  "$HOME/.copilot/skills"
  "$HOME/.codex/skills"
)

list_skills() {
  if [[ -n "$SKILLS_FILTER" ]]; then
    for s in $SKILLS_FILTER; do echo "$s"; done
  else
    # owned skills
    for d in "$SRC_DIR"/*/; do
      [[ -d "$d" ]] || continue
      basename "$d"
    done
    # vendored submodule skills (vendor/<repo>/skills/*)
    for d in "$REPO_ROOT"/vendor/*/skills/*/; do
      [[ -d "$d" ]] || continue
      basename "$d"
    done
  fi
}

# Resolve a skill name to its source dir (owned first, then vendor).
resolve_skill() {
  local skill="$1"
  if [[ -d "$SRC_DIR/$skill" ]]; then
    echo "$SRC_DIR/$skill"
    return 0
  fi
  local match
  match="$(find "$REPO_ROOT/vendor" -maxdepth 3 -type d -path "*/skills/$skill" 2>/dev/null | head -n 1)"
  if [[ -n "$match" ]]; then
    echo "$match"
    return 0
  fi
  return 1
}

check_skill() {
  local skill="$1" dir="$2"
  # agentskills.io: dir name must match `name:` in SKILL.md frontmatter
  local name
  name="$(awk '/^---/{c++; next} c==1 && /^name:/{sub(/^name:[[:space:]]*/,""); print; exit}' "$dir/SKILL.md")"
  if [[ "$name" != "$skill" ]]; then
    echo "ERROR: $dir/SKILL.md name '$name' != dir '$skill'" >&2
    return 1
  fi
}

install_skill() {
  local skill="$1" src="$2" target="$3"
  mkdir -p "$target"
  local link="$target/$skill"
  if [[ -L "$link" && "$(readlink "$link")" == "$src" ]]; then
    echo "ok   $link -> $src"
  elif [[ -e "$link" ]]; then
    echo "SKIP $link exists and is not our symlink (not touching)" >&2
  else
    ln -s "$src" "$link"
    echo "link $link -> $src"
  fi
}

fail=0
for skill in $(list_skills); do
  src="$(resolve_skill "$skill" || true)"
  if [[ -z "${src:-}" || ! -f "$src/SKILL.md" ]]; then
    echo "ERROR: skill '$skill' has no SKILL.md (owned or vendor)" >&2; fail=1; continue
  fi
  check_skill "$skill" "$src" || fail=1
  if [[ "$MODE" == "--check" ]]; then
    for t in "${TARGETS[@]}"; do
      if [[ -L "$t/$skill" && "$(readlink "$t/$skill")" == "$src" ]]; then
        echo "ok   $t/$skill"
      else
        echo "MISS $t/$skill" >&2; fail=1
      fi
    done
  else
    for t in "${TARGETS[@]}"; do install_skill "$skill" "$src" "$t"; done
  fi
done

# Repo-local discovery: .agents/skills and .claude/skills aliases so any
# checkout works without install (Codex/Cursor/Copilot read these in-repo).
if [[ "$MODE" != "--check" ]]; then
  mkdir -p "$REPO_ROOT/.agents" "$REPO_ROOT/.claude"
  for alias in "$REPO_ROOT/.agents/skills" "$REPO_ROOT/.claude/skills"; do
    if [[ ! -e "$alias" ]]; then
      ln -s "../skills" "$alias"
      echo "link $alias -> ../skills"
    fi
  done
fi

exit "$fail"
