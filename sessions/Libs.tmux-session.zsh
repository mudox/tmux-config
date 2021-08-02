#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

setup 'Libs'

root="${HOME}/OneDrive/Libs"

new_session 'Inbox' "${root}"

libs="
SwiftKit
AppleKit
"

for lib in $libs; do
  new_window "${lib}" "${root}/${lib}"
done

clean_up
