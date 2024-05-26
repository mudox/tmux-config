#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

tmux clear-history
tmux respawn-pane -k 'ap -t'
