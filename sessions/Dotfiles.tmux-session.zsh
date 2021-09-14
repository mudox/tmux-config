#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup Dotfiles

root_dir="${HOME}/.dotfiles"

new_session Main "${root_dir}" nvim
title_pane 1 Neovim

new_window Karabiner "${root_dir}/karabiner" nvim
title_pane 1 Neovim

new_window Actions "${root_dir}/ap" nvim
title_pane 1 Neovim

clean_up
