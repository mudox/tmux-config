#  vim: fdm=marker fmr=〈,〉

# declare: Declare (prepare) a new session 〈
#
# Usage: session "{session_name}"
#
# Adds variables:
# - session_name
session() {
  set -eo pipefail

  session_name="${1:?need a session name as 1st argument}"

  # hide cursor
  tput civis
  trap 'tput cnorm' EXIT

  # kill old session if any
  if tmux has-session -t ${session_name} &>/dev/null; then
    jack warn "session [${session_name}] already exists, kill it!"
    tmux kill-session -t "${session_name}"
  fi

  session_created=false
  pane_count=0
} 
# 〉

# window: Creates a new session/window. 〈
#
# Create the session if not existed, otherwise create new window.
#
# Usage:
# ```zsh
# () {
#   local window_name=...
#   local pane_title=...
#   local dir=...
#   local cmd=...
#   window
# }
# ```
#
# Depends on variables:
# - session_name (created by `session`)
#
# Update variables:
# - window # tmux full identifier of the created window, e.g. `Session:Window`.
# - pane_count # pane count already created
window() {
  s=${session_name:?}
  w=${window_name:?}
  t=${pane_title:-$w}
  p=${dir:?}
  c=${cmd:-zsh}

  window="$s:$w"
  pane="$window.1"

  if [[ $session_created != true ]]; then
    jack info "Create session [$s]"

    tmux new-session \
      -s "$s" \
      -n "$w" \
      -c "$p" \
      -d \
      -- \
      "$c"
    title-pane 1 "$t"

    session_created=true
  else
    jack verbose "Create window [$w]"

    tmux new-window \
      -a \
      -t "$s:{end}" \
      -n "$w" \
      -c "$p" \
      -d \
      -- \
      "$c"
  fi

  pane_count=1

  jack verbose "Create window [$w]"
  jack verbose "  + Pane [$t]"
}
# 〉

# pane: Creates a new pane by splitting a pane. 〈
#
# Usage:
# ```zsh
# () {
# local pane_title=...
# local hv=... # 'h'(default) or 'v'
# local dir=...
# local cmd=...
# pane
# }
# ```
#
# Depends on variables:
# - pane_index (by `window` or `pane`)
#
# Change variables:
# - pane_index # tmux full identifier of the created pane, e.g. `Session:Window:1`.
pane() {
  s="${window:?}.${pane_count:?}"
  t=${pane_title:?}
  p=${dir:?}
  c=${cmd:-zsh}

  jack verbose "  + Pane [$t]"

  tmux split-window \
    -t "$s" \
    -"${hv:-h}" \
    -d \
    -c "$p" \
    "$c"
  ((pane_count++))
  tmux select-pane -t "${window}.${pane_count}" -T "$t"
}
# 〉

# title-pane: Setup a pane. 〈
#
# Usage:
# ```
# title-pane {pane_index} {title}
# ```
#
# Depends on variables:
# - window
title-pane() {
  index=${1:?need pane index as 1st argument}
  title=${2:?need pane title as 2nd argument}
  tmux select-pane -t "$window.$index" -T "$title"
}
# 〉

# finish: Finalize session creation. 〈
#
# Usage: done
#
# Depends on variables:
# - session_name
finish() {
  tmux select-window -t "${session_name:?}:1.1"
} 
# 〉

hide_title() {
  tmux set -w -t "$window" pane-border-status off
}
