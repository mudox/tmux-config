#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/OneDrive/Apple/Lisa"

setup 'Lisa' "${root}"

new_session 'Config' "${root}/" "
nvim -p Podfile Podfile.lock
"

new_window 'Edit' "${root}"

clean_up
