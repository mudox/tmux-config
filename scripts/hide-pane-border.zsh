#!/usr/bin/env zsh

panes_count() {
  tmux list-panes | wc -l
}

if [[ $(panes_count) -eq 1 ]]; then
  tmux set-option -w pane-border-status off
fi
