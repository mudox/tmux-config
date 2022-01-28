#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

themes=( "${themes_dir}"/* )
set -x
dice=$(( RANDOM % $#themes_dir + 1 ))
theme="${themes[$dice]}"

tmux source-file "${theme}"
