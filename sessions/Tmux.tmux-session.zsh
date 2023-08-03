#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${MDX_TMUX_DIR}"

session "Tmux"

main_editor_window

# Window: 'Help' 〈
() {
local window_name='Help'
local pane_title='  Help'
local dir="$root_dir"
local cmd='MANPAGER="MDX_NVIM_MODE=man nvim +Man!" man tmux'
window
}
# 〉

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
