#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${HOME}"

session "Default"

main_shell_window

# Window: 'Help' 〈
() {
local window_name='Monitor'
local pane_title='󰦉  BTop'
local dir="$root_dir"
local cmd='btop'
window
}
# 〉

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
