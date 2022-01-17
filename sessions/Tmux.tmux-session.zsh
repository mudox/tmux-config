#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${MDX_TMUX_DIR}"

session "Tmux"

# Window: "Main" 〈
() {
local window_name='Main'
local pane_title=' Edit'
local dir="$root_dir"
local cmd='nvim tmux.conf'
window
}
# 〉

# Window: 'Help' 〈
() {
local window_name='Help'
local pane_title='  Help'
local dir="$root_dir"
local cmd='man tmux'
window
}
# 〉

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
