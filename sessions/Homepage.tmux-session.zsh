#!/usr/bin/env bash
set -euo pipefail

source ~/.dotfiles/scripts/lib/jack.zsh

tput civis
trap 'tput cnorm' EXIT

# client size
set +u
if [[ -n "$TMUX" ]]; then
  client_width="$(tmux list-clients -t '.' -F '#{client_width}')"
  client_height="$(tmux list-clients -t '.' -F '#{client_height}')"
else
  client_height=$(tput lines)
  client_width=$(tput cols)
fi
set -u

session_name='Homepage'
if tmux has-session -t ${session_name} &>/dev/null; then
  echo "session [${session_name}] already exisits, kill it!"
  tmux kill-session -t "${session_name}"
fi

#
# window: Edit
#
jackProgress 'Creating window [Edit] ...'

root="${HOME}/Sites/home/"
window_name='Edit'
window="${session_name}:${window_name}"
tmux new-session \
  -s "${session_name}" \
  -n "${window_name}" \
  -x "$client_width" \
  -y "$client_height" \
  -c "${root}" \
  -d
sleep 0.1
tmux send-keys -t "${window}" "
v web -c 'FZF!'
"

#
# window: Server
#
jackProgress 'Creating window [Server] ...'

root="${HOME}/Sites/home/"
window_name='Server'
window="${session_name}:${window_name}"
tmux new-window \
  -a \
  -t "${session_name}:{end}" \
  -n "${window_name}" \
  -c "${root}" \
  -d
sleep 0.1
tmux send-keys -t "${window}" "
hs
"

#
# window: Shell
#
jackProgress 'Creating window [Shell] ...'

root="${HOME}/Sites/home"
window_name='Shell'
window="${session_name}:${window_name}"
tmux new-window \
  -a \
  -t "${session_name}:{end}" \
  -n "${window_name}" \
  -c "${root}" \
  -d
sleep 0.1

jackEndProgress
tmux select-window -t "${session_name}:1.1"
echo "[${session_name}]"
tmux list-window -t "${session_name}" -F ' - #W'
