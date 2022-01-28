#!/usr/bin/env zsh
set -euo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

session_name=$(get_session_name)
text=" ${session_name} "

style=$(tmux show-options -g -v status-left)
color="${style[17,23]}"

art=$(figlet -w 1000 -f "${resources_dir}/ANSI Shadow" "${text}")

height=$(echo "${art}" | wc -l)
width=$(echo "${art}" | "${scripts_dir}/art-width.py")

cmd="stty -echo; tput civis; tput cup 2 0; echo \"${art}\"; zsh -c 'read -qt ${1:-0.3}'; true"

tmux display-popup \
	-E \
  -e "art=${art}" \
	-w $(( width + 2 )) \
	-h $(( height + 5 )) \
  -s "fg=black bg=${color}" \
  -S "fg=${color} bg=${color}" \
	"${cmd}"
