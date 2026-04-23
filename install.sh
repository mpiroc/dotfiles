#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

mkdir -p "$CLAUDE_DIR"
mkdir -p "$CLAUDE_DIR/agents"
mkdir -p "$CLAUDE_DIR/skills"

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

# Symlink each skill directory individually so user-local skills are preserved.
for skill in "$DOTFILES_DIR/claude/skills/"*; do
  [ "$(basename "$skill")" = ".gitkeep" ] && continue
  [ -e "$skill" ] || continue
  link "$skill" "$CLAUDE_DIR/skills/$(basename "$skill")"
done

# Register a PAT-backed credential helper scoped to this repo only, so pushes
# to mpiroc/dotfiles from a Codespace work even when the default token can't
# write to it. Single quotes keep $DOTFILES_PAT literal so git expands it at
# credential-lookup time (not at install time).
#
# Two subtleties:
#   1. useHttpPath must be enabled at a scope that matches without a path
#      (host-only), otherwise git strips the path before matching and the
#      per-repo scope below never applies.
#   2. /etc/gitconfig in Codespaces unconditionally sets credential.helper to
#      the default Codespaces helper, which answers first and short-circuits
#      the chain. Setting helper to an empty string inside the per-repo scope
#      resets the list for this URL so only our helper runs.
git config --global --replace-all \
  'credential.https://github.com.useHttpPath' \
  'true'
git config --global --replace-all \
  'credential.https://github.com/mpiroc/dotfiles.helper' \
  ''
git config --global --add \
  'credential.https://github.com/mpiroc/dotfiles.helper' \
  '!f() { echo username=mpiroc; echo password=$DOTFILES_PAT; }; f'

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
