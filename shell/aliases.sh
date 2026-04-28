# pdot - [P]ush [Dot]files
# pushd into the Codespace's dotfiles checkout.
alias pdot='pushd /workspaces/.codespaces/.persistedshare/dotfiles'

# ucs - [U]pdate [C]ode[S]pace
# Each machine stays on its own branch (codespace/<CODESPACE_NAME> in
# Codespaces, machine/<hostname> elsewhere) so memory edits from different
# machines don't fight on a shared branch. ucs fetches origin/main, rebases
# the per-machine branch on top, auto-seeds any project memory dirs that
# aren't in the repo yet, force-with-lease pushes, then re-runs install.sh
# and reloads the shell.
#
# Failures:
# - Refuses to run with uncommitted changes (commit or stash first).
# - On rebase conflicts, leaves the user in the dotfiles dir mid-rebase so
#   they can resolve, run `git rebase --continue`, and re-run `ucs`.
unalias ucs 2>/dev/null
# Detect any project memory dirs at ~/.claude/projects/<slug>/memory/ that
# are still real directories on this machine (not yet symlinked into the
# repo) and seed them: mv the content into claude/memory/<slug>/, replace
# the live path with a symlink, and commit on the per-machine branch in a
# single commit covering all slugs seeded in this run. install.sh's
# existing memory loop will then manage them like any other tracked slug.
_ucs_seed_new_slugs() {
  local seeded_count=0
  local seeded_list=""
  local proj_dir slug live_memory
  for proj_dir in "$HOME/.claude/projects/"*/; do
    [ -d "$proj_dir" ] || continue
    slug=$(basename "$proj_dir")
    live_memory="${proj_dir}memory"
    [ -L "$live_memory" ] && continue
    [ -d "$live_memory" ] || continue
    [ -z "$(ls -A "$live_memory" 2>/dev/null)" ] && continue
    [ -e "claude/memory/$slug" ] && continue

    echo "ucs: seeding new slug into the repo: $slug"
    if ! mv "$live_memory" "claude/memory/$slug"; then
      echo "ucs: mv failed for $slug; aborting seed step" >&2
      return 1
    fi
    if ! ln -sfn "$PWD/claude/memory/$slug" "$live_memory"; then
      echo "ucs: failed to create symlink for $slug; moving content back" >&2
      mv "claude/memory/$slug" "$live_memory" || true
      return 1
    fi
    git add "claude/memory/$slug" || return 1
    seeded_count=$((seeded_count + 1))
    seeded_list="${seeded_list}- ${slug}
"
  done

  if [ "$seeded_count" -gt 0 ]; then
    git commit -m "Auto-seed memory slugs detected by ucs

${seeded_list}" || return 1
  fi
}
_ucs_run() {
  local branch=$1
  if ! git diff-index --quiet HEAD --; then
    echo "ucs: uncommitted changes in $PWD; commit or stash first" >&2
    return 1
  fi
  git fetch origin main || return 1
  if git show-ref --verify --quiet "refs/heads/$branch"; then
    git checkout "$branch" || return 1
  else
    # Bootstrap from local 'main' (or fall back to origin/main if absent) so
    # any local-only commits sitting on main — typically memory updates that
    # were committed before this machine's first ucs run — are carried into
    # the per-machine branch instead of being stranded. The subsequent
    # `git rebase origin/main` integrates anything new from other machines.
    local base
    if git show-ref --verify --quiet "refs/heads/main"; then
      base=main
    else
      base=origin/main
    fi
    echo "ucs: creating per-machine branch $branch from $base"
    git checkout -b "$branch" "$base" || return 1
  fi
  if ! git rebase origin/main; then
    echo "ucs: rebase conflicts. Resolve in $PWD, then 'git rebase --continue' and re-run ucs." >&2
    return 2
  fi
  _ucs_seed_new_slugs || return 1
  # Try to populate refs/remotes/origin/$branch so --force-with-lease has a
  # known expected value. Ignore failure: branch may not exist remotely yet.
  git fetch origin "$branch" 2>/dev/null || true
  if git rev-parse --verify --quiet "refs/remotes/origin/$branch" >/dev/null; then
    git push --force-with-lease origin "$branch" || return 1
  else
    git push -u origin "$branch" || return 1
  fi
  ./install.sh
}
ucs() {
  local dotfiles_dir=/workspaces/.codespaces/.persistedshare/dotfiles
  local orig_pwd=$PWD branch rc
  if [ -n "${CODESPACE_NAME:-}" ]; then
    branch="codespace/$CODESPACE_NAME"
  else
    branch="machine/$(uname -n)"
  fi
  cd "$dotfiles_dir" || return 1
  _ucs_run "$branch"
  rc=$?
  # rc=2 means rebase conflict — stay in dotfiles dir so the user can resolve.
  if [ $rc -ne 2 ]; then
    cd "$orig_pwd"
  fi
  if [ $rc -eq 0 ]; then
    . ~/.bashrc
  fi
  return $rc
}

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
