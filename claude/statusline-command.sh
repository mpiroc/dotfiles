#!/bin/bash
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // "."')
model=$(echo "$input" | jq -r '.model.display_name // ""')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

user="${GITHUB_USER:-$(whoami)}"

branch=""
if [ "$(git -C "$cwd" config --get devcontainers-theme.hide-status 2>/dev/null)" != 1 ] && \
   [ "$(git -C "$cwd" config --get codespaces-theme.hide-status 2>/dev/null)" != 1 ]; then
    branch="$(git --no-optional-locks -C "$cwd" symbolic-ref --short HEAD 2>/dev/null || \
               git --no-optional-locks -C "$cwd" rev-parse --short HEAD 2>/dev/null)"
fi

printf "\033[0;32m%s\033[0m " "$user"
printf "\033[1;34m%s\033[0m" "$cwd"

if [ -n "$branch" ]; then
    dirty=""
    if git --no-optional-locks -C "$cwd" ls-files --error-unmatch -m --directory --no-empty-directory -o --exclude-standard ":/*" > /dev/null 2>&1; then
        dirty=" \033[1;33m✗\033[0m"
    fi
    printf " \033[0;36m(\033[1;31m%s%b\033[0;36m)\033[0m" "$branch" "$dirty"
fi

if [ -n "$model" ]; then
    printf " \033[0;35m[%s]\033[0m" "$model"
fi

if [ -n "$remaining" ]; then
    printf " \033[0;33mctx:%s%%\033[0m" "$(printf '%.0f' "$remaining")"
fi
