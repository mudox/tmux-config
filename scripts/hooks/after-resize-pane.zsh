#!/usr/bin/env zsh
set -euo pipefail

zoomed=$(tmux display-message -p '#{window_zoomed_flag}')
if (( zoomed )); then
	kitty @ --to "${KITTY_LISTEN_ON}" set-font-size 22
else
	kitty @ --to "${KITTY_LISTEN_ON}" set-font-size 0
fi
