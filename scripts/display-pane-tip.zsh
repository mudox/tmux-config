#!/usr/bin/env zsh

set -uo pipefail

show=$(tmux show-options -gv '@mdx-display-pane-tip')
: "${show:=true}"

if [[ $show != true ]]; then
	return
fi

count=$(tmux display-message -p '#{window_panes}')

if [[ $count -gt 1 ]]; then
  zoomed=$(tmux display-message -p '#{window_zoomed_flag}')

  if [[ $zoomed -ne 1 ]]; then 
    tmux display-panes -d 2000
  fi
fi
