#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

TABLE_NAME='customize'
TABLE_PREFIX='.'
source "${MDX_TMUX_DIR}/scripts/lib/key-table.zsh"


# Apply random theme
bind . run-shell "${scripts_dir}/apply-random-theme.zsh"
