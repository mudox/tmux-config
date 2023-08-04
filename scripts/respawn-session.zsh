#!/usr/bin/env zsh
set -euo pipefail

session_name="$(tmux display-message -p '#{session_name}')"
session_file="${MDX_TMUX_DIR}/sessions/${session_name}.tmux-session.zsh"
if [[ ! -x $session_file ]]; then
  echo "Invalid session file '${session_file}', invalid path or not executable?"
else
  "${session_file}"
fi
