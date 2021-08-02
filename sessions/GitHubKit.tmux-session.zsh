#!/usr/bin/env bash

# setup {{{1
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

session_name='GitHubKit'
if tmux has-session -t ${session_name} &>/dev/null; then
  echo "session [${session_name}] already exisits, kill it!"
  tmux kill-session -t "${session_name}"
fi
# }}}

# window: Editor {{{1
jackProgress 'Creating window [Editor] ...'

root="${HOME}/Develop/Apple/Frameworks/GitHubKit"
window_name='Editor'
window="${session_name}:${window_name}"
mkdir -p "${root}" &>/dev/null
tmux new-session \
  -s "${session_name}" \
  -n "${window_name}" \
  -x "$client_width" \
  -y "$client_height" \
  -c "${root}" \
  -d
sleep 0.2
tmux send-keys -t "${window}" "
nvim -O ${session_name}.podspec Demo/Podfile
:tabnew   fastlane/Fastfile
:tabnew   .travis.yml
:tabnew   .gitignore
:tabnew   .tmux-session.sh
:tabnew   .codecov.yml
:vnew     .codeclimate.yml
:tabnew   README.md
:tabnew   CHANGELOG.md
"
# }}}

# window: Log {{{1
jackProgress 'Creating window [Log] ...'

root="${HOME}/Develop/Apple/Frameworks/GitHubKit"
window_name='Log'
window="${session_name}:${window_name}"
tmux new-window \
  -a \
  -t "${session_name}:{end}" \
  -n "${window_name}" \
  -c "${root}" \
  -d
sleep 0.2
# }}}

# window: Shell {{{1
jackProgress 'Creating window [Shell] ...'

root="${HOME}/Develop/Apple/Frameworks/GitHubKit"
window_name='Shell'
window="${session_name}:${window_name}"
tmux new-window \
  -a \
  -t "${session_name}:{end}" \
  -n "${window_name}" \
  -c "${root}" \
  -d
# }}}

# clean up {{{1
jackEndProgress
tmux select-window -t "${session_name}:1.1"
echo "[${session_name}]"
tmux list-window -t "${session_name}" -F ' - #W'
# vim: fdm=marker
