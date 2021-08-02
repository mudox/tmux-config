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

session_name='Update'
if tmux has-session -t ${session_name} &>/dev/null; then
  jackWarn "session [${session_name}] already exisits, kill it!"
  tmux kill-session -t "${session_name}"
fi

#
# window: Neovim
#
#jackProgress 'Creating window [Neovim] ...'

#root="${HOME}/Git/vim-config"
#window_name='Neovim'
#window="${session_name}:${window_name}"
#tmux new-session       \
#-s "${session_name}" \
#-n "${window_name}"  \
#-x "$client_width"   \
#-y "$client_height"  \
#-c "${root}"         \
#-d
#sleep 0.5
#tmux send-keys -t "${window}" "
#v all
#"

#
# window: Homebrew
#
jackProgress 'Creating window [Homebrew] ...'

root="${HOME}"
window_name='Homebrew'
window="${session_name}:${window_name}"
tmux new-window -a -d \
  -t "${session_name}:{end}" \
  -n "${window_name}" \
  -c "${root}"
sleep 0.5
tmux send-keys -t "${window}" "
bubu
"

#
# window: Python
#
jackProgress 'Creating window [Python] ...'

root="${HOME}"
window_name='Python'
window="${session_name}:${window_name}"
tmux new-window -a -d \
  -t "${session_name}:{end}" \
  -n "${window_name}" \
  -c "${root}"
sleep 0.5
tmux send-keys -t "${window}.1" "
pip3 list --outdated
"

#
# window: Ruby
#
jackProgress 'Creating window [Ruby] ...'

root="${HOME}"
window_name='Ruby'
window="${session_name}:${window_name}"
tmux new-window -a -d \
  -t "${session_name}:{end}" \
  -n "${window_name}" \
  -c "${root}"
sleep 0.5
tmux send-keys -t "${window}" "
gem outdated
"

jackEndProgress
tmux select-window -t "${session_name}:1.1"
echo "[${session_name}]"
tmux list-window -t "${session_name}" -F ' - #W'
