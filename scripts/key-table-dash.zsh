#!/usr/bin/env zsh
set -euo pipefail

mid='dash'
tmux bind-key - switch-client -T "$mid"

bind() {
  tmux bind-key -T "$mid" "$@"
}

typeset -A sessions=(
  d Dotfiles
  h Hammerspoon
  n Neovim
  t Tmux
)

for key name in "${(@kv)sessions}"; do
  bind "$key" run-shell "${MDX_TMUX_DIR}/scripts/switch-session.zsh ${name}"
done

# WTF
bind g display-popup -E -w90% -h90% git-repos-status-dashboard

# Ap
bind a display-popup -w60% -h80% ap

# Htop
bind x display-popup -E -w70% -h80% 'htop --user dash'
