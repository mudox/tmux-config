#!/usr/bin/env zsh

set -euo pipefail

tmux bind-key - switch-client -T mudox

typeset -A sessions=(
  d Dotfiles
  h Hammerspoon
  n Neovim
  t Tmux
)

for key name in "${(@kv)sessions}"; do
  tmux bind-key -Tmudox "$key" run-shell "${MDX_TMUX_DIR}/scripts/switch-session.zsh ${name}"
done

# WTF
tmux bind-key -Tmudox g display-popup -E -w90% -h90% git-repos-status-dashboard
