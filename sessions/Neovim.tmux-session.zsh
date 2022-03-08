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

# NOTE: currently commented out
# Window `Coc` 〈
# () {
# local window_name="Coc"
# local pane_title="  Mode: Coc"
# local dir="${root_dir}"
# local cmd='MDX_NVIM_MODE=coc nvim init.lua' 
# window
# }
# 〉

# Window `Log` 〈
() {
local tail=(tail -n 100 -F)

# pane 'Neovim'
local window_name=Log
local pane_title='  Neovim'
local dir="${HOME}/.cache/nvim"
local cmd="$tail -f log"
window

# pane 'LSP'
local pane_title='  LSP'
local cmd="$tail -f lsp.log"
pane

# pane 'LSP Installer'
local pane_title='  LSP Installer'
local cmd="$tail -f lsp-installer.log"
pane

# pane 'Packer'
local pane_title='  Packer'
local cmd="$tail -f packer.nvim.log"
pane

tmux select-layout -t "$window" -E
}
#  〉

# Window `Pad` 〈
() {
local window_name="LuaPad"
local pane_title="  LuaPad"
local dir="${HOME}/Develop/Lua"
local cmd="MDX_NVIM_MODE=lsp nvim luapad.lua -c 'lua require(\"luapad\").attach()'"
window
}
#  〉

#  〉

finish

#  vim: fdm=marker fmr=\ 〈,\ 〉
