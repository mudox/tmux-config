#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup Tmux

root_dir="${MDX_TMUX_DIR}"

new_session Main "${root_dir}" nvim
title_pane 1 Neovim

tmux split-window \
  -h \
  -t "${window}.1" \
  -c "${root_dir}/sessions"
title_pane 2 Sessions

clean_up
