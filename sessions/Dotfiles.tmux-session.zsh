#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

set -x

root_dir="${HOME}/.dotfiles"

session "Dotfiles"

main_editor_window

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
