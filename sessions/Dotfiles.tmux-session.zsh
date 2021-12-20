#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${HOME}/.dotfiles"

session "Dotfiles"

# Window: Main 〈
() {
window_name="Main"
pane_title="Edit"
dir="${root_dir}"
cmd="nvim zsh/zshrc.zsh"
window
}
#  〉

# Window: Karabiner 〈
() {
window_name="Karabiner"
pane_title="Edit"
dir="${root_dir}/karabiner"
cmd="nvim"
window
}
#  〉

# Window: Actions 〈
() {
window_name="Actions"
pane_title="Edit"
dir="${root_dir}/ap"
cmd="nvim"
window
}
#  〉

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
