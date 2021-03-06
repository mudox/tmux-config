#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

zoomed=$(tmux display-message -p '#{window_zoomed_flag}')

if (( zoomed )); then
	tmux set-option -w status off
  tmux set-option -w pane-border-status off
else
	tmux set-option -w status on
	"${scripts_dir}/update-pane-border-status.zsh"
fi
