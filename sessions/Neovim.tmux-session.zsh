#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${HOME}/.config/nvim"

session "Neovim"

main_editor_window

finish

#  vim: fdm=marker fmr=\ 〈,\ 〉
