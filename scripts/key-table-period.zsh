#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

table='period'
tmux bind-key . switch-client -T "${table}"

bind() {
  tmux bind-key -T "${table}" "$@"
}

# Apply random theme
tmux bind-key -T "${table}" . run-shell "${scripts_dir}/apply-random-theme.zsh"
