#!/usr/bin/env zsh

if ! tmux has-session -t "$1"; then
  bin="${MDX_TMUX_DIR}/sessions/$1.tmux-session.zsh"
  if [[ -f $bin ]]; then
    "$bin" >/dev/null 2>&1 && tmux switch-client -t "$1"
  fi
else
  tmux switch-client -t "$1:1"
fi
