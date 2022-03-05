#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${HOME}/.dotfiles"

session "Dotfiles"

# Window: Main 〈
() {
local window_name="Main"
local pane_title="  Edit"
local dir="${root_dir}"
local cmd="nvim zsh/zshrc.zsh"
window
}
#  〉

# # Window: Karabiner 〈
# () {
# local window_name="Karabiner"
# local pane_title=' Edit'
# local dir="${root_dir}/karabiner"
# local cmd="nvim"
# window
# }
# #  〉

# Window: Actions 〈
() {
local window_name="Actions"
local pane_title='  Edit'
local dir="${root_dir}/ap"
local cmd="nvim"
window
}
#  〉

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
