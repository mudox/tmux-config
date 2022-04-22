#!/usr/bin/env zsh

source ${MDX_TMUX_DIR}/sessions/lib/utils.zsh

root_dir="${HOME}/.config/nvim"

session "Neovim"

# Window `Main` 〈
() {
local window_name="Main"
local pane_title="  Mode: Default"
local dir="${root_dir}"
local cmd='nvim init.lua'
window

# # right pane
# local pane_title='  Mode: LSP'
# local cmd='MDX_NVIM_MODE=lsp nvim init.lua'
# pane
}
# 〉

#  〉

finish

#  vim: fdm=marker fmr=\ 〈,\ 〉
