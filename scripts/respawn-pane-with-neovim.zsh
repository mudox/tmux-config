#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

tmux clear-history
set_pane_label_suffix current '  Edit'
tmux respawn-pane -k 'nvim'
