#!/usr/bin/env zsh
set -euo pipefail

tmux clear-history
tmux respawn-pane -k "$1"

"${MDX_TMUX_DIR}/scripts/update-pane-border-format.zsh"
