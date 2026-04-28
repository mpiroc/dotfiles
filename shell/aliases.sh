# pdot - [P]ush [Dot]files
# pushd into the Codespace's dotfiles checkout.
alias pdot='pushd /workspaces/.codespaces/.persistedshare/dotfiles'

# ucs - [U]pdate [C]ode[S]pace
# Each machine stays on its own branch (codespace/<CODESPACE_NAME> in
# Codespaces, machine/<hostname> elsewhere) so memory edits from different
# machines don't fight on a shared branch. ucs fetches origin/main, rebases
# the per-machine branch on top, syncs local project memory dirs into the
# repo (seeding new slugs and merging local content into already-tracked
# slugs), force-with-lease pushes, then re-runs install.sh and reloads the
# shell.
#
# Failures:
# - Refuses to run with uncommitted changes (commit or stash first).
# - On rebase conflicts, leaves the user in the dotfiles dir mid-rebase so
#   they can resolve, run `git rebase --continue`, and re-run `ucs`.
unalias ucs 2>/dev/null
# Sync each ~/.claude/projects/<slug>/ into the repo. Two cases dispatch
# off slug state:
#
#   * SEED — live memory/ is a non-empty real dir AND the slug is not yet
#     tracked in claude/memory/. mv the content into the repo and replace
#     the live path with a symlink.
#   * MERGE — local content exists for a slug that's already tracked.
#     Source is either the live memory/ dir (if real and non-empty) or
#     memory.backup/ (recovery case after an earlier install.sh moved an
#     unmerged real dir aside). Per-file rules:
#       - MEMORY.md: union-merge unique lines (matches the existing
#         merge=union .gitattributes rule used during git rebase).
#       - Other file present only in source: copy into the repo.
#       - Other file present in both with matching content: no-op.
#       - Other file present in both with different content: skip and
#         print a "conflict for <slug>/<f>" warning; user resolves later.
#     cp is used (not mv) so the source dir keeps a snapshot — for the
#     live-dir case, install.sh later moves it aside as memory.backup/.
#
# All seed/merge results are staged and a single commit covers the run.
_ucs_sync_local_memories() {
  local seeded_count=0 merged_count=0
  local seeded_list="" merged_list=""
  local proj_dir slug live_memory backup_memory repo_memory
  local src_dir mode any_change sf bn target tmp
  for proj_dir in "$HOME/.claude/projects/"*/; do
    [ -d "$proj_dir" ] || continue
    slug=$(basename "$proj_dir")
    live_memory="${proj_dir}memory"
    backup_memory="${proj_dir}memory.backup"
    repo_memory="claude/memory/$slug"

    src_dir=""
    mode=""
    if [ -L "$live_memory" ]; then
      # Already-managed slug. Recovery case if memory.backup has content.
      if [ -d "$backup_memory" ] && [ ! -L "$backup_memory" ] \
         && [ -n "$(ls -A "$backup_memory" 2>/dev/null)" ]; then
        if [ -e "$repo_memory" ]; then
          src_dir="$backup_memory"
          mode=merge
        else
          echo "ucs: $slug has memory symlink + backup but slug missing from repo; skipping" >&2
          continue
        fi
      else
        continue
      fi
    elif [ -d "$live_memory" ]; then
      if [ -z "$(ls -A "$live_memory" 2>/dev/null)" ]; then
        continue
      elif [ -e "$repo_memory" ]; then
        src_dir="$live_memory"
        mode=merge
      else
        mode=seed
      fi
    else
      continue
    fi

    if [ "$mode" = seed ]; then
      echo "ucs: seeding new slug into the repo: $slug"
      if ! mv "$live_memory" "$repo_memory"; then
        echo "ucs: mv failed for $slug; aborting" >&2
        return 1
      fi
      if ! ln -sfn "$PWD/$repo_memory" "$live_memory"; then
        echo "ucs: failed to create symlink for $slug; moving content back" >&2
        mv "$repo_memory" "$live_memory" || true
        return 1
      fi
      git add "$repo_memory" || return 1
      seeded_count=$((seeded_count + 1))
      seeded_list="${seeded_list}- ${slug}
"
      continue
    fi

    # mode = merge
    any_change=0
    for sf in "$src_dir"/*; do
      [ -e "$sf" ] || continue
      bn=$(basename "$sf")
      target="$repo_memory/$bn"
      if [ "$bn" = "MEMORY.md" ]; then
        if [ -f "$target" ]; then
          if ! cmp -s "$target" "$sf"; then
            tmp=$(mktemp) || return 1
            cat "$target" "$sf" | awk '!seen[$0]++' > "$tmp"
            if ! cmp -s "$target" "$tmp"; then
              mv "$tmp" "$target" || { rm -f "$tmp"; return 1; }
              git add "$target" || return 1
              any_change=1
            else
              rm -f "$tmp"
            fi
          fi
        else
          cp "$sf" "$target" || return 1
          git add "$target" || return 1
          any_change=1
        fi
      else
        if [ ! -e "$target" ]; then
          cp "$sf" "$target" || return 1
          git add "$target" || return 1
          any_change=1
        elif ! cmp -s "$target" "$sf"; then
          echo "ucs: conflict for $slug/$bn — repo and local differ; left both as-is" >&2
        fi
      fi
    done

    if [ "$any_change" -eq 1 ]; then
      echo "ucs: merged local content into repo slug: $slug"
      merged_count=$((merged_count + 1))
      merged_list="${merged_list}- ${slug}
"
    fi
  done

  if [ $((seeded_count + merged_count)) -eq 0 ]; then
    return 0
  fi

  local msg
  msg="ucs: sync local memory dirs"
  if [ "$seeded_count" -gt 0 ]; then
    msg="${msg}

Seeded:
${seeded_list}"
  fi
  if [ "$merged_count" -gt 0 ]; then
    msg="${msg}

Merged into existing slugs:
${merged_list}"
  fi
  git commit -m "$msg" || return 1
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
  _ucs_sync_local_memories || return 1
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
