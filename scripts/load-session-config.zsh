#!/usr/bin/env zsh
set -euo pipefail

session_name=$(tmux display-message -p '#{session_name}')
config_dir="${MDX_TMUX_DIR}/scripts/session-configs"
config="${config_dir}/${session_name}.zsh"
if [[ -f "$config" ]]; then
  tmux run-shell "$config"
else
  tmux run-shell "${config_dir}/Default.zsh"
fi
