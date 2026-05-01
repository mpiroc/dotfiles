# dotfiles

Shared developer environment configuration, including [Claude Code](https://docs.anthropic.com/en/docs/claude-code) settings, shell aliases, and custom agents.

## What's included

- **`claude/`** -- Claude Code configuration (settings, agents, skills, statusline, `CLAUDE.md`)
- **`claude/memory/`** -- Per-project memories (`MEMORY.md`, `feedback_*.md`, etc.) symlinked into `~/.claude/projects/<slug>/memory/` so they sync across machines while session jsonls and other machine-local state stay put
- **`shell/aliases.sh`** -- Shell aliases and functions (works in both bash and zsh)
- **`install.sh`** -- Symlinks config into `~/.claude/` and sources aliases from your shell profile

### Aliases

#### `ucs` -- [U]pdate [C]ode[S]pace

```sh
ucs
```

Updates the Codespace with the latest dotfiles configuration:

1. Switches to (or creates) a per-machine branch — `codespace/$CODESPACE_NAME` in Codespaces, `machine/$(hostname)` elsewhere.
2. Fetches `origin/main` and rebases the per-machine branch on top.
3. Syncs local project memory dirs into the repo. **Seeds** any slug that's still a real directory on this machine and not yet tracked (moves it into `claude/memory/<slug>/`, replaces the live path with a symlink). **Merges** local content into already-tracked slugs: union-merges `MEMORY.md`, copies non-conflicting files into the repo, and prints `ucs: conflict for <slug>/<file>` for any non-`MEMORY.md` file that exists on both sides with different content (left as-is for manual resolution). The recovery case where `memory` is already a symlink but `memory.backup/` still has unmerged content is handled the same way.
4. Force-with-lease pushes the per-machine branch.
5. Re-runs `install.sh` and reloads the shell.

Per-machine branches keep memory edits from different machines from fighting on a shared branch. To promote your machine's changes to `main`, open a PR from your `codespace/...` branch — `ucs` itself only handles the local sync direction.

`MEMORY.md` files use the built-in `union` merge driver (configured in `.gitattributes`), so two machines adding different bullets to the same MEMORY.md auto-merge instead of producing conflict markers.

**Local edits are preserved.** `ucs` auto-stashes the working tree before the rebase and pops it back afterward. Memory-file dirt (typically a Claude session writing through the `~/.claude/projects/<slug>/memory` symlinks) is then staged and committed by step 3; non-memory dirt stays in the working tree exactly where it was. On rebase conflicts, leaves you in the dotfiles dir mid-rebase — resolve, `git rebase --continue`, then `git stash pop` to restore your edits, then re-run `ucs`. On stash-pop conflicts, resolve in place, `git stash drop` when done, then re-run.

#### `ucc` -- [U]pdate [C]laude [C]ode

Intended to be run at the start of a work day. Pulls the latest changes, installs local dependencies (if a `package.json` is present), and updates Claude Code to the latest version globally. Automatically detects the package manager from lockfiles (`pnpm-lock.yaml` or `package-lock.json`), defaulting to pnpm with npm as a fallback.

```sh
ucc
```

## Getting started

1. **Fork** this repo to your personal GitHub account (not an organization).

2. Go to [github.com/settings/codespaces](https://github.com/settings/codespaces) (Profile picture > **Settings** > **Codespaces**).

3. Under **Dotfiles**, check **Automatically install dotfiles**:

   ![Dotfiles section with the checkbox cleared](https://docs.github.com/assets/images/help/codespaces/install-custom-dotfiles.png)

4. Select your fork of this repo from the dropdown:

   ![Automatically install dotfiles selected with a repo chosen](https://docs.github.com/assets/images/help/codespaces/select-dotfiles-repo.png)

> **Note:** Only Codespaces created **after** configuring these settings will have access to the dotfiles repo. Existing Codespaces are not affected.

For more details, see [Personalizing GitHub Codespaces for your account](https://docs.github.com/en/codespaces/setting-your-user-preferences/personalizing-github-codespaces-for-your-account).

## Updating

To pull the latest dotfiles changes into an existing Codespace, run:

```sh
ucs
```

This pulls the latest version of the repo, re-runs `install.sh`, and reloads your shell.

## Usage outside of Codespaces

To use these dotfiles on a local machine or non-Codespace environment:

1. **Clone** your fork:

   ```sh
   git clone git@github.com:<your-username>/dotfiles.git
   cd dotfiles
   ```

2. **Run the installer:**

   ```sh
   ./install.sh
   ```

   This symlinks Claude Code config into `~/.claude/` and adds a source line to `~/.bashrc` and/or `~/.zshrc` (whichever exist).

3. **Reload your shell** (or open a new terminal) to pick up the aliases.
