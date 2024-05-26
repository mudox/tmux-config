#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${HOME}/Documents/Obsidian/Mudox"

session "Note"

# Window: "Main" 〈
() {
local window_name='Main'
local pane_title='  Edit'
local dir="$root_dir"
local cmd='nvim'
window
}
# 〉

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
