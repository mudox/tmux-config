#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup Dotfiles

root_dir="${HOME}/.dotfiles"

x_new_session Main "${root_dir}" nvim
title_pane 1 Neovim

x_new_window Tmux "${root_dir}/tmux" nvim
title_pane 1 Neovim

x_new_window Karabiner "${root_dir}/karabiner" nvim
title_pane 1 Neovim

# gitui_window "${root_dir}"

clean_up
