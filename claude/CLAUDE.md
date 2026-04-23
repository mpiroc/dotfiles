# User

- **Name:** Matthew Pirocchi
- **Email:** matthew.pirocchi@pixee.ai
- **GitHub:** mpiroc
- **DevRev:** DEVU-80 (DON: `don:identity:dvrv-us-1:devo/6OglRV4a:devu/80`)
- **Notion:** `1f9d872b-594c-81cc-8948-0002e98318dd`

# Git configuration

If the global git user email is not set or does not match `matthew.pirocchi@pixee.ai`, configure it:

```sh
git config --global user.email "matthew.pirocchi@pixee.ai"
git config --global user.name "Matthew Pirocchi"
```

# GitHub authentication for `mpiroc/dotfiles`

The default Codespaces `GITHUB_TOKEN` is scoped to the repo that spawned the Codespace and cannot write to `mpiroc/dotfiles`. When invoking `gh` against `mpiroc/dotfiles` specifically — creating PRs or issues, `gh api repos/mpiroc/dotfiles/...`, etc. — override the token per-command with `DOTFILES_PAT`:

```sh
GH_TOKEN="$DOTFILES_PAT" gh pr create ...
GH_TOKEN="$DOTFILES_PAT" gh api repos/mpiroc/dotfiles/...
```

Only apply this override for `mpiroc/dotfiles`. Every other repo must continue to use the default token — do not `export DOTFILES_PAT`, scope the variable to the single `gh` invocation. Plain `git` operations against `mpiroc/dotfiles` are already routed to the PAT by a scoped credential helper, so this rule applies specifically to `gh`.
