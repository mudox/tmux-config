#!/usr/bin/env zsh
set -euo pipefail

session=${1%:*}

if ! tmux has-session -t "${session}"; then
  bin="${MDX_TMUX_DIR}/sessions/${session}.tmux-session.zsh"
  if [[ -f ${bin} ]]; then
    "${bin}" >/dev/null 2>&1 && tmux switch-client -t "$1"
  fi
else
  tmux switch-client -t "$1"
fi
