# pdot - [P]ush [Dot]files
# pushd into the Codespace's dotfiles checkout.
alias pdot='pushd /workspaces/.codespaces/.persistedshare/dotfiles'

# ucs - [U]pdate [C]ode[S]pace
# Pulls the latest dotfiles repo and re-runs install.sh to update the
# Codespace with the latest configuration, then reloads the shell.
alias ucs='pushd /workspaces/.codespaces/.persistedshare/dotfiles/ && git pull && ./install.sh && popd && source ~/.bashrc'

# ucc - [U]pdate [C]laude [C]ode
# Intended to be run at the start of a work day. Pulls the latest changes,
# installs local dependencies (if applicable), and updates Claude Code to
# the latest version globally. Detects the package manager from lockfiles
# (pnpm-lock.yaml or package-lock.json), defaulting to pnpm with npm fallback.
unalias ucc 2>/dev/null
_detect_package_manager() {
  if [ -f pnpm-lock.yaml ]; then
    pnpm setup >&2
    echo pnpm
  elif [ -f package-lock.json ]; then
    echo npm
  elif command -v pnpm >/dev/null 2>&1; then
    pnpm setup >&2
    echo pnpm
  else
    echo npm
  fi
}
ucc() {
  # Pull latest changes, non-fatal (e.g. may fail if offline)
  git pull || true
  local pm
  pm=$(_detect_package_manager)
  # Local install: only when package.json exists, non-fatal
  if [ -f package.json ]; then
    "$pm" i || true
  fi
  # Global install
  "$pm" i -g @anthropic-ai/claude-code && node "$("$pm" root -g)/@anthropic-ai/claude-code/install.cjs"
}
