#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

for id in $(tmux list-panes -F '#D'); do
	set-title "${id}"
done
