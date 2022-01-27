#!/usr/bin/env zsh
set -euo pipefail

set -x
session_name=$(tmux display-message -p '#{session_name}')
width=${#session_name}
text="—— ${session_name} ——"

style=$(tmux show-options -g -v status-left)
color="${style[17,23]}"

tmux display-popup \
  -E \
  -e "text=${text}" \
  -w $(( width + 2 + 4 * 2)) \
  -h 5 \
  -s "fg=black bg=${color} bold" \
  -S "fg=${color} bg=${color}" \
  'stty -echo; tput civis; tput cup 1 1; echo ${text}; sleep 0.3'
