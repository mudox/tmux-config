#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/OneDrive/Apple/ShuGuang"

setup 'ShuGuang' "${root}"

new_session 'Editor' "${root}/" "
vv
"

new_window 'Test' "${root}"

clean_up
