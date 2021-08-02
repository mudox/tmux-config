#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/OneDrive/Apple/HuiLong"

setup 'HuiLong' "${root}"

new_session 'Config' "${root}/" "
nvim -p Podfile.rb Podfile.lock project.yml Gems.rb
"

new_window 'Edit' "${root}"

new_window 'L10n' "${root}"

clean_up
