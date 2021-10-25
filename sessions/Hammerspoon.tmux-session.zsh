#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root_dir="${HOME}/Git/hs-config"

setup Hammerspoon

new_session Main "${root_dir}" 'nvim init.lua'

clean_up
