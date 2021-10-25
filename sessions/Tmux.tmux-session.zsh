#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup Tmux

root_dir="${MDX_TMUX_DIR}"

new_session Main "${root_dir}" 'nvim tmux.conf'
title_pane 1 Neovim

new_window Help "${root_dir}" 'MDX_NVIM_MODE=help man tmux'

clean_up
