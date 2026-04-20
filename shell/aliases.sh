# ucs - [U]pdate [C]ode[S]pace
# Pulls the latest dotfiles repo and re-runs install.sh to update the
# Codespace with the latest configuration, then reloads the shell.
alias ucs='pushd /workspaces/.codespaces/.persistedshare/dotfiles/ && git pull && ./install.sh && popd && source ~/.bashrc'

# ucc - [U]pdate [C]laude [C]ode
# Intended to be run at the start of a work day. Pulls the latest changes,
# installs local dependencies (if applicable), and updates Claude Code to
# the latest version globally. Falls back to npm if pnpm is unavailable.
ucc() {
  git pull || return 1
  # Local install: only when package.json exists, non-fatal
  if [ -f package.json ]; then
    pnpm i || true
  fi
  # Global install: prefer pnpm, fall back to npm
  if command -v pnpm >/dev/null 2>&1 && [ -f pnpm-lock.yaml ] && pnpm i -g @anthropic-ai/claude-code; then
    node "$(pnpm root -g)/@anthropic-ai/claude-code/install.cjs"
  else
    npm i -g @anthropic-ai/claude-code && node "$(npm root -g)/@anthropic-ai/claude-code/install.cjs"
  fi
}
