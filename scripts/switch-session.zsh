#!/usr/bin/env zsh
set -euo pipefail

# remove trailing `:window.pane` part
session=${1%:*}

# TODO: $1 supports path instead

if ! tmux has-session -t "=${session}" &>/dev/null; then
  session_file="${MDX_TMUX_DIR}/sessions/${session}.tmux-session.zsh"
  if [[ -f ${session_file} ]]; then
    zsh "${session_file}" &>/dev/null
    tmux switch-client -t "$1"
    tmux set-option -t "${session}" '@mdx-session-file' "${session_file}"
  else
    echo "session file ${session_file} not found"
  fi
else
  tmux switch-client -t "$1"
fi
