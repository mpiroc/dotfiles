# dotfiles

Shared developer environment configuration, including [Claude Code](https://docs.anthropic.com/en/docs/claude-code) settings, shell aliases, and custom agents.

## What's included

- **`claude/`** -- Claude Code configuration (settings, agents, statusline, `CLAUDE.md`)
- **`shell/aliases.sh`** -- Shell aliases and functions (works in both bash and zsh)
- **`install.sh`** -- Symlinks config into `~/.claude/` and sources aliases from your shell profile

### Aliases

#### `ucs` -- [U]pdate [C]ode[S]pace

Pulls the latest dotfiles repo and re-runs `install.sh` to update the Codespace with the latest configuration, then reloads the shell.

```sh
ucs
```

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
