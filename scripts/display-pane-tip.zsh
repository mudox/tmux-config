#!/usr/bin/env zsh

set -euo pipefail

count=$(tmux display-message -p '#{window_panes}')

if [[ $count -gt 1 ]]; then
  zoomed=$(tmux display-message -p '#{window_zoomed_flag}')

  if [[ $zoomed -ne 1 ]]; then 
    tmux display-panes
  fi
fi
