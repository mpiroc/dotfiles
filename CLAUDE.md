# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

A shared developer environment configuration repo that gets applied to GitHub Codespaces automatically and can also be installed locally. It manages Claude Code settings, shell aliases, and custom agents via symlinks into `~/.claude/`.

## Installation

```sh
./install.sh
```

This symlinks everything in `claude/` into `~/.claude/` and appends a source line to `~/.bashrc`/`~/.zshrc` for shell aliases. It is idempotent and backs up existing non-symlink files.

## Structure

- `claude/settings.json` -- Claude Code harness settings (symlinked to `~/.claude/settings.json`)
- `claude/CLAUDE.md` -- User-level identity and global instructions (symlinked to `~/.claude/CLAUDE.md`)
- `claude/statusline-command.sh` -- Custom statusline script (reads JSON from stdin, outputs ANSI-colored status)
- `claude/agents/` -- Custom agent definitions (each file symlinked individually to `~/.claude/agents/`)
- `shell/aliases.sh` -- Shell aliases/functions sourced by bash and zsh; must use POSIX-compatible syntax
- `install.sh` -- Installer script; uses `set -euo pipefail`

## Key constraints

- **Shell compatibility:** `shell/aliases.sh` must work in both bash and zsh. Use `[ ]` not `[[ ]]`, `command -v` not `which`, and POSIX function syntax (`name() { ... }`).
- **Functions returning values via stdout:** `_detect_package_manager` communicates its result via `echo`. Any side-effect output (e.g., `pnpm setup`) must be redirected to stderr (`>&2`) to avoid corrupting the return value in command substitutions.
- **Alias-to-function migration:** If converting an alias to a function, add `unalias <name> 2>/dev/null` before the function definition so re-sourcing doesn't fail when the old alias is still in the session.
- **Symlink model:** `install.sh` creates symlinks, not copies. Edits to files in this repo take effect immediately in `~/.claude/` without re-running the installer.
- **Idempotent installer:** `install.sh` checks before appending source lines and backs up existing files. It must remain safe to run repeatedly.
