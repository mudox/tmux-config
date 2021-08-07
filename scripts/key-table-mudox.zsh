#!/usr/bin/env zsh

set -euo pipefail

tmux bind-key - switch-client -T mudox

typeset -A sessions=(
  d Dotfiles:1
  h Hammerspoon:1
  n Neovim:1
  t Tmux:1
)

for key name in "${(@kv)sessions}"; do
  tmux bind-key -Tmudox "$key" switch-client -t ${name}
done
