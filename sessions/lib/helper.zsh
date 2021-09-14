# Usage: setup session_name
#
# Defines envs:
# - session_name

setup() { # {{{1
  session_name="$1"

  set -euo pipefail

  # hide cursor
  tput civis
  trap 'tput cnorm' EXIT

  # kill old session if any
  if tmux has-session -t ${session_name} &>/dev/null; then
    jack warn "session [${session_name}] already exists, kill it!"
    tmux kill-session -t "${session_name}"
  fi
} # }}}

# Usage: new_session window_name path [command]
#
# It creates a new session with its initial window.
#
# Depends on envs:
# - session_name
#
# Defines envs:
# - window # tmux full identifier of the create window, e.g. `GuruLibs:Config`.

new_session() { # {{{1
  local window_name="$1"
  local root_dir="$2"
  
  local cmd="${3:-zsh}"
  # set +u
  # if [[ -n $3 ]]; then
    # cmd="sleep 0.1; $3"
  # else
    # cmd='zsh'
  # fi
  # set -u

  window="${session_name}:${window_name}"

  jack info "Create session [${session_name}]"
  jack verbose "Create window [$1]"

  tmux new-session       \
    -s "${session_name}" \
    -n "${window_name}"  \
    -c "${root_dir}"     \
    -d                   \
    --                   \
    "$cmd"
} # }}}

# Usage: new_window window_name path [command];
#
# Create a new window and append it to the session
#
# Depends on envs:
# - session_name
#
# Set envs:
# - window # tmux absolute identifier of the create window, e.g. `GuruLibs:Config`.

new_window() { # {{{1
  local window_name=$1
  local root_dir=$2

  window="${session_name}:${window_name}"

  jack verbose "Create window [${window_name}]"

  tmux new-window \
    -a \
    -t "${session_name}:{end}" \
    -n "${window_name}" \
    -c "${root_dir}" \
    -d \
    -- \
    "${3-zsh}"
} # }}}

# Usage: clean_up
#
# Depends on envs:
# - session_name

clean_up() { # {{{1
  tmux select-window -t "${session_name}:1.1"
} # }}}

# Usage: title_pane {pane} {title}
title_pane() {
  tmux select-pane -t "$window.$1" -T "$2"
}

hide_title() {
  tmux set -w -t "$window" pane-border-status off
}

# vim: ft=sh fdm=marker
