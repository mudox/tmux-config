#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup Tmux

root_dir="${MDX_TMUX_DIR}"

x_new_session Main "${root_dir}" nvim
title_pane 1 Neovim

clean_up
