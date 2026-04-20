alias ucs='pushd /workspaces/.codespaces/.persistedshare/dotfiles/ && git pull && ./install.sh && popd && source ~/.bashrc'
alias ucc='git pull && pnpm i && pnpm i -g @anthropic-ai/claude-code && node "$(pnpm root -g)/@anthropic-ai/claude-code/install.cjs"'
