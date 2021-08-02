nap() {
  sleep 0.2
}

# Usage: setup <session_name>
#
# It defines env `$session_name` which can be used by other functions.
#
# Output envs:
# - session_name

setup() { # {{{1
  session_name="$1"

  set -euo pipefail

  # for reporting progress
  source ~/.dotfiles/scripts/lib/jack.zsh

  # hide cursor
  tput civis
  trap 'tput cnorm' EXIT

  # kill old session if any
  if tmux has-session -t ${session_name} &>/dev/null; then
    echo "session [${session_name}] already exists, kill it!"
    tmux kill-session -t "${session_name}"
  fi
} # }}}

# Usage: new_session <window_name> <path> [keys]
#
# It creates a new session with its initial window.
#
# Input envs:
# - session_name
#
# Output envs:
# - window # tmux full identifier of the create window, e.g. `GuruLibs:Config`.

new_session() { # {{{1
  local window_name="$1"
  local root="$2"

  window="${session_name}:${window_name}"

  jackProgress "Creating window [$1] ..."

  tmux new-session \
    -s "${session_name}" \
    -n "${window_name}" \
    -c "${root}" \
    -d

  if [[ $# > 2 ]]; then
    tmux send-keys -t "${window}" "$3"
  fi

  nap
} # }}}

x_new_session() { # {{{1
  local window_name="$1"
  local root="$2"

  window="${session_name}:${window_name}"

  jackProgress "Creating window [$1] ..."

  tmux new-session \
    -s "${session_name}" \
    -n "${window_name}" \
    -c "${root}" \
    -d \
    -- \
    "${3-zsh}"
} # }}}

# Usage: new_window <name> <path> [keys]
#
# Create a new window appending it to the `$session_name`
#
# Input envs:
# - session_name
#
# Output envs:
# - window # tmux absolute identifier of the create window, e.g. `GuruLibs:Config`.

new_window() { # {{{1
  local window_name=$1
  local root=$2

  window="${session_name}:${window_name}"

  jackProgress "Creating window [${window_name}] ..."

  tmux new-window \
    -a \
    -t "${session_name}:{end}" \
    -n "${window_name}" \
    -c "${root}" \
    -d

  if [[ $# > 2 ]]; then
    tmux send-keys -t "${window}" "$3"
  fi

  nap
} # }}}

x_new_window() { # {{{1
  local window_name=$1
  local root=$2

  window="${session_name}:${window_name}"

  jackProgress "Creating window [${window_name}] ..."

  tmux new-window \
    -a \
    -t "${session_name}:{end}" \
    -n "${window_name}" \
    -c "${root}" \
    -d \
    -- \
    "${3-zsh}"
} # }}}

# Usage: clean_up
#
# Input envs:
# - session_name

clean_up() { # {{{1
  jackEndProgress

  tmux select-window -t "${session_name}:1.1"

  echo "[${session_name}]"
  tmux list-window -t "${session_name}" -F ' - #W'
} # }}}

# Usage: title_pane {pane} {title}
title_pane() {
  tmux select-pane -t "$window.$1" -T "$2"
}

hide_title() {
  tmux set -w -t "$window" pane-border-status off
}

# Usage: gitui_window {repo_dir}
gitui_window() {
  x_new_window Git "$1" gitui
  title_pane 1 GitUI
}

# vim: ft=sh fdm=marker
