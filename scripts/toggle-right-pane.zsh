#!/usr/bin/env zsh

(tmux break-pane -s '.2' -d || tmux join-pane -s ':{next}' -h -d || tmux split-window -h) >/dev/null 2>&1
