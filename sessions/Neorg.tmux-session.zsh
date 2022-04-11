#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${HOME}/OneDrive/Neorg/home"

session "Neorg"

# Window: "Main" 〈
() {
local window_name='Main'
local pane_title='  Edit'
local dir="$root_dir"
local cmd='MDX_NVIM_MODE=neorg nvim inbox.norg'
window
}
# 〉

# Window: "Journal" 〈
() {
local window_name='Journal'
local pane_title='  Journal'
local dir="${root_dir}"
local cmd='MDX_NVIM_MODE=neorg nvim -O $(\ls journal/*.norg | sort -r | head -n5)'
window
}
# 〉

finish

#  vim: ft=tmux-session.zsh fdm=marker fmr=\ 〈,\ 〉
