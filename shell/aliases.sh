# ucs - [U]pdate [C]ode[S]pace
alias ucs='pushd /workspaces/.codespaces/.persistedshare/dotfiles/ && git pull && ./install.sh && popd && source ~/.bashrc'

# ucc - [U]pdate [C]laude [C]ode
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
