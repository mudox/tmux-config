#!/usr/bin/env zsh
set -euo pipefail

panes_count=$(tmux display-message -p '#{window_panes}')

if (( panes_count == 1 )); then
  tmux set-option -w pane-border-status off
else
  tmux set-option -w pane-border-status top
fi
