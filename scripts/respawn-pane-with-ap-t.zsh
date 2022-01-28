#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

set_pane_label_suffix current '  Respawn'
tmux respawn-pane -k 'ap -t'
