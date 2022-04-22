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

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
