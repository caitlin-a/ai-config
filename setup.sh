#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
CURSOR_DIR="$HOME/.cursor"

blue()   { printf '\033[34m%s\033[0m\n' "$*"; }
yellow() { printf '\033[33m%s\033[0m\n' "$*"; }

link() {
    local src="$1"
    local dst="$2"

    if [[ ! -e "$src" ]]; then
        yellow "skip: $src does not exist"
        return
    fi

    mkdir -p "$(dirname "$dst")"

    if [[ -L "$dst" ]]; then
        rm "$dst"
    elif [[ -e "$dst" ]]; then
        yellow "warn: $dst already exists and is not a symlink — skipping (move it out of the way first)"
        return
    fi

    ln -s "$src" "$dst"
    blue "linked: $dst -> $src"
}

# Rename CLAUDE.personal.md -> AGENTS.personal.md if the old name still exists
if [[ -f "$CLAUDE_DIR/CLAUDE.personal.md" && ! -f "$CLAUDE_DIR/AGENTS.personal.md" ]]; then
    mv "$CLAUDE_DIR/CLAUDE.personal.md" "$CLAUDE_DIR/AGENTS.personal.md"
    blue "renamed: CLAUDE.personal.md -> AGENTS.personal.md"
fi

# Claude
link "$REPO/CLAUDE.md"     "$CLAUDE_DIR/CLAUDE.md"
link "$REPO/AGENTS.md"     "$CLAUDE_DIR/AGENTS.md"
link "$REPO/settings.json" "$CLAUDE_DIR/settings.json"
link "$REPO/rules"         "$CLAUDE_DIR/rules"

# Cursor: link each skill's SKILL.md to ~/.cursor/commands/<name>.md
if [[ -d "$REPO/skills" ]]; then
    for skill_dir in "$REPO/skills"/*/; do
        [[ -d "$skill_dir" ]] || continue
        skill_name="$(basename "$skill_dir")"
        skill_file="$skill_dir/SKILL.md"
        if [[ -f "$skill_file" ]]; then
            link "$skill_file" "$CURSOR_DIR/commands/$skill_name.md"
        fi
    done
fi

blue "ai-config setup complete."
