#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup Default

root="${HOME}"

new_session Main "${root}"

clean_up
