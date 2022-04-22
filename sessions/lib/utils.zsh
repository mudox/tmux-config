#  vim: fdm=marker fmr=〈,〉

set -eo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

tput civis
tmux set-option -g @mdx-display-pane-tip false
trap 'tput cnorm; tmux set -g @mdx-display-pane-tip true' EXIT

# session: Declare (prepare) a new session 〈
#
# Usage: session "{session_name}"
#
# Adds variables:
# - session_name
session() {
  session_name="${1:?need a session name as 1st argument}"

  # kill old session if any
  if tmux has-session -t ${session_name} &>/dev/null; then
    jack warn "session [${session_name}] already exists, kill it!"
    tmux kill-session -t "${session_name}"
  fi
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
#   local env=(NAME=VALUE NAME=VALUE ...)
#   window
# }
# ```
#
# Depends on variables:
# - session_name
#
# Update variables:
# - window # window id
# - pane # pane id
window() {
  : ${session_name:?}
  : ${window_name:?}
  : ${pane_title:?}
  : ${dir:?}
  : ${cmd:=zsh}
  : ${env:=()}

  local set_env=()
  for e in $env; do
    set_env=(-e "$e" $set_env)
  done

  local s w p format
  print -v format "#{session_id}\t#{window_id}\t#{pane_id}"

  if ! tmux has-session -t "${session_name}"; then
    jack info "Create session [${session_name}]"

    tmux new-session       \
      -s "${session_name}" \
      -n "${window_name}"  \
      -c "${dir}"          \
      ${set_env}           \
      -d                   \
      -PF "${format}"      \
      --                   \
      "${cmd}" | read s w p

  else
    tmux new-window              \
      -a                         \
      -t "${session_name}:{end}" \
      -n "${window_name}"        \
      -c "${dir}"                \
      ${set_env}                 \
      -PF "${format}"            \
      --                         \
      "${cmd}" | read s w p
  fi

  window="$s:$w"
  pane="${window}.$p"

  set_pane_label_suffix "${pane}" "${pane_title}"

  jack verbose "Create window [${window_name}]"
  jack verbose "  + Pane [$pane_title]"
}

# 〉

# pane: Creates a new pane by splitting a pane or window. 〈
#
# Usage:
# ```zsh
# () {
# local pane_title=...
# local hv=... # 'h'(default) or 'v'
# local dir=...
# local cmd=...
# local env=(NAME=VALUE NAME=VALUE ...)
# pane
# }
# ```
#
# Depends on variables:
# - pane # last created pane id
#
# Update variables:
# - pane # newly created pane id
pane() {
  : ${pane_title:?}
  : ${hv:=h}
  : ${dir:?}
  : ${cmd:=zsh}
  : ${env:=()}

  jack verbose "  + Pane [$pane_title]"

  local set_env=()
  for e in $env; do
    set_env=(-e "$e" $set_env)
  done

  local pane_id=$(tmux split-window \
    -t "${pane}"                    \
    -"${hv}"                        \
    -c "${dir}"                     \
    ${set_env}                      \
    -PF '#D'                        \
		-d                              \
    --                              \
    "${cmd}")

  pane="${window}.${pane_id}"

  set_pane_label_suffix "${pane}" "${pane_title}"
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
