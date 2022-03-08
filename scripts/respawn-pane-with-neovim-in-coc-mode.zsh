#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

tmux clear-history
set_pane_label_suffix current '  Mode: CoC'
tmux respawn-pane -k 'MDX_NVIM_MODE=coc nvim'
