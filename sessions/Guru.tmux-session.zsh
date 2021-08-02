#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/helper.zsh

root="${HOME}/GeLongHui/GuruClub"

setup 'Guru' "${root}"

new_session 'Main' "${root}" "
nvim -p Podfile.rb Podfile.lock project.yml
"

new_window 'Editor' "${root}" "
vv
"

new_window 'ProxyMan' "${HOME}/Onedrive/Charles" "
vv
"

new_window 'L10n' "${root}/guruclub-l10n/Localizable/" "
v zh-Hans.lproj/Localizable.strings
"

clean_up
