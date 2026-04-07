#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/agents"

# Symlink a file, backing up any existing non-symlink target.
link() {
  local src="$1" dst="$2"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    echo "Backing up $dst → ${dst}.backup"
    mv "$dst" "${dst}.backup"
  fi
  ln -sf "$src" "$dst"
  echo "Linked $dst → $src"
}

link "$DOTFILES_DIR/claude/settings.json" "$CLAUDE_DIR/settings.json"
link "$DOTFILES_DIR/claude/CLAUDE.md"     "$CLAUDE_DIR/CLAUDE.md"

# Symlink each agent file individually so user-local agents are preserved.
for agent in "$DOTFILES_DIR/claude/agents/"*; do
  [ "$(basename "$agent")" = ".gitkeep" ] && continue
  [ -e "$agent" ] || continue
  link "$agent" "$CLAUDE_DIR/agents/$(basename "$agent")"
done

echo "Done."
