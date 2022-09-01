#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/Develop/Apple/JiYi"

setup 'JiYi' "${root}"

new_session 'Main' "${root}/" nvim

clean_up
