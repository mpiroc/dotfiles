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

link "$DOTFILES_DIR/claude/settings.json"          "$CLAUDE_DIR/settings.json"
link "$DOTFILES_DIR/claude/CLAUDE.md"              "$CLAUDE_DIR/CLAUDE.md"
link "$DOTFILES_DIR/claude/statusline-command.sh"  "$CLAUDE_DIR/statusline-command.sh"

# Symlink each agent file individually so user-local agents are preserved.
for agent in "$DOTFILES_DIR/claude/agents/"*; do
  [ "$(basename "$agent")" = ".gitkeep" ] && continue
  [ -e "$agent" ] || continue
  link "$agent" "$CLAUDE_DIR/agents/$(basename "$agent")"
done

# Source shell aliases from shell profile files that exist.
ALIASES_SRC="$DOTFILES_DIR/shell/aliases.sh"
SOURCE_LINE=". \"$ALIASES_SRC\""

for rc in "$HOME/.bashrc" "$HOME/.zshrc"; do
  [ -f "$rc" ] || continue
  if ! grep -qF "$ALIASES_SRC" "$rc"; then
    printf '\n# dotfiles aliases\n%s\n' "$SOURCE_LINE" >> "$rc"
    echo "Added source line to $rc"
  else
    echo "Source line already in $rc"
  fi
done

echo "Done."
