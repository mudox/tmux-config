#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

table='dash'
tmux bind-key - switch-client -T "${table}"

bind() {
  tmux bind-key -T "${table}" "$@"
}

# Display session tip
bind q run-shell "${scripts_dir}/display-session-tip.zsh 3"

# Goto common sessions
typeset -A sessions=(
  d Dotfiles
  h Hammerspoon
  v Neovim
  t Tmux
	e Neorg:1
	j Neorg:Journal
	X Default:Btop
)

for key session in "${(@kv)sessions}"; do
  bind "$key" run-shell "${scripts_dir}/switch-session.zsh ${session}"
done

# WTF
bind g display-popup -E -w90% -h90% git-repos-status-dashboard

# Ap
bind a display-popup -E -w60% -h80% ap

# Htop
bind x display-popup -E -w70% -h80% 'htop --user mudox'

# Kabmat
bind b display-popup -E -w70% -h80% '~/Git/kabmat/kabmat'
