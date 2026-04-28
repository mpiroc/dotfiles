---
name: gh CLI should use DOTFILES_PAT in Codespaces
description: In the dotfiles repo Codespace, invoke gh with GH_TOKEN=$DOTFILES_PAT so it has pull_requests:write; the injected Codespaces GITHUB_TOKEN lacks the scope.
type: feedback
originSessionId: 965ee9e3-6730-4678-aec6-363bf933ff44
---
When running `gh` commands (especially `gh pr create`, `gh pr merge`, anything needing write scopes) against `mpiroc/dotfiles` from a Codespace, prefix with `GH_TOKEN="$DOTFILES_PAT"`.

**Why:** The Codespaces-injected `GITHUB_TOKEN` that `gh` picks up by default is scoped down and returns "Resource not accessible by integration" on PR creation. The git credential helper registered by `install.sh` fixes HTTPS git ops (push/pull) but does not affect the `gh` CLI, which reads its own token. `DOTFILES_PAT` is the PAT the user set up specifically so this repo's write operations work end-to-end.

**How to apply:** Any time `gh` needs write access in this repo's Codespace, pass `GH_TOKEN="$DOTFILES_PAT"` inline. Don't fall back to "ask the user to open the URL" without trying the PAT first.
