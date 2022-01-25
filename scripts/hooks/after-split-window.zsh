#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

# give the new pane a default title
"${scripts_dir}"/title-panes.zsh

# reveal pane border after splitting window
tmux set-option -w pane-border-status top
