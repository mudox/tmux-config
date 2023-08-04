#  vim: fdm=marker fmr=〈,〉

set -eo pipefail

source "${MDX_TMUX_DIR}/scripts/lib/utils.zsh"

tput civis
trap 'tput cnorm' EXIT

# session 〈
# Declare (prepare) a new session
#
# Usage: session "{session_name}"
#
# Adds variables:
# - session_name

session() {
    session_name="${1:?need a session name as 1st argument}"
    if tmux has-session -t "${session_name}" &>/dev/null; then
        tmux kill-session -t "${session_name}"
    fi
}

# 〉

# window 〈
# Creates a new session/window
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

    # LATER: remove it?
    local set_env=()
    for e in $env; do
        set_env=(-e "$e" $set_env)
    done

    local s w p format
    print -v format "#{session_id}\t#{window_id}\t#{pane_id}"

    # if ! tmux has-session -t "=${session_name}" &>/dev/null; then
    if [[ -z $session_id ]]; then
        tmux new-session                                     \
            -s "${session_name}"                             \
            -n "${window_name}"                              \
            -x $(tmux display-message -p '#{client_width}')  \
            -y $(tmux display-message -p '#{client_height}') \
            -c "${dir}"                                      \
            ${set_env}                                       \
            -d                                               \
            -PF "${format}"                                  \
            --                                               \
            "${cmd}"                                         \
            | read session_id window_id pane_id
    else
        tmux new-window                                      \
            -a                                               \
            -t "${session_id}:{end}"                         \
            -n "${window_name}"                              \
            -c "${dir}"                                      \
            ${set_env}                                       \
            -PF "${format}"                                  \
            --                                               \
            "${cmd}"                                         \
            | read session_id window_id pane_id
    fi

    set_pane_label_suffix "${pane_id}" "${pane_title}"
}

# 〉

# main_editor_window 〈
# Main window running `nvim`

main_editor_window() {
    local window_name='Main'
    local pane_title='  Edit'
    local dir="${root_dir:?}"
    local cmd='nvim'
    window
}

# 〉

# main_shell_window 〈
# Main window running `zsh`

main_shell_window() {
    local window_name='Main'
    local pane_title='  Shell'
    local dir="${root_dir:?}"
    local cmd='zsh'
    window
}

# 〉

# pane 〈
# Creates a new pane by splitting a pane or window
#
# Usage:
# ```zsh
# () {
# local pane_title=...
# local hv=... # 'h'(default) or 'v'
# local size=... # 120, 30% ...
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
    : ${size:=50%}
    : ${dir:?}
    : ${cmd:=zsh}
    : ${env:=()}

    local set_env=()
    for e in $env; do
        set_env=(-e "$e" $set_env)
    done

    tmux split-window         \
        -t "${pane_id}"       \
        -"${hv}" -l "${size}" \
        -c "${dir}"           \
        "${set_env}"          \
        -PF '#{pane_id}'      \
        -d                    \
        --                    \
        "${cmd}"              \
        | read pane_id

    pane="${window}.${pane_id}"

    set_pane_label_suffix "${pane_id}" "${pane_title}"
}

# 〉

# finish 〈
# Finalize session creation
#
# Usage: done
#
# Depends on variables:
# - session_id

finish() {
    tmux select-window -t "${session_id}:1.1"
}
# 〉
